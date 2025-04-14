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

    if data.name then
        self.name = data.name
    end

    if data.icon then
        self.icon = data.icon
    end
    
    if data.unavailable ~= nil then
        self.available = not data.unavailable
    elseif self.available == nil then
        self.available = true
    end

    if data.discovery_splash then
        self.discoverySplash = data.discovery_splash
    end

    if data.member_count then
        self.memberCount = data.member_count
    end

    if data.large then
        self.large = data.large
    end

    if data.premium_progress_bar_enabled then
        self.premiumProgressBarEnabled = data.premium_progress_bar_enabled
    end

    
    if data.application_id then
        self.applicationId = data.application_id
    end
    
    if data.afk_timeout then
        self.afkTimeout = data.afk_timeout
    end
    
    if data.afk_channel_id then
        self.afkChannelId = data.afk_channel_id
    end
    
    if data.system_channel_id then
        self.systemChannelId = data.system_channel_id
    end
    
    if data.premium_tier then
        self.premiumTier = data.premium_tier
    end
    
    if data.widget_enabled then
        self.widgetEnabled = data.widget_enabled
    end
    
    if data.widget_channel_id then
        self.widgetChannelId = data.widget_channel_id
    end
    
    if data.explicit_content_filter then
        self.explicitContentFilter = data.explicit_content_filter
    end
    
    if data.mfa_level then
        self.mfaLevel = data.mfa_level
    end
    
    if data.joined_at then
        self.joinedTimestamp = datetime.fromIsoDate(data.joined_at)
    end
    
    if data.default_message_notifications then
        self.defaultMessageNotifications = data.default_message_notifications
    end
    
    if data.system_channel_flags then
        self.systemChannelFlags = data.system_channel_flags -- TODO
    end
    
    if data.max_members then
        self.maximumMembers = data.max_members
    end
    
    if data.max_presences then
        self.maximumPresences = data.max_presences
    end
    
    if data.max_video_channel_users then
        self.maxVideoChannelUsers = data.max_video_channel_users
    end
    
    if data.max_stage_video_channel_users then
        self.maxStageVideoChannelUsers = data.max_stage_video_channel_users
    end
    
    if data.approximate_member_count then
        self.approximateMemberCount = data.approximate_member_count
    end
    
    if data.approximate_presence_count then
        self.approximatePresenceCount = data.approximate_presence_count
    end
    
    if data.rules_channel_id then
        self.rulesChannelId = data.rules_channel_id
    end
    
    if data.public_updates_channel_id then
        self.publicUpdatesChannelId = data.public_updates_channel_id
    end
    
    if data.preferred_locale then
        self.preferredLocale = data.preferred_locale
    end
    
    if data.safety_alerts_channel_id then
        self.safetyAlertsChannelId = data.safety_alerts_channel_id
    end
    
    if data.owner_id then
        self.ownerId = data.owner_id
    end

    if data.channels then
        for _, channelData in data.channels do
            channelData.guild_id = self.id
            local channel = self.channels:add(channelData)
            channel.guild = self
        end
    end
end

return Guild