return function(reaction: string): string
    if reaction:sub(1, 2) == "<:" then
        reaction = reaction:sub(3, reaction:len() - 1)
    end
    
    if reaction:sub(1, 3) == "<a:" then
        reaction = reaction:sub(4, reaction:len() - 1)
    end

    return reaction
end