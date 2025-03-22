local function snakeCaseToCamelCase(str: string): string
    return str:gsub("_(%l)", function(c: string): string
        return c:upper()
    end)
end

local function camelize(body: { [string]: any }): { [string]: any }
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