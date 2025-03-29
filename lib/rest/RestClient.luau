local Routes = require("Routes")
local Logger = require("../log/Logger")
type Logger = Logger.Logger
local RequestHandler = require("RequestHandler")
type RequestHandler = RequestHandler.RequestHandler

local processDiscordReaction = require("../util/processDiscordReaction")

local ApiTypes = require("../types/apiTypes")
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
        token = `Bot {options.token}`,
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

function RestClient.addRole(self: RestClient, guildId: string, userId: string, roleId: string, reason: string?)
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

function RestClient.createApplicationEmoji(self: RestClient, options: RestTypes.CreateApplicationEmojiRequest): RestTypes.CreateApplicationEmojiResponse
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

function RestClient.createGuildSticker(self: RestClient, guildId: string, options: RestTypes.CreateGuildStickerRequest, reason: string?): RestTypes.CreateGuildStickerResponse
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

function RestClient.createForumThread(self: RestClient, channelId: string, options: RestTypes.StartThreadInForumOrMediaChannelRequest, reason: string?): RestTypes.StartThreadInForumOrMediaChannelResponse
    return self.request:post(Routes.channels.forum(channelId), {
        body = options,
        file = options.files,
        reason = reason  
    })
end

function RestClient.createInvite(self: RestClient, channelId: string, options: RestTypes.CreateChannelInviteRequest, reason: string?): RestTypes.CreateChannelInviteResponse
    return self.request:post(Routes.channels.invites(channelId), {
        body = options,
        reason = reason
    })
end

function RestClient.createRole(self: RestClient, guildId: string, options: RestTypes.CreateGuildRoleRequest, reason: string?): RestTypes.CreateGuildRoleResponse
    return self.request:post(Routes.guilds.roles.all(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.createScheduledEvent(self: RestClient, guildId: string, options: RestTypes.CreateGuildScheduledEventRequest, reason: string?): RestTypes.CreateGuildScheduledEventResponse
    return self.request:post(Routes.guilds.events.events(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.createStageInstance(self: RestClient, options: RestTypes.CreateStageInstanceRequest, reason: string?): RestTypes.CreateStageInstanceResponse
    return self.request:post(Routes.channels.stages(), {
        body = options,
        reason = reason
    })
end

function RestClient.createWebhook(self: RestClient, channelId: string, options: RestTypes.CreateWebhookRequest, reason: string?): RestTypes.CreateWebhookResponse
    return self.request:post(Routes.channels.webhooks(channelId), {
        body = options,
        reason = reason
    })
end

function RestClient.deleteAutomodRule(self: RestClient, guildId: string, ruleId: string, reason: string?)
    self.request:delete(Routes.guilds.automod.rule(guildId, ruleId), {
        reason = reason
    })
end

function RestClient.deleteChannel(self: RestClient, channelId: string, reason: string?)
    self.request:delete(Routes.channels.channel(channelId), {
        reason = reason
    })
end

function RestClient.deleteChannelPermissionOverride(self: RestClient, channelId: string, overwriteId: string, reason: string?)
    self.request:delete(Routes.channels.overwrite(channelId, overwriteId), {
        reason = reason
    })
end

function RestClient.deleteEmoji(self: RestClient, guildId: string, emojiId: string, reason: string?)
    self.request:delete(Routes.guilds.emoji(guildId, emojiId), {
        reason = reason
    })
end

function RestClient.deleteApplicationEmoji(self: RestClient, emojiId: string)
    self.request:delete(Routes.applicationEmoji(self.applicationId, emojiId))
end

function RestClient.deleteFollowupMessage(self: RestClient, token: string, messageId: string)
    self.request:delete(Routes.interactions.responses.message(self.applicationId, token, messageId), {
        authenticated = false
    })
end

function RestClient.deleteGlobalApplicationCommand(self: RestClient, commandId: string)
    self.request:delete(Routes.interactions.commands.command(self.applicationId, commandId))
end

function RestClient.deleteGuild(self: RestClient, guildId: string)
    self.request:delete(Routes.guilds.guild(guildId))
end

function RestClient.deleteGuildApplicationCommand(self: RestClient, guildId: string, commandId: string)
    self.request:delete(Routes.interactions.commands.guilds.one(self.applicationId, guildId, commandId))
end

function RestClient.deleteGuildSticker(self: RestClient, guildId: string, stickerId: string, reason: string?)
    self.request:delete(Routes.guilds.sticker(guildId, stickerId), {
        reason = reason
    })
end

function RestClient.deleteGuildTemplate(self: RestClient, guildId: string, templateCode: string)
    self.request:delete(Routes.guilds.templates.guild(guildId, templateCode))
end

function RestClient.deleteIntegration(self: RestClient, guildId: string, integrationId: string, reason: string?)
    self.request:delete(Routes.guilds.integration(guildId, integrationId), {
        reason = reason
    })
end

function RestClient.deleteInvite(self: RestClient, inviteCode: string, reason: string?)
    self.request:delete(Routes.guilds.invite(inviteCode), {
        reason = reason
    })
end

function RestClient.deleteMessage(self: RestClient, channelId: string, messageId: string, reason: string?)
    self.request:delete(Routes.channels.message(channelId, messageId), {
        reason = reason
    })
end

function RestClient.deleteMessages(self: RestClient, channelId: string, messageIds: { string }, reason: string?)
    self.request:post(Routes.channels.bulk(channelId), {
        body = {
            messages = messageIds
        },
        reason
    })
end

function RestClient.deleteOriginalInteractionResponse(self: RestClient, token: string)
    self.request:delete(Routes.interactions.responses.original(self.applicationId, token), {
        authenticated = false
    })
end

function RestClient.deleteOwnReaction(self: RestClient, channelId: string, messageId: string, reaction: string)
    reaction = processDiscordReaction(reaction)
    self.request:delete(Routes.channels.reactions.bot(channelId, messageId, reaction))
end

function RestClient.deleteReactionsAll(self: RestClient, channelId: string, messageId: string)
    self.request:delete(Routes.channels.reactions.all(channelId, messageId))
end

function RestClient.deleteReactionsEmoji(self: RestClient, channelId: string, messageId: string, reaction: string)
    reaction = processDiscordReaction(reaction)
    self.request:delete(Routes.channels.reactions.emoji(channelId, messageId, reaction))
end

function RestClient.deleteRole(self: RestClient, guildId: string, roleId: string, reason: string?)
    self.request:delete(Routes.guilds.roles.one(guildId, roleId), {
        reason = reason
    })
end

function RestClient.deleteScheduledEvent(self: RestClient, guildId: string, eventId: string)
    self.request:delete(Routes.guilds.events.event(guildId, eventId))
end

function RestClient.deleteStageInstance(self: RestClient, channelId: string, reason: string?)
    self.request:delete(Routes.channels.stage(channelId), {
        reason = reason
    })
end

function RestClient.deleteUserReaction(self: RestClient, channelId: string, messageId: string, userId: string, reaction: string)
    reaction = processDiscordReaction(reaction)
    self.request:delete(Routes.channels.reactions.user(channelId, messageId, reaction, userId))
end

function RestClient.deleteWebhook(self: RestClient, webhookId: string, reason: string?)
    self.request:delete(Routes.webhooks.id(webhookId), {
        reason = reason
    })
end

function RestClient.deleteWebhookMessage(self: RestClient, webhookId: string, token: string, messageId: string, options: { type: number, after: string?, limit: number? }?)
    self.request:delete(Routes.webhooks.message(webhookId, token, messageId, options :: any), {
        authenticated = false
    })
end

function RestClient.deleteWebhookWithToken(self: RestClient, webhookId: string, token: string)
    self.request:delete(Routes.webhooks.webhook(webhookId, token), {
        authenticated = false
    })
end

function RestClient.editApplicationCommandPermissions(self: RestClient, guildId: string, commandId: string, bearerToken: string, permissions: ApiTypes.GuildApplicationCommandPermissionObject): RestTypes.EditGuildApplicationCommandResponse
    return self.request:put(Routes.interactions.commands.permission(self.applicationId, guildId, commandId), {
        body = permissions,
        authenticated = false,
        headers = {
            authorization = `Bearer {bearerToken}`
        }
    })
end

function RestClient.editAutomodRule(self: RestClient, guildId: string, ruleId: string, options: RestTypes.EditAutoModerationRuleRequest, reason: string?): RestTypes.EditAutoModerationRuleResponse
    return self.request:patch(Routes.guilds.automod.rule(guildId, ruleId), {
        body = options,
        reason = reason
    })
end

function RestClient.editBotProfile(self: RestClient, options: RestTypes.ModifyCurrentUserRequest): RestTypes.ModifyCurrentMemberResponse
    return self.request:patch(Routes.currentUser(), {
        body = options
    })
end

function RestClient.editChannel(self: RestClient, channelId: string, options: RestTypes.ModifyChannelRequest, reason: string?): RestTypes.ModifyChannelResponse
    return self.request:patch(Routes.channels.channel(channelId), {
        body = options,
        reason = reason
    })
end

function RestClient.editChannelPermissionOverride(self: RestClient, channelId: string, options: ApiTypes.OverwriteObject, reason: string?)
    self.request:put(Routes.channels.overwrite(channelId, options.id), {
        body = options,
        reason = reason
    })
end

function RestClient.editChannelPositions(self: RestClient, guildId: string, options: RestTypes.ModifyGuildChannelPositionsRequest)
    self.request:patch(Routes.guilds.channels(guildId), {
        body = options
    })
end

function RestClient.editEmoji(self: RestClient, guildId: string, emojiId: string, options: RestTypes.ModifyGuildEmojiRequest, reason: string?): RestTypes.ModifyGuildEmojiResponse
    return self.request:patch(Routes.guilds.emoji(guildId, emojiId), {
        body = options,
        reason = reason
    })
end

function RestClient.editApplicationEmoji(self: RestClient, emojiId: string, options: RestTypes.ModifyApplicationEmojiRequest): RestTypes.ModifyApplicationEmojiResponse
    return self.request:patch(Routes.applicationEmoji(self.applicationId, emojiId), {
        body = options
    })
end

return RestClient