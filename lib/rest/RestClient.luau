local Routes = require("Routes")
local Logger = require("../log/Logger")
type Logger = Logger.Logger
local RequestHandler = require("RequestHandler")
type RequestHandler = RequestHandler.RequestHandler

local ExtendedUser = require("../structures/ExtendedUser") -- TEMP

local RestClient = {}
RestClient.__index = RestClient

export type RestClientOptions = {
    token: string?,
    logger: Logger?,
    preferSnakeCase: boolean?
}

export type RestClient = typeof(setmetatable({} :: {
    logger: Logger,
    request: RequestHandler
}, RestClient))

function RestClient.new(options: RestClientOptions): RestClient
    local self = setmetatable({}, RestClient) :: RestClient

    self.logger = options.logger or Logger.new()
    
    local restOptions = {
        token = options.token,
        preferSnakeCase = options.preferSnakeCase,
        logger = self.logger
    }

    self.request = RequestHandler.new(restOptions)

    return self
end

-- TEMP
function RestClient:getGateway()
    return self.request:get(Routes.gateway())
end

function RestClient:getBotGateway()
    return self.request:get(Routes.gatewayBot(), {
        authenticated = true
    })
end

function RestClient:getSelf()
    return ExtendedUser.new(self.request:get(Routes.user("@me"), {
        authenticated = true
    }))
end

function RestClient:editSelf(options)
    return ExtendedUser.new(self.request:patch(Routes.user("@me"), {
        authenticated = true,
        body = options
    }))
end

return RestClient