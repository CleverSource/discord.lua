local RestClient = require("../rest/RestClient")
local GuildChannel = require("GuildChannel")

local MessageCache = require("../cache/MessageCache")

local TextChannel = {}
TextChannel.__index = TextChannel
setmetatable(TextChannel, { __index = GuildChannel })

export type TextChannel = typeof(setmetatable({} :: {
    messages: MessageCache.MessageCache,

    client: RestClient.RestClient,
}, {} :: typeof({ __index = TextChannel }))) & GuildChannel.GuildChannel

function TextChannel.new(client: RestClient.RestClient, data: any): TextChannel
    local self: TextChannel = setmetatable(GuildChannel.new(client, data) :: any, TextChannel)

    self.messages = MessageCache.new(client, 100)

    self.client = client

    self:update(data)

    return self
end

function TextChannel.update(self: TextChannel, data: any)
    GuildChannel.update(self, data)
end

return TextChannel