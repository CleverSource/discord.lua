
local function camelCaseToSnakeCase(str: string): string
    return str:gsub("(%u)", function(c: string): string 
        return "_" .. c:lower()
    end):gsub("^_", "")
end

local function snakize(body: { [string]: any }): { [string]: any }
    if typeof(body) ~= "table" then
        return body
    end
    
    local newBody = {}
    
    for key, value in body do
        local newKey = key
        
        if typeof(key) == "string" then
            newKey = camelCaseToSnakeCase(key)
        end
        
        if typeof(value) == "table" then
            newBody[newKey] = snakize(value)
        else
            newBody[newKey] = value
        end
    end

    return newBody
end

return snakize