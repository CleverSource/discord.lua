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
        CreateInstantInvite = bit32.lshift(1, 0),
        KickMembers = bit32.lshift(1, 1),
        BanMembers = bit32.lshift(1, 2),
        Administrator = bit32.lshift(1, 3),
        ManageChannels = bit32.lshift(1, 4),
        ManageGuild = bit32.lshift(1, 5),
        AddReactions = bit32.lshift(1, 6),
        ViewAuditLog = bit32.lshift(1, 7),
        PrioritySpeaker = bit32.lshift(1, 8),
        Stream = bit32.lshift(1, 9),
        ViewChannel = bit32.lshift(1, 10),
        SendMessages = bit32.lshift(1, 11),
        SendTtsMessages = bit32.lshift(1, 12),
        ManageMessages = bit32.lshift(1, 13),
        EmbedLinks = bit32.lshift(1, 14),
        AttachFiles = bit32.lshift(1, 15),
        ReadMessageHistory = bit32.lshift(1, 16),
        MentionEveryone = bit32.lshift(1, 17),
        UseExternalEmojis = bit32.lshift(1, 18),
        ViewGuildInsights = bit32.lshift(1, 19),
        Connect = bit32.lshift(1, 20),
        Speak = bit32.lshift(1, 21),
        MuteMembers = bit32.lshift(1, 22),
        DeafenMembers = bit32.lshift(1, 23),
        MoveMembers = bit32.lshift(1, 24),
        UseVad = bit32.lshift(1, 25),
        ChangeNickname = bit32.lshift(1, 26),
        ManageNicknames = bit32.lshift(1, 27),
        ManageRoles = bit32.lshift(1, 28),
        ManageWebhooks = bit32.lshift(1, 29),
        ManageGuildExpressions = bit32.lshift(1, 30),
        UseSlashCommands = bit32.lshift(1, 31),
        RequestToSpeak = bit64.shift(1, 32),
        ManageEvents = bit64.shift(1, 33),
        ManageThreads = bit64.shift(1, 34),
        CreatePublicThreads = bit64.shift(1, 35),
        CreatePrivateThreads = bit64.shift(1, 36),
        UseExternalStickers = bit64.shift(1, 37),
        SendMessagesInThreads = bit64.shift(1, 38),
        UseEmbeddedActivities = bit64.shift(1, 39),
        ModerateMembers = bit64.shift(1, 40),
        ViewCreatorMonetizationAnalytics = bit64.shift(1, 41),
        UseSoundboard = bit64.shift(1, 42),
        CreateGuildExpressions = bit64.shift(1, 43),
        CreateEvents = bit64.shift(1, 44),
        UseExternalSounds = bit64.shift(1, 45),
        SendVoiceMessages = bit64.shift(1, 46),
        SendPolls = bit64.shift(1, 49),
        UseExternalApps = bit64.shift(1, 50)
    },

    Locales = {
        Indonesian = "id",
        Danish = "da",
        German = "de",
        EnglishUk = "en-GB",
        EnglishUs = "en-US",
        Spanish = "es-ES",
        SpanishLatam = "es-419",
        French = "fr",
        Croatian = "hr",
        Italian = "it",
        Lithuanian = "lt",
        Hungarian = "hu",
        Dutch = "nl",
        Norwegian = "no",
        Polish = "pl",
        PortugueseBrazilian = "pt-BR",
        RomanianRomania = "ro",
        Finnish = "fi",
        Swedish = "sv-SE",
        Vietnamese = "vi",
        Turkish = "tr",
        Czech = "cs",
        Greek = "el",
        Bulgarian = "bg",
        Russian = "ru",
        Ukrainian = "uk",
        Hindi = "hi",
        Thai = "th",
        ChineseChina = "zh-CN",
        Japanese = "ja",
        ChineseTaiwan = "zh-TW",
        Korean = "ko"
    },

    ApplicationCommandTypes = {
        ChatInput = 1,
        User = 2,
        Message = 3,
        PrimaryEntryPoint = 4
    },

    ApplicationCommandOptionTypes = {
        SubCommand = 1,
        SubCommandGroup = 2,
        String = 3,
        Integer = 4,
        Boolean = 5,
        User = 6,
        Channel = 7,
        Role = 8,
        Mentionable = 9,
        Number = 10,
        Attachment = 11,
    },

    ApplicationIntegrationType = {
        GuildInstall = 0,
        UserInstall = 1
    },

    InteractionContextType = {
        Guild = 0,
        BotDm = 1,
        PrivateChannel = 2
    },

    InteractionEntryPointCommandHandlerType = {
        AppHandler = 1,
        DiscordLaunchActivity = 2
    },

    InteractionResponseTypes = {
        Pong = 1,
        ChannelMessageWithSource = 4,
        DeferredChannelMessageWithSource = 5,
        DeferredUpdateMessage = 6,
        UpdateMessage = 7,
        ApplicationCommandAutocompleteResult = 8,
        Modal = 9,
        PremiumRequired = 10,
        LaunchActivity = 12,
    }
}