local OldNameCall = nil

OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Self, Key = ...
    local NamecallMethod = getnamecallmethod()
    if Self == game.Players.LocalPlayer and NamecallMethod == "Kick" then
        print("Attempted Kick")
        return
    end
    return OldNameCall(...)
end))