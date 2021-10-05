-- [==[ Created by mothra#1337 ]==]
-- (Anti-Displayname v5)
local Settings = {
    ApplyToLeaderboard = true,
    IdentifyFriends = true,
    FriendIdentifier = ' [Friend]',
    BlockedIdentifier = ' Blocked',
    Orientation = 'Vertical',
    DisplayNameToName = false,
    ShowBlockedInName = true,
}

local Data = {
    Main = 'rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/App/ImageSet/ImageAtlas/img_set_1x_1.png',
    Friend = 'rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/App/ImageSet/ImageAtlas/img_set_1x_3.png',
    BlockedPos = '488, 133',
    PremiumPos = '484, 489',
    FriendPos = '230, 301'    
}

if not game['Loaded'] or not game:GetService('Players')['LocalPlayer'] then
    game['Loaded']:Wait();
    game:WaitForChild(game:GetService('Players'));
    game:GetService('Players'):WaitForChild(game:GetService('Players').LocalPlayer.Name)
    wait(1)
end

local Players, LP, CoreUI = game:GetService('Players'), game:GetService('Players').LocalPlayer, game:GetService('CoreGui')
local function GetPlayer(data)
    if type(data) == 'string' then
        for _, v in next, Players:GetPlayers() do
            if v.Name:lower():match('^'..data:lower()) or v.DisplayName:lower():match('^'..data:lower()) then
                return v
            end
        end
    elseif type(data) == 'number' then
        for _, v in next, Players:GetPlayers() do
            if v.UserId == data then
                return v
            end
        end
    end
end
local function FindChildByOrder(parent, tbl, returnInstance)
    if parent and tbl and typeof(parent) == 'Instance' and type(tbl) == 'table' and #tbl > 0 then
        local Current = parent;
        for _, v in next, tbl do
            coroutine.wrap(function()
                if type(v) == 'string' and Current:FindFirstChild(v) then
                    Current = Current:FindFirstChild(v)
                else
                    return false
                end
            end)()
        end
        if not returnInstance then
            return true
        elseif returnInstance then
            return Current
        end
    end
end

local AppendNames = function()
    local PLM = FindChildByOrder(game:GetService('CoreGui'), {'PlayerList', 'PlayerListMaster', 'OffsetFrame', 'PlayerScrollList', 'SizeOffsetFrame', 'ScrollingFrameContainer', 'ScrollingFrameClippingFrame', 'ScollingFrame', 'OffsetUndoFrame'}, true)
    if PLM and PLM:IsA('Frame') then
        for _, v in next, PLM:GetChildren() do
            task.spawn(function()
                local TP, NLabel, Status = GetPlayer(0 + v.Name:gsub('p_', '')), FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}, true), FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerIcon'}, true)
                if TP and NLabel and Status and not Settings.DisplayNameToName then
                    if tostring(Status.ImageRectOffset) == Data.FriendPos then --1
                        NLabel.RichText = true
                        if Settings.ApplyToLeaderboard == true and Settings.IdentifyFriends then
                            if Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name ~= TP.DisplayName then
                                NLabel.Text = '<font color="#24EC00">'..TP.DisplayName..'\n(@'..TP.Name..')'..'</font>'
                            elseif Settings.Orientation == 'Horizontal' and TP.Name ~= TP.DisplayName then
                                NLabel.Text = '<font color="#24EC00">'..TP.DisplayName..' (@'..TP.Name..')'..'</font>'
                            elseif table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name == TP.DisplayName then
                                NLabel.Text = '<font color="#24EC00">'..TP.DisplayName..'</font>'
                            end
                        else
                            NLabel.RichText = false
                            NLabel.Text = TP.DisplayName
                        end
                        if Settings.ShowBlockedInName and TP['Character'] and TP.Character:FindFirstChildWhichIsA('Humanoid') and TP.Name ~= TP.DisplayName then
                            local H = TP.Character:FindFirstChildWhichIsA('Humanoid')
                            if Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name ~= TP.DisplayName then
                                H.DisplayName = TP.DisplayName..'\n(@'..TP.Name..')\n'..Settings.FriendIdentifier
                            elseif Settings.Orientation == 'Horizontal' and TP.Name ~= TP.DisplayName then
                                H.DisplayName = TP.DisplayName..' (@'..TP.Name..')'..Settings.FriendIdentifier
                            elseif Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name == TP.DisplayName then
                                H.DisplayName = TP.DisplayName..'\n'..Settings.FriendIdentifier
                            elseif Settings.Orientation == 'Horizontal' and TP.Name == TP.DisplayName then
                                H.DisplayName = TP.DisplayName..Settings.FriendIdentifier
                            end
                        elseif not Settings.ShowBlockedInName and TP['Character'] and TP.Character:FindFirstChildWhichIsA('Humanoid') then
                            local H = TP.Character:FindFirstChildWhichIsA('Humanoid')
                            H.DisplayName = TP.DisplayName
                        end
                    elseif tostring(Status.ImageRectOffset) == Data.BlockedPos then --2
                        if Settings.ApplyToLeaderboard == true and Settings.ShowBlockedInName then
                            NLabel.RichText = true
                            if Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name ~= TP.DisplayName then
                                NLabel.Text = '<font color="#FC0000">'..TP.DisplayName..'\n(@'..TP.Name..')'..'</font>'
                            elseif Settings.Orientation == 'Horizontal' and TP.Name ~= TP.DisplayName then
                                NLabel.Text = '<font color="#FC0000">'..TP.DisplayName..' (@'..TP.Name..')'..'</font>'
                            elseif Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name == TP.DisplayName then
                                NLabel.Text = '<font color="#FC0000">'..TP.DisplayName..'</font>'
                            elseif Settings.Orientation == 'Vertical' and TP.Name ~= TP.DisplayName then
                                NLabel.Text = '<font color="#FC0000">'..TP.DisplayName..'</font>'
                            end
                        else
                            NLabel.RichText = false
                            NLabel.Text = TP.DisplayName
                        end
                        if Settings.ShowBlockedInName and TP['Character'] and TP.Character:FindFirstChildWhichIsA('Humanoid') and TP.Name ~= TP.DisplayName then
                            local H = TP.Character:FindFirstChildWhichIsA('Humanoid')
                            if Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name ~= TP.DisplayName then
                                H.DisplayName = TP.DisplayName..'\n(@'..TP.Name..')\n'..Settings.BlockedIdentifier
                            elseif Settings.Orientation == 'Horizontal' and TP.Name ~= TP.DisplayName then
                                H.DisplayName = TP.DisplayName..' (@'..TP.Name..')'..Settings.BlockedIdentifier
                            elseif Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name == TP.DisplayName then
                                H.DisplayName = TP.DisplayName..'\n'..Settings.BlockedIdentifier
                            elseif Settings.Orientation == 'Horizontal' and TP.Name == TP.DisplayName then
                                H.DisplayName = TP.DisplayName..Settings.BlockedIdentifier
                            end
                        elseif not Settings.ShowBlockedInName and TP['Character'] and TP.Character:FindFirstChildWhichIsA('Humanoid') then
                            local H = TP.Character:FindFirstChildWhichIsA('Humanoid')
                            H.DisplayName = TP.DisplayName
                        end
                    else --3
                        if Settings.ApplyToLeaderboard == true then
                            NLabel.RichText = true
                            if Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name ~= TP.DisplayName then
                                NLabel.Text = TP.DisplayName..'\n(@'..TP.Name..')'
                            elseif Settings.Orientation == 'Horizontal' and TP.Name ~= TP.DisplayName then
                                NLabel.Text = TP.DisplayName..' (@'..TP.Name..')'
                            elseif table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name == TP.DisplayName then
                                NLabel.Text = TP.DisplayName
                            end
                        else
                            NLabel.RichText = false
                            NLabel.Text = TP.DisplayName
                        end
                        if TP['Character'] and TP.Character:FindFirstChildWhichIsA('Humanoid') and TP.Name ~= TP.DisplayName then
                            local H = TP.Character:FindFirstChildWhichIsA('Humanoid')
                            if Settings.Orientation == 'Vertical' or not table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name ~= TP.DisplayName then
                                H.DisplayName = TP.DisplayName..'\n(@'..TP.Name..')'
                            elseif Settings.Orientation == 'Horizontal' and TP.Name ~= TP.DisplayName then
                                H.DisplayName = TP.DisplayName..' (@'..TP.Name..')'
                            elseif table.find({'Vertical', 'Horizontal'}, Settings.Orientation) and TP.Name == TP.DisplayName then
                                H.DisplayName = TP.DisplayName
                            end
                        end
                    end
                elseif TP and NLabel and Status and Settings.DisplayNameToName == true then -- 1b
                    NLabel.RichText = false
                    NLabel.Text = TP.Name
                    if TP['Character'] and TP.Character:FindFirstChildWhichIsA('Humanoid') and TP.Name ~= TP.DisplayName then
                        local H = TP.Character:FindFirstChildWhichIsA('Humanoid')
                        H.DisplayName = TP.Name
                    elseif TP['Character'] and TP.Character:FindFirstChildWhichIsA('Humanoid') and TP.Name == TP.DisplayName then
                        local H = TP.Character:FindFirstChildWhichIsA('Humanoid')
                        H.DisplayName = TP.Name
                    end
                end
            end)
        end
    end
end

AppendNames();
--
for _, v in next, Players:GetPlayers() do
    if v ~= LP then
        v.CharacterAdded:Connect(function()
            local CA;CA = v.Character.ChildAdded:Connect(function(b)
                if b:IsA('Humanoid') then
                    AppendNames()
                end
            end)
            wait(1)
            CA:Disconnect()
        end)
    end
end
--
Players.PlayerAdded:Connect(function(v)
    wait()
    v.CharacterAdded:Connect(function()
        local CA;CA = v.Character.ChildAdded:Connect(function(b)
            if b:IsA('Humanoid') then
                AppendNames()
            end
        end)
        wait(1)
        CA:Disconnect()
    end)
end)
