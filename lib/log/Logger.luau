local Logger = {}
Logger.__index = Logger

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

function Logger:debug(message, ...)
    if self._debug then
        log("DEBUG", colors.debug, message, ...)
    end
end

function Logger:print(message, ...)
    log("INFO", colors.info, message, ...)
end

function Logger:warn(message, ...)
    log("WARN", colors.warn, message, ...)
end

function Logger:error(message, ...)
    log("ERROR", colors.error, message, ...)
end

return Logger