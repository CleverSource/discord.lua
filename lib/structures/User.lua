local Base = require("Base")

local User = Base:extend {
    constructor = function(self, data)
        self.super("constructor", data.id)
        self.bot = not (not data.bot)
        self.system = not (not data.system)
        self:update(data)
    end,
    update = function(self, data)
        self.avatar = data.avatar
        self.avatarDecorationData = data.avatarDecorationData or data.avatar_decoration_data
        self.username = data.username
        self.discriminator = data.discriminator
        self.publicFlags = data.publicFlags or data.public_flags
        self.banner = data.banner
        self.accentColor = data.accentColor or data.accent_color
        self.globalName = data.globalName or data.global_name
    end,
    defaultAvatar = function(self)
        if self.discriminator == "0" then
            return self:getDiscordEpoch(self.id) % 6
        end
        return self.discriminator % 5
    end,
    mention = function(self)
        return "<@" .. self.id .. ">"
    end
}

return User