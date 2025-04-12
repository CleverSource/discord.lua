local RestClient = require("../rest/RestClient")
local Channel = require("Channel")

local ApiTypes = require("../types/apiTypes")
local RestTypes = require("../types/internal/rest")

local GuildChannel = {}
GuildChannel.__index = GuildChannel
setmetatable(GuildChannel, { __index = Channel })

export type GuildChannel = typeof(setmetatable({} :: {
    guildId: string,
    permissions: string,
    name: string,
    parentId: string?,
    flags: number?
}, {} :: typeof({ __index = GuildChannel }))) & Channel.Channel

function GuildChannel.new(client: RestClient.RestClient, data: any): GuildChannel
    local self: GuildChannel = setmetatable(Channel.new(client, data) :: any, GuildChannel)

    self.guildId = data.guild_id
    self.permissions = data.permissions -- TODO: structure

    self:update(data)

    return self
end

function GuildChannel.update(self: GuildChannel, data: any)
    self.type = data.type
    self.name = data.name
    self.parentId = data.parent_id
    self.flags = data.flags
end

function GuildChannel.delete(self: GuildChannel, reason: string?)
    self._client:deleteChannel(self.id, reason)
end

function GuildChannel.deletePermission(self: GuildChannel, overwriteId: string, reason: string?)
    self._client:deleteChannelPermissionOverride(self.id, overwriteId, reason)
end

function GuildChannel.edit(self: GuildChannel, options: RestTypes.ModifyChannelRequest, reason: string?): RestTypes.ModifyChannelResponse
    return self._client:editChannel(self.id, options, reason)
end

function GuildChannel.editPermission(self: GuildChannel, options: ApiTypes.OverwriteObject, reason: string?)
    self._client:editChannelPermissionOverride(self.id, options)
end

function GuildChannel.editPosition(self: GuildChannel, position: number, options: { lockPermissions: boolean?, parentId: string? }?)
    print("TODO") -- TODO
end

return GuildChannel