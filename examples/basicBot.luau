local config = require("../config")
local Client = require("../lib/Client")

local bot = Client.new({
    token = config.token,
    debug = true,
    intents = {
        "AllNonPrivileged"
    },
    compression = false
})

bot:connect()