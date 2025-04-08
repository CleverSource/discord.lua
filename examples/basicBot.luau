local Client = require("../lib/Client")
local config = require("../config")

local bot = Client.new({
    token = config.token,
    debug = true,
    intents = {
        "AllNonPrivileged"
    },
    compression = false
})

bot.events.ready = function(data)
    print("Bot is ready!")
end

bot:on("channelCreate", function(channel) 
    print(channel.name .. " was created!")
end :: typeof(bot.events.channelCreate))

bot:connect()