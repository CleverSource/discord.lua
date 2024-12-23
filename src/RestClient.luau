-- Utils
local getBotIdFromToken = require("utils/getBotIdFromToken")

-- Promise
local PromiseType = require("@vendor/Promise/types/Promise")
type Promise = PromiseType.AnyPromise

-- Request
local Request = require("Request")
type Request = Request.Request
type RequestOptions = Request.RequestOptions

-- Types
local Discord = require("types/Discord")
type DiscordGetGatewayBot = Discord.DiscordGetGatewayBot

-- RestClient
local RestClient = {}

export type RestClient = {
    token: string,
    applicationId: string,
    Request: Request,

    new: (options: RestClientOptions) -> RestClient,
    handleResponseValue: (self: RestClient, promise: Promise) -> any,

    getGatewayBot: (self: RestClient) -> DiscordGetGatewayBot,
} & typeof(RestClient)

export type RestClientOptions = {
    token: string,
    applicationId: string?,
    restOptions: RequestOptions?,
}

function RestClient.new(options: RestClientOptions): RestClient
    local self = setmetatable({} :: RestClient, {
        __index = RestClient
    })
    
    self.token = `Bot {options.token}`
    self.applicationId = options.applicationId or getBotIdFromToken(options.token)
    self.Request = Request.new(self.token, options.restOptions)

    return self
end

function RestClient.handleResponseValue(self: RestClient, promise: Promise): any
    local success, result = promise:await()
    if success then
        return result
    end
    return nil
end

function RestClient.getGatewayBot(self: RestClient): DiscordGetGatewayBot
    local promise = self.Request:request("GET", "/gateway/bot", true)
    return self:handleResponseValue(promise)
end

return RestClient