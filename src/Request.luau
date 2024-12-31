-- Lune
local Net = require("@lune/net")
local DateTime = require("@lune/datetime")
local Task = require("@lune/task")

-- Promise
local PromiseType = require("@vendor/Promise/types/Promise")
local Promise = require("@vendor/Promise/lib") :: PromiseType.Promise
type Promise = PromiseType.AnyPromise

-- FormData
local FormData = require("FormData")

-- Types
local LatencyRef = require("types/LatencyRef")
type LatencyRef = LatencyRef.LatencyRef

local OrderedBucket = require("OrderedBucket")
type OrderedBucket = OrderedBucket.OrderedBucket

export type RequestOptions = {
    disableLatencyCompensation: boolean?,
    latencyThreshold: number?,
    ratelimiterOffset: number?,
    requestTimeout: number?
}

export type FileContent = {
    file: buffer | string,
    name: string
}

-- Constants
local HEADER_AUDIT_LOG_REASON = "x-audit-log-reason"

local HEADER_RATELIMIT_LIMIT = "x-ratelimit-limit"
local HEADER_RATELIMIT_REMAINING = "x-ratelimit-remaining"
local HEADER_RATELIMIT_RESET = "x-ratelimit-reset"
local HEADER_RATELIMIT_RESET_AFTER = "x-ratelimit-reset-after"
local HEADER_RATELIMIT_SCOPE = "x-ratelimit-scope"
local HEADER_RATELIMIT_GLOBAL = "x-ratelimit-global"

local HEADER_RETRY_AFTER = "retry-after"

local HTTP_TOO_MANY_REQUESTS = 429
local HTTP_MULTIPLE_CHOICES = 300

local API_VERSION = 10
local BASE_URL = `https://discord.com/api/v{API_VERSION}`

-- Request
local Request = {}

export type Request = {
    globalBlock: boolean,
    latencyRef: LatencyRef,
    options: RequestOptions,
    ratelimits: { [string]: OrderedBucket },
    readyQueue: { () -> nil },
    userAgent: string,
    authorization: any,

    new: (authorization: string, options: RequestOptions?) -> Request,
    globalUnblock: (self: Request) -> nil,
    request: (self: Request, method: Net.HttpMethod, url: string, auth: boolean?, body: { [string]: any }?, file: FileContent?, _route: string?, short: boolean?) -> Promise,
    getRatelimitBucketIdFromUrl: (self: Request, url: string, method: Net.HttpMethod) -> string
} & typeof(Request)

function Request.new(authorization: any, options: RequestOptions?): Request
    local self = setmetatable({} :: Request, {
        __index = Request
    })

    self.options = {
        disableLatencyCompensation = options and options.disableLatencyCompensation or false,
        latencyThreshold = options and options.latencyThreshold or 30000,
        ratelimiterOffset = options and options.ratelimiterOffset or 0,
        requestTimeout = options and options.requestTimeout or 15000
    }
    self.authorization = authorization
    self.userAgent = "DiscordBot (https://github.com/cleversource/discord.lua, 0.0.1)"
    self.ratelimits = {}
    self.latencyRef = {
        latency = self.options.ratelimiterOffset,
        raw = table.create(10, self.options.ratelimiterOffset),
        timeOffset = 0,
        timeOffsets = table.create(10, 0),
        lastTimeOffsetCheck = 0
    }
    self.globalBlock = false
    self.readyQueue = {}

    return self
end

function Request.globalUnblock(self: Request)
    self.globalBlock = false
    while #self.readyQueue > 0 do
        local callback = table.remove(self.readyQueue, 1)
        if callback then
            callback()
        end
    end
end

function Request.request(self: Request, method: Net.HttpMethod, url: string, auth: boolean?, body: { [string]: any }?, file: FileContent?, _route: string?, short: boolean?): Promise
    local route = _route or self:getRatelimitBucketIdFromUrl(url, method)

    return Promise.new(function(resolve, reject, onCancel)
        local attempts = 0

        local function request(callback)
            local headers = {
                ["user-agent"] = self.userAgent,
                ["accept-encoding"] = "gzip,deflate"
            }
            
            if auth then
                headers.authorization = self.authorization
            end

            if body and body.reason then
                headers[HEADER_AUDIT_LOG_REASON] = Net.urlEncode(body.reason)
                body.reason = nil      
            end

            local bodyObject = ""

            if file then
                local data = FormData.new()
                headers["content-type"] = `multipart/form-data; boundary={data.boundary}`

                if typeof(file[1]) == "table" then
                    for index, fileData in file do
                        if not fileData.file then
                            return
                        end

                        data:attach(`files[{index - 1}]`, fileData.file, fileData.name)
                    end
                elseif file.file then
                    -- TODO: special case for stickers
                    data:attach("files[0]", file.file, file.name)
                else
                    error("Invalid file object")
                end

                if body then
                    body.payload_json.file = nil
                    for key, value in body do
                        data:attach(key, value)
                    end
                end

                data:attach("test", "asd?")

                for _, value in data:finish() do
                    bodyObject ..= buffer.tostring(value)
                end
            else
                headers["content-type"] = "application/json"
                bodyObject = Net.jsonEncode(body)
            end

            local latency = DateTime.now().unixTimestampMillis
            local success, response = pcall(function()
                if method == "GET" or method == "DELETE" then
                    return Net.request({
                        method = method,
                        url = `{BASE_URL}{url}`,
                        headers = headers,
                        query = body
                    })
                else
                    return Net.request({
                        method = method,
                        url = `{BASE_URL}{url}`,
                        headers = headers,
                        body = bodyObject
                    })
                end
            end)
            if not success then
                callback()
                reject(response)
                return
            end

            latency = DateTime.now().unixTimestampMillis - latency
            table.insert(self.latencyRef.raw, latency)
            self.latencyRef.latency = self.latencyRef.latency - math.modf(table.remove(self.latencyRef.raw, 1) :: number / 10) + math.modf(latency / 10) 

            local responseBody = response.body
            if response.headers["content-type"] == "application/json" then
                responseBody = Net.jsonDecode(responseBody)
            end

            -- TODO: temporary, see https://github.com/lune-org/lune/pull/285
            -- local dateNow = DateTime.fromRfcDate(response.headers.date)
            local date, month, year, time =
                response.headers.date:match("(%d%d?) (%a%a%a) (%d%d%d%d) (%d%d:%d%d:%d%d)")
            local months = {
                Jan = 1,
                Feb = 2,
                Mar = 3,
                Apr = 4,
                May = 5,
                Jun = 6,
                Jul = 7,
                Aug = 8,
                Sep = 9,
                Oct = 10,
                Nov = 11,
                Dec = 12
            }
            local dateNow = DateTime.fromUniversalTime({
                year = year,
                month = months[month],
                day = date,
                hour = time:match("(%d%d):%d%d:%d%d"),
                minute = time:match("%d%d:(%d%d):%d%d"),
                second = time:match("%d%d:%d%d:(%d%d)")
            }).unixTimestampMillis

            if self.latencyRef.lastTimeOffsetCheck < DateTime.now().unixTimestampMillis - 5000 then
                self.latencyRef.lastTimeOffsetCheck = DateTime.now().unixTimestampMillis
                local timeOffset = dateNow + 500 - self.latencyRef.lastTimeOffsetCheck
                if (self.latencyRef.timeOffset - self.latencyRef.latency >= self.options.latencyThreshold and timeOffset - self.latencyRef.latency >= self.options.latencyThreshold) then
                    warn(`Your clock is {timeOffset}ms behind Discord's server clock. Please check your connection and system time.`)
                end
                self.latencyRef.timeOffset = self.latencyRef.timeOffset - math.modf(table.remove(self.latencyRef.timeOffsets, 1) :: number / 10) + math.modf(timeOffset / 10)
                table.insert(self.latencyRef.timeOffsets, timeOffset)
            end

            -- TODO: encoding?

            local now = DateTime.now().unixTimestampMillis
            if response.headers[HEADER_RATELIMIT_LIMIT] then
                self.ratelimits[route].limit = tonumber(response.headers[HEADER_RATELIMIT_LIMIT]) :: number
            end

            if method ~= "GET" and (response.headers[HEADER_RATELIMIT_REMAINING] == nil or response.headers[HEADER_RATELIMIT_LIMIT] == nil) and self.ratelimits[route].limit ~= 1 then
                -- TODO: better debug logging
                print(`Missing ratelimit headers for OrderedBucket({self.ratelimits[route].remaining}/{self.ratelimits[route].limit}) with non-default limit`)
            end

            self.ratelimits[route].remaining = response.headers[HEADER_RATELIMIT_REMAINING] == nil and 1 or tonumber(response.headers[HEADER_RATELIMIT_REMAINING]) or 0

            local retryAfter = (tonumber(response.headers[HEADER_RATELIMIT_RESET_AFTER] or response.headers[HEADER_RETRY_AFTER]) :: number) or 0 * 1000
            if retryAfter >= 0 then
                if response.headers[HEADER_RATELIMIT_GLOBAL] then
                    self.globalBlock = true
                    Task.delay(retryAfter / 1000 or 1 / 1000, function() 
                        self:globalUnblock()
                    end)
                else
                    self.ratelimits[route].reset = (retryAfter or 1) + now
                end
            elseif response.headers[HEADER_RATELIMIT_RESET] then
                local resetTime = (tonumber(response.headers[HEADER_RATELIMIT_RESET]) :: number) * 1000
                -- TODO: reactions route is special
                self.ratelimits[route].reset = math.max(resetTime - self.latencyRef.latency, now)
            else
                self.ratelimits[route].reset = now
            end

            if response.statusCode ~= HTTP_TOO_MANY_REQUESTS then
                -- TODO: better debug logging
                local content = if typeof(body) == "table" then body.content else ""
                print(`{content}{now} {route} {response.statusCode}: {latency}ms ({self.latencyRef.latency}ms avg) | {self.ratelimits[route].remaining}/{self.ratelimits[route].limit} left | Reset {self.ratelimits[route].reset} ({self.ratelimits[route].reset - now}ms left)`)
            end

            if response.statusCode >= HTTP_MULTIPLE_CHOICES then
                if response.statusCode == HTTP_TOO_MANY_REQUESTS then
                    local delay = retryAfter
                    if response.headers[HEADER_RATELIMIT_SCOPE] == "shared" then
                        delay = responseBody.retry_after * 1000
                    end
                    -- TODO: better debug logging
                    local content = if typeof(body) == "table" then body.content else ""
                    print(`{response.headers[HEADER_RATELIMIT_GLOBAL] and "Global" or "Unexpected"} 429`)
                    print(responseBody)
                    print(`{content}{now} {route} {response.statusCode}: {latency}ms ({self.latencyRef.latency}ms avg) | {self.ratelimits[route].remaining}/{self.ratelimits[route].limit} left | Reset {self.ratelimits[route].reset} ({self.ratelimits[route].reset - now}ms left) | Scope {response.headers[HEADER_RATELIMIT_SCOPE]}`)
                    
                    if delay then
                        Task.delay(delay / 1000, function() 
                            callback()
                            self:request(method, url, auth, body, file, route, true)
                        end)
                        return
                    else
                        callback()
                        self:request(method, url, auth, body, file, route, true)
                        return
                    end
                elseif response.statusCode == 502 and attempts < 4 then
                    attempts += 1
                    Task.delay((math.random() * 1900 + 100) / 1000, function() 
                        self:request(method, url, auth, body, file, route, true)
                    end)
                    callback()
                    return
                end
                callback()

                -- TODO: better error handling for unexpected status codes here
                local err = response
                if responseBody.code then
                    -- TODO: Handle Discord error responses
                else
                    -- TODO: Handle HTTP errors
                end
                reject(err)

                return
            end

            callback()
            resolve(responseBody)
        end

        if self.globalBlock and auth then
            table.insert(self.readyQueue, function() 
                if not self.ratelimits[route] then
                    self.ratelimits[route] = OrderedBucket.new(1, self.latencyRef)
                end
                self.ratelimits[route]:queue(request, short)
            end)
        else
            if not self.ratelimits[route] then
                self.ratelimits[route] = OrderedBucket.new(1, self.latencyRef)
            end
            self.ratelimits[route]:queue(request, short)
        end
    end)
end

function Request.getRatelimitBucketIdFromUrl(self: Request, url: string, method: Net.HttpMethod): string
    -- TODO
    return method .. " " .. url
end

return Request