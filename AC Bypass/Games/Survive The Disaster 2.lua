-- Owner is a furry so all action here is justified
local Players = game:GetService("Players")
local Player  = Players.LocalPlayer
local PS      = Player:WaitForChild("PlayerScripts")

local BadScripts = {} -- Go to hell Anti-Exploits

-- BadScripts["..."] = PS["..."] | Don't Disable this one it has connection check
BadScripts["AntiGhosting"] = PS["AntiGhosting"]
BadScripts["AntiFreeze"] = PS["AntiFreeze"]

for i, v in pairs(BadScripts) do
    if v then v.Disabled = true end
end

if game.CreatorType == Enum.CreatorType.User then
    Player.Name = "VyrissDev" -- Dumbass built a bypass for theirself by their name not even ID (AntiFreeze)
end

local OldNameCall OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" and Self.Name == "Detect" then
        args[1] = 50
        args[2] = 100
        args[3] = 16
        return OldNameCall(Self, unpack(args))
    end
    if method == "FireServer" and Self.Name == "GetServerPos" then
        args[1] = Vector3.new(0,0,0)
    end
    return OldNameCall(Self, ...)
end))