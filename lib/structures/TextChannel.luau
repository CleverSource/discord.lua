local RestClient = require("../rest/RestClient")
local BaseGuildTextChannel = require("BaseGuildTextChannel")

local GuildChannelMixin = require("mixin/GuildChannelMixin")
local BaseGuildTextChannelMixin = require("mixin/BaseGuildTextChannelMixin")

local TextChannel = {}
TextChannel.__index = TextChannel
setmetatable(TextChannel, { __index = BaseGuildTextChannel })

export type TextChannel = typeof(setmetatable({} :: {
    rateLimitPerUser: number
}, {} :: typeof({ __index = TextChannel }))) & BaseGuildTextChannel.BaseGuildTextChannel

function TextChannel.new(client: RestClient.RestClient, data: any): TextChannel
    local self: TextChannel = setmetatable(BaseGuildTextChannel.new(client, data) :: any, TextChannel)

    self:update(data)

    return self
end

function TextChannel.update(self: TextChannel, data: any)
    BaseGuildTextChannel.update(self, data)

    if data.rate_limit_per_user then
        self.rateLimitPerUser = data.rate_limit_per_user
    end
end

function TextChannel.setRateLimitPerUser<T>(self: T, rateLimitPerUser: number, reason: string?): T
    return (self :: any):edit({ rateLimitPerUser = rateLimitPerUser, reason = reason })
end

GuildChannelMixin.mix(BaseGuildTextChannel)
BaseGuildTextChannelMixin.mix(BaseGuildTextChannel)

return TextChannel