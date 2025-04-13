local Client = require("../lib/Client")
local config = require("../config")

-- Create bot client
local bot = Client.new({
    token = config.token,
    debug = true, -- Enable verbose output from the library
    intents = {
        -- Intents can be specified as a list of strings or numbers
        "AllNonPrivileged",
        -- Constants are provided for all intents
        -- If testing, ensure you have the correct intents enabled in the developer portal
        Client.Constants.Intents.MessageContent
    },
    compression = false
})

-- Events are functional in nature with proper types
bot.events.ready = function()
    print("Bot is ready!")
end

bot.events.messageCreate = function(message)
    if message.content == "!ping" then
        -- Directly interact with the rest client
        -- or choose to use the `message` object to send a message
        -- e.g. message:reply("Pong!")
        bot.rest:sendMessage(message.channelId, {
            content = "Pong!",
            messageReference = {
                messageId = message.id
            }
        })
    end
end

-- Typing is lost here, so you can use `typeof` to get the type of the event
bot:on("channelCreate", function(channel)
    -- This is a channel object, so you can use the methods available on it
    -- TODO: add this back when the channel object is fixed
end :: typeof(bot.events.channelCreate))

bot:connect()