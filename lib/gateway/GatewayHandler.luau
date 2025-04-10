local process = require("@lune/process")

local Shard = require("Shard")
type Shard = Shard.Shard
type ShardEvents = Shard.Events
type ShardProperties = Shard.ShardProperties
local Constants = require("../Constants")
local Logger = require("../log/Logger")
type Logger = Logger.Logger

local getDiscordEpoch = require("../util/getDiscordEpoch")

local GatewayTypes = require("../types/internal/gateway")
local ApiTypes = require("../types/apiTypes")

local Promise = require("../vendor/Promise")
type Promise = Promise.Promise

local GatewayHandler = {}
GatewayHandler.__index = GatewayHandler

export type ConnectionOptions = {
    url: string,
    shards: number,
    sessionStartLimit: ApiTypes.SessionStartLimitObject
}

export type GatewayHandlerOptions = {
    logger: Logger?,
    events: ShardEvents?,
    token: string?,
    preferSnakeCase: boolean?,
    url: string?,
    version: number?,
    compress: boolean?,
    intents: number?,
    connection: ConnectionOptions?,
    totalShards: number?,
    lastShardId: number?,
    firstShardId: number?,
    totalWorkers: number?,
    shardsPerWorker: number?
}

export type GatewayHandler = typeof(setmetatable({} :: {
    defaultConnection: boolean,
    logger: Logger,
    token: string?,
    preferSnakeCase: boolean,
    url: string,
    version: number,
    compress: boolean,
    intents: number,
    sessionStartLimit: ApiTypes.SessionStartLimitObject,
    totalShards: number,
    lastShardId: number,
    firstShardId: number,
    totalWorkers: number,
    shardsPerWorker: number,
    buckets: {}, -- TODO
    shards: { [string]: Shard },
    properties: ShardProperties,
    events: ShardEvents,
}, GatewayHandler))

function GatewayHandler.new(options: GatewayHandlerOptions): GatewayHandler
    local self = setmetatable({}, GatewayHandler) :: GatewayHandler

    options = options or {} :: GatewayHandlerOptions

    self.defaultConnection = true

    local defaultConnectionOptions = {
        url = Constants.DefaultGateway,
        shards = 1,
        sessionStartLimit = {
            maxConcurrency = 1,
            remaining = 1000,
            total = 1000,
            resetAfter = 1000 * 60 * 60 * 24
        }
    }

    self.logger = options.logger or Logger.new()

    self.events = options.events or {}
    self.token = options.token
    self.preferSnakeCase = options.preferSnakeCase or false
    self.url = options.url or defaultConnectionOptions.url
    self.version = options.version or Constants.GatewayVersion
    self.compress = options.compress or false
    self.intents = options.intents or 0

    local connectionOptions = options.connection or defaultConnectionOptions
    self.sessionStartLimit = connectionOptions.sessionStartLimit
    self.totalShards = options.totalShards or connectionOptions.shards
    self.lastShardId = options.lastShardId or (self.totalShards - 1)
    self.firstShardId = options.firstShardId or 0
    self.totalWorkers = options.totalWorkers or 4
    self.shardsPerWorker = options.shardsPerWorker or 25

    self.buckets = {}
    self.shards = {}
    self.properties = {
        os = process.os,
        browser = "DiscordLua",
        device = "DiscordLua"
    }

    -- TODO: resharding

    return self
end

function GatewayHandler.calculateShardId(self: GatewayHandler, guildId: string, totalShards: number?): number
    if not totalShards then
        totalShards = self.totalShards
    end

    if totalShards == 1 then
        self.logger:debug("[Gateway] Only one shard in use - assigning shardId 0")
        return 0
    end

    self.logger:debug(`[Gateway] shardId calculated using guildId: {guildId}, with total shards: {totalShards}`)
    local shardId = getDiscordEpoch(guildId) % totalShards :: number
    return shardId
end

function GatewayHandler.updateConnectionOptions(self: GatewayHandler, newOptions: ConnectionOptions)
    if not newOptions then return end

    if newOptions.url then
        self.url = newOptions.url
    end

    if newOptions.sessionStartLimit then
        self.sessionStartLimit = newOptions.sessionStartLimit
    end

    if newOptions.shards then
        self.totalShards = newOptions.shards
        self.lastShardId = self.totalShards - 1
    end

    self.defaultConnection = false
end

function GatewayHandler.calculateWorkerId(self: GatewayHandler, shardId: number): number
    local workerId = math.min(math.floor(shardId / self.shardsPerWorker), self.totalWorkers - 1)
    self.logger:debug(`[Gateway] Worker allocation for shard {shardId}: worker {workerId} (Max workers: {self.totalWorkers}, Shards/worker: {self.shardsPerWorker})`)
    return workerId
end

function GatewayHandler.prepareBuckets(self: GatewayHandler)
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

function GatewayHandler.identify(self: GatewayHandler, shardId: number): Promise
    local shard = self.shards[tostring(shardId)]
    self.logger:debug(`[Gateway] Starting identification of shard #{shardId} ({shard and "reusing" or "creating"})`)

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
            events = self.events,
            logger = self.logger
        })

        if self.preferSnakeCase then
            shard.forwardToClient = function(shardSelf: Shard, packet: GatewayTypes.Payload<any>)
                if shardSelf.events.message then
                    shardSelf.events.message(shardSelf, packet)
                end
            end
        end

        self.shards[tostring(shardId)] = shard
    end

    local bucket = self.buckets[tostring(shardId % self.sessionStartLimit.maxConcurrency)]
    table.insert(bucket.identifyRequests, shardId)
    self.logger:debug(`[Gateway] Shard #{shardId} added to identify queue`)
    return shard:identify()
end

function GatewayHandler.tellWorkerToIdentify(self: GatewayHandler, workerId: number, shardId: number, bucketId: string): Promise
    self.logger:debug(`[Gateway] Requesting worker #{workerId} to handle shard #{shardId} in bucket #{bucketId}`)
    return self:identify(shardId)
end

function GatewayHandler.spawnShards(self: GatewayHandler)
    if self.defaultConnection then
        self.logger:warn("[Gateway] Using default connection options. It is recommended you fetch the gateway URL and session start limit from Discord.")
    end

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
    
    self.logger:debug("[Gateway] All shard processes have now been initialized")
end

function GatewayHandler.shutdown(self: GatewayHandler, code: number)
    for _, shard in pairs(self.shards) do
        shard:close(code)
    end
end

function GatewayHandler.sendPayload(self: GatewayHandler, shardId: number, payload: any)
    local shard = self.shards[tostring(shardId)]
    if not shard then
        error(`Shard (id: {shardId}) not found`)
    end
    shard:send(payload)
end

function GatewayHandler.kill(self: GatewayHandler, shardId: number)
    local shard = self.shards[tostring(shardId)]
    if not shard then
        error(`[Gateway] Cannot terminate shard #{shardId} — not found`)
    end

    self.logger:debug(`[Gateway] Shard #{shardId} is being terminated`)
    self.shards[tostring(shardId)] = nil
    shard:shutdown()
end

function GatewayHandler.joinVoiceChannel(self: GatewayHandler, guildId: string, channelId: string, options: { selfMute: boolean?, selfDeaf: boolean? }?)
    local shardId = self:calculateShardId(guildId)
    
    self.logger:debug(`[Gateway] Requesting voice channel exit for guild {guildId}`)

    self:sendPayload(shardId, {
        op = Constants.GatewayOpCodes.VoiceStateUpdate,
        d = {
            guild_id = guildId,
            channel_id = channelId,
            self_mute = options and options.selfMute or false,
            self_deaf = options and options.selfDeaf or false
        }
    })
end

function GatewayHandler.leaveVoiceChannel(self: GatewayHandler, guildId: string)
    local shardId = self:calculateShardId(guildId)
    
    self.logger:debug(`[Gateway] Leaving voice channel (guildId: {guildId})`)

    self:sendPayload(shardId, {
        op = Constants.GatewayOpCodes.VoiceStateUpdate,
        d = {
            guild_id = guildId,
            channel_id = "null",
            self_mute = false,
            self_deaf = false
        }
    })
end

return GatewayHandler