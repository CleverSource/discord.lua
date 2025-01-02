-- Lune
local DateTime = require("@lune/datetime")

-- Utils
local getApplicationIdFromToken = require("utils/getApplicationIdFromToken")
local urlToBase64 = require("utils/urlToBase64")

-- Promise
local PromiseType = require("@vendor/Promise/types/Promise")
type Promise = PromiseType.AnyPromise

-- Request
local Request = require("Request")
type Request = Request.Request
type RequestOptions = Request.RequestOptions
type FileContent = Request.FileContent

-- Routes
local RestRoutes = require("RestRoutes")

-- Discord Types
local Discord = require("types/Discord")

-- TODO: some of these are placeholders until the types are implemented
type DiscordGetGatewayBot = Discord.DiscordGetGatewayBot
type DiscordWebook = Discord.DiscordWebhook
type DiscordMessage = any
type DiscordChannel = any
type DiscordAllowedMentions = Discord.DiscordAllowedMentions
type DiscordSnowflake = Discord.DiscordSnowflake
type DiscordPartialAttachment = Discord.DiscordPartialAttachment
type DiscordForumTag = Discord.DiscordForumTag
type DiscordDefaultReactionEmoji = Discord.DiscordDefaultReactionEmoji
type DiscordFollowChannel = Discord.DiscordFollowChannel

type AllowedMentions = {
    everyone: boolean?,
    repliedUser: boolean?,
    roles: boolean | { DiscordSnowflake }?,
    users: boolean | { DiscordSnowflake }?
}

-- Internal Option Types
type CreateWebhookOptions = {
    name: string,
    avatar: string | nil?
}
type EditWebhookOptions = {
    name: string?,
    avatar: string | nil?,
    channelId: DiscordSnowflake?
}
type EditWebhookMessageOptions = {
    attachments: { DiscordPartialAttachment }?,
    content: string?,
    embeds: { any }?, -- TODO
    file: FileContent | { FileContent }?,
    allowedMentions: AllowedMentions?,
    components: { any }? -- TODO
}
type ExecuteWebhookOptions = {
    allowedMentions: AllowedMentions?,
    attachments: { DiscordPartialAttachment }?,
    avatarUrl: string?,
    components: { any }?, -- TODO
    content: string?,
    embeds: { any }?, -- TODO
    file: FileContent | { FileContent }?,
    flags: number,
    poll: any, -- TODO
    threadId: string?,
    tts: boolean?,
    username: string?,
    wait: boolean?
}
type AddDmRecipientOptions = {
    accessToken: string,
    nick: string?
}
type EditChannelOptions = {
    name: string?,
    icon: string?,
    type: number?,
    position: number | nil?,
    topic: string | nil?,
    nsfw: boolean | nil?,
    rateLimitPerUser: number | nil?,
    bitrate: number | nil?,
    userLimit: number | nil?,
    parentId: string | nil?,
    rtcRegion: string | nil?,
    videoQualityMode: number?,
    defaultAutoArchiveDuration: number?,
    flags: number?,
    availableTags: { DiscordForumTag }?,
    defaultReactionEmoji: DiscordDefaultReactionEmoji?,
    defaultThreadRateLimitPerUser: number?,
    defaultSortOrder: number | nil?,
    defaultFormLayout: number?,
    archived: boolean?,
    autoArchiveDuration: number?,
    locked: boolean?,
    invitable: boolean?,
    appliedTags: { string }?
}
type CreateForumThreadOptions = {
    name: string,
    autoArchiveDuration: number,
    rateLimitPerUser: number | nil?,
    message: {
        content: string?,
        embeds: { any }?, -- TODO
        allowedMentions: AllowedMentions?,
        components: { any }?, -- TODO
        stickerIds: { DiscordSnowflake }?,
        flags: number?
    },
    appliedTags: { string }?,
    file: FileContent | { FileContent }?
}

-- RestClient
local RestClient = {}

export type RestClient = {
    token: string,
    applicationId: DiscordSnowflake,
    Request: Request,

    new: (options: RestClientOptions) -> RestClient,
    processResponse: (self: RestClient, promise: Promise) -> any,
    formatAllowedMentions: (self: RestClient, allowedMentions: AllowedMentions) -> DiscordAllowedMentions,

    -- Gateway
    getGatewayBot: (self: RestClient) -> DiscordGetGatewayBot,
    
    -- Webhooks
    getWebook: (self: RestClient, webhookId: DiscordSnowflake) -> DiscordWebook,
    getWebhookWithToken: (self: RestClient, webhookId: DiscordSnowflake, token: string) -> DiscordWebook,
    getWebookMessage: (self: RestClient, webhookId: DiscordSnowflake, token: string, messageId: string) -> DiscordMessage,
    
    deleteWebhook: (self: RestClient, webhookId: DiscordSnowflake, reason: string?) -> nil,
    deleteWebhookWithToken: (self: RestClient, webhookId: DiscordSnowflake, token: string) -> nil,
    deleteWebhookMessage: (self: RestClient, webhookId: DiscordSnowflake, token: string, messageId: string) -> nil,
    
    editWebhook: (self: RestClient, webhookId: DiscordSnowflake, options: EditWebhookOptions, reason: string?) -> DiscordWebook,
    editWebhookWithToken: (self: RestClient, webhookId: DiscordSnowflake, token: string, options: EditWebhookOptions) -> DiscordWebook,
    editWebhookMessage: (self: RestClient, webhookId: DiscordSnowflake, token: string, messageId: string, options: EditWebhookMessageOptions) -> DiscordMessage,
    
    executeWebhook: (self: RestClient, webhookId: DiscordSnowflake, token: string, options: ExecuteWebhookOptions) -> DiscordMessage | nil,

    -- Channels
    deleteMessages: (self: RestClient, channelId: DiscordSnowflake, messageIds: { DiscordSnowflake }, reason: string?) -> nil,
    getDmChannel: (self: RestClient, userId: DiscordSnowflake) -> DiscordChannel,
    addDmRecipient: (self: RestClient, channelId: DiscordSnowflake, userId: DiscordSnowflake, options: AddDmRecipientOptions) -> nil,
    removeDmRecipient: (self: RestClient, channelId: DiscordSnowflake, userId: DiscordSnowflake) -> nil,
    pinMessage: (self: RestClient, channelId: DiscordSnowflake, messageId: DiscordSnowflake, reason: string?) -> nil,
    unpinMessage: (self: RestClient, channelId: DiscordSnowflake, messageId: DiscordSnowflake, reason: string?) -> nil,
    getPinnedMessages: (self: RestClient, channelId: DiscordSnowflake) -> { DiscordMessage },
    getChannelWebhooks: (self: RestClient, channelId: DiscordSnowflake) -> { DiscordWebook },
    createWebhook: (self: RestClient, channelId: DiscordSnowflake, options: CreateWebhookOptions, reason: string?) -> DiscordWebook,
    getChannel: (self: RestClient, channelId: DiscordSnowflake) -> DiscordChannel,
    editChannel: (self: RestClient, channelId: DiscordSnowflake, options: EditChannelOptions, reason: string?) -> DiscordChannel,
    deleteChannel: (self: RestClient, channelId: DiscordSnowflake, reason: string?) -> nil,
    followAnnouncement: (self: RestClient, sourceChannelId: DiscordSnowflake, targetChannelId: DiscordSnowflake, reason: string?) -> DiscordFollowChannel,
    createForumThread: (self: RestClient, channelId: DiscordSnowflake, options: CreateForumThreadOptions, reason: string?) -> DiscordChannel
} & typeof(RestClient)

export type RestClientOptions = {
    token: string,
    applicationId: DiscordSnowflake?,
    restOptions: RequestOptions?,
}

function RestClient.new(options: RestClientOptions): RestClient
    local self = setmetatable({} :: RestClient, {
        __index = RestClient
    })
    
    self.token = `Bot {options.token}`
    self.applicationId = options.applicationId or getApplicationIdFromToken(options.token)
    self.Request = Request.new(self.token, options.restOptions)

    return self
end

function RestClient.processResponse(self: RestClient, promise: Promise): any
    local success, result = promise:await()
    if success then
        return result
    else
        print(result)
    end
    return nil
end

function RestClient.formatAllowedMentions(self: RestClient, allowedMentions: AllowedMentions): DiscordAllowedMentions
    local result = {
        parse = {}
    } :: DiscordAllowedMentions

    if allowedMentions.everyone then
        table.insert(result.parse, "everyone")
    end

    if allowedMentions.roles == true then
        table.insert(result.parse, "roles")
    elseif typeof(allowedMentions.roles) == "table" then
        if #allowedMentions.roles > 100 then
            error("Allowed mentions roles cannot exceed 100")
        end
        result.roles = allowedMentions.roles
    end

    if allowedMentions.users == true then
        table.insert(result.parse, "users")
    elseif typeof(allowedMentions.users) == "table" then
        if #allowedMentions.users > 100 then
            error("Allowed mentions users cannot exceed 100")
        end
        result.users = allowedMentions.users
    end

    if allowedMentions.repliedUser then
        result.replied_user = allowedMentions.repliedUser 
    end

    return result
end

-- Gateway
function RestClient.getGatewayBot(self: RestClient): DiscordGetGatewayBot
    local promise = self.Request:request("GET", RestRoutes.gatewayBot(), true)
    return self:processResponse(promise)
end

-- Webhooks
function RestClient.getWebook(self: RestClient, webhookId: DiscordSnowflake): DiscordWebook
    local promise = self.Request:request("GET", RestRoutes.webhooks.id(webhookId), true)
    return self:processResponse(promise)
end

function RestClient.getWebookWithToken(self: RestClient, webhookId: DiscordSnowflake, token: string): DiscordWebook
    local promise = self.Request:request("GET", RestRoutes.webhooks.webhook(webhookId, token), false)
    return self:processResponse(promise)
end

function RestClient.getWebookMessage(self: RestClient, webhookId: DiscordSnowflake, token: string, messageId: string): DiscordMessage
    local promise = self.Request:request("GET", RestRoutes.webhooks.message(webhookId, token, messageId), false)
    return self:processResponse(promise)
end

function RestClient.deleteWebhook(self: RestClient, webhookId: DiscordSnowflake, reason: string?)
    self:processResponse(self.Request:request("DELETE", RestRoutes.webhooks.id(webhookId), true, { 
        reason = reason
    }))
end

function RestClient.deleteWebhookWithToken(self: RestClient, webhookId: DiscordSnowflake, token: string)
    self:processResponse(self.Request:request("DELETE", RestRoutes.webhooks.webhook(webhookId, token), false))
end

function RestClient.deleteWebhookMessage(self: RestClient, webhookId: DiscordSnowflake, token: string, messageId: string)
    self:processResponse(self.Request:request("DELETE", RestRoutes.webhooks.message(webhookId, token, messageId), false))
end

function RestClient.editWebhook(self: RestClient, webhookId: DiscordSnowflake, options: EditWebhookOptions, reason: string?): DiscordWebook
    local promise = self.Request:request("PATCH", RestRoutes.webhooks.id(webhookId), true, options)
    return self:processResponse(promise)
end

function RestClient.editWebhookWithToken(self: RestClient, webhookId: DiscordSnowflake, token: string, options: EditWebhookOptions): DiscordWebook
    local promise = self.Request:request("PATCH", RestRoutes.webhooks.webhook(webhookId, token), false, options)
    return self:processResponse(promise)
end

function RestClient.editWebhookMessage(self: RestClient, webhookId: DiscordSnowflake, token: string, messageId: string, options: EditWebhookMessageOptions): DiscordMessage
    if options.allowedMentions then
        (options :: any).allowedMentions = self:formatAllowedMentions(options.allowedMentions)
    end

    -- TODO: better design for requests with files
    local promise = self.Request:request("PATCH", RestRoutes.webhooks.message(webhookId, token, messageId), false, options, options.file :: FileContent)

    -- TODO: convert to DiscordMessage
    return self:processResponse(promise)
end

function RestClient.executeWebhook(self: RestClient, webhookId: DiscordSnowflake, token: string, options: ExecuteWebhookOptions): DiscordMessage | nil
    if options.allowedMentions then
        (options :: any).allowedMentions = self:formatAllowedMentions(options.allowedMentions)
    end

    local promise = self.Request:request("POST", RestRoutes.webhooks.webhook(webhookId, token, options), false, options, options.file :: FileContent)
    
    -- TODO: convert to DiscordMessage
    local response = self:processResponse(promise)
    if options.wait then
        return response
    else
        return nil
    end
end

-- Channels
function RestClient.deleteMessages(self: RestClient, channelId: DiscordSnowflake, messageIds: { DiscordSnowflake }, reason: string?)
    if #messageIds == 0 then
        return
    end
    if #messageIds == 1 then
        -- TODO: delete single message
        return
    end

    local oldestAllowedSnowflake = (DateTime.now().unixTimestampMillis - 1421280000000) * 4194304
    local invalidMessage = false

    for _, messageId in messageIds do
        if tonumber(messageId) < oldestAllowedSnowflake then
            invalidMessage = messageId
            break
        end
    end

    if invalidMessage then
        error(`Message {invalidMessage} is more than 2 weeks old.`)
    end

    local MAX_MESSAGES = 100
    if #messageIds > MAX_MESSAGES then
        local shift = table.move(messageIds, MAX_MESSAGES + 1, #messageIds, 1, {})
        local splice = table.move(messageIds, 1, MAX_MESSAGES, 1, {})

        self.Request:request("POST", RestRoutes.channels.bulk(channelId), true, {
            messages = splice,
            reason = reason
        }):andThen(function()
            self:deleteMessages(channelId, shift, reason)
        end)
        return
    end
    self:processResponse(self.Request:request("POST", RestRoutes.channels.bulk(channelId), true, {
        messages = messageIds,
        reason = reason
    }))
end

function RestClient.getDmChannel(self: RestClient, userId: DiscordSnowflake): DiscordChannel
    local promise = self.Request:request("POST", RestRoutes.channels.dm(), true, {
        recipient_id = userId
    })
    
    -- TODO: convert to DiscordChannel
    return self:processResponse(promise)
end

function RestClient.addDmRecipient(self: RestClient, channelId: DiscordSnowflake, userId: DiscordSnowflake, options: AddDmRecipientOptions)
    (options :: any).access_token = options.accessToken
    self:processResponse(self.Request:request("PUT", RestRoutes.channels.dmRecipient(channelId, userId), true, options))
end

function RestClient.removeDmRecipient(self: RestClient, channelId: DiscordSnowflake, userId: DiscordSnowflake)
    self:processResponse(self.Request:request("DELETE", RestRoutes.channels.dmRecipient(channelId, userId), true))
end

function RestClient.pinMessage(self: RestClient, channelId: DiscordSnowflake, messageId: DiscordSnowflake, reason: string?)
    self:processResponse(self.Request:request("PUT", RestRoutes.channels.pin(channelId, messageId), true, {
        reason = reason
    }))
end

function RestClient.unpinMessage(self: RestClient, channelId: DiscordSnowflake, messageId: DiscordSnowflake, reason: string?)
    self:processResponse(self.Request:request("DELETE", RestRoutes.channels.pin(channelId, messageId), true, {
        reason = reason
    }))
end

function RestClient.getPinnedMessages(self: RestClient, channelId: DiscordSnowflake): { DiscordMessage }
    local promise = self.Request:request("GET", RestRoutes.channels.pins(channelId), true)

    -- TODO: convert to array of DiscordMessage
    return self:processResponse(promise)
end

function RestClient.getChannelWebhooks(self: RestClient, channelId: DiscordSnowflake): { DiscordWebook }
    local promise = self.Request:request("GET", RestRoutes.channels.webhooks(channelId), true)

    -- TODO: convert to array of DiscordWebhook
    return self:processResponse(promise)
end

function RestClient.createWebhook(self: RestClient, channelId: DiscordSnowflake, options: CreateWebhookOptions, reason: string?): DiscordWebook
    local promise = self.Request:request("POST", RestRoutes.channels.webhooks(channelId), true, {
        name = options.name,
        avatar = options.avatar and urlToBase64(options.avatar) or nil,
        reason = reason
    })
    
    -- TODO: convert to DiscordWebhook
    return self:processResponse(promise)
end

function RestClient.getChannel(self: RestClient, channelId: DiscordSnowflake): DiscordChannel
    local promise = self.Request:request("GET", RestRoutes.channels.channel(channelId), true)
    
    -- TODO: convert to DiscordChannel
    return self:processResponse(promise)
end

function RestClient.editChannel(self: RestClient, channelId: DiscordSnowflake, options: EditChannelOptions, reason: string?): DiscordChannel
    (options :: any).reason = reason
    local promise = self.Request:request("PATCH", RestRoutes.channels.channel(channelId), true, options)

    -- TODO: convert to DiscordChannel
    return self:processResponse(promise)
end

function RestClient.deleteChannel(self: RestClient, channelId: DiscordSnowflake, reason: string?)
    self:processResponse(self.Request:request("DELETE", RestRoutes.channels.channel(channelId), true, {
        reason = reason
    }))
end

function RestClient.followAnnouncement(self: RestClient, sourceChannelId: DiscordSnowflake, targetChannelId: DiscordSnowflake, reason: string?): DiscordFollowChannel
    return self:processResponse(self.Request:request("POST", RestRoutes.channels.follow(sourceChannelId), true, {
        webhookChannelId = targetChannelId,
        reason = reason
    }))
end

function RestClient.createForumThread(self: RestClient, channelId: DiscordSnowflake, options: CreateForumThreadOptions, reason: string?): DiscordChannel
    (options :: any).reason = reason
    if options.message and options.message.allowedMentions then
        (options :: any).message.allowedMentions = self:formatAllowedMentions((options :: any).message.allowedMentions)
    end
    local promise = self.Request:request("POST", RestRoutes.channels.forum(channelId), true, options, options.file :: FileContent)

    return self:processResponse(promise)
end

return RestClient