local function snakeCaseToCamelCase(str)
    return str:gsub("_(%l)", function(c)
        return c:upper()
    end)
end

local function camelize(body)
    local newBody = {}
    
    for key, value in body do
        local newKey = key
        
        if typeof(key) == "string" then
            newKey = snakeCaseToCamelCase(key)
        end
        
        if typeof(value) == "table" then
            newBody[newKey] = camelize(value)
        else
            newBody[newKey] = value
        end
    end

    return newBody
end

return camelize