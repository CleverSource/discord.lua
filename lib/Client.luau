local RestClient = require("rest/RestClient")
type RestClient = RestClient.RestClient
local GatewayHandler = require("gateway/GatewayHandler")
type GatewayHandler = GatewayHandler.GatewayHandler
local Constants = require("Constants")
local Shard = require("gateway/Shard")
type Shard = Shard.Shard

local getApplicationIdFromToken = require("util/getApplicationIdFromToken")

local Logger = require("log/Logger")
type Logger = Logger.Logger

local GatewayTypes = require("types/internal/gateway")

local Client = {}
Client.__index = Client

Client.Constants = Constants

export type ClientOptions = {
    token: string?,
    applicationId: string?,
    debug: boolean?,
    compression: boolean?,
    preferSnakeCase: boolean?,
    intents: { number | Constants.Intents }?,
    restOptions: RestClient.RestClientOptions?,
    gatewayOptions: GatewayHandler.GatewayHandlerOptions?
}

export type Client = typeof(setmetatable({} :: {
    token: string,
    logger: Logger,
    gateway: GatewayHandler,
    rest: RestClient,
    constants: typeof(Constants)
}, Client))

function Client.new(options: ClientOptions): Client
    local self = setmetatable({}, Client) :: Client

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
        options.intents = intents
    end

    local intentsBit = options.intents or Constants.Intents.AllNonPrivileged
    
    -- Converting snake_case to camelCase is inexpensive for REST API responses
    local restOptions = options.restOptions or {
        token = options.token,
        preferSnakeCase = preferSnakeCase or false,
        logger = logger
    }

    if options.token and not options.applicationId then
        restOptions.applicationId = getApplicationIdFromToken(options.token)
    else
        restOptions.applicationId = options.applicationId
    end

    -- Converting snake_case to camelCase is expensive for constant gateway events, 
    -- so we should prefer snake_case for gateway events
    local gatewayOptions = options.gatewayOptions or {
        token = options.token,
        events = {
            message = function(shard: Shard, packet: GatewayTypes.Payload<any>)
                if not packet.t then
                    return
                end

                self:handleDispatch(packet.t, shard, packet)
            end
        },
        preferSnakeCase = preferSnakeCase or true,
        logger = logger,
        intents = intentsBit,
        compress = options.compression or false
    }

    self.logger = logger
    self.gateway = GatewayHandler.new(gatewayOptions)
    self.rest = RestClient.new(restOptions)

    return self
end

function Client.handleDispatch(self: Client, event: string, shard: Shard, packet: GatewayTypes.Payload<any>)
    -- print(packet)
end

function Client.connect(self: Client)
    if self.gateway.defaultConnection then
        self.gateway:updateConnectionOptions(self.rest:getBotGateway())
    end

    self.gateway:spawnShards()
    self.logger:print("[Bot] Connected successfully")
end

return Client