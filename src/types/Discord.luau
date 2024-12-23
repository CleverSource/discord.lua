export type DiscordGetGatewayBot = {
    url: string,
    shards: number,
    session_start_limit: DiscordSessionStartLimit
}

export type DiscordSessionStartLimit = {
    total: number,
    remaining: number,
    reset_after: number,
    max_concurrency: number
}

return {}