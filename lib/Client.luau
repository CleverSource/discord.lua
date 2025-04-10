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
                    | "guildEmojisUpdate"
                    | "entitlementCreate"
                    | "entitlementDelete"
                    | "entitlementUpdate"
                    | "automodActionExecution"
                    | "automodRuleCreate"
                    | "automodRuleDelete"
                    | "automodRuleUpdate"
                    | "scheduledEventCreate"
                    | "scheduledEventDelete"
                    | "scheduledEventUpdate"
                    | "scheduledEventUserAdd"
                    | "scheduledEventUserRemove"
                    | "guildAuditLogEntryCreate"
                    | "guildBanAdd"
                    | "guildBanRemove"
                    | "guildCreate"
                    | "guildUnavailable"
                    | "guildDelete"
                    | "integrationUpdate"
                    | "guildStickersUpdate"
                    | "guildUpdate"
                    | "integrationCreate"
                    | "integrationDelete"
                    | "integrationUpdate"
                    | "applicationCommandPermissionsUpdate"
                    | "interactionCreate"
                    | "inviteCreate"
                    | "inviteDelete"
                    | "guildMemberAdd"
                    | "guildMemberRemove"
                    | "guildMemberUpdate"
                    | "messageCreate"
                    | "messageDelete"
                    | "messageDeleteBulk"
                    | "reactionAdd"
                    | "reactionRemove"
                    | "reactionRemoveAll"
                    | "reactionRemoveEmoji"
                    | "messageUpdate"
                    | "messagePollVoteAdd"
                    | "messagePollVoteRemove"
                    | "roleCreate"
                    | "roleDelete"
                    | "roleUpdate"
                    | "soundboardSoundsUpdate"
                    | "soundboardSoundCreate"
                    | "soundboardSoundDelete"
                    | "soundboardSoundUpdate"
                    | "soundboardSounds"
                    | "subscriptionCreate"
                    | "subscriptionDelete"
                    | "subscriptionUpdate"
                    | "voiceChannelEffectSend"
                    | "voiceServerUpdate"
                    | "voiceStateUpdate"
                    | "presenceUpdate"
                    | "typingStart"
                    | "botUpdate"
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
    threadUpdate: ((ApiTypes.ChannelObject) -> ())?,

    guildEmojisUpdate: (({
        guildId: string,
        emojis: { ApiTypes.EmojiObject }
    }) -> ())?,

    entitlementCreate: ((ApiTypes.EntitlementObject) -> ())?,
    entitlementDelete: ((ApiTypes.EntitlementObject) -> ())?,
    entitlementUpdate: ((ApiTypes.EntitlementObject) -> ())?,

    automodActionExecution: ((ApiTypes.AutomoderationActionObject) -> ())?,
    automodRuleCreate: ((ApiTypes.AutomoderationRuleObject) -> ())?,
    automodRuleDelete: ((ApiTypes.AutomoderationRuleObject) -> ())?,
    automodRuleUpdate: ((ApiTypes.AutomoderationRuleObject) -> ())?,

    scheduledEventCreate: ((ApiTypes.GuildScheduledEventObject) -> ())?,
    scheduledEventDelete: ((ApiTypes.GuildScheduledEventObject) -> ())?,
    scheduledEventUpdate: ((ApiTypes.GuildScheduledEventObject) -> ())?,
    scheduledEventUserAdd: (({
        guildScheduledEventId: string,
        guildId: string,
        userId: string
    }) -> ())?,
    scheduledEventUserRemove: (({
        guildScheduledEventId: string,
        guildId: string,
        userId: string
    }) -> ())?,

    guildAuditLogEntryCreate: ((ApiTypes.AuditLogEntryObject) -> ())?,
    guildBanAdd: ((ApiTypes.UserObject) -> ())?,
    guildBanRemove: ((ApiTypes.UserObject) -> ())?,
    guildCreate: ((ApiTypes.GuildObject) -> ())?,
    guildUnavailable: ((string) -> ())?,
    guildDelete: ((string) -> ())?,
    guildStickersUpdate: (({
        guildId: string,
        stickers: { ApiTypes.StickerObject }
    }) -> ())?,
    guildUpdate: ((ApiTypes.GuildObject) -> ())?,

    integrationCreate: ((ApiTypes.IntegrationObject) -> ())?,
    integrationDelete: (({
        id: string,
        guildId: string,
        applicationId: string
    }) -> ())?,
    integrationUpdate: (({
        guildId: string
    }) -> ())?,

    interactionCreate: ((ApiTypes.InteractionObject) -> ())?,
    applicationCommandPermissionsUpdate: ((ApiTypes.GuildApplicationCommandPermissionsObject) -> ())?,

    inviteCreate: ((ApiTypes.InviteObject) -> ())?,
    inviteDelete: ((ApiTypes.InviteObject) -> ())?,

    guildMemberAdd: ((ApiTypes.GuildMemberObject) -> ())?,
    guildMemberDelete: ((ApiTypes.UserObject) -> ())?,
    guildMemberUpdate: ((ApiTypes.GuildMemberObject) -> ())?,

    messageCreate: ((ApiTypes.MessageObject) -> ())?,
    messageDelete: (({
        id: string,
        channelId: string,
        guildId: string?
    }) -> ())?,
    messageDeleteBulk: ((
        ids: { string },
        channelId: string,
        guildId: string?
    ) -> ())?,
    messageUpdate: ((ApiTypes.MessageObject) -> ())?,
    reactionAdd: ((ApiTypes.ReactionObject) -> ())?,
    reactionRemove: ((ApiTypes.ReactionObject) -> ())?,
    reactionRemoveAll: (({
        channelId: string,
        messageId: string,
        guildId: string?
    }) -> ())?,
    reactionRemoveEmoji: (({
        channelId: string,
        messageId: string,
        guildId: string?,
        emoji: ApiTypes.EmojiObject
    }) -> ())?,

    messagePollVoteAdd: (({
        userId: string,
        channelId: string,
        messageId: string,
        guildId: string?,
        answerId: number
    }) -> ())?,
    messagePollVoteRemove: (({
        userId: string,
        channelId: string,
        messageId: string,
        guildId: string?,
        answerId: number
    }) -> ())?,

    roleCreate: ((ApiTypes.GuildRoleObject) -> ())?,
    roleDelete: (({
        guildId: string,
        roleId: string
    }) -> ())?,
    roleUpdate: ((ApiTypes.GuildRoleObject) -> ())?,

    soundboardSoundsUpdate: (({
        soundboardSounds: { ApiTypes.SoundboardSoundObject },
        guildId: string
    }) -> ())?,
    soundboardSoundCreate: ((ApiTypes.SoundboardSoundObject) -> ())?,
    soundboardSoundDelete: (({
        soundId: string,
        guildId: string
    }) -> ())?,
    soundboardSoundUpdate: ((ApiTypes.SoundboardSoundObject) -> ())?,
    soundboardSounds: (({
        soundboardSounds: { ApiTypes.SoundboardSoundObject },
        guildId: string
    }) -> ())?,
    
    subscriptionCreate: ((ApiTypes.SubscriptionObject) -> ())?,
    subscriptionDelete: ((ApiTypes.SubscriptionObject) -> ())?,
    subscriptionUpdate: ((ApiTypes.SubscriptionObject) -> ())?,
    voiceChannelEffectSend: (({
        channelId: string,
        guildId: string,
        userId: string,
        emoji: ApiTypes.EmojiObject?,
        animationType: number?,
        animationId: number?,
        soundId: string?,
        soundVolume: number?
    }) -> ())?
    voiceServerUpdate: (({
        token: string,
        endpoint: string?,
        guildId: string
    }) -> ())?,
    voiceStateUpdate: ((ApiTypes.VoiceStateObject) -> ())?,

    presenceUpdate: ((ApiTypes.PresenceUpdateObject) -> ())?
    typingStart: (({
        guildId: string?,
        channelId: string,
        userId: string,
        timestamp: number,
        member: ApiTypes.GuildMemberObject?
    }) -> ())?,
    botUpdate: ((ApiTypes.UserObject) -> ())?
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
}, Client))

function Client.new(options: ClientOptions): Client
    local self = setmetatable({}, Client) :: Client

    self.token = options.token

    local logger = Logger.new(options.debug or false)

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
    
    local restOptions = options.restOptions or {
        token = options.token,
        preferSnakeCase = false,
        logger = logger
    }

    if options.token and not options.applicationId then
        restOptions.applicationId = getApplicationIdFromToken(options.token)
    else
        restOptions.applicationId = options.applicationId
    end

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
        preferSnakeCase = true,
        logger = logger,
        intents = intentsBit,
        compress = options.compression or false
    }

    self.logger = logger
    self.gateway = GatewayHandler.new(gatewayOptions)
    self.rest = RestClient.new(restOptions)

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
                callback(camelize(...))
            end
        else
            self.events[event](camelize(...))
        end
    end
end

function Client.handleDispatch(self: Client, event: string, shard: Shard, packet: GatewayTypes.Payload<any>)
    local data = packet.d
    
    if event == "READY" then
        self.id = data.user.id
        self.rest:setApplicationId(data.application.id)
        
        self:_callEvent("ready", {
            shardId = shard.id,
            v = data.v,
            user = data.user,
            guilds = data.guilds,
            sessionId = data.session_id,
            shard = data.shard,
            applicationId = data.application.id
        })
    end

    if event == "WEBHOOKS_UPDATE" then
        self:_callEvent("webhooksUpdate", data)
    elseif event == "CHANNEL_CREATE" then
        self:_callEvent("channelCreate", data)
    elseif event == "CHANNEL_DELETE" then
        self:_callEvent("channelDelete", data)
    elseif event == "CHANNEL_PINS_UPDATE" then
        self:_callEvent("channelPinsUpdate", data)
    elseif event == "CHANNEL_UPDATE" then
        self:_callEvent("channelUpdate", data)
    elseif event == "STAGE_INSTANCE_CREATE" then
        self:_callEvent("stageInstanceCreate", data)
    elseif event == "STAGE_INSTANCE_DELETE" then
        self:_callEvent("stageInstanceDelete", data)
    elseif event == "STAGE_INSTANCE_UPDATE" then
        self:_callEvent("stageInstanceUpdate", data)
    elseif event == "THREAD_CREATE" then
        self:_callEvent("threadCreate", data)
    elseif event == "THREAD_DELETE" then
        self:_callEvent("threadDelete", data)
    elseif event == "THREAD_LIST_SYNC" then
        self:_callEvent("threadListSync", data)
    elseif event == "THREAD_MEMBERS_UPDATE" then
        self:_callEvent("threadMembersUpdate", data)
    elseif event == "THREAD_MEMBER_UPDATE" then
        self:_callEvent("threadMemberUpdate", data)
    elseif event == "THREAD_UPDATE" then
        self:_callEvent("threadUpdate", data)
    elseif event == "GUILD_EMOJIS_UPDATE" then
        self:_callEvent("guildEmojisUpdate", data)
    elseif event == "ENTITLEMENT_CREATE" then
        self:_callEvent("entitlementCreate", data)
    elseif event == "ENTITLEMENT_DELETE" then
        self:_callEvent("entitlementDelete", data)
    elseif event == "ENTITLEMENT_UPDATE" then
        self:_callEvent("entitlementUpdate", data)
    elseif event == "AUTO_MODERATION_ACTION_EXECUTION" then
        self:_callEvent("automodActionExecution", data)
    elseif event == "AUTO_MODERATION_RULE_CREATE" then
        self:_callEvent("automodRuleCreate", data)
    elseif event == "AUTO_MODERATION_RULE_DELETE" then
        self:_callEvent("automodRuleDelete", data)
    elseif event == "AUTO_MODERATION_RULE_UPDATE" then
        self:_callEvent("automodRuleUpdate", data)
    elseif event == "GUILD_SCHEDULED_EVENT_CREATE" then
        self:_callEvent("scheduledEventCreate", data)
    elseif event == "GUILD_SCHEDULED_EVENT_DELETE" then
        self:_callEvent("scheduledEventDelete", data)
    elseif event == "GUILD_SCHEDULED_EVENT_UPDATE" then
        self:_callEvent("scheduledEventUpdate", data)
    elseif event == "GUILD_SCHEDULED_EVENT_USER_ADD" then
        self:_callEvent("scheduledEventUserAdd", data)
    elseif event == "GUILD_SCHEDULED_EVENT_USER_REMOVE" then
        self:_callEvent("scheduledEventUserRemove", data)
    elseif event == "GUILD_AUDIT_LOG_ENTRY_CREATE" then
        self:_callEvent("guildAuditLogEntryCreate", data)
    elseif event == "GUILD_BAN_ADD" then
        self:_callEvent("guildBanAdd", data)
    elseif event == "GUILD_BAN_REMOVE" then
        self:_callEvent("guildBanRemove", data)
    elseif event == "GUILD_CREATE" then
        self:_callEvent("guildCreate", data)
    elseif event == "GUILD_DELETE" then
        if data.unavailable then
            self:_callEvent("guildUnavailable", data.id)
            return
        end
        self:_callEvent("guildDelete", data.id)
    elseif event == "GUILD_INTEGRATIONS_UPDATE" then
        self:_callEvent("integrationUpdate", data)
    elseif event == "GUILD_STICKERS_UPDATE" then
        self:_callEvent("guildStickersUpdate", data)
    elseif event == "GUILD_UPDATE" then
        self:_callEvent("guildUpdate", data)
    elseif event == "INTEGRATION_CREATE" then
        self:_callEvent("integrationCreate", data)
    elseif event == "INTEGRATION_DELETE" then
        self:_callEvent("integrationDelete", data)
    elseif event == "INTEGRATION_UPDATE" then
        self:_callEvent("integrationUpdate", data)
    elseif event == "APPLICATION_COMMAND_PERMISSIONS_UPDATE" then
        self:_callEvent("applicationCommandPermissionsUpdate", data)
    elseif event == "INTERACTION_CREATE" then
        self:_callEvent("interactionCreate", data)
    elseif event == "INVITE_CREATE" then
        self:_callEvent("inviteCreate", data)
    elseif event == "INVITE_DELETE" then
        self:_callEvent("inviteDelete", data)
    elseif event == "GUILD_MEMBERS_CHUNK" then
        -- TODO
    elseif event == "GUILD_MEMBER_ADD" then
        self:_callEvent("guildMemberAdd", data)
    elseif event == "GUILD_MEMBER_REMOVE" then
        self:_callEvent("guildMemberRemove", data)
    elseif event == "GUILD_MEMBER_UPDATE" then
        self:_callEvent("guildMemberUpdate", data)
    elseif event == "MESSAGE_CREATE" then
        self:_callEvent("messageCreate", data)
    elseif event == "MESSAGE_DELETE" then
        self:_callEvent("messageDelete", data)
    elseif event == "MESSAGE_DELETE_BULK" then
        self:_callEvent("messageDeleteBulk", data)
    elseif event == "MESSAGE_REACTION_ADD" then
        self:_callEvent("reactionAdd", data)
    elseif event == "MESSAGE_REACTION_REMOVE" then
        self:_callEvent("reactionRemove", data)
    elseif event == "MESSAGE_REACTION_REMOVE_ALL" then
        self:_callEvent("reactionRemoveAll", data)
    elseif event == "MESSAGE_REACTION_REMOVE_EMOJI" then
        self:_callEvent("reactionRemoveEmoji", data)
    elseif event == "MESSAGE_UPDATE" then
        if not data.edited_timestamp then return end
        self:_callEvent("messageUpdate", data)
    elseif event == "MESSAGE_POLL_VOTE_ADD" then
        self:_callEvent("messagePollVoteAdd", data)
    elseif event == "MESSAGE_POLL_VOTE_REMOVE" then
        self:_callEvent("messagePollVoteRemove", data)
    elseif event == "GUILD_ROLE_CREATE" then
        self:_callEvent("roleCreate", data)
    elseif event == "GUILD_ROLE_DELETE" then
        self:_callEvent("roleDelete", data)
    elseif event == "GUILD_ROLE_UPDATE" then
        self:_callEvent("roleUpdate", data)
    elseif event == "GUILD_SOUNDBOARD_SOUNDS_UPDATE" then
        self:_callEvent("soundboardSoundsUpdate", data)
    elseif event == "GUILD_SOUNDBOARD_SOUND_CREATE" then
        self:_callEvent("soundboardSoundCreate", data)
    elseif event == "GUILD_SOUNDBOARD_SOUND_DELETE" then
        self:_callEvent("soundboardSoundDelete", data)
    elseif event == "GUILD_SOUNDBOARD_SOUND_UPDATE" then
        self:_callEvent("soundboardSoundUpdate", data)
    elseif event == "SOUNDBOARD_SOUNDS" then
        self:_callEvent("soundboardSounds", data)
    elseif event == "SUBSCRIPTION_CREATE" then
        self:_callEvent("subscriptionCreate", data)
    elseif event == "SUBSCRIPTION_DELETE" then
        self:_callEvent("subscriptionDelete", data)
    elseif event == "SUBSCRIPTION_UPDATE" then
        self:_callEvent("subscriptionUpdate", data)
    elseif event == "VOICE_CHANNEL_EFFECT_SEND" then
        self:_callEvent("voiceChannelEffectSend", data)
    elseif event == "VOICE_SERVER_UPDATE" then
        self:_callEvent("voiceServerUpdate", data)
    elseif event == "VOICE_STATE_UPDATE" then
        if not data.guild_id then return end
        self:_callEvent("voiceStateUpdate", data)
    elseif event == "PRESENCE_UPDATE" then
        self:_callEvent("presenceUpdate", data)
    elseif event == "TYPING_START" then
        self:_callEvent("typingStart", data)
    elseif event == "USER_UPDATE" then
        self:_callEvent("botUpdate", data)
    end
end

function Client.on(self: Client, event: Event, callback: (any) -> ())
    if not self.events[event] then
        self.events[event] = {}
    elseif self.events[event] and typeof(self.events[event]) ~= "table" then
        local oldCallback = self.events[event]
        self.events[event] = {}
        table.insert(self.events[event], oldCallback)
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