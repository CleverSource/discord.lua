local RestClient = require("../rest/RestClient")
local Message = require("../structures/Message")

local MessageCache = {}
MessageCache.__index = MessageCache

export type MessageCache = typeof(setmetatable({} :: {
    client: RestClient.RestClient,
    cache: { [string]: Message.Message },
    limit: number,
    queue: { string }
}, MessageCache))

function MessageCache.new(client: RestClient.RestClient, limit: number?): MessageCache
    local self = setmetatable({}, MessageCache) :: MessageCache

    self.client = client
    self.cache = {}

    self.limit = limit or 100
    self.queue = {}

    return self
end

function MessageCache.get(self: MessageCache, id: string): Message.Message?
    return self.cache[id]
end

function MessageCache.add(self: MessageCache, data: any)
    local message = self:get(data.id)
    if message then
        message:update(data)
    else
        if #self.queue >= self.limit then
            local oldestId = table.remove(self.queue, 1)
            self.cache[oldestId] = nil
        end

        message = Message.new(self.client, data)
        self.cache[data.id] = message
        table.insert(self.queue, data.id)
    end
    return message
end

function MessageCache.remove(self: MessageCache, id: string)
    local old = self.cache[id]
    self.cache[id] = nil
    for i, v in ipairs(self.queue) do
        if v == id then
            table.remove(self.queue, i)
            break
        end
    end

    return old
end

return MessageCache