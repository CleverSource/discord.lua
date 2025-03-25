local datetime = require("@lune/datetime")
local net = require("@lune/net")

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
                return `/channels/{channelId}/messages/{messageId}/reactions/{net.urlEncode(emoji)}/@me`
            end,
            user = function(channelId: string, messageId: string, emoji: string, userId: string): string
                return `/channels/{channelId}/messages/{messageId}/reactions/{net.urlEncode(emoji)}/{userId}`
            end,
            all = function(channelId: string, messageId: string): string
                return `/channels/{channelId}/messages/{messageId}/reactions`
            end,
            emoji = function(channelId: string, messageId: string, emoji: string, options: { type: number, after: string?, limit: number? }?): string
                local path = `/channels/{channelId}/messages/{messageId}/reactions/{net.urlEncode(emoji)}?`

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
                local path = `/channels/{channelId}/messages/{messageId}/reactions/{net.urlEncode(emoji)}?`
    
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

    guilds = {
        all = function(): string
            return "/guilds"
        end,
        userGuilds = function(options: { before: string?, after: string?, limit: number?, withCounts: boolean? }?): string
            local path = "/users/@me/guilds?"

            if options then
                if options.after then
                    path ..= `after={options.after}`
                end

                if options.before then
                    path ..= `&before={options.before}`
                end

                if options.limit then
                    path ..= `&limit={options.limit}`
                end

                if options.withCounts then
                    path ..= `&with_counts={options.withCounts}`
                end
            end

            return path
        end,
        auditLogs = function(guildId: string, options: { userId: string?, actionType: number?, before: string?, after: string?, limit: number? }?): string
            local path = `/guilds/{guildId}/audit-logs?`

            if options then
                if options.actionType then
                    path ..= `action_type={options.actionType}`
                end

                if options.before then
                    path ..= `&before={options.before}`
                end

                if options.after then
                    path ..= `&after={options.after}`
                end

                if options.limit then
                    path ..= `&limit={options.limit}`
                end

                if options.userId then
                    path ..= `&user_id={options.userId}`
                end
            end

            return path
        end,
        automod = {
            rule = function(guildId: string, ruleId: string): string
                return `/guilds/{guildId}/auto-moderation/rules/{ruleId}`
            end,
            rules = function(guildId: string): string
                return `/guilds/{guildId}/auto-moderation/rules`
            end
        },
        channels = function(guildId: string): string
            return `/guilds/{guildId}/channels`
        end,
        emoji = function(guildId: string, emojiId: string): string
            return `/guilds/{guildId}/emojis/{emojiId}`
        end,
        emojis = function(guildId: string): string
            return `/guilds/{guildId}/emojis`
        end,
        events = {
            events = function(guildId: string, withUserCount: boolean?): string
                local path = `/guilds/{guildId}/scheduled-events?`

                if withUserCount then
                    path ..= `with_user_count={withUserCount}`
                end

                return path
            end,
            event = function(guildId: string, eventId: string, withUserCount: boolean?): string
                local path = `/guilds/{guildId}/scheduled-events/{eventId}?`

                if withUserCount then
                    path ..= `with_user_count={withUserCount}`
                end

                return path
            end,
            users = function(guildId: string, eventId: string, options: { limit: number?, withMember: boolean?, before: string?, after: string? }?): string
                local path = `/guilds/{guildId}/scheduled-events/{eventId}/users?`

                if options then
                    if options.limit then
                        path ..= `limit={options.limit}`
                    end

                    if options.withMember then
                        path ..= `&with_member={options.withMember}`
                    end

                    if options.after then
                        path ..= `&after={options.after}`
                    end

                    if options.before then
                        path ..= `&before={options.before}`
                    end
                end

                return path
            end
        },
        guild = function(guildId: string, withCounts: boolean?): string
            local path = `/guilds/{guildId}?`

            if withCounts then
                path ..= `with_counts={withCounts}`
            end

            return path
        end,
        integration = function(guildId: string, integrationId: string)
            return `/guilds/{guildId}/integrations/{integrationId}`
        end,
        integrations = function(guildId: string): string
            return `/guilds/{guildId}/integrations?include_applications=true`
        end,
        invite = function(inviteCode: string, options: { withCounts: boolean?, withExpiration: boolean?, scheduledEventId: string? }?): string
            local path = `/invites/{inviteCode}?`

            if options then
                if options.withCounts then
                    path ..= `with_counts={options.withCounts}`
                end

                if options.withExpiration then
                    path ..= `&with_expiration={options.withExpiration}`
                end

                if options.scheduledEventId then
                    path ..= `&guild_scheduled_event_id={options.scheduledEventId}`
                end
            end

            return path
        end,
        invites = function(guildId: string): string
            return `/guilds/{guildId}/invites`
        end,
        leave = function(guildId: string): string
            return `/users/@me/guilds/{guildId}`
        end,
        members = {
            ban = function(guildId: string, userId: string): string
                return `/guilds/{guildId}/bans/{userId}`
            end,
            bans = function(guildId: string, options: { limit: number?, before: string?, after: string? }?): string
                local path = `/guilds/{guildId}/bans?`

                if options then
                    if options.limit then
                        path ..= `limit={options.limit}`
                    end

                    if options.after then
                        path ..= `&after={options.after}`
                    end

                    if options.before then
                        path ..= `&before={options.before}`
                    end
                end

                return path
            end,
            bulkBan = function(guildId: string): string
                return `/guilds/{guildId}/bulk-ban`
            end,
            bot = function(guildId: string): string
                return `/guilds/{guildId}/members/@me`
            end,
            member = function(guildId: string, userId: string): string
                return `/guilds/{guildId}/members/{userId}`
            end,
            currentMember = function(guildId: string): string
                return `/users/@me/guilds/{guildId}/member`
            end,
            members = function(guildId: string, options: { limit: number?, after: string? }?): string
                local path = `/guilds/{guildId}/members?`

                if options then
                    if options.limit then
                        path ..= `limit={options.limit}`
                    end

                    if options.after then
                        path ..= `&after={options.after}`
                    end
                end

                return path
            end,
            search = function(guildId: string, query: string, options: { limit: number? }?): string
                local path = `/guilds/{guildId}/members/search?query={net.urlEncode(query)}`

                if options then
                    if options.limit then
                        path ..= `&limit={options.limit}`
                    end
                end

                return path
            end,
            prune = function(guildId: string, options: { days: number?, includeRoles: (string | { string })? }?): string
                local path = `/guilds/{guildId}/prune?`

                if options then
                    if options.days then
                        path ..= `days={options.days}`
                    end

                    if options.includeRoles then
                        if typeof(options.includeRoles) == "table" then
                            path ..= `include_roles={table.concat(options.includeRoles, ",")}`
                        else
                            path ..= `include_roles={options.includeRoles}`
                        end
                    end
                end

                return path
            end
        },
        mfa = function(guildId: string): string
            return `/guilds/{guildId}/mfa`
        end,
        preview = function(guildId: string): string
            return `/guilds/{guildId}/preview`
        end,
        prune = function(guildId: string, options: { days: number?, includeRoles: (string | { string })? }?): string
            local path = `/guilds/{guildId}/prune?`

            if options then
                if options.days then
                    path ..= `days={options.days}`
                end

                if options.includeRoles then
                    if typeof(options.includeRoles) == "table" then
                        path ..= `include_roles={table.concat(options.includeRoles, ",")}`
                    else
                        path ..= `include_roles={options.includeRoles}`
                    end
                end
            end

            return path
        end,
        roles = {
            one = function(guildId: string, roleId: string): string
                return `/guilds/{guildId}/roles/{roleId}`
            end,
            all = function(guildId: string): string
                return `/guilds/{guildId}/roles`
            end,
            member = function(guildId: string, memberId: string, roleId: string): string
                return `/guilds/{guildId}/members/{memberId}/roles/{roleId}`
            end
        },
        stickers = function(guildId: string): string
            return `/guilds/{guildId}/stickers`
        end,
        sticker = function(guildId: string, stickerId: string): string
            return `/guilds/{guildId}/stickers/{stickerId}`
        end,
        voice = function(guildId: string, userId: string?): string
            return `/guilds/{guildId}/voice-states/{userId or "@me"}`
        end,
        templates = {
            code = function(code: string): string
                return `/guilds/templates/{code}`
            end,
            guild = function(guildId: string, code: string): string
                return `/guilds/{guildId}/templates/{code}`
            end,
            all = function(guildId: string): string
                return `/guilds/{guildId}/templates`
            end
        },
        vanity = function(guildId: string): string
            return `/guilds/{guildId}/vanity-url`
        end,
        regions = function(guildId: string): string
            return `/guilds/{guildId}/regions`
        end,
        webhooks = function(guildId: string): string
            return `/guilds/{guildId}/webhooks`
        end,
        welcome = function(guildId: string): string
            return `/guilds/{guildId}/welcome-screen`
        end,
        widget = function(guildId: string): string
            return `/guilds/{guildId}/widget`
        end,
        widgetJson = function(guildId: string): string
            return `/guilds/{guildId}/widget.json`
        end,
        onboarding = function(guildId: string): string
            return `/guilds/{guildId}/onboarding`
        end,
        incidentActions = function(guildId: string): string
            return `/guilds/{guildId}/incident-actions`
        end,
    },

    sticker = function(stickerId: string): string
        return `/stickers/{stickerId}`
    end,

    regions = function(): string
        return "/voice/regions"
    end,

    interactions = {
        commands = {
            commands = function(applicationId: string): string
                return `/applications/{applicationId}/commands`
            end,
            guilds = {
                all = function(applicationId: string, guildId: string): string
                    return `/applications/{applicationId}/guilds/{guildId}/commands`
                end,
                one = function(applicationId: string, guildId: string, commandId: string, withLocalizations: boolean?): string
                    local path = `/applications/{applicationId}/guilds/{guildId}/commands/{commandId}?`

                    if withLocalizations then
                        path ..= `with_localizations={withLocalizations}`
                    end

                    return path
                end
            },
            permissions = function(applicationId: string, guildId: string): string
                return `/applications/{applicationId}/guilds/{guildId}/commands/permissions`
            end,
            permission = function(applicationId: string, guildId: string, commandId: string): string
                return `/applications/{applicationId}/guilds/{guildId}/commands/{commandId}/permissions`
            end,
            command = function(applicationId: string, commandId: string, withLocalizations: boolean?)
                local path = `/applications/{applicationId}/commands/{commandId}?`

                if withLocalizations then
                    path ..= `with_localizations={withLocalizations}`
                end

                return path
            end
        },

        responses = {
            callback = function(interactionId: string, token: string, options: { withResponse: boolean? }?)
                return `/interactions/{interactionId}/{token}/callback?with_response={options and options.withResponse or false}`
            end,
            original = function(interactionId: string, token: string): string
                return `/webhooks/{interactionId}/{token}/@original`
            end,
            message = function(applicationId: string, token: string, messageId: string): string
                return `/webhooks/{applicationId}/{token}/messages/{messageId}`
            end
        }
    },

    oauth2 = {
        tokenExchange = function(): string
            return "/oauth2/token"
        end,
        tokenRevoke = function(): string
            return "/oauth2/token/revoke"
        end,
        currentAuthorization = function(): string
            return "/oauth2/@me"
        end,
        application = function(): string
            return "/oauth2/applications/@me"
        end,
        connections = function(): string
            return "/users/@me/connections"
        end,
        roleConnections = function(applicationId: string): string
            return `/users/@me/applications/{applicationId}/role-connection`
        end
    },

    monetization = {
        entitlements = function(applicationId: string, options: { userId: string?, skuIds: { string }?, before: string?, after: string?, limit: number?, guildId: string?, excludeEnded: boolean?, excludeDeleted: boolean? }?): string
            local path = `/applications/{applicationId}/entitlements?`

            if options then
                if options.after then
                    path ..= `after={options.after}`
                end

                if options.before then
                    path ..= `&before={options.before}`
                end

                if options.excludeEnded then
                    path ..= `&exclude_ended={options.excludeEnded}`
                end

                if options.guildId then
                    path ..= `&guild_id={options.guildId}`
                end

                if options.limit then
                    path ..= `&limit={options.limit}`
                end

                if options.skuIds then
                    path ..= `&sku_ids={table.concat(options.skuIds, ",")}`
                end

                if options.userId then
                    path ..= `&user_id={options.userId}`
                end
            end

            return path
        end,
        entitlement = function(applicationId: string, entitlementId: string): string
            return `/applications/{applicationId}/entitlements/{entitlementId}`
        end,
        consumeEntitlement = function(applicationId: string, entitlementId: string): string
            return `/applications/{applicationId}/entitlements/{entitlementId}/consume`
        end,
        skus = function(applicationId: string): string
            return `/applications/{applicationId}/skus`
        end,
        subscription = function(skuId: string, subscriptionId: string): string
            return `/skus/{skuId}/subscriptions/{subscriptionId}`
        end,
        subscriptions = function(skuId: string, options: { before: string?, after: string?, limit: number?, userId: string? }?): string
            local path = `/skus/{skuId}/subscriptions?`

            if options then
                if options.after then
                    path ..= `after={options.after}`
                end

                if options.before then
                    path ..= `&before={options.before}`
                end

                if options.userId then
                    path ..= `&user_id={options.userId}`
                end

                if options.limit then
                    path ..= `&limit={options.limit}`
                end
            end

            return path
        end
    },

    soundboard = {
        sendSound = function(channelId: string): string
            return `/channels/{channelId}`
        end,
        listDefault = function(): string
            return "/soundboard-default-sounds"
        end,
        guildSounds = function(guildId: string): string
            return `/guilds/{guildId}/soundboard-sounds`
        end,
        guildSound = function(guildId: string, soundId: string): string
            return `/guilds/{guildId}/soundboard-sounds/{soundId}`
        end
    },

    applicationEmoji = function(applicationId: string, emojiId: string): string
        return `/applications/{applicationId}/emojis/{emojiId}`
    end,

    applicationEmojis = function(applicationId: string): string
        return `/applications/{applicationId}/emojis`
    end,

    applicationRoleConnectionMetadata = function(applicationId: string): string
        return `/applications/{applicationId}/role-connections/metadata`
    end,

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