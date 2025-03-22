local task = require("@lune/task")
local datetime = require("@lune/datetime")

local OrderedBucket = {}

export type LatencyRef = {
    latency: number,
    raw: { number },
    timeOffset: number,
    timeOffsets: { number },
    lastTimeOffsetCheck: number
}

export type OrderedBucket = {
    latencyRef: LatencyRef,
    limit: number,
    processing: boolean | thread,
    remaining: number,
    reset: number,

    _queue: {},

    new: (limit: number, latencyRef: LatencyRef?) -> OrderedBucket,
    check: (self: OrderedBucket, override: boolean?) -> nil,
    queue: (self: OrderedBucket, func: () -> any, short: boolean?) -> nil
} & typeof(OrderedBucket)

function OrderedBucket.new(limit: number, latencyRef: LatencyRef?): OrderedBucket
    local self = setmetatable({} :: OrderedBucket, {
        __index = OrderedBucket
    })

    if not latencyRef then
        latencyRef = { latency = 0 } :: any
    end

    self.limit = limit
    self.remaining = limit
    self.reset = 0
    self.processing = false
    self.latencyRef = latencyRef
    self._queue = {}

    return self
end

function OrderedBucket.check(self: OrderedBucket, override: boolean?)
    if #self._queue == 0 then
        if self.processing then
            task.cancel(self.processing :: thread)
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

function OrderedBucket.queue(self: OrderedBucket, func: () -> any, short: boolean?)
    if short then
        table.insert(self._queue, 1, func)
    else
        table.insert(self._queue, func)
    end
    self:check()
end

return OrderedBucket