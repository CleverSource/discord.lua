return function(str: string): string
    return str:gsub("%u", function(c: string)
        return "_" .. c:lower()
    end):gsub("^_", "")
end