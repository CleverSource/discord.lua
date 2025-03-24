local Routes = require("Routes")
local Logger = require("../log/Logger")
type Logger = Logger.Logger
local RequestHandler = require("RequestHandler")
type RequestHandler = RequestHandler.RequestHandler

local processDiscordReaction = require("../util/processDiscordReaction")

local GatewayTypes = require("../types/internal/gateway")
local RestTypes = require("../types/internal/rest")

local RestClient = {}
RestClient.__index = RestClient

export type RestClientOptions = {
    token: string?,
    logger: Logger?,
    preferSnakeCase: boolean?
}

export type RestClient = typeof(setmetatable({} :: {
    logger: Logger,
    request: RequestHandler
}, RestClient))

function RestClient.new(options: RestClientOptions): RestClient
    local self = setmetatable({}, RestClient) :: RestClient

    self.logger = options.logger or Logger.new()
    self.request = RequestHandler.new({
        token = options.token,
        preferSnakeCase = options.preferSnakeCase or false,
        logger = self.logger
    })

    return self
end

function RestClient.getGateway(self: RestClient): { url: string }
    return self.request:get(Routes.gateway(), {
        authenticated = false
    })
end

function RestClient.getBotGateway(self: RestClient): GatewayTypes.GetGatewayBot
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
        body = {
            reason = reason
        }
    })
end

function RestClient.addThreadMember(self: RestClient, channelId: string, userId: string)
    self.request:put(Routes.channels.threads.user(channelId, userId))
end

function RestClient.addDmRecipient(self: RestClient, channelId: string, userId: string, options: RestTypes.AddDmRecipientOptions)
    self.request:put(Routes.channels.dmRecipient(channelId, userId), {
        body = options
    })
end

return RestClient