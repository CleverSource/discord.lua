local RestClient = require("../rest/RestClient")
local Base = require("Base")

local Message = {}
Message.__index = Message
setmetatable(Message, { __index = Base })

export type Message = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
}, {} :: typeof({ __index = Message }))) & Base.Base

function Message.new(client: RestClient.RestClient, data: any): Message
    local self: Message = setmetatable(Base.new(data.id) :: any, Message)

    self.client = client

    self:update(data)

    return self
end

function Message.update(self: Message, data: any)
    
end

return Message