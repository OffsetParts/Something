local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...) 
    if getnamecallmethod() == "Kick" then 
        return wait(9e8)
    end

    return Old(Self, ...)
end)
