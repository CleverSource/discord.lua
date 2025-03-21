local process = require("@lune/process")

local Shard = require("Shard")
local Constants = require("../Constants")

local Promise = require("../vendor/Promise")

local GatewayHandler = {}

function GatewayHandler.new(options)
    local self = setmetatable({}, {
        __index = GatewayHandler
    })

    local connectionOptions = options.connectionOptions or {
        url = Constants.DefaultGateway,
        shards = 1,
        sessionStartLimit = {
            maxConcurrency = 1,
            remaining = 1000,
            total = 1000,
            resetAfter = 1000 * 60 * 60 * 24
        }
    }

    self.events = options.events or {}
    self.token = options.token

    self.preferSnakeCase = options.preferSnakeCase or false

    self.url = options.url or connectionOptions.url
    self.version = options.version or Constants.GatewayVersion
    self.compress = options.compress or false
    self.properties = {
        os = process.os,
        browser = "DiscordLua",
        device = "DiscordLua"
    }
    self.intents = options.intents or 0

    self.sessionStartLimit = connectionOptions.sessionStartLimit

    self.totalShards = options.totalShards or connectionOptions.shards
    self.lastShardId = options.lastShardId or (self.totalShards - 1)
    self.firstShardId = options.firstShardId or 0

    self.totalWorkers = options.totalWorkers or 4
    self.shardsPerWorker = options.shardsPerWorker or 25

    self.buckets = {}
    self.shards = {}

    return self
end

function GatewayHandler:calculateWorkerId(shardId)
    local workerId = math.min(math.floor(shardId / self.shardsPerWorker), self.totalWorkers - 1)
    print(`[Gateway] Calculating workerId: Shard: {shardId} -> Worker: {workerId} -> Per Worker {self.shardsPerWorker} -> Total: {self.totalWorkers}`)
    return workerId
end

function GatewayHandler:prepareBuckets()
    for i = 0, self.sessionStartLimit.maxConcurrency - 1 do
        self.buckets[tostring(i)] = {
            workers = {},
            identifyRequests = {}
        }
    end

    local shardId = self.firstShardId
    while shardId <= self.lastShardId do
        local bucketId = shardId % self.sessionStartLimit.maxConcurrency
        local bucket = self.buckets[tostring(bucketId)]

        local workerId = self:calculateWorkerId(shardId)
        local workerFound = false
        for _, worker in ipairs(bucket.workers) do
            if worker.id == workerId then
                table.insert(worker.shards, shardId)
                workerFound = true
                break
            end
        end

        if not workerFound then
            table.insert(bucket.workers, {
                id = workerId,
                queue = {
                    shardId
                }
            })
        end

        shardId = shardId + 1
    end

    for _, bucket in pairs(self.buckets) do
        for _, worker in pairs(bucket.workers) do
            table.sort(worker.queue, function(a, b) 
                return a < b 
            end)
        end
    end
end

function GatewayHandler:identify(shardId)
    local shard = self.shards[tostring(shardId)]
    print(`[Gateway] Identifying {shard and "existing" or "new"} shard ({shardId})`)

    if not shard then
        shard = Shard.new({
            id = shardId,
            connection = {
                url = self.url,
                version = self.version,
                token = self.token,
                compress = self.compress,
                properties = self.properties,
                intents = self.intents,
                totalShards = self.totalShards
            },
            events = self.events
        })

        if self.preferSnakeCase then
            shard.forwardToClient = function(shardSelf, packet)
                if shardSelf.events.message then
                    shardSelf.events.message(shardSelf, packet)
                end
            end
        end

        self.shards[tostring(shardId)] = shard
    end

    local bucket = self.buckets[tostring(shardId % self.sessionStartLimit.maxConcurrency)]
    table.insert(bucket.identifyRequests, shardId)
    print(`[Gateway] Identifying Shard #{shardId}`)
    return shard:identify()
end

function GatewayHandler:tellWorkerToIdentify(workerId, shardId, bucketId)
    print(`[Gateway] Telling worker to identify ({workerId}, {shardId}, {bucketId})`)
    return self:identify(shardId)
end

function GatewayHandler:spawnShards()
    self:prepareBuckets()

    local promises = {}
    for bucketId, bucket in pairs(self.buckets) do
        for _, worker in pairs(bucket.workers) do
            for _, shardId in pairs(worker.queue) do
                table.insert(promises, self:tellWorkerToIdentify(worker.id, shardId, bucketId))
            end
        end
    end
    Promise.All(promises):Await()
    
    print("[Gateway] All shards spawned")
end

function GatewayHandler:shutdown(code)
    for _, shard in pairs(self.shards) do
        shard:close(code)
    end
end

function GatewayHandler:sendPayload(shardId, payload)
    local shard = self.shards[tostring(shardId)]
    if not shard then
        error(`Shard (id: {shardId}) not found`)
    end
    shard:send(payload)
end

function GatewayHandler:kill(shardId)
    local shard = self.shards[tostring(shardId)]
    if not shard then
        error(`[Gateway] A kill for Shard #{shardId} was requested, but the shard was not found`)
    end

    print(`[Gateway] Killing Shard #{shardId}`)
    self.shards[tostring(shardId)] = nil
    shard:shutdown()
end

return GatewayHandler