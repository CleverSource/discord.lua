local Base64 = require("@vendor/Base64")

return function(token: string): string
    return Base64.decode(token:split(".")[1])
end