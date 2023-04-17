-- TODO: revive bypass
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage") 

-- Variables
local Player  = Players.LocalPlayer
local gameData = ReplicatedStorage:WaitForChild('GameData')
local EI = ReplicatedStorage:WaitForChild('EntityInfo')

local Char = Player.Character or Player.CharacterAdded:Wait()
local plrScripts = Player.PlayerScripts
local plrGui = Player.PlayerGui

local HumanoidRootPart = Char:WaitForChild('HumanoidRootPart')
local Hum = Char:WaitForChild('Humanoid')

-- Remotes
local Screehie = EI:WaitForChild('Screech')

-- GUI
local MainUI = plrGui:WaitForChild('MainUI')

--- Modules
local Modules = MainUI:WaitForChild('Modules')

-- Scripts
local MG = MainUI:WaitForChild('Initiator'):WaitForChild('Main_Game')
local RL = MG:WaitForChild('RemoteListener')

local Attributes = {
    SB = 'SpeedBoost',
    SBE = 'SpeedBoostExtra',
    SBB = 'SpeedBoostBehind'
}

local function changeAttribute(obj, attribute, value)
    obj:SetAttribute(attribute, value)
end

-- changeAttribute(Hum, Attributes.SB, 0)

warn('suckie wackie')