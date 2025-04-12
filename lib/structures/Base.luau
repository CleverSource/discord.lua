local RestClient = require("../rest/RestClient")

local Base = {}
Base.__index = Base

export type Base = typeof(setmetatable({} :: {
    _client: RestClient.RestClient,
}, {} :: typeof({ __index = Base })))

function Base.new(client: RestClient.RestClient, id: string?): Base
    local self: Base = setmetatable({} :: any, Base)

    self._client = client

    return self
end

return Base