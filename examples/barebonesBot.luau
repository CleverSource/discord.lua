local Client = require("../lib/Client")
local config = require("../config")

local bot = Client.new({
    token = config.token,
    intents = {
        Client.Constants.Intents.AllNonPrivileged,
        Client.Constants.Intents.MessageContent
    }
})

bot:on("ready", function(data)
    print(`{data.user.username} has connected!`)
end :: typeof(bot.events.ready))

bot.events.messageCreate = function(message)
    print(message.content)
    if message.content == "!!ping" then
        local test = message:reply("Test!")
        -- test:reply("A reply to my own message??")
    end
end

bot:connect()