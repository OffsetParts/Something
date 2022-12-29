-- POS game
if not game:IsLoaded() then game.Loaded:Wait() end

local _genv = getgenv() or _G

-- < Services > --
if not _genv.Services then
    _genv.Services = setmetatable({}, {
        __index = function(Self, Index)
            local NewService = game:GetService(Index)
            if NewService then
                Self[Index] = NewService
            end
            return NewService
        end
    })
end

local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local RunService = Services.RunService

local Events = ReplicatedStorage.Events
local Player = Players.LocalPlayer

local CCDisabled 

-- Remotes
local CC = Events:FindFirstChild("CC")
local Died = Events:FindFirstChild("Died") Died:Destroy()

local PlayerScripts = Player.PlayerScripts
local Character = Player.Character or Player.CharacterAdded:Wait()

local AdMonitor = PlayerScripts:WaitForChild("ClientModules").AdMonitor
local ClientS   = Character:WaitForChild("Client")

local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(...)
    local Self, Key = ...
    local method = getnamecallmethod()
    local callingscript = getcallingscript()

    if not checkcaller() then
        -- print(method)
        if Self == Player and method:lower() == "kick" then
            -- print('game tried to', method)
            return
        end
    end
    return OldNameCall(...)
end)

if CC then 
    task.spawn(function() 
        for i, v in pairs(getconnections(CC.AncestryChanged)) do 
            if pcall(function() v:Disable(v) end) then
                CCDisabled = true 
            end
        end
        CC:Destroy()
    end)
end