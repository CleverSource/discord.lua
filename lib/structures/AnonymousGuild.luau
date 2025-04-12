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
    self.features = data.features
    self.splash = data.splash
    self.banner = data.banner
    self.description = data.description
    self.verificationLevel = data.verification_level
    self.vanityUrlCode = data.vanity_url_code
    self.nsfwLevel = data.nsfw_level
    self.premiumSubscriptionCount = data.premium_subscription_count

    -- TODO: banner & splash url
end

return AnonymousGuild