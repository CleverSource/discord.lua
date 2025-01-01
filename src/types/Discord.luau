export type DiscordSnowflake = string

export type AllowedMentionTypes = "everyone" | "roles" | "users"
export type DiscordAllowedMentions = {
    parse: { AllowedMentionTypes }?,
    replied_user: boolean?,
    roles: { string }?,
    users: { string }?
}

export type DiscordWebhook = {
    id: DiscordSnowflake,
    type: number, -- TODO
    guild_id: DiscordSnowflake | nil?,
    channel_id: DiscordSnowflake | nil?,
    user: any?, -- TODO
    name: string | nil,
    avatar: string | nil,
    token: string?,
    application_id: DiscordSnowflake | nil?,
    source_guild: { icon: string?, id: string, name: string }?,
    source_channel: { id: string, name: string }?,
    url: string?
}

export type DiscordPartialAttachment = {
    description: string?,
    filename: string?,
    id: string | number
}

export type DiscordForumTag = {
    id: string,
    name: string,
    moderated: boolean,
    emoji_id: string,
    emoji_name: string | nil
}

export type DiscordDefaultReactionEmoji = {
    emoji_id: string,
    emoji_name: string | nil
}

export type DiscordFollowChannel = {
    channel_id: string,
    webhook_id: string
}

return {}