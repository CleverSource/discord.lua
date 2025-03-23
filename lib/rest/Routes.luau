local datetime = require("@lune/datetime")

return {
    webhooks = {
        id = function(webhookId: string): string
            return `/webhooks/{webhookId}`
        end,
        message = function(webhookId: string, token: string, messageId: string, options: { threadId: string? }?): string
            local path = `/webhooks/{webhookId}/{token}/messages/{messageId}?`
            if options then
                if options.threadId then
                    path ..= `thread_id={options.threadId}`
                end
            end

            return path
        end,
        original = function(webhookId: string, token: string, options: { threadId: string? }?): string
            local path = `/webhooks/{webhookId}/{token}/@original?`

            if options then
                if options.threadId then
                    path ..= `thread_id={options.threadId}`
                end
            end

            return path
        end,
        webhook = function(webhookId: string, token: string, options: { wait: boolean?, threadId: string? }?): string
            local path = `/webhooks/{webhookId}/{token}?`

            if options then
                if options.wait then
                    path ..= `wait={options.wait}`
                end

                if options.threadId then
                    path ..= `thread_id={options.threadId}`
                end
            end

            return path
        end
    },

    channels = {
        bulk = function(channelId: string): string
            return `/channels/{channelId}/messages/bulk-delete`
        end,
        dm = function(): string
            return "/users/@me/channels"
        end,
        dmRecipient = function(channelId: string, userId: string): string
            return `/channels/{channelId}/recipients/{userId}`
        end,
        pin = function(channelId: string, messageId: string): string
            return `/channels/{channelId}/pins/{messageId}`
        end,
        pins = function(channelId: string): string
            return `/channels/{channelId}/pins`
        end,
        reactions = {
            bot = function(channelId: string, messageId: string, emoji: string): string
                return `/channels/{channelId}/messages/{messageId}/reactions/{emoji}/@me`
            end,
            user = function(channelId: string, messageId: string, emoji: string, userId: string): string
                return `/channels/{channelId}/messages/{messageId}/reactions/{emoji}/{userId}`
            end,
            all = function(channelId: string, messageId: string): string
                return `/channels/{channelId}/messages/{messageId}/reactions`
            end,
            emoji = function(channelId: string, messageId: string, emoji: string, options: { type: number, after: string?, limit: number? }?): string
                local path = `/channels/{channelId}/messages/{messageId}/reactions/{emoji}?`

                if options then
                    if options.type then
                        path ..= `type={options.type}`
                    end

                    if options.after then
                        path ..= `&after={options.after}`
                    end

                    if options.limit then
                        path ..= `&limit={options.limit}`
                    end
                end

                return path
            end,
            message = function(channelId: string, messageId: string, emoji: string, options: { type: number, after: string?, limit: number? }?): string
                local path = `/channels/{channelId}/messages/{messageId}/reactions/{emoji}?`
    
                if options then
                    if options.after then
                        path ..= `after={options.after}`
                    end

                    if options.limit then
                        path ..= `&limit={options.limit}`
                    end
                end

                return path
            end
        },
        webhooks = function(channelId: string): string
            return `/channels/{channelId}/webhooks`
        end,
        channel = function(channelId: string): string
            return `/channels/{channelId}`
        end,
        follow = function(channelId: string): string
            return `/channels/{channelId}/followers`
        end,
        forum = function(channelId: string): string
            return `/channels/{channelId}/threads`
        end,
        invites = function(channelId: string): string
            return `/channels/{channelId}/invites`
        end,
        message = function(channelId: string, messageId: string): string
            return `/channels/{channelId}/messages/{messageId}`
        end,
        messages = function(channelId: string, options: { limit: number?, after: string?, before: string?, around: string? }?): string
            local path = `/channels/{channelId}/messages?`

            if options then
                if options.after then
                    path ..= `after={options.after}`
                end

                if options.before then
                    path ..= `&before={options.before}`
                end

                if options.around then
                    path ..= `&around={options.around}`
                end

                if options.limit then
                    path ..= `&limit={options.limit}`
                end
            end

            return path
        end,
        overwrite = function(channelId: string, overwriteId: string): string
            return `/channels/{channelId}/permissions/{overwriteId}`
        end,
        crosspost = function(channelId: string, messageId: string): string
            return `/channels/{channelId}/messages/{messageId}/crosspost`
        end,
        stages = function(): string
            return "/stage-instances"
        end,
        stage = function(channelId: string): string
            return `/stage-instances/{channelId}`
        end,
        threads = {
            message = function(channelId: string, messageId: string): string
                return `/channels/{channelId}/messages/{messageId}/threads`
            end,
            all = function(channelId: string): string
                return `/channels/{channelId}/threads`
            end,
            active = function(guildId: string): string
                return `/guilds/{guildId}/threads/active`
            end,
            members = function(channelId: string, options: { withMember: boolean?, after: string?, limit: number? }?): string
                local path = `/channels/{channelId}/thread-members?`

                if options then 
                    if options.withMember then
                        path ..= `with_member={options.withMember}`
                    end
                    
                    if options.limit then
                        path ..= `&limit={options.limit}`
                    end

                    if options.after then
                        path ..= `&after={options.after}`
                    end
                end

                return path
            end,
            me = function(channelId: string): string
                return `/channels/{channelId}/thread-members/@me`
            end,
            getUser = function(channelId: string, userId: string, options: { withMember: boolean? }?): string
                local path = `/channels/{channelId}/thread-members/{userId}?`

                if options then
                    if options.withMember then 
                        path ..= `with_member={options.withMember}`
                    end
                end

                return path
            end,
            user = function(channelId: string, userId: string): string
                return `/channels/{channelId}/thread-members/{userId}`
            end,
            archived = function(channelId: string): string
                return `/channels/{channelId}/threads/archived`
            end,
            public = function(channelId: string, options: { before: number?, limit: number? }?): string
                local path = `/channels/{channelId}/threads/archived/public?`

                if options then
                    if options.before then
                        path ..= `before={datetime.fromUnixTimestamp(options.before):toIsoDate()}`
                    end

                    if options.limit then 
                        path ..= `&limit={options.limit}`
                    end
                end

                return path
            end,
            private = function(channelId: string, options: { before: number?, limit: number? }?): string
                local path = `/channels/{channelId}/threads/archived/private?`

                if options then
                    if options.before then
                        path ..= `before={datetime.fromUnixTimestamp(options.before):toIsoDate()}`
                    end

                    if options.limit then 
                        path ..= `&limit={options.limit}`
                    end
                end

                return path
            end,
            joined = function(channelId: string, options: { before: number?, limit: number? }?): string
                local path = `/channels/{channelId}/users/@me/threads/archived/private?`

                if options then
                    if options.before then
                        path ..= `before={datetime.fromUnixTimestamp(options.before):toIsoDate()}`
                    end
                    if options.limit then
                        path ..= `&limit={options.limit}`
                    end
                end

                return path
            end,
        },
        typing = function(channelId: string): string
            return `/channels/{channelId}/typing`
        end,
        polls = {
            votes = function(channelId: string, messageId: string, answerId: string, options: { after: string?, limit: number? }?): string
                local path = `/channels/{channelId}/polls/{messageId}/answers/{answerId}?`

                if options then
                    if options.after then
                        path ..= `after={options.after}`
                    end

                    if options.limit then
                        path ..= `&limit={options.limit}`
                    end
                end

                return path
            end,
            expire = function(channelId: string, messageId: string): string
                return `/channels/{channelId}/polls/{messageId}/expire`
            end
        }
    },

    

    gateway = function(): string
        return "/gateway"
    end,
    gatewayBot = function(): string
        return "/gateway/bot"
    end,
    user = function(userId: string): string
        return `/users/{userId}`
    end,
    currentUser = function(): string
        return "/users/@me"
    end,
    stickerPacks = function(): string
        return "/sticker-packs"
    end,
    stickerPack = function(stickerPackId: string): string
        return `/sticker-packs/{stickerPackId}`
    end,
    application = function(): string
        return "/applications/@me"
    end,
    applicationActivityInstance = function(applicationId: string, instanceId: string): string
        return `/applications/{applicationId}/activity-instances/{instanceId}`
    end
}