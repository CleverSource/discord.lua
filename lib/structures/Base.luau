local class = require("../vendor/ezobj")
local RestClient = require("../rest/RestClient")

export type BaseInterface = class.Object<{
    client: RestClient.RestClient
}>
local Base = class({
    constructor = function(self: BaseInterface, client: RestClient.RestClient)
        self.client = client
    end
} :: BaseClass & BaseInterface)
type BaseClass = typeof(Base.type())

return Base :: BaseClass