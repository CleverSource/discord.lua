return {
    DefaultGateway = "wss://gateway.discord.gg",
    GatewayVersion = 10,

    GatewayOpCodes = {
        Dispatch = 0,
        Heartbeat = 1,
        Identify = 2,
        Resume = 6,
        Reconnect = 7,
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
        InvalidSeq = 4007,
        SessionTimedOut = 4009,
        InvalidShard = 4010,
        ShardingRequired = 4011,
        InvalidApiVersion = 4012,
        InvalidIntents = 4013,
        DisallowedIntents = 4014
    }
}