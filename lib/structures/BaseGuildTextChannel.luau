local datetime = require("@lune/datetime")

local RestClient = require("../rest/RestClient")
local GuildChannel = require("GuildChannel")

local MessageCache = require("../cache/MessageCache")

local GuildChannelMixin = require("mixin/GuildChannelMixin")
local BaseGuildTextChannelMixin = require("mixin/BaseGuildTextChannelMixin")

local BaseGuildTextChannel = {}
BaseGuildTextChannel.__index = BaseGuildTextChannel
setmetatable(BaseGuildTextChannel, { __index = GuildChannel })

export type BaseGuildTextChannel = typeof(setmetatable({} :: {
    messages: MessageCache.MessageCache,

    topic: string?,
    nsfw: boolean,
    lastMessageId: string?,
    lastPinTimestamp: datetime.DateTime?,
    defaultAutoArchiveDuration: number?,
    defaultThreadRateLimitPerUser: number?
}, {} :: typeof({ __index = BaseGuildTextChannel }))) & GuildChannel.GuildChannel & BaseGuildTextChannelMixin.Methods

function BaseGuildTextChannel.new(client: RestClient.RestClient, data: any): BaseGuildTextChannel
    local self: BaseGuildTextChannel = setmetatable(GuildChannel.new(client, data, false) :: any, BaseGuildTextChannel)

    self.messages = MessageCache.new(client, 100)

    self.nsfw = data.nsfw

    self:update(data)

    return self
end

function BaseGuildTextChannel.update(self: BaseGuildTextChannel, data: any)
    GuildChannel.update(self, data)

    if data.topic then
        self.topic = data.topic
    end

    if data.last_message_id then
        self.lastMessageId = data.last_message_id
    end

    if data.last_pin_timestamp then
        self.lastPinTimestamp = datetime.fromIsoDate(data.last_pin_timestamp)
    end

    if data.default_auto_archive_duration then
        self.defaultAutoArchiveDuration = data.default_auto_archive_duration
    end

    if data.default_thread_rate_limit_per_user then
        self.defaultThreadRateLimitPerUser = data.default_thread_rate_limit_per_user
    end

    if data.messages then
        for _, message in data.messages do
            self.messages:add(message)
        end
    end
end

GuildChannelMixin.mix(BaseGuildTextChannel)
BaseGuildTextChannelMixin.mix(BaseGuildTextChannel)

return BaseGuildTextChannel