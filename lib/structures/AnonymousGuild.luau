local RestClient = require("../rest/RestClient")
local BaseGuild = require("BaseGuild")

local AnonymousGuild = {}
AnonymousGuild.__index = AnonymousGuild
setmetatable(AnonymousGuild, { __index = BaseGuild })

export type AnonymousGuild = typeof(setmetatable({} :: {
    splash: string?,
    banner: string?,
    description: string?,
    verificationLevel: number,
    vanityUrlCode: string?,
    nsfwLevel: number,
    premiumSubscriptionCount: number?,
}, {} :: typeof({ __index = AnonymousGuild }))) & BaseGuild.BaseGuild

function AnonymousGuild.new(client: RestClient.RestClient, data: any, instantUpdate: boolean?): AnonymousGuild
    local self: AnonymousGuild = setmetatable(BaseGuild.new(client, data) :: any, AnonymousGuild)

    if data and not (not instantUpdate) then
        self:update(data)
    end

    return self
end

function AnonymousGuild.update(self: AnonymousGuild, data: any)
    if data.features then
        self.features = data.features
    end
    
    if data.splash then
        self.splash = data.splash
    end

    if data.banner then
        self.banner = data.banner
    end

    if data.description then
        self.description = data.description
    end

    if data.verification_level then
        self.verificationLevel = data.verification_level
    end

    if data.vanity_url_code then
        self.vanityUrlCode = data.vanity_url_code
    end

    if data.nsfw_level then
        self.nsfwLevel = data.nsfw_level
    end

    if data.premium_subscription_count then
        self.premiumSubscriptionCount = data.premium_subscription_count
    end

    -- TODO: banner & splash url
end

return AnonymousGuild