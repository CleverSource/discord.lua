--[=[
@class Logger

A simple logging utility with color-coded output for different log levels.
]=]
local Logger = {}
Logger.__index = Logger

--[=[
@prop _debug Socket
@private
@within Logger
A boolean that indicates whether debugging is enabled. If true, debug messages will be logged.
]=]
export type Logger = typeof(setmetatable({} :: {
    _debug: boolean,
}, Logger))

local colors = {
    reset = "\27[0m",
    debug = "\27[36m",
    info = "\27[32m",
    warn = "\27[33m",
    error = "\27[31m",
}

--[=[
@function new
@within Logger
@tag Constructor

Creates a new Logger instance.

@param debug boolean? -- Whether to enable debugging. Defaults to false.
@return Logger -- The constructed Logger instance.
]=]
function Logger.new(debug: boolean?): Logger
    local self = setmetatable({}, Logger) :: Logger

    self._debug = debug or false

    return self
end

local function log(level, color, message, ...)
    if typeof(message) == "string" then    
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local messageFormatted = message:format(...)
        print(`{color}[{timestamp}] [{level}] {messageFormatted}{colors.reset}`)
    else
        print(`{color}{os.date("%Y-%m-%d %H:%M:%S")} [{level}]:{colors.reset}`)
        print(message)
    end
end

--[=[
@method debug
@within Logger

Logs a debug message if debugging is enabled.

@param message string -- The debug message to log.
@param ... any -- Additional values to format into the message.
]=]
function Logger:debug(message, ...)
    if self._debug then
        log("DEBUG", colors.debug, message, ...)
    end
end

--[=[
@method print
@within Logger

Logs an informational message.

@param message string -- The informational message to log.
@param ... any -- Additional values to format into the message.
]=]
function Logger:print(message, ...)
    log("INFO", colors.info, message, ...)
end

--[=[
@method warn
@within Logger

Logs a warning message.

@param message string -- The warning message to log.
@param ... any -- Additional values to format into the message.
]=]
function Logger:warn(message, ...)
    log("WARN", colors.warn, message, ...)
end

--[=[
@method error
@within Logger

Logs an error message.

@param message string -- The error message to log.
@param ... any -- Additional values to format into the message.
]=]
function Logger:error(message, ...)
    log("ERROR", colors.error, message, ...)
end

return Logger