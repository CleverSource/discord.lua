local class = require("../vendor/ezobj")

local Base = class {
    constructor = function(self, id)
        self.id = tostring(id)
    end,
    createdAt = function(self)
        return self:getCreatedAt(self.id)
    end,
    getCreatedAt = function(self, id)
        return self:getDiscordEpoch(id) + 1420070400000
    end,
    getDiscordEpoch = function(_, id)
        return math.floor(tonumber(id) / 4194304)
    end
}

return Base