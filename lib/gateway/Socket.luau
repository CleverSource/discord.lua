local net = require("@lune/net")
local task = require("@lune/task")

local Socket = {}
Socket.__index = Socket

export type Events = {
    open: (() -> ())?,
    message: ((string) -> ())?,
    close: ((number) -> ())?,
    error: ((string) -> ())?
}

export type Socket = typeof(setmetatable({} :: {
    socket: net.WebSocket?,
    isOpen: boolean,

    events: Events,
}, Socket))

function Socket.new(url: string, listenImmediately: boolean?): Socket
    local self = setmetatable({}, Socket) :: Socket

    self.socket = net.socket(url)
    self.isOpen = true

    self.events = {}

    -- NOTE: a race condition will occur with "OnOpen" if listenImmediately is true
    if not (not listenImmediately) then
        self:_startListening()
    end

    return self
end

function Socket._startListening(self: Socket)
    task.spawn(function()
        if self.events.open then
            self.events.open()
        end

        while self.socket and self.socket.closeCode == nil do
            local success, message = pcall(self.socket.next)
            if success and message then
                if self.events.message then
                    self.events.message(message)
                end
            elseif not success then
                if self.events.error then
                    self.events.error(message)
                end
                break
            end
        end

        self.isOpen = false
        if self.socket then
            if self.events.close then
                self.events.close(self.socket.closeCode :: number)
            end
        end
    end)
end

function Socket.send(self: Socket, message: string)
    if message:find('"null"') then
        message = message:gsub('"null"', "null")
    end

    if self.socket and self.socket.closeCode == nil then
        local success, err = pcall(self.socket.send, message)
        if not success then
            if self.events.error then
                self.events.error(err)
            end
        end
    else
        if self.events.error then
            self.events.error("Socket is closed")
        end
    end
end

function Socket.connect(self: Socket)
    self:_startListening()
end

function Socket.close(self: Socket, code: number?)
    if self.socket and self.socket.closeCode == nil then
        self.socket.close(code)
        self.isOpen = false
    end
end

return Socket