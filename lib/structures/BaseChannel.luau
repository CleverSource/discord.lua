local datetime = require("@lune/datetime")

local RestClient = require("../rest/RestClient")
local Base = require("Base")

local Constants = require("../Constants")
local snowflakeCreatedAt = require("../util/snowflakeCreatedAt")

local BaseChannel = {}
BaseChannel.__index = BaseChannel
setmetatable(BaseChannel, { __index = Base })

export type BaseChannel = typeof(setmetatable({} :: {
    id: string,
    type: number,
    flags: number?,
    createdTimestamp: number,
    createdAt: datetime.DateTime,
}, {} :: typeof({ __index = BaseChannel }))) & Base.Base

function BaseChannel.new(client: RestClient.RestClient, data: any, instantUpdate: boolean?): BaseChannel
    local self: BaseChannel = setmetatable(Base.new(client) :: any, BaseChannel)

    self.type = data.type

    if data and not (not instantUpdate) then
        self:update(data)
    end
    
    return self
end

function BaseChannel.update(self: BaseChannel, data: any)
    self.flags = data.flags
    self.id = data.id
    self.createdTimestamp = snowflakeCreatedAt(self.id)
    self.createdAt = datetime.fromUnixTimestamp(self.createdTimestamp / 1000)

    -- TODO: url
end

function BaseChannel.delete(self: BaseChannel, reason: string?)
    self._client:deleteChannel(self.id, reason)
end

function BaseChannel.isThread(self: BaseChannel): boolean
    return self.type == Constants.ChannelTypes.AnnouncementThread
            or self.type == Constants.ChannelTypes.PublicThread
            or self.type == Constants.ChannelTypes.PrivateThread
end

function BaseChannel.isTextBased(self: BaseChannel): boolean
    return (self :: any).messages ~= nil
end

function BaseChannel.isDMBased(self: BaseChannel): boolean
    return self.type == Constants.ChannelTypes.DM
            or self.type == Constants.ChannelTypes.GroupDM
end

function BaseChannel.isVoiceBased(self: BaseChannel): boolean
    return (self :: any).bitrate ~= nil
end

function BaseChannel.isThreadOnly(self: BaseChannel): boolean
    return (self :: any).availableTags ~= nil
end

function BaseChannel.isSendable(self: BaseChannel): boolean
    return (self :: any).send ~= nil
end

return BaseChannel