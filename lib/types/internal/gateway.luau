-- camelCase types are preferred for internal types; these are a representation of the Discord API

export type Packet<T> = {
    op: number,
    d: T,
    s: number?,
    t: string?
}

-- https://discord.com/developers/docs/events/gateway#get-gateway-bot
export type GetGatewayBot = {
    url: string,
    shards: number,
    sessionStartLimit: SessionStartLimit
}

-- https://discord.com/developers/docs/events/gateway#session-start-limit-object
export type SessionStartLimit = {
    total: number,
    remaining: number,
    resetAfter: number,
    maxConcurrency: number
}

return {}