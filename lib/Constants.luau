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

    MediaSortOrder = {
        LatestActivity = 0,
        CreationDate = 1,
    },

    ForumSortOrder = {
        LatestActivity = 0,
        CreationDate = 1,
    },

    ForumLayout = {
        NotSet = 0,
        ListView = 1,
        GalleryView = 2,
    },

    VideoQualityMode = {
        Auto = 1,
        Full = 2,
    },

    SelectMenuType = {
        String = 3,
        Text = 4,
        User = 5,
        Role = 6,
        Mentionable = 7,
        Channel = 8,
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

    InteractionType = {
        Ping = 1,
        ApplicationCommand = 2,
        MessageComponent = 3,
        ApplicationCommandAutocomplete = 4,
        ModalSubmit = 5,
    },

    ApplicationCommandOptionType = {
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

    ApplicationCommandType = {
        ChatInput = 1,
        User = 2,
        Message = 3,
        PrimaryEntryPoiant = 4,
    },

    ComponentType = {
        ActionRow = 1,
        Button = 2,
        StringSelect = 3,
        TextInput = 4,
        UserSelect = 5,
        RoleSelect = 6,
        MentionableSelect = 7,
        ChannelSelect = 8,
    },

    VerificationLevel = {
        None = 0,
        Low = 1,
        Medium = 2,
        High = 3,
        VeryHigh = 4,   
    },

    DefaultMessageNotification = {
        AllMessages = 0,
        OnlyMentions = 1
    },

    ExplicitContentFilterLevel = {
        Disabled = 0,
        MembersWithoutRoles = 1,
        AllMembers = 2,
    },

    NSFWLevel = {
        Default = 0,
        Explicit = 1,
        Safe = 2,
        AgeRestricted = 3,
    },

    PremiumTier = {
        None = 0,
        Tier1 = 1,
        Tier2 = 2,
        Tier3 = 3,
    },

    MFALevel = {
        None = 0,
        Elevated = 1,
    },

    InviteType = {
        Guild = 0,
        GroupDM = 1,
        Friend = 2,
    },

    InviteTargetType = {
        Stream = 1,
        EmbeddedApplication = 2,
    },

    ScheduledEventPrivacyLevel = {
        GuildOnly = 2
    },

    ScheduledEventEntityType = {
        StageInstance = 1,
        Voice = 2,
        External = 3,
    },

    ScheduledEventStatus = {
        Scheduled = 1,
        Active = 2,
        Completed = 3,
        Cancelled = 4
    },

    IntegrationType = {
        Twitch = "twitch",
        YouTube = "youtube",
        Discord = "discord",
        GuildSubscription = "guild_subscription",
    },

    IntegrationExpireBehavior = {
        RemoveRole = 0,
        Kick = 1,
    },

    OnboardingPromptType = {
        MultipleChoice = "MULTIPLE_CHOICE",
        Dropdown = "DROPDOWN",
    },

    OnboardingMode = {
        Default = "ONBOARDING_DEFAULT",
        Advanced = "ONBOARDING_ADVANCED",
    },

    OverwriteType = {
        Role = 0,
        Member = 1
    },

    TriggerType = {
        Keyword = 1,
        Spam = 3,
        KeywordPreset = 4,
        MentionSpam = 5,
        MemberProfile = 6,
    },

    KeywordPresetType = {
        Profanity = 1,
        SexualContent = 2,
        Slurs = 3,
    },

    EventType = {
        MessageSend = 1,
        MemberUpdate = 2,
    },

    ActionType = {
        BlockMessage = 1,
        SendAlertMessage = 2,
        Timeout = 3,
        BlockMemberInteraction = 4,
    },

    AuditLogEvent = {
        GuildUpdate = 1,
        ChannelCreate = 10,
        ChannelUpdate = 11,
        ChannelDelete = 12,
        ChannelOverwriteCreate = 13,
        ChannelOverwriteUpdate = 14,
        ChannelOverwriteDelete = 15,
        MemberKick = 20,
        MemberPrune = 21,
        MemberBanAdd = 22,
        MemberBanRemove = 23,
        MemberUpdate = 24,
        MemberRoleUpdate = 25,
        MemberMove = 26,
        MemberDisconnect = 27,
        BotAdd = 28,
        RoleCreate = 30,
        RoleUpdate = 31,
        RoleDelete = 32,
        InviteCreate = 40,
        InviteUpdate = 41,
        InviteDelete = 42,
        WebhookCreate = 50,
        WebhookUpdate = 51,
        WebhookDelete = 52,
        EmojiCreate = 60,
        EmojiUpdate = 61,
        EmojiDelete = 62,
        MessageDelete = 72,
        MessageBulkDelete = 73,
        MessagePin = 74,
        MessageUnpin = 75,
        IntegrationCreate = 80,
        IntegrationUpdate = 81,
        IntegrationDelete = 82,
        StageInstanceCreate = 83,
        StageInstanceUpdate = 84,
        StageInstanceDelete = 85,
        StickerCreate = 90,
        StickerUpdate = 91,
        StickerDelete = 92,
        GuildScheduledEventCreate = 100,
        GuildScheduledEventUpdate = 101,
        GuildScheduledEventDelete = 102,
        ThreadCreate = 110,
        ThreadUpdate = 111,
        ThreadDelete = 112,
        ApplicationCommandPermissionUpdate = 121,
        SoundboardSoundCreate = 130,
        SoundboardSoundUpdate = 131,
        SoundboardSoundDelete = 132,
        AutoModerationRuleCreate = 140,
        AutoModerationRuleUpdate = 141,
        AutoModerationRuleDelete = 142,
        AutoModerationBlockMessage = 143,
        AutoModerationFlagToChannel = 144,
        AutoModerationUserCommunicationDisabled = 145,
        CreatorMonetizationRequestCreated = 150,
        CreatorMonetizationTermsAccepted = 151,
        OnboardingPromptCreate = 163,
        OnboardingPromptUpdate = 164,
        OnboardingPromptDelete = 165,
        OnboardingCreate = 166,
        OnboardingUpdate = 167,
        HomeSettingsCreate = 190,
        HomeSettingsUpdate = 191,
    },

    EntitlementType = {
        Purchase = 1,
        PremiumSubscription = 2,
        DeveloperGift = 3,
        TestModePurchase = 4,
        FreePurchase = 5,
        UserGift = 6,
        PremiumPurchase = 7,
        ApplicationSubscription = 8,
    },

    EmbedType = {
        Rich = "rich",
        Image = "image",
        Video = "video",
        Gifv = "gifv",
        Article = "article",
        Link = "link",
        PollResult = "poll_result",
    },

    ActivityType = {
        Game = 0,
        Streaming = 1,
        Listening = 2,
        Watching = 3,
        Competing = 5,
    },

    Status = {
        Online = "online",
        DoNotDisturb = "dnd",
        Idle = "idle",
        Invisible = "invisible",
        Offline = "offline",
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
    },

    WebhookType = {
        Incoming = 1,
        ChannelFollower = 2,
        Application = 3
    },

    NitroType = {
        None = 0,
        NitroClassic = 1,
        Nitro = 2,
        NitroBasic = 3,
    },

    StickerType = {
        Standard = 1,
        Guild = 2,
    },

    StickerFormatType = {
        PNG = 1,
        APNG = 2,
        LOTTIE = 3,
        GIF = 4
    },

    MessageType = {
        Default = 0,
        RecipientAdd = 1,
        RecipientRemove = 2,
        Call = 3,
        ChannelNameChange = 4,
        ChannelIconChange = 5,
        ChannelPinnedMessage = 6,
        UserJoin = 7,
        GuildBoost = 8,
        GuildBoostTier1 = 9,
        GuildBoostTier2 = 10,
        GuildBoostTier3 = 11,
        ChannelFollowAdd = 12,
        GuildDiscoveryDisqualified = 14,
        GuildDiscoveryRequalified = 15,
        GuildDiscoveryGracePeriodInitialWarning = 16,
        GuildDiscoveryGracePeriodFinalWarning = 17,
        ThreadCreated = 18,
        Reply = 19,
        ChatInputCommand = 20,
        ThreadStarterMessage = 21,
        GuildInviteReminder = 22,
        ContextMenuCommand = 23,
        AutoModerationAction = 24,
        RoleSubscriptionPurchase = 25,
        InteractionPremiumUpsell = 26,
        StageStart = 27,
        StageEnd = 28,
        StageSpeaker = 29,
        StageTopic = 31,
        GuildApplicationPremiumSubscription = 32,
        GuildIncidentAlertModeEnabled = 36,
        GuildIncidentAlertModeDisabled = 37,
        GuildIncidentReportRaid = 38,
        GuildIncidentReportFalseAlarm = 39,
        PurchaseNotification = 44,
        PollResult = 46,
    },

    MessageActivityType = {
        Join = 1,
        Spectate = 2,
        Listen = 3,
        JoinRequest = 5
    },

    MessageReferenceType = {
        Default = 0,
        Forward = 1
    },

    ButtonStyle = {
        Blurple = 1,
        Grey = 2,
        Green = 3,
        Red = 4,
    },

    TextInputStyle = {
        Short = 1,
        Paragraph = 2
    },

    SelectDefaultValueType = {
        Role = "role",
        User = "user",
        Channel = "channel",
    },

    PollLayoutType = {
        Default = 1
    },

    ReactionType = {
        Normal = 0,
        Burst = 1
    }
}