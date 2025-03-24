local Intents = {
    Guilds = bit32.lshift(1, 0),
    GuildMembers = bit32.lshift(1, 1),
    GuildBans = bit32.lshift(1, 2),
    GuildExpressions = bit32.lshift(1, 3),
    GuildIntegrations = bit32.lshift(1, 4),
    GuildWebhooks = bit32.lshift(1, 5),
    GuildInvites = bit32.lshift(1, 6),
    GuildVoiceStates = bit32.lshift(1, 7),
    GuildPresences = bit32.lshift(1, 8),
    GuildMessages = bit32.lshift(1, 9),
    GuildMessageReactions = bit32.lshift(1, 10),
    GuildMessageTyping = bit32.lshift(1, 11),
    DirectMessages = bit32.lshift(1, 12),
    DirectMessageReactions = bit32.lshift(1, 13),
    DirectMessageTyping = bit32.lshift(1, 14),
    MessageContent = bit32.lshift(1, 15),
    GuildScheduledEvents = bit32.lshift(1, 16),
    AutoModerationConfiguration = bit32.lshift(1, 20),
    AutoModerationExecution = bit32.lshift(1, 21),
    GuildMessagePolls = bit32.lshift(1, 24),
    DirectMessagePolls = bit32.lshift(1, 25)
}

Intents.AllNonPrivileged = bit32.bor(
    Intents.Guilds,
    Intents.GuildBans,
    Intents.GuildExpressions,
    Intents.GuildIntegrations,
    Intents.GuildWebhooks,
    Intents.GuildInvites,
    Intents.GuildVoiceStates,
    Intents.GuildMessages,
    Intents.GuildMessageReactions,
    Intents.GuildMessageTyping,
    Intents.DirectMessages,
    Intents.DirectMessageReactions,
    Intents.DirectMessageTyping,
    Intents.GuildScheduledEvents,
    Intents.AutoModerationConfiguration,
    Intents.AutoModerationExecution,
    Intents.GuildMessagePolls,
    Intents.DirectMessagePolls
)

Intents.AllPrivileged = bit32.bor(
    Intents.GuildPresences,
    Intents.GuildMembers,
    Intents.GuildVoiceStates
)

Intents.All = bit32.bor(
    Intents.AllNonPrivileged,
    Intents.AllPrivileged
)

export type Intents = "Guilds" 
                    | "GuildMembers"
                    | "GuildBans"
                    | "GuildExpressions"
                    | "GuildIntegrations"
                    | "GuildWebhooks"
                    | "GuildInvites"
                    | "GuildVoiceStates"
                    | "GuildPresences"
                    | "GuildMessages"
                    | "GuildMessageReactions"
                    | "GuildMessageTyping"
                    | "DirectMessages"
                    | "DirectMessageReactions"
                    | "DirectMessageTyping"
                    | "MessageContent"
                    | "GuildScheduledEvents"
                    | "AutoModerationConfiguration"
                    | "AutoModerationExecution"
                    | "GuildMessagePolls"
                    | "DirectMessagePolls"
                    | "AllNonPrivileged"
                    | "AllPrivileged"
                    | "All"

return {
    DefaultGateway = "wss://gateway.discord.gg",
    GatewayVersion = 10,

    GatewayOpCodes = {
        Dispatch = 0,
        Heartbeat = 1,
        Identify = 2,
        PresenceUpdate = 3,
	    VoiceStateUpdate = 4,
        Resume = 6,
        Reconnect = 7,
        RequestGuildMembers = 8,
        InvalidSession = 9,
        Hello = 10,
        HeartbeatACK = 11
    },

    ShardCloseCodes = {
        Shutdown = 3000,
        ZombieConnection = 3010,
        ResumeClosingOldConnection = 3024,
        TestingFinished = 3064,
        Resharded = 3065,
        ReIdentifying = 3066
    },

    GatewayCloseCodes = {
        NormalClosure = 1000,
        GoingAway = 1001,
        DecodeError = 4002,
        NotAuthenticated = 4003,
        AuthenticationFailed = 4004,
        AlreadyAuthenticated = 4005,
        InvalidSeq = 4007,
        Ratelimited = 4008,
        SessionTimedOut = 4009,
        InvalidShard = 4010,
        ShardingRequired = 4011,
        InvalidApiVersion = 4012,
        InvalidIntents = 4013,
        DisallowedIntents = 4014
    },

    Intents = Intents,
}