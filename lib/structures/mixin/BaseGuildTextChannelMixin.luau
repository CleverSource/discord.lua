local methods = {
    setDefaultAutoArchiveDuration = function<T>(self: T, duration: number, reason: string?): T
        return (self :: any):edit({ defaultAutoArchiveDuration = duration, reason = reason })
    end,
    setType = function<T>(self: T, type: number, reason: string?): T
        return (self :: any):edit({ type = type, reason = reason })
    end,
}
export type Methods = typeof(methods)

return {
    mix = function(class)
        for methodName, method in methods do
            (class :: any)[methodName] = method
        end
    end
}