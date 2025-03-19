local task = require("@lune/task")
local datetime = require("@lune/datetime")

local OrderedBucket = {}

function OrderedBucket.new(limit, latencyRef)
    local self = setmetatable({}, {
        __index = OrderedBucket
    })

    if not latencyRef then
        latencyRef = { latency = 0 }
    end

    self.limit = limit
    self.remaining = limit
    self.reset = 0
    self.processing = false
    self.latencyRef = latencyRef
    self._queue = {}

    return self
end

function OrderedBucket:check(override)
    if #self._queue == 0 then
        if self.processing then
            task.cancel(self.processing)
            self.processing = false
        end
        return
    end

    if self.processing and not override then
        return
    end

    local now = datetime.now().unixTimestampMillis
    local offset = self.latencyRef.latency
    if self.reset == 0 or self.reset < now - offset then
        self.reset = now - offset
        self.remaining = self.limit
    end

    if self.remaining <= 0 then
        self.processing = task.delay(math.max(0, self.reset - now + offset) / 1000, function()
            self.processing = false
            self:check(true)
        end)
        return
    end

    self.remaining = self.remaining - 1
    self.processing = true

    local func = table.remove(self._queue, 1)
    func(function()
        if #self._queue > 0 then
            self:check(true)
        else
            self.processing = false
        end
    end)
end

function OrderedBucket:queue(func, short)
    if short then
        table.insert(self._queue, 1, func)
    else
        table.insert(self._queue, func)
    end
    self:check()
end

return OrderedBucket