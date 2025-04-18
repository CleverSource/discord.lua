local datetime = require("@lune/datetime")

local snowflakeCreatedAt = require("../util/snowflakeCreatedAt")

local Base = {}
Base.__index = Base

export type Base = typeof(setmetatable({} :: {
    id: string?,
    createdTimestamp: number,
    createdAt: datetime.DateTime,
}, {} :: typeof({ __index = Base })))

function Base.new(id: string?): Base
    local self: Base = setmetatable({} :: any, Base)

    if id then
        self.id = id
        self.createdTimestamp = snowflakeCreatedAt(self.id :: string)
        self.createdAt = datetime.fromUnixTimestamp(self.createdTimestamp / 1000)
    end

    return self
end

return Base