if not game:IsLoaded() then game.Loaded:Wait() end

-- TODO: Features - GUI in Main and Hub | Auto-roll, Bloodbag actually working, chance and userdata manipulation, etc.

local whitelist = {
    7127407851, -- Main
    7229033818, -- Hub/Lobby
    10421123948, -- Hub/Lobby - Pro
    9668084201, -- Hub/Lobby - Trading
    7942446389, -- Forest - PvE
    8061174649, -- Shiganshina - PvE
    8061174873, -- OutSkirts - PvE
    8365571520, -- Training Grounds - PvE
    8892853383, -- Utgard Castle - PvE
    8452934184, -- Hub - PvP
}

local wl
for _, c in next, whitelist do
    if c == game.PlaceId then wl = true end
end

if not wl then print'invaild gameID, ending script' return end
task.wait(5)

local _senv = getgenv() or _G

local CoreGui           = game:GetService("CoreGui")
local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP                = Players.LocalPlayer
local Assets            = ReplicatedStorage:WaitForChild("Assets")

local GPIDs             = LP:WaitForChild("Gamepasses")
local Modules           = Assets:WaitForChild("Modules")

local Titans -- Titans folder if in plasuible area

local Stuff = {}

Stuff.RE = nil
Stuff.RF = nil
-- Functions
function Stuff:Add (Index, obj, override: boolean)
    if not self[Index] and not override then
        if obj then
            self[Index] = obj;
        else
            return false;
        end
        return self[Index];
    else
        return self[Index];
    end
end

-- ESP 
local function create(Int: string, Nickname: string?, Parent: Instance?) -- <type>? can be <type> or nil
    local obj = Instance.new(Int)
    if Parent then
        obj.Parent = Parent
    end
    if Nickname then
        obj.Name = Nickname
    end
    return obj
end

local function MHL(FillC, OutLC, obj)
    if obj:FindFirstChildOfClass('Highlight') then
        obj:FindFirstChildOfClass('Highlight'):Destroy()
    end
    local Inst = create('Highlight', obj.Name, obj)

    Inst.Adornee = obj
    Inst.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Inst.FillColor = FillC
    Inst.FillTransparency  = 0.6499999761581421
    Inst.OutlineColor = OutLC
    Inst.OutlineTransparency = 0

    Inst.Adornee.Changed:Connect(function()
        if not Inst.Adornee or not Inst.Adornee.Parent then
            Inst:Destroy()
        end
    end)

    return Inst
end

if game.PlaceId == whitelist[1] then
    -- for main menu storing W.I.P.
end

for i = 2, 3, 1 do
    if game.PlaceId == whitelist[i] then
        -- for hub storing
    end
end

for i = 1, 3, 1 do
    if game.PlaceId == whitelist[i] then -- doesn't work for some reason in PvE it so weird.
        for i, v in pairs(getloadedmodules()) do
            if v.Name == 'Host' and require(v).New() then
                local modu = require(v)
                local values = modu.New()

                local shadowID = 42787763 -- pick an ID of an gamepass you have.
                for x, w in next, GPIDs:GetChildren() do
                    w.Value = true
                end

                for _, c in next, values.Gamepass_IDs do
                    c = shadowID
                end
                
                local oldGPs oldGPs = hookfunction(modu.Owns_Gamepass, function(...) -- bloodline bag visual(don't store, will not work) and skip roll for now.
                    return true
                end)

                local oldSecurity oldSecurity = hookfunction(modu.Security, function(...) -- stop remotes from changing their names
                    wait(9e9)
                    return
                end)
                
                if game.PlaceId ~= whitelist[1] then
                    local oldOPS oldOPS = hookfunction(modu.Owns_Perk, function(...) -- supposed to grant all perks, and third slot access but it doesn't work.
                        return true
                    end)
                end
            end
        end
    end
end
task.wait(1)

if game.PlaceId ~= whitelist[1] and game.PlaceId ~= whitelist[2] and game.PlaceId ~= whitelist[3] and game.PlaceId ~= whitelist[4] then -- any PvE area
    Titans = Workspace:WaitForChild("Titans")
    local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
    local Orion        = CoreGui:FindFirstChild("Orion")
    local Flags        = OrionLib.Flags

    local MainWindow   = OrionLib:MakeWindow({Name = "Apeirophobia GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "./Scrumpy/Attack on Titan - Evo"})

    local Main         = MainWindow:MakeTab({Name = ' Main ', Icon = "rbxassetid://4483345998", premiumOnly = false})
    local Function     = Main:AddSection({Name = ' Functions '})
    local Keybinds     = Main:AddSection({Name = ' Keybinds '})
    local Funny        = Main:AddSection({Name = ' Funny '})

    if Flags.SlientMode then Orion.Enabled = false end -- toggle get inverted on the flags for some reason.

    local AN = Function:AddToggle({
        Name = "Always Nape",
        Description = "Always Nape + Max DMG",
        Default = false,
        Callback = function(bool)
            return
        end,
        Flag = "AlwaysNape",
        Save = true,
    })

    local FG = Function:AddToggle({
        Name = "Full Gas",
        Description = "significantly decrease gas intake",
        Default = false,
        Callback = function(bool)
            return
        end,
        Flag = "FullGas",
        Save = true
    })

    Function:AddToggle({
        Name = "Titan ESP",
        Default = false,
        Callback = function(bool)
            while Flags.TitanESP do
                task.wait(5)
                for i2, v2 in pairs(Titans:GetChildren()) do
                    local HL = MHL(Color3.fromRGB(200, 90, 255), Color3.fromRGB(255, 119, 215), v2)
                end
            end
        end,
        Flag = "TitanESP",
        Save = true
    })

    Function:AddToggle({
        Name = "Slient Mode",
        Description = "To not show orion GUI on launch, use control GUI keybind to open",
        Default = false,
        Callback = function(bool)
            
        end,
        Flag = "SlientMode",
        Save = true
    })

    Keybinds:AddBind({
        Name = "Control Gui",
        Default = Enum.KeyCode.RightShift,
        Hold = false,
        Callback = function() Orion.Enabled = not Orion.Enabled end,
        Flag = "GUI",
        Save = true,
    })

    Keybinds:AddBind({
        Name = "Always Nape Keybind",
        Default = Enum.KeyCode.G,
        Hold = false,
        Callback = function() AN:Set(not Flags.AlwaysNape) end,
        Flag = "ANK",
        Save = true,
    })

    Keybinds:AddBind({
        Name = "Full Gas Keybind",
        Default = Enum.KeyCode.Y,
        Hold = false,
        Callback = function() FG:Set(not Flags.FullGas) end,
        Flag = "FGK",
        Save = true,
    })

    Funny:AddButton({
        Name = "Break titan animations",
        Callback = function()
            for i, v in pairs(Titans:GetChildren()) do
                local Hum = v:WaitForChild("HumanoidRootPart")
                if Hum then
                    Hum:WaitForChild("Animator"):Destroy()
                end
                task.wait()
            end
        end,
    })

    Funny:AddParagraph("Side Note", "Makes them seem frozen, and flop around. Titans actually body is serverside, so this is not recommended. Also, Slient Mode will shown to be false, after the first run. Don't mind it for now its a bug.")

    OrionLib:Init()

    local OldNameCall OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
        local args = {...}
        local method = getnamecallmethod()
        local caller = getcallingscript()
        if method == "InvokeServer" and args[1] == "Slash" and Flags.AlwaysNape then
            print(caller)
            args[3] = "Nape"
            args[4] = 12500
            if not Stuff.RF then Stuff.RF = Self end
            return OldNameCall(Self, unpack(args))
        end
        if method == "FireServer" and args[2] == "Gas" and Flags.FullGas then
            print(caller)
            args[3] = 1
            if not Stuff.RE then Stuff.RE = Self end
            return OldNameCall(Self, unpack(args))
        end
        return OldNameCall(Self, ...)
    end))
end