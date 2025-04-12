local datetime = require("@lune/datetime")

local snowflakeCreatedAt = require("../util/snowflakeCreatedAt")

local RestClient = require("../rest/RestClient")
local ApiTypes = require("../types/ApiTypes")

local Base = {}
Base.__index = Base

export type Base = typeof(setmetatable({} :: {
    _client: RestClient.RestClient,

    id: ApiTypes.Snowflake,
    createdTimestamp: number,
    createdAt: datetime.DateTime
}, {} :: typeof({ __index = Base })))

function Base.new(client: RestClient.RestClient, id: string?): Base
    local self: Base = setmetatable({} :: any, Base)

    self._client = client
    if id then
        self.id = id
    end

    self.createdTimestamp = self.id and snowflakeCreatedAt(self.id)
    self.createdAt = self.createdTimestamp and datetime.fromUnixTimestamp(self.createdTimestamp / 1000)

    return self
end

return Base