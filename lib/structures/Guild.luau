local datetime = require("@lune/datetime")

local RestClient = require("../rest/RestClient")
local AnonymousGuild = require("AnonymousGuild")

local ChannelCache = require("../cache/ChannelCache")

local ApiTypes = require("../types/apiTypes")

local Guild = {}
Guild.__index = Guild
setmetatable(Guild, { __index = AnonymousGuild })

export type Guild = typeof(setmetatable({} :: {
    channels: ChannelCache.ChannelCache,

    shardId: number,

    id: string,
    available: boolean,
    discoverySplash: string?,
    memberCount: number,
    large: boolean,
    premiumProgressBarEnabled: boolean,
    applicationId: string?,
    afkTimeout: number?,
    afkChannelId: string?,
    systemChannelId: string?,
    premiumTier: number,
    widgetEnabled: boolean?,
    widgetChannelId: string?,
    explicitContentFilter: number,
    mfaLevel: number,
    joinedTimestamp: datetime.DateTime,
    defaultMessageNotifications: number,
    systemChannelFlags: number,
    maximumMembers: number?,
    maximumPresences: number?,
    maxVideoChannelUsers: number?,
    maxStageVideoChannelUsers: number?,
    approximateMemberCount: number?,
    approximatePresenceCount: number?,
    rulesChannelId: string?,
    publicUpdatesChannelId: string?,
    preferredLocale: ApiTypes.LanguageLocales,
    safetyAlertsChannelId: string?,
    ownerId: string,
}, {} :: typeof({ __index = Guild }))) & AnonymousGuild.AnonymousGuild

function Guild.new(client: RestClient.RestClient, data: any): Guild
    local self: Guild = setmetatable(AnonymousGuild.new(client, data, false) :: any, Guild)

    self.channels = ChannelCache.new(client)

    if data.unavailable then
        self.available = false
    else
        self:update(data)
        if not data.channels then
            self.available = false
        end
    end

    self.shardId = data.shard_id

    return self
end

function Guild.update(self: Guild, data: any)
    AnonymousGuild.update(self, data)

    self.id = data.id
    self.name = data.name
    self.icon = data.icon
    if data.unavailable ~= nil then
        self.available = not data.unavailable
    elseif self.available == nil then
        self.available = true
    end

    self.discoverySplash = data.discovery_splash
    self.memberCount = data.member_count
    self.large = data.large
    self.premiumProgressBarEnabled = data.premium_progress_bar_enabled
    self.applicationId = data.application_id
    self.afkTimeout = data.afk_timeout
    self.afkChannelId = data.afk_channel_id
    self.systemChannelId = data.system_channel_id
    self.premiumTier = data.premium_tier
    self.widgetEnabled = data.widget_enabled
    self.widgetChannelId = data.widget_channel_id
    self.explicitContentFilter = data.explicit_content_filter
    self.mfaLevel = data.mfa_level
    self.joinedTimestamp = data.joined_at and datetime.fromIsoDate(data.joined_at)
    self.defaultMessageNotifications = data.default_message_notifications
    self.systemChannelFlags = data.system_channel_flags -- TODO
    self.maximumMembers = data.max_members
    self.maximumPresences = data.max_presences
    self.maxVideoChannelUsers = data.max_video_channel_users
    self.maxStageVideoChannelUsers = data.max_stage_video_channel_users
    self.approximateMemberCount = data.approximate_member_count
    self.approximatePresenceCount = data.approximate_presence_count
    self.rulesChannelId = data.rules_channel_id
    self.publicUpdatesChannelId = data.public_updates_channel_id
    self.preferredLocale = data.preferred_locale
    self.safetyAlertsChannelId = data.safety_alerts_channel_id
    self.ownerId = data.owner_id

    if data.channels then
        for _, channelData in data.channels do
            channelData.guild_id = self.id
            local channel = self.channels:add(channelData)
            channel.guild = self
        end
    end
end

return Guild