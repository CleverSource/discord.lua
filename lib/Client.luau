local RestClient = require("rest/RestClient")
type RestClient = RestClient.RestClient
local GatewayHandler = require("gateway/GatewayHandler")
type GatewayHandler = GatewayHandler.GatewayHandler
local Constants = require("Constants")
local Shard = require("gateway/Shard")
type Shard = Shard.Shard
local ApiTypes = require("types/apiTypes")

local datetime = require("@lune/datetime")

local getApplicationIdFromToken = require("util/getApplicationIdFromToken")
local camelize = require("util/snakeCaseToCamel")

local Logger = require("log/Logger")
type Logger = Logger.Logger

export type Event = "ready" 
                    | "webhooksUpdate" 
                    | "channelCreate" 
                    | "channelDelete" 
                    | "channelPinsUpdate"
                    | "channelUpdate"
                    | "stageInstanceCreate" 
                    | "stageInstanceDelete" 
                    | "stageInstanceUpdate"
                    | "threadCreate"
                    | "threadDelete"
                    | "threadListSync"
                    | "threadMembersUpdate"
                    | "threadMemberUpdate"
                    | "threadUpdate"
export type Events = {
    ready: (({
        shardId: number,
        v: number,
        user: ApiTypes.UserObject,
        guilds: { string },
        sessionId: string,
        shard: { number },
        applicationId: string
    }) -> ())?,
    
    webhooksUpdate: (({
        channelId: string,
        guildId: string
    }) -> ())?,

    channelCreate: ((ApiTypes.ChannelObject) -> ())?,
    channelDelete: ((ApiTypes.ChannelObject) -> ())?,
    channelPinsUpdate: (({
        guildId: string,
        channelId: string,
        lastPinTimestamp: datetime.DateTime?
    }) -> ())?,
    channelUpdate: ((ApiTypes.ChannelObject) -> ())?,

    stageInstanceCreate: (({
        id: string,
        guildId: string,
        channelId: string,
        topic: string
    }) -> ())?,
    stageInstanceDelete: (({
        id: string,
        guildId: string,
        channelId: string,
        topic: string
    }) -> ())?,
    stageInstanceUpdate: (({
        id: string,
        guildId: string,
        channelId: string,
        topic: string
    }) -> ())?,

    threadCreate: ((ApiTypes.ChannelObject) -> ())?,
    threadDelete: ((ApiTypes.ChannelObject) -> ())?,
    threadListSync: (({
        guildId: string,
        channelIds: { string }?,
        threads: { ApiTypes.ChannelObject },
        members: { ApiTypes.ThreadMemberObject }
    }) -> ())?,
    threadMembersUpdate: (({
        id: string,
        guildId: string,
        addedMembers: { ApiTypes.ThreadMemberObject },
        removedMemberIds: { string }
    }) -> ())?,
    threadMemberUpdate: (({
        id: string,
        guildId: string,
        joinedAt: datetime.DateTime,
        flags: number
    }) -> ())?,
    threadUpdate: ((ApiTypes.ChannelObject) -> ())?
}

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
    gatewayOptions: GatewayHandler.GatewayHandlerOptions?,
    events: Events?
}

export type Client = typeof(setmetatable({} :: {
    Constants: typeof(Constants),
    
    token: string,
    logger: Logger,
    gateway: GatewayHandler,
    rest: RestClient,
    events: Events,
    id: string?,
    preferSnakeCase: boolean,
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

    self.preferSnakeCase = preferSnakeCase or false

    self.events = options.events or {}

    return self
end

function Client._callEvent(self: Client, event: Event, ...: any)
    if not self.events[event] then
        return
    end

    if self.events[event] then
        if typeof(self.events[event]) == "table" then
            for _, callback in ipairs(self.events[event]) do
                callback(self.preferSnakeCase and ... or camelize(...))
            end
        else
            self.events[event](self.preferSnakeCase and ... or camelize(...))
        end
    end
end

function Client.handleDispatch(self: Client, event: string, shard: Shard, packet: GatewayTypes.Payload<any>)
    if event == "READY" then
        local data = packet.d
        self:_callEvent("ready", {
            shardId = shard.id,
            v = data.v,
            user = data.user,
            guilds = data.guilds,
            sessionId = data.session_id,
            shard = data.shard,
            applicationId = data.application.id
        })

        self.id = data.user.id
        self.rest:setApplicationId(data.application.id)
    end

    if event == "WEBHOOKS_UPDATE" then
        local data = packet.d
        self:_callEvent("webhooksUpdate", {
            channelId = data.channel_id,
            guildId = data.guild_id
        })
    elseif event == "CHANNEL_CREATE" then
        local data = packet.d
        self:_callEvent("channelCreate", data)
    elseif event == "CHANNEL_DELETE" then
        local data = packet.d
        self:_callEvent("channelDelete", data)
    elseif event == "CHANNEL_PINS_UPDATE" then
        local data = packet.d
        self:_callEvent("channelPinsUpdate", {
            guildId = data.guild_id,
            channelId = data.channel_id,
            lastPinTimestamp = data.last_pin_timestamp and datetime.fromIsoDate(data.last_pin_timestamp) or nil
        })
    elseif event == "CHANNEL_UPDATE" then
        local data = packet.d
        self:_callEvent("channelUpdate", data)
    elseif event == "STAGE_INSTANCE_CREATE" then
        local data = packet.d
        self:_callEvent("stageInstanceCreate", {
            id = data.id,
            guildId = data.guild_id,
            channelId = data.channel_id,
            topic = data.topic
        })
    elseif event == "STAGE_INSTANCE_DELETE" then
        local data = packet.d
        self:_callEvent("stageInstanceDelete", {
            id = data.id,
            guildId = data.guild_id,
            channelId = data.channel_id,
            topic = data.topic
        })
    elseif event == "STAGE_INSTANCE_UPDATE" then
        local data = packet.d
        self:_callEvent("stageInstanceUpdate", {
            id = data.id,
            guildId = data.guild_id,
            channelId = data.channel_id,
            topic = data.topic
        })
    elseif event == "THREAD_CREATE" then
        local data = packet.d
        self:_callEvent("threadCreate", data)
    elseif event == "THREAD_DELETE" then
        local data = packet.d
        self:_callEvent("threadDelete", data)
    elseif event == "THREAD_LIST_SYNC" then
        local data = packet.d

        local eventData = {
            guildId = data.guild_id,
            channelIds = data.channel_ids,
            threads = data.threads,
            members = data.members
        }
        if eventData.members then
            for _, member in ipairs(eventData.members) do
                member.userId = member.user_id
                member.user_id = nil
                member.joinTimestamp = datetime.fromIsoDate(member.join_timestamp)
                member.join_timestamp = nil
            end
        end

        self:_callEvent("threadListSync", eventData)
    elseif event == "THREAD_MEMBERS_UPDATE" then
        local data = packet.d

        local eventData = {
            id = data.id,
            guildId = data.guild_id,
            addedMembers = data.added_members,
            removedMemberIds = data.removed_member_ids
        }
        if eventData.addedMembers then
            for _, member in ipairs(eventData.addedMembers) do
                member.userId = member.user_id
                member.user_id = nil
                member.joinTimestamp = datetime.fromIsoDate(member.join_timestamp)
                member.join_timestamp = nil
            end
        end

        self:_callEvent("threadMembersUpdate", eventData)
    elseif event == "THREAD_MEMBER_UPDATE" then
        local data = packet.d
        self:_callEvent("threadMemberUpdate", {
            id = data.id,
            guildId = data.guild_id,
            joinedAt = datetime.fromIsoDate(data.joined_at),
            flags = data.flags
        })
    elseif event == "THREAD_UPDATE" then
        local data = packet.d
        self:_callEvent("threadUpdate", data)
    end
end

function Client.on(self: Client, event: Event, callback: (any) -> ())
    if not self.events[event] then
        self.events[event] = {}
    end
    table.insert(self.events[event], callback)
end

function Client.connect(self: Client)
    if self.gateway.defaultConnection then
        self.gateway:updateConnectionOptions(self.rest:getBotGateway())
    end

    self.gateway:spawnShards()
    self.logger:print("[Bot] Connected successfully")
end

return Client