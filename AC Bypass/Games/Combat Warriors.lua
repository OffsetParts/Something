if not game:IsLoaded() then game.Loaded:Wait() end

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables --
local Nevermore = require(ReplicatedStorage.Framework:WaitForChild("Nevermore"))
local Lookup = rawget(Nevermore, "_lookupTable") -- stores the modules

getgenv().Mods = Mods or {} -- Modules

Lookup = {
	["FireClient"] = <Module>
}

-- Functions --
local function Notify(func, msg)
	func("CW:", tostring(msg))
end

local function isNotStored(Module, Name)
	if not Mods[Name] then
		Mods[Name] = Module
		return true
	end
	return
end

local function GetModule(Name)
	local Module = Lookup[Name]
	if Module then Module.Name = Name
		if isNotStored(Module, Name) then
			return require(Module)
		elseif Mods[Name] then
			return require(Mods[Name])
		end
	end
end

local function unpatch(name, data) -- method by Task
	if data.Remote and data.Remote:GetPropertyChangedSignal("Name") then
        for i, v in pairs(getconnections(data.Remote:GetPropertyChangedSignal("Name"))) do
            v:Disable()
        end
	end
end

task.spawn(function()
    for _, c in pairs(Lookup) do -- index modules
        GetModule(_) task.wait()
    end
end)

local Network = GetModule("Network")
local NetworkEnv = getsenv(Mods["Network"])

local Anticheat = GetModule("AntiCheatHandler")

if Network then
	table.foreach(debug.getupvalue(NetworkEnv.GetEventHandler, 1), unpatch)
	table.foreach(debug.getupvalue(NetworkEnv.GetFunctionHandler, 1), unpatch)
end

if Anticheat then
	local kickQueue = {}
	hookfunction(Anticheat["punish"], newcclosure(function(Player, Info, Callback)
		if Info.shouldCreateNotification then
			Callback({
				punishType = Info.punishType,
				reason = Info.reason .. "\n Bypassed",
			})
		end
		local Character = Player.Character
		local function punishKick()
			Notify(warn, "game initiated kick")
		end
		local func = {
			kill = function()
				local Humanoid = Character:FindFirstChild("Humanoid")
				if Humanoid then
					-- Humanoid:ChangeState(Enum.HumanoidStateType.Dead) | How about not doing that?
					Notify(print, "hate the game, not the player :)")
				end
			end,
			randomDelayKick = function()
				punishKick()
			end,
			kick = punishKick(),
			logKick = function()
				punishKick()
			end
		}
		local success, err = pcall(function() -- Line: 133
			if func[Info.punishType] then
				func[Info.punishType]()
				return true
			end
			Notify(warn, "No punishment handler found for " .. Info.punishType)
		end)
		if not success then
			warn(err)
		end
	end))

	hookfunction(Anticheat["getIsBodyMoverCreatedByGame"], function(BodyMover)
		if BodyMover then
			return true
		end
	end)
end