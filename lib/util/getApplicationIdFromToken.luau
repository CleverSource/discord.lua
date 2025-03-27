local Base64 = require("../vendor/Base64")
local padBase64String = require("padBase64String")

return function(token: string): string
    local paddedToken = padBase64String(token:split(".")[1])
    local applicationIdBuffer = Base64.decode(buffer.fromstring(paddedToken))
    return buffer.tostring(applicationIdBuffer)
end