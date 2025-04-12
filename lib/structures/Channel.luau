local RestClient = require("../rest/RestClient")
local Base = require("Base")

local Channel = {}
Channel.__index = Channel
setmetatable(Channel, { __index = Base })

export type Channel = typeof(setmetatable({} :: {
    type: number,
    mention: string
}, {} :: typeof({ __index = Channel }))) & Base.Base

function Channel.new(client: RestClient.RestClient, data: any): Channel
    local self: Channel = setmetatable(Base.new(client, data.id) :: any, Channel)

    self.type = data.type
    self.mention = `<#{self.id}>`

    return self
end

return Channel