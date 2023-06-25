-- ver 5 | Happy with my creation
-- set config array, dumbass
if not game:IsLoaded() then
	setfflag("AbuseReportScreenshotPercentage", "0")
	setfflag("DFFlagAbuseReportScreenshot", "False")
	setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
	setfflag("DFIntCrashUploadToBacktracePercentage", "0")
	setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
	setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
	
	game.Loaded:Wait()
end

ST = os.clock()
-- [ Settings ] --
getgenv().Scrumpy = {
	Alias = 'Ghost', -- Alias used in NR
	Logs  = true, -- Enable logs
	Debug = true -- Enables further logging and functions for troubleshooting (W.I.P)
}

if not type(getgenv().config) == 'table' then -- if you want to use a link instead
	getgenv().config = {
		ACBs = false,   -- Community gathered Anticheat bypasses
		NR   = false,   -- Name replacer | Replaces your name in-game every | client-sided
		NTR  = false,   -- NameTag Remover | An function to find any client side nametags to remove (caution: raises suspicion)
		NC   = false,   -- Noclip tool
		ASS  = false,  -- Anti-Stream Snipe | Obfuscate players' names to make it harder to track your current server | Interferes with ADN slightly
		ADN  = {       -- Anti Display Names by mothra#4150
			Enable = false,
			Preferences = {RetroNaming = true, ShowOriginalName   = true, ApplyToLeaderboard = true,
				IdentifyFriends    = {Toggle = true, Identifier = '[Cuz]'},
				IdentifyBlocked    = {Toggle = true, Identifier = '[Cunt]'},
				IdentifyPremium    = {Toggle = true, Identifier = '[Premium]'},
				IdentifyDeveloper  = {Toggle = true, Identifier = '[Dev]'},
				SpoofLocalPlayer   = {Toggle = false, UseRandomName = false, NewName = 'NiggaChin'}, -- this will interfere with NR on the leaderboard
				Orientation 	   = 'Vertical'
			}
		},

		Customs = true, -- loads custom scripts url only for now
		Games = {
		--  [gameId]     = 'raw text file link'
			[6536671967] = 'https://raw.githubusercontent.com/XTheMasterX/Scripts/Main/SlayersUnleashedAdmin', -- by septex the great
			[8982709021] = 'https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/YouTube%20Life/Auto%20Farm.lua', -- useless spergs
		},
	}
end

-- / Functions \
getgenv().Services = setmetatable({}, {
	__index = function(Self, Index)
		local NewService = game:GetService(Index)
		if NewService then
			Self[Index] = NewService
		end
		return NewService
	end
})

getgenv().Notifier = function(txt, debug) -- quick global alert function
    if Scrumpy.Logs then
        if debug and Scrumpy.Debug then
            warn("NORTH:", os.time(), "|", txt)
        else
            print("NORTH:", os.time(), "|", txt)
        end
    end
end

getgenv().setconnectionenabled = function(connection, boolean)
	if connection then
		connection.Enabled = boolean
	end
end

Services.GuiService.AutoSelectGuiEnabled = false
Services.GuiService.GuiNavigationEnabled = false

-- [[ Variables ]] --
local Player  		 = Services.Players.LocalPlayer
local getConnections = getconnections or get_signal_cons

Player:SetSuperSafeChat(false) -- fuck filtering
Player:SetMembershipType(4) -- premium
Player:SetAccountAge(math.random(2000, 6000))

if getConnections then 
	for _, c in pairs(getConnections(Player.Idled)) do -- AntiAFK
		setconnectionenabled(c, false)
	end
end

task.spawn(function ()
	if config.ACBs then
		loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Bypass.lua"), true))()
	end
	task.delay(1, function ()
		if config.NR then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Renamer.lua"), true))()
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.NTR then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/NameTag.lua"), true))()
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ADN.Enable then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Anti-DisplayName.lua"),true))()
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ASS then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/AntiStreamSnipe.lua"),true))()
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.NC then
			loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/OffsetParts/Something/master/Main/Noclip.lua"), true))()
		end

		Notifier("Took " .. os.clock() - ST .. " seconds to load", true)
	end)

	--- Custom | Possibly more addons in the future
	if config.Customs then
		for i, v in next, config.Games do
			task.wait()

			if v == game.PlaceId then
				task.spawn(function()
					loadstring(game:HttpGetAsync((config.Games[v]), true))()
				end)
				Notifier('Custom script loaded for ' .. i, true)
			end
		end
	end
end)