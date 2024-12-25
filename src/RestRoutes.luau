export type RestRoutes = {
    gatewayBot: () -> string,

    webhooks: {
        id: (webhookId: string) -> string,
        webhook: (webhookId: string, token: string, options: { wait: boolean?, threadId: string? }?) -> string,
        message: (webhookId: string, token: string, messageId: string, options: { threadId: string? }?) -> string
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
    }
} :: RestRoutes