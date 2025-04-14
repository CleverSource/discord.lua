local RestClient = require("../rest/RestClient")
local Base = require("Base")

local Constants = require("../Constants")
local snowflakeCreatedAt = require("../util/snowflakeCreatedAt")

local Message = {}
Message.__index = Message
setmetatable(Message, { __index = Base })

export type Message = typeof(setmetatable({} :: {
    id: string,
    channelId: string,
    guildId: string,
    createdTimestamp: number,
    type: number?,
    system: boolean?,
    content: string?,
    pinned: boolean?,
    tts: boolean?,
    nonce: string?,
    position: number?
}, {} :: typeof({ __index = Message }))) & Base.Base

function Message.new(client: RestClient.RestClient, data: any): Message
    local self: Message = setmetatable(Base.new(client) :: any, Message)

    ;(self :: any).channel = data.channel
    
    self.channelId = data.channel_id
    self.guildId = data.guild_id or data.channel.guild.id

    self:update(data)

    return self
end

function Message.update(self: Message, data: any)
    self.id = data.id
    self.createdTimestamp = snowflakeCreatedAt(self.id)

    if data.type then
        self.type = data.type
        self.system = not (data.type == Constants.MessageType.Default
                            or data.type == Constants.MessageType.Reply
                            or data.type == Constants.MessageType.ChatInputCommand
                            or data.type == Constants.MessageType.ContextMenuCommand)
    end

    if data.content then
        self.content = data.content
    end

    -- TODO: author

    if data.pinned then
        self.pinned = data.pinned
    end

    if data.tts then
        self.tts = data.tts
    end

    if data.nonce then
        self.nonce = data.nonce
    end

    -- TODO: embeds
    -- TODO: components
    -- TODO: attachments
    -- TODO: sticker items

    if data.position then
        self.position = data.position
    end
end

return Message