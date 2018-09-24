-- My Discord: aleegs#2539
-- Script to log and analyze silver gains (compatible with ec's bot). Work in progress.
local ec 				  = _G["__EC__"]

local settings = nil

local versionString = "1.0"

local settings_template = {
    settings_version = 10,
	record_silver_earnings = true,
	stop_after_1hour = true,
	use_value_pack = true,
	record_earnings = 0,
	type_market_price = 1, -- 0 = min price, 1 = max price, 2 = avg price
	hours = 0,
	seconds = 0, -- TODO: optimize to prevent unnecessary disk usage
	minutes = 0, -- TODO: optimize to prevent unnecessary disk usage
	itemLogTotalSilver = {},
	itemLogTotalCount = {}
}

local function comma_value(amount) -- credits: http://lua-users.org/wiki/FormattingNumbers (sam_lie)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

local strFileName = "Fadus"

local OnRenderMenu = function(ui)
	ui.text("----- Silver Stats ver "..versionString.." (Free) -----")
	ui.text("Contact: aleegs (forum), aleegs#2539 (discord)")
	ui.text("")
	ui.text("The following settings are saved")
	ui.text("for all characters (global settings):")
	ui.text("")
	
	if ui.checkbox("Enable Recording", settings.record_silver_earnings) then
		settings.record_silver_earnings = not settings.record_silver_earnings
	end
	
	if ui.checkbox("Automatically stop recording after 1 hour", settings.stop_after_1hour) then
		settings.stop_after_1hour = not settings.stop_after_1hour
	end
	
	ui.text("")
	local tMarketPrice
    if settings.type_market_price==0 then
        tMarketPrice = "Calculate Min. price"
    elseif settings.type_market_price==1 then
        tMarketPrice = "Calculate Max. price"
    else
		tMarketPrice = "Calculate Avg. price"
	end
	
	if ui.checkbox("Ignore Green Armor/Weapons +0", settings.stop_after_1hour) then
		settings.stop_after_1hour = not settings.stop_after_1hour
	end
	
	if ui.beginCombo("Market Items##select_market_price_calc", tMarketPrice) then
        if ui.selectable("Calculate Min. price") then
            settings.type_market_price = 0
        end
		if ui.selectable("Calculate Max. price") then
            settings.type_market_price = 1
        end
		if ui.selectable("Calculate Avg. price") then
            settings.type_market_price = 2
        end
        ui.endCombo()
    end
	
	if ui.checkbox("Take Value Pack into Account", settings.use_value_pack) then
		settings.use_value_pack = not settings.use_value_pack
	end
	
	ui.text("")
	
	ui.separator()
	
	ui.text("")
	
	ui.text("Total time recorded: "..settings.hours..":"..settings.minutes..":"..settings.seconds)
	
	local total_seconds = settings.seconds + settings.minutes*60 + settings.hours*3600
	
	if settings.seconds>0 then
		ui.text("")
		ui.text("Total Silver Gain: "..comma_value(math.floor(settings.record_earnings)))
		ui.text("Calculated Silver/h: "..comma_value(math.floor((3600*math.floor(settings.record_earnings))/total_seconds)))
		ui.text("* Let it run for 1 hour minimum")
	end
	
	ui.text("")
	
	for name,v in pairs(settings.itemLogTotalSilver) do
		if settings.itemLogTotalCount[name] then
			ui.text(name.." x"..settings.itemLogTotalCount[name].." = "..comma_value(math.floor(v))) -- TODO add percentage total earnings
		end
	end
	
	ui.text("")
	
	_, strFileName = ui.inputText("File Name##strFileName", strFileName)
	if ui.button(" Save Stats to File (WIP) ") then
		-- TODO save stats to txt
		--ui.text("Saved file to EC Folder/Scripts/ec.grindstats/"..strFileName..".txt")
	end
	
	ui.text("")
	
	if ui.button(" Reset Stats ") then
		settings.hours = 0
		settings.minutes = 0
		settings.record_earnings = 0
		settings.seconds = 0
		for name,v in pairs(settings.itemLogTotalSilver) do
			settings.itemLogTotalSilver[name] = nil
		end
		
		for name,v in pairs(settings.itemLogTotalCount) do
			settings.itemLogTotalCount[name] = nil
		end
	end
	 
end

local OnLoad = function()
    settings = ec.settings_mgr.LoadGlobalSettings("SilverStats", settings_template) 

    if settings.settings_version ~= settings_template.settings_version then
        ec.log("Silver Stats settings deprecated, reset them.")
        settings.clear()
    end
	ec.main_menu.AddEntry("Silver Stats", OnRenderMenu) 
	registerEvent("EventAddItemToInventory", "Inventory_AddItem_Stats")
end

local OnUnload = function()
	settings.flush()
	unregisterEvent("EventAddItemToInventory", "Inventory_AddItem_Stats")
end

local nextUpdateT = 0

local OnPulse = function()
	if os.clock() < nextUpdateT then return end
	if settings.record_silver_earnings == false then return end
	if settings.seconds >= 60 then 
		settings.seconds = 0 
		settings.minutes = settings.minutes + 1 
		if settings.minutes >= 60 then 
			settings.minutes = 0 
			settings.hours = settings.hours+1 
		end 
	end
	settings.seconds = settings.seconds + 1
	nextUpdateT = os.clock()+1
	if settings.stop_after_1hour and settings.hours >= 1 then settings.record_silver_earnings = false end
end

function Inventory_AddItem_Stats(itemKey, slotNo, itemCount)
	if settings.record_silver_earnings == false then return end
	
	local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, slotNo)
	
	if itemWrapper then 
		local itemSSW   = itemWrapper:getStaticStatus()
		if(itemSSW) then
			local itemGrade = itemSSW:getGradeType()
			local enchantLevel = itemSSW:get()._key:getEnchantLevel()
			local masterInfo = getItemMarketMasterByItemEnchantKey(itemSSW:get()._key:get())
			local itemName = itemSSW:getName()
			local itemOriginalPrice = Int64toInt32(itemSSW:get()._originalPrice_s64)/10
			
			local itemCount32 = Int64toInt32(itemCount)
			local marketValue = 0
			
			local isSilver = itemKey==1

			-- Get market price
			if masterInfo then
				local itemMaxPrice = masterInfo:getMaxPrice()
				local itemMinPrice = masterInfo:getMinPrice()
				if settings.type_market_price == 1 then marketValue = Int64toInt32(itemMaxPrice)
				elseif settings.type_market_price == 0 then marketValue = Int64toInt32(itemMinPrice)
				else marketValue = (Int64toInt32(itemMaxPrice)+Int64toInt32(itemMinPrice)) / 2 end
				
				ec.log(itemName.." Market Value = "..comma_value(marketValue))
			end
			
			local lootValue = 0
			
			if isSilver == false then -- is item
				if marketValue==0 then -- npc items
					lootValue = itemCount32*itemOriginalPrice
					settings.record_earnings = lootValue+settings.record_earnings
				else -- items with market price
					local constVP = 0.65 -- without value pack
					if settings.use_value_pack == true then constVP = 0.845 end -- with value pack
					lootValue = marketValue*itemCount32*constVP
					settings.record_earnings = lootValue+settings.record_earnings
				end
			else -- is silver
				lootValue = itemCount32
				settings.record_earnings = lootValue+settings.record_earnings
			end

			-- loot history
			if settings.itemLogTotalSilver[itemName] then -- item is already logged
				settings.itemLogTotalSilver[itemName] = lootValue+settings.itemLogTotalSilver[itemName]
				if settings.itemLogTotalCount[itemName] then
					settings.itemLogTotalCount[itemName] = settings.itemLogTotalCount[itemName] + itemCount32
				else
					settings.itemLogTotalCount[itemName] = itemCount32
				end
			else -- new item added to log
				settings.itemLogTotalSilver[itemName] = lootValue
				settings.itemLogTotalCount[itemName] = itemCount32
			end
			
		end
	end
end

ec.registerEvent("EC.OnLoad",       OnLoad)
ec.registerEvent("EC.OnUnload",     OnUnload)
ec.registerEvent("EC.OnPulse",     OnPulse)