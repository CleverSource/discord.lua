return function(bigNum): number
    -- HACK: BigNum doesn't support conversion of "small" 
    -- BigNum's to numbers so we have to convert it to a string first
    return tonumber(tostring(bigNum)) :: number
end