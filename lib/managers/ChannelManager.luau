local RestClient = require("../rest/RestClient")

local BaseChannel = require("../structures/BaseChannel")
local TextChannel = require("../structures/TextChannel")

local Constants = require("../Constants")

export type AnyChannel = BaseChannel.BaseChannel & TextChannel.TextChannel

local ChannelManager = {}
ChannelManager.__index = ChannelManager

export type ChannelManager = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
    cache: { [string]: BaseChannel.BaseChannel }, -- NOTE: this type is wrong but we don't care
}, ChannelManager))

function ChannelManager.new(client: RestClient.RestClient): ChannelManager
    local self = setmetatable({}, ChannelManager) :: ChannelManager

    self.client = client
    self.cache = {}

    return self
end

-- Getters with proper typing; these are preferred over the generic get method
function ChannelManager.getTextChannel(self: ChannelManager, id: string): TextChannel.TextChannel?
    return self:get(id)
end

-- Type hacks for better interfacing with the library
function ChannelManager.get(self: ChannelManager, id: string): AnyChannel?
    return self.cache[id] :: any
end

function ChannelManager.add(self: ChannelManager, data: any)
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

function ChannelManager.remove(self: ChannelManager, id: string)
    self.cache[id] = nil
end

return ChannelManager