-- [==[ Created by mothra#1337 ]==]
-- (Anti-Displayname v4)
-- 8/11/21
if not game['Loaded'] or not game:GetService('Players')['LocalPlayer'] then
    game['Loaded']:Wait();
    game:WaitForChild(game:GetService('Players'));
    game:GetService('Players'):WaitForChild(game:GetService('Players').LocalPlayer.Name)
end

local LP = game:GetService('Players').LocalPlayer
local ApplyLeaderboardDisplayname = true
--^> Sets the players' DisplayName on the leaderboard to their actual name in this convention; "DisplayName [UserName]"
local FriendIdentifier = '✓' -- Change this to anything you like, considering unicode might not work on all exploits.
local NameLayout = 'Vertical'
--> Makes the name layout either Vertical or Horizontal.
-- Layouts: {Vertical, Horizontal}

local FindChildByOrder = function(parent, tbl, returnInstance)
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

local GetPlrInfo = function(userId)
    if userId and type(userId) == 'string' or type(userId) == 'number' then
        local success, result = pcall(function()
            return game:GetService('UserService'):GetUserInfosByUserIdsAsync({tonumber(tostring(userId))})
        end)
        
        if success then
            return result
        else
            return {{['Id'] = 0, ['Username'] = 'nil (failed to parse?) [HTTP 403?]', ['DisplayName'] = 'nil (failed to parse?) [HTTP 403?]', ['Error'] = result}}
        end
    end
end

local GetPlrFromName = function(name)
    if name and type(name) == 'string' then
        local Player = false;
        for _, v in next, game:GetService('Players'):GetPlayers() do
            coroutine.wrap(function()
                if v.DisplayName:lower() == name:lower() or v.Name:lower() == name:lower() then
                    Player = v
                end
            end)()
        end
        return Player
    end
end

local PlayersStuff = FindChildByOrder(game:GetService('CoreGui'), {'PlayerList', 'PlayerListMaster', 'OffsetFrame', 'PlayerScrollList', 'SizeOffsetFrame', 'ScrollingFrameContainer', 'ScrollingFrameClippingFrame', 'ScollingFrame', 'OffsetUndoFrame'}, true)
if PlayersStuff then
    for _, v in next, PlayersStuff:GetChildren() do
        coroutine.wrap(function()
            if v.Name:match('p_') and GetPlrInfo(v.Name:gsub('p_', '')) and FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}) then
                local PlrInfo = GetPlrInfo(v.Name:gsub('p_', ''));
                local PlayerNameLabel = FindChildByOrder(v, {'ChildrenFrame', 'NameFrame', 'BGFrame', 'OverlayFrame', 'PlayerName', 'PlayerName'}, true)
                if not game:GetService('Players'):FindFirstChild(PlrInfo[1].DisplayName) and PlrInfo[1].Username ~= LP.Name and ApplyLeaderboardDisplayname then
                    PlayerNameLabel.Text = PlrInfo[1].DisplayName..' ['..tostring(PlrInfo[1].Username)..']'
                end
            end
        end)()
    end
    for _, v in next, game:GetService('Players'):GetPlayers() do
        coroutine.wrap(function()
            if v ~= LP and GetPlrInfo(v.UserId) then
                local PlrInfo = GetPlrInfo(v.UserId);
                if PlrInfo[1].Username ~= PlrInfo[1].DisplayName then
                    if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                        if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                        elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                        end
                    end
                    v.CharacterAdded:Connect(function(Char)
                        local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                            if v:IsA('Humanoid') then
                                if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                                    v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                                elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                                    v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                                end
                                CAdded:Disconnect()
                            end
                        end)
                    end)
                elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and FriendIdentifier and type(FriendIdentifier) == 'string' then
                    local PlrInfo = GetPlrInfo(v.UserId);
                    if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                        if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..'] ['..FriendIdentifier..']'
                        elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                            v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..'] ['..FriendIdentifier..']'
                        end
                    end
                    v.CharacterAdded:Connect(function(Char)
                        local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                            if v:IsA('Humanoid') and FriendIdentifier and type(FriendIdentifier) == 'string' then
                                if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                                    v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                                elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                                    v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                                end
                                CAdded:Disconnect()
                            end
                        end)
                    end)
                end
            end
        end)()
    end
    
    game:GetService('Players').PlayerAdded:Connect(function(v)
        if v ~= LP and GetPlrInfo(v.UserId) then
            local PlrInfo = GetPlrInfo(v.UserId);
            if PlrInfo[1].Username ~= PlrInfo[1].DisplayName then
                if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                    if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                        v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                    elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                        v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                    end
                end
                v.CharacterAdded:Connect(function(Char)
                    local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                        if v:IsA('Humanoid') then
                            if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                                v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                            elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                                v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                            end
                            CAdded:Disconnect()
                        end
                    end)
                end)
            elseif v:IsFriendsWith(LP.UserId) and GetPlrInfo(v.UserId) and FriendIdentifier and type(FriendIdentifier) == 'string' then
                local PlrInfo = GetPlrInfo(v.UserId);
                if v['Character'] and v.Character:FindFirstChild('Humanoid') then
                    if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                        v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                    elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                        v.Character.Humanoid.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                    end
                end
                v.CharacterAdded:Connect(function(Char)
                    local CAdded;CAdded = Char.ChildAdded:Connect(function(v)
                        if v:IsA('Humanoid') and FriendIdentifier and type(FriendIdentifier) == 'string' then
                            if NameLayout == 'Vertical' or NameLayout ~= 'Horizontal' then
                                v.DisplayName = PlrInfo[1].DisplayName..'\n['..PlrInfo[1].Username..']'
                            elseif NameLayout == 'Horizontal' or NameLayout ~= 'Vertical' then
                                v.DisplayName = PlrInfo[1].DisplayName..' ['..PlrInfo[1].Username..']'
                            end
                            CAdded:Disconnect()
                        end
                    end)
                end)
            end
        end
    end)
end
