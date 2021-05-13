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
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "failed to load asset rbxassetid://0 fail to load sound",
        messageType = Enum.MessageType.MessageError,
        timeStamp = 0
    },
    {
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Chunk JQlf7FhdPRFyAVU4, at Line 21: Unexpected symbol near '.'",
        messageType = Enum.MessageType.MessageWarning,
        timeStamp = 1
    },
    {
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Chunk 9o1Bbmsb1P9bhEc, at Line 1: Unexpected symbol near '}'",
        messageType = Enum.MessageType.MessageWarning,
        timeStamp = 1
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Chunk Hji2WVavxU51wTQF, at Line 5: Unexpected symbol near '['",
        messageType = Enum.MessageType.MessageWarning,
        timeStamp = 1
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Chunk 5XBWnWVbXeFT6l6F9OVNjC, at Line 42: Unexpected symbol near '|'",
        messageType = Enum.MessageType.MessageWarning,
        timeStamp = 1
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Chunk 7UALGkX1JE8FvQn2, at Line 69: Unexpected symbol near 'true'",
        messageType = Enum.MessageType.MessageWarning,
        timeStamp = 1
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Chunk Hji2WVavxU51wTQF, at Line 51: Unexpected symbol near '['",
        messageType = Enum.MessageType.MessageWarning,
        timeStamp = 1
    },
	{
        message = "[" .. localTime(os.date("*t", now)) .. "] " .. "Infinite yield possible on game.ReplicatedStorage.Main:WaitForChild('Handle')",
        messageType = Enum.MessageType.MessageWarning,
        timeStamp = 0
    }
}
end)
