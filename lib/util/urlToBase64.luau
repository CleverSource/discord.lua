local net = require("@lune/net")
local Base64 = require("../vendor/Base64")

return function(url: string): string
    local image = net.request({
        method = "GET",
        url = url
    })
    local imageStr = Base64.encode(buffer.fromstring(image.body))
    local type = url:lower():match("%.([^%.]+)$")
    return `data:image/{type};base64,{buffer.tostring(imageStr)}`
end