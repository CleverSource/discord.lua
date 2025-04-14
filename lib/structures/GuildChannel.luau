local RestClient = require("../rest/RestClient")
local BaseChannel = require("BaseChannel")

local ApiTypes = require("../types/apiTypes")

local GuildChannelMixin = require("mixin/GuildChannelMixin")

local GuildChannel = {}
GuildChannel.__index = GuildChannel
setmetatable(GuildChannel, { __index = BaseChannel })

export type GuildChannel = typeof(setmetatable({} :: {
    guildId: string,
    name: string,
    rawPosition: number,
    parentId: string?,
    permissionOverwrites: { ApiTypes.OverwriteObject }
}, {} :: typeof({ __index = GuildChannel }))) & BaseChannel.BaseChannel & GuildChannelMixin.Methods

function GuildChannel.new(client: RestClient.RestClient, data: any, instantUpdate: boolean?): GuildChannel
    local self: GuildChannel = setmetatable(BaseChannel.new(client, data, false) :: any, GuildChannel)

    ;(self :: any).guild = data.guild
    
    self.guildId = data.guild_id
    
    if data and not (not instantUpdate) then
        self:update(data)
    end

    return self
end

function GuildChannel.update(self: GuildChannel, data: any)
    BaseChannel.update(self, data)

    if data.name then
        self.name = data.name
    end

    if data.position then
        self.rawPosition = data.position
    end

    if data.guild_id then
        self.guildId = data.guild_id
    end

    if data.parent_id then
        self.parentId = data.parent_id
    end

    if data.permission_overwrites then
        self.permissionOverwrites = data.permission_overwrites -- TODO
    end
end

GuildChannelMixin.mix(GuildChannel)

return GuildChannel