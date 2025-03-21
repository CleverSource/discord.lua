local RequestHandler = require("rest/RequestHandler")
local Routes = require("rest/Routes")
local GatewayHandler = require("gateway/GatewayHandler")

local ExtendedUser = require("structures/ExtendedUser")

local PROMISE_SUCCESS = "Resolved"
local PROMISE_FAIL = "Rejected"

local Client = {}

function Client.new(options)
    local self = setmetatable({}, {
        __index = Client
    })
    
    local restOptions = options.restOptions or {
        preferSnakeCase = options.preferSnakeCase or false
    }

    self.token = "Bot " .. options.token

    self.request = RequestHandler.new(self.token, restOptions)
    self.gateway = GatewayHandler.new({
        token = options.token,
        events = {
            message = function(shard, packet)
                print(shard)
                print(packet)
            end
        },
        connectionOptions = self:getBotGateway(),
        preferSnakeCase = options.preferSnakeCase or false
    })

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
    local res = self.request:createRequest("GET", Routes.gateway())
    return processPromise(res)
end

function Client:getBotGateway()
    local res = self.request:createRequest("GET", Routes.gatewayBot(), true)
    return processPromise(res)
end

function Client:getSelf()
    local res = processPromise(self.request:createRequest("GET", Routes.user("@me"), true))
    return ExtendedUser.new(res)
end

function Client:editSelf(options)
    local res = processPromise(self.request:createRequest("PATCH", Routes.user("@me"), true, options))
    return ExtendedUser.new(res)
end

function Client:connect()
    self.gateway:spawnShards()
end

return Client