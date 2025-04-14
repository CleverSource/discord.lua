local snakize = require("../../util/camelCaseToSnake")

local RestTypes = require("../../types/internal/rest")

local methods = {
    edit = function<T>(self: T, options: RestTypes.ModifyChannelRequest, reason: string?): T
        local data = (self :: any)._client:editChannel((self :: any).id, options, reason)
        if data then
            (self :: any):update(snakize(data))
        end
        return self
    end,
    setName = function<T>(self: T, name: string, reason: string?): T
        return (self :: any):edit({ name = name }, reason)
    end,
    setParent = function<T>(self: T, parentId: string, options: {
        lockPermissions: boolean?,
        reason: string?
    }?): T
        return (self :: any):edit({
            parentId = parentId,
            lockPermissions = options and options.lockPermissions,
            reason = options and options.reason
        })
    end
}
export type Methods = typeof(methods)

return {
    mix = function(class)
        for methodName, method in methods do
            (class :: any)[methodName] = method
        end
    end
}