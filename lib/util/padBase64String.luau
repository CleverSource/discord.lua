return function(base64: string): string
    local base64Padding = "="
    
    if base64:find(base64Padding, 1, true) then
        return base64
    end

    local padding = (4 - (#base64 % 4)) % 4
    if padding == 3 then
        error("Provided base64 string is corrupt, it requires an invalid amount of padding")
    elseif padding == 0 then
        return base64
    end

    return `{base64}{base64Padding:rep(padding)}`
end