local RestTypes = require("../types/internal/rest")
local Constants = require("../Constants")
local bit64 = require("../vendor/bit64")

return function(permissions: { RestTypes.PermissionStrings }): number
    local bits = 0
    for _, permission in ipairs(permissions) do
        bits = bit64.bor(bits, Constants.BitwisePermissionFlags[permission])
    end
    return bits
end