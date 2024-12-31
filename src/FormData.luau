-- Lune
local Regex = require("@lune/regex")
local Serde = require("@lune/serde")

-- Constants
local VALID_EXTENSIONS = {
    png = true,
    apng = true,
    gif = true,
    jpg = true,
    jpeg = true,
    webp = true,
    svg = true,
    json = true
}

-- FormData
local FormData = {}

export type FormData = {
    boundary: "DiscordLua",
    buffers: { buffer },
    fileRegex: Regex.Regex,

    new: () -> FormData,
    attach: (self: FormData, fieldName: string, data: any, filename: string) -> nil,
    finish: (self: FormData) -> { buffer }
} & typeof(FormData)

function FormData.new(): FormData
    local self = setmetatable({} :: FormData, {
        __index = FormData
    })

    self.boundary = "DiscordLua"
    self.buffers = {}

    return self
end

function FormData.attach(self: FormData, fieldName: string, data: buffer | string, filename: string)
    local str = `\r\n--{self.boundary}\r\nContent-Disposition: form-data; name="{fieldName}"`
    local contentType = ""
    if filename then
        str ..= `; filename="{filename}"`
        local extension = filename:lower():match("%.([^%.]+)$")
        if VALID_EXTENSIONS[extension] then
            if extension == "png" or extension == "apng" or extension == "gif" or extension == "jpg" or extension == "jpeg" or extension == "webp" or extension == "svg" then
                if extension == "svg" then
                    extension = "svg+xml"
                end
                contentType = "image/"
            elseif extension == "json" then
                contentType = "application/"
            end
            contentType ..= extension
        end
    end

    if contentType ~= "" then
        str ..= `\r\nContent-Type: {contentType}`
    elseif typeof(data) == "table" then
        str ..= "\r\nContent-Type: application/json"
        data = buffer.fromstring(Serde.encode("json", data))
    end

    if typeof(data) == "string" then
        data = buffer.fromstring(`{data}`)
    end

    table.insert(self.buffers, buffer.fromstring(`{str}\r\n\r\n`))
    table.insert(self.buffers, data :: buffer)
end

function FormData.finish(self: FormData)
    table.insert(self.buffers, buffer.fromstring(`\r\n--{self.boundary}--`))
    return self.buffers
end

return FormData