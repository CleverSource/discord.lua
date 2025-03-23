local Routes = require("Routes")
local Logger = require("../log/Logger")
type Logger = Logger.Logger
local RequestHandler = require("RequestHandler")
type RequestHandler = RequestHandler.RequestHandler

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

function RestClient:getGateway()
    return self.request:get(Routes.gateway())
end

function RestClient:getBotGateway()
    return self.request:get(Routes.gatewayBot(), {
        authenticated = true
    })
end

return RestClient