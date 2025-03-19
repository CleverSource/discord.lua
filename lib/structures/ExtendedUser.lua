local User = require("User")

local ExtendedUser = User:extend {
    constructor = function(self, data)
        self.super("constructor", data)
    end,
    update = function(self, data)
        self.super("update", data)
        self.email = data.email
        self.verified = data.verified
        self.mfaEnabled = data.mfa_enabled
        self.premiumType = data.premium_type
    end
}

return ExtendedUser