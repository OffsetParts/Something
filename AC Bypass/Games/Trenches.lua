-- by me
local Player = game:GetService("Players").LocalPlayer

local Main         = Player:WaitForChild("PlayerScripts"):WaitForChild("LocalMain")
local GravityCheck = require(Main:WaitForChild("Bindables"):WaitForChild("CharacterAdded"):WaitForChild("GravityCheck"))
local AntiExploit  = require(Main:WaitForChild("Bindables"):WaitForChild("CharacterAdded"):WaitForChild("AntiExploit"))
local KickPlayer   = require(Main:WaitForChild("GeneralFunctions"):WaitForChild("KickPlayer"))

-- Just gonna disable everything even though it resorts to kickplayer just incase
local OldAE OldAE = hookfunction(AntiExploit.Initiate, function(...)
    task.wait(9e9) -- Lol fuck no
end)

local OldKP OldKP = hookfunction(KickPlayer.Initiate, function(...)
    task.wait(9e9) -- Lol fuck no
end)

local OldKP OldKP = hookfunction(KickPlayer.Initiate, function(...)
    task.wait(9e9) -- Lol fuck no
end)