local RequestHandler = require("rest/RequestHandler")
local Routes = require("rest/Routes")
local GatewayHandler = require("gateway/GatewayHandler")

local ExtendedUser = require("structures/ExtendedUser")

local PROMISE_SUCCESS = "Resolved"
local PROMISE_FAIL = "Rejected"

local Logger = require("log/Logger")

local Client = {}

function Client.new(options)
    local self = setmetatable({}, {
        __index = Client
    })
    
    self.token = options.token

    local logger = Logger.new(options.debug or false)

    local preferSnakeCase = options.preferSnakeCase or false
    local restOptions = options.restOptions or {
        token = options.token,
        preferSnakeCase = preferSnakeCase,
        logger = logger
    }
    local gatewayOptions = options.gatewayOptions or {
        token = options.token,
        events = {
            message = function(shard, packet)
                -- print(shard)
                -- print(packet)
            end
        },
        preferSnakeCase = preferSnakeCase,
        logger = logger
    }

    self.request = RequestHandler.new(restOptions)
    self.gateway = GatewayHandler.new(gatewayOptions)

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
    if self.gateway.defaultConnection then
        self.gateway:updateConnectionOptions(self:getBotGateway())
    end

    self.gateway:spawnShards()
end

return Client