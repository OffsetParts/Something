if not game:IsLoaded() then game.Loaded:Wait() end

-- TODO: Features - GUI in Main and Hub | Auto-roll, Bloodbag actually working, chance and userdata manipulation, etc.

local whitelist = {
    7127407851,  -- Main
    7229033818,  -- Hub
    10421123948, -- Hub - Pro
    9668084201,  -- Hub - Trading
    7942446389,  -- Forest - PvE
    8061174649,  -- Shiganshina - PvE
    8061174873,  -- OutSkirts - PvE
    8365571520,  -- Training Grounds - PvE
    8892853383,  -- Utgard Castle - PvE
    -- 8452934184,  -- Hub - PvP
}

local wl
for _, c in next, whitelist do
    if c == game.PlaceId then wl = true end
end

if not wl then return end

local _senv = getgenv() or _G

local CoreGui               = game:GetService("CoreGui")
local Players               = game:GetService("Players")
local Workspace             = game:GetService("Workspace")
local RunService            = game:GetService("RunService")
local ReplicatedStorage     = game:GetService("ReplicatedStorage")
local PathfindingService    = game:GetService("PathfindingService")
local VirtualInputManager   = game:GetService('VirtualInputManager')
local TweenService          = game:GetService('TweenService')
local virtualUser           = game:GetService('VirtualUser')
local TeleportService       = game:GetService("TeleportService")

local LP                = Players.LocalPlayer
local Assets            = ReplicatedStorage:WaitForChild("Assets")

local GPIDs             = LP:WaitForChild("Gamepasses")
local Modules           = Assets:WaitForChild("Modules")
local Events            = Assets:WaitForChild("Remotes")

local RE                = Events:FindFirstChildOfClass("RemoteEvent") -- Join, Refill, Leave, etc.
local RF                = Events:FindFirstChildOfClass("RemoteFunction") -- Attack, etc.

local Stuff = {}
-- Functions
function Stuff:Add (Index, obj, override: boolean)
    if not self[Index] then
        if obj then
            self[Index] = obj;
        else
            return;
        end
        return self[Index];
    elseif self[Index] and override then
        if obj then
            self[Index] = obj;
        else
            return;
        end
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
    if not obj:FindFirstChildOfClass('Highlight') then
        local Inst = create('Highlight', obj.Name, obj)

        Inst.Adornee = obj
        Inst.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Inst.FillColor = FillC
        Inst.FillTransparency  = 0.65
        Inst.OutlineColor = OutLC
        Inst.OutlineTransparency = 0

        Inst.Adornee.Changed:Connect(function()
            if (not Inst.Adornee or not Inst.Adornee.Parent) then
                Inst:Destroy()
            end
        end)
    end
end

for x, w in next, GPIDs:GetChildren() do
    w.Value = true
end

local HostM

for i, v in pairs(getloadedmodules()) do
    if v.Name == 'Host' and v.Parent == nil then
        print'found Module'

        HostM = require(v)
        
        local oldCheck -- logs stuff(Animations, Errors, Events, Data?, etc.) -- don't know if this is sent to the server
        local oldGPs -- verifies gamepasses
        local oldSecurity -- create fraud and spoof remotes
        local oldOPS -- verifies perks
        local oldFamily -- verifies family
        local oldGM -- Gear Multiplier
        local oldKick -- Kick plr
        local oldGU -- Gear Upgrades
        local oldPhysics -- calculates physics, and movement anticheat
        local oldCustomization -- customizes the player and its interface

        oldCheck = hookfunction(HostM.Check, function(Success, Error)
            -- if Error then warn(Error) end
            return 
        end)

        oldGPs = hookfunction(HostM.Owns_Gamepass, function(Player, ID, Type, Prompt)
            return true
        end)

        oldSecurity = hookfunction(HostM.Security, function(POST)
            return
        end)

        if game.PlaceId == whitelist[i] then
            oldCustomization = hookfunction(HostM.Customization, function(Player, POST, GET, Interface, Customisation, Data)
                local Success, Error = pcall(function()
                    local Whitelist, Prefix, Devices, Services, Client_Assets, Enums, Settings, Product_IDs = HostM.Whitelist, HostM.Prefix, HostM.Devices, HostM.Services, HostM.Client_Assets, HostM.Enums, HostM.Settings, HostM.Product_IDs
                    
                    local Button_1, Movement, Touch = Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch
                    
                    local Time, Delay = .2, 1
                    
                    local Objects = {
                        [1] = { Name = "Logo"; Class = "ImageLabel"; Properties = { ImageTransparency = 0 } };
                        [2] = { Name = "Play"; Class = "ImageButton"; Properties = { ImageTransparency = 0 } };
                        [3] = { Name = "Friends"; Class = "ImageButton"; Properties = { ImageTransparency = 0 } };
                        [4] = { Name = "Hub"; Class = "ImageButton"; Properties = { ImageTransparency = 0 } };
                        [5] = { Name = "Customise"; Class = "ImageButton"; Properties = { ImageTransparency = 0 } };
                        [6] = { Name = "Settings"; Class = "ImageButton"; Properties = { ImageTransparency = 0 } };
                        [7] = { Name = "VIP"; Class = "ImageButton"; Properties = { ImageTransparency = 0 } };
                        [8] = { Name = "Title"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                    }
                    
                    local Customisation_Objects = {
                        [1] = { Name = "Left"; Class = "Frame"; Properties = { BackgroundTransparency = 0 } };
                        [2] = { Name = "Right"; Class = "Frame"; Properties = { BackgroundTransparency = 0 } };
                        [3] = { Name = "LArrow"; Class = "TextButton"; Properties = { TextTransparency = 0 } };
                        [4] = { Name = "RArrow"; Class = "TextButton"; Properties = { TextTransparency = 0 } };
                        [5] = { Name = "Finish"; Class = "TextButton"; Properties = { BackgroundTransparency = 0 } };
                        [6] = { Name = "Title"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [7] = { Name = "Line"; Class = "Frame"; Properties = { BackgroundTransparency = 0 } };
                        [8] = { Name = "Primary"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [9] = { Name = "Secondary"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [10] = { Name = "Eyes"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [11] = { Name = "Mouth"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [12] = { Name = "Height"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [13] = { Name = "Width"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [14] = { Name = "Skin"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [15] = { Name = "Shirt"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [16] = { Name = "Pants"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [17] = { Name = "Shoes"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [18] = { Name = "Interact"; Class = "TextButton"; Properties = { TextTransparency = 0 } };
                        [19] = { Name = "Left"; Class = "TextButton"; Properties = { TextTransparency = 0; BackgroundTransparency = 0 } };
                        [20] = { Name = "Right"; Class = "TextButton"; Properties = { TextTransparency = 0; BackgroundTransparency = 0 } };
                        [21] = { Name = "Accessory_1"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [22] = { Name = "Accessory_2"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [23] = { Name = "Accessory_3"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [24] = { Name = "Identifier"; Class = "Frame"; Properties = { BackgroundTransparency = 0 } };
                        [25] = { Name = "Box"; Class = "TextBox"; Properties = { TextTransparency = 0 } };
                        [26] = { Name = "Title"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [27] = { Name = "Family"; Class = "Frame"; Properties = { BackgroundTransparency = 0 } };
                        [28] = { Name = "Buy"; Class = "TextButton"; Properties = { BackgroundTransparency = 0; TextTransparency = 0 } };
                        [29] = { Name = "Roll"; Class = "TextButton"; Properties = { BackgroundTransparency = 0; TextTransparency = 0 } };
                        [30] = { Name = "Selected"; Class = "TextLabel"; Properties = { TextStrokeTransparency = 0; TextTransparency = 0 } };
                        [31] = { Name = "Spins"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [32] = { Name = "Families"; Class = "ScrollingFrame"; Properties = { ScrollBarImageTransparency = 0 } };
                        [33] = { Name = "Join"; Class = "TextButton"; Properties = { BackgroundTransparency = 0 } };
                        [34] = { Name = "Interact"; Class = "TextBox"; Properties = { TextTransparency = 0 } };
                        [35] = { Name = "Real"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [36] = { Name = "Pity_1"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [37] = { Name = "Pity_2"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                        [38] = { Name = "Custom"; Class = "TextButton"; Properties = { BackgroundTransparency = 0 } };
                        [39] = { Name = "Store"; Class = "TextButton"; Properties = { BackgroundTransparency = 0; TextTransparency = 0 } }
                    }
                    
                    if (Player ~= nil and POST ~= nil and GET ~= nil and Interface ~= nil and Customisation ~= nil and Data ~= nil and Whitelist ~= nil and Prefix ~= nil and Devices ~= nil and Services ~= nil and Client_Assets ~= nil and Enums ~= nil and Settings ~= nil and Product_IDs ~= nil and Button_1 ~= nil and Movement ~= nil and Touch ~= nil) then
                        local ID = Player.UserId
                        
                        local Families = HostM:Module("Families")
                        
                        local Title_Screen = Interface:WaitForChild("Title Screen")
                        
                        local Left, Right = Customisation:WaitForChild("Left"), Customisation:WaitForChild("Right")
                        local LArrow, RArrow = Customisation:WaitForChild("LArrow"), Customisation:WaitForChild("RArrow")
                        local Finish, Spins = Customisation:WaitForChild("Finish"), Customisation:WaitForChild("Spins")
                        local Join = Customisation:WaitForChild("Join")
                        local Notification = Customisation:WaitForChild("Notification")
                        
                        local Console = Devices.Console
                        
                        local UIS, RS, TS, TP, GS, MS, W = Services.UIS, Services.RS, Services.TS, Services.TP, Services.GS, Services.MS, Services.W
                        
                        local Assets = Client_Assets:WaitForChild("Customisation")
                        
                        local Style, In, Out = Enums.Style, Enums.In, Enums.Out
                        
                        local Selected = nil
                        
                        local Holding, Moving = false, false
                        
                        local Left_Arrow_Hold, Right_Arrow_Hold = false, false
                        
                        local Spinning = false
                        
                        local New_Position = nil
                        
                        local Saved, Pressed_Saved = false, false
                        
                        local Queued = false
                        
                        local Finished_Customising = false
                        
                        if (ID ~= nil and Families ~= nil and Title_Screen ~= nil and Left ~= nil and Right ~= nil and LArrow ~= nil and RArrow ~= nil and Finish ~= nil and Join ~= nil and Notification ~= nil and Console ~= nil and Spins ~= nil and UIS ~= nil and RS ~= nil and TS ~= nil and TP ~= nil and GS ~= nil and MS ~= nil and W ~= nil and Assets ~= nil and Style ~= nil and In ~= nil and Out ~= nil) then
                            local Wheel, Saturation, Colour, Set = Left:WaitForChild("Wheel"), Left:WaitForChild("Saturation"), Left:WaitForChild("Colour"), Left:WaitForChild("Set")
                            local Identifier, Family, __Families = Right:WaitForChild("Identifier"), Right:WaitForChild("Family"), Right:WaitForChild("Families")
                            local Pity_1, Pity_2 = Family:WaitForChild("Pity_1"), Family:WaitForChild("Pity_2")
                            local Deal = Spins:FindFirstChild("Deal", true)
                            local Join_Interact = Join:WaitForChild("Interact")
                            local Decline, Accept, Title__ = Notification:WaitForChild("Decline"), Notification:WaitForChild("Accept"), Notification:WaitForChild("Title__")
                            local Custom = Right:WaitForChild("Custom")
                            
                            local VIP = Title_Screen:WaitForChild("VIP")
                            
                            local Camera, Map = W.CurrentCamera, W:WaitForChild("Map")
                            
                            local Tween_Info_1 = TweenInfo.new(Time, Style, In)
                            local Tween_Info_2 = TweenInfo.new(Time, Style, Out)
                            
                            if (Wheel ~= nil and Saturation ~= nil and Colour ~= nil and Identifier ~= nil and Family ~= nil and __Families ~= nil and Pity_1 ~= nil and Pity_2 ~= nil and Deal ~= nil and Join_Interact ~= nil and Decline ~= nil and Accept ~= nil and Title__ ~= nil and VIP ~= nil and Camera ~= nil and Map ~= nil and Tween_Info_1 ~= nil and Tween_Info_2 ~= nil) then
                                local Picker, Slider, Gradient = Wheel:WaitForChild("Picker"), Saturation:WaitForChild("Slider"), Saturation:WaitForChild("Gradient")
                                local Box = Identifier:WaitForChild("Box")
                                local Buttons = Family:WaitForChild("Buttons")
                                local Buy, Roll, Selected_Family, __Spins = Buttons:WaitForChild("Buy"), Buttons:WaitForChild("Roll"), Family:WaitForChild("Selected"), Family:WaitForChild("Spins")
                                local Store = Buttons:WaitForChild("Store")
                                
                                local Code = VIP:WaitForChild("Details"):WaitForChild("Generate"):WaitForChild("Code")
                                
                                local Main = Map:WaitForChild("Main")
                                
                                if (Picker ~= nil and Slider ~= nil and Gradient ~= nil and Box ~= nil and Buy ~= nil and Roll ~= nil and Selected_Family ~= nil and __Spins ~= nil and Code ~= nil and Main ~= nil) then
                                    local Character = Main:WaitForChild("Character")
                                    
                                    if (Character ~= nil) then
                                        local Humanoid, HumanoidRootPart = Character:WaitForChild("Humanoid"), Character:WaitForChild("HumanoidRootPart")
                                        
                                        HostM:Animations(Humanoid)
                                        
                                        if (Humanoid ~= nil and HumanoidRootPart ~= nil) then
                                            local Temporary_Data = {}
                                            
                                            for Index, Value in pairs(Data) do
                                                if (Index ~= "Spins") then
                                                    Temporary_Data[Index] = Value
                                                end
                                            end
                                            
                                            local Indexes = {}
                                            
                                            local function Update_Indexes()
                                                for Category, Data in pairs(Indexes) do
                                                    local Label = Customisation:FindFirstChild(Category, true)
                                                    
                                                    local Base = (((Category == "Primary" or Category == "Secondary") and tostring(Category .. " Hair")) or Category)
                                                    
                                                    local Name = Data.Name
                                                    
                                                    if (Label ~= nil and Base ~= nil and Name ~= nil) then
                                                        local Number = tonumber(Name)
                                                        
                                                        if (Number ~= nil) then
                                                            if (string.len(Name) < 2 and Number < 10) then
                                                                Name = tostring("0" .. Name)
                                                            end
                                                            
                                                            local Text = Label:GetAttribute("Text")
                                                            
                                                            if (Text == nil) then
                                                                Label.Text = tostring(Base .. ": <" .. Name .. ">")
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Update_Colour(Center)
                                                local Hairs = Temporary_Data.Hairs
                                                
                                                if (((Selected == "Primary" or Selected == "Secondary") or New_Position ~= nil) and Hairs ~= nil) then
                                                    local Index = (((Selected == "Primary" or New_Position ~= nil) and 1) or (Selected == "Secondary" and 2))
                                                    
                                                    local Absolute_Size_1, Absolute_Position_1 = Picker.AbsoluteSize, Picker.AbsolutePosition
                                                    local Absolute_Size_2, Absolute_Position_2 = Saturation.AbsoluteSize, Saturation.AbsolutePosition
                                                    local Absolute_Position_3 = Slider.AbsolutePosition
                                                    
                                                    if (Index ~= nil and Absolute_Size_1 ~= nil and Absolute_Position_1 ~= nil and Absolute_Size_2 ~= nil and Absolute_Position_2 ~= nil and Absolute_Position_3 ~= nil) then
                                                        local X, Y = (Absolute_Position_1.X + (Absolute_Size_1.X / 2)), (Absolute_Position_1.Y + (Absolute_Size_1.Y / 2))
                                                        
                                                        if (X ~= nil and Y ~= nil) then
                                                            local Picker_Center = Vector2.new(X, Y)
                                                            
                                                            local X, Y = (Picker_Center.X - Center.X), (Picker_Center.Y - Center.Y)
                                                            
                                                            if (X ~= nil and Y ~= nil) then
                                                                local H = ((math.pi - math.atan2(Y, X)) / (math.pi * 2))
                                                                local S = ((Center - Picker_Center).Magnitude / (Wheel.AbsoluteSize.X / 2))
                                                                local V = math.abs((Absolute_Position_3.Y - Absolute_Position_2.Y) / Absolute_Size_2.Y - 1)
                                                                
                                                                H, S, V = math.clamp(H, 0, 1), math.clamp(S, 0, 1), math.clamp(V, 0, 1)
                                                                
                                                                if (H ~= nil and S ~= nil and V ~= nil) then
                                                                    local HSV = Color3.fromHSV(H, S, V)
                                                                    
                                                                    if (HSV ~= nil) then
                                                                        Colour.ImageColor3 = HSV
                                                                        
                                                                        Gradient.Color = ColorSequence.new {
                                                                            ColorSequenceKeypoint.new(0, HSV), 
                                                                            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
                                                                        }
                                                                        
                                                                        local Colour = Colour.ImageColor3
                                                                        
                                                                        if (Colour ~= nil) then
                                                                            local R, G, B = Colour.R, Colour.G, Colour.B
                                                                            
                                                                            if (R ~= nil and G ~= nil and B ~= nil) then
                                                                                Slider.ImageColor3 = Color3.fromRGB(((1 - R) * 255), ((1 - G) * 255), ((1 - B) * 255))
                                                                                
                                                                                local H, S, V = Color3.new(R, G, B):ToHSV()
                                                                                
                                                                                if (H ~= nil and S ~= nil and V ~= nil) then
                                                                                    local HSV = Color3.fromHSV(H, S, V)
                                                                                    
                                                                                    if (HSV ~= nil) then
                                                                                        local function Update(Index)
                                                                                            if (Index ~= nil) then
                                                                                                local Hair_Data = Hairs[Index]
                                                                                                
                                                                                                if (Hair_Data ~= nil) then
                                                                                                    local Hair = Character:FindFirstChild("Hair - " .. Index)
                                                                                                    
                                                                                                    if (New_Position ~= nil and Hair ~= nil and Hair:IsA("Accessory") == true) then
                                                                                                        for _, Object in pairs(Hair:GetChildren()) do
                                                                                                            if ((Object.Name ~= "Bow" and Object.Name ~= "Fringe" and Object.Name ~= "Clip") and Object.Color ~= HSV) then
                                                                                                                Hair_Data.R, Hair_Data.G, Hair_Data.B, Hair_Data.Changed = H, S, V, true
                                                                                                            end
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                        
                                                                                        Update(Index)
                                                                                        
                                                                                        if (New_Position ~= nil) then
                                                                                            Update(2)
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Colour_Movement(Input)
                                                if (((Selected == "Primary" or Selected == "Secondary") and Input ~= nil) or New_Position ~= nil) then
                                                    local Location = UIS:GetMouseLocation()
                                                    
                                                    local Inset = GS:GetGuiInset()
                                                    
                                                    local Absolute_Size_1, Absolute_Position_1 = Wheel.AbsoluteSize, Wheel.AbsolutePosition
                                                    local Absolute_Size_2, Absolute_Position_2 = Saturation.AbsoluteSize, Saturation.AbsolutePosition
                                                    
                                                    if (Location ~= nil and Inset ~= nil and Absolute_Size_1 and Absolute_Position_1 ~= nil and Absolute_Size_2 ~= nil and Absolute_Position_2 ~= nil) then
                                                        local Type = ((Input == nil and nil) or (Input ~= nil and Input.UserInputType))
                                                        
                                                        local Y = Inset.Y
                                                        
                                                        if (((Type ~= nil and Type == Movement or Type == Touch) or New_Position ~= nil) and Y ~= nil) then
                                                            local Position = (New_Position == nil and (Location - Vector2.new(0, Y)) or (New_Position ~= nil and New_Position))
                                                            
                                                            local X, Y = (Absolute_Position_1.X + (Absolute_Size_1.X / 2)), (Absolute_Position_1.Y + (Absolute_Size_1.Y / 2))
                                                            
                                                            if (Position ~= nil and X ~= nil and Y ~= nil) then
                                                                local Center = Vector2.new(X, Y)
                                                                
                                                                if (Center ~= nil) then
                                                                    local Distance = (Position - Center).Magnitude
                                                                    
                                                                    if (Distance ~= nil) then
                                                                        if (Distance <= (Absolute_Size_1.X / 2) and (Holding == true or New_Position ~= nil)) then
                                                                            local X, Y = (Position.X - Absolute_Position_1.X), (Position.Y - Absolute_Position_1.Y)
                                                                            
                                                                            if (X ~= nil and Y ~= nil) then
                                                                                Picker.Position = UDim2.new(0, X, 0, Y)
                                                                            end
                                                                            
                                                                        elseif (Moving == true) then
                                                                            local Y = math.clamp((Position.Y - Absolute_Position_2.Y), 0, Absolute_Size_2.Y)
                                                                            
                                                                            Slider.Position = UDim2.new(Slider.Position.X.Scale, 0, 0, Y)
                                                                        end
                                                                        
                                                                        Update_Colour(Center, New_Position)
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Get_Indexed_Item(Items, Index)
                                                local Item = nil
                                                
                                                if (Items ~= nil and Index ~= nil) then
                                                    local Items_Array = Items:GetChildren()
                                                    
                                                    if (Items_Array ~= nil) then
                                                        table.sort(Items_Array, function(A, B)
                                                            return (tonumber(A.Name) < tonumber(B.Name))
                                                        end)
                                                        
                                                        Item = Items_Array[tonumber(Index)]
                                                    end
                                                    
                                                    if (Item == nil) then
                                                        for Index, __Item in pairs(Items:GetChildren()) do
                                                            if (Index == tonumber(Index)) then
                                                                Item = __Item
                                                                
                                                                break
                                                            end
                                                        end
                                                    end
                                                end
                                                
                                                return Item
                                            end
                                            
                                            local Visibility = nil
                                            
                                            local function Select(Type, Skip)
                                                local Debounce = HostM:Debounce()
                                                
                                                if (Type ~= nil and Skip ~= nil and (Debounce == true or Skip == true)) then
                                                    if (Selected ~= nil) then
                                                        local Button = Customisation:FindFirstChild(Selected, true)
                                                        
                                                        if (Button ~= nil) then
                                                            local Tween = TS:Create(Button, Tween_Info_2, { BackgroundColor3 = Color3.fromRGB(255, 255, 255); BackgroundTransparency = 1 })
                                                            
                                                            Tween:Play()
                                                        end
                                                    end
                                                    
                                                    if (Selected == Type and Skip == false) then
                                                        Type = nil
                                                        
                                                        Settings.Selected, Selected = Type, Type
                                                        
                                                    elseif (Selected ~= Type or Skip == true) then
                                                        Settings.Selected, Selected = Type, Type
                                                        
                                                        local Button = Customisation:FindFirstChild(Type, true)
                                                        
                                                        if (Button ~= nil) then
                                                            local Tween = TS:Create(Button, Tween_Info_2, { BackgroundColor3 = Color3.fromRGB(109, 109, 109); BackgroundTransparency = .4 })
                                                            
                                                            Tween:Play()
                                                        end
                                                    end
                                                    
                                                    Visibility(Type)
                                                end
                                            end
                                            
                                            local function Index(Type, Increment, Skip)
                                                local Debounce = HostM:Debounce()
                                                
                                                if (Type ~= nil and Increment ~= nil and (Skip ~= nil or Debounce == true)) then
                                                    local Is_Accessory = (Type:find("Accessory") ~= nil)
                                                    
                                                    if (Is_Accessory ~= nil) then
                                                        local Category = (((Type == "Primary" or Type == "Secondary") and "Hairs") or (Is_Accessory == true and "Accessories") or Type)
                                                        
                                                        local Index = Indexes[Type]
                                                        
                                                        if (Category ~= nil and Index ~= nil) then
                                                            local Minimum_Index = ((Category == "Accessories" and 0) or 1)
                                                            
                                                            local Items = Assets:FindFirstChild(Category)
                                                            
                                                            local Data = Temporary_Data[Category]
                                                            
                                                            local Current_Index, Maximum_Index = Index.Current, Index.Maximum
                                                            
                                                            if (Minimum_Index ~= nil and Items ~= nil and Data ~= nil and Current_Index ~= nil and Maximum_Index ~= nil) then
                                                                local New_Index = (Current_Index + Increment)
                                                                
                                                                if (New_Index ~= nil) then
                                                                    New_Index = ((New_Index > Maximum_Index and Minimum_Index) or (New_Index <= (Minimum_Index - 1) and Maximum_Index) or New_Index)
                                                                    
                                                                    local New_Item = Get_Indexed_Item(Items, New_Index)
                                                                    
                                                                    if ((New_Item == nil and New_Index == 0) or New_Item ~= nil) then
                                                                        local Name = ((New_Item == nil and '""') or (New_Item ~= nil and New_Item.Name))
                                                                        
                                                                        if (Name ~= nil) then
                                                                            Select(Type, true)
                                                                            
                                                                            Index.Current, Index.Name = New_Index, ((Is_Accessory == false and Name) or (Is_Accessory == true and New_Index))
                                                                            
                                                                            Update_Indexes()
                                                                            
                                                                            local Index = ((Type == "Primary" and 1) or (Type == "Secondary" and 2) or (Is_Accessory == true and Type) or nil)
                                                                            
                                                                            if (Index == nil) then
                                                                                Temporary_Data[Category] = Name
                                                                                
                                                                            elseif (Index ~= nil) then
                                                                                local Data_Index = Data[Index]
                                                                                
                                                                                if (Data_Index ~= nil) then
                                                                                    if (Category == "Hairs") then
                                                                                        local Type = Data_Index.Type
                                                                                        
                                                                                        if (Type ~= nil) then
                                                                                            Data_Index.Type = New_Index
                                                                                        end
                                                                                        
                                                                                    elseif (Category == "Accessories") then
                                                                                        local __Name = Data_Index.Name
                                                                                        
                                                                                        if (__Name ~= nil) then
                                                                                            Data_Index.Name = Name
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                            
                                                                            POST:FireServer("Customisation", Category, New_Item, Index)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Create_Avatar()
                                                local Saved = Temporary_Data.Saved
                                                
                                                if (Saved ~= nil) then
                                                    for Category, Value in pairs(Temporary_Data) do
                                                        local Items = Assets:FindFirstChild(Category)
                                                        
                                                        if (Items ~= nil) then
                                                            local Amount = #Items:GetChildren()
                                                            
                                                            if (Amount ~= nil) then
                                                                local Current_Index, Maximum_Index = nil, Amount
                                                                
                                                                Current_Index = ((Amount > 0 and math.random(1, Amount)) or nil)
                                                                
                                                                if (Saved == true) then
                                                                    Current_Index = Value
                                                                    
                                                                end
                                                                
                                                                if (((Current_Index == nil and Category == "Accessories") or Current_Index ~= nil) and Maximum_Index ~= nil) then
                                                                    if (Category == "Hairs") then
                                                                        local Absolute_Size, Absolute_Position = Wheel.AbsoluteSize, Wheel.AbsolutePosition
                                                                        
                                                                        if (Absolute_Size ~= nil and Absolute_Position ~= nil) then
                                                                            for Index, Data in pairs(Value) do
                                                                                local Type, R, G, B, Changed = Data.Type, Data.R, Data.G, Data.B, Data.Changed
                                                                                
                                                                                if (Type ~= nil and R ~= nil and G ~= nil and B ~= nil and Changed ~= nil) then
                                                                                    if (tonumber(Type) > 0) then
                                                                                        local Indexed_Items = Items:GetChildren()
                                                                                        
                                                                                        table.sort(Indexed_Items, function(A, B)
                                                                                            return (tonumber(A.Name) < tonumber(B.Name))
                                                                                        end)
                                                                                        
                                                                                        local Found = false
                                                                                        
                                                                                        for Index, Item in pairs(Indexed_Items) do
                                                                                            if (tonumber(Item.Name) == Type) then
                                                                                                Current_Index = Index
                                                                                                
                                                                                                Found = true
                                                                                                
                                                                                                break
                                                                                            end
                                                                                        end
                                                                                        
                                                                                        if (Found == false) then
                                                                                            Current_Index = Items:GetChildren()[math.random(1, #Items:GetChildren())].Name
                                                                                        end
                                                                                    end
                                                                                    
                                                                                    if (Index == 1) then
                                                                                        Data.Type, Data.R, Data.G, Data.B = Current_Index, R, G, B
                                                                                        
                                                                                        if (Changed == false) then
                                                                                            local X = (Absolute_Position.X + math.random(1, Absolute_Size.X))
                                                                                            local Y = (Absolute_Position.Y + math.random(1, Absolute_Size.Y))
                                                                                            
                                                                                            if (X ~= nil and Y ~= nil) then
                                                                                                New_Position = Vector2.new(X, Y)
                                                                                                
                                                                                                Colour_Movement(nil)
                                                                                                
                                                                                                task.defer(function()
                                                                                                    wait(Index)
                                                                                                    
                                                                                                    New_Position = nil
                                                                                                end)
                                                                                            end
                                                                                        end
                                                                                        
                                                                                    elseif (Index > 1) then
                                                                                        Data.Type, Data.R, Data.G, Data.B = Current_Index, R, G, B
                                                                                    end
                                                                                    
                                                                                    local Type = ((Index == 1 and "Primary") or (Index == 2 and "Secondary"))
                                                                                    
                                                                                    if (Type ~= nil) then
                                                                                        local Item = Get_Indexed_Item(Items, Current_Index)
                                                                                        
                                                                                        if (Item ~= nil) then
                                                                                            Indexes[Type] = { Current = Current_Index; Maximum = Maximum_Index; Name = Item.Name }
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        
                                                                    elseif (Category == "Accessories") then
                                                                        for Index, Accessory_Data in pairs(Value) do
                                                                            local Name = Accessory_Data.Name
                                                                            
                                                                            if (Name ~= nil) then
                                                                                Current_Index = ((Name == "" and 0) or nil)
                                                                                
                                                                                if (Current_Index == nil) then
                                                                                    for Index, Item in pairs(Items:GetChildren()) do
                                                                                        local Tag = Item:FindFirstChild("Tag")
                                                                                        
                                                                                        if (Tag ~= nil and Tag.Value == Name) then
                                                                                            Current_Index = Index
                                                                                            
                                                                                            break
                                                                                        end
                                                                                    end
                                                                                end
                                                                                
                                                                                if (Current_Index ~= nil) then
                                                                                    Indexes[Index] = { Current = Current_Index; Maximum = Maximum_Index; Name = Current_Index }
                                                                                end
                                                                            end
                                                                        end
                                                                        
                                                                    elseif (Category ~= "Hairs" and Category ~= "Accessories") then
                                                                        Value = tonumber(Value)
                                                                        
                                                                        if (Value > 0) then
                                                                            local Indexed_Items = Items:GetChildren()
                                                                            
                                                                            table.sort(Indexed_Items, function(A, B)
                                                                                return (tonumber(A.Name) < tonumber(B.Name))
                                                                            end)
                                                                            
                                                                            for Index, Item in pairs(Indexed_Items) do
                                                                                if (tonumber(Item.Name) == Value) then
                                                                                    Current_Index = Index
                                                                                    
                                                                                    break
                                                                                end
                                                                            end
                                                                        end
                                                                        
                                                                        local Item = Get_Indexed_Item(Items, Current_Index)
                                                                        
                                                                        if (Item == nil and Current_Index == 0) then
                                                                            Current_Index = math.random(1, Maximum_Index)
                                                                            
                                                                            Item = Get_Indexed_Item(Items, Current_Index)
                                                                        end
                                                                        
                                                                        if (Item ~= nil) then
                                                                            local Name = ((Item == nil and '""') or (Item ~= nil and Item.Name))
                                                                            
                                                                            if (Name ~= nil) then
                                                                                Temporary_Data[Category] = Name
                                                                                
                                                                                Indexes[Category] = { Current = Current_Index; Maximum = Maximum_Index; Name = Item.Name }
                                                                                
                                                                                Items.ChildAdded:Connect(function()
                                                                                    Indexes[Category].Maximum = #Items:GetChildren()
                                                                                end)
                                                                                
                                                                                Items.ChildRemoved:Connect(function(Object)
                                                                                    Indexes[Category].Maximum = #Items:GetChildren()
                                                                                    
                                                                                    if (Object ~= nil) then
                                                                                        local Current = Indexes[Category].Current
                                                                                        
                                                                                        if (Current ~= nil and tonumber(Object.Name) == tonumber(Current)) then
                                                                                            Index(Category, -1, true)
                                                                                        end
                                                                                    end
                                                                                end)
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Initialise_Avatar()
                                                for Category, Value in pairs(Temporary_Data) do
                                                    local Items = Assets:FindFirstChild(Category)
                                                    
                                                    if (Items ~= nil) then
                                                        if (Category == "Hairs") then
                                                            for Index, Data in pairs(Value) do
                                                                local Type, R, G, B, Changed = Data.Type, Data.R, Data.G, Data.B, Data.Changed
                                                                
                                                                local Colour = Colour.ImageColor3
                                                                
                                                                if (Type ~= nil and R ~= nil and G ~= nil and B ~= nil and Changed ~= nil and Colour ~= nil) then
                                                                    local Item = Get_Indexed_Item(Items, Type)
                                                                    
                                                                    local R = ((Changed == false and Colour.R) or (Changed == true and R))
                                                                    local G = ((Changed == false and Colour.G) or (Changed == true and G))
                                                                    local B = ((Changed == false and Colour.B) or (Changed == true and B))
                                                                    
                                                                    if (Item ~= nil and R ~= nil and G ~= nil and B ~= nil) then
                                                                        Data.R, Data.G, Data.B = R, G, B
                                                                        
                                                                        local HSV = nil
                                                                        
                                                                        if (Changed == false) then
                                                                            local H, S, V = Color3.new(R, G, B):ToHSV()
                                                                            
                                                                            if (H ~= nil and S ~= nil and V ~= nil) then
                                                                                HSV = Color3.fromHSV(H, S, V)
                                                                            end
                                                                            
                                                                        elseif (Changed == true) then
                                                                            HSV = Color3.fromHSV(R, G, B)
                                                                        end
                                                                        
                                                                        if (HSV ~= nil) then
                                                                            POST:FireServer("Customisation", "Hairs", Item, Index, HSV)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            
                                                        elseif (Category == "Accessories") then
                                                            for Index, Data in pairs(Value) do
                                                                local Item = Data.Name
                                                                
                                                                if (Item ~= nil) then
                                                                    local __Item = nil
                                                                    
                                                                    for Index, ____Item in pairs(Items:GetChildren()) do
                                                                        local Tag = ____Item:FindFirstChild("Tag")
                                                                        
                                                                        if (Tag ~= nil and Tag.Value == Item) then
                                                                            __Item = ____Item
                                                                            
                                                                            break
                                                                        end
                                                                    end
                                                                    
                                                                    if (__Item ~= nil) then
                                                                        POST:FireServer("Customisation", Category, __Item, Index)
                                                                    end
                                                                end
                                                            end
                                                            
                                                        elseif (Category ~= "Hairs" and Category ~= "Accessories") then
                                                            local Current_Index = 0
                                                            
                                                            local Indexed_Items = Items:GetChildren()
                                                            
                                                            table.sort(Indexed_Items, function(A, B)
                                                                return (tonumber(A.Name) < tonumber(B.Name))
                                                            end)
                                                            
                                                            for Index, Item in pairs(Indexed_Items) do
                                                                if (tonumber(Item.Name) == tonumber(Value)) then
                                                                    Current_Index = Index
                                                                    
                                                                    break
                                                                end
                                                            end
                                                            
                                                            local Item = Get_Indexed_Item(Items, Current_Index)
                                                            
                                                            if (Item ~= nil) then
                                                                POST:FireServer("Customisation", Category, Item)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            Visibility = function(Type)
                                                local Visible = (((Type == "Primary" or Type == "Secondary") and true) or false)
                                                
                                                local Object_Properties = {
                                                    ["ImageButton"] = {
                                                        [1] = "ImageTransparency"
                                                    };
                                                    
                                                    ["ImageLabel"] = {
                                                        [1] = "ImageTransparency"
                                                    };
                                                    
                                                    ["Frame"] = {
                                                        [1] = "BackgroundTransparency"
                                                    };
                                                    
                                                    ["TextButton"] = {
                                                        [1] = "BackgroundTransparency";
                                                        [2] = "TextTransparency"
                                                    }
                                                }
                                                
                                                if (Visible ~= nil) then
                                                    local Objects = { [1] = Wheel; [2] = Saturation; [3] = Colour; [4] = Set; [5] = Picker; [6] = Slider }
                                                    
                                                    for _, Object in pairs(Objects) do
                                                        local Properties = {}
                                                        
                                                        local Property_Data = Object_Properties[Object.ClassName]
                                                        
                                                        local State = ((Visible == false and 1) or (Visible == true and 0))
                                                        
                                                        if (Property_Data ~= nil and State ~= nil) then
                                                            for _, Property in pairs(Property_Data) do
                                                                Properties[Property] = State
                                                                
                                                                if (Object == Slider) then
                                                                    Properties.BackgroundTransparency = State
                                                                end
                                                                
                                                                local Tween = TS:Create(Object, Tween_Info_1, Properties)
                                                                
                                                                Tween:Play()
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Rotate(Y)
                                                if (Y ~= nil) then
                                                    local Angle = CFrame.Angles(0, math.rad(Y), 0)
                                                    
                                                    if (Angle ~= nil) then
                                                        local cFrame = HumanoidRootPart.CFrame
                                                        
                                                        if (cFrame ~= nil) then
                                                            local Tween = TS:Create(HumanoidRootPart, Tween_Info_1, { CFrame = (cFrame * Angle) })
                                                            
                                                            Tween:Play()
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Update_Spins(Amount)
                                                if (Amount == nil) then
                                                    Amount = Data.Spins
                                                end
                                                
                                                if (Amount ~= nil) then
                                                    __Spins.Text = tostring("Spins: " .. Amount)
                                                end
                                            end
                                            
                                            local function Update_Family(Family)
                                                if (Family == nil) then
                                                    Family = Data.Family
                                                end
                                                
                                                if (Family ~= nil) then
                                                    local Colour = nil
                                                    
                                                    for _, Data in pairs(Families) do
                                                        local Name, __Colour = Data.Name, Data.Colour
                                                        
                                                        if (Name ~= nil and __Colour ~= nil and Family == Name) then
                                                            Colour = __Colour
                                                            
                                                            break
                                                        end
                                                    end
                                                    
                                                    if (Family == "" and Colour == nil) then
                                                        Colour = Color3.fromRGB(255, 255, 255)
                                                    end
                                                    
                                                    if (Colour ~= nil) then
                                                        Selected_Family.Text, Selected_Family.TextColor3 = string.upper(Family), Colour
                                                        
                                                        Temporary_Data.Family = Family
                                                    end
                                                end
                                            end
                                            
                                            local function Popup(Skip)
                                                local Debounce = HostM:Debounce()
                                                
                                                local Text = Buy.Text
                                                
                                                if (Skip ~= nil and Debounce ~= nil and (Debounce == true or Skip == true) and Text ~= nil) then
                                                    Buy.Text = ((Text == "BUY" and "CLOSE") or (Text == "CLOSE" and "BUY"))
                                                    
                                                    local Visibility = ((Text == "BUY" and true) or (Text == "CLOSE" and false))
                                                    
                                                    if (Visibility ~= nil) then
                                                        local Objects = {
                                                            [1] = { Name = "Spins"; Class = "TextButton"; Properties = { BackgroundTransparency = 0 } };
                                                            [2] = { Name = "Return"; Class = "Frame"; Properties = { BackgroundTransparency = 0 } };
                                                            [3] = { Name = "Buy_"; Class = "TextButton"; Properties = { BackgroundTransparency = 0; TextTransparency = 0 } };
                                                            [4] = { Name = "Title_"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                                                            [5] = { Name = "Deal"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                                                            [6] = { Name = "1"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                                                            [7] = { Name = "2"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                                                            [8] = { Name = "3"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                                                            [9] = { Name = "4"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                                                            [10] = { Name = "5"; Class = "TextLabel"; Properties = { TextTransparency = 0 } };
                                                            [11] = { Name = "6"; Class = "TextLabel"; Properties = { TextTransparency = 0 } }
                                                        }
                                                        
                                                        HostM:Fade(Spins, Visibility, Objects)
                                                    end
                                                end
                                            end
                                            
                                            local function Update_Name(Original)
                                                local Device = HostM.Last_Device
                                                
                                                if (Original ~= nil and Device ~= nil) then
                                                    local Name = Data.Name
                                                    
                                                    local Text = Box.Text
                                                    
                                                    local Minimum, Maximum = 3, 12
                                                    
                                                    local Delay = .5
                                                    
                                                    if (Name ~= nil and Text ~= nil) then
                                                        if (Name == "" or Original == false) then
                                                            if (Console == true) then
                                                                Text = Player.Name
                                                            end
                                                            
                                                            local New_Name = GET:InvokeServer("Name", Text)
                                                            
                                                            if (New_Name ~= nil) then
                                                                local Filtered = (New_Name:find("#") ~= nil)
                                                                local Spaces = (New_Name:find(" ") ~= nil)
                                                                local Length = string.len(New_Name)
                                                                
                                                                if (Filtered ~= nil and Spaces ~= nil and Length ~= nil) then
                                                                    local Error = ((Filtered == true and "FILTERED") or (Spaces == true and "NO SPACES") or (Length < Minimum and "TOO SHORT") or (Length > Maximum and "TOO LONG") or (Text == "" and "NOT A NAME") or nil)
                                                                    
                                                                    if (Console == true) then
                                                                        Error = nil
                                                                    end
                                                                    
                                                                    Box.Text = ((Error == nil and New_Name) or (Error ~= nil and Error))
                                                                    
                                                                    if (Error == nil) then
                                                                        local __Name = Temporary_Data.Name
                                                                        
                                                                        if (__Name ~= nil) then
                                                                            Temporary_Data.Name = New_Name
                                                                        end
                                                                        
                                                                    elseif (Error ~= nil) then
                                                                        task.defer(function()
                                                                            wait(Delay)
                                                                            
                                                                            Box.Text = "ENTER NAME"
                                                                        end)
                                                                    end
                                                                end
                                                            end
                                                            
                                                        elseif (Name ~= "" and Original == true) then
                                                            Box.Text = Name
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Adjust_Notification(State, Family)
                                                if (State ~= nil) then
                                                    local Objects = {
                                                        [1] = { Name = "Notification"; Class = "Frame"; Properties = { BackgroundTransparency = 0 } };
                                                        [2] = { Name = "Decline"; Class = "TextButton"; Properties = { BackgroundTransparency = 0 } };
                                                        [3] = { Name = "Accept"; Class = "TextButton"; Properties = { BackgroundTransparency = 0 } };
                                                        [4] = { Name = "Title__"; Class = "TextLabel"; Properties = { TextTransparency = 0 } }
                                                    }
                                                    
                                                    HostM:Fade(Notification, State, Objects)
                                                    
                                                    if (State == true and Family ~= nil) then
                                                        Title__.Text = tostring("Are you sure you would like to re-roll " .. Family .. "?")
                                                    end
                                                end
                                            end
                                            
                                            local Rolling = false
                                            
                                            local function __Roll()
                                                if (Rolling == false) then
                                                    Data.Spins = 999
                                                    local Spins = Data.Spins
                                                    
                                                    local Debounce = HostM:Debounce()
                                                    
                                                    if (Spins ~= nil and Debounce ~= nil and Debounce == true and Spinning == false and Roll.TextTransparency == 0) then
                                                        if (Spins == 0) then
                                                            local Product_ID = Product_IDs["1"]
                                                            
                                                            if (Debounce and Product_ID) then
                                                                MS:PromptProductPurchase(Player, Product_ID)
                                                            end
                                                            
                                                            --Popup(true)
                                                            
                                                        elseif (Spins > 0) then
                                                            local Current_Family = Temporary_Data.Family
                                                            
                                                            if (Current_Family ~= nil) then
                                                                local Rarity = nil
                                                                
                                                                for _, Data in pairs(Families) do
                                                                    local Name, __Rarity = Data.Name, Data.Rarity
                                                                    
                                                                    if (Name ~= nil and __Rarity ~= nil and Current_Family == Name) then
                                                                        Rarity = __Rarity
                                                                        
                                                                        break
                                                                    end
                                                                end
                                                                
                                                                local function Get_Random_Name(Family)
                                                                    local __Family = Family
                                                                    
                                                                    local Chance = 1
                                                                    
                                                                    if (Chance <= 1) then
                                                                        local __Families = {}
                                                                        
                                                                        for _, Family_Data in pairs(Families) do
                                                                            local Name, Rarity = Family_Data.Name, Family_Data.Rarity
                                                                            
                                                                            if (Name ~= nil and Rarity ~= nil and Rarity == "Legendary") then
                                                                                table.insert(__Families, Name)
                                                                                print('Rolling a '.. Name)
                                                                            end
                                                                        end
                                                                        
                                                                        if (__Families ~= nil and #__Families > 0) then
                                                                            local Index = math.random(1, #__Families)
                                                                            
                                                                            if (Index ~= nil) then
                                                                                __Family = __Families[Index]
                                                                            end
                                                                        end
                                                                        
                                                                    --[[ elseif (Chance <= 10) then
                                                                        local __Families = {}
                                                                        
                                                                        for _, Family_Data in pairs(Families) do
                                                                            local Name, Rarity = Family_Data.Name, Family_Data.Rarity
                                                                            
                                                                            if (Name ~= nil and Rarity ~= nil and Rarity == "Epic") then
                                                                                table.insert(__Families, Name)
                                                                            end
                                                                        end
                                                                        
                                                                        if (__Families ~= nil and #__Families > 0) then
                                                                            local Index = math.random(1, #__Families)
                                                                            
                                                                            if (Index ~= nil) then
                                                                                __Family = __Families[Index]
                                                                            end
                                                                        end *]]
                                                                    end
                                                                    
                                                                    return (__Family)
                                                                end
                                                                
                                                                local function Start_Roll()
                                                                    Rolling = true
                                                                    
                                                                    local Result = GET:InvokeServer("Family")
                                                                    
                                                                    if (Result ~= nil) then
                                                                        local Spins, Families, O_Pity, R_Pity, R_Pity_2 = 999, Result.Families, 424, 2999, 2999

                                                                        print(R_Pity_2)
                                                                        
                                                                        if (Spins ~= nil and Families ~= nil and O_Pity ~= nil) then
                                                                            Update_Spins(Spins)
                                                                            
                                                                            local Owns_Bag = HostM:Owns_Gamepass(Player, ID, "Bloodline Bag", false)
                                                                            
                                                                            if (Owns_Bag ~= nil) then
                                                                                local Orange_Pity = ((Owns_Bag == false and 425) or (Owns_Bag == true and 375))
                                                                                local Red_Pity = ((Owns_Bag == false and 3500) or (Owns_Bag == true and 3000))
                                                                                
                                                                                Pity_1.Text = tostring("ORANGE PITY: " .. O_Pity .. "/" .. Orange_Pity)
                                                                                
                                                                                if (R_Pity ~= nil) then
                                                                                    Pity_2.Text = tostring("RED PITY: " .. R_Pity .. "/" .. Red_Pity)
                                                                                    
                                                                                elseif (R_Pity_2 ~= nil) then
                                                                                    Pity_2.Text = tostring("RED PITY: " .. R_Pity_2 .. "/" .. Red_Pity)
                                                                                    
                                                                                else
                                                                                    Pity_1.Position = UDim2.new(.5, 0, 2.55, 0)
                                                                                    
                                                                                    Pity_2.Visible = false
                                                                                end
                                                                            end
                                                                            
                                                                            Spinning = true
                                                                            
                                                                            local Tween = TS:Create(Roll, Tween_Info_1, { BackgroundTransparency = 1; TextTransparency = 1 })
                                                                            
                                                                            Tween:Play()
                                                                            
                                                                            task.defer(function()
                                                                                local Smallest_Index = 55
                                                                                
                                                                                local Owns_Skip_Roll = HostM:Owns_Gamepass(Player, ID, "Skip Roll", false)
                                                                                
                                                                                if (Owns_Skip_Roll ~= nil) then
                                                                                    if (Owns_Skip_Roll == false) then
                                                                                        for Index, Family in pairs(Families) do
                                                                                            if (Index < #Families) then
                                                                                                Family = Get_Random_Name(Family)
                                                                                            end
                                                                                            
                                                                                            Update_Family(Family)
                                                                                            
                                                                                            local Time = ((Index >= Smallest_Index and (.25 + ((Index - Smallest_Index) / 5))) or ((Index / #Families) / 5))
                                                                                            
                                                                                            HostM:Sound(Customisation, "Spin", true)
                                                                                            
                                                                                            if (Index < #Families) then
                                                                                                wait(Time)
                                                                                            end
                                                                                        end
                                                                                        
                                                                                    elseif (Owns_Skip_Roll == true) then
                                                                                        Update_Family(Families[#Families])
                                                                                    end
                                                                                end
                                                                                
                                                                                HostM:Sound(Customisation, "Family", true)
                                                                                
                                                                                Spinning = false
                                                                                
                                                                                Rolling = false
                                                                                
                                                                                local Tween = TS:Create(Roll, Tween_Info_2, { BackgroundTransparency = 0; TextTransparency = 0 })
                                                                                
                                                                                Tween:Play()
                                                                            end)
                                                                        end
                                                                    end
                                                                end
                                                                
                                                                if (Rarity == "Epic" or Rarity == "Legendary") then
                                                                    Adjust_Notification(true, Current_Family)
                                                                    
                                                                    if (Events.Decline_Family ~= nil) then
                                                                        Events.Decline_Family:Disconnect(); Events.Decline_Family = nil
                                                                    end
                                                                    
                                                                    Events.Decline_Family = Decline.MouseButton1Click:Connect(function()
                                                                        if (Notification.Visible == true and Title__.TextTransparency == 0) then
                                                                            local Debounce = HostM:Debounce()
                                                                            
                                                                            if (Debounce ~= nil and Debounce == true) then
                                                                                Adjust_Notification(false, nil)
                                                                            end
                                                                        end
                                                                    end)
                                                                    
                                                                    if (Events.Accept_Family ~= nil) then
                                                                        Events.Accept_Family:Disconnect(); Events.Accept_Family = nil
                                                                    end
                                                                    
                                                                    Events.Accept_Family = Accept.MouseButton1Click:Connect(function()
                                                                        if (Notification.Visible == true and Title__.TextTransparency == 0) then
                                                                            local Debounce = HostM:Debounce()
                                                                            
                                                                            if (Debounce ~= nil and Debounce == true) then
                                                                                Adjust_Notification(false, nil)
                                                                                
                                                                                Start_Roll()
                                                                            end
                                                                        end
                                                                    end)
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            local function Get_Place_ID(Type)
                                                local ID = nil
                                                
                                                if (Type ~= nil) then
                                                    for _, Place_Data in pairs(Whitelist) do
                                                        local Place_Name, Place_ID = Place_Data.Name, Place_Data.ID
                                                        
                                                        if (Place_Name ~= nil and Type == Place_Name and Place_ID ~= nil) then
                                                            ID = Place_ID
                                                            
                                                            break
                                                        end
                                                    end
                                                end
                                                
                                                return (ID)
                                            end
                                            
                                            local function Setup_Teleport()
                                                local ID = Get_Place_ID("Hub")
                                                
                                                local Teleport_GUI = Settings.Teleport_GUI
                                                
                                                if (ID ~= nil and Teleport_GUI ~= nil) then
                                                    local Can_Teleport = nil
                                                    
                                                    repeat
                                                        RS.RenderStepped:Wait()
                                                        
                                                        Can_Teleport = Settings.Can_Teleport
                                                        
                                                    until (Can_Teleport ~= nil and Can_Teleport == true)
                                                    
                                                    TP:SetTeleportGui(Teleport_GUI)
                                                    
                                                    TP:Teleport(ID, Player, nil, Teleport_GUI)
                                                end
                                            end
                                            
                                            local __Pity_1, __Pity_2, __R_Pity = Data.Pity, Data.Pity_2, Data.R_Pity
                                            
                                            local Owns_Bag = HostM:Owns_Gamepass(Player, ID, "Bloodline Bag", false)
                                            
                                            if (Owns_Bag ~= nil) then
                                                local Orange_Pity = ((Owns_Bag == false and 425) or (Owns_Bag == true and 375))
                                                local Red_Pity = ((Owns_Bag == false and 3500) or (Owns_Bag == true and 3000))
                                                
                                                Pity_1.Text = tostring("ORANGE PITY: " .. __Pity_1 .. "/" .. Orange_Pity)
                                                
                                                if (__Pity_2 ~= nil) then
                                                    Pity_2.Text = tostring("RED PITY: " .. __Pity_2 .. "/" .. Red_Pity)
                                                    
                                                elseif (__R_Pity ~= nil) then
                                                    Pity_2.Text = tostring("RED PITY: " .. __R_Pity .. "/" .. Red_Pity)
                                                    
                                                else
                                                    Pity_1.Position = UDim2.new(.5, 0, 2.55, 0)
                                                    
                                                    Pity_2.Visible = false
                                                end
                                            end
                                            
                                            Create_Avatar()
                                            
                                            Initialise_Avatar()
                                            
                                            Visibility(Selected)
                                            
                                            Update_Indexes()
                                            
                                            Update_Spins()
                                            
                                            Update_Family()
                                            
                                            Update_Name(true)
                                            
                                            local function Detect_Gamepass(Type, Object, Left, Right)
                                                if (Type ~= nil and Object ~= nil and Left ~= nil and Right ~= nil) then
                                                    local Gamepasses = Player:FindFirstChild("Gamepasses")
                                                    
                                                    local Gamepass_IDs = HostM.Gamepass_IDs
                                                    
                                                    if (Gamepasses ~= nil and Gamepass_IDs ~= nil) then
                                                        local Gamepass_ID = nil
                                                        
                                                        for Gamepass_Name, ID in pairs(Gamepass_IDs) do
                                                            if (Type == Gamepass_Name) then
                                                                Gamepass_ID = ID
                                                                
                                                                break
                                                            end
                                                        end
                                                        
                                                        if (Gamepass_ID ~= nil) then
                                                            local Gamepass = Gamepasses:FindFirstChild(Gamepass_ID)
                                                            
                                                            if (Gamepass ~= nil) then
                                                                local function Update()
                                                                    local Owned = Gamepass.Value
                                                                    
                                                                    if (Owned ~= nil) then
                                                                        local Colour = ((Owned == false and Color3.fromRGB(150, 150, 150)) or (Owned == true and Color3.fromRGB(255, 255, 255)))
                                                                        
                                                                        if (Colour ~= nil) then
                                                                            Object.TextColor3, Left.TextColor3, Right.TextColor3 = Colour, Colour, Colour
                                                                            
                                                                            if (Owned == false) then
                                                                                Object:SetAttribute("Text", Object.Text)
                                                                                
                                                                                Object.Text = "Locked <0>"
                                                                                
                                                                            elseif (Owned == true) then
                                                                                local Text = Object:GetAttribute("Text")
                                                                                
                                                                                if (Text ~= nil) then
                                                                                    Object.Text = Text
                                                                                    
                                                                                    Object:SetAttribute("Text", nil)
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                                
                                                                Update()
                                                                
                                                                Gamepass:GetPropertyChangedSignal("Value"):Connect(function()
                                                                    Update()
                                                                end)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            for __Index, _ in pairs(Indexes) do
                                                local Object = Customisation:FindFirstChild(__Index, true)
                                                
                                                if (Object ~= nil and Object:IsA("TextLabel") == true) then
                                                    local Interact = Object:FindFirstChild("Interact")
                                                    
                                                    local Left, Right = Object:FindFirstChild("Left"), Object:FindFirstChild("Right")
                                                    
                                                    if (Interact ~= nil and Left ~= nil and Right ~= nil) then
                                                        local Type = ((Object.Name == "Accessory_2" and "Secondary Accessory Slot") or (Object.Name == "Accessory_3" and "Third Accessory Slot") or nil)
                                                        
                                                        if (Type ~= nil) then
                                                            Detect_Gamepass(Type, Object, Left, Right)
                                                        end
                                                        
                                                        Interact.MouseButton1Click:Connect(function()
                                                            local Continue = true
                                                            
                                                            if (Object.Name == "Accessory_2") then
                                                                Continue = HostM:Owns_Gamepass(Player, ID, "Secondary Accessory Slot", true)
                                                                
                                                            elseif (Object.Name == "Accessory_3") then
                                                                Continue = HostM:Owns_Gamepass(Player, ID, "Third Accessory Slot", true)
                                                            end
                                                            
                                                            if (Continue ~= nil and Continue == true) then
                                                                Select(Object.Name, false)
                                                            end
                                                        end)
                                                        
                                                        Left.MouseButton1Click:Connect(function()
                                                            local Continue = true
                                                            
                                                            if (Object.Name == "Accessory_2") then
                                                                Continue = HostM:Owns_Gamepass(Player, ID, "Secondary Accessory Slot", true)
                                                                
                                                            elseif (Object.Name == "Accessory_3") then
                                                                Continue = HostM:Owns_Gamepass(Player, ID, "Third Accessory Slot", true)
                                                            end
                                                            
                                                            if (Continue ~= nil and Continue == true) then
                                                                if (Data.Custom == false) then
                                                                    Index(Object.Name, -1)
                                                                    
                                                                else
                                                                    HostM:Notification(Interface, "Turn off custom avatar!", false)
                                                                end
                                                            end
                                                        end)
                                                        
                                                        Right.MouseButton1Click:Connect(function()
                                                            local Continue = true
                                                            
                                                            if (Object.Name == "Accessory_2") then
                                                                Continue = HostM:Owns_Gamepass(Player, ID, "Secondary Accessory Slot", true)
                                                                
                                                            elseif (Object.Name == "Accessory_3") then
                                                                Continue = HostM:Owns_Gamepass(Player, ID, "Third Accessory Slot", true)
                                                            end
                                                            
                                                            if (Continue ~= nil and Continue == true) then
                                                                if (Data.Custom == false) then
                                                                    Index(Object.Name, 1)
                                                                    
                                                                else
                                                                    HostM:Notification(Interface, "Turn off custom avatar!", false)
                                                                end
                                                            end
                                                        end)
                                                    end
                                                end
                                            end
                                            
                                            if (Data.Custom == true) then
                                                GET:InvokeServer("Character", true)
                                            end
                                            
                                            Custom.MouseButton1Click:Connect(function()
                                                local Debounce = HostM:Debounce()
                                                
                                                if (Debounce ~= nil and Debounce == true) then
                                                    local Owns_Gamepass = HostM:Owns_Gamepass(Player, ID, "Custom Character", true)
                                                    
                                                    if (Owns_Gamepass ~= nil and Owns_Gamepass == true) then
                                                        local New_State = GET:InvokeServer("Character")
                                                        
                                                        if (New_State ~= nil) then
                                                            Data.Custom = New_State
                                                            
                                                            local New_State = ((New_State == false and "OFF") or (New_State == true and "ON"))
                                                            
                                                            Custom.Title.Text = tostring("CUSTOM AVATAR: " .. New_State)
                                                        end
                                                    end
                                                end
                                            end)
                                            
                                            local New_State = ((Data.Custom == false and "OFF") or (Data.Custom == true and "ON"))
                                            
                                            Custom.Title.Text = tostring("CUSTOM AVATAR: " .. New_State)
                                            
                                            task.defer(function()
                                                wait(1)
                                                
                                                Rotate(180)
                                            end)
                                            
                                            LArrow.MouseButton1Click:Connect(function()
                                                local Debounce = HostM:Debounce()
                                                
                                                if (Debounce ~= nil and Debounce == true) then
                                                    Rotate(-30)
                                                end
                                            end)
                                            
                                            LArrow.MouseButton1Down:Connect(function()
                                                Left_Arrow_Hold, Right_Arrow_Hold = true, false
                                            end)
                                            
                                            LArrow.MouseButton1Up:Connect(function()
                                                Left_Arrow_Hold, Right_Arrow_Hold = false, false
                                            end)
                                            
                                            RArrow.MouseButton1Click:Connect(function()
                                                local Debounce = HostM:Debounce()
                                                
                                                if (Debounce ~= nil and Debounce == true) then
                                                    Rotate(30)
                                                end
                                            end)
                                            
                                            RArrow.MouseButton1Down:Connect(function()
                                                Left_Arrow_Hold, Right_Arrow_Hold = false, true
                                            end)
                                            
                                            RArrow.MouseButton1Up:Connect(function()
                                                Left_Arrow_Hold, Right_Arrow_Hold = false, false
                                            end)
                                            
                                            local Owns_Bag = HostM:Owns_Gamepass(Player, ID, "Bloodline Bag", false)
                                            
                                            if (Owns_Bag ~= nil and Owns_Bag == true) then
                                                Store.Visible = true
                                                
                                                Buttons.List.Padding = UDim.new(.05, 0)
                                                
                                                for _, Object in pairs(Buttons:GetChildren()) do
                                                    if (Object:IsA("TextButton") == true) then
                                                        Object.Size = UDim2.new(.3, 0, 1, 0)
                                                    end
                                                end
                                                
                                                local Stored = false
                                                
                                                Store.MouseButton1Click:Connect(function()
                                                    if (Stored == false) then
                                                        local Debounce = HostM:Debounce()
                                                        
                                                        if (Debounce ~= nil) then
                                                            Stored = true
                                                            
                                                            local Result = GET:InvokeServer("Store")
                                                            
                                                            if (Result ~= nil) then
                                                                local Message, Success, Family = Result[1], Result[2], Result[3]
                                                                
                                                                if (Message ~= nil and Success ~= nil and Family ~= nil) then
                                                                    HostM:Notification(Interface, Message, Success)
                                                                    
                                                                    Stored = false
                                                                    
                                                                    if (Success == true) then
                                                                        Selected_Family.Text, Selected_Family.TextColor3 = string.upper(Family), Color3.fromRGB(255, 255, 255)
                                                                        
                                                                        Temporary_Data.Family = Family
                                                                        
                                                                        HostM:Sound(Customisation, "Family", true)
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end)
                                            end
                                            
                                            Buy.MouseButton1Click:Connect(function()
                                                Popup(false)
                                            end)
                                            
                                            Roll.MouseButton1Click:Connect(function()
                                                if (Notification.Visible == false) then
                                                    __Roll()
                                                end
                                            end)
                                            
                                            Finish.MouseButton1Click:Connect(function()
                                                if (Finished_Customising == false) then
                                                    local Debounce = HostM:Debounce()
                                                    
                                                    local Name, Family = Temporary_Data.Name, Temporary_Data.Family
                                                    
                                                    if (Debounce ~= nil and Debounce == true and Name ~= nil and Family ~= nil) then
                                                        if (Name ~= "" and Family ~= "" and Spinning == false) then
                                                            if (Pressed_Saved == false) then
                                                                Pressed_Saved = true
                                                                
                                                                Finished_Customising = true
                                                                
                                                                HostM:Notification(Interface, "Saved Data!", true)
                                                                
                                                                POST:FireServer("Save", "Avatar", Temporary_Data)
                                                                
                                                                HostM:Fade(Customisation, false, Customisation_Objects, true)
                                                                
                                                                HostM:Lobbies(Player, Interface, POST, GET)
                                                                
                                                            elseif (Pressed_Saved == true) then
                                                                HostM:Notification(Interface, "Already saved!", false)
                                                            end
                                                            
                                                        elseif (Name == "") then
                                                            HostM:Notification(Interface, "Enter a name!", false)
                                                            
                                                        elseif (Family == "") then
                                                            HostM:Notification(Interface, "Roll a family!", false)
                                                            
                                                        elseif (Spinning == true) then
                                                            HostM:Notification(Interface, "Currently spinning!", false)
                                                        end
                                                    end
                                                end
                                            end)
                                            
                                            for _, Object in pairs(Spins:GetDescendants()) do
                                                if (Object:IsA("TextLabel") == true) then
                                                    local Buy = Object:FindFirstChild("Buy_")
                                                    
                                                    if (Buy ~= nil) then
                                                        Buy.MouseButton1Click:Connect(function()
                                                            local Debounce = HostM:Debounce()
                                                            
                                                            local Product_ID = Product_IDs[Object.Name]
                                                            
                                                            if (Debounce ~= nil and Debounce == true and Product_ID ~= nil) then
                                                                MS:PromptProductPurchase(Player, Product_ID)
                                                            end
                                                        end)
                                                    end
                                                end
                                            end
                                            
                                            Wheel.MouseButton1Down:Connect(function()
                                                Holding = true
                                            end)
            
                                            Saturation.MouseButton1Down:Connect(function()
                                                Moving = true
                                            end)
                                            
                                            Join_Interact.FocusLost:Connect(function(Enter)
                                                local Join_Code = Join_Interact.Text
                                                
                                                if (Enter ~= nil and Join_Code ~= nil and Join_Interact.Visible == true and Finished_Customising == false) then
                                                    local Joining = GET:InvokeServer("VIP", "Join", Join_Code)
                                                    
                                                    if (Joining ~= nil and Pressed_Saved == false) then
                                                        if (Joining == false) then
                                                            Join_Interact.Text = "INVALID"
                                                            
                                                        elseif (Joining == true) then
                                                            Pressed_Saved = true
                                                            
                                                            Join_Interact.Visible = false
                                                            
                                                            local Clone = Code:Clone()
                                                            
                                                            if (Clone ~= nil) then
                                                                Clone.Name, Clone.Size, Clone.Position, Clone.Text = "Title", UDim2.new(.8, 0, .6, 0), UDim2.new(.5, 0, .5, 0), "TELEPORTING"
                                                                
                                                                Clone.Parent = Join
                                                                
                                                                HostM:Notification(Interface, "Saved Data!", true)
                                                                
                                                                POST:FireServer("Save", "Avatar", Temporary_Data)
                                                                
                                                                HostM:Fade(Customisation, false, Customisation_Objects, true)
                                                                
                                                                HostM:Loading_Screen(Player, POST, GET, Interface, "Hub", nil)
                                                                
                                                                Setup_Teleport()
                                                            end
                                                        end
                                                    end
                                                end
                                            end)
                                            
                                            Set.MouseButton1Click:Connect(function()
                                                local Debounce = HostM:Debounce()
                                                
                                                local Hairs = Temporary_Data.Hairs
                                                
                                                local Index = (((Selected == "Primary" or New_Position ~= nil) and 1) or (Selected == "Secondary" and 2) or nil)
                                                
                                                if (Debounce ~= nil and Debounce == true and Hairs ~= nil and Index ~= nil) then
                                                    local Hair = Character:FindFirstChild("Hair - " .. Index)
                                                    
                                                    local Hair_Data = Hairs[Index]
                                                    
                                                    if (Hair ~= nil and Hair:IsA("Accessory") == true and Hair_Data ~= nil) then
                                                        local Colour = Colour.ImageColor3
                                                        
                                                        if (Colour ~= nil) then
                                                            local R, G, B = Colour.R, Colour.G, Colour.B
                                                            
                                                            if (R ~= nil and G ~= nil and B ~= nil) then
                                                                local H, S, V = Color3.new(R, G, B):ToHSV()
                                                                
                                                                if (H ~= nil and S ~= nil and V ~= nil) then
                                                                    local HSV = Color3.fromHSV(H, S, V)
                                                                    
                                                                    if (HSV ~= nil) then
                                                                        for _, Object in pairs(Hair:GetChildren()) do
                                                                            if ((Object.Name ~= "Bow" and Object.Name ~= "Fringe" and Object.Name ~= "Clip") and Object.Color ~= HSV) then
                                                                                Hair_Data.R, Hair_Data.G, Hair_Data.B, Hair_Data.Changed = H, S, V, true
                                                                                
                                                                                POST:FireServer("Customisation", "Colour", "Hair", HSV, Index)
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end)
                                            
                                            local Device = HostM.Last_Device
                                            
                                            if (Device ~= nil) then
                                                if (Console == true) then
                                                    local New_Name = GET:InvokeServer("Name", Player.Name)
                                                    
                                                    Box.Visible = false
                                                    
                                                    local Real = Identifier:FindFirstChild("Real")
                                                    
                                                    if (Real ~= nil) then
                                                        Real.Text = string.upper(New_Name)
                                                        
                                                        Real.Visible = true
                                                    end
                                                    
                                                    local __Name = Temporary_Data.Name
                                                    
                                                    if (__Name ~= nil) then
                                                        Temporary_Data.Name = Player.Name
                                                    end
                                                    
                                                elseif (Console == false) then
                                                    Box.FocusLost:Connect(function()
                                                        Update_Name(false)
                                                    end)
                                                end
                                            end
                                            
                                            UIS.InputChanged:Connect(function(Input)
                                                Colour_Movement(Input)
                                            end)
                                            
                                            UIS.InputEnded:Connect(function(Input)
                                                if (Input ~= nil) then
                                                    local Type = Input.UserInputType
                                                    
                                                    if (Type ~= nil and Type == Button_1) then
                                                        Holding, Moving = false, false
                                                    end
                                                end
                                            end)
                                            
                                            POST.OnClientEvent:Connect(function(Spins)
                                                Data.Spins = Spins
                                                
                                                Update_Spins(Spins)
                                            end)
                                            
                                            for _, Object in pairs(__Families:GetChildren()) do
                                                if (Object:IsA("TextLabel") == true) then
                                                    local Data = { Name = Object.Name; Class = "TextLabel"; Properties = { TextTransparency = 0 } }
                                                    
                                                    table.insert(Customisation_Objects, Data)
                                                end
                                            end
                                            
                                            wait(Delay - 1)
                                            
                                            Interface.Corner.Position = UDim2.new(.995, 0, .995, 0)
                                            
                                            wait(1)
                                            
                                            HostM:Fade(Customisation, true, Customisation_Objects)
                                            
                                            local Gradient = Deal:FindFirstChild("Gradient")
                                            
                                            if (Gradient ~= nil) then
                                                local Time, Range = 1, 10
                                                
                                                task.defer(function()
                                                    while (true) do
                                                        local Loop = tick() % Time / Time
                                                        
                                                        local Points = {}
                                                        
                                                        for Increment = Time, (Range + Time), Time do
                                                            local __Time = Color3.fromHSV(Loop - ((Increment - Time) / Range), Time, Time)
                                                            
                                                            if (__Time ~= nil and (Loop - ((Increment - Time) / Range)) < 0) then
                                                                __Time = Color3.fromHSV(((Loop - ((Increment - Time) / Range)) + Time), Time, Time)
                                                            end
                                                            
                                                            local Point = ColorSequenceKeypoint.new(((Increment - Time) / Range), __Time)
                                                            
                                                            if (Point ~= nil) then
                                                                table.insert(Points, (#Points + 1), Point)
                                                            end
                                                        end
                                                        
                                                        if (Points ~= nil and #Points > 0) then
                                                            Gradient.Color = ColorSequence.new(Points)
                                                        end
                                                        
                                                        RS.RenderStepped:Wait()
                                                    end
                                                end)
                                            end
                                            
                                            local Last = tick()
                                            
                                            RS.RenderStepped:Connect(function()
                                                if (Left_Arrow_Hold == true or Right_Arrow_Hold == true) then
                                                    local Time_Difference = (tick() - Last)
                                                    
                                                    if (Time_Difference ~= nil and Time_Difference >= Time) then
                                                        local Y = ((Left_Arrow_Hold == true and -15) or (Right_Arrow_Hold == true and 15))
                                                        
                                                        if (Y ~= nil) then
                                                            Last = tick()
                                                            
                                                            Rotate(Y)
                                                        end
                                                    end
                                                    
                                                elseif (Left_Arrow_Hold == false and Right_Arrow_Hold == false) then
                                                    Last = tick()
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                
                oldCheck(Success, Error)
            end)
        end
        
        for i = 2, 9 do -- excluding Main
            if game.PlaceId == whitelist[i] then
                oldOPS = hookfunction(HostM.Owns_Perk, function(Player, Perk)
	                return true;
                end)

                oldFamily = hookfunction(HostM.Owns_Family, function(Family)
                    return true
                end)
            end
        end

        for c = 5, 10 do -- missions only
            if game.PlaceId == whitelist[c] then
                oldGM = hookfunction(HostM.Gear_Multiplier, function(stat)
                    --[[ local newValue = 1;
                    local v2853, v2854 = pcall(function()
                        local Data = self.Data;
                        local Player = LP;
                        local Services = self.Services;
                        local Difficulty = self.Difficulty;
                        if stat ~= nil and Data ~= nil and Player ~= nil and Services ~= nil and Difficulty ~= nil and Difficulty ~= "Nightmare" then
                            local Avatar = Data.Avatar;
                            local Players = Services.P;
                            if Avatar ~= nil and Players ~= nil then
                                local Family = Avatar.Family;
                                if Family ~= nil then
                                    if Family == "Ackerman" then
                                        local v2862 = Player:GetAttribute("Bloodlust");
                                        if stat == "Damage" then
                                            newValue = 1.2;
                                        end;
                                        if v2862 ~= nil and v2862 == true then
                                            newValue = newValue + 0.5;
                                        end;
                                    elseif Family == "Braus" and stat == "Range" then
                                        newValue = 1.1;
                                    end;
                                    local Growth = true
                                    local Proficiency = true
                                    if Growth ~= nil and Proficiency ~= nil then
                                        if Growth == true then
                                            local Stack = 6;
                                            if Stack ~= nil and Stack > 0 then
                                                newValue = newValue + Stack * 0.05;
                                            end;
                                        end;
                                        if Proficiency == true then
                                            newValue = newValue + 1;
                                        end;
                                    end;
                                    if (stat == "Speed" or stat == "Damage") then
                                        if stat == "Speed" then
                                            newValue = newValue + 1;
                                        elseif stat == "Damage" then
                                            newValue = newValue + 1;
                                        end;
                                    end;
                                    local Solo = true;
                                    if Solo ~= nil and Solo == true then
                                        local SoloB = 0;
                                        for index, value in pairs(Players:GetPlayers()) do
                                            local Character = value.Character;
                                            if Character ~= nil then
                                                local Humanoid = Character:FindFirstChild("Humanoid");
                                                if Humanoid ~= nil and Humanoid.Health > 0 then
                                                    SoloB = SoloB + 1;
                                                end;
                                            end;
                                        end;
                                        if SoloB then
                                            newValue = newValue + 0.1;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end); ]]
                    return 1.5;
                end)

                oldKick = hookfunction(HostM.Kick, function(Player, POST, Message)
                    warn'tried to kick'
                    return
                end)

                HostM.Get_Upgrades = function(Upgrade_Name) -- supposed to grant all family perks
                    local Upgrades = 0

                    local Success, Error = pcall(function()
                        local Player_Data = HostM.Data
                        
                        if (Player_Data ~= nil) then
                            local Current, Player_Upgrades = Player_Data.Current, Player_Data.Upgrades
                            
                            if (Current ~= nil and Player_Upgrades ~= nil) then
                                if (Upgrade_Name:find("3DMG") ~= nil) then
                                    Upgrade_Name = string.gsub(Upgrade_Name, "3DMG", Current)
                                    
                                elseif (Upgrade_Name:find("APG") ~= nil) then
                                    Upgrade_Name = string.gsub(Upgrade_Name, "APG", Current)
                                    
                                elseif (Upgrade_Name:find("TP") ~= nil) then
                                    Upgrade_Name = string.gsub(Upgrade_Name, "TP", Current)
                                end

                                print('Upgrade_Name is', Upgrade_Name)
                                
                                for _, Upgrade_Data in pairs(Player_Upgrades) do
                                    local Name, Current = Upgrade_Data.Name, Upgrade_Data.Current
                                    
                                    if (Name ~= nil and Name == Upgrade_Name and Current ~= nil) then
                                        Upgrades = Current
                                        
                                        break
                                    end
                                end
                            end
                        end
                    end)
                    
                    HostM:Check(Success, Error)
                    
                    print('Upgrades is', Upgrades)
                    return 8
                end

                -- oldPhysics = hookfunction(HostM.Physics, function(Player, POST, Step, Character, Base_Settings, Humanoid, HumanoidRootPart)
                --     local Success, Error = pcall(function()
                --         local Data, Difficulty, Services, Gear, Cache, Velocities = HostM.Data, HostM.Difficulty, HostM.Services, HostM.Gear, HostM.Cache, HostM.Velocities
                        
                --         local Lerp_Speed, Quick_Delay = .025, .05
                        
                --         local Medium_Delay = (Quick_Delay * 15)
                        
                --         local Quick_Medium_Delay = (Medium_Delay / 4)
                        
                --         local Max_Delay = (Medium_Delay * 2)
                        
                --         local Base_Force, Max_Force = Vector3.new(0, 0, 0), Vector3.new((30000 / 2), (30000 / 2), (30000 / 2))
                        
                --         local Max_Magnitude, Minimum_Distance, Speed_Multiplier, Boost_Multiplier = 500, 7.5, 4, 1.05
                        
                --         local Base_Gravity = 85
                        
                --         local Behaviour, Freefall = Enum.MouseBehavior.LockCenter, Enum.HumanoidStateType.Freefall
                        
                --         local Minimum = 0
                        
                --         local Ignore_List = HostM:Ignore_List()
                        
                --         local Maximum_Speed = 500
                        
                --         local Skill_Holding = HostM.Skill_Holding
                        
                --         if (Player ~= nil and POST  ~= nil and Step ~= nil and Character ~= nil and Base_Settings ~= nil and Humanoid ~= nil and HumanoidRootPart ~= nil and Data ~= nil and Difficulty ~= nil and Services ~= nil and Gear ~= nil and Cache ~= nil and Velocities ~= nil and Behaviour ~= nil and Freefall ~= nil and Ignore_List ~= nil) then
                --             local Mouse = Player:GetMouse()
                            
                --             local Morph, Damaged = HostM:Morph(Player), Character:GetAttribute("Damaged")
                --             local Skill = Player:GetAttribute("Skill")
                            
                --             local Radius = Base_Settings.Remove_Range
                            
                --             local State, Move_Direction = Humanoid:GetState(), Humanoid.MoveDirection
                            
                --             local Avatar, D_Settings = Data.Avatar, Data.Settings
                            
                --             local UIS, W = Services.UIS, Services.W
                            
                --             local Equipped, Settings, Refill, Hooks, Swerves, Boosting, Backflip, Frontflip, Upflip, Left_Side, Right_Side, Running, Grab, Typing, Holds, Landing, Rolling, Escaped, G_Speed = Gear.Equipped, Gear.Settings, Gear.Refill, Gear.Hooks, Gear.Swerves, Gear.Boosting, Gear.Backflip, Gear.Frontflip, Gear.Upflip, Gear.Left_Side, Gear.Right_Side, Gear.Running, Gear.Grab, Gear.Typing, Gear.Holds, Gear.Landing, Gear.Rolling, Gear.Escaped, Gear.Speed
                            
                --             local C_Objects = Cache.Objects
                            
                --             local Swerve, Target_Swerve = Velocities.Swerve, Velocities.Target_Swerve
                            
                --             local Momentum = HumanoidRootPart.Velocity
                            
                --             local Can_Continue = true --((Damaged == nil) or (Damaged ~= nil and Damaged.Value == false and BG ~= nil and BV ~= nil) or (Damaged ~= nil and Damaged.Value == true and BG == nil and BV == nil))
                            
                --             if (Mouse ~= nil and Morph ~= nil and Radius ~= nil and State ~= nil and Move_Direction ~= nil and Avatar ~= nil and D_Settings ~= nil and Can_Continue == true and UIS ~= nil and W ~= nil and Equipped ~= nil and Settings ~= nil and Refill ~= nil and Hooks ~= nil and Swerves ~= nil and Boosting ~= nil and Backflip ~= nil and Frontflip ~= nil and Upflip ~= nil and Left_Side ~= nil and Right_Side ~= nil and Running ~= nil and Grab ~= nil and Typing ~= nil and Holds ~= nil and Landing ~= nil and Rolling ~= nil and Escaped ~= nil and G_Speed ~= nil and C_Objects ~= nil and Swerve ~= nil and Target_Swerve ~= nil and Momentum ~= nil) then
                --                 local Gas = Morph:FindFirstChild("Gas")
                                
                --                 local Family = Avatar.Family
                                
                --                 local Gameplay = D_Settings.Gameplay
                                
                --                 local Camera, Current_Gravity, Titans = W.CurrentCamera, math.floor(W.Gravity), W:FindFirstChild("Titans")
                                
                --                 local Equipping = Equipped.State
                                
                --                 local Speed, Range, Remove_Range, Delay, Gravity, Cooldown = Settings.Speed, Settings.Range, Settings.Remove_Range, Settings.Delay, Settings.Gravity, Settings.Cooldown
                                
                --                 local Refilling, Full_Refilling, Station = Refill.Refilling, Refill.Full_Refilling, Refill.Station
                                
                --                 local Left_Hook, Right_Hook, Midpoint, Hooked, Last_Change = Hooks.Left, Hooks.Right, Hooks.Midpoint, Hooks.Hooked, Hooks.Change
                                
                --                 local Left_Swerve, Right_Swerve, Change = Swerves.Left, Swerves.Right, Swerves.Change
                                
                --                 local Backflipping = Backflip.State
                                
                --                 local Frontflipping = Frontflip.State
                                
                --                 local Upflipping = Upflip.State
                                
                --                 local Left_Flipping, Right_Flipping = Left_Side.State, Right_Side.State
                                
                --                 local Grabbing, Grab_Pressed = Grab.Grabbing, Grab.Pressed
                                
                --                 local Left_Hold, Right_Hold = Holds.Left, Holds.Right
                                
                --                 local Speed_cFrame, Speed_Value = G_Speed.CFrame, G_Speed.Value
                                
                --                 local Magnitude = Momentum.Magnitude
                                
                --                 local BG, BV = C_Objects.BG, C_Objects.BV
                                
                --                 local Remove_Magnitude = (HumanoidRootPart.Position - Midpoint).Magnitude
                --                 local Grab_Magnitude = (Midpoint - Vector3.new(HumanoidRootPart.Position.X, Midpoint.Y, HumanoidRootPart.Position.Z)).Magnitude
                                
                --                 if (Gas ~= nil and Family ~= nil and Gameplay ~= nil and Camera ~= nil and Current_Gravity ~= nil and Titans ~= nil and Equipping ~= nil and Speed ~= nil and Range ~= nil and Remove_Range ~= nil and Delay ~= nil and Gravity ~= nil and Cooldown ~= nil and Refilling ~= nil and Full_Refilling ~= nil and Left_Hook ~= nil and Right_Hook ~= nil and Left_Swerve ~= nil and Right_Swerve ~= nil and Change ~= nil and Backflipping ~= nil and Frontflipping ~= nil and Upflipping ~= nil and Left_Flipping ~= nil and Right_Flipping ~= nil and Grab_Pressed ~= nil and Left_Hold ~= nil and Right_Hold ~= nil and Midpoint ~= nil and Last_Change ~= nil and Speed_cFrame ~= nil and Speed_Value ~= nil and Magnitude ~= nil and BG ~= nil and BV ~= nil and Remove_Magnitude ~= nil and Grab_Magnitude ~= nil) then
                --                     local Family_Speed_Multiplier = HostM:Gear_Multiplier("Speed")
                                    
                --                     local Last_Change_Difference = (tick() - Last_Change)
                                    
                --                     --[[ if (Speed > Maximum_Speed) then -- Speedster
                --                         Speed = Maximum_Speed
                --                     end *]]
                                    
                --                     if (Family_Speed_Multiplier ~= nil) then
                --                         Speed = (Speed * Family_Speed_Multiplier)
                --                     end
                                    
                --                     local Teleporting = HostM.Teleporting
                                    
                --                     if (Damaged == nil and Humanoid.Health > 0 and Teleporting ~= nil and Teleporting == false) then
                --                         BG.Parent, BV.Parent = HumanoidRootPart, HumanoidRootPart
                                        
                --                         if (Skill ~= nil and Skill ~= "Rising Thrust" and Skill ~= "Drilling Thrust" and Skill ~= "Boost" and Skill ~= "Loose Capsules" and Skill ~= "Self Heal" and Skill ~= "Healing Aura" and Skill ~= "Infinite Chain") then
                --                             BG.CFrame, BV.MaxForce = HumanoidRootPart.CFrame, Vector3.new(0, 0, 0)
                --                         end
                                        
                --                     elseif (HostM.Blown == nil) then
                --                         BG.Parent, BV.Parent = nil, nil
                --                     end
                                    
                --                     local Current_Gas = Gas:FindFirstChild("Current")
                                    
                --                     local cFrame_1, cFrame_2 = HumanoidRootPart.CFrame, (Camera.CFrame * cframenew(0, 1, 0))
                                    
                --                     local Gear_Speed = Speed_Value
                                    
                --                     if (Boosting == true) then
                --                         local Owns_Perk = HostM:Owns_Perk(Player, "Propulsion")
                                        
                --                         if (Owns_Perk ~= nil and Owns_Perk == true) then
                --                             Boost_Multiplier = (Boost_Multiplier * 1.15)
                --                         end
                                        
                --                         Gear_Speed = (Gear_Speed * Boost_Multiplier)
                --                     end
                                    
                --                     local Final_cFrame = cframenew(Speed, 0, 0)
                                    
                --                     local Left_Part, Right_Part = Left_Hook.Part, Right_Hook.Part
                --                     local Left_Position, Right_Position = Left_Hook.Position, Right_Hook.Position
                --                     local Left_Hitbox, Right_Hitbox = Left_Hook.Hitbox, Right_Hook.Hitbox
                --                     local Left_Pressed, Right_Pressed = Left_Hook.Pressed, Right_Hook.Pressed
                --                     local Left_Ending, Right_Ending = Left_Hook.Ending, Right_Hook.Ending
                                    
                --                     local Left_Swerving, Right_Swerving = Left_Swerve.State, Right_Swerve.State
                                    
                --                     local Change_Difference = (tick() - Change)
                                    
                --                     local Grab_Time_Difference = (tick() - Grab_Pressed)
                                    
                --                     local Continue = true
                                    
                --                     local function End(Grab, Left, Right, Skip)
                --                         if (Grab ~= nil and Left ~= nil and Right ~= nil) then
                --                             local Grabbed = false
                                            
                --                             if (Grab == true) then
                --                                 Grabbed = HostM:Grab(Player, POST, Character, HumanoidRootPart, Midpoint, Left_Hook, Right_Hook)
                --                             end
                                            
                --                             if (Grabbed == false) then
                --                                 if (Skip ~= nil and Skip == true) then
                --                                     Left, Right = true, true
                --                                 end
                                                
                --                                 if (Left == true) then
                --                                     HostM:Hook(Player, POST, { Hook = "Left"; State = "Passive" })
                --                                 end
                                                
                --                                 if (Right == true) then
                --                                     HostM:Hook(Player, POST, { Hook = "Right"; State = "Passive" })
                --                                 end
                --                             end
                                            
                --                             if (Left == false and Right == false) then
                --                                 Continue = false
                --                             end
                --                         end
                --                     end
                                    
                --                     if ((Left_Part ~= nil or Right_Part ~= nil) and (Damaged ~= nil or Humanoid.Health <= 0 or Skill ~= nil)) then
                --                         End(false, true, true)
                --                     end
                                    
                --                     local Mouse_Hit = Mouse.Hit
                                    
                --                     local Skill = Player:GetAttribute("Skill")
                                    
                --                     if (Skill ~= nil and (Skill == "Counter" or Skill == "Loose_Capsules" or Skill == "Self_Heal" or Skill == "Healing_Aura" or Skill == "Infinite_Chain")) then
                --                         Skill = nil
                --                     end
                                    
                --                     if (Current_Gas ~= nil and cFrame_1 ~= nil and cFrame_2 ~= nil and Gear_Speed ~= nil and Speed_cFrame ~= nil and Left_Pressed ~= nil and Right_Pressed ~= nil and Left_Ending ~= nil and Right_Ending ~= nil and Left_Swerving ~= nil and Right_Swerving ~= nil and Change_Difference ~= nil and Grab_Time_Difference ~= nil) then
                --                         local Movement_Direction = cFrame_1:VectorToObjectSpace(Move_Direction).Unit
                                        
                --                         local LookVector = cFrame_2.LookVector
                                        
                --                         local Left_Time_Difference, Right_Time_Difference = (tick() - Left_Pressed), (tick() - Right_Pressed)
                                        
                --                         if (Movement_Direction ~= nil and LookVector ~= nil and Left_Time_Difference ~= nil and Right_Time_Difference ~= nil) then
                --                             local Final_cFrame = cframenew(Speed, 0, 0)
                                            
                --                             local X, Z = Movement_Direction.X, Movement_Direction.Z
                                            
                --                             if (X ~= nil and Z ~= nil) then
                --                                 local Backwards = ((Z > 0 and math.abs(X) <= math.abs(Z)) or ((X >= 0 or X < 0) and math.abs(Z) <= math.abs(X)))
                                                
                --                                 local  __Target_Swerve, Velocity_1, Velocity_2 = HostM:Constants(Medium_Delay, Boosting, Swerve, Target_Swerve, BV, Speed, Left_Position, Right_Position, Change_Difference)
                                                
                --                                 if (Backwards ~= nil and Speed ~= nil and __Target_Swerve ~= nil and Velocity_1 ~= nil and Velocity_2 ~= nil) then
                --                                     local Values = { [1] = __Target_Swerve; [2] = Velocity_1, [3] = Velocity_2 }
                
                --                                     HostM:Updater(Step, Grabbing, Values)
                                                    
                --                                     local Kick, Type = false, ""
                                                    
                --                                     for Index, Value in pairs(Base_Settings) do
                --                                         local Setting = Settings[Index]
                                                        
                --                                         if (Setting ~= nil) then
                --                                             local Range_Multiplier = HostM:Gear_Multiplier("Range")
                                                            
                --                                             if ((Index == "Remove_Range" and (Radius * Range_Multiplier) < (Setting * Range_Multiplier)) or (Index ~= "Remove_Range" and Value ~= Setting)) then
                --                                                 Kick, Type = true, Index
                                                                
                --                                                 break
                --                                             end
                --                                         end
                --                                     end
                                                    
                --                                     Gravity = (((Left_Position ~= nil or Right_Position ~= nil or Left_Time_Difference <= Max_Delay or Right_Time_Difference <= Max_Delay) and Base_Gravity) or (Base_Gravity * 1.4))
                                                    
                --                                     if (Current_Gravity ~= Gravity) then
                --                                         -- Kick, Type = true, "Gravity"
                                                        
                --                                         W.Gravity = Gravity
                --                                     end
                                                    
                --                                     if (Kick == true) then
                --                                         -- HostM:Kick(Player, POST, Type)
                --                                     end
                                                    
                --                                     if ((Left_Position == nil and Right_Position == nil) or (Left_Ending == true and Right_Ending == true)) then
                --                                         local Velocity, Divider = nil, nil
                                                        
                --                                         local __Delay = (Delay * 3)
                                                        
                --                                         G_Speed.CFrame = cframenew(0, 0, 0)
                                                        
                --                                         if (Escaped == true) then
                --                                             Velocity, Divider = (cframenew(HumanoidRootPart.Position).UpVector * 225), 1
                                                            
                --                                         elseif (Backflipping == true) then
                --                                             local __Velocity = HumanoidRootPart.Velocity
                                                            
                --                                             if (__Velocity ~= nil) then
                --                                                 local Speed = (Speed / Speed_Multiplier)
                                                                
                --                                                 local Increment_Y = 0
                                                                
                --                                                 if (__Velocity.Y < 0 and State == Freefall) then
                --                                                     Increment_Y = __Velocity.Y
                                                                    
                --                                                     HumanoidRootPart.Velocity = Vector3.new(__Velocity.X, -(Increment_Y / 3), __Velocity.Z)
                --                                                 end
                                                                
                --                                                 local Owns_Perk = HostM:Owns_Perk(Player, "Parkour Master")
                                                                
                --                                                 if (Owns_Perk ~= nil and Owns_Perk == true) then
                --                                                     Speed = (Speed * 1.25)
                --                                                 end
                                                                
                --                                                 Velocity, Divider = ((cFrame_1.LookVector * -(Speed * 2.5)) + (cFrame_1.UpVector * ((Speed + Increment_Y) * 1.5))), 1
                                                                
                --                                                 if (State ~= Freefall) then
                --                                                     Velocity = ((cFrame_1.LookVector * -(Speed * 2.5)) + (cFrame_1.UpVector * (Speed * .65)))
                                                                    
                --                                                     BV.MaxForce = Max_Force
                --                                                 end
                --                                             end
                                                            
                --                                         elseif (Frontflipping == true) then
                --                                             local __Velocity = HumanoidRootPart.Velocity
                                                            
                --                                             if (__Velocity ~= nil) then
                --                                                 local Speed = (Speed / Speed_Multiplier)
                                                                
                --                                                 local Increment_Y = 0
                                                                
                --                                                 if (__Velocity.Y < 0 and State == Freefall) then
                --                                                     Increment_Y = __Velocity.Y
                                                                    
                --                                                     HumanoidRootPart.Velocity = Vector3.new(__Velocity.X, -(Increment_Y / 3), __Velocity.Z)
                --                                                 end
                                                                
                --                                                 local Owns_Perk = HostM:Owns_Perk(Player, "Parkour Master")
                                                                
                --                                                 if (Owns_Perk ~= nil and Owns_Perk == true) then
                --                                                     Speed = (Speed * 1.25)
                --                                                 end
                                                                
                --                                                 Velocity, Divider = ((cFrame_1.LookVector * (Speed * 2.5)) + (cFrame_1.UpVector * ((Speed + Increment_Y) * 1.5))), 1
                                                                
                --                                                 if (State ~= Freefall) then
                --                                                     Velocity = ((cFrame_1.LookVector * (Speed * 2.5)) + (cFrame_1.UpVector * (Speed * .65)))
                                                                    
                --                                                     BV.MaxForce = Max_Force
                --                                                 end
                --                                             end
                                                            
                --                                         elseif (Upflipping == true) then
                --                                             local __Velocity = HumanoidRootPart.Velocity
                                                            
                --                                             if (__Velocity ~= nil) then
                --                                                 local Speed = (Speed / Speed_Multiplier)
                                                                
                --                                                 local Increment_Y = 0
                                                                
                --                                                 if (__Velocity.Y < 0 and State == Freefall) then
                --                                                     Increment_Y = __Velocity.Y
                --                                                 end
                                                                
                --                                                 local Owns_Perk = HostM:Owns_Perk(Player, "Parkour Master")
                                                                
                --                                                 if (Owns_Perk ~= nil and Owns_Perk == true) then
                --                                                     Speed = (Speed * 1.25)
                --                                                 end
                                                                
                --                                                 Velocity, Divider = (cFrame_1.UpVector * ((Speed + Increment_Y) * 2)), 1
                                                                
                --                                                 if (State ~= Freefall) then
                --                                                     Velocity = (cFrame_1.UpVector * (Speed * 1.25))
                --                                                 end
                                                                
                --                                                 BV.MaxForce = Max_Force
                --                                             end
                                                            
                --                                         elseif (Left_Flipping == true) then
                --                                             local __Velocity = HumanoidRootPart.Velocity
                                                            
                --                                             if (__Velocity ~= nil) then
                --                                                 local Speed = (Speed / Speed_Multiplier)
                                                                
                --                                                 local Increment_Y = 0
                                                                
                --                                                 if (__Velocity.Y < 0 and State == Freefall) then
                --                                                     Increment_Y = __Velocity.Y
                                                                    
                --                                                     HumanoidRootPart.Velocity = Vector3.new(__Velocity.X, -(Increment_Y / 3), __Velocity.Z)
                --                                                 end
                                                                
                --                                                 local Owns_Perk = HostM:Owns_Perk(Player, "Parkour Master")
                                                                
                --                                                 if (Owns_Perk ~= nil and Owns_Perk == true) then
                --                                                     Speed = (Speed * 1.25)
                --                                                 end
                                                                
                --                                                 Velocity, Divider = ((cFrame_1.RightVector * -(Speed * 2.5)) + (cFrame_1.UpVector * ((Speed + Increment_Y) * 1.5))), 1
                                                                
                --                                                 if (State ~= Freefall) then
                --                                                     Velocity = ((cFrame_1.RightVector * -(Speed * 2.5)) + (cFrame_1.UpVector * (Speed * .65)))
                                                                    
                --                                                     BV.MaxForce = Max_Force
                --                                                 end
                --                                             end
                                                            
                --                                         elseif (Right_Flipping == true) then
                --                                             local __Velocity = HumanoidRootPart.Velocity
                                                            
                --                                             if (__Velocity ~= nil) then
                --                                                 local Speed = (Speed / Speed_Multiplier)
                                                                
                --                                                 local Increment_Y = 0
                                                                
                --                                                 if (__Velocity.Y < 0 and State == Freefall) then
                --                                                     Increment_Y = __Velocity.Y
                                                                    
                --                                                     HumanoidRootPart.Velocity = Vector3.new(__Velocity.X, -(Increment_Y / 3), __Velocity.Z)
                --                                                 end
                                                                
                --                                                 local Owns_Perk = HostM:Owns_Perk(Player, "Parkour Master")
                                                                
                --                                                 if (Owns_Perk ~= nil and Owns_Perk == true) then
                --                                                     Speed = (Speed * 1.25)
                --                                                 end
                                                                
                --                                                 Velocity, Divider = ((cFrame_1.RightVector * (Speed * 2.5)) + (cFrame_1.UpVector * ((Speed + Increment_Y) * 1.5))), 1
                                                                
                --                                                 if (State ~= Freefall) then
                --                                                     Velocity = ((cFrame_1.RightVector * -(Speed * 2.5)) + (cFrame_1.UpVector * (Speed * .65)))
                                                                    
                --                                                     BV.MaxForce = Max_Force
                --                                                 end
                --                                             end
                                                            
                --                                         elseif (Boosting == true and Left_Time_Difference >= Max_Delay and Right_Time_Difference >= Max_Delay) then
                --                                             local cFrame_2 = (cFrame_2 * cframenew(0, 0, 1))
                                                            
                --                                             local cFrame = cframenew(cFrame_1.Position)
                                                            
                --                                             if (cFrame_1.Position == cFrame_2.Position) then
                --                                                 cFrame = cframenew(cFrame_1.Position)
                                                            
                --                                             elseif (cFrame_1.Position ~= cFrame_2.Position) then
                --                                                 cFrame = cframenew(cFrame_1.Position, cFrame_2.Position)
                --                                             end
                                                            
                --                                             if (cFrame ~= nil) then
                --                                                 local Scalar = ((Speed / Speed_Multiplier) * 1.4)
                                                                
                --                                                 if (Scalar ~= nil) then
                --                                                     Velocity, Divider = ((cFrame.LookVector * -Scalar) + (cFrame_2.UpVector * -5)), 1
                                                                    
                --                                                     Continue = false
                                                                    
                --                                                     HostM:Gas_Usage(POST, Left_Position, Right_Position, Boosting, false)
                --                                                 end
                --                                             end
                                                            
                --                                         elseif (Grab_Time_Difference > __Delay) then
                --                                             Magnitude = math.clamp(Magnitude, 1, Max_Magnitude)
                                                            
                --                                             if (Rolling == false) then
                --                                                 Velocity, Divider = (cFrame_1.LookVector * Magnitude--[[) + (cFrame_2.UpVector * -(Magnitude / 2.5)--]]), 70
                                                                
                --                                             elseif (Rolling == true) then
                --                                                 local Held_Velocity = HostM.Held_Velocity
                                                                
                --                                                 if (Held_Velocity == nil) then
                --                                                     local Multiplier = ((math.abs(BV.Velocity.X) + math.abs(BV.Velocity.Z)) / 2)
                                                                    
                --                                                     Velocity, Divider = (cFrame_1.LookVector * Multiplier), 1
                                                                    
                --                                                     HostM.Held_Velocity = Multiplier
                                                                    
                --                                                 elseif (Held_Velocity ~= nil) then
                --                                                     Velocity, Divider = (cFrame_1.LookVector * Held_Velocity), 1
                                                                    
                --                                                     -- HostM:Shake(1)
                --                                                 end
                --                                             end
                --                                         end
                                                        
                --                                         local Knockback, Upwards = HostM.Knockback, false
                                                        
                --                                         if (Knockback ~= nil and Knockback == true) then
                --                                             local Current = Data.Current
                                                            
                --                                             if (Current ~= nil) then
                --                                                 if (Current == "APG") then
                --                                                     --HumanoidRootPart.Velocity = ((HumanoidRootPart.Velocity + (cFrame_1.LookVector * -20)) + (cFrame_1.UpVector * 35))
                                                                    
                --                                                     Upwards = true
                                                                    
                --                                                 elseif (Current == "3DMG") then
                --                                                     --HumanoidRootPart.Velocity = (HumanoidRootPart.Velocity + (cFrame_1.LookVector * 30))
                --                                                 end
                --                                             end
                                                            
                --                                             Divider = 1
                --                                         end
                                                        
                --                                         HostM:Ungrab(Player, POST)
                                                        
                --                                         if (Velocity ~= nil and Divider ~= nil and Divider >= 1 and HostM.Blown == nil) then
                --                                             if (Velocity ~= Velocity) then
                --                                                 print("NaN Velocity")
                                                                
                --                                             elseif (Velocity == Velocity) then
                --                                                 local BP = HumanoidRootPart:FindFirstChild("Skill_BP")
                                                                
                --                                                 if (Skill == nil and BP ~= nil) then
                --                                                     BP:Destroy()
                --                                                 end
                                                                
                --                                                 if (Skill ~= nil and Skill_Holding == true) then
                --                                                     --BG.CFrame = cframenew(HumanoidRootPart.Position, Vector3.new(Mouse_Hit.Position.X, HumanoidRootPart.Position.Y, Mouse_Hit.Position.Z))
                                                                    
                --                                                     if (BP == nil and Skill:find("Blade") == nil and Skill ~= "Loose_Capsules" and Skill ~= "Self_Heal" and Skill ~= "Healing_Aura" and Skill ~= "Infinite_Chain") then
                --                                                         HumanoidRootPart.CFrame = HumanoidRootPart.CFrame
                                                                        
                --                                                         BP = Instance.new("BodyPosition")
                                                                        
                --                                                         BP.Name, BP.Position, BP.P, BP.D = "Skill_BP", HumanoidRootPart.Position, 100, 100000
                                                                        
                --                                                         BP.Parent = HumanoidRootPart
                --                                                     end
                                                                    
                --                                                 elseif (Full_Refilling == false and ((HostM.Coordinates.Lock == true or Skill ~= nil or Backwards == true or UIS.MouseBehavior == Behaviour or Left_Time_Difference <= __Delay or Right_Time_Difference <= __Delay) or (Move_Direction ~= Vector3.new(0, 0, 0))) and Mouse_Hit ~= nil) then
                --                                                     local Offset = Vector3.new(LookVector.X, 0, LookVector.Z)
                                                                    
                --                                                     local Look_At = (HumanoidRootPart.Position + Offset)
                                                                    
                --                                                     if (HumanoidRootPart.Position ~= Look_At and BG ~= nil) then
                --                                                         local Aiming = HostM.Aiming
                                                                        
                --                                                         if (Aiming ~= nil) then
                --                                                             BG.CFrame = Aiming
                                                                            
                --                                                         elseif (Rolling == false and (HostM.Coordinates.Lock == true or Humanoid.MoveDirection ~= Vector3.new(0, 0, 0))) then
                --                                                             BG.CFrame = cframenew(HumanoidRootPart.Position, Look_At)
                --                                                         end
                --                                                     end
                                                                    
                --                                                 elseif (Full_Refilling == true and Station ~= nil) then
                --                                                     local Hitbox = Station:FindFirstChild("Hitbox")
                                                                    
                --                                                     if (Hitbox ~= nil) then
                --                                                         local Look_At = Vector3.new(Hitbox.Position.X, HumanoidRootPart.Position.Y, Hitbox.Position.Z)
                                                                        
                --                                                         if (Rolling == false and HumanoidRootPart.Position ~= Look_At and BG ~= nil and BG.Parent == HumanoidRootPart) then
                --                                                             BG.CFrame = cframenew(HumanoidRootPart.Position, Look_At)
                --                                                         end
                --                                                     end
                --                                                 end
                                                                
                --                                                 --HumanoidRootPart.Anchored = (((Station ~= nil and Full_Refilling == true) == true) or false)
                                                                
                --                                                 local Base_Speed, Base_Jump = 16, 50
                                                                
                --                                                 if (Difficulty == nil or Damaged ~= nil or Landing == true or Rolling == true or Full_Refilling == true) then
                --                                                     Base_Speed, Base_Jump = 0, 0
                --                                                 end
                                                                
                --                                                 local Owns_Perk = HostM:Owns_Perk(Player, "Lightweight")
                                                                
                --                                                 if (Owns_Perk ~= nil and Owns_Perk == true) then
                --                                                     Base_Speed = (Base_Speed * 1.2)
                --                                                 end
                                                                
                --                                                 local Owns_Galliard = HostM:Owns_Family("Galliard")
                                                                
                --                                                 if (Owns_Galliard ~= nil and Owns_Galliard == true) then
                --                                                     Base_Speed = (Base_Speed * 1.5)
                --                                                 end
                                                                
                --                                                 local Smith_Stackable_Multiplier = HostM:Owns_Stackable_Family(Player, "Smith")
                                                                
                --                                                 if (Smith_Stackable_Multiplier ~= nil) then
                --                                                     Base_Speed = (Base_Speed * Smith_Stackable_Multiplier)
                --                                                 end
                                                                
                --                                                 local Owns_Perk = HostM:Owns_Perk(Player, "Willpower")
                                                                
                --                                                 if (Owns_Perk ~= nil) then
                --                                                     local Bloodlust = Player:GetAttribute("Bloodlust")
                                                                    
                --                                                     if ((Family == "Ackerman" and Bloodlust ~= nil and Bloodlust == true) or Owns_Perk == true or Family == "Galliard") then
                --                                                         --
                                                                        
                --                                                     else
                --                                                         Base_Speed = (Base_Speed * (Humanoid.Health / Humanoid.MaxHealth))
                --                                                     end
                --                                                 end
                                                                
                --                                                 if (Skill ~= nil or Humanoid.Health <= 0) then
                --                                                     Base_Speed, Base_Jump = 0, 0
                --                                                 end
                                                                
                --                                                 local Speed = ((Running == false and Base_Speed) or (Running == true and (Base_Speed * 2.3)))
                                                                
                --                                                 Humanoid.WalkSpeed, Humanoid.JumpPower = Speed, Base_Jump
                                                                
                --                                                 if (BV ~= nil) then
                --                                                     if (Damaged == nil) then
                --                                                         if (Skill ~= nil and Skill_Holding == false and (Skill == "Drilling_Thrust" or Skill == "Rising_Thrust" or Skill == "Boost")) then
                --                                                             BV.MaxForce = Max_Force
                                                                            
                --                                                             local Speed_Upgrades = HostM:Get_Upgrades("3DMG Speed")
                                                                            
                --                                                             if (Speed_Upgrades ~= nil) then
                --                                                                 if (Skill == "Drilling_Thrust") then
                --                                                                     local Aiming = HostM.Aiming
                                                                                    
                --                                                                     if (Aiming == nil) then
                --                                                                         HostM.Aiming = Mouse_Hit
                                                                                        
                --                                                                     elseif (Aiming ~= nil) then
                --                                                                         BV.MaxForce = Max_Force
                                                                                        
                --                                                                         BV.Velocity = (Aiming.LookVector * (175 + (Speed_Upgrades * 15)))
                --                                                                     end
                                                                                    
                --                                                                 elseif (Skill == "Rising_Thrust") then
                --                                                                     BV.MaxForce = Max_Force
                                                                                    
                --                                                                     BV.Velocity = (HumanoidRootPart.CFrame.UpVector * (120 + (Speed_Upgrades * 5)))
                                                                                    
                --                                                                 elseif (Skill == "Boost") then
                --                                                                     local Aiming = HostM.Aiming
                                                                                    
                --                                                                     if (Aiming == nil) then
                --                                                                         HostM.Aiming = Mouse_Hit
                                                                                        
                --                                                                     elseif (Aiming ~= nil) then
                --                                                                         BV.MaxForce = Max_Force
                                                                                        
                --                                                                         BV.Velocity = (Aiming.LookVector * (500 + (Speed_Upgrades * 60)))
                                                                                        
                --                                                                         HostM.Boost_Delay = tick()
                                                                                        
                --                                                                         -- HostM:Shake(5)
                --                                                                     end
                --                                                                 end
                --                                                             end
                                                                            
                --                                                         else
                --                                                             local Current_Force, Medium_Force = BV.MaxForce, (Max_Force / 5)
                                                                            
                --                                                             local Increase = (Backflipping == true or Frontflipping == true or Upflipping == true or Left_Flipping == true or Right_Flipping == true or Boosting == true or (Left_Time_Difference <= Delay) or (Right_Time_Difference <= Delay))
                                                                            
                --                                                             if (Increase ~= nil) then
                --                                                                 local X = ((Escaped == true and Max_Force.X) or (Increase == false and Current_Force.X) or (Increase == true and Medium_Force.X))
                --                                                                 local Y = (((Upwards == false and Escaped == false) and Current_Force.Y) or ((Upwards == true or Escaped == true) and Max_Force.Y))
                --                                                                 local Z = ((Escaped == true and Max_Force.Z) or (Increase == false and Current_Force.Z) or (Increase == true and Medium_Force.Z))
                                                                                
                --                                                                 Y = (Y / Divider)
                                                                                
                --                                                                 BV.MaxForce = Vector3.new(X, Y, Z)
                                                                                
                --                                                                 Lerp_Speed = (Lerp_Speed * 1.25)
                                                                                
                --                                                                 local Base_Force = Base_Force
                                                                                
                --                                                                 if (HostM.Blown == true) then
                --                                                                     Base_Force = Max_Force
                --                                                                 end
                                                                                
                --                                                                 BV.MaxForce = BV.MaxForce:Lerp(Base_Force, Lerp_Speed)
                                                                                
                --                                                                 local Magnitude = Velocity.Magnitude
                                                                                
                --                                                                 local Held_Velocity = HostM.Held_Velocity
                                                                                
                --                                                                 if (Held_Velocity == nil and Skill ~= nil and Skill ~= "Counter" and Skill ~= "Loose_Capsules" and Skill ~= "Self_Heal" and Skill ~= "Healing_Aura" and Skill ~= "Infinite_Chain" and Velocity ~= nil) then
                --                                                                     HostM.Held_Velocity = Velocity
                                                                                    
                --                                                                 elseif (Rolling == false and Held_Velocity ~= nil and (Skill == nil or (Skill == "Counter" or Skill == "Loose_Capsules" or Skill == "Self_Heal" or Skill == "Healing_Aura" or Skill == "Infinite_Chain"))) then
                --                                                                     Velocity = Held_Velocity
                                                                                    
                --                                                                     BV.MaxForce, Lerp_Speed = Max_Force, 1
                                                                                    
                --                                                                     HostM.Held_Velocity, HostM.Aiming = nil, nil
                --                                                                 end
                                                                                
                --                                                                 if (Rolling == true) then
                --                                                                     local Maximum = 2
                                                                                    
                --                                                                     local Last_Fall = Gear.Last_Fall
                                                                                    
                --                                                                     local Time_Difference = (tick() - Last_Fall)
                                                                                    
                --                                                                     Lerp_Speed = (Maximum - Time_Difference)
                                                                                    
                --                                                                     BV.MaxForce = Vector3.new((Max_Force.X * Lerp_Speed), 0, (Max_Force.Z * Lerp_Speed))
                                                                                    
                --                                                                     HumanoidRootPart.Anchored = false
                --                                                                 end
                                                                                
                --                                                                 if (type(Velocity) == "vector") then
                --                                                                     BV.Velocity = BV.Velocity:Lerp(Velocity, Lerp_Speed)
                --                                                                 end
                --                                                             end
                --                                                         end
                                                                        
                --                                                     elseif (Damaged ~= nil and HostM.Blown == nil) then
                --                                                         BV.MaxForce, BV.Velocity = Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
                --                                                     end
                --                                                 end
                --                                             end
                --                                         end
                                                        
                --                                     elseif ((Left_Part ~= nil or Right_Part ~= nil) and (Left_Position ~= nil or Right_Position ~= nil) and (Left_Ending == false or Right_Ending == false)) then
                --                                         local Multiplier = ((Boosting == false and 1) or (Boosting == true and 2))
                                                        
                --                                         if (Multiplier ~= nil) then
                --                                             local S_Lerp_Speed = (((Left_Hitbox ~= nil and Right_Hitbox ~= nil) and .2) or ((Left_Hitbox ~= nil or Right_Hitbox ~= nil) and .1) or 0)
                                                            
                --                                             if (S_Lerp_Speed ~= nil and S_Lerp_Speed > 0) then
                --                                                 S_Lerp_Speed = (S_Lerp_Speed * Multiplier)
                                                                
                --                                                 HostM:Gas_Usage(POST, Left_Position, Right_Position, Boosting, false)
                                                                
                --                                                 G_Speed.CFrame = Speed_cFrame:Lerp(Final_cFrame, S_Lerp_Speed)
                                                                
                --                                                 local New_cFrame = G_Speed.CFrame
                                                                
                --                                                 if (New_cFrame ~= nil) then
                --                                                     G_Speed.Value = New_cFrame.X
                                                                    
                --                                                     local Is_Titan_Part = false
                                                                    
                --                                                     if ((Left_Part ~= nil and Left_Part:IsDescendantOf(Titans) == true) or (Right_Part ~= nil and Right_Part:IsDescendantOf(Titans) == true)) then
                --                                                         Is_Titan_Part = true
                --                                                     end
                                                                    
                --                                                     if (Is_Titan_Part ~= nil) then
                --                                                         local Multiplier = ((Is_Titan_Part == false and 1) or (Is_Titan_Part == true and 2))
                                                                        
                --                                                         if (Multiplier ~= nil) then
                --                                                             local Max_Magnitude = (2.5 * Multiplier)
                                                                            
                --                                                             local __Continue = true
                                                                            
                --                                                             local Left, Right = true, true
                                                                            
                --                                                             if (Data.Current == "TP" and (Gear.Launch.Launching == true or Gear.Launch.Triggering == true)) then
                --                                                                 if ((Gear.Launch.Combo == "Left" and Gear.Hooks.Left.Part ~= nil) or (Gear.Launch.Combo == "Right" and Gear.Hooks.Right.Part ~= nil)) then
                --                                                                     __Continue = false
                                                                                    
                --                                                                     Left, Right = (Gear.Launch.Combo == "Left"), (Gear.Launch.Combo == "Right")
                --                                                                 end
                --                                                             end
                                                                            
                --                                                             if (Humanoid.Health <= 0 or Damaged ~= nil or Landing == true or Rolling == true or (__Continue == false and (Left == true or Right == true)) or Equipping == false or Refilling == true or Current_Gas.Value <= Minimum or Remove_Magnitude > Remove_Range) then
                --                                                                 End(false, Left, Right)
                                                                                
                --                                                             elseif (Grabbing == true and Grab_Time_Difference >= Cooldown) then
                --                                                                 HostM:Ungrab(Player, POST)
                                                                                
                --                                                             elseif (Grabbing == false and Grab_Magnitude <= Max_Magnitude) then
                --                                                                 local Left_Continue, Right_Continue = false, false
                                                                                
                --                                                                 if (Left_Position == nil or (Left_Position ~= nil and Left_Part ~= nil)) then
                --                                                                     Left_Continue = true
                --                                                                 end
                                                                                
                --                                                                 if (Right_Position == nil or (Right_Position ~= nil and Right_Part ~= nil)) then
                --                                                                     Right_Continue = true
                --                                                                 end
                                                                                
                --                                                                 if (Left_Continue == true and Right_Continue == true) then
                --                                                                     End(true, false, false, true)
                --                                                                 end
                                                                                
                --                                                             elseif (Typing == false and (Left_Hold == false or Right_Hold == false)) then
                --                                                                 End(false, (not Left_Hold), (not Right_Hold))
                --                                                             end
                                                                            
                --                                                             if (Continue == true) then
                --                                                                 if (HostM.Devices.Computer == true or HostM.Devices.Console == true) then
                --                                                                     Humanoid.WalkSpeed, Humanoid.JumpPower = 0, 0
                --                                                                 end
                                                                                
                --                                                                 if (Boosting == true) then
                --                                                                     Lerp_Speed = (Lerp_Speed * 2.5)
                --                                                                 end
                                                                                
                --                                                                 if (Change_Difference <= Quick_Medium_Delay) then
                --                                                                     Lerp_Speed = (Lerp_Speed / 4)
                --                                                                 end
                                                                                
                --                                                                 if (BV ~= nil) then
                --                                                                     BV.MaxForce = BV.MaxForce:Lerp(Max_Force, Lerp_Speed)
                --                                                                 end
                                                                                
                --                                                                 if (HostM.Gear.Hooks.Left.Hitbox ~= nil or HostM.Gear.Hooks.Right.Hitbox ~= nil) and HostM.Gear.Hooks.Left.Ending == false and HostM.Gear.Hooks.Right.Ending == false and (HostM.Gear.Hooks.Left.Position ~= nil or HostM.Gear.Hooks.Right.Position ~= nil) then
                --                                                                     local Left_Position, Right_Position = ((Left_Hitbox ~= nil and Left_Hitbox.Position) or nil), ((Right_Hitbox ~= nil and Right_Hitbox.Position) or nil)
                                                                                    
                --                                                                     local function Find_Pointer(Type, Hitbox)
                --                                                                         if (Type ~= nil and Hitbox ~= nil) then
                --                                                                             local Pointer = Hitbox:FindFirstChild("Pointer")
                                                                                            
                --                                                                             if (Pointer ~= nil) then
                --                                                                                 local A = Pointer.Value
                                                                                                
                --                                                                                 if (A ~= nil) then
                --                                                                                     if (Type == "Left") then
                --                                                                                         Left_Position = A.WorldPosition
                                                                                                        
                --                                                                                     elseif (Type == "Right") then
                --                                                                                         Right_Position = A.WorldPosition
                --                                                                                     end
                --                                                                                 end
                --                                                                             end
                --                                                                         end
                --                                                                     end
                                                                                    
                --                                                                     Find_Pointer("Left", Left_Hitbox)
                --                                                                     Find_Pointer("Right", Right_Hitbox)
                                                                                    
                --                                                                     if (Left_Position == nil or Right_Position == nil) then
                --                                                                         Midpoint = ((Left_Position ~= nil and Left_Position) or (Right_Position ~= nil and Right_Position))
                                                                                        
                --                                                                     elseif (Left_Position ~= nil and Right_Position ~= nil) then
                --                                                                         if (Left_Position == Right_Position) then
                --                                                                             Midpoint = Left_Position
                                                                                            
                --                                                                         elseif (Left_Position ~= Right_Position) then
                --                                                                             local cFrame = cframenew(Left_Position, Right_Position)
                                                                                            
                --                                                                             local Distance = ((Left_Position - Right_Position).Magnitude / 2)
                                                                                            
                --                                                                             local Position = (cFrame + (cFrame.LookVector * Distance)).Position
                                                                                            
                --                                                                             Midpoint = Position
                --                                                                         end
                --                                                                     end
                                                                                    
                --                                                                     Hooks.Midpoint = Midpoint
                --                                                                 end
                                                                                
                --                                                                 local V_1, V_2 = Midpoint, Midpoint
                                                                                
                --                                                                 local Look_At = cframenew(0, 0, 0)
                                                                                
                --                                                                 local Distance = (V_1 - HumanoidRootPart.Position).Magnitude
                                                                                
                --                                                                 local Look_Vector = (V_1 - HumanoidRootPart.Position)
                --                                                                 local Look_Vector_2 = (V_2 - HumanoidRootPart.Position)
                                                                                
                --                                                                 if (V_1 == HumanoidRootPart.Position) then
                --                                                                     Look_Vector = V_1
                --                                                                 end
                                                                                
                --                                                                 if (V_2 == HumanoidRootPart.Position) then
                --                                                                     Look_Vector_2 = V_2
                --                                                                 end
                                                                                
                --                                                                 local Look_Vector = Look_Vector.Unit
                --                                                                 local Look_Vector_2 = Look_Vector_2.Unit
                                                                                
                --                                                                 local Right_Vector = Look_Vector:Cross(Vector3.new(0, 1, 0))
                --                                                                 local Right_Vector_2 = Look_Vector_2:Cross(Vector3.new(0, 1, 0))
                                                                                
                --                                                                 local Up_Vector = Right_Vector:Cross(Look_Vector)
                --                                                                 local Up_Vector_2 = Right_Vector_2:Cross(Look_Vector_2)
                                                                                
                --                                                                 local cFrame = CFrame.fromMatrix(HumanoidRootPart.Position, Right_Vector, Up_Vector)
                --                                                                 local cFrame_2 = CFrame.fromMatrix(HumanoidRootPart.Position, Right_Vector_2, Up_Vector_2)
                                                                                
                --                                                                 BV.MaxForce = BV.MaxForce:lerp(Max_Force, .1)
                                                                                
                --                                                                 BG.MaxTorque = Vector3.new(1000, 1000, 1000)
                                                                                
                --                                                                 BG.CFrame = cFrame_2
                                                                                
                --                                                                 local Swerve_Direction = (((Left_Swerving == true or Left_Flipping == true) and -1) or ((Right_Swerving == true or Right_Flipping == true) and 1) or 0)
                                                                                
                --                                                                 if (Left_Flipping == true or Right_Flipping == true) then
                --                                                                     local Target_Velocity = (cFrame * (cframenew((Swerve_Direction * 50), 0, 0)))
                                                                                    
                --                                                                     local Target_Position = (cframenew(V_1, Target_Velocity.Position) * cframenew(0, 0, (-Distance + 10)))
                                                                                    
                --                                                                     local Velocity = (cframenew(HumanoidRootPart.Position, Target_Position.Position).LookVector * Gear_Speed)
                                                                                    
                --                                                                     if (Frontflipping == true) then
                --                                                                         Velocity = (Velocity * 1.35)
                                                                                        
                --                                                                     elseif (Backflipping == true) then
                --                                                                         Velocity = (Velocity * -1.35)
                                                                                        
                --                                                                     elseif (Upflipping == true) then
                --                                                                         Velocity = (Velocity + (Up_Vector * Gear_Speed))
                --                                                                     end
                                                                                    
                --                                                                     BV.Velocity = BV.Velocity:lerp(Velocity, Lerp_Speed)
                                                                                    
                --                                                                 elseif (Swerve_Direction == 0) then
                --                                                                     local Velocity = (Look_Vector * Gear_Speed)
                                                                                    
                --                                                                     if (Frontflipping == true) then
                --                                                                         Velocity = (Velocity * 1.35)
                                                                                        
                --                                                                     elseif (Backflipping == true) then
                --                                                                         Velocity = (Velocity * -1.35)
                                                                                        
                --                                                                     elseif (Upflipping == true) then
                --                                                                         Velocity = (Velocity + (Up_Vector * Gear_Speed))
                --                                                                     end
                                                                                    
                --                                                                     BV.Velocity = BV.Velocity:lerp(Velocity, Lerp_Speed)
                                                                                    
                --                                                                 elseif (Swerve_Direction ~= 0) then
                --                                                                     local Target_Velocity = (cFrame * (cframenew(Swerve_Direction, 0, 0)))
                                                                                    
                --                                                                     local Target_Position = (cframenew(V_1, Target_Velocity.Position) * cframenew(0, 0, (-Distance + 1)))
                                                                                    
                --                                                                     local Velocity = (cframenew(HumanoidRootPart.Position, Target_Position.Position).LookVector * Gear_Speed)
                                                                                    
                --                                                                     if (Frontflipping == true) then
                --                                                                         Velocity = (Velocity * 1.35)
                                                                                        
                --                                                                     elseif (Backflipping == true) then
                --                                                                         Velocity = (Velocity * -1.35)
                                                                                        
                --                                                                     elseif (Upflipping == true) then
                --                                                                         Velocity = (Velocity + (Up_Vector * Gear_Speed))
                --                                                                     end
                                                                                    
                --                                                                     BV.Velocity = BV.Velocity:lerp(Velocity, Lerp_Speed)
                --                                                                 end
                --                                                             end
                --                                                         end
                --                                                     end
                --                                                 end
                --                                             end
                --                                         end
                --                                     end
                --                                 end
                --                             end
                --                         end
                --                     end
                --                 end
                --             end
                --         end
                --     end)
                    
                --     HostM:Check(Success, Error)
                -- end)
            end
        end
    end
end


local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")
local flags        = OrionLib.Flags

local MainWindow   = OrionLib:MakeWindow({Name = "Attack On Titan: Evo", HidePremium = false, SaveConfig = true, ConfigFolder = "./Scrumpy/Attack on Titan - Evo"})

local Main         = MainWindow:MakeTab({Name = ' Main ', Icon = "rbxassetid://4483345998", premiumOnly = false})

local Function     = Main:AddSection({Name = ' Functions '})
local Keybinds     = Main:AddSection({Name = ' Keybinds '})
local Funny        = Main:AddSection({Name = ' Funny '})

local Settings = {
    SlientMode = false,
    AlwaysNape = false,
    Damage = 6000,
    TitanESP = false
}

Keybinds:AddBind({
    Name = "Control Gui",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function() 
        Orion.Enabled = not Orion.Enabled 
    end,
    Flag = "GUI",
    Save = true,
})

for i = 5, 10 do
    if game.PlaceId == whitelist[i] then -- any PvE area
        local Titans = Workspace:WaitForChild("Titans")

        task.spawn(function () -- anti-attack
            while task.wait() do
                local HRP = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if HRP:FindFirstChildOfClass("TouchTransmitter") then
                    HRP.TouchInterest:Destroy()
                end
            end
        end)

        local AN = Function:AddToggle({
            Name = "Always Nape",
            Default = true,
            Callback = function(bool) 
                Settings.AlwaysNape = bool
                if Settings.AlwaysNape then
                    while Settings.AlwaysNape do
                        task.wait()
                        print('Nape')
                    end
                end
            end,
            Flag = "AlwaysNape",
            Save = true,
        })

        Function:AddToggle({
            Name = "Titan ESP",
            Default = true,
            Callback = function(bool)
                Settings.TitanESP = bool
                if Settings.TitanESP then
                    while Settings.TitanESP do
                        task.wait()
                        for i2, v2 in pairs(Titans:GetChildren()) do
                            MHL(Color3.fromRGB(200, 90, 255), Color3.fromRGB(255, 119, 215), v2)
                        end
                    end
                end
            end,
            Flag = "TitanESP",
            Save = true
        })

        Keybinds:AddBind({
            Name = "Always Nape Keybind",
            Default = Enum.KeyCode.G,
            Hold = false,
            Callback = function() 
                AN:Set(not flags.AlwaysNape)
            end,
            Flag = "ANBind",
            Save = true,
        })

        Funny:AddButton({
            Name = "Break titan animations",
            Callback = function()
                for i, v in pairs(Titans:GetChildren()) do
                    task.wait()
                    if v:FindFirstChild("HumanoidRootPart") then
                        v:WaitForChild("HumanoidRootPart"):WaitForChild("Animator"):Destroy()
                    end
                end
            end,
        })

        Funny:AddParagraph("Side Note", "It Makes them seem frozen, and flop around. A titan body's is actually serverside(making the game seem laggy), so this is not recommended.")

        local OldNameCall; OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if not checkcaller() then
                if method == "InvokeServer" and args[1] == "Slash" and Settings.AlwaysNape then
                    args[3] = "Nape"
                    args[7] = Settings.Damage
                    return OldNameCall(Self, unpack(args))
                end
            end
            return OldNameCall(Self, ...)
        end))
    end
end

Orion.Enabled = false

OrionLib:MakeNotification({
	Name = "Slient Mode",
	Content = "GUI is off by default, default keybind to toggle is RSHIFT",
	Image = "rbxassetid://4483345998",
	Time = 5
})

OrionLib:Init()
