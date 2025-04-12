local task = require("@lune/task")
local datetime = require("@lune/datetime")

--[=[
@class OrderedBucket
@private

A class that manages a rate-limited bucket with ordered processing for tasks.
]=]
local OrderedBucket = {}
OrderedBucket.__index = OrderedBucket

--[=[
@type LatencyRef { latency: number, raw: { number }, timeOffset: number, timeOffsets: { number }, lastTimeOffsetCheck: number }
@within OrderedBucket
A type representing latency reference data for bucket management.
]=]
export type LatencyRef = {
    latency: number,
    raw: { number },
    timeOffset: number,
    timeOffsets: { number },
    lastTimeOffsetCheck: number
}

export type OrderedBucket = typeof(setmetatable({} :: {
    latencyRef: LatencyRef,
    limit: number,
    processing: boolean | thread,
    remaining: number,
    reset: number,

    _queue: {},
}, OrderedBucket))

--[=[
@function new
@within OrderedBucket
@tag Constructor

Creates a new OrderedBucket instance.

@param limit number -- The limit for the bucket (e.g., max number of tasks).
@param latencyRef LatencyRef? -- Optional latency reference object for latency-based resets.
@return OrderedBucket -- The constructed OrderedBucket instance.
]=]
function OrderedBucket.new(limit: number, latencyRef: LatencyRef?): OrderedBucket
    local self = setmetatable({}, OrderedBucket) :: OrderedBucket

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

--[=[
@method check
@within OrderedBucket

Checks and processes the next task in the queue, respecting the rate limit and latency.

@param override boolean? -- Optional flag to override the current processing state.
]=]
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

--[=[
@method queue
@within OrderedBucket

Queues a function to be processed by the OrderedBucket with respect to rate limits.

@param func function -- The function to queue.
@param short boolean? -- If true, the function is placed at the front of the queue; otherwise, it's placed at the end.
]=]
function OrderedBucket.queue(self: OrderedBucket, func: () -> any, short: boolean?)
    if short then
        table.insert(self._queue, 1, func)
    else
        table.insert(self._queue, func)
    end
    self:check()
end

return OrderedBucket