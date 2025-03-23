local Intents = {
    guilds = bit32.lshift(1, 0),
    guildMembers = bit32.lshift(1, 1),
    guildBans = bit32.lshift(1, 2),
    guildExpressions = bit32.lshift(1, 3),
    guildIntegrations = bit32.lshift(1, 4),
    guildWebhooks = bit32.lshift(1, 5),
    guildInvites = bit32.lshift(1, 6),
    guildVoiceStates = bit32.lshift(1, 7),
    guildPresences = bit32.lshift(1, 8),
    guildMessages = bit32.lshift(1, 9),
    guildMessageReactions = bit32.lshift(1, 10),
    guildMessageTyping = bit32.lshift(1, 11),
    directMessages = bit32.lshift(1, 12),
    directMessageReactions = bit32.lshift(1, 13),
    directMessageTyping = bit32.lshift(1, 14),
    messageContent = bit32.lshift(1, 15),
    guildScheduledEvents = bit32.lshift(1, 16),
    autoModerationConfiguration = bit32.lshift(1, 20),
    autoModerationExecution = bit32.lshift(1, 21),
    guildMessagePolls = bit32.lshift(1, 24),
    directMessagePolls = bit32.lshift(1, 25)
}

Intents.allNonPrivileged = bit32.bor(
    Intents.guilds,
    Intents.guildBans,
    Intents.guildExpressions,
    Intents.guildIntegrations,
    Intents.guildWebhooks,
    Intents.guildInvites,
    Intents.guildVoiceStates,
    Intents.guildMessages,
    Intents.guildMessageReactions,
    Intents.guildMessageTyping,
    Intents.directMessages,
    Intents.directMessageReactions,
    Intents.directMessageTyping,
    Intents.guildScheduledEvents,
    Intents.autoModerationConfiguration,
    Intents.autoModerationExecution,
    Intents.guildMessagePolls,
    Intents.directMessagePolls
)

Intents.allPrivileged = bit32.bor(
    Intents.guildPresences,
    Intents.guildMembers,
    Intents.guildVoiceStates
)

Intents.all = bit32.bor(
    Intents.allNonPrivileged,
    Intents.allPrivileged
)

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