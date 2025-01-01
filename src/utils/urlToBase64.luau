local Net = require("@lune/net")
local Base64 = require("@vendor/Base64")

return function(url: string): string
    local image = Net.request({
        method = "GET",
        url = url
    })
    local imageStr = Base64.encode(image.body)
    local type = url:lower():match("%.([^%.]+)$")
    return `data:image/{type};base64,{imageStr}`
end