local datetime = require("@lune/datetime")

local RestClient = require("../rest/RestClient")
local Base = require("Base")

local ChannelManager = require("../managers/ChannelManager")

local Guild = {}
Guild.__index = Guild
setmetatable(Guild, { __index = Base })

export type Guild = typeof(setmetatable({} :: {
    channels: ChannelManager.ChannelManager,

    unavailable: boolean,
    joinedAt: datetime.DateTime,
    memberCount: number,
    applicationId: string?,
    widgetEnabled: boolean?,
    widgetChannelId: string?,
    approximateMemberCount: number?,
    approximatePresenceCount: number?,
}, {} :: typeof({ __index = Guild }))) & Base.Base

function Guild.new(client: RestClient.RestClient, data: any): Guild
    local self: Guild = setmetatable(Base.new(client, data.id) :: any, Guild)

    self.channels = ChannelManager.new(client)

    self.unavailable = not (not data.unavailable)
    self.joinedAt = datetime.fromIsoDate(data.joined_at)
    self.memberCount = data.member_count
    self.applicationId = data.application_id
    self.widgetEnabled = data.widget_enabled
    self.widgetChannelId = data.widget_channel_id
    self.approximateMemberCount = data.approximate_member_count
    self.approximatePresenceCount = data.approximate_presence_count

    if data.channels then
        for _, channelData in data.channels do
            channelData.guild_id = self.id
            local channel = self.channels:add(channelData)
            channel.guild = self
        end
    end

    self:update(data)

    return self
end

function Guild.update(self: Guild, data: any)
    
end

return Guild