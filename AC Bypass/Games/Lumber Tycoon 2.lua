-- Version Check
local Anticheat_Version = "38c8ecdd043ddac9078c5accdcf51ceca1eda9c33f696b175bb039a73478aa4506afbab775980dbe3400c6dd6a7048cd"

if getscripthash(game:GetService("Players").LocalPlayer.PlayerGui.LoadSaveGUI.LoadSaveClient.LocalScript) ~= Anticheat_Version then
    print("Anticheat Updated")
    return
end

-- BypassCounter
local Bypass_Count = 0

-- Remote Deletion Bypass
if game:GetService("ReplicatedStorage").Interaction:FindFirstChild("Ban") then
    for _, v in next, getconnections(game:GetService("ReplicatedStorage").Interaction.Ban.AncestryChanged) do
        if pcall(function()
            v:Disable()
        end) then
            Bypass_Count = Bypass_Count + 1
            print("Disabled AncestryChanged Connection On Ban Remote")
        end
    end
end

-- Destroy Ban Remote
if pcall(function()
    if Bypass_Count == 0 then return end -- prevent ban
    game:GetService("ReplicatedStorage").Interaction.Ban:Destroy()
end) then
    Bypass_Count = Bypass_Count + 1
    print("Destroyed Ban Remote")
end

local Anticheat_Env = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.LoadSaveGUI.LoadSaveClient.LocalScript)

-- Hook Ban Function
hookfunction(Anticheat_Env.ban, function(...)
    wait(9e9)
end)

print("Hooked Ban Function")

-- AntiKick / AntiLog
local __namecall
__namecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    if tostring(...) == 'AddLog' then
        wait(9e9)
    end
    if getnamecallmethod() == 'Kick' then
        wait(9e9)
    end
    if tostring(...) == 'Ban' then
        wait(9e9)
    end
    return __namecall(...)
end))

print("Namecall Hooked")

-- Finished
warn('Successfully Bypassed Anticheat')