
local function camelCaseToSnakeCase(str: string): string
    return str:gsub("(%u)", function(c: string): string 
        return "_" .. c:lower()
    end):gsub("^_", "")
end

return camelCaseToSnakeCase