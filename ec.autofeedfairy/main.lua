-- AUTO FEED FAIRY
-- Use instant mode at your own risk
-- https://forums.elitecheat.ru/showthread.php?tid=222
-- https://github.com/aleegs/ec-scripts

local versionString = "2.0"

local ec 				= _G["__EC__"]
local eccore 			= ec.requireScript("ec.core")

local settings = nil

local settings_template = {
    settings_version = 1,
	enable_auto_feed_fairy = false,
	wait_fairy_feed = 0,
	min_minutes_fairy_feed_cycle = 15,
	max_minutes_fairy_feed_cycle = 30,
	enable_instant_mode = false
}

math.randomseed(os.clock()*100000000000)

local old_exp = 1337
local wait_for_new_exp = false

local WaitNextFairyFeed = function (sec)
    settings.wait_fairy_feed = os.clock() + sec
end

local OnRenderMenu = function(ui)
	ui.text("----- Auto Feed Fairy Script "..versionString.." -----")
	ui.text("Contact: aleegs (forum), aleegs#2539 (discord)")
	ui.text("")
	ui.text("The following settings are saved")
	ui.text("for all characters (global settings):")
	ui.text("")
	if ui.checkbox("Automatically feed fairy with green items +0", settings.enable_auto_feed_fairy) then
		settings.enable_auto_feed_fairy = not settings.enable_auto_feed_fairy
	end
	
	ui.text("")
	ui.text("Time between cycles (for auto feed)")
	_, settings.min_minutes_fairy_feed_cycle = ui.inputInt("Min. minutes", settings.min_minutes_fairy_feed_cycle)
	_, settings.max_minutes_fairy_feed_cycle = ui.inputInt("Max. minutes", settings.max_minutes_fairy_feed_cycle)
	
		ui.text("")
			if ui.checkbox("Instant = Check, Wait anim (legit) = Uncheck", settings.enable_instant_mode) then
		settings.enable_instant_mode = not settings.enable_instant_mode
	end
	ui.text("    Use instant mode under your own risk")
	if ui.button(" Manual Feed Fairy Now (INSTANT MODE REQUIRED) ") then
		button_feed_fairy()
	end
	
	ui.text("")
	local fairy_current_time = os.clock()

	if fairy_current_time < settings.wait_fairy_feed then
		ui.text("Next auto feed in "..math.floor(settings.wait_fairy_feed-fairy_current_time).."s ("..math.floor(((settings.wait_fairy_feed-fairy_current_time)/60)).." min)")
	else 
		ui.text("Next auto feed should be now")
	end
	
	if ec.actors.isInWorld() then
		if(PaGlobal_FairyInfo_isMaxLevel()) then
			ui.text("")
			ui.text("YOUR FAIRY IS MAX LEVEL")
		end
	end
	
	if ui.button(" Reset timer ") then
		WaitNextFairyFeed(1)
	end
end


local getFairyFoodInvSlots = function()
    local resultsSlot = { }
    
    local selfPlayerWrapper = getSelfPlayer()
    local selfPlayer = selfPlayerWrapper:get()
    local invenSize = getSelfPlayer():get():getInventorySlotCount(true)
	
    for itemIndex = 1, invenSize - 1 do
        local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, itemIndex)
		
        if itemWrapper then
            local shouldAdd = false

			if itemWrapper:isFairyFeedItem() and not(ToClient_Inventory_CheckItemLock(itemIndex, CppEnums.ItemWhereType.eInventory)) then
				shouldAdd = true
			end
            
            if shouldAdd then      
                table.insert(resultsSlot, itemIndex)
            end
        end
    end

    return resultsSlot
end

local ECFairyFoodHandler = function ()
	if(settings.enable_auto_feed_fairy) then
		local fairy_current_time = os.clock()
		if fairy_current_time < settings.wait_fairy_feed then
			return
		end
		
		if(settings.enable_instant_mode) then
			if(tlen(getFairyFoodInvSlots())>0) then 
				for _, slotNo in pairs(getFairyFoodInvSlots()) do
					local itemWrapper = getInventoryItem(slotNo)
					local itemSSW = itemWrapper:getStaticStatus()
					local itemName = itemSSW:getName()
					ec.log("Feeding item "..itemName.." to fairy (INSTANT MODE)")
					ToClient_FairyFeedingRequest(PaGlobal_FairyInfo_GetFairyNo(), itemWrapper:get():getKey(), slotNo, 1, false)
				end
				local waitftime = math.random(settings.min_minutes_fairy_feed_cycle*60, settings.max_minutes_fairy_feed_cycle*60)
				ec.log("(Instant Mode) Automatically fed fairy... Sleeping for "..(waitftime/60).." minutes.") 
				WaitNextFairyFeed(waitftime)
			else
				local waitftime = math.random(settings.min_minutes_fairy_feed_cycle*60, settings.max_minutes_fairy_feed_cycle*60)
				ec.log("(Instant Mode) No food for fairy... Sleeping for "..(waitftime/60).." minutes.") 
				WaitNextFairyFeed(waitftime)
			end
		else
			if(wait_for_new_exp) then 
				if (old_exp == PaGlobal_FairyInfo_CurrentExpRate()) then return
				else wait_for_new_exp = false end
			end
			
			if(tlen(getFairyFoodInvSlots())==0) then 
				local waitftime = math.random(settings.min_minutes_fairy_feed_cycle*60, settings.max_minutes_fairy_feed_cycle*60)
				WaitNextFairyFeed(waitftime)
				ec.log("No fairy food found... Sleeping for "..(waitftime/60).." minutes.") 
				if true==Panel_FairyInfo:GetShow() then PaGlobal_FairyInfo_Close() end
				if true==Panel_Window_FairyUpgrade:GetShow() then PaGlobal_FairyUpgrade_Close() end
				return 
			end
			
			if false==Panel_FairyInfo:GetShow() then PaGlobal_FairyInfo_Open(true) end
			if false==Panel_Window_FairyUpgrade:GetShow() then PaGlobal_FairyUpgrade_Open(true) end
			
			if false==Panel_FairyInfo:GetShow() then return end
			if false==Panel_Window_FairyUpgrade:GetShow() then return end
			
			local _mainBG = UI.getChildControl(Panel_Window_FairyUpgrade, "Static_MainBG")
			local buttonmultiupgrade = UI.getChildControl(_mainBG, "CheckButton_Stream")
			buttonmultiupgrade:SetCheck(true)
			
			local slotNo = getFairyFoodInvSlots()[1]
			local itemWrapper = getInventoryItem(slotNo)
			local itemSSW = itemWrapper:getStaticStatus()
			local itemName = itemSSW:getName()
			
			ec.log("Feeding item "..itemName.." to fairy")
				
			PaGlobal_FairyUpgrade_RClickItem(itemWrapper:get():getKey(), slotNo, 1)
			PaGlobal_FairyUpgrade_Request()
			MessageBox.keyProcessEnter()

			old_exp = PaGlobal_FairyInfo_CurrentExpRate()
			wait_for_new_exp = true
		end
	end
end

function button_feed_fairy()
	if(settings.enable_instant_mode) then
		if ec.actors.isInWorld() then
			if(tlen(getFairyFoodInvSlots())>0) then 
				for _, slotNo in pairs(getFairyFoodInvSlots()) do
					local itemWrapper = getInventoryItem(slotNo)
					local itemSSW = itemWrapper:getStaticStatus()
					local itemName = itemSSW:getName()
					ec.log("Feeding item "..itemName.." to fairy (INSTANT MODE-MANUAL)")
					ToClient_FairyFeedingRequest(PaGlobal_FairyInfo_GetFairyNo(), itemWrapper:get():getKey(), slotNo, 1, false)
				end
				ec.log("(Instant Mode) Manually fed fairy")
			else
				ec.log("(Instant Mode) No food for fairy...")
			end
		end
	else
		ec.log("Manual feed is only supported for instant mode")
	end
end

function tlen(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local OnPulse = function()
    local selfPlayerActorWrapper = getSelfPlayer()
    if selfPlayerActorWrapper == nil then return end

    local selfPlayerActor = selfPlayerActorWrapper:get()
    if selfPlayerActor == nil then return end
	
	if not(ec.actors.isInWorld()) then return end
	
	if selfPlayerActor:getHp() == 0 then return end
	
	if(PaGlobal_FairyInfo_GetFairyNo()) then
		if (settings.enable_auto_feed_fairy) and PaGlobal_FairyInfo_isMaxLevel()==false then
			ECFairyFoodHandler()
		end
	end
end


local OnLoad = function()
    settings = ec.settings_mgr.LoadGlobalSettings("autofeedfairy", settings_template) 

    if settings.settings_version ~= settings_template.settings_version then
        ec.log("Auto feed fairy settings deprecated, reset them.")
        settings.clear()
    end
	registerEvent("EventOpenPassword", "OnGameStart")
end

local OnUnload = function()
	WaitNextFairyFeed(1)
    settings.flush()
end

local function OnGameStart()
	ec.log("[Auto Feed Fairy] OnGameStart: Timer Reset")
	WaitNextFairyFeed(1)
end

ec.registerEvent("EC.OnLoad",       OnLoad)
ec.registerEvent("EC.OnUnload",     OnUnload)
ec.registerEvent("EC.OnPulse", OnPulse)

if ec.main_menu then
	ec.main_menu.AddEntry("Auto Feed Fairy", OnRenderMenu)
end
