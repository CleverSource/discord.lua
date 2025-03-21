local SHARD_STATE_IDENTIFYING = "identifying"
local SHARD_STATE_RESUMING = "resuming"
local SHARD_STATE_CONNECTING = "connecting"
local SHARD_STATE_UNIDENTIFIED = "unidentified"
local SHARD_STATE_CONNECTED = "connected"
local SHARD_STATE_DISCONNECTED = "disconnected"
local SHARD_STATE_OFFLINE = "offline"

local task = require("@lune/task")
local net = require("@lune/net")
local datetime = require("@lune/datetime")

local Socket = require("Socket")
local Constants = require("../Constants")

local Signal = require("../vendor/Signal")
local Promise = require("../vendor/Promise")

local Shard = {}

function Shard.new(options)
    local self = setmetatable({}, {
        __index = Shard
    })

    self.id = options.id
    self.connection = options.connection
    
    self.heart = {
        acknowledged = false,
        interval = 45000
    }
    self.resolvers = {}

    self.events = options.events or {}
    
    return self
end

function Shard:isOpen()
    return self.socket and self.socket.isOpen or false
end

function Shard:gatewayConfig()
    return self.connection
end

function Shard:connectionUrl()
    -- TODO: resuming
    return self.resumeGatewayUrl or self:gatewayConfig().url
end

function Shard:handleError(err)
    print(`[Shard] There was an error connecting Shard #{self.id}.`, err)
end

function Shard:handleClose(code)
    print(code)
end

function Shard:handleMessage(msg)
    local data = net.jsonDecode(msg)
    self:handleDiscordPacket(data)
end

function Shard:handleDiscordPacket(packet)
    self.heart.lastAck = datetime.now().unixTimestampMillis
    self.heart.acknowledged = true

    if packet.op == Constants.GatewayOpCodes.HEARTBEAT then
        if not self:isOpen() then return end

        self.heart.lastBeat = datetime.now().unixTimestampMillis

        self.socket:send(net.jsonEncode({
            op = Constants.GatewayOpCodes.HEARTBEAT,
            d = self.previousSequenceNumber
        }))
        -- TODO: heartbeat event
    elseif packet.op == Constants.GatewayOpCodes.HELLO then
        local interval = packet.d.heartbeat_interval
        print(`[Shard] Shard #{self.id} received Hello`)
        self:startHeartbeating(interval)

        if self.state ~= SHARD_STATE_RESUMING then
            -- TODO: bucket stuff
        end

        -- TODO: hello event
    end

    if packet.t == "RESUMED" then
    
    elseif packet.t == "READY" then
        local payload = packet.d
        self.resumeGatewayUrl = payload.resume_gateway_url
        self.sessionId = payload.session_id

        self.state = SHARD_STATE_CONNECTED

        print(`[Shard] Shard #{self.id} received READY`)

        -- TODO: offline queue

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

function Shard:forwardToClient(packet)
    print(packet)
end

function Shard:connect()
    if self.state ~= SHARD_STATE_IDENTIFYING and self.state ~= SHARD_STATE_RESUMING then
        self.state = SHARD_STATE_CONNECTING
    end

    -- TODO: connecting event

    local url = self:connectionUrl()
    if url:sub(#url) ~= "/" then
        url = url .. "/"
    end
    url = `{url}?v={self:gatewayConfig().version}&encoding=json`

    local socket = Socket.new(url, false)
    self.socket = socket

    socket.OnError:Connect(function(err)
        self:handleError(err)
    end)
    socket.OnClose:Connect(function(code) 
        self:handleClose(code)
    end)
    socket.OnMessage:Connect(function(msg) 
        self:handleMessage(msg)
    end)

    return Promise.new(function(resolve)
        socket.OnOpen:Connect(function() 
            if self.state ~= SHARD_STATE_IDENTIFYING and self.state ~= SHARD_STATE_RESUMING then
                self.state = SHARD_STATE_UNIDENTIFIED
            end

            -- TODO: connected event

            resolve()
        end)

        socket:connect()
    end)
end

function Shard:startHeartbeating(interval)
    print(`[Shard] Start heatbeating on Shard #{self.id}`)
    self:stopHeartbeating()

    self.heart.interval = interval

    if self.state == SHARD_STATE_DISCONNECTED or self.state == SHARD_STATE_OFFLINE then
        print(`[Shard] Shard is disconnected or offline but the heartbeat was started #{self.id}`)
        self.state = SHARD_STATE_UNIDENTIFIED
    end

    local jitteryness = math.random()
    local jitter = math.ceil(self.heart.interval * (jitteryness ~= 0 and jitteryness or 0.5))

    self.heart.delayId = task.delay(jitter / 1000, function()
        print(`[Shard] Beginning heartbeating process for Shard #{self.id}`)

        if not self:isOpen() then return end

        print(`[Shard] Heartbeating on Shard #{self.id}. Previous sequence number: {self.previousSequenceNumber}`)
    
        self.socket:send(net.jsonEncode({
            op = Constants.GatewayOpCodes.HEARTBEAT,
            d = self.previousSequenceNumber
        }))

        self.heart.lastBeat = datetime.now().unixTimestampMillis
        self.heart.acknowledged = false

        self.heart.spawnId = task.spawn(function() 
            local function beat()
                task.wait(self.heart.interval / 1000)

                if not self:isOpen() then
                    print(`[Shard] Shard #{self.id} is not open, but attempted heartbeat?`)
                    return
                end
    
                if not self.heart.acknowledged then
                    print(`[Shard] Heartbeat not acknowledged for Shard #{self.id}. Closing`)
                    -- TODO: close connection
                    return
                end
    
                print(`[Shard] Heartbeating on Shard #{self.id}. Previous sequence number: {self.previousSequenceNumber}`)
            
                self.socket:send(net.jsonEncode({
                    op = Constants.GatewayOpCodes.HEARTBEAT,
                    d = self.previousSequenceNumber
                }))
    
                self.heart.lastBeat = datetime.now().unixTimestampMillis
                self.heart.acknowledged = false
    
                -- TODO: heartbeat event
                beat()
            end
            beat()
        end)
    end)
end

function Shard:stopHeartbeating()
    if self.heart.spawnId then
        task.cancel(self.heart.spawnId)
    end

    if self.heart.delayId then
        task.cancel(self.heart.delayId)
    end
end

function Shard:send(message, highPriority)
    -- TODO: check offline stuff?

    self.socket:send(net.jsonEncode(message))
end

function Shard:identify()
    -- TODO: old connections

    self.state = SHARD_STATE_IDENTIFYING
    -- TODO: identifying event

    if not self:isOpen() then
        self:connect():Await()
    end

    self:send({
        op = Constants.GatewayOpCodes.IDENTIFY,
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
            -- TODO: identified event
            -- TODO: shard is ready
            resolve()
        end
        self.resolvers["INVALID_SESSION"] = function() 
            self.resolvers["READY"] = nil
            resolve()
        end
    end)
end

return Shard