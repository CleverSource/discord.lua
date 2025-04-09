local class = require("../vendor/ezobj")
local Base = require("Base")
local RestClient = require("../rest/RestClient")

local ApiTypes = require("../types/apiTypes")
local RestTypes = require("../types/internal/rest")

export type StageInstanceInterface = class.Object<ApiTypes.StageInstanceObject & {
    _patch: (self: StageInstanceInterface, data: ApiTypes.StageInstanceObject) -> (),
    setTopic: (self: StageInstanceInterface, topic: string, reason: string?) -> RestTypes.ModifyStageInstanceResponse,
    delete: (self: StageInstanceInterface, reason: string?) -> (),
}> & class.InheritedObject<Base.BaseInterface, {}>
local StageInstance = Base:extend({
    constructor = function(self: StageInstanceInterface, client: RestClient.RestClient, data: ApiTypes.StageInstanceObject)
        self.super("constructor", client)

        self.id = data.id
        self:_patch(data)
    end,
    _patch = function(self: StageInstanceInterface, data: ApiTypes.StageInstanceObject)
        self.guildId = data.guildId
        self.channelId = data.channelId
        self.topic = data.topic
        self.privacyLevel = data.privacyLevel
        self.guildScheduledEventId = data.guildScheduledEventId
    end,
    setTopic = function(self: StageInstanceInterface, topic: string, reason: string?): RestTypes.ModifyStageInstanceResponse
        return self.client:editStageInstance(self.channelId, topic, reason)
    end,
    delete = function(self: StageInstanceInterface, reason: string?)
        self.client:deleteStageInstance(self.channelId, reason)
    end,
} :: StageInstanceClass & StageInstanceInterface)
type StageInstanceClass = typeof(StageInstance.type())

return StageInstance