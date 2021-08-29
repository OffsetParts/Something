local LogService = game:GetService("LogService")

function localTime(date)
    local dataString = "{hour}:{min}"
    local result = string.gsub(dataString, "{(%w+)}", date)
    return result
end
local now = os.time()

local index = 1


-- changes locallogs for anyone who trys to get it it won't change for you GetLogHistory
-- Full protection with sensible logs that are common to confuse any dev or admin
local Old
Old = hookfunction(LogService.GetLogHistory, function(...)
    if checkcaller() then return Old(...) end
return {
    {
		-- 16 chars
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://296178266: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 0
    },
    {
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://1679489532: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 1
    },
    {
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://296178266: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 2
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://0: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 3
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://0: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 4
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://0: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 5
    }
}
end)
