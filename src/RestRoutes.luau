export type RestRoutes = {
    gatewayBot: () -> string,

    webhooks: {
        id: (webhookId: string) -> string,
        webhook: (webhookId: string, token: string, options: { wait: boolean?, threadId: string? }?) -> string,
        message: (webhookId: string, token: string, messageId: string, options: { threadId: string? }?) -> string
    },

    channels: {
        bulk: (channelId: string) -> string,
        dm: () -> string,
        dmRecipient: (channelId: string, userId: string) -> string,
        pin: (channelId: string, messageId: string) -> string,
        pins: (channelId: string) -> string,
        webhooks: (channelId: string) -> string,
        channel: (channelId: string) -> string,
        follow: (channelId: string) -> string
    }
}

return {
    gatewayBot = function() 
        return "/gateway/bot"
    end,

    webhooks = {
        id = function(webhookId)
            return `/webhooks/{webhookId}`
        end,
        webhook = function(webhookId, token, options)
            local url = `/webhooks/{webhookId}/{token}?`

            if options then
                if options.wait then
                    url = url .. `wait={tostring(options.wait)}`
                end
                if options.threadId then
                    url = url .. `&thread_id={options.threadId}`
                end
            end

            return url
        end,
        message = function(webhookId, token, messageId, options)
            local url = `/webhooks/{webhookId}/{token}/messages/{messageId}?`

            if options then
                if options.threadId then
                    url = url .. `thread_id={options.threadId}`
                end
            end

            return url
        end
    },

    channels = {
        bulk = function(channelId)
            return `/channels/{channelId}/messages/bulk-delete`
        end,
        dm = function()
            return "/users/@me/channels" 
        end,
        dmRecipient = function(channelId, userId)
            return `/channels/{channelId}/recipients/{userId}`
        end,
        pin = function(channelId, messageId)
            return `/channels/{channelId}/pins/{messageId}`
        end,
        pins = function(channelId)
            return `/channels/{channelId}/pins`
        end,
        webhooks = function(channelId)
            return `/channels/{channelId}/webhooks`
        end,
        channel = function(channelId)
            return `/channels/{channelId}`
        end,
        follow = function(channelId)
            return `/channels/{channelId}/followers`
        end
    }
} :: RestRoutes