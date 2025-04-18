local RestClient = require("../rest/RestClient")
local Base = require("Base")

local ChannelCache = require("../cache/ChannelCache")

local Guild = {}
Guild.__index = Guild
setmetatable(Guild, { __index = Base })

export type Guild = typeof(setmetatable({} :: {
    channels: ChannelCache.ChannelCache,

    client: RestClient.RestClient,
}, {} :: typeof({ __index = Guild }))) & Base.Base

function Guild.new(client: RestClient.RestClient, data: any): Guild
    local self: Guild = setmetatable(Base.new(data.id) :: any, Guild)

    self.channels = ChannelCache.new(client)

    self.client = client

    self:update(data)

    return self
end

function Guild.update(self: Guild, data: any)
    if data.channels then
        for _, channelData in data.channels do
            channelData.guild_id = self.id
            local channel = self.channels:add(channelData)
            channel.guild = self
        end
    end
end

return Guild