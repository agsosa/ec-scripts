-- PLAYERESP
-- Contact: aleegs (forum), aleegs#2539 (discord)
-- https://forums.elitecheat.ru/showthread.php?tid=225
-- https://github.com/aleegs/ec-scripts

local versionString = "2.0"

local DEFAULT_UPDATE_RATE = 1
local DEFAULT_MAX_DISTANCE = 3300
local MAX_POSSIBLE_DISTANCE = 6900
local MAX_POSSIBLE_UPDATE_RATE = 5

local ec 				= _G["__EC__"]
local eccore 			= ec.requireScript("ec.core")

local settings = nil

local settings_template = {
    settings_version = 1,
	show_others_gs = false,
	force_show_healthbar = false,
	disable_camouflages = false,
	max_distance = DEFAULT_MAX_DISTANCE,
	update_rate = DEFAULT_UPDATE_RATE,
}

local isNameESPEnabled = function() 
	return settings.show_others_gs or settings.force_show_healthbar or settings.disable_camouflages
end

local OnRenderMenu = function(ui)
	ui.text("----- Player ESP Script "..versionString.." (VIP) -----")
	ui.text("Contact: aleegs (forum), aleegs#2539 (discord)")
	ui.text("")
	ui.text("The following settings are saved")
	ui.text("for all characters (global settings):")
	ui.text("")
	
	if ui.checkbox("Show Others GS & Level", settings.show_others_gs) then
		settings.show_others_gs = not settings.show_others_gs
	end
	
	if ui.checkbox("Force Show Health Bar", settings.force_show_healthbar) then
		settings.force_show_healthbar = not settings.force_show_healthbar
	end
	
	if ui.checkbox("Anti-Camouflages", settings.disable_camouflages) then
		settings.disable_camouflages = not settings.disable_camouflages
	end
	
	ui.text("")
	ui.text("Advanced - Change these values if you have FPS problems")
	_, settings.update_rate = ui.sliderFloat("Update Rate (seconds)", settings.update_rate, 0.1, MAX_POSSIBLE_UPDATE_RATE)
	_, settings.max_distance = ui.sliderFloat("Distance", settings.max_distance, 1, MAX_POSSIBLE_DISTANCE)
	
	if ui.button(" Set Default Values ") then
		settings.update_rate = DEFAULT_UPDATE_RATE
		settings.max_distance = DEFAULT_MAX_DISTANCE
	end
end

local lastUpdateTime = 0
function WaitUpdate(sec)
    lastUpdateTime = os.clock() + sec
end

local need_to_refresh_tags = true
local delayed_player_esp_boolean = false
local delayed_show_others_gs_boolean = false
local delayed_disable_camouflages_boolean = false

local nameTendencyColor = function(tendency)
  local r, g, b = 0, 0, 0
  local upValue = 300000
  local downValue = -1000000
  if tendency > 0 then
    local percents = tendency / upValue
    r = math.floor(203 - 203 * percents)
    g = math.floor(203 - 203 * percents)
    b = math.floor(203 + 52 * percents)
  else
    local percents = tendency / downValue
    r = math.floor(203 + 52 * percents)
    g = math.floor(203 - 203 * percents)
    b = math.floor(203 - 203 * percents)
  end
  local sumColorValue = 4278190080 + 65536 * r + 256 * g + b
  return sumColorValue
end

local ECPlayerESPHandler = function ()
	local current_time_pe = os.clock()
	if current_time_pe < lastUpdateTime then
		return
	end

	-- Refresh tags when needed (on settings changed)
	if(delayed_player_esp_boolean~=isNameESPEnabled()) then
		ec.log("[Player ESP] All Player ESP options are now disabled")
		delayed_player_esp_boolean=isNameESPEnabled()
		need_to_refresh_tags = true
	end
	
	if(delayed_show_others_gs_boolean~=settings.show_others_gs) then
		ec.log("[Player ESP] Settings changed")
		delayed_show_others_gs_boolean=settings.show_others_gs
		need_to_refresh_tags = true
	end
	
	if(delayed_disable_camouflages_boolean~=settings.disable_camouflages) then
		ec.log("[Player ESP] Settings changed")
		delayed_disable_camouflages_boolean=settings.disable_camouflages
		need_to_refresh_tags = true
	end
	
	if(need_to_refresh_tags) then
		ec.log("[Player ESP] Refreshing name tags..")
		for _, key in ipairs(ec.actors.getActorsKey(settings.max_distance)) do
			FromClient_ChangeMilitiaNameTag(key)
		end
		need_to_refresh_tags = false
		return
	end
		
	for _, key in ipairs(ec.actors.getActorsKey(settings.max_distance)) do
		local actor = getActor(key)
		if(actor==nil) then return end
		
		if actor:get():isPlayer() and not(actor:get():isSelfPlayer()) and actor:get():getHp()>0 then
			
			local characterActor = getCharacterActor(key)
			if(characterActor==nil) then return end
			local playerActor = getPlayerActor(key)
			if(playerActor==nil) then return end
			
			local normal_name = actor:getName()
			local usingCamouflage = normal_name==""
			local hiddenName = actor:getOriginalName()
			local familyName = playerActor:getUserNickname()
			local gearScore = math.floor(playerActor:get():getTotalStatValue())
			local guildName = playerActor:getGuildName()
			local level = playerActor:get():getLevel()

			local onlyShowGS = false
					
			if usingCamouflage == false then onlyShowGS = true end

			if (settings.force_show_healthbar) then EventActorAddDamage(key, 1, 0, 0) end -- Force show HP bar
					
			local panel = actor:get():getUIPanel()
			local alias = UI.getChildControl(panel, "CharacterAlias") -- title
			local guildUITag = UI.getChildControl(panel, "CharacterGuild")
			
			if (onlyShowGS and settings.show_others_gs) then -- player without camouflage
				if(alias:GetShow()==false) then
					guildUITag:SetText("<"..guildName..">\n\n")
					guildUITag:SetScale(1,1)
				end
				alias:SetFontColor(Defines.Color.C_FFEE7001) 
				alias:useGlowFont(true, "BaseFont_10_Glow", Defines.Color.C_FFEEBA3E)
				alias:SetText(" [ GS : "..gearScore.." ] Lv"..level)
				alias:SetShow(true)
				alias:SetScale(1,1)
			else -- player with camouflage
				if(settings.disable_camouflages and not(onlyShowGS)) then
					local nameTag = UI.getChildControl(panel, "CharacterName")
					local family = UI.getChildControl(panel, "CharacterTitle")
					
					if(guildName~="") then
						guildUITag:SetFontColor(4293914607)
						guildUITag:useGlowFont(true, "BaseFont_10_Glow", 4279004349)
						guildUITag:SetShow(true)
						guildUITag:SetText("<"..guildName..">")
					end
					
					nameTag:SetText("(CAMOUFLAGE) "..hiddenName)
					nameTag:SetFontColor(Defines.Color.C_FFFFFFFF)
					nameTag:SetShow(true)
					
					local glow = C_FFFFFFFF
					local playerTendency = playerActor:get():getTendency()
					
					if ec.actors.isActorAttackable(key) then ec.log("is attackable = true "..hiddenName) glow = Defines.Color.C_FFFF0000 end
					
					family:SetFontColor(Defines.Color.C_FFFFFFFF)
					family:useGlowFont(true, "BaseFont_10_Glow", glow)
					family:SetText("(CAMOUFLAGE) "..familyName)
					family:SetShow(true)
					
					if(settings.show_others_gs) then
						alias:SetFontColor(Defines.Color.C_FFEE7001) 
						alias:useGlowFont(true, "BaseFont_10_Glow", Defines.Color.C_FFEEBA3E)
						alias:SetText("[ GS : "..gearScore.." ] Lv"..level)
						alias:SetShow(true)
						alias:SetScale(1, 1)
					end
				end
			end
		end
	end
	
	WaitUpdate(settings.update_rate)
end

local OnPulse = function()
    local selfPlayerActorWrapper = getSelfPlayer()
    if selfPlayerActorWrapper == nil then return end

    local selfPlayerActor = selfPlayerActorWrapper:get()
    if selfPlayerActor == nil then return end
	
	if not(ec.actors.isInWorld()) then return end
	
	ECPlayerESPHandler()
end

local OnLoad = function()
    settings = ec.settings_mgr.LoadGlobalSettings("playerESP", settings_template) 

    if settings.settings_version ~= settings_template.settings_version then
        ec.log("Player ESP settings deprecated, reset them.")
        settings.clear()
    end
	
	delayed_player_esp_boolean = isNameESPEnabled()
	delayed_disable_camouflages_boolean = settings.disable_camouflages
	delayed_show_others_gs_boolean = settings.show_others_gs
end

local OnUnload = function()
    settings.flush()
end

ec.registerEvent("EC.OnLoad", OnLoad)
ec.registerEvent("EC.OnUnload", OnUnload)
ec.registerEvent("EC.OnPulse", OnPulse)

if ec.main_menu then
	ec.main_menu.AddEntry("Player ESP", OnRenderMenu)
end