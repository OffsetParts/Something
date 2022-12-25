-- ver - 4 | Honestly got nothing else to do
if not game:IsLoaded() then
	setfflag("AbuseReportScreenshotPercentage", 0) -- 
	setfflag("DFFlagAbuseReportScreenshot", "False") -- Disable Abuse Report Screenshots
	setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "") -- remove the url
	setfflag("DFIntCrashUploadToBacktracePercentage", "0") -- nullifies it chances
	setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "") -- remove fingerprint token
	setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "") -- remove fingerprint token

	game.Loaded:Wait()
end

getgenv().Services = setmetatable({}, {
	__index = function(Self, Index)
		local NewService = game.GetService(game, Index)
		if NewService then
			Self[Index] = NewService
		end
		return NewService
	end
})

getgenv().Scrumpy = {
	Alias = 'Ghost',
	Logs  = true, -- Enable logs
	Debug = true -- Enables further logging and functions for troubleshooting (W.I.P)
}

getgenv().Notifier = function(txt, debug) -- global quick alert function
    if  Scrumpy.Logs then
        if not debug then
            print(tostring(txt))
        elseif Scrumpy.Debug then
            warn("[DEBUG] ", tostring(txt))
        end
    end
end

local ST = os.clock()

-- [[ Variables ]] --
local Players = Services.Players
local Player  = Players.LocalPlayer
local GetConnections = getconnections or get_signal_cons

Player:SetSuperSafeChat(false) -- fuck filtering
Player:SetMembershipType(4) -- premium | just for show (client)
Player:SetAccountAge(1000) -- just for show here

task.spawn(function() -- Anti Alt detection
	if not isfile("alt_hashes.txt") then
		writefile("alt_hashes.txt", "")
	end

	local found_hash = false
	local hash_list = readfile("alt_hashes.txt")

	local lines = hash_list:split("\n")
	local clock_offset

	if #lines > 0 then
	   for i,v in next, lines do
		   if found_hash then
			   break
		   end

		   local line_split = v:split(":")
		   if string.find(line_split[1], tostring(Player.UserId)) then
			   clock_offset = tonumber(line_split[2])
			   found_hash = true
		   end
	   end
	end

	if not found_hash then
		math.randomseed(tick())
		clock_offset = math.random(1,200) + math.random(1,10000)/10000
		appendfile("alt_hashes.txt", tostring(Player.UserId)..":"..tostring(clock_offset).."\n")
	end

	local os_clock; os_clock = hookfunction(os.clock, function()
		return os_clock() + clock_offset
	end)
end)

if GetConnections then -- AntiAFK
	for i, ob in pairs(GetConnections(Player.Idled)) do
		if ob["Disable"] then
			ob["Disable"](ob)
		elseif ob["Disconnect"] then
			ob["Disconnect"](ob)
		end
	end
end

-- [ Settings ] -- At the top for quicker access
getgenv().config = {
	ACBs = true,  -- Community gathered Anticheat bypasses | Only contributor me :(
    NR   = true,   -- Name replacer | Replaces your name in-game every clientsided
	NTR  = true,   -- NameTag Remover | An function to find any client side nametags to remove (caution: raises suspicion)
	NC   = false,   -- Noclip tool
	ASS  = false,  -- Anti-Stream Snipe | Function Denaming players to make it harder to track your games. Tip: Interferes with ADN so choose wisely
    ADN  = {       -- Anti Display Names by mothra#4150
		Enable = true,
		Preferences = {
			RetroNaming = true,
			ShowOriginalName   = true,
			ApplyToLeaderboard = true,
			IdentifyFriends    = {Toggle = true, Identifier = '[Cuz]'},
			IdentifyBlocked    = {Toggle = true, Identifier = '[Cunt]'},
			IdentifyPremium    = {Toggle = true, Identifier = '[Premium]'},
			IdentifyDeveloper  = {Toggle = true, Identifier = '[Dev]'},
			SpoofLocalPlayer   = {Toggle = false, UseRandomName = false, NewName = 'Random Name Lol'}, -- this will interfere with NR on the leaderboard
			Orientation 	   = 'Vertical'
		}
	},

	Customs = true, -- loads custom scripts url only for now
	Games = {
	--  [gameId]     = 'raw text file link'
		[6536671967] = 'https://raw.githubusercontent.com/XTheMasterX/Scripts/Main/SlayersUnleashedAdmin', -- by septex great
		[8982709021] = 'https://raw.githubusercontent.com/RegularVynixu/Scripts/main/YouTube%20Life/Auto%20Farm.lua', -- useless spergs
	},
}

-- loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Utilites/Settings.lua"), true))()
-- 	Notifier("(1) Settings Loaded", true)

task.spawn(function ()
	if config.ACBs then
		loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Bypass.lua"), true))()
		Notifier("(2) ACBs", true)
	end
	task.delay(2, function ()
		if config.NR then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Renamer.lua"), true))()
			Notifier("(3) Obscurer", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.NTR then -- lol
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/NameTag.lua"), true))()
			Notifier("(4) Nametag Remover", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ADN.Enable then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Anti-DisplayName.lua"),true))()
			Notifier("(5) Anti-Display Name", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ASS then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/AntiStreamSnipe.lua"),true))()
			Notifier("(6) Anti-Stream Snipe", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.NC then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Noclip.lua"), true))()
			Notifier("(7) Noclip", true)
		end
		
		DT = os.clock() - ST
		Notifier("Took " .. DT .. " seconds to load", true)
	end)

	--- Custom | Possibly more addons in the future
	if config.Customs then
		for i, v in next, config.Games do
			task.wait()
			if v == game.PlaceId then
				task.spawn(function()
					loadstring(game:HttpGetAsync((config.Games[v]), true))()
				end)
				Notifier('Script founded for ' .. i, true)
			end
		end
	end
end)