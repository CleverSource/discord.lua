local RestClient = require("../rest/RestClient")
local Base = require("Base")

local Channel = {}
Channel.__index = Channel
setmetatable(Channel, { __index = Base })

export type Channel = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
    type: number,
    mention: string
}, {} :: typeof({ __index = Channel }))) & Base.Base

function Channel.new(client: RestClient.RestClient, data: any): Channel
    local self: Channel = setmetatable(Base.new(data.id) :: any, Channel)

    self.client = client
    self.type = data.type
    self.mention = `<#{self.id}>`

    return self
end

function Channel.isTextBased(self: Channel): boolean
    return (self :: any).messages ~= nil
end

return Channel