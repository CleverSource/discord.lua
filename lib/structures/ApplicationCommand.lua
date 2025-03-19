local Base = require("Base")

local ApplicationCommand = Base:extend {
    constructor = function(self, data)
        self.super("constructor", data.id)
        self.applicationId = data.application_id
        self.name = data.name
        self.description = data.description
        self.type = data.type
        self.version = data.version
        self.guildId = data.guild_id
        self.nameLocalizations = data.name_localizations
        self.descriptionLocalizations = data.description_localizations
        self.options = data.options
        self.defaultMemberPermissions = data.default_member_permissions
        self.dmPermission = data.dm_permission
        self.nsfw = data.nsfw
        self.handler = data.handler
        self.integrationTypes = data.integration_types
        self.contexts = data.contexts
    end
}

return ApplicationCommand