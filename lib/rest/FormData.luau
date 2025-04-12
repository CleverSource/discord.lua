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

--[=[
@class FormData
@private

A class that represents form data for HTTP requests, supporting file attachments and various data types.
]=]
local FormData = {}
FormData.__index = FormData

export type FormData = typeof(setmetatable({} :: {
    boundary: "DiscordLua",
    data: { string },
}, FormData))

--[=[
@function new
@within FormData
@tag Constructor

Creates a new FormData instance.

@return FormData -- The constructed FormData instance.
]=]
function FormData.new(): FormData
    local self = setmetatable({}, FormData) :: FormData

    self.boundary = "DiscordLua"
    self.data = {}

    return self
end

--[=[
@method attach
@within FormData

Attaches a field to the form data with optional file handling based on the provided filename.

@param fieldName string -- The name of the field.
@param data string | table -- The data associated with the field, either as a string or a table to be serialized to JSON.
@param filename string? -- Optional filename for file data.
]=]
function FormData.attach(self: FormData, fieldName: string, data: string, filename: string)
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

--[=[
@method finish
@within FormData

Finishes the form data by adding the closing boundary and returning the complete form data.

@return { string } -- A list of strings representing the complete form data, including the boundary.
]=]
function FormData.finish(self: FormData): { string }
    table.insert(self.data, "\r\n--" .. self.boundary .. "--")
    return self.data
end

return FormData