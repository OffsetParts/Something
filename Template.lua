-- ver - 3.2 | Its getting there I think
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- [ Settings ] -- At the top for quicker access
getgenv().config = {
	ACBs = false, -- Community gathered Anticheat bypasses | Only contributor me :(
    NR   = false,  -- Name replacer | Replaces your name in-game every clientsided
	NTR  = true,  -- NameTag Remover | An function to find any client side nametags to remove (caution: raises suspicion)
    ASS  = false, -- Anti-Stream Snipe | Function Denaming players to make it harder to track your games. Tip: Interferes with ADN so choose wisely
	NC   = true,  -- Noclip tool
    ADN  = {      -- Anti Display Names by mothra#4150
		Enable = true,
		Preferences = {
			RetroNaming = false,
			ShowOriginalName   = true,
			ApplyToLeaderboard = true,
			IdentifyFriends    = {Toggle = true, Identifier = '[Cuz]'},
			IdentifyBlocked    = {Toggle = true, Identifier = '[Cunt]'},
			IdentifyPremium    = {Toggle = false, Identifier = '[Premium]'},
			IdentifyDeveloper  = {Toggle = true, Identifier = '[Developer]'},
			SpoofLocalPlayer   = {Toggle = false, UseRandomName = false, NewName = 'Random Name Lol'},
			Orientation 	   = 'Vertical'
		}
	},

	Customs = true, -- loads custom scripts url only
	Games = {
	--  [gameId]     = 'link'
		[6536671967] = 'https://raw.githubusercontent.com/Input50/Something/master/Games/SlayersUnleased.lua',
		[8982709021] = 'https://raw.githubusercontent.com/RegularVynixu/Scripts/main/YouTube%20Life/Auto%20Farm.lua',
	},
}

-- loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Utilites/Settings.lua"), true))()

-- [[ Variables ]] --
if not Scrumpy then getgenv()["Scrumpy"] = {} end -- Yes I named it that, its to make it harder for other scripts global to interfere
local Settings = getgenv()["Scrumpy"]

getgenv().Alias = 'Nil'
Settings = {
	Logs  = true, -- Enable logs
	Debug = true, -- Unlocks more intensive features for debugging and proofing | WIP
	ID    = game.placeId -- for funny
}


local ST = os.clock()
getgenv().Notifier = function(str, debug) -- global quick print function
    if Settings.Logs then
        if not debug then
            print(tostring(str))
        elseif Settings.Debug then
            warn("[DEBUG] " .. tostring(str))
        end
    end
end

-- [[ Libraries ]] --
if not Promise then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/stellar-4242/Source/main/Promise.lua"))()
    getgenv().Promise = require("{AB02623B-DEB2-4994-8732-BF44E3FDCFBC}")
end

if not ProtectInstance or not UnProtectInstance then
    loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisInstanceProtect.lua"))()
end

if not IrisInit then
    loadstring(game:HttpGet("https://irishost.xyz/InfinityHosting/IrisInit.lua"))()
	loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterConsole.lua"))()
end

if config.ACBs then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"), true))()
end
Notifier("(1/2) Security/Settings Loaded", true)

task.spawn(function ()
	task.desynchronize()
	task.delay(7, function () 
        Notifier("Loading...", true)
		--- Obscure Names
		if config.NR then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"), true))()
			Notifier("(3) Obscurer Deployed", true)
		end
		
		if config.NTR then -- lol
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/NameTag.lua"), true))()
			Notifier("(4) Nametag Remover Deployed", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ADN then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Anti-DisplayName.lua"),true))()
			Notifier("(5) Anti-Display Name Deployed", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ASS then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/AntiStreamSnipe.lua"),true))()
			Notifier("(6) Anti-Stream Snipe protection", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		-- Noclip
		if config.NC then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua"), true))()
			Notifier("(7) Noclip Loaded", true)
		end
	end)
end)

--- Custom | Possibly more addons in the future
if config.Customs then
    for i, v in next, config.Games do
        task.wait()
        if v == Settings.ID then
            local link = config.Games[v]
            spawn(
                function()
                    loadstring(game:HttpGet((link), true))()
                end
            )
            Notifier(place .. ": " .. link, true)
        end
    end
end

-- Benchmark execution speed
DT = os.clock() - ST
Notifier("Took " .. DT .. " seconds to load", true)