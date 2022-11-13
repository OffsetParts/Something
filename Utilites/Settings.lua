-- Figure out how to save Enums in JSON (probably got to make my own ver of JSON Encode and Decode)

local HS = game:GetService("HttpService")
local ugs = UserSettings():GetService("UserGameSettings")

local whitelist = {
    ["CameraYInverted"] = true,
    ["ComputerCameraMovementMode"] = true,
    ["ComputerMovementMode"] = true,
    ["ControlMode"] = true,
    ["Fullscreen"] = true,
    ["GamepadCameraSensitivity"] = true,
    ["MasterVolume"] = true,
    ["MouseSensitivity"] = true,
    ["OnScreenProfilerEnabled"] = true,
    ["PerformanceStatsVisible"] = true,
    ["SavedQualityLevel"] = true,
    ["TouchCameraMovementMode"] = true,
    ["TouchMovementMode"] = true,
}

local propertiesWithOwnSignal = { 
    Fullscreen = "FullscreenChanged", 
    PerformanceStatsVisible = "PerformanceStatsVisibleChanged" 
}

local function ifFile(file_name)
    if isfile(file_name) then 
        return readfile(file_name)
    else
        writefile(file_name, '{}')
        return readfile(file_name)
    end
end

local function ifOwnSignal(property)
    if propertiesWithOwnSignal[property] then return true else return end
end

if ifFile('robloxSettings.json') then -- load saved settings
    local savedSettings = HS:JSONDecode(ifFile("robloxSettings.json"))
    if not savedSettings then return end
    for Setting, Value in next, savedSettings do
        if ugs[Setting] ~= nil then
            ugs[Setting] = Value
        end
    end
end

--[[ for _, v in next, whitelist do -- save new settings
    if whitelist[_] and not ifOwnSignal(_) and ugs[tostring(_)] then
        ugs.Changed:Connect(function(prop)
            task.wait(0.1)
            local newSave = HS:JSONDecode(ifFile("robloxSettings.json"))
            newSave[_] = ugs[prop]

            writefile("robloxSettings.json", HS:JSONEncode(newSave))
        end)
    end
end *]]

ugs.Changed:Connect(function(prop)
    if whitelist[prop] and not ifOwnSignal(prop) then
        task.wait(0.1)
        local newSave = HS:JSONDecode(ifFile("robloxSettings.json"))
        if prop == 'SavedQualityLevel' then print(ugs[prop], typeof(ugs[prop])) end
        newSave[prop] = ugs[prop]

        writefile("robloxSettings.json", HS:JSONEncode(newSave))
    end
end)

ugs.FullscreenChanged:Connect(function(isFullscreen)
    local newSave = HS:JSONDecode(ifFile("robloxSettings.json"))
    newSave['Fullscreen'] = isFullscreen

    writefile("robloxSettings.json", HS:JSONEncode(newSave))
end)

ugs.PerformanceStatsVisibleChanged:Connect(function(isPerformanceStatsVisible)
    local newSave = HS:JSONDecode(ifFile("robloxSettings.json"))
    newSave['PerformanceStatsVisible'] = isPerformanceStatsVisible

    writefile("robloxSettings.json", HS:JSONEncode(newSave))
end)