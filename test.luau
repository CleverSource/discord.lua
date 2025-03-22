local task = require("@lune/task")

local Client = require("lib/Client")

local bot = Client.new({
    token = "MTMwMzc3NDg0MzY5MDI4NzIzMA.GP6rsx.iX5cqXRgHswQiFi5qMw55jDCL0Ct_rNVtaGoFY",
    debug = true
})

bot:connect()