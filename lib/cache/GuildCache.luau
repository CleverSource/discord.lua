local RestClient = require("../rest/RestClient")
local Guild = require("../structures/Guild")

local GuildCache = {}
GuildCache.__index = GuildCache

export type GuildCache = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
    cache: { [string]: Guild.Guild },
    channelGuildMap: { [string]: string }
}, GuildCache))

function GuildCache.new(client: RestClient.RestClient): GuildCache
    local self = setmetatable({}, GuildCache) :: GuildCache

    self.client = client
    self.cache = {}

    self.channelGuildMap = {}

    return self
end

function GuildCache.get(self: GuildCache, id: string): Guild.Guild?
    return self.cache[id]
end

function GuildCache.add(self: GuildCache, data: any)
    local guild = self:get(data.id)

    if guild then
        guild:update(data)
    else
        guild = Guild.new(self.client, data)
        self.cache[data.id] = guild
    end

    if data.channels then
        for _, channel in data.channels do
            self.channelGuildMap[channel.id] = guild.id
        end
    end

    return guild
end

function GuildCache.remove(self: GuildCache, id: string)
    local old = self.cache[id]

    -- TODO: should not be accessing cache directly
    for _, channel in old.channels.cache do
        self.channelGuildMap[channel.id] = nil
    end

    self.cache[id] = nil
    
    return old
end

return GuildCache