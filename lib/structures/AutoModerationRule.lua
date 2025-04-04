local Base = require("Base")

local AutoModerationRule = Base:extend {
    constructor = function(self, data)
        self.super("constructor", data.id)
        self.actions = {}
        for _, action in ipairs(data.actions) do
            table.insert(self.actions, {
                type = action.type,
                metadata = action.metadata
            })
        end
        self.creatorId = data.creatorId or data.creator_id
        self.enabled = data.enabled
        self.eventType = data.eventType or data.event_type
        self.exemptRoles = data.exemptRoles or data.exempt_roles
        self.exemptChannels = data.exemptChannels or data.exempt_channels
        self.guildId = data.guildId or data.guild_id
        self.name = data.name
        self.triggerMetadata = data.triggerMetadata or data.trigger_metadata
        self.triggerType = data.triggerType or data.trigger_type
    end,
}

return AutoModerationRule