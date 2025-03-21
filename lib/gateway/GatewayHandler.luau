local process = require("@lune/process")

local Shard = require("Shard")

local Promise = require("../vendor/Promise")

local GatewayHandler = {}

function GatewayHandler.new(options)
    local self = setmetatable({}, {
        __index = GatewayHandler
    })

    self.sessionStartLimit = {
        maxConcurrency = 1
    }

    self.token = options.token

    self.url = "wss://gateway.discord.gg"
    self.version = 10
    self.compress = false
    self.properties = {
        os = process.os,
        browser = "DiscordLua",
        device = "DiscordLua"
    }
    self.intents = 0

    self.buckets = {}
    self.shards = {}

    self.totalShards = 1
    self.lastShardId = self.totalShards - 1
    self.firstShardId = 0

    self.totalWorkers = 4
    self.shardsPerWorker = 25

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
            }
        })
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

return GatewayHandler