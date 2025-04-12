local RestClient = require("../rest/RestClient")
local Guild = require("../structures/Guild")

local GuildManager = {}
GuildManager.__index = GuildManager

export type GuildManager = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
    cache: { [string]: Guild.Guild },
}, GuildManager))

function GuildManager.new(client: RestClient.RestClient): GuildManager
    local self = setmetatable({}, GuildManager) :: GuildManager

    self.client = client
    self.cache = {}

    return self
end

function GuildManager.get(self: GuildManager, id: string): Guild.Guild?
    return self.cache[id]
end

function GuildManager.add(self: GuildManager, data: any)
    local guild = self:get(data.id)
    if guild then
        guild:update(data)
    else
        guild = Guild.new(self.client, data)
        self.cache[data.id] = guild
    end
    return guild
end

function GuildManager.remove(self: GuildManager, id: string)
    self.cache[id] = nil
end

return GuildManager