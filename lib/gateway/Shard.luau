local task = require("@lune/task")
local net = require("@lune/net")

local camelize = require("../util/snakeCaseToCamel")
local Socket = require("Socket")
type Socket = Socket.Socket
local Constants = require("../Constants")
local Logger = require("../log/Logger")
type Logger = Logger.Logger

local Promise = require("../vendor/Promise")
type Promise = Promise.Promise

local GatewayTypes = require("../types/internal/gateway")

local SHARD_STATE_IDENTIFYING = "identifying"
local SHARD_STATE_RESUMING = "resuming"
local SHARD_STATE_CONNECTING = "connecting"
local SHARD_STATE_UNIDENTIFIED = "unidentified"
local SHARD_STATE_CONNECTED = "connected"
local SHARD_STATE_DISCONNECTED = "disconnected"
local SHARD_STATE_OFFLINE = "offline"

local Shard = {}
Shard.__index = Shard

export type ShardProperties = {
    os: string,
    browser: string,
    device: string,
}

export type ShardConnection = {
    url: string,
    version: number,
    token: string,
    compress: boolean,
    properties: ShardProperties,
    intents: number,
    totalShards: number
}

export type Events = {
    disconnected: ((Shard) -> ())?,
    heartbeat: ((Shard) -> ())?,
    hello: ((Shard) -> ())?,
    heartbeatAck: ((Shard) -> ())?,
    requestedReconnect: ((Shard) -> ())?,
    invalidSession: ((Shard, boolean) -> ())?,
    resumed: ((Shard) -> ())?,
    message: ((Shard, GatewayTypes.Packet<any>) -> ())?,
    connected: ((Shard) -> ())?,
    connecting: ((Shard) -> ())?,
    identifying: ((Shard) -> ())?,
    identified: ((Shard) -> ())?
}

export type ShardOptions = {
    logger: Logger?,
    id: number,
    connection: ShardConnection,
    events: Events?
}

export type Shard = typeof(setmetatable({} :: {
    logger: Logger,
    id: number,
    connection: ShardConnection,
    goingOffline: boolean,
    heart: {
        acknowledged: boolean,
        interval: number,
        spawnId: thread,
        delayId: thread
    },
    resolvers: {
        [string]: () -> ()
    },
    offlineSendQueue: { () -> () },
    events: Events,
    socket: Socket,
    resumeGatewayUrl: string,
    sessionId: string,
    previousSequenceNumber: number,
    state: "identifying" | "resuming" | "connecting" | "unidentified" | "connected" | "disconnected" | "offline",
    resolveAfterClose: (() -> ())?,
}, Shard))

function Shard.new(options: ShardOptions): Shard
    local self = setmetatable({}, Shard) :: Shard

    self.logger = options.logger or Logger.new()

    self.id = options.id
    self.connection = options.connection
    
    self.goingOffline = false
    self.heart = {
        acknowledged = false,
        interval = 45000
    }
    self.resolvers = {}
    self.offlineSendQueue = {}

    -- Functional events
    self.events = options.events or {}
    
    return self
end

function Shard.isOpen(self: Shard): boolean
    return self.socket and self.socket.isOpen or false
end

function Shard.checkOffline(self: Shard, highPriority: boolean?): Promise
    if self:isOpen() then return { Await = function() end } end

    return Promise.new(function(resolve)
        if highPriority then
            table.insert(self.offlineSendQueue, 1, resolve)
        else
            table.insert(self.offlineSendQueue, resolve)
        end
    end)
end

function Shard.gatewayConfig(self: Shard): ShardConnection
    return self.connection
end

function Shard.connectionUrl(self: Shard): string
    return self.resumeGatewayUrl or self:gatewayConfig().url
end

function Shard.handleError(self: Shard, err: any)
    self.logger:error(`[Shard] There was an error connecting Shard #{self.id}.`, err)
end

function Shard.handleClose(self: Shard, code: number?)
    self.socket = nil :: any
    self:stopHeartbeating()

    self.logger:debug(`[Shard] Shard #{self.id} closed with code {code}`)
    
    if self.resolveAfterClose then
        self.resolveAfterClose()
    end

    -- Cases where a resume is not allowed
    if code == Constants.ShardCloseCodes.TestingFinished then
        self.state = SHARD_STATE_OFFLINE
        if self.events.disconnected then
            self.events.disconnected(self)
        end

        return
    elseif code == Constants.ShardCloseCodes.Shutdown or code == Constants.ShardCloseCodes.ReIdentifying or code == Constants.ShardCloseCodes.Resharded or code == Constants.ShardCloseCodes.ResumeClosingOldConnection then
        self.state = SHARD_STATE_DISCONNECTED
        if self.events.disconnected then
            self.events.disconnected(self)
        end

        return
    elseif 
        code == Constants.GatewayCloseCodes.AuthenticationFailed 
        or code == Constants.GatewayCloseCodes.InvalidShard 
        or code == Constants.GatewayCloseCodes.ShardingRequired 
        or code == Constants.GatewayCloseCodes.InvalidApiVersion 
        or code == Constants.GatewayCloseCodes.InvalidIntents 
        or code == Constants.GatewayCloseCodes.DisallowedIntents then
        self.state = SHARD_STATE_OFFLINE
        if self.events.disconnected then
            self.events.disconnected(self)
        end

        self.logger:error(`[Shard] Shard #{self.id} closed and will not reconnect. Code: {code}`)
        return
    elseif code == Constants.GatewayCloseCodes.NotAuthenticated or code == Constants.GatewayCloseCodes.InvalidSeq or code == Constants.GatewayCloseCodes.SessionTimedOut then
        self.logger:debug(`[Shard] Shard #{self.id} closed requiring re-identify`)
        self.state = SHARD_STATE_IDENTIFYING
        if self.events.disconnected then
            self.events.disconnected(self)
        end

        self:identify():Await()
        return
    end

    if code == Constants.GatewayCloseCodes.NormalClosure or code == Constants.GatewayCloseCodes.GoingAway then
        if self.goingOffline then
            self.state = SHARD_STATE_DISCONNECTED
            if self.events.disconnected then
                self.events.disconnected(self)
            end

            self.goingOffline = false
            return
        end
    end

    -- Attempt resume
    self.logger:debug(`[Shard] Shard #{self.id} closed with code {code}. Attempting to resume!`)
    self.state = self.state == SHARD_STATE_RESUMING and SHARD_STATE_IDENTIFYING or SHARD_STATE_RESUMING
    if self.events.disconnected then
        self.events.disconnected(self)
    end

    if self.state == SHARD_STATE_RESUMING then
        self:resume():Await()
    else
        self:identify():Await()
    end
end

function Shard.handleMessage(self: Shard, msg: any)
    -- TODO: compression

    local data = net.jsonDecode(msg)
    self:handleDiscordPacket(data)
end

function Shard.handleDiscordPacket(self: Shard, packet: GatewayTypes.Packet<any>)
    self.heart.acknowledged = true

    if packet.op == Constants.GatewayOpCodes.Heartbeat then
        if not self:isOpen() then return end

        self.socket:send(net.jsonEncode({
            op = Constants.GatewayOpCodes.Heartbeat,
            d = self.previousSequenceNumber
        }))
        if self.events.heartbeat then
            self.events.heartbeat(self)
        end
    elseif packet.op == Constants.GatewayOpCodes.Hello then
        local interval = packet.d.heartbeat_interval
        self.logger:debug(`[Shard] Shard #{self.id} received Hello`)
        self:startHeartbeating(interval)

        if self.state ~= SHARD_STATE_RESUMING then
            -- TODO: bucket stuff
        end

        if self.events.hello then
            self.events.hello(self)
        end
    elseif packet.op == Constants.GatewayOpCodes.HeartbeatACK then
        if self.events.heartbeatAck then
            self.events.heartbeatAck(self)
        end
    elseif packet.op == Constants.GatewayOpCodes.Reconnect then
        self.logger:debug(`[Shard] Received a Reconnect for Shard #{self.id}`)
        if self.events.requestedReconnect then
            self.events.requestedReconnect(self)
        end

        self:resume():Await()
    elseif packet.op == Constants.GatewayOpCodes.InvalidSession then
        local resumable = not (not packet.d)
        self.logger:debug(`[Shard] Received Invalid Session for Shard #{self.id} with resumable as {resumable}`)

        if self.events.invalidSession then
            self.events.invalidSession(self, resumable)
        end

        task.wait(math.floor((math.random() * 5) + 1))

        if self.resolvers["INVALID_SESSION"] then
            self.resolvers["INVALID_SESSION"]()
            self.resolvers["INVALID_SESSION"] = nil
        end

        if resumable then
            self:resume():Await()
        else
            self:identify():Await()
        end
    end

    if packet.t == "RESUMED" then
        self.state = SHARD_STATE_CONNECTED
        if self.events.resumed then
            self.events.resumed(self)
        end

        self.logger:debug(`[Shard] Shard #{self.id} received RESUMED`)

        for _, resolve in ipairs(self.offlineSendQueue) do
            resolve()
        end
        table.clear(self.offlineSendQueue)

        if self.resolvers["RESUMED"] then
            self.resolvers["RESUMED"]()
            self.resolvers["RESUMED"] = nil
        end
    elseif packet.t == "READY" then
        local payload = packet.d
        self.resumeGatewayUrl = payload.resume_gateway_url
        self.sessionId = payload.session_id

        self.state = SHARD_STATE_CONNECTED

        self.logger:debug(`[Shard] Shard #{self.id} received READY`)

        for _, resolve in ipairs(self.offlineSendQueue) do
            resolve()
        end
        table.clear(self.offlineSendQueue)

        if self.resolvers["READY"] then
            self.resolvers["READY"]()
            self.resolvers["READY"] = nil
        end
    end

    if packet.s ~= nil then
        self.previousSequenceNumber = packet.s
    end

    self:forwardToClient(packet)
end

function Shard.forwardToClient(self: Shard, packet: GatewayTypes.Packet<any>)
    if self.events.message then
        self.events.message(self, camelize(packet))
    end
end

function Shard.close(self: Shard, code: number)
    self.logger:debug(`[Shard] Request for Shard #{self.id} to close the socket with code {code}`)

    if not self.socket.isOpen then
        self.logger:warn(`[Shard] Shard #{self.id} is not open, but attempted to close`)
        return
    end

    self.goingOffline = code == Constants.GatewayCloseCodes.NormalClosure or code == Constants.GatewayCloseCodes.GoingAway

    local promise = Promise.new(function(resolve) 
        self.resolveAfterClose = resolve
    end)

    self.socket:close(code)

    self.logger:debug(`[Shard] Waiting for Shard #{self.id} to close the socket with code {code}`)

    promise:Await()

    self.logger:debug(`[Shard] Shard #{self.id} closed the socket with code {code}`)
    self.resolveAfterClose = nil
end

function Shard.shutdown(self: Shard)
    self:close(Constants.ShardCloseCodes.Shutdown)
    self.state = SHARD_STATE_OFFLINE
end

function Shard.connect(self: Shard): Promise
    if self.state ~= SHARD_STATE_IDENTIFYING and self.state ~= SHARD_STATE_RESUMING then
        self.state = SHARD_STATE_CONNECTING
    end

    if self.events.connecting then
        self.events.connecting(self)
    end

    local url = self:connectionUrl()
    if url:sub(#url) ~= "/" then
        url = url .. "/"
    end
    url = `{url}?v={self:gatewayConfig().version}&encoding=json`

    self.logger:debug(`[Shard] Connecting to {url}`)

    local socket = Socket.new(url, false)
    self.socket = socket

    socket.events.error = function(err)
        self:handleError(err)
    end
    socket.events.close = function(code)
        self:handleClose(code)
    end
    socket.events.message = function(msg)
        self:handleMessage(msg)
    end

    return Promise.new(function(resolve)
        socket.events.open = function()
            if self.state ~= SHARD_STATE_IDENTIFYING and self.state ~= SHARD_STATE_RESUMING then
                self.state = SHARD_STATE_UNIDENTIFIED
            end

            if self.events.connected then
                self.events.connected(self)
            end

            resolve()
        end

        socket:connect()
    end)
end

function Shard.startHeartbeating(self: Shard, interval: number)
    self.logger:debug(`[Shard] Start heatbeating on Shard #{self.id}`)
    self:stopHeartbeating()

    self.heart.interval = interval

    if self.state == SHARD_STATE_DISCONNECTED or self.state == SHARD_STATE_OFFLINE then
        self.logger:warn(`[Shard] Shard is disconnected or offline but the heartbeat was started #{self.id}`)
        self.state = SHARD_STATE_UNIDENTIFIED
    end

    local jitteryness = math.random()
    local jitter = math.ceil(self.heart.interval * (jitteryness ~= 0 and jitteryness or 0.5))

    self.heart.delayId = task.delay(jitter / 1000, function()
        self.logger:debug(`[Shard] Beginning heartbeating process for Shard #{self.id}`)

        if not self:isOpen() then return end

        self.logger:debug(`[Shard] Heartbeating on Shard #{self.id}. Previous sequence number: {self.previousSequenceNumber}`)
    
        self.socket:send(net.jsonEncode({
            op = Constants.GatewayOpCodes.Heartbeat,
            d = self.previousSequenceNumber
        }))

        self.heart.acknowledged = false

        self.heart.spawnId = task.spawn(function() 
            local function beat()
                task.wait(self.heart.interval / 1000)

                if not self:isOpen() then
                    self.logger:warn(`[Shard] Shard #{self.id} is not open, but attempted heartbeat`)
                    return
                end
    
                if not self.heart.acknowledged then
                    self.logger:warn(`[Shard] Heartbeat not acknowledged for Shard #{self.id}. Closing`)
                    self:close(Constants.ShardCloseCodes.ZombieConnection)
                    return
                end
    
                self.logger:debug(`[Shard] Heartbeating on Shard #{self.id}. Previous sequence number: {self.previousSequenceNumber}`)
            
                self.socket:send(net.jsonEncode({
                    op = Constants.GatewayOpCodes.Heartbeat,
                    d = self.previousSequenceNumber
                }))
    
                self.heart.acknowledged = false
    
                if self.events.heartbeat then
                    self.events.heartbeat(self)
                end
                beat()
            end
            beat()
        end)
    end)
end

function Shard.stopHeartbeating(self: Shard)
    if self.heart.spawnId then
        task.cancel(self.heart.spawnId)
    end

    if self.heart.delayId then
        task.cancel(self.heart.delayId)
    end
end

function Shard.send(self: Shard, message: any, highPriority: boolean?)
    self:checkOffline():Await()

    -- TODO: bucket stuff

    -- self:checkOffline():Await()

    self.socket:send(net.jsonEncode(message))
end

function Shard.identify(self: Shard): Promise
    if self:isOpen() then
        self.logger:debug(`[Shard] Identifying open Shard #{self.id}, closing the connection`)
        self:close(Constants.ShardCloseCodes.ReIdentifying)
    end

    self.state = SHARD_STATE_IDENTIFYING
    if self.events.identifying then
        self.events.identifying(self)
    end

    if not self:isOpen() then
        self:connect():Await()
    end

    self:send({
        op = Constants.GatewayOpCodes.Identify,
        d = {
            token = `Bot {self:gatewayConfig().token}`,
            compress = self:gatewayConfig().compress,
            properties = self:gatewayConfig().properties,
            intents = self:gatewayConfig().intents,
            shard = {
                self.id,
                self:gatewayConfig().totalShards
            }
        }
    })

    return Promise.new(function(resolve)
        self.resolvers["READY"] = function() 
            if self.events.identified then
                self.events.identified(self)
            end
            resolve()
        end
        self.resolvers["INVALID_SESSION"] = function() 
            self.resolvers["READY"] = nil
            resolve()
        end
    end)
end

function Shard.resume(self: Shard): Promise
    self.logger:debug(`[Shard] Resuming Shard #{self.id}`)

    if self:isOpen() then
        self.logger:debug(`[Shard] Resuming open Shard #{self.id}, closing the connection`)
        self:close(Constants.ShardCloseCodes.ResumeClosingOldConnection)
    end

    if not self.sessionId then
        self.logger:debug(`[Shard] Trying to resume Shard #{self.id} without a session id. Identifying the shard instead`)

        self:identify():Await()
        return
    end

    self.state = SHARD_STATE_RESUMING

    self:connect():Await()

    self.logger:debug(`[Shard] Resuming Shard #{self.id} connected. Session id: {self.sessionId} | Sequence: {self.previousSequenceNumber}`)

    self:send({
        op = Constants.GatewayOpCodes.Resume,
        d = {
            token = `Bot {self:gatewayConfig().token}`,
            session_id = self.sessionId,
            seq = self.previousSequenceNumber or 0
        }
    })

    return Promise.new(function(resolve) 
        self.resolvers["RESUMED"] = function() 
            resolve()
        end
        self.resolvers["INVALID_SESSION"] = function() 
            self.resolvers["RESUMED"] = nil
            resolve()
        end
    end)
end

return Shard