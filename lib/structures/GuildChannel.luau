local RestClient = require("../rest/RestClient")
local BaseChannel = require("BaseChannel")

local GuildChannel = {}
GuildChannel.__index = GuildChannel
setmetatable(GuildChannel, { __index = BaseChannel })

export type GuildChannel = typeof(setmetatable({} :: {
    guildId: string,
    name: string,
}, {} :: typeof({ __index = GuildChannel }))) & BaseChannel.BaseChannel

function GuildChannel.new(client: RestClient.RestClient, data: any): GuildChannel
    local self: GuildChannel = setmetatable(BaseChannel.new(client, data, false) :: any, GuildChannel)

    self.guildId = data.guild_id

    self:update(data)

    return self
end

function GuildChannel.update(self: GuildChannel, data: any)
    BaseChannel.update(self, data)

    self.name = data.name
end

return GuildChannel