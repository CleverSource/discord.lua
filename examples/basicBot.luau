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
        Client.Constants.Intents.MessageContent
    },
    compression = false
})

-- Events are functional in nature with proper types
bot.events.ready = function(data)
    print("Bot is ready!")
end

-- Typing is lost here, so you can use `typeof` to get the type of the event
bot:on("channelCreate", function(channel)
    bot.rest:sendMessage(channel.id, {
        content = `This channel named \`{channel.name}\` is cool!`
    })
end :: typeof(bot.events.channelCreate))

-- Application commands
local commands = {
    {
        name = "ping",
        description = "Ping the bot",
        type = Client.Constants.ApplicationCommandTypes.ChatInput,
        options = {}
    }
}

local currentCommands = bot.rest:getGlobalApplicationCommands()
for i, command in commands do
    if command.name ~= currentCommands[i].name then
        bot.rest:upsertGlobalApplicationCommands(commands)
        break
    end
end

bot.events.interactionCreate = function(interaction)
    if interaction.type == Client.Constants.InteractionType.ApplicationCommand then
        if interaction.data.name == "ping" then
            bot.rest:sendInteractionResponse(interaction.id, interaction.token, {
                type = Client.Constants.InteractionResponseTypes.ChannelMessageWithSource,
                data = {
                    content = "Pong!"
                }
            })
        end
    end
end

bot:connect()