local Request = require("rest/Request")
local Routes = require("rest/Routes")

local ExtendedUser = require("structures/ExtendedUser")

local PROMISE_SUCCESS = "Resolved"
local PROMISE_FAIL = "Rejected"

local Client = {}

function Client.new(options)
    local self = setmetatable({}, {
        __index = Client
    })

    self.token = options.token
    self.Request = Request.new(self.token, options.restOptions)

    return self
end

local function processPromise(promise)
    local status, result = promise:StatusAwait()
    if status == PROMISE_SUCCESS then
        return result
    elseif status == PROMISE_FAIL then
        error(result)
    else
        error("Fatal error: Promise status is neither Resolved nor Rejected")
    end
end

function Client:getGateway()
    local res = self.Request:request("GET", Routes.gateway())
    return processPromise(res)
end

function Client:getBotGateway()
    local res = self.Request:request("GET", Routes.gatewayBot(), true)
    return processPromise(res)
end

function Client:getSelf()
    local res = processPromise(self.Request:request("GET", Routes.user("@me"), true))
    return ExtendedUser.new(res)
end

function Client:editSelf(options)
    local res = processPromise(self.Request:request("PATCH", Routes.user("@me"), true, options))
    return ExtendedUser.new(res)
end

return Client