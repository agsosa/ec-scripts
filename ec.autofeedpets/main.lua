-- AUTO FEED PETS
-- https://forums.elitecheat.ru/showthread.php?tid=219
-- https://github.com/aleegs/ec-scripts

local versionString = "2.0"

local ec 				= _G["__EC__"]
local eccore 			= ec.requireScript("ec.core")

local settings = nil

local settings_template = {
    settings_version = 1,
	enable_auto_feed_pets = true,
	wait_pets_feed = 0,
	min_minutes_pets_feed_cycle = 15,
	max_minutes_pets_feed_cycle = 30,
}

math.randomseed(os.clock()*100000000000)

local OnRenderMenu = function(ui)
	ui.text("----- Auto Feed Pets Script "..versionString.." -----")
	ui.text("Contact: aleegs (forum), aleegs#2539 (discord)")
	ui.text("")
	ui.text("The following settings are saved")
	ui.text("for all characters (global settings):")
	ui.text("")
	
	if ui.checkbox("Automatically feed Pets", settings.enable_auto_feed_pets) then
		settings.enable_auto_feed_pets = not settings.enable_auto_feed_pets
	end
	
	ui.text("")
	ui.text("Time between cycles (for auto feed)")
	_, settings.min_minutes_pets_feed_cycle = ui.inputInt("Min. minutes", settings.min_minutes_pets_feed_cycle)
	_, settings.max_minutes_pets_feed_cycle = ui.inputInt("Max. minutes", settings.max_minutes_pets_feed_cycle)
	

	ui.text("")
	local pcurrenttime = os.clock()
	if pcurrenttime < settings.wait_pets_feed then
		ui.text("Next auto feed in "..math.floor(settings.wait_pets_feed-pcurrenttime).."s ("..math.floor(((settings.wait_pets_feed-pcurrenttime)/60)).." min)")
	else 
		ui.text("Next auto feed should be now")
	end
	
	if ec.actors.isInWorld() then 
		local userFeedItemCountPet = ToClient_Pet_GetFeedItemCount()
		if(userFeedItemCountPet < 1) then
			ui.text("")
			ui.text("No pet food detected!")
		end
	end
	
	if ui.button(" Reset timer ") then
		WaitForPetFeed(1)
	end
end

function WaitForPetFeed(sec)
    settings.wait_pets_feed = os.clock() + sec
end

local ECPetFeedHandler = function ()
	local current_timep = os.clock()
	if current_timep < settings.wait_pets_feed then
		return
	end
	
	local userFeedItemCountPet = ToClient_Pet_GetFeedItemCount()
	if userFeedItemCountPet > 0 then
		ec.log("[Auto Feed Pets] FEEDING PETS <START>")
		
		FGlobal_PetListNew_Open()
		
		HandleClicked_PetList_FeedAll()
		HandleClicked_PetList_FeedItemToAll(0)
		PetList_useFeedItemToAll()
		
		HandleClicked_PetList_FeedAllClose()
		FGlobal_PetList_FeedClose()
		FGlobal_PetListNew_Close()
		
		ec.log("[Auto Feed Pets] FEEDING PETS <END>")

		local waitpettime = math.random(settings.min_minutes_pets_feed_cycle*60, settings.max_minutes_pets_feed_cycle*60)
		WaitForPetFeed(waitpettime)
		ec.log("[Auto Feed Pets] NEXT CYCLE IN "..(waitpettime/60).." MINUTES!")
	end
end

local OnPulse = function()
    local selfPlayerActorWrapper = getSelfPlayer()
    if selfPlayerActorWrapper == nil then return end

    local selfPlayerActor = selfPlayerActorWrapper:get()
    if selfPlayerActor == nil then return end
	
	if not(ec.actors.isInWorld()) then return end
	
	if selfPlayerActor:getHp() == 0 then return end
	
	if (settings.enable_auto_feed_pets) then
		ECPetFeedHandler()
	end
end

local OnLoad = function()
    settings = ec.settings_mgr.LoadGlobalSettings("autofeedpets", settings_template) 

    if settings.settings_version ~= settings_template.settings_version then
        ec.log("Auto feed pets settings deprecated, reset them.")
        settings.clear()
    end
	registerEvent("EventOpenPassword", "OnGameStart")
end

local OnUnload = function()
    settings.flush()
end

function OnGameStart()
	ec.log("[Auto Feed Pets] OnGameStart: Timer Reset")
	WaitForPetFeed(1)
end

ec.registerEvent("EC.OnLoad",       OnLoad)
ec.registerEvent("EC.OnUnload",     OnUnload)
ec.registerEvent("EC.OnPulse", OnPulse)

if ec.main_menu then
	ec.main_menu.AddEntry("Auto Feed Pets", OnRenderMenu)
end
