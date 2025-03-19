-- Lovingly taken & modified. Original work by @North-dev-x
-- https://github.com/North-dev-x/ezobj
 
--!nocheck

-- CONFIG --
local config = {
    type_checking = true
}

------------

local ezobj = {}
ezobj.__index = ezobj

-- Helper function to determine table type
local function getTableType(t)
    if next(t) == nil then return "Abstract" end
    local isArray, isDictionary, isClassTable = true, true, true
    for k, _ in next, t do
        if type(k) == "number" and k % 1 == 0 and k > 0 then
            isDictionary = false
        elseif type(k) ~= "string" then
            isClassTable = false
        else
            isArray = false
        end
    end
    if isClassTable then return "ClassTable" end
    if isArray then return "Array" elseif isDictionary then return "Dictionary" else return "MixedTable" end
end

-- Deep freeze a table
function deepFreeze(tbl)
    for _, v in ipairs(tbl) do
        if type(v) == "table" and not table.isfrozen(v) then
            deepFreeze(v)
        end
    end
    return table.freeze(tbl)
end

-- Find the class defining a method
local function find_method_class(classtbl, method_name)
    local current = classtbl
    while current do
        if rawget(current, method_name) then
            return current
        end
        current = current.super
    end
    return nil
end

-- Type definitions
export type Object<T> = (T
    & {
        new: (T?) -> T;
        extend: <I>(T,I) -> InheritedObject<T & I, T>;
        type: () -> T;
    }) & (T?) -> T

export type InheritedObject<T,I> = (T
    & {
        new: (T?) -> T & {super: I};
        extend: <N>(T,N) -> InheritedObject2<T & N,T>;
        type: () -> T & {super: I};
        super: I;
    }) & (T? | any?) -> T & {super: I}

type InheritedObject2<T,I> = (T
    & {
        new: (T?) -> T & {super: I};
        extend: <N>(T,N) -> InheritedObject3<T & N,T>;
        type: () -> T & {super: I};
        super: I;
    }) & (T? | any?) -> T & {super: I}

type InheritedObject3<T,I> =( T 
    & {
        new: (T?) -> T & {super: I};
        extend: <N>(T,N) -> InheritedObject4<T & N,T>;
        type: () -> T & {super: I};
        super: I;
    }) & (T? | any?) -> T & {super: I}


type InheritedObject4<T,I> = (T 
    & {
        new: (T?) -> T & {super: I};
        extend: <N>(T,N) -> InheritedObject5<T & N,T>;
        type: () -> T & {super: I};
        super: I;
    }) & (T? | any?) -> T & {super: I}

type InheritedObject5<T,I> = (T 
    & {
        new: (T?) -> T & {super: I};
        extend: <N>(T,N) -> InheritedObject6<T & N,T>;
        type: () -> T & {super: I};
        super: I;
    }) & (T? | any?) -> T & {super: I}

type InheritedObject6<T,I> = (T 
    & {
        new: (T?) -> T & {super: I};
        extend: <N>(T,N) -> InheritedObject7<T & N,T>;
        type: () -> T & {super: I};
        super: I;
    }) & (T? | any?) -> T & {super: I}

type InheritedObject7<T,I> = (T 
    & {
        new: (T?) -> T & {super: I};
        extend: <N>(T,N) -> any; -- will not work with autocomplete and will no longer be type-safe
        type: () -> T & {super: I};
        super: I;
    }) & (T? | any?) -> T & {super: I}

-- Extend function to create a subclass
function ezobj.extend<I,T>(object: I, classtbl: T):
	InheritedObject<T,I>
	| InheritedObject2<T,I> 
	| InheritedObject3<T,I> 
	| InheritedObject4<T,I> 
	| InheritedObject5<T,I> 
	| InheritedObject6<T,I> 
	| InheritedObject7<T,I>

    if type(classtbl) ~= "table" then
        error("Expected table when reading class initializer, got " .. type(classtbl), 2)
    end
    local t = getTableType(object)
    if t ~= "ClassTable" and t ~= "Abstract" then
        error("Expected ClassTable {[string]: any} or Empty when initializing Object, got " .. t, 2)
    end
    for k, v in pairs(object) do
        if classtbl[k] == nil then
            classtbl[k] = v
        end
    end

    classtbl.new = function(...)
        local obj = {}
        setmetatable(obj, {
            __index = function(t, k)
                local method_class = find_method_class(classtbl, k)
                if method_class and type(method_class[k]) == "function" then
                    local original_method = method_class[k]
                    local super_class = method_class.super
                    local super_func = super_class and function(method_name, ...)
                        local args = {...}
                        local super_method_class = find_method_class(super_class, method_name)
                        if super_method_class then
                            local super_method = super_method_class[method_name]
                            local super_super_class = super_method_class.super
                            local super_super_func = super_super_class and function(sub_method_name, ...)
                                local super_super_method_class = find_method_class(super_super_class, sub_method_name)
                                if super_super_method_class then
                                    return super_super_method_class[sub_method_name](t, ...)
                                else
                                    error("Superclass method '" .. sub_method_name .. "' not found", 2)
                                end
                            end or nil
                            local old_super = t.super
                            t.super = super_super_func
                            local result = super_method(t, table.unpack(args))
                            t.super = old_super
                            return result
                        else
                            error("Superclass method '" .. method_name .. "' not found", 2)
                        end
                    end or nil
                    return function(self, ...)
                        local old_super = self.super
                        self.super = super_func
                        local result = original_method(self, ...)
                        self.super = old_super
                        return result
                    end
                else
                    return method_class and method_class[k]
                end
            end
        })
        if classtbl.constructor then
            local wrapped_constructor = obj.constructor -- Triggers __index to wrap the constructor
            wrapped_constructor(obj, ...)
            obj.constructor = nil
        else
            local tbl = select(1, ...)
            if tbl then
                for k, v in pairs(tbl) do
                    if config.type_checking and type(v) ~= type(classtbl[k]) and classtbl[k] ~= nil and type(v) ~= "nil" then
                        error("Type mismatch for key '" .. k .. "': expected " .. type(classtbl[k]) .. ", got " .. type(v))
                    end
                    rawset(obj, k, v)
                end
            end
        end
        return obj
    end

    classtbl.super = object
    classtbl.type = function() return classtbl end
    return deepFreeze(setmetatable(classtbl, {__index = ezobj, __call = classtbl.new}))
end

-- Base object creation
function ezobj:__call<T>(object: T): Object<T>
    if type(object) ~= "table" then
        error("Expected table when reading class initializer, got " .. type(object), 2)
    end
    local t = getTableType(object)
    if t ~= "ClassTable" and t ~= "Abstract" then
        error("Expected ClassTable {[string]: any} or Empty when initializing Object, got " .. t, 2)
    end

    object.new = function(tbl)
        local obj = {}
        if object.constructor then
            object.constructor(obj, tbl)
            obj.constructor = nil
        elseif tbl then
            for k, v in pairs(tbl) do
                if config.type_checking and type(v) ~= type(object[k]) and object[k] ~= nil and type(v) ~= "nil" then
                    error("Expected " .. type(object[k]) .. " when instantiating object key '" .. k .. "', got " .. type(v))
                end
                rawset(obj, k, v)
            end
        end
        return setmetatable(obj, {__index = object})
    end

    object.type = function() return object end
    return deepFreeze(setmetatable(object, {__index = ezobj, __call = object.new}))
end

return setmetatable({}, ezobj)