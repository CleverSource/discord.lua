local RestClient = require("../rest/RestClient")
local Channel = require("Channel")

local GuildChannel = {}
GuildChannel.__index = GuildChannel
setmetatable(GuildChannel, { __index = Channel })

export type GuildChannel = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
}, {} :: typeof({ __index = GuildChannel }))) & Channel.Channel

function GuildChannel.new(client: RestClient.RestClient, data: any): GuildChannel
    local self: GuildChannel = setmetatable(Channel.new(client, data) :: any, GuildChannel)

    self.client = client

    self:update(data)

    return self
end

function GuildChannel.update(self: GuildChannel, data: any)
    
end

return GuildChannel