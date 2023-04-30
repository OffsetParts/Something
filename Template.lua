-- ver 5 | Honestly got nothing else to do
if not game:IsLoaded() then
	setfflag("AbuseReportScreenshotPercentage", "0")
	setfflag("DFFlagAbuseReportScreenshot", "False")
	setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
	setfflag("DFIntCrashUploadToBacktracePercentage", "0")
	setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
	setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
	
	game.Loaded:Wait()
end

-- [ Settings ] --
getgenv().Scrumpy = {
	Alias = 'Ghost', -- Alias used in NR
	Logs  = true, -- Enable logs
	Debug = true -- Enables further logging and functions for troubleshooting (W.I.P)
}

getgenv().config = {
	ACBs = false,   -- Community gathered Anticheat bypasses
    NR   = true,   -- Name replacer | Replaces your name in-game every | client-sided
	NTR  = false,   -- NameTag Remover | An function to find any client side nametags to remove (caution: raises suspicion)
	NC   = true,   -- Noclip tool
	ASS  = false,  -- Anti-Stream Snipe | Obfuscate players' names to make it harder to track your current server | Interferes with ADN slightly
    ADN  = {       -- Anti Display Names by mothra#4150
		Enable = true,
		Preferences = {RetroNaming = true, ShowOriginalName   = true, ApplyToLeaderboard = true,
			IdentifyFriends    = {Toggle = true, Identifier = '[Cuz]'},
			IdentifyBlocked    = {Toggle = true, Identifier = '[Cunt]'},
			IdentifyPremium    = {Toggle = true, Identifier = '[Premium]'},
			IdentifyDeveloper  = {Toggle = true, Identifier = '[Dev]'},
			SpoofLocalPlayer   = {Toggle = false, UseRandomName = false, NewName = 'NiggaChin'}, -- this will interfere with NR on the leaderboard
			Orientation 	   = 'Vertical'
		}
	},

	Customs = true, -- loads custom scripts url
	Games = {
	--  [gameId]     = 'raw text file link'
		[6536671967] = 'https://raw.githubusercontent.com/XTheMasterX/Scripts/Main/SlayersUnleashedAdmin', -- by septex the great
		[8982709021] = 'https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/YouTube%20Life/Auto%20Farm.lua', -- useless spergs
	},
}

-- / Functions \
getgenv().Services = setmetatable({}, {
	__index = function(Self, Index)
		local NewService = game:GetService(Index)
		if NewService then
			Self[Index] = NewService
		else
			warn('Invalid Service provided :', Index)
		end
		return NewService
	end
})

getgenv().Notifier = function(txt, debug) -- global quick alert function
    if Scrumpy.Logs then
        if not Scrumpy.Debug then
            print(os.time(), "| " .. txt)
        elseif debug then
            warn("[DEBUG] ", tostring(txt))
        end
    end
end

local ST = os.clock()

Services.GuiService.AutoSelectGuiEnabled = false -- fuck the disabled
Services.GuiService.GuiNavigationEnabled = false

-- [[ Variables ]] --
local Player  		 = Services.Players.LocalPlayer
local getConnections = getconnections or get_signal_cons

Player:SetSuperSafeChat(false) -- fuck filtering
Player:SetMembershipType(4) -- premium
Player:SetAccountAge(math.random(2000, 6000))

if getConnections then 
	for _, c in pairs(getConnections(Player.Idled)) do -- AntiAFK
		if c["Disable"] then c["Disable"]() elseif c["Disconnect"] then c["Disconnect"]() end
	end
end

task.spawn(function()
	if config.ACBs then
		loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Bypass.lua"), true))()
		Notifier("(#) ACBs", true)
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------
	task.delay(.5, function()
		if config.NR then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Renamer.lua"), true))()
			Notifier("(1a) Obscurer", true)
		end
		----------------------------------------------------------------------------------------------------------------------------------------------
		if config.NTR then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/NameTag.lua"), true))()
			Notifier("(2a) Nametag Remover", true)
		end
		----------------------------------------------------------------------------------------------------------------------------------------------
		if config.ADN.Enable then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Anti-DisplayName.lua"),true))()
			Notifier("(2b) Anti-Display Name", true)
		end
		----------------------------------------------------------------------------------------------------------------------------------------------
		if config.ASS then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/AntiStreamSnipe.lua"),true))()
			Notifier("(2c) Anti-Stream Snipe", true)
		end
		----------------------------------------------------------------------------------------------------------------------------------------------
		if config.NC then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Noclip.lua"), true))()
			Notifier("(3a) Noclip Tool", true)
		end

		Notifier("Took " .. os.clock() - ST .. " seconds to load", true)
	end)

	--- Custom Scripts
	if config.Customs and config.Games[game.PlaceId] then
		loadstring(game:HttpGetAsync((config.Games[game.PlaceId]), true))()
	end
end)