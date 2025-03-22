local Base = require("Base")

local ApplicationCommand = Base:extend {
    constructor = function(self, data)
        self.super("constructor", data.id)
        self.applicationId = data.applicationId or data.application_id
        self.name = data.name
        self.description = data.description
        self.type = data.type
        self.version = data.version
        self.guildId = data.guildId or data.guild_id
        self.nameLocalizations = data.nameLocalizations or data.name_localizations
        self.descriptionLocalizations = data.descriptionLocalizations or data.description_localizations
        self.options = data.options
        self.defaultMemberPermissions = data.defaultMemberPermissions or data.default_member_permissions
        self.dmPermission = data.dmPermission or data.dm_permission
        self.nsfw = data.nsfw
        self.handler = data.handler
        self.integrationTypes = data.integrationTypes or data.integration_types
        self.contexts = data.contexts
    end
}

return ApplicationCommand