return function(snowflake: string): number
    return math.floor(tonumber(snowflake) :: number / 4194304) + 1420070400000
end