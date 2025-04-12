local datetime = require("@lune/datetime")

local RestClient = require("../rest/RestClient")
local GuildChannel = require("GuildChannel")

local RestTypes = require("../types/internal/rest")

local TextChannel = {}
TextChannel.__index = TextChannel
setmetatable(TextChannel, { __index = GuildChannel })

export type TextChannel = typeof(setmetatable({} :: {
    lastMessageId: string?,
    rateLimitPerUser: number,
    lastPinTimestamp: datetime.DateTime?,
    topic: string?,
    defaultAutoArchiveDuration: number,
    permissionOverwrites: any, -- TODO
    position: number,
    nsfw: boolean,
}, {} :: typeof({ __index = TextChannel }))) & GuildChannel.GuildChannel

function TextChannel.new(client: RestClient.RestClient, data: any): TextChannel
    local self: TextChannel = setmetatable(GuildChannel.new(client, data) :: any, TextChannel)

    -- TODO: messages manager

    self.lastMessageId = data.last_message_id
    self.rateLimitPerUser = data.rate_limit_per_user
    self.lastPinTimestamp = data.last_pin_timestamp and datetime.fromIsoDate(data.last_pin_timestamp)

    self:update(data)

    return self
end

function TextChannel.update(self: TextChannel, data: any)
    GuildChannel.update(self, data)

    self.topic = data.topic
    self.defaultAutoArchiveDuration = data.default_auto_archive_duration
    self.permissionOverwrites = data.permission_overwrites -- TODO: manager
    self.position = data.position
    self.nsfw = data.nsfw
end

function TextChannel.addMessageReaction(self: TextChannel, messageId: string, reaction: string)
    self._client:addReaction(self.id, messageId, reaction)
end

function TextChannel.createInvite(self: TextChannel, options: RestTypes.CreateChannelInviteRequest, reason: string?): RestTypes.CreateChannelInviteResponse
    return self._client:createInvite(self.id, options, reason)
end

function TextChannel.sendMessage(self: TextChannel, optionsOrContent: string | RestTypes.CreateMessageRequest): RestTypes.CreateMessageResponse
    if typeof(optionsOrContent) == "string" then
        optionsOrContent = {
            content = optionsOrContent,
        } :: RestTypes.CreateMessageRequest
    end
    return self._client:sendMessage(self.id, optionsOrContent)
end

function TextChannel.startThread(self: TextChannel, options: RestTypes.StartThreadWithoutMessageRequest): RestTypes.StartThreadWithoutMessageResponse
    return self._client:startThreadWithoutMessage(self.id, options)
end

function TextChannel.startThreadWithMessage(self: TextChannel, messageId: string, options: RestTypes.StartThreadFromMessageRequest): RestTypes.StartThreadFromMessageRequest
    return self._client:startThreadWithMessage(self.id, messageId, options)
end

function TextChannel.createWebhook(self: TextChannel, options: RestTypes.CreateWebhookRequest, reason: string?): RestTypes.CreateWebhookResponse
    return self._client:createWebhook(self.id, options, reason)
end

function TextChannel.deleteMessage(self: TextChannel, messageId: string, reason: string?)
    self._client:deleteMessage(self.id, messageId, reason)
end

function TextChannel.deleteMessages(self: TextChannel, messageIds: { string }, reason: string?)
    self._client:deleteMessages(self.id, messageIds, reason)
end

function TextChannel.editMessage(self: TextChannel, messageId: string, options: RestTypes.EditMessageRequest): RestTypes.EditMessageResponse
    return self._client:editMessage(self.id, messageId, options)
end

return TextChannel