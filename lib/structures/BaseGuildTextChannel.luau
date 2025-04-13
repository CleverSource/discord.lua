local RestClient = require("../rest/RestClient")
local GuildChannel = require("GuildChannel")

local MessageCache = require("../cache/MessageCache")

local BaseGuildTextChannel = {}
BaseGuildTextChannel.__index = BaseGuildTextChannel
setmetatable(BaseGuildTextChannel, { __index = GuildChannel })

export type BaseGuildTextChannel = typeof(setmetatable({} :: {
    messages: MessageCache.MessageCache,

    topic: string?,
    nsfw: boolean,
    lastMessageId: string?,
}, {} :: typeof({ __index = BaseGuildTextChannel }))) & GuildChannel.GuildChannel

function BaseGuildTextChannel.new(client: RestClient.RestClient, data: any): BaseGuildTextChannel
    local self: BaseGuildTextChannel = setmetatable(GuildChannel.new(client, data, false) :: any, BaseGuildTextChannel)

    self.messages = MessageCache.new(client, 100)

    self.nsfw = data.nsfw

    self:update(data)

    return self
end

function BaseGuildTextChannel.update(self: BaseGuildTextChannel, data: any)
    GuildChannel.update(self, data)

    self.topic = data.topic
    self.lastMessageId = data.last_message_id

    if data.messages then
        for _, message in data.messages do
            self.messages:add(message)
        end
    end
end

return BaseGuildTextChannel