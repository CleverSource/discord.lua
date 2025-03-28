local Routes = require("Routes")
local Logger = require("../log/Logger")
type Logger = Logger.Logger
local RequestHandler = require("RequestHandler")
type RequestHandler = RequestHandler.RequestHandler

local processDiscordReaction = require("../util/processDiscordReaction")

local RestTypes = require("../types/internal/rest")

local RestClient = {}
RestClient.__index = RestClient

export type RestClientOptions = {
    token: string?,
    logger: Logger?,
    preferSnakeCase: boolean?,
    applicationId: string?
}

export type RestClient = typeof(setmetatable({} :: {
    logger: Logger,
    request: RequestHandler,
    applicationId: string
}, RestClient))

function RestClient.new(options: RestClientOptions): RestClient
    local self = setmetatable({}, RestClient) :: RestClient

    self.logger = options.logger or Logger.new()
    self.request = RequestHandler.new({
        token = options.token,
        preferSnakeCase = options.preferSnakeCase or false,
        logger = self.logger
    })
    self.applicationId = options.applicationId

    return self
end

function RestClient.getGateway(self: RestClient): RestTypes.GetGatewayResponse
    return self.request:get(Routes.gateway(), {
        authenticated = false
    })
end

function RestClient.getBotGateway(self: RestClient): RestTypes.GetGatewayBotResponse
    return self.request:get(Routes.gatewayBot())
end

function RestClient.addReaction(self: RestClient, channelId: string, messageId: string, reaction: string)
    reaction = processDiscordReaction(reaction)
    self.request:put(Routes.channels.reactions.bot(channelId, messageId, reaction))
end

function RestClient.addReactions(self: RestClient, channelId: string, messageId: string, reactions: { string })
    for _, reaction in ipairs(reactions) do
        self:addReaction(channelId, messageId, reaction)
    end
end

function RestClient.addRole(self: RestClient, guildId: string, userId: string, roleId: string, reason: string)
    self.request:put(Routes.guilds.roles.member(guildId, userId, roleId), {
        reason = reason
    })
end

function RestClient.addThreadMember(self: RestClient, channelId: string, userId: string)
    self.request:put(Routes.channels.threads.user(channelId, userId))
end

function RestClient.addDmRecipient(self: RestClient, channelId: string, userId: string, options: RestTypes.GroupDMAddRecipientRequest)
    self.request:put(Routes.channels.dmRecipient(channelId, userId), {
        body = options
    })
end

function RestClient.createAutomodRule(self: RestClient, guildId: string, options: RestTypes.CreateAutoModerationRuleRequest, reason: string?): RestTypes.CreateAutoModerationRuleResponse
    return self.request:post(Routes.guilds.automod.rules(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.createChannel(self: RestClient, guildId: string, options: RestTypes.CreateGuildChannelRequest, reason: string?): RestTypes.CreateGuildChannelResponse
    return self.request:post(Routes.guilds.channels(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.createEmoji(self: RestClient, guildId: string, options: RestTypes.CreateGuildEmojiRequest, reason: string?): RestTypes.CreateGuildEmojiResponse
    return self.request:post(Routes.guilds.emojis(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.createApplicationEmoji(self: RestClient, options: RestTypes.CreateApplicationEmojiRequest): RestTypes.CreateGuildEmojiResponse
    return self.request:post(Routes.applicationEmojis(self.applicationId), {
        body = options
    })
end

function RestClient.createGlobalApplicationCommand(self: RestClient, command: RestTypes.CreateGlobalApplicationCommandRequest, options: { bearerToken: string }?): RestTypes.CreateGlobalApplicationCommandResponse
    local restOptions: RequestHandler.CreateRequestOptions = {
        body = command
    }

    if options and options.bearerToken then
        restOptions.authenticated = false
        restOptions.headers = {
            authorization = `Bearer {options.bearerToken}`
        }
    end

    return self.request:post(Routes.interactions.commands.commands(self.applicationId), restOptions)
end

function RestClient.createGuild(self: RestClient, options: RestTypes.CreateGuildRequest): RestTypes.CreateGuildResponse
    return self.request:post(Routes.guilds.all(), {
        body = options
    })
end

function RestClient.createGuildApplicationCommand(self: RestClient, guildId: string, command: RestTypes.CreateGuildApplicationCommandRequest, options: { bearerToken: string }?): RestTypes.CreateGuildApplicationCommandResponse
    local restOptions: RequestHandler.CreateRequestOptions = {
        body = command
    }

    if options and options.bearerToken then
        restOptions.authenticated = false
        restOptions.headers = {
            authorization = `Bearer {options.bearerToken}`
        }
    end

    return self.request:post(Routes.interactions.commands.guilds.all(self.applicationId, guildId), restOptions)
end

function RestClient.createGuildFromTemplate(self: RestClient, templateCode: string, options: RestTypes.CreateGuildFromGuildTemplateRequest): RestTypes.CreateGuildFromGuildTemplateResponse
    return self.request:post(Routes.guilds.templates.code(templateCode), {
        body = options
    })
end

function RestClient.createGuildSticker(self: RestClient, guildId: string, options: RestTypes.CreateGuildStickerRequest, reason: string): RestTypes.CreateGuildStickerResponse
    return self.request:post(Routes.guilds.stickers(guildId), {
        body = options,
        reason = reason,
        file = options.file
    })
end

function RestClient.createGuildTemplate(self: RestClient, guildId: string, options: RestTypes.CreateGuildTemplateRequest): RestTypes.CreateGuildTemplateResponse
    return self.request:post(Routes.guilds.templates.all(guildId), {
        body = options
    })
end

return RestClient