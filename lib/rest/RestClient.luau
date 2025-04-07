local Routes = require("Routes")
local Logger = require("../log/Logger")
type Logger = Logger.Logger
local RequestHandler = require("RequestHandler")
type RequestHandler = RequestHandler.RequestHandler

local processDiscordReaction = require("../util/processDiscordReaction")

local Constants = require("../Constants")
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

function RestClient.editFollowupMessage(self: RestClient, token: string, messageId: string, options: RestTypes.EditFollowupMessageRequest): RestTypes.EditFollowupMessageResponse
    return self.request:patch(Routes.interactions.responses.message(self.applicationId, token, messageId), {
        body = options,
        file = options.files,
        authenticated = false
    })
end

function RestClient.editGlobalApplicationCommand(self: RestClient, commandId: string, options: RestTypes.EditGlobalApplicationCommandRequest): RestTypes.EditGlobalApplicationCommandResponse
    return self.request:patch(Routes.interactions.commands.command(self.applicationId, commandId), {
        body = options
    })
end

function RestClient.editGuild(self: RestClient, guildId: string, options: RestTypes.ModifyGuildRequest, reason: string?): RestTypes.ModifyGuildResponse
    return self.request:patch(Routes.guilds.guild(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.editGuildApplicationCommand(self: RestClient, guildId: string, commandId: string, options: RestTypes.EditGuildApplicationCommandRequest): RestTypes.EditGuildApplicationCommandResponse
    return self.request:patch(Routes.interactions.commands.guilds.one(self.applicationId, guildId, commandId), {
        body = options
    })
end

function RestClient.editGuildMfaLevel(self: RestClient, guildId: string, mfaLeveL: ApiTypes.MFALevel, reason: string?)
    self.request:post(Routes.guilds.mfa(guildId), {
        body = {
            level = mfaLeveL
        },
        reason = reason
    })
end

function RestClient.editGuildSticker(self: RestClient, guildId: string, stickerId: string, options: RestTypes.ModifyGuildStickerRequest, reason: string?): RestTypes.ModifyGuildStickerResponse
    return self.request:patch(Routes.guilds.sticker(guildId, stickerId), {
        body = options,
        reason = reason
    })
end

function RestClient.editGuildTemplate(self: RestClient, guildId: string, templateCode: string, options: RestTypes.ModifyGuildTemplateRequest): RestTypes.ModifyGuildTemplateResponse
    return self.request:patch(Routes.guilds.templates.guild(guildId, templateCode), {
        body = options
    })
end

function RestClient.editMessage(self: RestClient, channelId: string, messageId: string, options: RestTypes.EditMessageRequest): RestTypes.EditMessageResponse
    return self.request:patch(Routes.channels.message(channelId, messageId), {
        body = options,
        file = options.files
    })
end

function RestClient.editOriginalInteractionResponse(self: RestClient, token: string, options: RestTypes.EditOriginalInteractionRequest): RestTypes.EditOriginalInteractionResponse
    return self.request:patch(Routes.interactions.responses.original(self.applicationId, token), {
        body = options,
        file = options.files,
        authenticated = false
    })
end

function RestClient.editOriginalWebhookMessage(self: RestClient, webhookId: string, token: string, options: RestTypes.EditOriginalWebhookRequest): RestTypes.EditOriginalWebhookRequest
    return self.request:patch(Routes.webhooks.original(webhookId, token, options), {
        body = {
            type = Constants.InteractionResponseTypes.UpdateMessage,
            data = options
        },
        file = options.files,
        authenticated = false
    })
end

function RestClient.editOwnVoiceState(self: RestClient, guildId: string, options: RestTypes.ModifyCurrentUserVoiceStateRequest)
    if options.requestToSpeakTimestamp and typeof(options.requestToSpeakTimestamp) ~= "string" then
        options.requestToSpeakTimestamp = options.requestToSpeakTimestamp:toIsoDate()
    end

    self.request:patch(Routes.guilds.voice(guildId), {
        body = options
    })
end

function RestClient.editScheduledEvent(self: RestClient, guildId: string, eventId: string, options: RestTypes.ModifyGuildScheduledEventRequest, reason: string?): RestTypes.ModifyGuildScheduledEventResponse
    return self.request:patch(Routes.guilds.events.event(guildId, eventId), {
        body = options,
        reason = reason
    })
end

function RestClient.editRole(self: RestClient, guildId: string, roleId: string, options: RestTypes.ModifyGuildRoleRequest, reason: string?): RestTypes.ModifyGuildRoleResponse
    return self.request:patch(Routes.guilds.roles.one(guildId, roleId), {
        body = options,
        reason = reason
    })
end

function RestClient.editRolePositions(self: RestClient, guildId: string, options: RestTypes.ModifyGuildRolePositionsRequest, reason: string?): RestTypes.ModifyGuildRolePositionsResponse
    return self.request:patch(Routes.guilds.roles.all(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.editStageInstance(self: RestClient, channelId: string, topic: string, reason: string?): RestTypes.ModifyStageInstanceResponse
    return self.request:patch(Routes.channels.stage(channelId), {
        body = {
            topic = topic
        },
        reason = reason
    })
end

function RestClient.editUserVoiceState(self: RestClient, guildId: string, options: RestTypes.ModifyUserVoiceStateRequest)
    self.request:patch(Routes.guilds.voice(guildId, options.userId), {
        body = options
    })
end

function RestClient.editWebhook(self: RestClient, webhookId: string, options: RestTypes.ModifyWebhookRequest, reason: string?): RestTypes.ModifyWebhookResponse
    return self.request:patch(Routes.webhooks.id(webhookId), {
        body = options,
        reason = reason
    })
end

function RestClient.editWebhookMessage(self: RestClient, webhookId: string, token: string, messageId: string, options: RestTypes.EditWebhookMessageRequest): RestTypes.EditWebhookMessageResponse
    return self.request:patch(Routes.webhooks.message(webhookId, token, messageId, options), {
        body = options,
        file = options.files,
        authenticated = false
    })
end

function RestClient.editWebhookWithToken(self: RestClient, webhookId: string, token: string, options: RestTypes.ModifyWebhookRequest): RestTypes.ModifyWebhookResponse
    return self.request:patch(Routes.webhooks.webhook(webhookId, token), {
        body = options,
        authenticated = false
    })
end

function RestClient.editWelcomeScreen(self: RestClient, guildId: string, options: RestTypes.ModifyGuildWelcomeScreenRequest, reason: string?): RestTypes.ModifyGuildWelcomeScreenResponse
    return self.request:patch(Routes.guilds.welcome(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.editWidgetSettings(self: RestClient, guildId: string, options: RestTypes.ModifyGuildWidgetRequest, reason: string?): RestTypes.ModifyGuildWidgetResponse
    return self.request:patch(Routes.guilds.widget(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.executeWebhook(self: RestClient, webhookId: string, token: string, options: RestTypes.ExecuteWebhookRequest): RestTypes.ExecuteWebhookResponse
    return self.request:post(Routes.webhooks.webhook(webhookId, token, options :: any), {
        body = options,
        file = options.files,
        authenticated = false
    })
end

function RestClient.followAnnouncement(self: RestClient, sourceChannelId: string, targetChannelId: string, reason: string?)
    return self.request:post(Routes.channels.follow(sourceChannelId), {
        body = {
            webhookChannelId = targetChannelId
        },
        reason = reason
    })
end

function RestClient.getActiveThreads(self: RestClient, guildId: string): RestTypes.ListActiveGuildThreadsResponse
    return self.request:get(Routes.channels.threads.active(guildId))
end

function RestClient.getApplicationCommandPermission(self: RestClient, guildId: string, commandId: string, options: RestTypes.GetApplicationCommandPermissionRequest): RestTypes.GetApplicationCommandPermissionResponse
    local restOptions: RequestHandler.CreateRequestOptions = {}
    local applicationId = options.applicationId or self.applicationId

    if options and options.accessToken then
        restOptions.authenticated = false
        restOptions.headers = {
            authorization = `Bearer {options.accessToken}`
        }
    end

    return self.request:get(Routes.interactions.commands.permission(applicationId, guildId, commandId), restOptions)
end

function RestClient.getApplicationCommandPermissions(self: RestClient, guildId: string, options: RestTypes.GetApplicationCommandPermissionRequest): RestTypes.GetApplicationCommandPermissionsResponse
    local restOptions: RequestHandler.CreateRequestOptions = {}
    local applicationId = options.applicationId or self.applicationId

    if options and options.accessToken then
        restOptions.authenticated = false
        restOptions.headers = {
            authorization = `Bearer {options.accessToken}`
        }
    end

    return self.request:get(Routes.interactions.commands.permissions(applicationId, guildId), restOptions)
end

function RestClient.getApplicationInfo(self: RestClient): RestTypes.GetCurrentApplicationResponse
    return self.request:get(Routes.oauth2.application())
end

function RestClient.editApplicationInfo(self: RestClient, options: RestTypes.EditCurrentApplicationRequest): RestTypes.EditCurrentApplicationResponse
    return self.request:patch(Routes.application(), {
        body = options
    })
end

function RestClient.getCurrentAuthenticationInfo(self: RestClient, token: string): RestTypes.GetCurrentAuthorization
    return self.request:get(Routes.oauth2.currentAuthorization(), {
        headers = {
            authorization = `Bearer {token}`
        },
        authenticated = false
    })
end

-- TODO: exchange tokens

function RestClient.getAuditLog(self: RestClient, guildId: string, options: { userId: string?, actionType: number?, before: string?, after: string?, limit: number? }?): RestTypes.GetGuildAuditLogResponse
    return self.request:get(Routes.guilds.auditlogs(guildId, options))
end

function RestClient.getAutomodRule(self: RestClient, guildId: string, ruleId: string): RestTypes.GetAutoModerationRuleResponse
    return self.request:get(Routes.guilds.automod.rule(guildId, ruleId))
end

function RestClient.getAutomodRules(self: RestClient, guildId: string):  { RestTypes.GetAutoModerationRuleResponse }
    return self.request:get(Routes.guilds.automod.rules(guildId))
end

function RestClient.getAvailableVoiceRegions(self: RestClient): RestTypes.GetCurrentUserVoiceStateResponse
    return self.request:get(Routes.regions())
end

function RestClient.getBan(self: RestClient, guildId: string, userId: string): RestTypes.GetGuildBanResponse
    return self.request:get(Routes.guilds.members.ban(guildId, userId))
end

function RestClient.getBans(self: RestClient, guildId: string, options: { limit: number?, before: string?, after: string? }?): RestTypes.GetGuildBansResponse
    return self.request:get(Routes.guilds.members.bans(guildId, options))
end

function RestClient.getChannel(self: RestClient, channelId: string): RestTypes.GetGuildChannelResponse
    return self.request:get(Routes.channels.channel(channelId))
end 

function RestClient.getChannelInvites(self: RestClient, channelId: string): RestTypes.GetChannelInvitesResponse
    return self.request:get(Routes.channels.invites(channelId))
end

function RestClient.getChannels(self: RestClient, guildId: string): RestTypes.GetGuildChannelsResponse
    return self.request:get(Routes.guilds.channels(guildId))
end

function RestClient.getChannelWebhooks(self: RestClient, channelId: string): RestTypes.GetChannelWebhooksResponse
    return self.request:get(Routes.channels.webhooks(channelId))
end

function RestClient.getDmChannel(self: RestClient, userId: string): RestTypes.GetDmChannelResponse
    return self.request:post(Routes.channels.dm(), {
        body = {
            recipientId = userId
        }
    })
end

function RestClient.getGroupDmChannel(self: RestClient, options: { accessTokens: { string }, nicks: { [string]: string }? }): RestTypes.GetDmChannelResponse
    return self.request:post(Routes.channels.dm(), {
        body = options
    })
end

function RestClient.getEmoji(self: RestClient, guildId: string, emojiId: string): RestTypes.GetGuildEmojiResponse
    return self.request:get(Routes.guilds.emoji(guildId, emojiId))
end

function RestClient.getApplicationEmoji(self: RestClient, emojiId: string): RestTypes.GetApplicationEmojiResponse
    return self.request:get(Routes.applicationEmoji(self.applicationId, emojiId))
end

function RestClient.getEmojis(self: RestClient, guildId: string): RestTypes.GetGuildEmojisResponse
    return self.request:get(Routes.guilds.emojis(guildId))
end

function RestClient.getApplicationEmojis(self: RestClient): RestTypes.GetApplicationEmojisResponse
    return self.request:get(Routes.applicationEmojis(self.applicationId))
end

function RestClient.getFollowupMessage(self: RestClient, token: string, messageId: string): RestTypes.GetFollowupMessageResponse
    return self.request:get(Routes.interactions.responses.message(self.applicationId, token, messageId), {
        authenticated = false
    })
end

function RestClient.getGlobalApplicationCommand(self: RestClient, commandId: string): RestTypes.GetGlobalApplicationCommandResponse
    return self.request:get(Routes.interactions.commands.command(self.applicationId, commandId))
end

function RestClient.getGlobalApplicationCommands(self: RestClient): RestTypes.GetGlobalApplicationCommandsResponse
    return self.request:get(Routes.interactions.commands.commands(self.applicationId))
end

function RestClient.getGuild(self: RestClient, guildId: string, options: { count: boolean }?): RestTypes.GetGuildResponse
    return self.request:get(Routes.guilds.guild(guildId, options and options.count or true))
end

function RestClient.getGuilds(self: RestClient, token: string, options: { before: string?, after: string?, limit: number?, withCounts: boolean? }?): RestTypes.GetGuildsResponse
     local restOptions: RequestHandler.CreateRequestOptions = token and {
        headers = {
            authorization = `Bearer {token}`
        },
        authenticated = false
     } or {}

     return self.request:get(Routes.guilds.userGuilds(options), restOptions)
end

function RestClient.getGuildApplicationCommand(self: RestClient, commandId: string, guildId: string): RestTypes.GetGuildApplicationCommandResponse
    return self.request:get(Routes.interactions.commands.guilds.one(self.applicationId, guildId, commandId))
end

function RestClient.getGuildApplicationCommands(self: RestClient, guildId: string): RestTypes.GetGuildApplicationCommandsResponse
    return self.request:get(Routes.interactions.commands.guilds.all(self.applicationId, guildId))
end

function RestClient.getGuildPreview(self: RestClient, guildId: string): RestTypes.GetGuildPreviewResponse
    return self.request:get(Routes.guilds.preview(guildId))
end

function RestClient.getGuildTemplate(self: RestClient, templateCode: string): RestTypes.GetGuildTemplateResponse
    return self.request:get(Routes.guilds.templates.code(templateCode))
end

function RestClient.getGuildTemplates(self: RestClient, guildId: string): RestTypes.GetGuildTemplatesResponse
    return self.request:get(Routes.guilds.templates.all(guildId))
end

function RestClient.getGuildWebhooks(self: RestClient, guildId: string): RestTypes.GetGuildWebhooksResponse
    return self.request:get(Routes.guilds.webhooks(guildId))
end

function RestClient.getIntegrations(self: RestClient, guildId: string): RestTypes.GetGuildIntegrationsResponse
    return self.request:get(Routes.guilds.integrations(guildId))
end

function RestClient.getInvite(self: RestClient, inviteCode: string, options: { withCounts: boolean?, withExpiration: boolean?, scheduledEventId: string? }?): RestTypes.GetInviteResponse
    return self.request:get(Routes.guilds.invite(inviteCode, options))
end

function RestClient.getInvites(self: RestClient, guildId: string): RestTypes.GetGuildInvitesResponse
    return self.request:get(Routes.guilds.invites(guildId))
end

function RestClient.getMessage(self: RestClient, channelId: string, messageId: string): RestTypes.GetChannelMessageResponse
    return self.request:get(Routes.channels.message(channelId, messageId))
end

function RestClient.getMessages(self: RestClient, channelId: string, options: { limit: number?, after: string?, before: string?, around: string? }?): RestTypes.GetChannelMessagesResponse
    return self.request:get(Routes.channels.messages(channelId, options))
end

function RestClient.getStickerPacks(self: RestClient): RestTypes.GetStickerPacksResponse
    return self.request:get(Routes.stickerPacks())
end

function RestClient.getOriginalInteractionResponse(self: RestClient, token: string): RestTypes.GetOriginalInteractionResponse
    return self.request:get(Routes.interactions.responses.original(self.applicationId, token), {
        authenticated = false
    })
end

function RestClient.getPinnedMessages(self: RestClient, channelId: string): RestTypes.GetPinnedMessagesResponse
    return self.request:get(Routes.channels.pins(channelId))
end

function RestClient.getPrivateArchivedThreads(self: RestClient, channelId: string, options: { before: number?, limit: number? }?): RestTypes.ListPrivateArchivedThreadsResponse
    return self.request:get(Routes.channels.threads.private(channelId, options))
end

function RestClient.getPrivateJoinedArchivedThreads(self: RestClient, channelId: string, options: { before: number?, limit: number? }?): RestTypes.ListJoinedPrivateArchivedThreadsResponse
    return self.request:get(Routes.channels.threads.joined(channelId, options))
end

function RestClient.getPruneCount(self: RestClient, guildId: string, options: { days: number?, includeRoles: (string | { string })? }?): RestTypes.GetGuildPruneCountResponse
    return self.request:get(Routes.guilds.prune(guildId, options))
end

function RestClient.getPublicArchivedThreads(self: RestClient, channelId: string, options: { before: number?, limit: number? }?): RestTypes.ListPublicArchivedThreadsResponse
    return self.request:get(Routes.channels.threads.public(channelId, options))
end

function RestClient.getRoles(self: RestClient, guildId: string): RestTypes.GetGuildRolesResponse
    return self.request:get(Routes.guilds.roles.all(guildId)) 
end

function RestClient.getRole(self: RestClient, guildId: string, roleId: string): RestTypes.GetGuildRoleResponse
    return self.request:get(Routes.guilds.roles.one(guildId, roleId))
end

function RestClient.getScheduledEvent(self: RestClient, guildId: string, eventId: string, options: { withUserCount: boolean? }?): RestTypes.GetGuildScheduledEventResponse
    return self.request:get(Routes.guilds.events.event(guildId, eventId, options and options.withUserCount))
end

function RestClient.getScheduledEvents(self: RestClient, guildId: string, options: { withUserCount: boolean? }?): RestTypes.GetGuildScheduledEventsResponse
    return self.request:get(Routes.guilds.events.events(guildId, options and options.withUserCount))
end

function RestClient.getScheduledEventUsers(self: RestClient, guildId: string, eventId: string, options: { limit: number?, withMember: boolean?, before: string?, after: string? }?): RestTypes.ListScheduledEventUsersResponse
    return self.request:get(Routes.guilds.events.users(guildId, eventId, options))
end

function RestClient.getStageInstance(self: RestClient, channelId: string): RestTypes.GetStageInstanceResponse
    return self.request:get(Routes.channels.stage(channelId))
end

function RestClient.getOwnVoiceState(self: RestClient, guildId: string): RestTypes.GetCurrentUserVoiceStateResponse
    return self.request:get(Routes.guilds.voice(guildId))
end

function RestClient.getUserVoiceState(self: RestClient, guildId: string, userId: string): RestTypes.GetUserVoiceStateResponse
    return self.request:get(Routes.guilds.voice(guildId, userId))
end

function RestClient.getSticker(self: RestClient, stickerId: string): RestTypes.GetStickerResponse
    return self.request:get(Routes.sticker(stickerId))
end

function RestClient.getGuildSticker(self: RestClient, guildId: string, stickerId: string): RestTypes.GetGuildStickerResponse
    return self.request:get(Routes.guilds.sticker(guildId, stickerId))
end

function RestClient.getGuildStickers(self: RestClient, guildId: string): RestTypes.GetGuildStickerResponse
    return self.request:get(Routes.guilds.stickers(guildId))
end

function RestClient.getThreadMember(self: RestClient, channelId: string, userId: string, options: { withMember: boolean? }?): RestTypes.GetThreadMemberResponse
    return self.request:get(Routes.channels.threads.getUser(channelId, userId, options))
end

function RestClient.getThreadMembers(self: RestClient, channelId: string, options: { withMember: boolean?, after: string?, limit: number? }?): RestTypes.ListThreadMembersResponse
    return self.request:get(Routes.channels.threads.members(channelId, options))
end

function RestClient.getReactions(self: RestClient, channelId: string, messageId: string, reaction: string, options: { type: number, after: string?, limit: number? }?): RestTypes.GetReactionsResponse
    return self.request:get(Routes.channels.reactions.message(channelId, messageId, reaction, options))
end

function RestClient.getUser(self: RestClient, userId: string): RestTypes.GetUserResponse
    return self.request:get(Routes.user(userId))
end

function RestClient.getCurrentUser(self: RestClient, token: string): RestTypes.GetCurrentUserResponse
    return self.request:get(Routes.currentUser(), {
        headers = {
            authorization = `Bearer {token}`
        },
        authenticated = false
    })
end

function RestClient.getUserConnections(self: RestClient, token: string): RestTypes.GetCurrentUserConnectionResponse
    return self.request:get(Routes.oauth2.connections(), {
        headers = {
            authorization = `Bearer {token}`
        },
        authenticated = false
    })
end

function RestClient.getUserApplicationRoleConnection(self: RestClient, token: string, applicationId: string): RestTypes.GetCurrentUserApplicationRoleConnectionResponse
    return self.request:get(Routes.oauth2.roleConnections(applicationId), {
        headers = {
            authorization = `Bearer {token}`
        },
        authenticated = false
    })
end

function RestClient.getVanityUrl(self: RestClient, guildId: string): RestTypes.GetGuildVanityUrlResponse
    return self.request:get(Routes.guilds.vanity(guildId))
end

function RestClient.getVoiceRegions(self: RestClient, guildId: string): RestTypes.GetGuildVoiceRegionsResponse
    return self.request:get(Routes.guilds.regions(guildId))
end

function RestClient.getWebhook(self: RestClient, webhookId: string): RestTypes.GetWebhookResponse
    return self.request:get(Routes.webhooks.id(webhookId))
end

function RestClient.getWebhookMessage(self: RestClient, webhookId: string, token: string, messageId: string, options: { threadId: string? }?): RestTypes.GetWebhookMessageResponse
    return self.request:get(Routes.webhooks.message(webhookId, token, messageId, options), {
        authenticated = false
    })
end

function RestClient.getWebhookWithToken(self: RestClient, webhookId: string, token: string): RestTypes.GetWebhookWithTokenResponse
    return self.request:get(Routes.webhooks.webhook(webhookId, token), {
        authenticated = false
    })
end

function RestClient.getWelcomeScreen(self: RestClient, guildId: string): RestTypes.GetGuildWelcomeScreenResponse
    return self.request:get(Routes.guilds.welcome(guildId))
end

function RestClient.getWidget(self: RestClient, guildId: string): RestTypes.GetGuildWidgetResponse
    return self.request:get(Routes.guilds.widgetJson(guildId))
end

function RestClient.getWidgetSettings(self: RestClient, guildId: string): RestTypes.GetGuildWidgetSettingsResponse
    return self.request:get(Routes.guilds.widget(guildId))
end

function RestClient.joinThread(self: RestClient, channelId: string)
    self.request:put(Routes.channels.threads.me(channelId))
end

function RestClient.leaveGuild(self: RestClient, guildId: string)
    self.request:delete(Routes.guilds.leave(guildId))
end

function RestClient.leaveThread(self: RestClient, channelId: string)
    self.request:delete(Routes.channels.threads.me(channelId))
end

function RestClient.publishMessage(self: RestClient, channelId: string, messageId: string): RestTypes.CrosspostMessageResponse
    return self.request:post(Routes.channels.crosspost(channelId, messageId))
end

function RestClient.removeRole(self: RestClient, guildId: string, userId: string, roleId: string, reason: string?)
    return self.request:delete(Routes.guilds.roles.member(guildId, userId, roleId), {
        reason = reason
    })
end

function RestClient.removeThreadMember(self: RestClient, channelId: string, userId: string)
    self.request:delete(Routes.channels.threads.user(channelId, userId))
end

function RestClient.removeDmRecipient(self: RestClient, channelId: string, userId: string)
    self.request:delete(Routes.channels.dmRecipient(channelId, userId))
end

function RestClient.sendFollowupMessage(self: RestClient, token: string, options: RestTypes.CreateFollowupMessageRequest): RestTypes.CreateFollowupMessageResponse
    return self.request:post(Routes.webhooks.webhook(self.applicationId, token), {
        body = options,
        file = options.files,
        authenticated = false
    })
end

function RestClient.sendInteractionResponse(self: RestClient, interactionId: string, token: string, options: RestTypes.CreateInteractionRequest, params: { withResponse: boolean? }?): RestTypes.CreateInteractionResponse
    local optionsDataAvailable = options and options.data
    return self.request:post(Routes.interactions.responses.callback(interactionId, token, params), {
        body = options,
        file = optionsDataAvailable and options.data.files,
        -- skip queue
        authenticated = false
    })
end

function RestClient.sendMessage(self: RestClient, channelId: string, options: RestTypes.CreateMessageRequest): RestTypes.CreateMessageResponse
    return self.request:post(Routes.channels.messages(channelId), {
        body = options,
        file = options.files
    })
end

function RestClient.startThreadWithMessage(self: RestClient, channelId: string, messageId: string, options: RestTypes.StartThreadFromMessageRequest, reason: string?): RestTypes.StartThreadFromMessageResponse
    return self.request:post(Routes.channels.threads.message(channelId, messageId), {
        body = options,
        reason = reason
    })
end

function RestClient.startThreadWithoutMessage(self: RestClient, channelId: string, options: RestTypes.StartThreadWithoutMessageRequest, reason: string?): RestTypes.StartThreadWithoutMessageResponse
    return self.request:post(Routes.channels.threads.all(channelId), {
        body = options,
        reason = reason
    })
end

function RestClient.getPollAnswerVoters(self: RestClient, channelId: string, messageId: string, answerId: string, options: { after: string?, limit: number? }?): RestTypes.GetAnswerVotersResponse
    return self.request:get(Routes.channels.polls.votes(channelId, messageId, answerId, options))
end

function RestClient.endPoll(self: RestClient, channelId: string, messageId: string): RestTypes.EndPollResponse
    return self.request:post(Routes.channels.polls.expire(channelId, messageId))
end

function RestClient.syncGuildTemplate(self: RestClient, guildId: string): RestTypes.SyncGuildTemplateResponse
    return self.request:put(Routes.guilds.templates.all(guildId))
end

function RestClient.banMember(self: RestClient, guildId: string, userId: string, options: RestTypes.CreateGuildBanRequest, reason: string?)
    self.request:put(Routes.guilds.members.ban(guildId, userId), {
        body = options,
        reason = reason
    })
end

function RestClient.bulkBanMembers(self: RestClient, guildId: string, options: RestTypes.BulkGuildBanRequest, reason: string?): RestTypes.BulkGuildBanResponse
    return self.request:put(Routes.guilds.members.bulkBan(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.editBotMember(self: RestClient, guildId: string, options: RestTypes.ModifyCurrentMemberRequest, reason: string?): RestTypes.ModifyCurrentMemberResponse
    return self.request:patch(Routes.guilds.members.bot(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.editMember(self: RestClient, guildId: string, userId: string, options: RestTypes.ModifyGuildMemberRequest, reason: string?): RestTypes.ModifyGuildMemberResponse
    return self.request:patch(Routes.guilds.members.member(guildId, userId), {
        body = options,
        reason = reason
    })
end

function RestClient.getMember(self: RestClient, guildId: string, userId: string): RestTypes.GetGuildMemberResponse
    return self.request:get(Routes.guilds.members.member(guildId, userId))
end

function RestClient.getCurrentMember(self: RestClient, guildId: string, token: string): RestTypes.GetCurrentUserGuildMemberResponse
    return self.request:get(Routes.guilds.members.currentMember(guildId), {
        headers = {
            authorization = `Bearer {token}`
        },
        authenticated = false
    })
end

function RestClient.getMembers(self: RestClient, guildId: string, options: { limit: number?, after: string? }?): RestTypes.ListGuildMembersResponse
    return self.request:get(Routes.guilds.members.members(guildId, options))
end

function RestClient.getApplicationActivityInstance(self: RestClient, applicationId: string, instanceId: string): RestTypes.GetActivityInstanceResponse
    return self.request:get(Routes.applicationActivityInstance(applicationId, instanceId))
end

function RestClient.kickMember(self: RestClient, guildId: string, userId: string, reason: string?)
    self.request:delete(Routes.guilds.members.member(guildId, userId), {
        reason = reason
    })
end

function RestClient.pinMessage(self: RestClient, channelId: string, messageId: string, reason: string?)
    self.request:put(Routes.channels.pin(channelId, messageId), {
        reason = reason
    })
end

function RestClient.pruneMember(self: RestClient, guildId: string, options: RestTypes.BeginGuildPruneRequest, reason: string?): RestTypes.BeginGuildPruneResponse
    return self.request:post(Routes.guilds.members.prune(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.searchMembers(self: RestClient, guildId: string, query: string, options: { limit: number? }?): RestTypes.SearchGuildMembersResponse
    return self.request:get(Routes.guilds.members.search(guildId, query, options))
end

function RestClient.getGuildOnboarding(self: RestClient, guildId: string): RestTypes.GetGuildOnboardingResponse
    return self.request:get(Routes.guilds.onboarding(guildId))
end

function RestClient.editGuildOnboarding(self: RestClient, guildId: string, options: RestTypes.ModifyGuildOnboardingRequest, reason: string?): RestTypes.ModifyGuildOnboardingResponse
    return self.request:put(Routes.guilds.onboarding(guildId), {
        body = options,
        reason = reason
    })
end

function RestClient.modifyGuildIncidentActions(self: RestClient, guildId: string, options: RestTypes.ModifyGuildIncidentActionsRequest): RestTypes.IncidentsDataResponse
    return self.request:put(Routes.guilds.incidentActions(guildId), {
        body = options
    })
end

function RestClient.unbanMember(self: RestClient, guildId: string, userId: string, reason: string?)
    self.request:delete(Routes.guilds.members.ban(guildId, userId), {
        reason = reason
    })
end

function RestClient.unpinMessage(self: RestClient, channelId: string, messageId: string, reason: string?)
    self.request:delete(Routes.channels.pin(channelId, messageId), {
        reason = reason
    })
end

function RestClient.triggerTypingIndicator(self: RestClient, channelId: string)
    self.request:post(Routes.channels.typing(channelId))
end

function RestClient.upsertGlobalApplicationCommands(self: RestClient, command: RestTypes.EditGlobalApplicationCommandRequest, options: { bearerToken: string }?): RestTypes.EditGlobalApplicationCommandResponse
    local restOptions: RequestHandler.CreateRequestOptions = {
        body = command
    }

    if options and options.bearerToken then
        restOptions.authenticated = false
        restOptions.headers = {
            authorization = `Bearer {options.bearerToken}`
        }
    end

    return self.request:put(Routes.interactions.commands.commands(self.applicationId), restOptions)
end

function RestClient.upsertGuildApplicationCommands(self: RestClient, guildId: string, command: RestTypes.EditGuildApplicationCommandRequest, options: { bearerToken: string }?): RestTypes.EditGuildApplicationCommandResponse
    local restOptions: RequestHandler.CreateRequestOptions = {
        body = command
    }

    if options and options.bearerToken then
        restOptions.authenticated = false
        restOptions.headers = {
            authorization = `Bearer {options.bearerToken}`
        }
    end

    return self.request:put(Routes.interactions.commands.guilds.all(self.applicationId, guildId), restOptions)
end

function RestClient.editUserApplicationRoleConnection(self: RestClient, token: string, applicationId: string, options: RestTypes.UpdateCurrentUserApplicationRoleConnectionRequest): RestTypes.UpdateCurrentUserApplicationRoleConnectionResponse
    return self.request:put(Routes.oauth2.roleConnections(applicationId), {
        body = options,
        headers = {
            authorization = `Bearer {token}`
        },
        authenticated = false
    })
end

function RestClient.addGuildMember(self: RestClient, guildId: string, userId: string, options: RestTypes.AddGuildMemberRequest): RestTypes.AddGuildMemberResponse
    return self.request:put(Routes.guilds.members.member(guildId, userId), {
        body = options
    })
end

function RestClient.createTestEntitlement(self: RestClient, applicationId: string, options: RestTypes.CreateEntitlementRequest): RestTypes.CreateEntitlementResponse
    return self.request:post(Routes.monetization.entitlements(applicationId), {
        body = options
    })
end

function RestClient.listEntitlements(self: RestClient, applicationId: string, options: { userId: string?, skuIds: { string }?, before: string?, after: string?, limit: number?, guildId: string?, excludeEnded: boolean?, excludeDeleted: boolean? }?): RestTypes.ListEntitlementsResponse
    return self.request:get(Routes.monetization.entitlements(applicationId, options))
end

function RestClient.getEntitlement(self: RestClient, applicationId: string, entitlementId: string): RestTypes.GetEntitlementResponse
    return self.request:get(Routes.monetization.entitlement(applicationId, entitlementId))
end

function RestClient.deleteTestEntitlement(self: RestClient, applicationId: string, entitlementId: string)
    self.request:delete(Routes.monetization.entitlement(applicationId, entitlementId))
end

function RestClient.consumeEntitlement(self: RestClient, applicationId: string, entitlementId: string)
    self.request:post(Routes.monetization.consumeEntitlement(applicationId, entitlementId))
end

function RestClient.listSkus(self: RestClient, applicationId: string): RestTypes.ListSkusResponse
    return self.request:get(Routes.monetization.skus(applicationId))
end

-- list & get subscriptions

function RestClient.sendSoundboardSound(self: RestClient, channelId: string, options: { soundId: string, sourceGuildId: string? })
    self.request:post(Routes.soundboard.sendSound(channelId), {
        body = options
    })
end

function RestClient.listDefaultSoundboardSounds(self: RestClient): RestTypes.ListDefaultSoundboardSoundsResponse
    return self.request:get(Routes.soundboard.listDefault())
end

function RestClient.getGuildSoundboardSound(self: RestClient, guildId: string, soundId: string): RestTypes.GetGuildSoundboardSoundResponse
    return self.request:get(Routes.soundboard.guildSound(guildId, soundId))
end

function RestClient.createGuildSoundboardSound(self: RestClient, guildId: string, options: RestTypes.CreateGuildSoundboardSoundRequest, reason: string?): RestTypes.CreateGuildSoundboardSoundResponse
    return self.request:post(Routes.soundboard.guildSounds(guildId), {
        body = options,
        reason = reason,
    })
end

function RestClient.modifyGuildSoundboardSound(self: RestClient, guildId: string, soundId: string, options: RestTypes.ModifyGuildSoundboardSoundRequest, reason: string?): RestTypes.ModifyGuildSoundboardSoundResponse
    return self.request:post(Routes.soundboard.guildSound(guildId, soundId), {
        body = options,
        reason = reason,
    })
end

function RestClient.deleteGuildSoundboardSound(self: RestClient, guildId: string, soundId: string, reason: string?)
    return self.request:delete(Routes.soundboard.guildSound(guildId, soundId), {
        reason = reason,
    })
end

function RestClient.listApplicationRoleConnectionsMetadataRecords(self: RestClient, applicationId: string): RestTypes.GetApplicationRoleConnectionMetadataRecordsResponse
    return self.request:get(Routes.applicationRoleConnectionMetadata(applicationId))
end

function RestClient.updateApplicationRoleConnectionsMetadataRecords(self: RestClient, applicationId: string, options: RestTypes.UpdateApplicationRoleConnectionMetadataRecordsResponse): RestTypes.UpdateApplicationRoleConnectionMetadataRecordsResponse
    return self.request:put(Routes.applicationRoleConnectionMetadata(applicationId), {
        body = options
    })
end

return RestClient