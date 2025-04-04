-- Lovingly taken & modified. Original work by @DiscordLuau
-- https://github.com/DiscordLuau/discord-luau
-- MIT License
-- 
-- Copyright (c) 2024 Discord-Luau
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

export type Partial<T> = any

export type Snowflake = string

export type FileContent = {
    content: string,
    name: string
}

-- https://discord.com/developers/docs/topics/permissions#permissions-bitwise-permission-flags
export type PermissionStrings = "CreateInstantInvite"
                                | "KickMembers"
                                | "BanMembers"
                                | "Administrator"
                                | "ManageChannels"
                                | "ManageGuild"
                                | "AddReactions"
                                | "ViewAuditLog"
                                | "PrioritySpeaker"
                                | "Stream"
                                | "ViewChannel"
                                | "SendMessages"
                                | "SendTtsMessages"
                                | "ManageMessages"
                                | "EmbedLinks"
                                | "AttachFiles"
                                | "ReadMessageHistory"
                                | "MentionEveryone"
                                | "UseExternalEmojis"
                                | "ViewGuildInsights"
                                | "Connect"
                                | "Speak"
                                | "MuteMembers"
                                | "DeafenMembers"
                                | "MoveMembers"
                                | "UseVad"
                                | "ChangeNickname"
                                | "ManageNicknames"
                                | "ManageRoles"
                                | "ManageWebhooks"
                                | "ManageGuildExpressions"
                                | "UseSlashCommands"
                                | "RequestToSpeak"
                                | "ManageEvents"
                                | "ManageThreads"
                                | "CreatePublicThreads"
                                | "CreatePrivateThreads"
                                | "UseExternalStickers"
                                | "SendMessagesInThreads"
                                | "UseEmbeddedActivities"
                                | "ModerateMembers"
                                | "ViewCreatorMonetizationAnalytics"
                                | "UseSoundboard"
                                | "CreateGuildExpressions"
                                | "CreateEvents"
                                | "UseExternalSounds"
                                | "SendVoiceMessages"
                                | "SendPolls"
                                | "UseExternalApps"

-- https://discord.com/developers/docs/resources/user#user-object-premium-types
export type PremiumTypes = number

-- https://discord.com/developers/docs/reference#locales
export type LanguageLocales =
    "id"
    | "da"
    | "de"
    | "en-GB"
    | "en-US"
    | "es-ES"
    | "fr"
    | "hr"
    | "it"
    | "lt"
    | "nl"
    | "no"
    | "pl"
    | "pt-BR"
    | "ro"
    | "fi"
    | "sv-SE"
    | "vi"
    | "tr"
    | "cs"
    | "el"
    | "bg"
    | "ru"
    | "uk"
    | "hi"
    | "th"
    | "zn-CH"
    | "ja"
    | "ko"

-- https://discord.com/developers/docs/topics/teams#data-models-membership-state-enum
export type MembershipState = number

-- https://discord.com/developers/docs/topics/teams#data-models-membership-state-enum
export type TeamMemberRole = "Owner" | "Admin" | "Developer" | "Read-only"

-- https://discord.com/developers/docs/resources/guild#guild-object-verification-level
export type VerificationLevel = number

-- https://discord.com/developers/docs/resources/guild#guild-object-default-message-notification-level
export type DefaultMessageNotification = number

-- https://discord.com/developers/docs/resources/guild#guild-object-explicit-content-filter-level
export type ExplicitContentFilterLevel = number

-- https://discord.com/developers/docs/resources/guild#guild-object-explicit-content-filter-level
export type MFALevel = number

-- https://discord.com/developers/docs/resources/guild#guild-object-guild-nsfw-level
export type GuildNSFWLevel = number

-- https://discord.com/developers/docs/resources/guild#guild-object-premium-tier
export type PremiumTier = number

-- https://discord.com/developers/docs/resources/guild#guild-object-system-channel-flags
export type SystemChannelFlags = number

-- https://discord.com/developers/docs/resources/guild#guild-object-guild-features
export type GuildFeature =
    "ANIMATED_BANNER"
    | "ANIMATED_ICON"
    | "APPLICATION_COMMAND_PERMISSIONS_V2"
    | "AUTO_MODERATION"
    | "BANNER"
    | "COMMUNITY"
    | "CREATOR_MONETIZABLE_PROVISIONAL"
    | "CREATOR_STORE_PAGE"
    | "DEVELOPER_SUPPORT_SERVER"
    | "DISCOVERABLE"
    | "FEATURABLE"
    | "INVITES_DISABLED"
    | "INVITE_SPLASH"
    | "MEMBER_VERIFICATION_GATE_ENABLED"
    | "MORE_STICKERS"
    | "NEWS"
    | "PARTNERED"
    | "PREVIEW_ENABLED"
    | "RAID_ALERTS_DISABLED"
    | "ROLE_ICONS"
    | "ROLE_SUBSCRIPTIONS_AVAILABLE_FOR_PURCHASE"
    | "ROLE_SUBSCRIPTIONS_ENABLED"
    | "TICKETED_EVENTS_ENABLED"
    | "VANITY_URL"
    | "VERIFIED"
    | "VIP_REGIONS"
    | "WELCOME_SCREEN_ENABLED"

-- https://discord.com/developers/docs/resources/guild#guild-object-mutable-guild-features
export type MutableGuildFeatures = "COMMUNITY" | "DISCOVERABLE" | "INVITES_DISABLED" | "RAID_ALERTS_DISABLED"

-- https://discord.com/developers/docs/resources/sticker#sticker-object-sticker-types
export type StickerType = number

export type CreateEntitlementOwnerType = number

-- https://discord.com/developers/docs/resources/sticker#sticker-object-sticker-format-types
export type StickerFormatType = number

-- https://discord.com/developers/docs/topics/oauth2#shared-resources-oauth2-scopes
export type OAuth2Scopes =
    "activities.read"
    | "activities.write"
    | "applications.builds.read"
    | "applications.builds.upload"
    | "applications.commands"
    | "applications.commands.update"
    | "applications.commands.permissions.update"
    | "applications.entitlements"
    | "applications.store.update"
    | "bot"
    | "connections"
    | "dm_channels.read"
    | "email"
    | "gdm.join"
    | "guilds"
    | "guilds.join"
    | "guilds.members.read"
    | "identify"
    | "messages.read"
    | "relationships.read"
    | "role_connections.write"
    | "rpc"
    | "rpc.activities.write"
    | "rpc.notifications.read"
    | "rpc.voice.read"
    | "rpc.voice.write"
    | "voice"
    | "webhook.incoming"

-- https://discord.com/developers/docs/resources/guild#integration-object
export type IntegrationType = number -- "twitch" | "youtube" | "discord" | "guild_subscriptions"

-- https://discord.com/developers/docs/resources/application#application-object-application-integration-types
export type ApplicationIntegrationType = number

-- https://discord.com/developers/docs/interactions/application-commands#application-command-permissions-object-application-command-permission-type
export type ApplicationCommandPermissionType = number

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-rule-object-event-types
export type AutomoderationRuleEventType = number

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-rule-object-trigger-types
export type AutomoderationRuleTriggerType = number

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-rule-object-keyword-preset-types
export type AutomoderationRuleKeywordPresetType = number

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-action-object-action-types
export type AutomoderationActionType = number

-- https://discord.com/developers/docs/resources/channel#channel-object-channel-types
export type ChannelType = number

-- https://discord.com/developers/docs/resources/channel#channel-object-video-quality-modes
export type VideoQualityMode = number

-- https://discord.com/developers/docs/resources/channel#channel-object-channel-flags
export type ChannelFlags = number

-- https://discord.com/developers/docs/resources/channel#channel-object-sort-order-types
export type SortOrderType = number

-- https://discord.com/developers/docs/resources/channel#channel-object-forum-layout-types
export type ForumLayoutType = number

-- https://discord.com/developers/docs/resources/channel#overwrite-object
export type OverwriteObjectType = number

-- https://discord.com/developers/docs/monetization/entitlements#entitlement-object-entitlement-types
export type EntitlementType = number

-- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-types
export type ActivityType = number

-- https://discord.com/developers/docs/resources/stage-instance#stage-instance-object-privacy-level
export type PrivacyLevel = number

-- https://discord.com/developers/docs/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-status
export type GuildScheduledEventStatus = number

-- https://discord.com/developers/docs/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-entity-types
export type GuildScheduledEventEntityType = number

-- https://discord.com/developers/docs/resources/guild#integration-object-integration-expire-behaviors
export type IntegrationExpireBehaviours = number

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-type
export type InteractionType = number

-- https://discord.com/developers/docs/resources/message#embed-object-embed-types
export type EmbedType = "Rich" | "Image" | "Video" | "GIFV" | "Article" | "Link" | "PollResult"

-- https://discord.com/developers/docs/resources/channel#message-object-message-types
export type MessageType = number

-- https://discord.com/developers/docs/resources/channel#message-object-message-activity-types
export type MessageActivityType = number

-- https://discord.com/developers/docs/interactions/message-components#button-object-button-styles
export type ButtonStyle = number

-- https://discord.com/developers/docs/interactions/message-components#text-input-object-text-input-styles
export type TextInputStyles = number

-- https://discord.com/developers/docs/resources/poll#layout-type
export type PollLayoutType = number

-- https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-type
export type ApplicationCommandOptionType = number

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-context-types
export type InteractionContextType = number

-- https://discord.com/developers/docs/resources/invite#invite-object-invite-types
export type InviteTypes = number

-- https://discord.com/developers/docs/resources/invite#invite-object-invite-target-types
export type InviteTargetTypes = number

-- https://discord.com/developers/docs/resources/channel#get-reactions-reaction-types
export type ReactionType = number

-- https://discord.com/developers/docs/resources/application-role-connection-metadata#application-role-connection-metadata-object-application-role-connection-metadata-type
export type ApplicationRoleConnectionMetadataType = number

-- https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-types
export type ApplicationCommandType = number

-- https://discord.com/developers/docs/resources/audit-log#audit-log-entry-object-audit-log-events
export type AuditLogEventType = number

-- https://discord.com/developers/docs/resources/webhook#webhook-object-webhook-types
export type WebhookType = number

-- https://discord.com/developers/docs/resources/guild#guild-onboarding-object-onboarding-mode
export type OnboardingMode = number

-- https://discord.com/developers/docs/resources/guild#guild-onboarding-object-prompt-types
export type PromptTypes = number

-- https://discord.com/developers/docs/resources/user#connection-object-services
export type ConnectionObjectServices =
    "battlenet"
    | "bungie"
    | "domain"
    | "ebay"
    | "epicgames"
    | "facebook"
    | "github"
    | "instagram"
    | "leagueoflegends"
    | "paypal"
    | "playstation"
    | "reddit"
    | "riotgames"
    | "spotify"
    | "skype"
    | "stream"
    | "tiktok"
    | "twitch"
    | "twitter"
    | "xbox"
    | "youtube"

-- https://discord.com/developers/docs/resources/channel#allowed-mentions-object-allowed-mention-types
export type AllowedMentionTypes = "roles" | "users" | "everyone"

-- https://discord.com/developers/docs/resources/user#connection-object-visibility-types
export type ConnectionVisibilityTypes = number

-- https://discord.com/developers/docs/resources/channel#message-reference-types
export type MessageReferenceType = number

-- https://discord.com/developers/docs/resources/guild#guild-member-object-guild-member-flags
export type GuildMemberFlags = number

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-type
export type InteractionCallbackType = number

-- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-timestamps
export type ActivityTimestampObject = {
    start: number, -- Unix time (in milliseconds) of when the activity started
    ["end"]: number, -- Unix time (in milliseconds) of when the activity ends
}

-- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-emoji
export type ActivityEmojiObject = {
    name: string, -- Name of the emoji
    id: Snowflake, -- ID of the emoji
    animated: boolean?, -- Whether the emoji is animated
}

-- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-party
export type ActivityPartyObject = {
    id: string, -- ID of the party
    size: { number }, -- Used to show the party's current and maximum size, array of two integers (current_size, max_size)
}

-- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-assets
export type ActivityAssetsObject = {
    large_image: string, -- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-asset-image
    large_text: string, -- Text displayed when hovering over the large image of the activity
    small_image: string, -- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-asset-image
    small_text: string, -- Text displayed when hovering over the small image of the activity
}

-- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-secrets
export type ActivitySecretsObject = {
    join: string?, -- Secret for joining a party
    spectate: string?, -- Secret for spectating a game
    match: string?, -- Secret for a specific instanced match
}

-- https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-buttons
export type ActivityButtonsObject = {
    label: string, -- Text shown on the button (1-32 characters)
    url: string, -- URL opened when clicking the button (1-512 characters)
}

-- https://discord.com/developers/docs/topics/gateway-events#activity-object
export type ActivityObject = {
    name: string, -- Activity's name
    type: number, -- Activity's type
    url: string?, -- Stream URL, is validated when type is 1
    created_at: number, -- Unix timestamp (in milliseconds) of when the activity was added to the user's session
    timestamps: ActivityTimestampObject, -- Unix timestamps for start and/or end of the game
    application_id: Snowflake, -- Application ID for the game
    details: string?, -- What the player is currently doing
    state: string?, -- User's current party status, or text used for a custom status
    emoji: ActivityEmojiObject?, -- Emoji used for a custom status
    party: ActivityPartyObject?, -- Information for the current party of the player
    assets: ActivityAssetsObject?, -- Images for the presence and their hover texts
    secrets: ActivitySecretsObject?, -- Secrets for Rich Presence joining and spectating
    instance: boolean?, -- Whether or not the activity is an instanced game session
    flags: number?, -- Activity flags ORd together, describes what the payload includes
    buttons: { ActivityButtonsObject }?, -- Custom buttons shown in the Rich Presence (max 2)
}

-- https://discord.com/developers/docs/topics/gateway-events#update-presence
export type PresenceObject = {
    since: number, -- Unix time (in milliseconds) of when the client went idle, or null if the client is not idle
    activities: { ActivityObject }, -- User's activities
    status: string, -- User's new status
    afk: boolean, -- Whether or not the client is afk
}

-- https://discord.com/developers/docs/topics/gateway-events#identify-identify-connection-properties
export type IdentifyPropertiesObject = {
    os: string,
    browser: string,
    device: string,
}

-- https://discord.com/developers/docs/resources/user#avatar-decoration-data-object
export type AvatarDecorationDataObject = {
    asset: string, -- the avatar decoration hash
    skuId: Snowflake, -- id of the avatar decoration's SKU
}

-- https://discord.com/developers/docs/resources/user#user-object
export type UserObject = {
    id: Snowflake, -- the user's id
    username: string, -- the user's username, not unique across the platform
    discriminator: string, -- the user's Discord-tag
    globalName: string, -- the user's display name, if it is set. For bots, this is the application name
    avatar: string, -- the user's avatar hash
    bot: boolean?, -- whether the user belongs to an OAuth2 application
    system: boolean?, -- whether the user is an Official Discord System user (part of the urgent message system)
    mfaEnabled: boolean?, -- whether the user has two factor enabled on their account
    banner: string?, -- the user's banner hash
    accentColor: number?, -- the user's banner color encoded as an integer representation of hexadecimal color code
    locale: LanguageLocales?, -- the user's chosen language option
    verified: boolean?, -- whether the email on this account has been verified
    email: string?, -- the user's email
    flags: number?, -- the flags on a user's account
    premiumType: PremiumTypes?, -- the type of Nitro subscription on a user's account
    publicFlags: number?, -- the public flags on a user's account
    avatarDecorationData: AvatarDecorationDataObject?, -- data for the user's avatar decoration
}

-- https://discord.com/developers/docs/resources/guild#unavailable-guild-object
export type UnavailableGuildObject = {
    id: Snowflake, -- guild id
    unavailable: boolean, -- true, the guild is unavailable
}

-- https://discord.com/developers/docs/topics/teams#data-models-team-member-object
export type TeamMemberObject = {
    membershipState: MembershipState, -- User's membership state on the team
    teamId: Snowflake, -- ID of the parent team of which they are a member
    user: UserObject, -- Avatar, discriminator, ID, and username of the user
    role: TeamMemberRole, -- Role of the team member
}

-- https://discord.com/developers/docs/topics/teams#data-models-team-object
export type TeamObject = {
    icon: string, -- Hash of the image of the team's icon
    id: Snowflake, -- Unique ID of the team
    members: { TeamMemberObject }, -- Members of the team
    name: string, -- Name of the team
    ownerUserId: Snowflake, -- User ID of the current team owner
}

-- https://discord.com/developers/docs/topics/permissions#role-object-role-tags-structure
export type GuildRoleTagObject = {
    botId: Snowflake?, -- the id of the bot this role belongs to
    integrationId: Snowflake?, -- the id of the integration this role belongs to
    premiumSubscriber: nil, -- whether this is the guild's Booster role
    subscriptionListingId: Snowflake, -- the id of this role's subscription sku and listing
    availableForPurchase: nil, -- whether this role is available for purchase
    guildConnections: nil, -- whether this role is a guild's linked role
}

-- https://discord.com/developers/docs/topics/permissions#role-object
export type GuildRoleObject = {
    id: Snowflake?, -- role id
    name: string, -- role name
    color: number, -- integer representation of hexadecimal color code
    hoist: boolean, -- if this role is pinned in the user listing
    icon: string?, -- role icon hash
    unicodeEmoji: string?, -- role unicode emoji
    position: number, -- position of this role (roles with the same position are sorted by id)
    permissions: string, -- permission bit set
    managed: boolean, -- whether this role is managed by an integration
    mentionable: boolean, -- whether this role is mentionable
    tags: GuildRoleTagObject?, -- the tags this role has
    flags: number, -- role flags combined as a bitfield
}

-- https://discord.com/developers/docs/resources/emoji#emoji-object
export type EmojiObject = {
    id: Snowflake?, -- 	emoji id
    name: string, -- emoji name
    roles: { Snowflake }?, -- roles allowed to use this emoji
    user: UserObject?, -- user that created this emoji
    requireColons: boolean?, -- whether this emoji must be wrapped in colons
    managed: boolean?, -- whether this emoji is managed
    animated: boolean?, -- whether this emoji is animated
    available: boolean?, -- whether this emoji can be used, may be false due to loss of Server Boosts
}

-- https://discord.com/developers/docs/resources/guild#welcome-screen-object-welcome-screen-channel-structure
export type WelcomeScreenChannelObject = {
    channelId: Snowflake?, -- the channel's id
    description: string?, -- the description shown for the channel
    emojiId: Snowflake?, -- the emoji id, if the emoji is custom
    emojiName: string?, -- the emoji name if custom, the unicode character if standard, or null if no emoji is set
}

-- https://discord.com/developers/docs/resources/guild#welcome-screen-object
export type WelcomeScreenObject = {
    description: string, -- the server description shown in the welcome screen
    welcomeChannels: { WelcomeScreenChannelObject }, -- the channels shown in the welcome screen, up to 5
}

-- https://discord.com/developers/docs/resources/sticker#sticker-object
export type StickerObject = {
    id: Snowflake, -- id of the sticker
    packId: Snowflake, -- for standard stickers, id of the pack the sticker is from
    name: string, -- name of the sticker
    description: string?, -- description of the sticker
    tags: string, -- autocomplete/suggestion tags for the sticker (max 200 characters)
    asset: string?, -- Deprecated previously the sticker asset hash, now an empty string
    type: StickerType, -- type of sticker
    formatType: StickerFormatType, -- 	type of sticker format
    available: boolean?, -- whether this guild sticker can be used, may be false due to loss of Server Boosts
    guildId: Snowflake?, -- id of the guild that owns this sticker
    user: UserObject?, -- the user that uploaded the guild sticker
    sortValue: number?, -- the standard sticker's sort order within its pack
}

-- https://discord.com/developers/docs/resources/guild#guild-object
export type GuildObject = {
    id: Snowflake?, -- guild id
    name: string?, -- guild name (2-100 characters, excluding trailing and leading whitespace)
    icon: string?, -- icon hash
    iconHash: string?, -- icon hash, returned when in the template object
    splash: string?, -- 	splash hash
    discoverySplash: string?, -- discovery splash hash; only present for guilds with the "DISCOVERABLE" feature
    owner: boolean?, -- true if the user is the owner of the guild
    ownerId: Snowflake?, -- id of owner
    permissions: string?, -- total permissions for the user in the guild (excludes overwrites and implicit permissions)
    region: string?, -- voice region id for the guild (deprecated)
    afkChannelId: Snowflake?, -- id of afk channel
    afkTimeout: number?, -- afk timeout in seconds
    widgetEnabled: boolean?, -- true if the server widget is enabled
    widgetChannelId: Snowflake?, -- the channel id that the widget will generate an invite to, or null if set to no invite
    verificationLevel: VerificationLevel?, -- verification level required for the guild
    defaultMessageNotifications: DefaultMessageNotification?, -- default message notifications level
    explicitContentFilter: ExplicitContentFilterLevel?, -- explicit content filter level
    roles: { GuildRoleObject }?, -- roles in the guild
    emojis: { EmojiObject }?, -- custom guild emojis
    features: { GuildFeature }?, -- enabled guild features
    mfaLevel: MFALevel?, -- required MFA level for the guild
    applicationId: Snowflake?, -- application id of the guild creator if it is bot-created
    systemChannelId: Snowflake?, -- the id of the channel where guild notices such as welcome messages and boost events are posted
    systemChannelFlags: SystemChannelFlags?, -- system channel flags
    rulesChannelId: Snowflake?, -- the id of the channel where Community guilds can display rules and/or guidelines
    maxPresences: number?, -- the maximum number of presences for the guild (null is always returned, apart from the largest of guilds)
    maxMembers: number?, -- the maximum number of members for the guild
    vanityUrlCode: string?, -- the vanity url code for the guild
    description: string?, -- the description of a guild
    banner: string?, -- banner hash
    premiumTier: PremiumTier?, -- premium tier (Server Boost level)
    premiumSubscriptionCount: number?, -- the number of boosts this guild currently has
    preferredLocale: LanguageLocales?, -- the preferred locale of a Community guild; used in server discovery and notices from Discord, and sent in interactions; defaults to "en-US"
    publicUpdatesChannelId: Snowflake?, -- the id of the channel where admins and moderators of Community guilds receive notices from Discord
    maxVideoChannelUsers: number?, -- the maximum amount of users in a video channel
    maxStageVideoChannelUsers: number?, -- the maximum amount of users in a stage video channel
    approximateMemberCount: number?, -- approximate number of members in this guild, returned from the GET /guilds/<id> and /users/@me/guilds endpoints when with_counts is true
    approximatePresenceCount: number?, -- approximate number of non-offline members in this guild, returned from the GET /guilds/<id> and /users/@me/guilds endpoints when with_counts is true
    welcomeScreen: WelcomeScreenObject?, -- the welcome screen of a Community guild, shown to new members, returned in an Invite's guild object
    nsfwLevel: GuildNSFWLevel?, -- 	guild NSFW level
    stickers: { StickerObject }?, -- custom guild stickers
    premiumProgressBarEnabled: boolean?, -- whether the guild has the boost progress bar enabled
    safetyAlertsChannelId: Snowflake?, -- the id of the channel where admins and moderators of Community guilds receive safety alerts from Discord
}

-- https://discord.com/developers/docs/resources/application#install-params-object
export type InstallParamsObject = {
    scopes: { OAuth2Scopes }, -- Scopes to add the application to the server with
    permissions: string, -- Permissions to request for the bot role
}

-- https://discord.com/developers/docs/resources/soundboard#soundboard-sound-object-soundboard-sound-structure
export type SoundboardSoundObject = {
    name: string,
    soundId: Snowflake,
    volume: number,
    emojiId: Snowflake?,
    emojiName: string,
    guildId: Snowflake?,
    available: boolean,
    user: UserObject?
}

-- https://discord.com/developers/docs/resources/application#application-object
export type ApplicationObject = {
    id: Snowflake, -- ID of the app
    name: string, -- Name of the app
    icon: string?, -- Icon hash of the app
    description: string, -- Description of the app
    rpcOrigins: { string }?, -- List of RPC origin URLs, if RPC is enabled
    botPublic: boolean, -- When false, only the app owner can add the app to guilds
    botRequireCodeGrant: boolean, -- When true, the app's bot will only join upon completion of the full OAuth2 code grant flow
    bot: UserObject?, -- Partial user object for the bot user associated with the app
    termsOfServiceUrl: string?, -- URL of the app's Terms of Service
    privacyPolicyUrl: string?, -- URL of the app's Privacy Policy
    owner: UserObject?, -- Partial user object for the owner of the app
    summary: string, -- deprecated and will be removed in v11. An empty string.
    verifyKey: string, -- Hex encoded key for verification in interactions and the GameSDK's GetTicket
    team: TeamObject?, -- If the app belongs to a team, this will be a list of the members of that team
    guildId: Snowflake?, -- Guild associated with the app. For example, a developer support server.
    guild: GuildObject?, -- Partial object of the associated guild
    primarySkuId: Snowflake?, -- If this app is a game sold on Discord, this field will be the id of the "Game SKU" that is created, if exists
    slug: string?, -- If this app is a game sold on Discord, this field will be the URL slug that links to the store page
    coverImage: string?, -- App's default rich presence invite cover image hash
    flags: number?, -- App's public flags
    approximateGuildCount: number?, -- Approximate count of guilds the app has been added to
    redirectUris: { string }?, -- Array of redirect URIs for the app
    interactionsEndpointUrl: string?, -- Interactions endpoint URL for the app
    roleConnectionsVerificationUrl: string?, -- Role connection verification URL for the app
    tags: { string }?, -- List of tags describing the content and functionality of the app. Max of 5 tags.
    installParams: InstallParamsObject?, -- Settings for the app's default in-app authorization link, if enabled
    integrationTypesConfig: { [ApplicationIntegrationType]: boolean }?, -- In preview. Default scopes and permissions for each supported installation context. Value for each key is an integration type configuration object
    customInstallUrl: string?, -- Default custom authorization URL for the app, if enabled
}

-- https://discord.com/developers/docs/resources/sku#sku-object-sku-structure
export type SkuObject = {
    id: Snowflake,
    type: number,
    applicationId: Snowflake,
    name: string,
    slug: string,
    flags: number
}

-- https://discord.com/developers/docs/interactions/application-commands#application-command-permissions-object-application-command-permissions-structure
export type GuildApplicationCommandPermissionObject = {
    id: Snowflake, -- ID of the role, user, or channel. It can also be a permission constant
    type: ApplicationCommandPermissionType, -- role (1), user (2), or channel (3)
    permission: boolean, -- true to allow, false, to disallow
}

-- https://discord.com/developers/docs/interactions/application-commands#application-command-permissions-object-guild-application-command-permissions-structure
export type GuildApplicationCommandPermissionsObject = {
    id: Snowflake, -- ID of the command or the application ID
    applicationId: Snowflake, -- ID of the application the command belongs to
    guildId: Snowflake, -- ID of the guild
    permissions: { GuildApplicationCommandPermissionObject }, -- Permissions for the command in the guild, max of 100
}

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-rule-object-trigger-metadata
export type AutomoderationRuleTriggerMetadataObject = {
    keywordFilter: { string }, -- substrings which will be searched for in content (Maximum of 1000)
    regexPatterns: { string }, -- regular expression patterns which will be matched against content (Maximum of 10)
    presets: { AutomoderationRuleKeywordPresetType }, -- the internally pre-defined wordsets which will be searched for in content
    allowList: { string }, -- substrings which should not trigger the rule (Maximum of 100 or 1000)
    mentionTotalLimit: number, -- total number of unique role and user mentions allowed per message (Maximum of 50)
    mentionRaidProtectionEnabled: boolean, -- whether to automatically detect mention raids
}

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-action-object-action-metadata
export type AutmoderationActionMetadataObject = {
    channel_id: Snowflake, -- channel to which user content should be logged
    duration_seconds: number, -- timeout duration in seconds, maximum of 2419200 seconds (4 weeks)
    custom_message: string?, -- additional explanation that will be shown to members whenever their message is blocked, maximum of 150 characters
}

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-action-object
export type AutomoderationActionObject = {
    type: AutomoderationActionType, -- the type of action
    metadata: AutmoderationActionMetadataObject?, -- additional metadata needed during execution for this specific action type
}

-- https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-rule-object
export type AutomoderationRuleObject = {
    id: Snowflake, -- the id of this rule
    guildId: Snowflake, -- the id of the guild which this rule belongs to
    name: string, -- the rule name
    creatorId: Snowflake, -- the user which first created this rule
    eventType: AutomoderationRuleEventType, -- the rule event type
    triggerType: AutomoderationRuleTriggerType, -- the rule trigger type
    triggerMetadata: AutomoderationRuleTriggerMetadataObject, -- the rule trigger metadata
    actions: { AutomoderationActionObject }, -- the actions which will execute when the rule is triggered
    enabled: boolean, -- whether the rule is enabled
    exemptRoles: { Snowflake }, -- the role ids that should not be affected by the rule (Maximum of 20)
    exemptChannels: { Snowflake }, -- the channel ids that should not be affected by the rule (Maximum of 50)
}

-- https://discord.com/developers/docs/resources/channel#overwrite-object
export type OverwriteObject = {
    id: Snowflake, -- role or user id
    type: OverwriteObjectType, -- either 0 (role) or 1 (member)
    allow: { PermissionStrings }, -- permission bit set
    deny: { PermissionStrings }, --permission bit set
}

-- https://discord.com/developers/docs/resources/channel#thread-metadata-object
export type ThreadMetadataObject = {
    archived: boolean, -- whether the thread is archived
    autoArchiveDuration: number, -- the thread will stop showing in the channel list after auto_archive_duration minutes of inactivity, can be set to: 60, 1440, 4320, 10080
    archiveTimestamp: string, -- timestamp when the thread's archive status was last changed, used for calculating recent activity
    locked: boolean, -- whether the thread is locked; when a thread is locked, only users with MANAGE_THREADS can unarchive it
    invitable: boolean?, -- whether non-moderators can add other non-moderators to a thread; only available on private threads
    createTimestamp: string, -- timestamp when the thread was created; only populated for threads created after 2022-01-09
}

-- https://discord.com/developers/docs/resources/guild#guild-member-object
export type GuildMemberObject = {
    user: UserObject?, -- the user this guild member represents
    nick: string?, -- this user's guild nickname
    avatar: string?, -- the member's guild avatar hash
    roles: { Snowflake }, -- array of role object ids
    joinedAt: string, -- when the user joined the guild
    premiumSince: string?, -- when the user started boosting the guild
    deaf: boolean, -- whether the user is deafened in voice channels
    mute: boolean, -- whether the user is muted in voice channels
    flags: number, -- guild member flags represented as a bit set, defaults to 0
    pending: boolean?, -- whether the user has not yet passed the guild's Membership Screening requirements
    permissions: string?, -- total permissions of the member in the channel, including overwrites, returned when in the interaction object
    communicationDisabledUntil: string?, -- when the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
    avatarDecorationData: AvatarDecorationDataObject?, -- data for the member's guild avatar decoration
}

-- https://discord.com/developers/docs/resources/channel#thread-member-object
export type ThreadMemberObject = {
    id: Snowflake?, -- ID of the thread
    userId: Snowflake?, -- ID of the user
    joinTimestamp: string, -- Time the user last joined the thread
    flags: number, -- Any user-thread settings, currently only used for notifications
    member: GuildMemberObject?, -- Additional information about the user
}

-- https://discord.com/developers/docs/resources/channel#forum-tag-object
export type ForumTagObject = {
    id: Snowflake, -- the id of the tag
    name: string, -- the name of the tag (0-20 characters)
    moderated: boolean, -- whether this tag can only be added to or removed from threads by a member with the MANAGE_THREADS permission
    emojiId: string?, -- the id of a guild's custom emoji
    emojiName: string?, -- the unicode character of the emoji
}

-- https://discord.com/developers/docs/resources/channel#default-reaction-object
export type DefaultReactionObject = {
    emojiId: string?, -- the id of a guild's custom emoji
    emojiName: string?, -- the unicode character of the emoji
}

-- https://discord.com/developers/docs/resources/channel#channel-object
export type ChannelObject = {
    id: Snowflake?, -- the id of this channel
    type: ChannelType, -- the type of channel
    guildId: Snowflake?, -- the id of the guild (may be missing for some channel objects received over gateway guild dispatches)
    position: number, -- sorting position of the channel (channels with the same position are sorted by id)
    permissionOverwrites: { OverwriteObject }, -- explicit permission overwrites for members and roles
    name: string, -- the name of the channel (1-100 characters)
    topic: string?, -- the channel topic (0-4096 characters for GUILD_FORUM and GUILD_MEDIA channels, 0-1024 characters for all others)
    nsfw: boolean?, -- whether the channel is nsfw
    lastMessageId: Snowflake?, -- the id of the last message sent in this channel (or thread for GUILD_FORUM or GUILD_MEDIA channels) (may not point to an existing or valid message or thread)
    bitrate: number?, -- the bitrate (in bits) of the voice channel
    userLimit: number?, -- the user limit of the voice channel
    rateLimitPerUser: number?, -- amount of seconds a user has to wait before sending another message (0-21600); bots, as well as users with the permission manage_messages or manage_channel, are unaffected
    recipients: { UserObject }?, -- the recipients of the DM
    icon: string?, -- icon hash of the group DM
    ownerId: Snowflake?, -- id of the creator of the group DM or thread
    applicationId: Snowflake?, -- application id of the group DM creator if it is bot-created
    managed: boolean?, -- for group DM channels: whether the channel is managed by an application via the gdm.join OAuth2 scope
    parentId: Snowflake?, -- for guild channels: id of the parent category for a channel (each parent category can contain up to 50 channels), for threads: id of the text channel this thread was created
    lastPinTimestamp: string?, -- when the last pinned message was pinned. This may be null in events such as GUILD_CREATE when a message is not pinned.
    rtcRegion: string?, -- voice region id for the voice channel, automatic when set to null
    videoQualityMode: VideoQualityMode?, -- the camera video quality mode of the voice channel, 1 when not present
    messageCount: number?, -- number of messages (not including the initial message or deleted messages) in a thread.
    memberCount: number?, -- an approximate count of users in a thread, stops counting at 50
    threadMetadata: ThreadMetadataObject?, -- thread-specific fields not needed by other channels
    member: ThreadMemberObject?, -- thread member object for the current user, if they have joined the thread, only included on certain API endpoints
    defaultAutoArchiveDuration: number?, -- default duration, copied onto newly created threads, in minutes, threads will stop showing in the channel list after the specified period of inactivity, can be set to: 60, 1440, 4320, 10080
    permissions: string?, -- computed permissions for the invoking user in the channel, including overwrites, only included when part of the resolved data received on a slash command interaction. This does not include implicit permissions, which may need to be checked separately
    flags: ChannelFlags?, -- channel flags combined as a bitfield
    totalMessageSent: number?, -- number of messages ever sent in a thread, it's similar to message_count on message creation, but will not decrement the number when a message is deleted
    availableTags: { ForumTagObject }?, -- the set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel
    appliedTags: { Snowflake }?, -- the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel
    defaultReactionEmoji: DefaultReactionObject?, -- the emoji to show in the add reaction button on a thread in a GUILD_FORUM or a GUILD_MEDIA channel
    defaultThreadRateLimitPerUser: number?, -- the initial rate_limit_per_user to set on newly created threads in a channel. this field is copied to the thread at creation time and does not live update.
    defaultSortOrder: SortOrderType?, -- the default sort order type used to order posts in GUILD_FORUM and GUILD_MEDIA channels. Defaults to null, which indicates a preferred sort order hasn't been set by a channel admin
    defaultForumLayout: ForumLayoutType?, -- the default forum layout view used to display posts in GUILD_FORUM channels. Defaults to 0, which indicates a layout view has not been set by a channel admin
}

-- https://discord.com/developers/docs/monetization/entitlements#entitlement-object
export type EntitlementObject = {
    id: Snowflake, -- ID of the entitlement
    skuId: Snowflake, -- ID of the SKU
    applicationId: Snowflake, -- ID of the parent application
    userId: Snowflake?, -- ID of the user that is granted access to the entitlement's sku
    type: EntitlementType, -- Type of entitlement
    deleted: boolean, -- Entitlement was deleted
    startsAt: string?, -- Start date at which the entitlement is valid. Not present when using test entitlements.
    endsAt: string?, -- Date at which the entitlement is no longer valid. Not present when using test entitlements.
    guildId: Snowflake?, -- ID of the guild that is granted access to the entitlement's sku
    consumed: boolean?, -- For consumable items, whether or not the entitlement has been consumed
}

-- https://discord.com/developers/docs/resources/voice#voice-state-object
export type VoiceStateObject = {
    guildId: Snowflake?, -- the guild id this voice state is for
    channelId: Snowflake?, -- the channel id this user is connected to
    userId: Snowflake, -- the user id this voice state is for
    member: GuildMemberObject?, -- the guild member this voice state is for
    sessionId: string, -- the session id for this voice state
    deaf: boolean, -- whether this user is deafened by the server
    mute: boolean, -- whether this user is muted by the server
    selfDeaf: boolean, -- whether this user is locally deafened
    selfMute: boolean, -- whether this user is locally muted
    selfStream: boolean?, -- whether this user is streaming using "Go Live"
    selfVideo: boolean, -- whether this user's camera is enabled
    suppress: boolean, -- whether this user's permission to speak is denied
    requestToSpeakTimestamp: string?, -- the time at which the user requested to speak
}

-- https://discord.com/developers/docs/topics/gateway-events#client-status-object
export type ClientStatusObject = {
    desktop: string?, -- User's status set for an active desktop (Windows, Linux, Mac) application session
    mobile: string?, -- User's status set for an active mobile (iOS, Android) application session
    web: string?, -- User's status set for an active web (browser, bot user) application session
}

-- https://discord.com/developers/docs/topics/gateway-events#presence-update
export type PresenceUpdateObject = {
    user: UserObject, -- User whose presence is being updated
    guild_id: Snowflake, -- ID of the guild
    status: string, -- Either "idle", "dnd", "online", or "offline"
    activities: { ActivityObject }, -- User's current activities
    client_status: ClientStatusObject, -- User's platform-dependent status
}

-- https://discord.com/developers/docs/resources/stage-instance#stage-instance-object
export type StageInstanceObject = {
    id: Snowflake, -- The id of this Stage instance
    guildId: Snowflake, -- The guild id of the associated Stage channel
    channelId: Snowflake, -- The id of the associated Stage channel
    topic: string, -- The topic of the Stage instance (1-120 characters)
    privacyLevel: PrivacyLevel, -- The privacy level of the Stage instance
    discoverableDisabled: boolean, -- Whether or not Stage Discovery is disabled (deprecated)
    guildScheduledEventId: Snowflake?, -- The id of the scheduled event for this Stage instance
}

-- https://discord.com/developers/docs/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-entity-metadata
export type GuildScheduledEventEntityMetadata = {
    location: string, -- location of the event (1-100 characters)
}

-- https://discord.com/developers/docs/resources/guild-scheduled-event#guild-scheduled-event-object
export type GuildScheduledEventObject = {
    id: Snowflake, -- the id of the scheduled event
    guildId: Snowflake, -- the guild id which the scheduled event belongs to
    channelId: Snowflake?, -- the channel id in which the scheduled event will be hosted, or null if scheduled entity type is EXTERNAL
    creatorId: Snowflake?, -- the id of the user that created the scheduled event
    name: string, -- the name of the scheduled event (1-100 characters)
    description: string?, -- the description of the scheduled event (1-1000 characters)
    scheduledStartTime: string, -- the time the scheduled event will start
    scheduledEndTime: string?, -- the time the scheduled event will end, required if entity_type is EXTERNAL
    privacyLevel: PrivacyLevel, -- the privacy level of the scheduled event
    status: GuildScheduledEventStatus, -- the status of the scheduled event
    entityType: GuildScheduledEventEntityType, -- the type of the scheduled event
    entityId: Snowflake?, -- the id of an entity associated with a guild scheduled event
    entityMetadata: GuildScheduledEventEntityMetadata?, -- additional metadata for the guild scheduled event
    creator: UserObject?, -- the user that created the scheduled event
    userCount: number, -- the number of users subscribed to the scheduled event
    image: string?, -- the cover image hash of the scheduled event
}

-- https://discord.com/developers/docs/resources/guild#integration-account-object
export type IntegrationAccountObject = {
    id: string, -- id of the account
    name: string, -- name of the account
}

-- https://discord.com/developers/docs/resources/guild#integration-object
export type IntegrationObject = {
    id: Snowflake, -- integration id
    name: string, -- integration name
    type: IntegrationType, -- integration type (twitch, youtube, discord, or guild_subscription)
    enabled: boolean, -- is this integration enabled
    syncing: boolean?, -- is this integration syncing
    roleId: Snowflake?, -- id that this integration uses for "subscribers"
    enableEmoticons: boolean?, -- whether emoticons should be synced for this integration (twitch only currently)
    expireBehaviour: IntegrationExpireBehaviours?, -- the behavior of expiring subscribers
    expireGracePeriod: number?, -- the grace period (in days) before expiring subscribers
    user: UserObject?, -- user for this integration
    account: IntegrationAccountObject, -- integration account information
    syncedAt: string?, -- when this integration was last synced
    subscriberCount: number?, -- how many subscribers this integration has
    revoked: boolean?, -- has this integration been revoked
    application: IntegrationApplicationObject?, -- The bot/OAuth2 application for discord integrations
    scopes: { OAuth2Scopes }?, -- the scopes the application has been authorized for
}

-- https://discord.com/developers/docs/resources/channel#channel-mention-object
export type ChannelMentionObject = {
    id: Snowflake, -- id of the channel
    guildId: Snowflake, -- id of the guild containing the channel
    type: ChannelType, -- the type of channel
    name: string, -- the name of the channel
}

-- https://discord.com/developers/docs/resources/channel#attachment-object
export type AttachmentObject = Partial<{
    id: Snowflake, -- attachment id
    filename: string, -- name of file attached
    title: string?, -- the title of the file
    description: string?, -- description for the file (max 1024 characters)
    contentType: string?, -- the attachment's media type
    size: number, -- size of file in bytes
    url: string, -- source url of file
    proxyUrl: string, -- a proxied url of file
    height: number?, -- height of file (if image)
    width: number?, -- width of file (if image)
    ephemeral: boolean?, -- whether this attachment is ephemeral
    durationSecs: number?, -- the duration of the audio file (currently for voice messages)
    waveform: string?, -- base64 encoded bytearray representing a sampled waveform (currently for voice messages)
    flags: number, -- attachment flags combined as a bitfield
}>

-- https://discord.com/developers/docs/resources/channel#embed-object-embed-footer-structure
export type EmbedFooterObject = {
    text: string, -- footer text
    iconUrl: string?, -- url of footer icon (only supports http(s) and attachments)
    proxyIconUrl: string?, -- a proxied url of footer icon
}

-- https://discord.com/developers/docs/resources/channel#embed-object-embed-image-structure
export type EmbedImageObject = {
    url: string, -- source url of image (only supports http(s) and attachments)
    proxyUrl: string?, -- a proxied url of the image
    height: number?, -- height of image
    width: number?, -- width of image
}

-- https://discord.com/developers/docs/resources/channel#embed-object-embed-provider-structure
export type EmbedProviderObject = {
    name: string?, -- name of provider
    url: string?, -- url of provider
}

-- https://discord.com/developers/docs/resources/channel#embed-object-embed-author-structure
export type EmbedAuthorObject = {
    name: string, -- name of author
    url: string?, -- url of author (only supports http(s))
    iconUrl: string?, -- url of author icon (only supports http(s) and attachments)
    proxyIconUrl: string?, -- a proxied url of author icon
}

-- https://discord.com/developers/docs/resources/channel#embed-object-embed-field-structure
export type EmbedFieldObject = {
    name: string, -- name of the field
    value: string, -- value of the field
    inline: boolean?, -- whether or not this field should display inline
}

-- https://discord.com/developers/docs/resources/channel#embed-object-embed-thumbnail-structure
export type EmbedThumbnailObject = {
    url: string, -- source url of thumbnail (only supports http(s) and attachments)
    proxyUrl: string?, -- a proxied url of the thumbnail
    height: number?, -- height of thumbnail
    width: number?, -- width of thumbnail
}

-- https://discord.com/developers/docs/resources/channel#embed-object-embed-video-structure
export type EmbedVideoObject = {
    url: string, -- source url of video
    proxyUrl: string?, -- a proxied url of the video
    height: number?, -- height of video
    width: number?, -- width of video
}

-- https://discord.com/developers/docs/resources/message#embed-object
export type EmbedObject = {
    title: string?, -- title of embed
    type: EmbedType?, -- type of embed (always "rich" for webhook embeds)
    description: string?, -- description of embed
    url: string?, -- url of embed
    timestamp: string?, -- timestamp of embed content
    color: number?, -- color code of the embed
    footer: EmbedFooterObject?, -- footer information
    image: EmbedImageObject?, -- image information
    thumbnail: EmbedThumbnailObject?, -- thumbnail information
    video: EmbedVideoObject?, -- video information
    provider: EmbedProviderObject?, -- provider information
    author: EmbedAuthorObject?, -- author information
    fields: { EmbedFieldObject }?, -- fields information, max of 25
}

-- https://discord.com/developers/docs/resources/channel#reaction-count-details-object
export type ReactionCountDetailsObject = {
    burst: number, -- Count of super reactions
    normal: number, -- Count of normal reactions
}

-- https://discord.com/developers/docs/resources/channel#reaction-object
export type ReactionObject = {
    count: number, -- Total number of times this emoji has been used to react (including super reacts)
    count_details: ReactionCountDetailsObject, -- Reaction count details object
    me: boolean, -- Whether the current user reacted using this emoji
    me_burst: boolean, -- Whether the current user super-reacted using this emoji
    emoji: EmojiObject, -- emoji information
    burst_colors: { string }, -- HEX colors used for super reaction
}

-- https://discord.com/developers/docs/resources/channel#message-object-message-activity-structure
export type MessageActivityObject = {
    type: MessageActivityType, -- 	type of message activity
    partyId: string, -- party_id from a Rich Presence event
}

-- https://discord.com/developers/docs/resources/channel#message-reference-object-message-reference-structure
export type MessageReferenceObject = {
    type: MessageReferenceType?, -- type of reference.
    messageId: Snowflake?, -- id of the originating message
    channelId: Snowflake?, -- id of the originating message's channel
    guildId: Snowflake?, -- id of the originating message's guild
    failIfNotExists: boolean?, -- when sending, whether to error if the referenced message doesn't exist instead of sending as a normal (non-reply) message, default true
}

-- https://discord.com/developers/docs/resources/channel#message-interaction-metadata-object-message-interaction-metadata-structure
export type MessageInteractionMetadataObject = {
    id: Snowflake, -- ID of the interaction
    type: InteractionType, -- Type of interaction
    user: UserObject, -- User who triggered the interaction
    authorizingIntegrationOwners: { [ApplicationIntegrationType]: Snowflake }, -- IDs for installation context(s) related to an interaction. Details in Authorizing Integration Owners Object
    originalResponseMessageId: Snowflake?, -- ID of the original response message, present only on follow-up messages
    interactedMessageId: Snowflake?, -- ID of the message that contained interactive component, present only on messages created from component interactions
    triggeringInteractionMetadata: MessageInteractionMetadataObject, -- Metadata for the interaction that was used to open the modal, present only on modal submit interactions
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#message-interaction-object-message-interaction-structure
export type MessageInteractionObject = {
    id: string, -- ID of the interaction
    type: InteractionType, -- Type of interaction
    name: string, -- Name of the application command, including subcommands and subcommand groups
    user: UserObject, -- User who invoked the interaction
    member: GuildMemberObject?, -- Member who invoked the interaction in the guild
}

-- https://discord.com/developers/docs/interactions/message-components#select-menu-object-select-option-structure
export type SelectOptionObject = {
    label: string, -- User-facing name of the option; max 100 characters
    value: string, -- Dev-defined value of the option; max 100 characters
    description: string?, -- Additional description of the option; max 100 characters
    emoji: EmojiObject?, -- id, name, and animated
    default: boolean, -- Will show this option as selected by default
}

-- https://discord.com/developers/docs/interactions/message-components#select-menu-object-select-default-value-structure
export type SelectDefaultValueObject = {
    id: Snowflake, -- ID of a user, role, or channel
    type: string, -- Type of value that id represents. Either "user", "role", or "channel"
}

-- https://discord.com/developers/docs/interactions/message-components#action-rows
export type ActionRowComponentObject = {
    type: number, -- 1 for an action row.
    components: { ComponentObjects }, -- range of component objects
}

-- https://discord.com/developers/docs/interactions/message-components#button-object
export type ButtonComponentObject = Partial<{
    type: number, -- 2 for a button
    style: ButtonStyle, -- A button style
    label: string?, -- Text that appears on the button; max 80 characters
    emoji: EmojiObject?, -- name, id, and animated
    customId: string?, -- Developer-defined identifier for the button; max 100 characters
    skuId: string?, -- Identifier for a purchasable SKU, only available when using premium-style buttons
    url: string?, --  URL for link-style buttons
    disabled: boolean?, -- Whether the button is disabled (defaults to false)
}>

-- https://discord.com/developers/docs/interactions/message-components#select-menu-object
export type SelectMenuComponentObject = {
    type: number, -- Type of select menu component (text: 3, user: 5, role: 6, mentionable: 7, channels: 8)
    customId: string, -- ID for the select menu; max 100 characters
    options: { SelectOptionObject }?, -- Specified choices in a select menu (only required and available for string selects (type 3); max 25
    channelTypes: { ChannelType }?, -- List of channel types to include in the channel select component (type 8)
    placeholder: string?, -- Placeholder text if nothing is selected; max 150 characters
    defaultValues: { SelectDefaultValueObject }?, -- List of default values for auto-populated select menu components; number of default values must be in the range defined by min_values and max_values
    minValues: number?, -- Minimum number of items that must be chosen (defaults to 1); min 0, max 25
    maxValues: number?, -- Maximum number of items that can be chosen (defaults to 1); max 25
    disabled: boolean?, -- Whether select menu is disabled (defaults to false)
}

-- https://discord.com/developers/docs/interactions/message-components#select-menu-object
export type TextInputComponentObject = {
    type: number, -- 4 for a text input
    customId: string, -- Developer-defined identifier for the input; max 100 characters
    style: TextInputStyles, -- The Text Input Style
    label: string, -- Label for this component; max 45 characters
    minLength: number?, -- Minimum input length for a text input; min 0, max 4000
    maxLength: number?, -- Maximum input length for a text input; min 1, max 4000
    required: boolean?, -- Whether this component is required to be filled (defaults to true)
    value: string?, -- Pre-filled value for this component; max 4000 characters
    placeholder: string?, -- Custom placeholder text if the input is empty; max 100 characters
}

-- https://discord.com/developers/docs/interactions/message-components#message-components
export type ComponentObjects =
    ActionRowComponentObject
    | ButtonComponentObject
    | SelectMenuComponentObject
    | TextInputComponentObject

-- https://discord.com/developers/docs/resources/sticker#sticker-item-object
export type StickerItemObject = {
    id: Snowflake, -- id of the sticker
    name: string, -- name of the sticker
    formatType: StickerFormatType, -- 	type of sticker format
}

-- https://discord.com/developers/docs/resources/channel#role-subscription-data-object
export type RoleSubscriptionDataObject = {
    roleSubscriptionListingId: Snowflake, -- the id of the sku and listing that the user is subscribed to
    tierName: string, -- the name of the tier that the user is subscribed to
    totalMonthsSubscribed: number, -- the cumulative number of months that the user has been subscribed for
    isRenewal: boolean, -- whether this notification is for a renewal rather than a new purchase
}

-- https://discord.com/developers/docs/resources/poll#poll-media-object-poll-media-object-structure
export type PollMediaObject = {
    text: string?, -- The text of the field
    emoji: Partial<EmojiObject>?, -- The emoji of the field
}

-- https://discord.com/developers/docs/resources/poll#poll-answer-object-poll-answer-object-structure
export type PollAnswerObject = {
    answerId: number, -- The ID of the answer
    pollMedia: PollMediaObject, -- The data of the answer
}

-- https://discord.com/developers/docs/resources/poll#poll-results-object-poll-answer-count-object-structure
export type PollAnswerCountObject = {
    id: number, -- The answer_id
    count: number, -- The number of votes for this answer
    meVoted: boolean, -- Whether the current user voted for this answer
}

-- https://discord.com/developers/docs/resources/poll#poll-results-object-poll-results-object-structure
export type PollResultObject = {
    isFinalized: boolean, -- Whether the votes have been precisely counted
    answerCounts: { PollAnswerCountObject }, -- The counts for each answer
}

-- https://discord.com/developers/docs/resources/poll#poll-object
export type PollObject = {
    question: PollMediaObject, -- The question of the poll. Only text is supported.
    answers: { PollAnswerObject }, -- Each of the answers available in the poll.
    expiry: string?, -- The time when the poll ends.
    allowMultiselect: boolean, -- Whether a user can select multiple answers
    layoutType: PollLayoutType, -- The layout type of the poll
    results: PollResultObject?, -- The results of the poll
}

-- https://discord.com/developers/docs/resources/channel#message-call-object
export type MessageCallObject = {
    participants: { UserObject }, -- array of user object ids that participated in the call
    endedTimestamp: string, -- time when call ended
}

-- https://discord.com/developers/docs/resources/channel#message-object
export type MessageObject = {
    id: Snowflake?, -- id of the message
    channelId: Snowflake?, -- id of the channel the message was sent in
    author: UserObject?, -- the author of this message (not guaranteed to be a valid user, see below)
    content: string?, -- contents of the message
    timestamp: string?, -- when this message was sent
    editedTimestamp: string?, -- when this message was edited (or null if never)
    tts: boolean?, -- whether this was a TTS message
    mentionEveryone: boolean?, -- whether this message mentions everyone
    mentions: { UserObject }?, -- users specifically mentioned in the message
    mentionRoles: { GuildRoleObject }?, -- roles specifically mentioned in this message
    mentionChannels: { ChannelMentionObject }?, -- channels specifically mentioned in this message
    attachments: { AttachmentObject }?, -- any attached files
    embeds: { EmbedObject }?, -- any embedded content
    reactions: { ReactionObject }?, -- reactions to the message
    nonce: string?, -- used for validating a message was sent
    pinned: boolean?, -- whether this message is pinned
    webhookId: Snowflake?, -- if the message is generated by a webhook, this is the webhook's id
    type: MessageType?, -- type of message
    activity: MessageActivityObject?, -- sent with Rich Presence-related chat embeds
    application: ApplicationObject?, -- sent with Rich Presence-related chat embeds
    applicationId: Snowflake?, -- if the message is an Interaction or application-owned webhook, this is the id of the application
    messageReference: MessageReferenceObject?, -- data showing the source of a crosspost, channel follow add, pin, or reply message
    flags: number?, -- message flags combined as a bitfield
    referencedMessage: MessageObject?, -- the message associated with the message_reference
    interactionMetadata: MessageInteractionMetadataObject?, -- In preview. Sent if the message is sent as a result of an interaction
    interaction: MessageInteractionObject?, -- Deprecated in favor of interaction_metadata; sent if the message is a response to an interaction
    thread: ChannelObject?, -- the thread that was started from this message, includes thread member object
    components: { ComponentObjects }?, -- sent if the message contains components like buttons, action rows, or other interactive components
    stickerItems: { StickerItemObject }?, -- sent if the message contains stickers
    stickers: { StickerObject }?, -- Deprecated the stickers sent with the message
    position: number?, -- A generally increasing integer (there may be gaps or duplicates) that represents the approximate position of the message in a thread, it can be used to estimate the relative position of the message in a thread in company with total_message_sent on parent thread
    roleSubscriptionData: RoleSubscriptionDataObject?, -- data of the role subscription purchase or renewal that prompted this ROLE_SUBSCRIPTION_PURCHASE message
    resolved: ResolvedDataStructure?, -- data for users, members, channels, and roles in the message's auto-populated select menus
    poll: PollObject?, -- the poll associated with the message
    call: MessageCallObject?, -- the call associated with the message
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-resolved-data-structure
export type ResolvedDataStructure = {
    users: { UserObject }?, -- the ids and User objects
    members: { GuildMemberObject }?, -- the ids and partial Member objects
    roles: { GuildRoleObject }?, -- the ids and Role objects
    channels: { ChannelObject }?, -- the ids and partial Channel objects
    messages: { MessageObject }?, -- the ids and partial Message objects
    attachments: { AttachmentObject }?, -- the ids and attachment objects
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-application-command-interaction-data-option-structure]
export type ApplicationCommandInteractionDataOptionObject = {
    name: string, -- Name of the parameter
    type: ApplicationCommandOptionType, -- Value of application command option type
    value: (string | number | boolean)?, -- Value of the option resulting from user input
    options: { ApplicationCommandInteractionDataOptionObject }, -- Present if this option is a group or subcommand
    focused: boolean, -- true if this option is the currently focused option for autocomplete
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-data
export type InteractionDataObject = {
    id: Snowflake, -- the ID of the invoked command
    name: string, -- the name of the invoked command
    type: number, -- the type of the invoked command
    resolved: ResolvedDataStructure?, -- converted users + roles + channels + attachments
    options: { ApplicationCommandInteractionDataOptionObject }?, -- the params + values from the user
    guild_id: Snowflake?, -- the id of the guild the command is registered to
    target_id: Snowflake?, -- id of the user or message targeted by a user or message command,

    custom_id: string?, -- custom_id of the component
    component_type: number?, -- type of the component
    values: { SelectOptionObject }?, -- Values the user selected in a select menu component

    components: { ComponentObjects }?, -- Resolved entities from selected options
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-structure
export type InteractionObject = {
    id: Snowflake, -- ID of the interaction
    application_id: Snowflake, -- ID of the application this interaction is for
    type: InteractionType, -- Type of interaction
    data: InteractionDataObject?, -- Interaction data payload
    guild: GuildObject?, -- Guild that the interaction was sent from
    guild_id: Snowflake?, -- Guild that the interaction was sent from
    channel: ChannelObject?, -- Channel that the interaction was sent from
    channel_id: Snowflake?, -- Channel that the interaction was sent from
    member: GuildMemberObject?, -- Guild member data for the invoking user, including permissions
    user: UserObject?, -- User object for the invoking user, if invoked in a DM
    token: string, -- Continuation token for responding to the interaction
    version: number, -- Read-only property, always 1
    message: MessageObject?, -- For components, the message they were attached to
    app_permissions: string, -- Bitwise set of permissions the app has in the source location of the interaction
    locale: LanguageLocales?, -- Selected language of the invoking user
    guild_locale: LanguageLocales?, -- Guild's preferred locale, if invoked in a guild
    entitlements: { EntitlementObject }, -- For monetized apps, any entitlements for the invoking user, representing access to premium SKUs
    authorizing_integration_owners: { IntegrationType }, -- Mapping of installation contexts that the interaction was authorized for to related user or guild IDs. See Authorizing Integration Owners Object for details
    context: InteractionContextType, -- Context where the interaction was triggered from
}

-- https://discord.com/developers/docs/resources/application-role-connection-metadata#application-role-connection-metadata-object
export type ApplicationRoleConnectionMetadataObject = {
    type: ApplicationRoleConnectionMetadataType, -- type of metadata value
    key: string, -- dictionary key for the metadata field (must be a-z, 0-9, or _ characters; 1-50 characters)
    name: string, -- name of the metadata field (1-100 characters)
    nameLocalizations: { [LanguageLocales]: string }?, -- translations of the name
    description: string, -- description of the metadata field (1-200 characters)
    descriptionLocalizations: { [LanguageLocales]: string }?, -- translations of the description
}

-- https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-choice-structure
export type ApplicationCommandOptionChoiceObject = {
    name: string, -- 1-100 character choice name
    nameLocalizations: { [LanguageLocales]: string }?, -- Localization dictionary for the name field. Values follow the same restrictions as name
    value: string | number, -- Value for the choice, up to 100 characters if string
}

-- https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-structure
export type ApplicationCommandOptionObject = {
    type: ApplicationCommandOptionType, -- Type of option
    name: string, -- 1-32 character name
    nameLocalizations: { [LanguageLocales]: string }?, -- Localization dictionary for the name field. Values follow the same restrictions as name
    description: string?, -- 1-100 character description
    descriptionLocalizations: { [LanguageLocales]: string }?, -- Localization dictionary for the description field. Values follow the same restrictions as description
    required: boolean?, -- Whether the parameter is required or optional, default false
    choices: { ApplicationCommandOptionChoiceObject }, -- Choices for the user to pick from, max 25
    options: { ApplicationCommandOptionObject }?, -- If the option is a subcommand or subcommand group type, these nested options will be the parameters or subcommands respectively; up to 25
    channelTypes: { ChannelType }?, -- The channels shown will be restricted to these types
    minValue: number?, -- The minimum value permitted
    maxValue: number?, -- The maximum value permitted
    minLength: number?, -- The minimum allowed length (minimum of 0, maximum of 6000)
    maxLength: number?, -- The maximum allowed length (minimum of 1, maximum of 6000)
    autocomplete: boolean?, -- If autocomplete interactions are enabled for this option
}

-- https://discord.com/developers/docs/interactions/application-commands#application-command-object
export type ApplicationCommandObject = {
    id: Snowflake?, -- Unique ID of command
    type: ApplicationCommandType?, -- Type of command, defaults to 1
    applicationId: Snowflake?, -- ID of the parent application
    guildId: Snowflake?, -- Guild ID of the command, if not global
    name: string, -- Name of command, 1-32 characters
    nameLocalizations: { [LanguageLocales]: string }?, -- Localization dictionary for name field. Values follow the same restrictions as name
    description: string, -- Description for CHAT_INPUT commands, 1-100 characters. Empty string for USER and MESSAGE commands
    descriptionLocalizations: { [LanguageLocales]: string }?, -- Localization dictionary for description field. Values follow the same restrictions as description
    options: { ApplicationCommandOptionObject }?, -- Parameters for the command, max of 25
    defaultMemberPermissions: string?, -- Set of permissions represented as a bit set
    dmPermission: string?, -- Deprecated (use contexts instead); Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
    defaultPermission: boolean?, -- Not recommended for use as field will soon be deprecated. Indicates whether the command is enabled by default when the app is added to a guild, defaults to true
    nsfw: boolean?, -- Indicates whether the command is age-restricted, defaults to false
    integrationTypes: { IntegrationType }?, -- Installation contexts where the command is available, only for globally-scoped commands. Defaults to your app's configured contexts
    contexts: { InteractionContextType }?, -- Interaction context(s) where the command can be used, only for globally-scoped commands. By default, all interaction context types included for new commands.
    version: Snowflake?, -- Autoincrementing version identifier updated during substantial record changes
}

-- https://discord.com/developers/docs/resources/audit-log#audit-log-change-object
export type AuditLogChangeObject = {
    newValue: any?, -- New value of the key
    oldValue: any?, -- Old value of the key
    key: string, -- Name of the changed entity, with a few exceptions
}

-- https://discord.com/developers/docs/resources/audit-log#audit-log-entry-object-optional-audit-entry-info
export type OptionalAuditEntryInfoObject = {
    applicationId: Snowflake, -- ID of the app whose permissions were targeted
    autoModerationRuleName: string, -- Name of the Auto Moderation rule that was triggered
    autoModerationRuleTriggerType: AutomoderationRuleTriggerType, -- Trigger type of the Auto Moderation rule that was triggered
    channelId: Snowflake, -- Channel in which the entities were targeted
    count: string, -- Number of entities that were targeted
    deleteMemberDays: string, -- Number of days after which inactive members were kicked
    id: Snowflake, -- ID of the overwritten entity
    membersRemoved: string, -- Number of members removed by the prune
    messageId: Snowflake, -- ID of the message that was targeted
    roleName: string, -- Name of the role if type is "0" (not present if type is "1")
    type: string, -- Type of overwritten entity - role ("0") or member ("1")
    integrationType: IntegrationType, -- The type of integration which performed the action
}

-- https://discord.com/developers/docs/resources/audit-log#audit-log-entry-object
export type AuditLogEntryObject = {
    targetId: string?, -- ID of the affected entity (webhook, user, role, etc.)
    changes: { AuditLogChangeObject }?, -- Changes made to the target_id
    userId: Snowflake?, -- User or app that made the changes
    id: Snowflake, -- ID of the entry
    actionType: AuditLogEventType, -- Type of action that occurred
    options: { OptionalAuditEntryInfoObject }?, -- Additional info for certain event types
    reason: string?, -- Reason for the change (1-512 characters)
}

-- https://discord.com/developers/docs/resources/webhook#webhook-object
export type WebhookObject = {
    id: Snowflake, -- the id of the webhook
    type: WebhookType, -- the type of the webhook
    guildId: Snowflake?, -- the guild id this webhook is for, if any
    channelId: Snowflake?, -- the channel id this webhook is for, if any
    user: UserObject?, -- the user this webhook was created by (not returned when getting a webhook with its token)
    name: string?, -- the default name of the webhook
    avatar: string?, -- the default user avatar hash of the webhook
    token: string?, -- the secure token of the webhook (returned for Incoming Webhooks)
    applicationId: Snowflake?, -- the bot/OAuth2 application that created this webhook
    sourceGuild: GuildObject?, -- the guild of the channel that this webhook is following (returned for Channel Follower Webhooks)
    sourceChannel: ChannelObject?, -- the channel that this webhook is following (returned for Channel Follower Webhooks)
    url: string?, -- the url used for executing the webhook (returned by the webhooks OAuth2 flow)
}

-- https://discord.com/developers/docs/resources/audit-log#audit-log-object
export type AuditLogObject = {
    applicationCommands: { ApplicationCommandObject }, -- List of application commands referenced in the audit log
    auditLogEntries: { AuditLogEntryObject }, -- List of audit log entries, sorted from most to least recent
    autoModerationRules: { AutomoderationRuleObject }, -- List of auto moderation rules referenced in the audit log
    guildScheduledEvents: { GuildScheduledEventObject }, -- List of guild scheduled events referenced in the audit log
    integrations: { IntegrationObject }, -- List of partial integration objects
    threads: { ChannelObject }, -- List of threads referenced in the audit log*
    users: { UserObject }, -- List of users referenced in the audit log
    webhooks: { WebhookObject }, -- List of webhooks referenced in the audit log
}

-- https://discord.com/developers/docs/resources/invite#invite-object
export type InviteObject = {
    type: InviteTypes, -- the type of invite
    code: string, -- the invite code (unique ID)
    guild: GuildObject?, -- the guild this invite is for
    channel: ChannelObject?, -- the channel this invite is for
    inviter: UserObject?, -- the user who created the invite
    targetType: InviteTargetTypes, -- the type of target for this voice channel invite
    targetUser: UserObject?, -- the user whose stream to display for this voice channel stream invite
    targetApplication: ApplicationObject?, -- the embedded application to open for this voice channel embedded application invite
    approximatePresenceCount: number?, -- approximate count of online members, returned from the GET /invites/<code> endpoint when with_counts is true
    approximateMemberCount: number?, -- approximate count of total members, returned from the GET /invites/<code> endpoint when with_counts is true
    expiresAt: string?, -- the expiration date of this invite, returned from the GET /invites/<code> endpoint when with_expiration is true
    stageInstance: StageInstanceObject?, -- stage instance data if there is a public Stage instance in the Stage channel this invite is for (deprecated)
    guildScheduledEvent: GuildScheduledEventObject?, -- guild scheduled event data, only included if guild_scheduled_event_id contains a valid guild scheduled event id
}

-- https://discord.com/developers/docs/resources/guild#get-guild-vanity-url
export type GuildVanityUrl = {
    code: string,
    uses: number,
}

-- https://discord.com/developers/docs/resources/invite#invite-metadata-object
export type InviteMetadataObject = {
    uses: number, -- number of times this invite has been used
    maxUses: number, -- max number of times this invite can be used
    maxAge: number, -- duration (in seconds) after which the invite expires
    temporary: boolean, -- whether this invite only grants temporary membership
    createdAt: string, -- when this invite was created
}

-- https://discord.com/developers/docs/resources/channel#followed-channel-object
export type FollowedChannelObject = {
    channel_id: Snowflake, -- source channel id
    webhook_id: Snowflake, -- created target webhook id
}

-- https://discord.com/developers/docs/resources/guild#guild-preview-object
export type GuildPreviewObject = {
    id: Snowflake, -- guild id
    name: string, -- guild name (2-100 characters)
    icon: string?, -- icon hash
    splash: string?, -- splash hash
    discoverySplash: string?, -- discovery splash hash
    emojis: { EmojiObject }, -- custom guild emojis
    features: { GuildFeature }, -- enabled guild features
    approximateMemberCount: number, -- approximate number of members in this guild
    approximatePresenceCount: number, -- approximate number of online members in this guild
    description: string?, -- the description for the guild
    stickers: { StickerObject }, -- custom guild stickers
}

-- https://discord.com/developers/docs/resources/guild#ban-object
export type BanObject = {
    reason: string?, -- the reason for the ban
    user: UserObject, -- the banned user=
}

-- https://discord.com/developers/docs/resources/voice#voice-region-object
export type VoiceRegionObject = {
    id: string, -- unique ID for the region
    name: string, -- name of the region
    optimal: boolean, -- true for a single server that is closest to the current user's client
    deprecated: boolean, -- whether this is a deprecated voice region (avoid switching to these)
    custom: boolean, -- whether this is a custom voice region (used for events/etc)
}

-- https://discord.com/developers/docs/resources/guild#guild-widget-settings-object
export type GuildWidgetSettingsObject = {
    enabled: boolean?, -- whether the widget is enabled
    channelId: Snowflake?, -- the widget channel id
}

-- https://discord.com/developers/docs/resources/guild#guild-widget-object
export type GuildWidgetObject = {
    id: Snowflake, -- guild id
    name: string, -- guild name (2-100 characters)
    instantInvite: string?, -- instant invite for the guilds specified widget invite channel
    channels: { ChannelObject }, -- voice and stage channels which are accessible by @everyone
    members: { UserObject }, -- special widget user objects that includes users presence (Limit 100)
    presenceCount: number, -- number of online members in this guild
}

-- https://discord.com/developers/docs/resources/guild#guild-onboarding-object-prompt-option-structure
export type PromptOptionObject = {
    id: Snowflake?, -- ID of the prompt option
    channelIds: { Snowflake }, -- IDs for channels a member is added to when the option is selected
    roleIds: { Snowflake }, -- IDs for roles assigned to a member when the option is selected
    emoji: EmojiObject | nil, -- Emoji of the option (see below)
    emojiId: Snowflake?, -- Emoji ID of the option (see below)
    emojiName: string?, -- Emoji name of the option (see below)
    emojiAnimated: boolean?, -- Whether the emoji is animated (see below)
    title: string?, -- Title of the option
    description: string?, -- Description of the option
}

-- https://discord.com/developers/docs/resources/guild#guild-onboarding-object-onboarding-prompt-structure
export type OnboardingPromptObject = {
    id: Snowflake | nil, -- ID of the prompt
    type: PromptTypes?, -- Type of prompt
    options: { PromptOptionObject }, -- Options available within the prompt
    title: string?, -- Title of the prompt
    singleSelect: boolean?, -- Indicates whether users are limited to selecting one option for the prompt
    required: boolean?, -- Indicates whether the prompt is required before a user completes the onboarding flow
    inOnboarding: boolean?, -- Indicates whether the prompt is present in the onboarding flow. If false, the prompt will only appear in the Channels & Roles tab
}

-- https://discord.com/developers/docs/resources/guild#guild-onboarding-object
export type GuildOnboardingObject = {
    guildId: Snowflake, -- ID of the guild this onboarding is part of
    prompts: { OnboardingPromptObject }, -- Prompts shown during onboarding and in customize community
    defaultChannelIds: { Snowflake }, -- Channel IDs that members get opted into automatically
    enabled: boolean, -- Whether onboarding is enabled in the guild
    mode: OnboardingMode, -- Current mode of onboarding
}

-- https://discord.com/developers/docs/resources/guild-scheduled-event#guild-scheduled-event-user-object
export type GuildScheduledEventUserObject = {
    guild_scheduled_event_id: Snowflake, -- the scheduled event id which the user subscribed to
    user: UserObject, -- user which subscribed to an event
    member: GuildMemberObject?, -- guild member data for this user for the guild which this event belongs to, if any
}

-- https://discord.com/developers/docs/resources/guild-template#guild-template-object
export type GuildTemplateObject = {
    code: string, -- the template code (unique ID)
    name: string, -- template name
    description: string?, -- the description for the template
    usageCount: number, -- number of times this template has been used
    creatorId: Snowflake, -- the ID of the user who created the template
    creator: UserObject, -- the user who created the template
    createdAt: string, -- when this template was created
    updatedAt: string, -- when this template was last synced to the source guild
    sourceGuildId: Snowflake, -- the ID of the guild this template is based on
    serializedSourceGuild: GuildObject, -- the guild snapshot this template contains
    isDirty: boolean?, -- whether the template has unsynced changes
}

-- https://discord.com/developers/docs/resources/sticker#sticker-pack-object
export type StickerPackObject = {
    id: Snowflake, -- id of the sticker pack
    stickers: { StickerObject }, -- the stickers in the pack
    name: string, -- name of the sticker pack
    skuId: Snowflake, -- id of the pack's SKU
    coverStickerId: Snowflake?, -- id of a sticker in the pack which is shown as the pack's icon
    description: string, -- description of the sticker pack
    bannerAssetId: Snowflake?, -- id of the sticker pack's banner image
}

-- https://discord.com/developers/docs/resources/guild#integration-application-object
export type IntegrationApplicationObject = {
    id: Snowflake, -- the id of the app
    name: string, -- the name of the app
    icon: string?, -- the icon hash of the app
    description: string, -- the description of the app
    bot: UserObject?, -- the bot associated with this application
}

-- https://discord.com/developers/docs/resources/user#connection-object
export type ConnectionObject = {
    id: string, -- id of the connection account
    name: string, -- the username of the connection account
    type: ConnectionObjectServices, -- the service of this connection
    revoked: boolean?, -- whether the connection is revoked
    integrations: { IntegrationObject }?, -- an array of partial server integrations
    verified: boolean, -- whether the connection is verified
    friendSync: boolean, -- whether friend sync is enabled for this connection
    showActivity: boolean, -- whether activities related to this connection will be shown in presence updates
    twoWayLink: boolean, -- whether this connection has a corresponding third party OAuth2 token
    visibility: ConnectionVisibilityTypes, -- visibility of this connection
}

-- https://discord.com/developers/docs/resources/application#get-application-activity-instance-activity-location-object
export type ActivityLocationObject = {
    id: string,
    kind: "gc" | "pc",
    channelId: Snowflake,
    guildId: Snowflake?
}

-- https://discord.com/developers/docs/resources/user#application-role-connection-object
export type ApplicationRoleConnectionObject = {
    platformName: string?, -- the vanity name of the platform a bot has connected (max 50 characters)
    platformUsername: string?, -- the username on the platform a bot has connected (max 100 characters)
    metadata: ApplicationRoleConnectionMetadataObject, -- object mapping application role connection metadata keys to their string-ified value (max 100 characters) for the user on the platform a bot has connected
}

-- https://discord.com/developers/docs/topics/gateway#session-start-limit-object
export type SessionStartLimitObject = {
    total: number, -- Total number of session starts the current user is allowed
    remaining: number, -- Remaining number of session starts the current user is allowed
    resetAfter: number, -- Number of milliseconds after which the limit resets
    maxConcurrency: number, -- Number of identify requests allowed per 5 seconds
}

-- https://discord.com/developers/docs/resources/channel#allowed-mentions-object
export type AllowedMentionObject = {
    parse: { AllowedMentionTypes }?, -- An array of allowed mention types to parse from the content.
    users: { string }?, -- Array of role_ids to mention (Max size of 100)
    roles: { string }?, -- Array of user_ids to mention (Max size of 100)
    repliedUser: boolean?, -- For replies, whether to mention the author of the message being replied to (default false)
}

-- https://discord.com/developers/docs/resources/channel#start-thread-in-forum-or-media-channel-forum-and-media-thread-message-params-object
export type ForumAndMediaThreadMessageObject = {
    content: string?, -- Message contents (up to 2000 characters)
    embeds: { EmbedObject }?, -- Up to 10 rich embeds (up to 6000 characters)
    allowedMentions: AllowedMentionObject?, -- Allowed mentions for the message
    components: { ComponentObjects }?, -- Components to include with the message
    stickerIds: { Snowflake }?, -- IDs of up to 3 stickers in the server to send in the message
    attachments: { AttachmentObject }?, -- Attachment objects with filename and description. See Uploading Files
    flags: number?, -- Message flags combined as a bitfield (only SUPPRESS_EMBEDS and SUPPRESS_NOTIFICATIONS can be set)
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-data-structure
export type InteractionCallbackAutocompleteObject = {
    choices: { ApplicationCommandOptionChoiceObject }?, -- autocomplete choices (max of 25 choices)
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-data-structure
export type InteractionCallbackModalObject = {
    customId: string?, -- Developer-defined identifier for the modal, max 100 characters
    title: string?, -- Title of the popup modal, max 45 characters
    components: { ComponentObjects }, -- Between 1 and 5 (inclusive) components that make up the modal
}

-- https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-response-object-interaction-callback-type
export type InteractionResponseObject = {
    type: InteractionCallbackType, -- the type of response
    data: (Partial<MessageObject> | InteractionCallbackAutocompleteObject | InteractionCallbackModalObject)?, -- an optional response message
}

return {}