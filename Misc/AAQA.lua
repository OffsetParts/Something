-- Ugh i stole i remade this from someone for detecting people related to roblox
-- In sort this will kick or notify (option) you when it detects when someone related to roblox staff and workers to avoid getting reported
if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or _G

_senv.kick = true -- kicks you when it finds an admin else just a nofication

local Players = game:GetService("Players")
local LP      = Players.LocalPlayer
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/saucekid/UI-Libraries/main/NotificationLib.lua"))()

function method(ID: number, identifier: string, name: string, type: string)
   if kick then
        if ID == 0 then
            LP:Kick(type .. " In your game, detected method: " .. identifier .. " | Username: " .. name)
        else
            LP:Kick(type .. " In your game: using " .. identifier .. " Method, User in question: " .. name)
        end
       ----------- KICK OFF ---------------------
    else
        if ID > 0 then
            Notification.WallNotification(type .. " In your game, detected method: " .. identifier .. " Method, Group ID: " .. tostring(ID) ", with Username: " .. name)
        else
            Notification.WallNotification(type .. " In your game: using " .. identifier .. " Method, User in question: " .. name)
        end
    end
end

local blGroups = {
    [1200769]  = { Tag = "Roblox Staff"},
    [3055661]  = { Tag = "QA Tester"},
    [14593111] = { Tag = "Avator Emotion Tester"},
    [12513722] = { Tag = "Bri'ish Person"},
    [10279336] = { Tag = "Sony Music Person"},
    [6821794]  = { Tag = "Graphics Tester"},
    [3253689]  = { Tag = "Member of the SML coalition"}
}

local function check(user)
    local Alias = user.Name
	local chara = user.Character or user.CharacterAdded:Wait()
    
    if user ~= LP then
        for id, t in pairs(blGroups) do
            if user:GetRankInGroup(id) > 0 then
                method(id, "Rank detection", Alias, t.Tag)
                return true
            end
        end

        for i, Int in next, chara:GetChildren() do
            if Int:IsA("Accessory") and (Int.Name == "Valiant Top Hat of Testing" or Int.Name == "Valiant Valkyrie of Testing" or Int.Name == "Thoroughly-Tested Hat of QA") then -- if qa tester hat then
                method(0, "Hat Detection", Alias, "QA TESTER")
                return true
            end
        end
    end
    return 
end

task.spawn(function()
    for i, plr in next, Players:GetPlayers() do
        task.wait()
        check(plr)
    end
end)

Players.PlayerAdded:Connect(function(plr)
    check(plr)
end)