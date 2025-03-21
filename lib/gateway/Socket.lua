local net = require("@lune/net")
local task = require("@lune/task")

local Signal = require("../vendor/Signal")

local Socket = {}

function Socket.new(url, listenImmediately)
    local self = setmetatable({}, {
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

function Socket:_startListening()
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
        if self.socket and self.socket.closeCode then
            self.OnClose:Fire(self.socket.closeCode)
        end
    end)
end

function Socket:send(message)
    if self.socket and self.socket.closeCode == nil then
        local success, err = pcall(self.socket.send, message)
        if not success then
            self.OnError:Fire(err)
        end
    else
        self.OnError:Fire("Socket is closed")
    end
end

function Socket:connect()
    self:_startListening()
end

function Socket:close(code)
    if self.socket and self.socket.closeCode == nil then
        self.socket:close(code)
        self.isOpen = false
    end
end

return Socket