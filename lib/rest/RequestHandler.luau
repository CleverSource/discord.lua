local net = require("@lune/net")
local datetime = require("@lune/datetime")
local task = require("@lune/task")
local serde = require("@lune/serde")

local Promise = require("../vendor/Promise")
type Promise = Promise.Promise

local imageDataToBase64 = require("../util/imageDataToBase64")
local urlToBase64 = require("../util/urlToBase64")
local camelize = require("../util/snakeCaseToCamel")
local snakize = require("../util/camelCaseToSnake")
local calculateBitwise = require("../util/calculateBitwise")
local FormData = require("FormData")
local snowflakeCreatedAt = require("../util/snowflakeCreatedAt")
local OrderedBucket = require("../ratelimit/OrderedBucket")
type OrderedBucket = OrderedBucket.OrderedBucket
type LatencyRef = OrderedBucket.LatencyRef

local ApiTypes = require("../types/apiTypes")

local Logger = require("../log/Logger")
type Logger = Logger.Logger

local PROMISE_SUCCESS = "Resolved"
local PROMISE_FAIL = "Rejected"

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
local HTTP_BAD_GATEWAY = 502

local STICKERS_ROUTE = "/stickers"
local REACTIONS_ROUTE = "/reactions/:id"

local API_VERSION = 10
local BASE_URL = "https://discord.com/api/v" .. API_VERSION

local RequestHandler = {}
RequestHandler.__index = RequestHandler

export type RequestHandlerOptions = {
    disableLatencyCompensation: boolean?,
    latencyThreshold: number?,
    ratelimiterOffset: number?,
    requestTimeout: number?,
    logger: Logger?,
    preferSnakeCase: boolean?,
    token: string?
}

type FileContent = ApiTypes.FileContent

export type CreateRequestOptions = {
    authenticated: boolean?,
    body: { [string]: any }?,
    headers: { [string]: string }?,
    file: FileContent? | { FileContent }?,
    reason: string?
}

export type RequestHandler = typeof(setmetatable({} :: {
    options: RequestHandlerOptions,
    logger: Logger,
    preferSnakeCase: boolean,
    authorization: string?,
    userAgent: string,
    ratelimits: { [string]: OrderedBucket },
    latencyRef: LatencyRef,
    globalBlock: boolean,
    readyQueue: { () -> () }
}, RequestHandler))

function RequestHandler.new(options: RequestHandlerOptions): RequestHandler
    local self = setmetatable({}, RequestHandler) :: RequestHandler

    options = options or {}

    self.options = {
        disableLatencyCompensation = options.disableLatencyCompensation or false,
        latencyThreshold = options.latencyThreshold or 30000,
        ratelimiterOffset = options.ratelimiterOffset or 0,
        requestTimeout = options.requestTimeout or 15000
    }

    self.logger = options.logger or Logger.new()

    self.preferSnakeCase = options.preferSnakeCase or false
    
    self.authorization = options.token
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

function RequestHandler._processPromise(self: RequestHandler, promise: Promise): any
    local status, result = promise:StatusAwait()
    if status == PROMISE_SUCCESS then
        return result
    elseif status == PROMISE_FAIL then
        self.logger:error(result)
        return
    else
        error("Fatal error: Promise status is neither Resolved nor Rejected")
    end
end

function RequestHandler.globalUnblock(self: RequestHandler)
    self.globalBlock = false
    while #self.readyQueue > 0 do
        local callback = table.remove(self.readyQueue, 1)
        if callback then
            callback()
        end
    end
end

function RequestHandler.get(self: RequestHandler, url: string, options: CreateRequestOptions?): any
    return self:_processPromise(self:makeRequest("GET", url, options and options.authenticated or true, options and options.body, options and options.file, options and options.reason, options and options.headers))
end

function RequestHandler.post(self: RequestHandler, url: string, options: CreateRequestOptions?): any
    return self:_processPromise(self:makeRequest("POST", url, options and options.authenticated or true, options and options.body, options and options.file, options and options.reason, options and options.headers))
end

function RequestHandler.delete(self: RequestHandler, url: string, options: CreateRequestOptions?): any
    return self:_processPromise(self:makeRequest("DELETE", url, options and options.authenticated or true, options and options.body, options and options.file, options and options.reason, options and options.headers))
end

function RequestHandler.patch(self: RequestHandler, url: string, options: CreateRequestOptions?): any
    return self:_processPromise(self:makeRequest("PATCH", url, options and options.authenticated or true, options and options.body, options and options.file, options and options.reason, options and options.headers))
end

function RequestHandler.put(self: RequestHandler, url: string, options: CreateRequestOptions?): any
    return self:_processPromise(self:makeRequest("PUT", url, options and options.authenticated or true, options and options.body, options and options.file, options and options.reason, options and options.headers))
end

function RequestHandler.changeToDiscordFormat(self: RequestHandler, body: any): any?
    if typeof(body) ~= "table" then
        return body
    end

    local newBody = {}

    for key, value in pairs(body) do
        local newKey = key

        if typeof(key) == "string" then
            newKey = snakize(key)
        end

        -- Bitwise permissions
        if newKey == "allow" or newKey == "deny" or newKey == "permissions" or newKey == "defaultMemberPermissions" then
            newBody[newKey] = typeof(value) == "number" and value or calculateBitwise(value :: any) 
        -- Image data encoding in base64
        elseif newKey == "image" or newKey == "icon" or newKey == "avatar" or newKey == "banner" then
            if type(value) == "string" and value:match("^https?://") then
                newBody[newKey] = urlToBase64(value)
            else
                newBody[newKey] = imageDataToBase64(value)
            end
        elseif typeof(value) == "table" then
            if #value > 0 then
                local newArray = {}
                for i, v in ipairs(value) do
                    newArray[i] = self:changeToDiscordFormat(v)
                end
                newBody[newKey] = newArray
            else
                newBody[newKey] = self:changeToDiscordFormat(value)
            end
        else
            newBody[newKey] = value
        end
    end

    return newBody
end

function RequestHandler.makeRequest(self: RequestHandler, method: net.HttpMethod, url: string, auth: boolean?, body: { [string]: any }?, file: FileContent? | { FileContent }?, reason: string?, extraHeaders: { [string]: string }?, _route: string?, short: boolean?): Promise
    local route = _route or self:getRatelimitBucketIdFromUrl(url, method)

    return Promise.new(function(resolve, reject)
        local attempts = 0

        local function request(callback)
            local headers = {
                ["user-agent"] = self.userAgent,
                ["accept-encoding"] = "gzip"
            }
            
            if auth then
                headers.authorization = self.authorization
            end

            if reason then
                headers[HEADER_AUDIT_LOG_REASON] = net.urlEncode(reason)
            end

            if extraHeaders then
                for key, value in extraHeaders do
                    headers[key] = value
                end
            end

            if body then
                body = self:changeToDiscordFormat(body)

                if file then
                    body = {
                        payload_json = body
                    }
                end
            end

            local bodyObject = ""

            if file then
                local data = FormData.new()
                headers["content-type"] = "multipart/form-data; boundary=" .. data.boundary
    
                if typeof(file) == "table" and #file > 0 then
                    for index, fileData in pairs(file) do
                        if not fileData.content then
                            return
                        end

                        data:attach(`files[{index - 1}]`, fileData.content, fileData.name)
                    end
                elseif (file :: FileContent).content then
                    if method == "POST" and url:sub(#url - #STICKERS_ROUTE + 1, #url) == STICKERS_ROUTE then
                        data:attach("file", (file :: FileContent).content, (file :: FileContent).name)
                    else
                        data:attach("files[0]", (file :: FileContent).content, (file :: FileContent).name)
                    end
                else
                    reject("Invalid file object")
                    return
                end

                if body then
                    body.payload_json.file = nil
                    body.payload_json.files = nil
                    for key, value in body do
                        data:attach(key, value)
                    end
                end

                for _, value in data:finish() do
                    bodyObject = bodyObject .. value
                end
            else
                headers["content-type"] = "application/json"
                bodyObject = net.jsonEncode(body)
            end

            local latency = datetime.now().unixTimestampMillis
            local success, response = pcall(function() 
                if method == "GET" or method == "DELETE" then
                    return net.request({
                        method = method,
                        url = `{BASE_URL}{url}`,
                        headers = headers,
                        query = body
                    })
                else
                    return net.request({
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

            latency = datetime.now().unixTimestampMillis - latency
            table.insert(self.latencyRef.raw, latency)
            self.latencyRef.latency = self.latencyRef.latency - math.modf(table.remove(self.latencyRef.raw, 1) :: number / 10) + math.modf(latency / 10) 
        
            local responseBody = response.body

            -- TODO: confirm this even works
            -- I have not been able to get "content-encoding" to appear in headers
            if response.headers["content-encoding"] then
                self.logger:warn("Content encoding detected, decompressing")
                if string.find(response.headers["content-encoding"], "gzip") then
                    responseBody = serde.decompress("gzip", responseBody)
                end
            end

            if response.headers["content-type"] == "application/json" then
                -- convert null to boolean for role tags case (see https://discord.com/developers/docs/topics/permissions#role-object-role-tags-structure)
                -- TODO: check this based on route, for now we do it in all cases
                -- responseBody = responseBody:gsub(
                --     "\"tags\":%b{}",
                --     function(tags_content)
                --         return tags_content:gsub(':null', ':true')
                --     end
                -- )

                responseBody = net.jsonDecode(responseBody)
            end

            -- TODO: temporary, see https://github.com/lune-org/lune/pull/285
            -- local dateNow = datetime.fromRfcDate(response.headers.date)
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
            local dateNow = datetime.fromUniversalTime({
                year = year,
                month = months[month],
                day = date,
                hour = time:match("(%d%d):%d%d:%d%d"),
                minute = time:match("%d%d:(%d%d):%d%d"),
                second = time:match("%d%d:%d%d:(%d%d)")
            }).unixTimestampMillis

            if self.latencyRef.lastTimeOffsetCheck < datetime.now().unixTimestampMillis - 5000 then
                self.latencyRef.lastTimeOffsetCheck = datetime.now().unixTimestampMillis
                local timeOffset = dateNow + 500 - self.latencyRef.lastTimeOffsetCheck
                if self.latencyRef.timeOffset - self.latencyRef.latency >= self.options.latencyThreshold and timeOffset - self.latencyRef.latency >= self.options.latencyThreshold then
                    self.logger:warn(`Your clock is {timeOffset}ms behind Discord's server clock. Please check your connection and system time.`)
                end
                self.latencyRef.timeOffset = self.latencyRef.timeOffset - math.modf(table.remove(self.latencyRef.timeOffsets, 1) :: number / 10) + math.modf(timeOffset / 10)
                table.insert(self.latencyRef.timeOffsets, timeOffset)
            end

            local now = datetime.now().unixTimestampMillis
            if response.headers[HEADER_RATELIMIT_LIMIT] then
                self.ratelimits[route].limit = tonumber(response.headers[HEADER_RATELIMIT_LIMIT]) :: number
            end
            
            if method ~= "GET" and (response.headers[HEADER_RATELIMIT_REMAINING] == nil or response.headers[HEADER_RATELIMIT_LIMIT] == nil) and self.ratelimits[route].limit ~= 1 then
                self.logger:warn(`Missing ratelimit headers for OrderedBucket({self.ratelimits[route].remaining}/{self.ratelimits[route].limit}) with non-default limit`)
            end

            self.ratelimits[route].remaining = response.headers[HEADER_RATELIMIT_REMAINING] == nil and 1 or tonumber(response.headers[HEADER_RATELIMIT_REMAINING]) or 0

            local retryAfter = ((tonumber(response.headers[HEADER_RATELIMIT_RESET_AFTER] or response.headers[HEADER_RETRY_AFTER]) :: number) or 0) * 1000
            if retryAfter >= 0 then
                if response.headers[HEADER_RATELIMIT_GLOBAL] then
                    self.globalBlock = true
                    task.delay(retryAfter / 1000 or 1 / 1000, function() 
                        self:globalUnblock()
                    end)
                else
                    self.ratelimits[route].reset = (retryAfter or 1) + now
                end
            elseif response.headers[HEADER_RATELIMIT_RESET] then
                local resetTime = (tonumber(response.headers[HEADER_RATELIMIT_RESET]) :: number) * 1000
                -- TODO: confirm if this is valid
                if (route:sub(#route - #REACTIONS_ROUTE + 1, #route) == REACTIONS_ROUTE) and (resetTime - dateNow) == 1000 then
                    resetTime = now + 250
                end
                self.ratelimits[route].reset = math.max(resetTime - self.latencyRef.latency, now)
            else
                self.ratelimits[route].reset = now
            end

            if response.statusCode ~= HTTP_TOO_MANY_REQUESTS then
                local content = if typeof(body) == "table" then body.content else ""
                self.logger:debug(`{content or ""}{now} {url} {response.statusCode}: {latency}ms ({self.latencyRef.latency}ms avg) | {self.ratelimits[route].remaining}/{self.ratelimits[route].limit} left | Reset {self.ratelimits[route].reset} ({self.ratelimits[route].reset - now}ms left)`)
            end

            if response.statusCode >= HTTP_MULTIPLE_CHOICES then
                if response.statusCode == HTTP_TOO_MANY_REQUESTS then
                    local delay = retryAfter
                    if response.headers[HEADER_RATELIMIT_SCOPE] == "shared" then
                        delay = responseBody.retry_after * 1000
                    end
                    local content = if typeof(body) == "table" then body.content else ""
                    self.logger:warn(`{response.headers[HEADER_RATELIMIT_GLOBAL] and "Global" or "Unexpected"} 429`)
                    self.logger:warn(responseBody)
                    self.logger:warn(`{content or ""}{now} {route} {response.statusCode}: {latency}ms ({self.latencyRef.latency}ms avg) | {self.ratelimits[route].remaining}/{self.ratelimits[route].limit} left | Reset {self.ratelimits[route].reset} ({self.ratelimits[route].reset - now}ms left) | Scope {response.headers[HEADER_RATELIMIT_SCOPE]}`)
                    
                    if delay then
                        task.delay(delay / 1000, function() 
                            callback()
                            self:makeRequest(method, url, auth, body, file, reason, extraHeaders, route, true):Then(resolve):Catch(reject)
                        end)
                        return
                    else
                        callback()
                        self:makeRequest(method, url, auth, body, file, reason, extraHeaders, route, true):Then(resolve):Catch(reject)
                        return
                    end
                elseif response.statusCode == HTTP_BAD_GATEWAY and attempts < 4 then
                    attempts += 1
                    task.delay((math.random() * 1900 + 100) / 1000, function() 
                        self:makeRequest(method, url, auth, body, file, reason, extraHeaders, route, true):Then(resolve):Catch(reject)
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
            if self.preferSnakeCase then
                resolve(responseBody)
            else
                resolve(camelize(responseBody))
            end
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

function RequestHandler.getRatelimitBucketIdFromUrl(self: RequestHandler, url: string, method: net.HttpMethod): string
    local parts = {}
    for part in url:gmatch("[^/]+") do
        table.insert(parts, part)
    end

    local secondLastPart = parts[#parts - 1]
    
    if secondLastPart == "channels" or secondLastPart == "guilds" then
        return secondLastPart
    end

    if secondLastPart == "reactions" or parts[#parts] == "@me" then
        table.remove(parts, (#parts - 1))
        parts[#parts] = "reactions"
    else
        parts[#parts] = "x"
    end

    if parts[#parts - 2] == "reactions" then
        table.remove(parts, (#parts - 1))
    end

    if method == "DELETE" and secondLastPart == "messages" then
        return "D" .. table.concat(parts, "/")
    end

    return table.concat(parts, "/")
end

return RequestHandler