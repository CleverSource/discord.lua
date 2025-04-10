local Client = require("../lib/Client")
local config = require("../config")

local bot = Client.new({
    token = config.token
})

bot:on("ready", function(data)
    print(`{data.user.username} has connected!`)
end :: typeof(bot.events.ready))

bot:connect()