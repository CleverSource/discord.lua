local bit64 = require("vendor/bit64")

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

    AutoModerationEventTypes = {
        MessageSend = 1,
        MemberUpdate = 2
    },

    AutoModerationTriggerTypes = {
        Keyword = 1,
        Spam = 3,
        KeywordPresent = 4,
        MentionSpam = 5,
        MemberProfile = 6
    },

    AutoModerationRuleTriggerMetadataPresets = {
        Profanity = 1,
        SexualContent = 2,
        Slurs = 3
    },

    AutoModerationActionType = {
        BlockMessage = 1,
        SendAlertMessage = 2,
        Timeout = 3,
        BlockMemberInteraction = 4
    },

    ChannelTypes = {
        GuildText = 0,
        DM = 1,
        GuildVoice = 2,
        GroupDm = 3,
        GuildCategory = 4,
        GuildAnnouncement = 5,
        AnnouncementThread = 10,
        PublicThread = 11,
        PrivateThread = 12,
        GuildStageVoice = 13,
        GuildDirectory = 14,
        GuildForum = 15,
        GuildMedia = 16
    },

    OverwriteTypes = {
        Role = 0,
        Member = 1
    },

    SortOrderTypes = {
        LatestActivity = 0,
        CreationDate = 1
    },

    BitwisePermissionFlags = {
        CREATE_INSTANT_INVITE = bit32.lshift(1, 0),
        KICK_MEMBERS = bit32.lshift(1, 1),
        BAN_MEMBERS = bit32.lshift(1, 2),
        ADMINISTRATOR = bit32.lshift(1, 3),
        MANAGE_CHANNELS = bit32.lshift(1, 4),
        MANAGE_GUILD = bit32.lshift(1, 5),
        ADD_REACTIONS = bit32.lshift(1, 6),
        VIEW_AUDIT_LOG = bit32.lshift(1, 7),
        PRIORITY_SPEAKER = bit32.lshift(1, 8),
        STREAM = bit32.lshift(1, 9),
        VIEW_CHANNEL = bit32.lshift(1, 10),
        SEND_MESSAGES = bit32.lshift(1, 11),
        SEND_TTS_MESSAGES = bit32.lshift(1, 12),
        MANAGE_MESSAGES = bit32.lshift(1, 13),
        EMBED_LINKS = bit32.lshift(1, 14),
        ATTACH_FILES = bit32.lshift(1, 15),
        READ_MESSAGE_HISTORY = bit32.lshift(1, 16),
        MENTION_EVERYONE = bit32.lshift(1, 17),
        USE_EXTERNAL_EMOJIS = bit32.lshift(1, 18),
        VIEW_GUILD_INSIGHTS = bit32.lshift(1, 19),
        CONNECT = bit32.lshift(1, 20),
        SPEAK = bit32.lshift(1, 21),
        MUTE_MEMBERS = bit32.lshift(1, 22),
        DEAFEN_MEMBERS = bit32.lshift(1, 23),
        MOVE_MEMBERS = bit32.lshift(1, 24),
        USE_VAD = bit32.lshift(1, 25),
        CHANGE_NICKNAME = bit32.lshift(1, 26),
        MANAGE_NICKNAMES = bit32.lshift(1, 27),
        MANAGE_ROLES = bit32.lshift(1, 28),
        MANAGE_WEBHOOKS = bit32.lshift(1, 29),
        MANAGE_GUILD_EXPRESSIONS = bit32.lshift(1, 30),
        USE_SLASH_COMMANDS = bit32.lshift(1, 31),
        REQUEST_TO_SPEAK = bit64.shift(1, 32),
        MANAGE_EVENTS = bit64.shift(1, 33),
        MANAGE_THREADS = bit64.shift(1, 34),
        CREATE_PUBLIC_THREADS = bit64.shift(1, 35),
        CREATE_PRIVATE_THREADS = bit64.shift(1, 36),
        USE_EXTERNAL_STICKERS = bit64.shift(1, 37),
        SEND_MESSAGES_IN_THREADS = bit64.shift(1, 38),
        USE_EMBEDDED_ACTIVITIES = bit64.shift(1, 39),
        MODERATE_MEMBERS = bit64.shift(1, 40),
        VIEW_CREATOR_MONETIZATION_ANALYTICS = bit64.shift(1, 41),
        USE_SOUNDBOARD = bit64.shift(1, 42),
        CREATE_GUILD_EXPRESSIONS = bit64.shift(1, 43),
        CREATE_EVENTS = bit64.shift(1, 44),
        USE_EXTERNAL_SOUNDS = bit64.shift(1, 45),
        SEND_VOICE_MESSAGES = bit64.shift(1, 46),
        SEND_POLLS = bit64.shift(1, 49),
        USE_EXTERNAL_APPS = bit64.shift(1, 50)
    }
}