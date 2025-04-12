local net = require("@lune/net")
local task = require("@lune/task")

--[=[
@class Socket

Socket provides a wrapper around a WebSocket connection, managing its lifecycle and events.
]=]
local Socket = {}
Socket.__index = Socket

--[=[
@type Events { open: (() -> ())?, message: ((string) -> ())?, close: ((number) -> ())?, error: ((string) -> ())? }
@within Socket
A type representing the event handlers for a WebSocket connection. This type defines optional callbacks for different events that may occur during the connection's lifecycle.

The events include:
- `open`: A function that is called when the WebSocket connection is successfully opened.
- `message`: A function that is called when a message is received from the WebSocket, with the message passed as a string parameter.
- `close`: A function that is called when the WebSocket connection is closed, with the closure code passed as a number parameter.
- `error`: A function that is called when an error occurs with the WebSocket, with the error message passed as a string parameter.
]=]
export type Events = {
    open: (() -> ())?,
    message: ((string) -> ())?,
    close: ((number) -> ())?,
    error: ((string) -> ())?
}

--[=[
@prop socket net.WebSocket?
@private
@within Socket
The underlying WebSocket instance used for the connection.
]=]
--[=[
@prop isOpen boolean
@within Socket
A boolean that indicates whether the WebSocket connection is currently open.
]=]
--[=[
@prop events Events
@within Socket
A table holding event handlers for the socket connection, such as `open`, `message`, `close`, and `error`.
]=]
export type Socket = typeof(setmetatable({} :: {
    socket: net.WebSocket?,
    isOpen: boolean,

    events: Events,
}, Socket))

--[=[
@function new
@within Socket
@tag Constructor

Creates a new Socket connection.

@param url string -- The WebSocket URL to connect to.
@param listenImmediately boolean? -- If true, starts listening immediately (can cause race conditions with `open`).
@return Socket -- The constructed Socket instance.
]=]
function Socket.new(url: string, listenImmediately: boolean?): Socket
    local self = setmetatable({}, Socket) :: Socket

    self.socket = net.socket(url)
    self.isOpen = true

    self.events = {}

    -- NOTE: a race condition will occur with events.open if listenImmediately is true
    if not (not listenImmediately) then
        self:_startListening()
    end

    return self
end

--[=[
@private
@method _startListening
@within Socket

Internal method that listens for messages and dispatches to appropriate events.
]=]
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

--[=[
@method send
@within Socket

Sends a message through the WebSocket if it's open.

@param message string -- The message to send.
]=]
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

--[=[
@method connect
@within Socket

Starts listening to the WebSocket connection. Can be called manually if `listenImmediately` was false.
]=]
function Socket.connect(self: Socket)
    self:_startListening()
end

--[=[
@method close
@within Socket

Closes the WebSocket connection.

@param code number? -- An optional close code to pass to the server.
]=]
function Socket.close(self: Socket, code: number?)
    if self.socket and self.socket.closeCode == nil then
        self.socket.close(code)
        self.isOpen = false
    end
end

return Socket