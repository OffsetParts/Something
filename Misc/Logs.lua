local LogService = game:GetService("LogService")

function localTime(date)
    local dataString = "{hour}:{min}"
    local result = string.gsub(dataString, "{(%w+)}", date)
    return result
end


-- I redid this for only it to all be lost, will redo probabbblyyyyyyyyyyyyyyyyyyyyyyyyyyyy never cause it took to long and still mad about it

local Old
local now = os.time()

Old = hookfunction(LogService.GetLogHistory, newcclosure(function(...) 
    if checkcaller() then 
        return Old(...) 
    end
return {
    {
		-- 16 chars
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://5486216: Unable to download sound data",
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
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://296178266: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 4
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Failed to load sound rbxassetid://0: Unable to download sound data",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 5
    }
}
end))