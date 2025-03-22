local User = require("User")

local ExtendedUser = User:extend {
    constructor = function(self, data)
        self.super("constructor", data)
    end,
    update = function(self, data)
        self.super("update", data)
        self.email = data.email
        self.verified = data.verified
        self.mfaEnabled = data.mfaEnabled or data.mfa_enabled
        self.premiumType = data.premiumType or data.premium_type
    end
}

return ExtendedUser