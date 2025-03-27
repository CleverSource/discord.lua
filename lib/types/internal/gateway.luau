-- camelCase types are preferred for internal types; these are a representation of the Discord API

export type Packet<T> = {
    op: number,
    d: T,
    s: number?,
    t: string?
}

export type GetGatewayBot = {
    url: string,
    shards: number,
    sessionStartLimit: SessionStartLimit
}

export type SessionStartLimit = {
    total: number,
    remaining: number,
    resetAfter: number,
    maxConcurrency: number
}

return {}