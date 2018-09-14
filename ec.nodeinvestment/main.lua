-- Node Investment: Automatically invest your energy in a node
-- Contact: aleegs (forum), aleegs#2539 (discord)
-- https://github.com/aleegs/ec-scripts

local versionString = "1.0"

local ec 				= _G["__EC__"]
local eccore 			= ec.requireScript("ec.core")

local settings = nil

math.randomseed(os.clock()*100000000000)

local settings_template = {
    settings_version = 1,
	enable_auto_energy = false,
	sleep_minutes = 60,
	next_investment_time = 0,
	nodeKey = 1321
}

local isValidNode = function()
	local nodeLevel = ToClient_GetNodeLevel(settings.nodeKey)
	if nil==nodeLevel then return false end
	
	return nodeLevel<10 and isWithdrawablePlant(settings.nodeKey) == true 
end

local investEnergy = function()
	local player = getSelfPlayer()
	if nil == player then return end
	
	local id = Int64toInt32(nodeKey)
	local wp = player:getWp()
	local maxWp = player:getMaxWp()
	
	local investableWp = 0
		
	if wp % 10 == 0 then 
		investableWp = wp
	else
		investableWp = wp - wp % 10
	end
	
	if isValidNode(settings.nodeKey) == true and investableWp >= 10 then
		ec.log("[Node Investment] Available Energy to Invest: "..investableWp)
		ec.log("[Node Investment] Investing "..investableWp.." energy in node "..settings.nodeKey)
		ToClient_RequestIncreaseExperienceNode(settings.nodeKey, investableWp)
	end
end

local strKey = "1321"

local OnRenderMenu = function(ui)
	ui.text("----- Auto Node Investment "..versionString.." -----")
	ui.text("Contact: aleegs (forum), aleegs#2539 (discord)")
	ui.text("")
	ui.text("The following settings are saved")
	ui.text("per CHARACTER (INDIVIDUAL SETTINGS):")
	
	ui.text("")
	
	ui.separator()
	
	if ui.checkbox("Automatically invest Energy in Node", settings.enable_auto_energy) then
		settings.enable_auto_energy = not settings.enable_auto_energy
	end
	
	ui.text("")
	
	ui.pushItemWidth(120)
    _, strKey = ui.inputText("Number (Node ID)##strKey", strKey)
    ui.popItemWidth()
	settings.nodeKey = tonumber(strKey)
	ui.text("* Use BDOCodex/BDDatabase to find the node key")
	
	ui.separator()

	ui.text("Time between cycles")
	_, settings.sleep_minutes = ui.inputInt("Minutes", settings.sleep_minutes)
	
	ui.separator()
	
	local nodeName = ToClient_GetNodeNameByWaypointKey(settings.nodeKey)
	local nodeLevel = ToClient_GetNodeLevel(settings.nodeKey)
	
	if nodeName and nodeLevel and ec.actors.isInWorld() then
		ui.text("- Node Information -")
		ui.text("Name: "..nodeName)
		ui.text("Level: "..nodeLevel.."/10")
	end
	
	if ec.actors.isInWorld() then
		if isValidNode(settings.nodeKey)==true then
			ui.text("Status: OK")
		else
			ui.text("Status: Error. The node is not valid/upgradable")
		end
	end
	
	ui.separator()

	if ui.button(" Invest Energy Now (Test) ") then
		investEnergy()
	end
	
	ui.separator()
	
	local current_time = os.clock()

	if current_time < settings.next_investment_time then
		ui.text("Next energy investment in "..math.floor(settings.next_investment_time-current_time).."s ("..math.floor(((settings.next_investment_time-current_time)/60)).." min)")
	else 
		ui.text("Next energy investment should be now")
	end
	
	ui.separator()
	
	if ui.button(" Reset Timer ") then
		settings.next_investment_time = os.clock()+(settings.sleep_minutes*60)
	end
end


local OnPulse = function()
	local currentTime = os.clock()
	if currentTime < settings.next_investment_time then return end
	
    local selfPlayerActorWrapper = getSelfPlayer()
    if selfPlayerActorWrapper == nil then return end

    local selfPlayerActor = selfPlayerActorWrapper:get()
    if selfPlayerActor == nil then return end
	
	if not(ec.actors.isInWorld()) then return end
		
	if selfPlayerActor:getHp() == 0 then return end
	
	investEnergy()
	
	settings.next_investment_time = os.clock() + (settings.sleep_minutes*60)
	
	ec.log("[Node Investment] Sleeping for "..settings.sleep_minutes.." minutes")
end

local OnLoad = function()
    settings = ec.settings_mgr.LoadCharacterSettings("nodeinvestment", settings_template) 

    if settings.settings_version ~= settings_template.settings_version then
        ec.log("Node Investment settings deprecated, reset them.")
        settings.clear()
    end
	
	if(settings.enable_node_investment==false) then Wait(1) end
	
	registerEvent("EventOpenPassword", "OnGameStart")
end

local OnUnload = function()
    settings.flush()
end

local function OnGameStart()
	ec.log("[Node Investment] OnGameStart: Timer Reset")
	settings.next_investment_time = os.clock()+1
end

ec.registerEvent("EC.OnLoad",       OnLoad)
ec.registerEvent("EC.OnUnload",     OnUnload)
ec.registerEvent("EC.OnPulse", OnPulse)

if ec.main_menu then
	ec.main_menu.AddEntry("Node Investment", OnRenderMenu)
end