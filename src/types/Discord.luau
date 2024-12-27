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
    guild_id: DiscordSnowflake | unknown?,
    channel_id: DiscordSnowflake | unknown?,
    user: any?, -- TODO
    name: string | unknown,
    avatar: string | unknown,
    token: string?,
    application_id: DiscordSnowflake | unknown?,
    source_guild: { icon: string?, id: string, name: string }?,
    source_channel: { id: string, name: string }?,
    url: string?
}

export type DiscordPartialAttachment = {
    description: string?,
    filename: string?,
    id: string | number
}

return {}