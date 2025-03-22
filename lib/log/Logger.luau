local Logger = {}

export type Logger = {
    _debug: boolean,

    new: (debug: boolean?) -> Logger,
    debug: (message: string, ...any) -> nil,
    print: (message: string, ...any) -> nil,
    warn: (message: string, ...any) -> nil,
    error: (message: string, ...any) -> nil,
} & typeof(Logger)

local colors = {
    reset = "\27[0m",
    debug = "\27[36m",
    info = "\27[32m",
    warn = "\27[33m",
    error = "\27[31m",
}

function Logger.new(debug: boolean?): Logger
    local self = setmetatable({} :: Logger, {
        __index = Logger
    })

    self._debug = debug or false

    return self
end

local function log(level, color, message, ...)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local messageFormated = string.format(message, ...)
    print(string.format("%s[%s] [%s] %s%s", color, timestamp, level, messageFormated, colors.reset))
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