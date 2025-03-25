local getDiscordEpoch = require("getDiscordEpoch")

local DISCORD_EPOCH = 1420070400000

return function(snowflake: string): number
    return getDiscordEpoch(snowflake) + DISCORD_EPOCH
end