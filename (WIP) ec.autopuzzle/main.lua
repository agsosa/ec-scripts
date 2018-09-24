-- Script to automatically combine valencia scrolls/mediah books/calph relics/kama dolls

local ec 		        = _G["__EC__"]

-- TODO: Implement settings and UI

local enabled = true
local TICK_WAIT_TIME = 1 -- Seconds
local CALPH_RELIC_ITEM_ID = 40218
local MEDIAH_BOOK_ITEM_ID = 40220
local VALENCIA_SCROLL_ITEM_ID = 40228
local KAMA_DOLL_ITEM_ID = 40383

local nextTick = 0

local function doCombine(itemKey)
	local inventory = ((getSelfPlayer()):get()):getInventoryByType(CppEnums.ItemWhereType.eInventory)
	if inventory == nil then return end
	
	local invenMaxSize = inventory:sizeXXX()
	local tItems = {}
	local cItems = 0

	for i = 0, invenMaxSize - 1 do
		local itemWrapper = getInventoryItem(i)
		if itemWrapper ~= nil then      
			if ((itemWrapper:get()):getKey()):getItemKey() == itemKey then
				cItems = cItems + 1
				tItems[cItems] = i
			end
		end
	end
	
	if cItems >= 5 then
		if findPuzzleAndReadyMake(0) then
			requestMakePuzzle()
		else
			local cSlots = {3,10,11,12,19}
			
			if tItems[1] ~= cSlots[1] then
				inventory_swapItem(0, tItems[1], cSlots[1])
			end
			if tItems[2] ~= cSlots[2] then
				inventory_swapItem(0, tItems[2], cSlots[2])
			end
			if tItems[3] ~= cSlots[3] then
				inventory_swapItem(0, tItems[3], cSlots[3])
			end
			if tItems[4] ~= cSlots[4] then
				inventory_swapItem(0, tItems[4], cSlots[4])
			end
			if tItems[5] ~= cSlots[5] then
				inventory_swapItem(0, tItems[5], cSlots[5])
			end
			
			if findPuzzleAndReadyMake(0) then
				requestMakePuzzle()
			end
		end
	end
end

local function invGetItemCountByItemId(aId, aEnchantLevel)
      local count = 0
	  
      local inventory = getSelfPlayer():get():getInventoryByType(CppEnums.ItemWhereType.eInventory)

      if inventory == nil then return count end

      local invenMaxSize = inventory:sizeXXX()

      for ii = 0, invenMaxSize - 1 do
        local itemWrapper = getInventoryItem(ii)

        if itemWrapper ~= nil then
			local itemId = itemWrapper:get():getKey():getItemKey()
			local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
			
			if itemId == aId and enchantLevel == aEnchantLevel then
				count = count + Int64toInt32(itemWrapper:get():getCount_s64())
			end
        end
      end

      return count
end

local function tryToCombine()
	--ec.log("[Auto Puzzle] Cheking inventory...")
	if invGetItemCountByItemId(CALPH_RELIC_ITEM_ID, 0) >= 5 then
		--ec.log("[Auto Puzzle] Combine Relics.")
		doCombine(CALPH_RELIC_ITEM_ID)
	end
	if invGetItemCountByItemId(MEDIAH_BOOK_ITEM_ID, 0) >= 5 then
	--	ec.log("[Auto Puzzle] Combine Books.")
		doCombine(MEDIAH_BOOK_ITEM_ID)
	end
	if invGetItemCountByItemId(VALENCIA_SCROLL_ITEM_ID, 0) >= 5 then
		--ec.log("[Auto Puzzle] Combine Scrolls.")
		doCombine(VALENCIA_SCROLL_ITEM_ID)
	end
	if invGetItemCountByItemId(KAMA_DOLL_ITEM_ID, 0) >= 5 then
		--ec.log("[Auto Puzzle] Combine Dolls.")
		doCombine(KAMA_DOLL_ITEM_ID)
	end
end

local function OnPulse()
	if enabled==false then return end
	if not getSelfPlayer() then return end
	if not getSelfPlayer():get() then return end
	if not getSelfPlayer():get():getInventoryByType(CppEnums.ItemWhereType.eInventory) then return end
	if os.clock() > nextTick then
		tryToCombine()
		nextTick = os.clock() + TICK_WAIT_TIME
	end
end

ec.registerEvent("EC.OnPulse", OnPulse)