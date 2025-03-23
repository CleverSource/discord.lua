local RequestHandler = require("rest/RequestHandler")
local Routes = require("rest/Routes")
local GatewayHandler = require("gateway/GatewayHandler")
local Constants = require("Constants")

local ExtendedUser = require("structures/ExtendedUser")

local Logger = require("log/Logger")

local Client = {}

function Client.new(options)
    local self = setmetatable({}, {
        __index = Client
    })
    
    self.token = options.token

    local logger = Logger.new(options.debug or false)
    local preferSnakeCase = options.preferSnakeCase

    if options.intents then
        local intents = 0
        for _, intent in ipairs(options.intents) do
            if typeof(intent) == "number" then
                intents = bit32.bor(intents, intent)
            elseif typeof(intent) == "string" and Constants.Intents[intent] then
                intents = bit32.bor(intents, Constants.Intents[intent])
            else
                logger:warn("Unknown intent: " .. intent)
            end
        end
        options.intent = intents
    end

    local intentsBit = options.intent or Constants.Intents.allNonPrivileged
    
    -- Converting snake_case to camelCase is inexpensive for REST API responses
    local restOptions = options.restOptions or {
        token = options.token,
        preferSnakeCase = preferSnakeCase or false,
        logger = logger
    }

    -- Converting snake_case to camelCase is expensive for constant gateway events, 
    -- so we should prefer snake_case for gateway events
    local gatewayOptions = options.gatewayOptions or {
        token = options.token,
        events = {
            message = function(shard, packet)
                if not packet.t then
                    return
                end

                self:handleDispatch(packet.t, shard, packet)
            end
        },
        preferSnakeCase = preferSnakeCase or true,
        logger = logger,
        intents = intentsBit
    }

    self.logger = logger
    self.request = RequestHandler.new(restOptions)
    self.gateway = GatewayHandler.new(gatewayOptions)

    return self
end

function Client:handleDispatch(event, shard, packet)
    print(packet)
end

function Client:getGateway()
    return self.request:get(Routes.gateway())    
end

function Client:getBotGateway()
    return self.request:get(Routes.gatewayBot(), {
        authenticated = true
    })
end

function Client:getSelf()
    return ExtendedUser.new(self.request:get(Routes.user("@me"), {
        authenticated = true
    }))
end

function Client:editSelf(options)
    return ExtendedUser.new(self.request:patch(Routes.user("@me"), {
        authenticated = true,
        body = options
    }))
end

function Client:connect()
    if self.gateway.defaultConnection then
        self.gateway:updateConnectionOptions(self:getBotGateway())
    end

    self.gateway:spawnShards()
    self.logger:print("[Bot] Connected successfully")
end

return Client