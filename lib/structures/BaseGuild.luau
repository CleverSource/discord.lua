local datetime = require("@lune/datetime")

local RestClient = require("../rest/RestClient")
local Base = require("Base")

local Constants = require("../Constants")
local snowflakeCreatedAt = require("../util/snowflakeCreatedAt")

local BaseGuild = {}
BaseGuild.__index = BaseGuild
setmetatable(BaseGuild, { __index = Base })

export type BaseGuild = typeof(setmetatable({} :: {
    id: string,
    name: string,
    icon: string?,
    features: { string },
    createdTimestamp: number,
    createdAt: datetime.DateTime,
}, {} :: typeof({ __index = BaseGuild }))) & Base.Base

function BaseGuild.new(client: RestClient.RestClient, data: any): BaseGuild
    local self: BaseGuild = setmetatable(Base.new(client) :: any, BaseGuild)

    self.id = data.id
    self.name = data.name
    self.icon = data.icon
    self.features = data.features

    self.createdTimestamp = snowflakeCreatedAt(self.id)
    self.createdAt = datetime.fromUnixTimestamp(self.createdTimestamp / 1000)
    
    -- TODO: icon url

    return self
end

function BaseGuild.getNameAcronym(self: BaseGuild): string
    return self.name and self.name:gsub("'s ", " "):gsub("%w+", function(word: string) 
        return word:sub(1, 1)
    end):gsub("%s+", "")
end

function BaseGuild.isPartnered(self: BaseGuild): boolean
    return self.features and table.find(self.features, Constants.GuildFeature.Partnered) ~= nil
end

function BaseGuild.isVerified(self: BaseGuild): boolean
    return self.features and table.find(self.features, Constants.GuildFeature.Verified) ~= nil
end

return BaseGuild