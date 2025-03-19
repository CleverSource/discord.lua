local serde = require("@lune/serde")

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

local FormData = {}

function FormData.new()
    local self = setmetatable({}, {
        __index = FormData
    })

    self.boundary = "DiscordLua"
    self.data = {}

    return self
end

function FormData:attach(fieldName, data, filename)
    local str = "\r\n--" .. self.boundary .. "\r\nContent-Disposition: form-data; name=\"" .. fieldName .. "\""
    local contentType = ""
    if filename then
        str = str .. "; filename=\"" .. filename .. "\""
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
            contentType = contentType .. extension
        end
    end

    if contentType ~= "" then
        str = str .. "\r\nContent-Type: " .. contentType
    elseif type(data) == "table" then
        str = str .. "\r\nContent-Type: application/json"
        data = serde.encode("json", data)
    end

    if type(data) == "string" then
        data = data
    end

    table.insert(self.data, str .. "\r\n\r\n")
    table.insert(self.data, data)
end

function FormData:finish()
    table.insert(self.data, "\r\n--" .. self.boundary .. "--")
    return self.data
end

return FormData