local Base64 = require("../vendor/Base64")

return function(content: string): string
    local contentStr = Base64.encode(buffer.fromstring(content))
    local base64EncodedContent = buffer.tostring(contentStr)
    local type = "unknown"
    if content:sub(1, 3) == "\xFF\xD8\xFF" then
        type = "image/jpeg"
    elseif content:sub(1, 8) == "\x89PNG\r\n\x1A\n" then
        type = "image/png"
    elseif content:sub(1, 4) == "GIF8" then
        type = "image/gif"
    end

    if type == "unknown" then
        error("Unknown image type")
    end

    return `data:image/{type};base64,{base64EncodedContent}`
end