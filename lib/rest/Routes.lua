return {
    gateway = function()
        return "/gateway"
    end,
    gatewayBot = function() 
        return "/gateway/bot"
    end,
    user = function(id)
        return "/users/" .. id
    end
}