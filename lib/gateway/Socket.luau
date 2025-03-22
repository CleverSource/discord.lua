local net = require("@lune/net")
local task = require("@lune/task")

local Signal = require("../vendor/Signal")
type Signal<T> = Signal.Signal<T>

local Socket = {}

export type Socket = {
    socket: net.WebSocket?,
    isOpen: boolean,
    
    OnOpen: Signal<nil>,
    OnMessage: Signal<string>,
    OnClose: Signal<number>,
    OnError: Signal<string>,

    new: (url: string, listenImmediately: boolean?) -> Socket,
    _startListening: (self: Socket) -> nil,
    send: (self: Socket, message: any) -> nil,
    connect: (self: Socket) -> nil,
    close: (self: Socket, code: number?) -> nil
} & typeof(Socket)

function Socket.new(url: string, listenImmediately: boolean?): Socket
    local self = setmetatable({} :: Socket, {
        __index = Socket
    })

    self.socket = net.socket(url)
    self.isOpen = true

    self.OnOpen = Signal()
    self.OnMessage = Signal()
    self.OnClose = Signal()
    self.OnError = Signal()

    -- NOTE: a race condition will occur with "OnOpen" if listenImmediately is true
    if not (not listenImmediately) then
        self:_startListening()
    end

    return self
end

function Socket._startListening(self: Socket)
    task.spawn(function()
        self.OnOpen:Fire()

        while self.socket and self.socket.closeCode == nil do
            local success, message = pcall(self.socket.next)
            if success and message then
                self.OnMessage:Fire(message)
            elseif not success then
                self.OnError:Fire(message)
                break
            end
        end

        self.isOpen = false
        if self.socket then
            self.OnClose:Fire(self.socket.closeCode :: number)
        end
    end)
end

function Socket.send(self: Socket, message: any)
    if self.socket and self.socket.closeCode == nil then
        local success, err = pcall(self.socket.send, message)
        if not success then
            self.OnError:Fire(err)
        end
    else
        self.OnError:Fire("Socket is closed")
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