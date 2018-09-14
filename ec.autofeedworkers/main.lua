-- AUTO FEED WORKERS
-- Contact: aleegs (forum), aleegs#2539 (discord)
-- https://forums.elitecheat.ru/showthread.php?tid=218
-- https://github.com/aleegs/ec-scripts

local versionString = "2.0"

local ec 				= _G["__EC__"]
local eccore 			= ec.requireScript("ec.core")

local settings = nil

local settings_template = {
    settings_version = 1,
	enable_auto_feed_workers = true,
	enable_repeat_all_workers_task = true,
	wait_workers_feed = 0,
	min_minutes_workers_feed_cycle = 15,
	max_minutes_workers_feed_cycle = 30,
}

math.randomseed(os.clock()*100000000000)

local OnRenderMenu = function(ui)
	ui.text("----- Auto Feed Workers Script "..versionString.." -----")
	ui.text("Contact: aleegs (forum), aleegs#2539 (discord)")
	ui.text("")
	ui.text("The following settings are saved")
	ui.text("for all characters (global settings):")
	ui.text("")
	
	if ui.checkbox("Automatically feed workers", settings.enable_auto_feed_workers) then
		settings.enable_auto_feed_workers = not settings.enable_auto_feed_workers
	end
	
	ui.text("")
	ui.text("Time between cycles (for auto feed)")
	_, settings.min_minutes_workers_feed_cycle = ui.inputInt("Min. minutes", settings.min_minutes_workers_feed_cycle)
	_, settings.max_minutes_workers_feed_cycle = ui.inputInt("Max. minutes", settings.max_minutes_workers_feed_cycle)
	
	ui.text("")
	if ui.checkbox("Repeat all workers tasks", settings.enable_repeat_all_workers_task) then
		settings.enable_repeat_all_workers_task = not settings.enable_repeat_all_workers_task
	end

	ui.text("")
	local wcurrenttime = os.clock()
	if wcurrenttime < settings.wait_workers_feed then
		ui.text("Next auto feed in "..math.floor(settings.wait_workers_feed-wcurrenttime).."s ("..math.floor(((settings.wait_workers_feed-wcurrenttime)/60)).." min)")
	else 
		ui.text("Next auto feed should be now")
	end
	
	if ec.actors.isInWorld() then 
		local restoreItemHasCount = ToClient_getNpcRecoveryItemList()
		if(restoreItemHasCount < 1) then
			ui.text("")
			ui.text("No worker food detected!")
		end
	end
	
	if ui.button(" Reset timer ") then
		WaitNextBeer(1)
	end
end

function WaitNextBeer(sec)
    settings.wait_workers_feed = os.clock() + sec
end

local ECWorkerFeedHandler = function ()
	local current_time_w = os.clock()
	if current_time_w < settings.wait_workers_feed then
		return
	end
	local restoreItemHasCount = ToClient_getNpcRecoveryItemList()
	if restoreItemHasCount > 0 then
		ec.log("[Auto Feed Workers] FEEDING WORKERS <START>")
		workerManager_Open()

		HandleClicked_workerManager_RestoreAll() -- open worker restore all window

		workerRestoreAll_Confirm(0) -- confirm restore all with first item

		if settings.enable_repeat_all_workers_task then 
			HandleClicked_workerManager_ReDoAll() -- repeat worker tasks
			ec.log("[Auto Feed Workers] REPEATING ALL WORKERS TASKS")
		else ec.log("[Auto Feed Workers] THE OPTION TO REPEAT ALL WORKERS TASKS IS DISABLED.")
		end

		HandleClicked_WorkerManager_Close()
		ec.log("[Auto Feed Workers] FEEDING WORKERS <END>")

		local waittimew = math.random(settings.min_minutes_workers_feed_cycle*60, settings.max_minutes_workers_feed_cycle*60)
		WaitNextBeer(waittimew)
		ec.log("[Auto Feed Workers] NEXT CYCLE IN "..(waittimew/60).." MINUTES!")
	end
end

local OnPulse = function()	
    local selfPlayerActorWrapper = getSelfPlayer()
    if selfPlayerActorWrapper == nil then return end

    local selfPlayerActor = selfPlayerActorWrapper:get()
    if selfPlayerActor == nil then return end
	
	if not(ec.actors.isInWorld()) then return end
	
	if selfPlayerActor:getHp() == 0 then return end
	
	if (settings.enable_auto_feed_workers) then
		ECWorkerFeedHandler()
	end
end

local OnLoad = function()
    settings = ec.settings_mgr.LoadGlobalSettings("autofeedworkers", settings_template) 

    if settings.settings_version ~= settings_template.settings_version then
        ec.log("Auto feed workers settings deprecated, reset them.")
        settings.clear()
    end
	
	if(settings.enable_auto_feed_workers==false) then WaitNextBeer(1) end
	
	registerEvent("EventOpenPassword", "OnGameStart")
end

local OnUnload = function()
    settings.flush()
end

function OnGameStart()
	ec.log("[Auto Feed Workers] OnGameStart: Timer Reset")
	WaitNextBeer(1)
end

ec.registerEvent("EC.OnLoad",       OnLoad)
ec.registerEvent("EC.OnUnload",     OnUnload)
ec.registerEvent("EC.OnPulse", OnPulse)

if ec.main_menu then
	ec.main_menu.AddEntry("Auto Feed Workers", OnRenderMenu)
end