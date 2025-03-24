-- camelCase types are preferred for internal types; these are a representation of the Discord API

-- https://discord.com/developers/docs/resources/channel#group-dm-add-recipient-json-params
export type AddDmRecipientOptions = {
    accessToken: string,
    nick: string?
}

return {}