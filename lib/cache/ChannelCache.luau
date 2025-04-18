local RestClient = require("../rest/RestClient")

local Channel = require("../structures/Channel")
local GuildChannel = require("../structures/GuildChannel")
local TextChannel = require("../structures/TextChannel")

local Constants = require("../Constants")

export type AnyChannel = Channel.Channel & GuildChannel.GuildChannel & TextChannel.TextChannel

local ChannelCache = {}
ChannelCache.__index = ChannelCache

export type ChannelCache = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
    cache: { [string]: Channel.Channel }, -- NOTE: this type is wrong but we don't care
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
        end

        if not channel and not data.guild_id then
            self.client.logger:warn(`Unknown channel type: {data.type}`)
            channel = Channel.new(self.client, data)
        elseif not channel and data.guild_id then
            if data.last_message_id ~= nil then
                self.client.logger:warn(`Unknown guild text channel type: {data.type}`)
                channel = TextChannel.new(self.client, data)
            else
                self.client.logger:warn(`Unknown guild channel type: {data.type}`)
                channel = GuildChannel.new(self.client, data)
            end
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