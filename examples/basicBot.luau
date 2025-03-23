local config = require("../config")
local Client = require("../lib/Client")

local bot = Client.new({
    token = config.token,
    debug = true,
    intents = {
        "allNonPrivileged"
    }
})

bot:connect()