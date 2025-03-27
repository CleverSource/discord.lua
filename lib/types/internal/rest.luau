-- camelCase types are preferred for internal types; these are a representation of the Discord API

export type AddDmRecipientOptions = {
    accessToken: string,
    nick: string?
}

export type CreateAutomodRuleOptions = {
    name: string,
    eventType: number,
    triggerType: number,
    triggerMetadata: {
        keywordFilter: { string }?,
        regexPatterns: { string }?,
        presets: { number }?,
        allowList: { string }?,
        mentionTotalLimit: number?
    },
    actions: { 
        [number]: {
            type: number,
            metadata: {
                channelId: string?,
                durationSeconds: number?
            }?
        }
    },
    enabled: boolean?,
    exemptRoles: { string }?,
    exemptChannels: { string }?
}

export type PermissionStrings = "CREATE_INSTANT_INVITE"
                                | "KICK_MEMBERS"
                                | "BAN_MEMBERS"
                                | "ADMINISTRATOR"
                                | "MANAGE_CHANNELS"
                                | "MANAGE_GUILD"
                                | "ADD_REACTIONS"
                                | "VIEW_AUDIT_LOG"
                                | "PRIORITY_SPEAKER"
                                | "STREAM"
                                | "VIEW_CHANNEL"
                                | "SEND_MESSAGES"
                                | "SEND_TTS_MESSAGES"
                                | "MANAGE_MESSAGES"
                                | "EMBED_LINKS"
                                | "ATTACH_FILES"
                                | "READ_MESSAGE_HISTORY"
                                | "MENTION_EVERYONE"
                                | "USE_EXTERNAL_EMOJIS"
                                | "VIEW_GUILD_INSIGHTS"
                                | "CONNECT"
                                | "SPEAK"
                                | "MUTE_MEMBERS"
                                | "DEAFEN_MEMBERS"
                                | "MOVE_MEMBERS"
                                | "USE_VAD"
                                | "CHANGE_NICKNAME"
                                | "MANAGE_NICKNAMES"
                                | "MANAGE_ROLES"
                                | "MANAGE_WEBHOOKS"
                                | "MANAGE_GUILD_EXPRESSIONS"
                                | "USE_SLASH_COMMANDS"
                                | "REQUEST_TO_SPEAK"
                                | "MANAGE_EVENTS"
                                | "MANAGE_THREADS"
                                | "CREATE_PUBLIC_THREADS"
                                | "CREATE_PRIVATE_THREADS"
                                | "USE_EXTERNAL_STICKERS"
                                | "SEND_MESSAGES_IN_THREADS"
                                | "USE_EMBEDDED_ACTIVITIES"
                                | "MODERATE_MEMBERS"
                                | "VIEW_CREATOR_MONETIZATION_ANALYTICS"
                                | "USE_SOUNDBOARD"
                                | "CREATE_GUILD_EXPRESSIONS"
                                | "CREATE_EVENTS"
                                | "USE_EXTERNAL_SOUNDS"
                                | "SEND_VOICE_MESSAGES"
                                | "SEND_POLLS"
                                | "USE_EXTERNAL_APPS"

export type OverwriteReadable = {
    id: string,
    type: number,
    allow: { PermissionStrings }?,
    deny: { PermissionStrings }?
}

export type CreateGuildChannelOptions = {
    name: string,
    type: number?,
    topic: string?,
    bitrate: number?,
    userLimit: number?,
    rateLimitPerUser: number?,
    position: number?,
    permissionOverwrites: { [number]: OverwriteReadable }?,
    parentId: string?,
    nsfw: boolean?,
    defaultAutoArchiveDuration: number?,
    defaultReactionEmoji: {
        emojiId: string?,
        emojiName: string?
    }?,
    availableTags: {
        [number]: {
            id: string,
            name: string,
            moderated: boolean,
            emojiId: string,
            emojiName: string?
        }
    }?,
    defaultSortOrder: number?,
    defaultThreadRateLimitPerUser: number?
}

export type CreateGuildEmojiOptions = {
    name: string,
    image: string,
    roles: { string }?
}

export type CreateApplicationEmojiOptions = {
    name: string,
    image: string
}

export type Locales = "id"
                    | "da"
                    | "de"
                    | "en-GB"
                    | "en-US"
                    | "es-ES"
                    | "es-419"
                    | "fr"
                    | "hr"
                    | "it"
                    | "lt"
                    | "hu"
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
                    | "zh-CN"
                    | "ja"
                    | "zh-TW"
                    | "ko"

export type Localization = {
    [Locales]: string
}

export type ApplicationCommandOptionChoice = {
    name: string,
    nameLocalizations: Localization?,
    value: string | number
}

export type ApplicationCommandOption = {
    type: number,
    name: string,
    nameLocalizations: Localization?,
    description: string,
    descriptionLocalizations: Localization?,
    required: boolean?,
    choices: { ApplicationCommandOptionChoice }?,
    options: { ApplicationCommandOption }?,
    autocomplete: boolean?,
    channelTypes: number?,
    minValue: number?,
    maxValue: number?,
    minLength: number?,
    maxLength: number?
}

export type CreateApplicationCommand = CreateSlashApplicationCommand | CreateContextApplicationCommand

export type CreateSlashApplicationCommand = {
    name: string,
    nameLocalizations: Localization?,
    description: string,
    descriptionLocalizations: Localization?,
    type: number?,
    options: { ApplicationCommandOption }?,
    defaultMemberPermissions: { PermissionStrings }?,
    integrationTypes: { number }?,
    contexts: { number }?,
    dmPermission: boolean?,
    nsfw: boolean?,
    handler: number?
}

export type CreateContextApplicationCommand = {
    name: string,
    nameLocalizations: Localization?,
    type: number?,
    defaultMemberPermissions: { PermissionStrings }?,
    integrationTypes: { number }?,
    contexts: { number }?,
    dmPermission: boolean?,
    nsfw: boolean?,
    handler: number?
}

export type CreateApplicationCommandOptions = {
    bearerToken: string
}

return {}