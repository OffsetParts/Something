-- Ugh i stole i remade this from someone for detecting people related to roblox
-- In sort this will kick or notify you when it detects when someone related to roblox staff and programs to avoid getting reported
if not game:IsLoaded() then game.Loaded:Wait() end

local kick = false

local Players 	   = game:GetService("Players")
local LP      	   = Players.LocalPlayer
local Notification = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/saucekid/UI-Libraries/main/NotificationLib.lua"))()

local function method(ID: number?, identifier: string, name: string, typ: string)
   if kick then
        if ID then
            LP:Kick(typ .. " in your game, detected method: " .. identifier .. " Method, Group ID: " .. tostring(ID) ", with Username: " .. name)
        else
            LP:Kick(typ .. " in your game: found by " .. identifier .. " Method, User in question: " .. name)
        end
    else
        if ID then
            Notification.WallNotification(typ .. " in your game, detected method: " .. identifier .. " Method, Group ID: " .. tostring(ID) ", with Username: " .. name)
        else
            Notification.WallNotification(typ .. " in your game: found by " .. identifier .. " Method, User in question: " .. name)
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

local function check(plr)
	local chara = plr.Character or plr.CharacterAdded:Wait()
    
    if plr ~= LP then
        for id, t in pairs(blGroups) do
            if plr:IsInGroup(id) then
                method(id, "Group detection", plr.Name, t.Tag)
            end
        end

        for i, Int in next, chara:GetChildren() do
			task.wait()
            if Int:IsA("Accessory") and (Int.Name == "Valiant Top Hat of Testing" or Int.Name == "Valiant Valkyrie of Testing" or Int.Name == "Thoroughly-Tested Hat of QA") then -- if qa tester hat then
                method(nil, "Instance Detection", plr.Name, "QA Tester")
            end
        end
    end
end

task.spawn(function()
    for i, plr in pairs(Players:GetPlayers()) do
        check(plr)
    end
end)

Players.PlayerAdded:Connect(function(plr)
    check(plr)
end)