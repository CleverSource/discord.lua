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

-- bot.rest:sendMessage("924175444851458068", {
--     content = "Hello!",
--     components = {
--         {
--             type = 1,
--             components = {
--                 {
--                     type = 2,
--                     label = "Test",
--                     style = 1,
--                     custom_id = "click_me"
--                 }
--             }
--         }
--     },
--     files = {
--         {
--             name = "test.png",
--             content = require("@lune/fs").readFile("examples/test.png")
--         }
--     }
-- })

bot:connect()