local RestClient = require("../rest/RestClient")

local BaseChannel = require("../structures/BaseChannel")
local TextChannel = require("../structures/TextChannel")

local Constants = require("../Constants")

export type AnyChannel = BaseChannel.BaseChannel & TextChannel.TextChannel

local ChannelCache = {}
ChannelCache.__index = ChannelCache

export type ChannelCache = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
    cache: { [string]: BaseChannel.BaseChannel }, -- NOTE: this type is wrong but we don't care
}, ChannelCache))

function ChannelCache.new(client: RestClient.RestClient): ChannelCache
    local self = setmetatable({}, ChannelCache) :: ChannelCache

    self.client = client
    self.cache = {}

    return self
end

-- Getters with proper typing; these are preferred over the generic get method
function ChannelCache.getTextChannel(self: ChannelCache, id: string): TextChannel.TextChannel?
    return self:get(id)
end

-- Type hacks for better interfacing with the library
function ChannelCache.get(self: ChannelCache, id: string): AnyChannel?
    return self.cache[id] :: any
end

function ChannelCache.add(self: ChannelCache, data: any)
    local channel = self:get(data.id)
    if channel then
        channel:update(data)
    else
        if data.type == Constants.ChannelTypes.GuildText then
            channel = TextChannel.new(self.client, data)
        else
            channel = BaseChannel.new(self.client, data)
        end
        self.cache[data.id] = channel
    end

    return channel
end

function ChannelCache.remove(self: ChannelCache, id: string)
    local old = self.cache[id]
    self.cache[id] = nil
    return old
end

return ChannelCache