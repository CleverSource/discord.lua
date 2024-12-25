-- Utils
local getApplicationIdFromToken = require("utils/getApplicationIdFromToken")

-- Promise
local PromiseType = require("@vendor/Promise/types/Promise")
type Promise = PromiseType.AnyPromise

-- Request
local Request = require("Request")
type Request = Request.Request
type RequestOptions = Request.RequestOptions

-- Routes
local RestRoutes = require("RestRoutes")

-- Discord Types
local Discord = require("types/Discord")

-- TODO: placeholders until the types are implemented
type DiscordGetGatewayBot = any
type DiscordWebook = any
type DiscordMessage = any
type DiscordAllowedMentions = any

type AllowedMentions = any

-- Internal Option Types
type EditWebhookOptions = any
type EditWebhookMessageOptions = any
type ExecuteWebhookOptions = any

-- RestClient
local RestClient = {}

export type RestClient = {
    token: string,
    applicationId: string,
    Request: Request,

    new: (options: RestClientOptions) -> RestClient,
    processResponse: (self: RestClient, promise: Promise) -> any,
    formatAllowedMentions: (self: RestClient, allowedMentions: AllowedMentions) -> DiscordAllowedMentions,

    -- Gateway
    getGatewayBot: (self: RestClient) -> DiscordGetGatewayBot,
    
    -- Webhooks
    getWebook: (self: RestClient, webhookId: string) -> DiscordWebook,
    getWebhookWithToken: (self: RestClient, webhookId: string, token: string) -> DiscordWebook,
    getWebookMessage: (self: RestClient, webhookId: string, token: string, messageId: string) -> DiscordMessage,
    
    deleteWebhook: (self: RestClient, webhookId: string, reason: string?) -> nil,
    deleteWebhookWithToken: (self: RestClient, webhookId: string, token: string) -> nil,
    deleteWebhookMessage: (self: RestClient, webhookId: string, token: string, messageId: string) -> nil,
    
    editWebhook: (self: RestClient, webhookId: string, options: EditWebhookOptions, reason: string?) -> DiscordWebook,
    editWebhookWithToken: (self: RestClient, webhookId: string, token: string, options: EditWebhookOptions) -> DiscordWebook,
    editWebhookMessage: (self: RestClient, webhookId: string, token: string, messageId: string, options: EditWebhookMessageOptions) -> DiscordMessage,
    
    executeWebhook: (self: RestClient, webhookId: string, token: string, options: ExecuteWebhookOptions) -> DiscordMessage
} & typeof(RestClient)

export type RestClientOptions = {
    token: string,
    applicationId: string?,
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
    end
    return nil
end

function RestClient.formatAllowedMentions(self: RestClient, allowedMentions: AllowedMentions): DiscordAllowedMentions
    local result = {
        parse = {}
    }

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
function RestClient.getWebook(self: RestClient, webhookId: string): DiscordWebook
    local promise = self.Request:request("GET", RestRoutes.webhooks.id(webhookId), true)
    return self:processResponse(promise)
end

function RestClient.getWebookWithToken(self: RestClient, webhookId: string, token: string): DiscordWebook
    local promise = self.Request:request("GET", RestRoutes.webhooks.webhook(webhookId, token), false)
    return self:processResponse(promise)
end

function RestClient.getWebookMessage(self: RestClient, webhookId: string, token: string, messageId: string): DiscordMessage
    local promise = self.Request:request("GET", RestRoutes.webhooks.message(webhookId, token, messageId), false)
    return self:processResponse(promise)
end

function RestClient.deleteWebhook(self: RestClient, webhookId: string, reason: string?)
    self:processResponse(self.Request:request("DELETE", RestRoutes.webhooks.id(webhookId), true, { 
        reason = reason
    }))
end

function RestClient.deleteWebhookWithToken(self: RestClient, webhookId: string, token: string)
    self:processResponse(self.Request:request("DELETE", RestRoutes.webhooks.webhook(webhookId, token), false))
end

function RestClient.deleteWebhookMessage(self: RestClient, webhookId: string, token: string, messageId: string)
    self:processResponse(self.Request:request("DELETE", RestRoutes.webhooks.message(webhookId, token, messageId), false))
end

function RestClient.editWebhook(self: RestClient, webhookId: string, options: EditWebhookOptions, reason: string?): DiscordWebook
    local promise = self.Request:request("PATCH", RestRoutes.webhooks.id(webhookId), true, {
        name = options.name,
        avatar = options.avatar,
        channel_id = options.channelId,
        reason = reason
    })
    return self:processResponse(promise)
end

function RestClient.editWebhookWithToken(self: RestClient, webhookId: string, token: string, options: EditWebhookOptions): DiscordWebook
    local promise = self.Request:request("PATCH", RestRoutes.webhooks.webhook(webhookId, token), false, {
        name = options.name,
        avatar = options.avatar,
        channel_id = options.channelId
    })
    return self:processResponse(promise)
end

function RestClient.editWebhookMessage(self: RestClient, webhookId: string, token: string, messageId: string, options: EditWebhookMessageOptions): DiscordMessage
    if options.allowedMentions then
        options.allowed_mentions = self:formatAllowedMentions(options.allowedMentions)
        options.allowedMentions = nil
    end

    -- TODO: better design for requests with files
    local promise = self.Request:request("PATCH", RestRoutes.webhooks.message(webhookId, token, messageId), false, options.file and {
        payload_json = options
    } or options, options.file)

    -- TODO: convert to DiscordMessage
    return self:processResponse(promise)
end

function RestClient.executeWebhook(self: RestClient, webhookId: string, token: string, options: ExecuteWebhookOptions): DiscordMessage
    if options.allowedMentions then
        options.allowed_mentions = self:formatAllowedMentions(options.allowedMentions)
        options.allowedMentions = nil
    end
    options.avatar_url = options.avatarUrl
    options.avatarUrl = nil

    local promise = self.Request:request("POST", RestRoutes.webhooks.webhook(webhookId, token, options), false, options.file and {
        payload_json = options
    } or options, options.file)
    
    -- TODO: convert to DiscordMessage
    return self:processResponse(promise)
end

return RestClient