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

bot.events.channelCreate = function(data)
    bot.rest:sendMessage(data.id, {
        content = `Wow! {data.name} was created!`
    })
end

bot:connect()