local RestClient = require("../rest/RestClient")
local BaseChannel = require("BaseChannel")

local RestTypes = require("../types/internal/rest")
local ApiTypes = require("../types/apiTypes")

local GuildChannel = {}
GuildChannel.__index = GuildChannel
setmetatable(GuildChannel, { __index = BaseChannel })

export type GuildChannel = typeof(setmetatable({} :: {
    guildId: string,
    name: string,
    rawPosition: number,
    parentId: string?,
    permissionOverwrites: { ApiTypes.OverwriteObject }
}, {} :: typeof({ __index = GuildChannel }))) & BaseChannel.BaseChannel

function GuildChannel.new(client: RestClient.RestClient, data: any, instantUpdate: boolean?): GuildChannel
    local self: GuildChannel = setmetatable(BaseChannel.new(client, data, false) :: any, GuildChannel)

    self.guildId = data.guild_id
    
    if data and not (not instantUpdate) then
        self:update(data)
    end

    return self
end

function GuildChannel.update(self: GuildChannel, data: any)
    BaseChannel.update(self, data)

    self.name = data.name
    self.rawPosition = data.position
    self.guildId = data.guild_id
    self.parentId = data.parent_id
    self.permissionOverwrites = data.permission_overwrites -- TODO
end

function GuildChannel.edit(self: GuildChannel, options: RestTypes.ModifyChannelRequest, reason: string?): GuildChannel
    local data = self._client:editChannel(self.id, options, reason)
    if data then
        self:update(data)
    end
    return self
end

function GuildChannel.setName(self: GuildChannel, name: string, reason: string?): GuildChannel
    return self:edit({ 
        name = name
    }, reason)
end

function GuildChannel.setParent(self: GuildChannel, parentId: string, options: {
    lockPermissions: boolean?,
    reason: string?
}?): GuildChannel
    return self:edit({
        parentId = parentId,
        lockPermissions = options and options.lockPermissions,
        reason = options and options.reason
    })
end

return GuildChannel