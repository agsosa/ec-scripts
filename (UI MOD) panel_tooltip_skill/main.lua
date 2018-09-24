-- Simple UI mod for BDO to show SKILL ID and LEVEL in skill tooltips (useful to make combat scripts etc)
local UI_TM = CppEnums.TextMode
local UI_classType = CppEnums.ClassType
local ToolTipSkillUI = {
  main = Panel_Tooltip_Skill,
  skillName = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_Name"),
  skillIcon = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_Icon"),
  skillLevel = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_Level"),
  useCondition_category = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_category"),
  useCondition_category_panel = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_panel"),
  needHP = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needHP"),
  needHP_value = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needHP_value"),
  needMP = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needMP"),
  needMP_value = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needMP_value"),
  needSP = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needSP"),
  needSP_value = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needSP_value"),
  needItem = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needItem"),
  needItem_value = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_needItem_value"),
  reuseCycle = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_reuseCycle"),
  reuseCycle_value = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseCondition_reuseCycle_value"),
  useMethod = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_UseMethod"),
  skillEffect_category = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_SkillEffect_category"),
  skillEffect_panel = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_SkillEffect_panel"),
  skillEffect_value = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_SkillEffect_buff_value"),
  awakeningEffect_category = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_AwakeningEffect_category"),
  awakeningEffect_panel = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_AwakeningEffect_panel"),
  awakeningeffect = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_AwakeningEffect_effect"),
  skillDescription = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_Description"),
  skill_Movie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Tooltip_Skill, "WebControl_Skill_Movie"),
  skill_ResetBg = UI.getChildControl(Panel_Tooltip_Skill, "Tooltip_Skill_PartlyResetBg")
}
local ToolTipSkillUI_learning = {
  main = Panel_Tooltip_Skill_forLearning,
  nextLvTag = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_NextLevel_tag"),
  skillName = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_Name"),
  skillIcon = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_Icon"),
  skillLevel = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_Level"),
  learnRequirement_category = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_category"),
  learnRequirement_panel = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_panel"),
  requireLevel = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_level"),
  requireLevel_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_level_value"),
  requireSP = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_skillPoint"),
  requireSP_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_skillPoint_value"),
  requireItem = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_item"),
  requireItem_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_LearnRequirement_item_value"),
  useCondition_category = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_category"),
  useCondition_category_panel = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_panel"),
  needHP = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needHP"),
  needHP_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needHP_value"),
  needMP = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needMP"),
  needMP_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needMP_value"),
  needSP = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needSP"),
  needSP_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needSP_value"),
  needItem = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needItem"),
  needItem_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_needItem_value"),
  reuseCycle = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_reuseCycle"),
  reuseCycle_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseCondition_reuseCycle_value"),
  useMethod = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_UseMethod"),
  skillEffect_category = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_SkillEffect_category"),
  skillEffect_panel = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_SkillEffect_panel"),
  skillEffect_value = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_SkillEffect_buff_value"),
  awakeningEffect_category = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_AwakeningEffect_category"),
  awakeningEffect_panel = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_AwakeningEffect_panel"),
  awakeningeffect = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_AwakeningEffect_effect"),
  skillDescription = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Tooltip_Skill_Description"),
  skillArrow = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "Static_Arrow"),
  reservation_helpMsg = UI.getChildControl(Panel_Tooltip_Skill_forLearning, "StaticText_Reservation_Help"),
  skill_Movie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Tooltip_Skill_forLearning, "WebControl_Skill_Movie")
}
local ToolTipSkillUI_blackSpirit = {
  main = Panel_Tooltip_Skill_forBlackSpirit,
  skillName = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_Name"),
  skillIcon = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_Icon"),
  skillLevel = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_Level"),
  useCondition_category = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_category"),
  useCondition_category_panel = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_panel"),
  needHP = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needHP"),
  needHP_value = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needHP_value"),
  needMP = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needMP"),
  needMP_value = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needMP_value"),
  needSP = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needSP"),
  needSP_value = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needSP_value"),
  needItem = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needItem"),
  needItem_value = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_needItem_value"),
  reuseCycle = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_reuseCycle"),
  reuseCycle_value = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseCondition_reuseCycle_value"),
  useMethod = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_UseMethod"),
  skillEffect_category = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_SkillEffect_category"),
  skillEffect_panel = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_SkillEffect_panel"),
  skillEffect_value = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_SkillEffect_buff_value"),
  awakeningEffect_category = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_AwakeningEffect_category"),
  awakeningEffect_panel = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_AwakeningEffect_panel"),
  awakeningeffect = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_AwakeningEffect_effect"),
  skillDescription = UI.getChildControl(Panel_Tooltip_Skill_forBlackSpirit, "Tooltip_Skill_Description"),
  skill_Movie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Tooltip_Skill_forBlackSpirit, "WebControl_Skill_Movie")
}
local Tooltip_SkillData = {}
local positionSet = {}
local currentTooltip = {
  slotNo = -1,
  slotType = "",
  isShowNext = false
}
local isReserveSkillOn = false
local currMovieName
local callTooltipType = ""
local function initialize()
  ToolTipSkillUI.main:SetShow(false, false)
  ToolTipSkillUI.main:setMaskingChild(true)
  ToolTipSkillUI.main:SetIgnore(true)
  ToolTipSkillUI.main:setGlassBackground(true)
  ToolTipSkillUI.skill_Movie:SetHorizonCenter()
  ToolTipSkillUI.skill_Movie:SetSize(320, 240)
  ToolTipSkillUI.skill_Movie:SetSpanSize(-1, 0)
  ToolTipSkillUI.skill_Movie:SetShow(false)
  ToolTipSkillUI_learning.main:SetShow(false, false)
  ToolTipSkillUI_learning.main:setMaskingChild(true)
  ToolTipSkillUI_learning.main:SetIgnore(true)
  ToolTipSkillUI_learning.main:setGlassBackground(true)
  ToolTipSkillUI_learning.skillArrow:SetShow(false)
  ToolTipSkillUI_learning.skill_Movie:SetHorizonCenter()
  ToolTipSkillUI_learning.skill_Movie:ResetUrl()
  ToolTipSkillUI_learning.skill_Movie:SetSize(320, 240)
  ToolTipSkillUI_learning.skill_Movie:SetSpanSize(-1, 0)
  ToolTipSkillUI_learning.skill_Movie:SetShow(false)
  ToolTipSkillUI_blackSpirit.main:SetShow(false, false)
  ToolTipSkillUI_blackSpirit.main:setMaskingChild(true)
  ToolTipSkillUI_blackSpirit.main:SetIgnore(true)
  ToolTipSkillUI_blackSpirit.main:setGlassBackground(true)
  ToolTipSkillUI_blackSpirit.skill_Movie:SetHorizonCenter()
  ToolTipSkillUI_blackSpirit.skill_Movie:SetSize(320, 240)
  ToolTipSkillUI_blackSpirit.skill_Movie:SetSpanSize(-1, 0)
  ToolTipSkillUI_blackSpirit.skill_Movie:SetShow(false)
end
function Panel_SkillTooltip_Hide()
  if Panel_Tooltip_Skill:IsShow() then
    Panel_Tooltip_Skill:SetShow(false, false)
    if Panel_Tooltip_Skill:IsUISubApp() then
      Panel_Tooltip_Skill:CloseUISubApp()
    end
    ToolTipSkillUI.skill_Movie:TriggerEvent("StopMovie", "test")
    currMovieName = nil
    currentTooltip.slotNo = -1
  end
  if Panel_Tooltip_Skill_forLearning:IsShow() then
    Panel_Tooltip_Skill_forLearning:SetShow(false, false)
    if Panel_Tooltip_Skill_forLearning:IsUISubApp() then
      Panel_Tooltip_Skill_forLearning:CloseUISubApp()
    end
    ToolTipSkillUI_learning.skill_Movie:TriggerEvent("StopMovie", "test")
    currMovieName = nil
    currentTooltip.slotNo = -1
  end
  if Panel_Tooltip_Skill_forBlackSpirit:IsShow() then
    Panel_Tooltip_Skill_forBlackSpirit:SetShow(false, false)
    if Panel_Tooltip_Skill_forBlackSpirit:IsUISubApp() then
      Panel_Tooltip_Skill_forBlackSpirit:CloseUISubApp()
    end
    currMovieName = nil
    currentTooltip.slotNo = -1
  end
end
function Panel_SkillTooltip_GetCurrentSlotType()
  return currentTooltip.slotType
end
function Panel_SkillTooltip_Refresh()
  if -1 ~= currentTooltip.slotNo then
    Panel_SkillTooltip_Show(currentTooltip.slotNo, currentTooltip.isShowNext, currentTooltip.slotType, isReserveSkillOn)
  else
    Panel_SkillTooltip_Hide()
  end
end
function Panel_SkillTooltip_SetPosition(skillNo, slot, slotType)
  if nil == positionSet[slotType] then
    positionSet[slotType] = {}
  end
  positionSet[slotType][skillNo] = slot
end
function Panel_SkillTooltip_Show(slotNo, isShowNextLevel, SlotType, isReserveSkill, isResetable)
  audioPostEvent_SystemUi(1, 13)
  callTooltipType = SlotType
  local skillNo = slotNo
  if SlotType == "QuickSlot" then
    local quickSlotInfo = getQuickSlotItem(slotNo)
    if nil == quickSlotInfo then
      return
    end
    skillNo = quickSlotInfo._skillKey:getSkillNo()
  end
  local skillTypeSS = getSkillTypeStaticStatus(skillNo)
  if nil == skillTypeSS then
    return
  end
  currentTooltip.slotNo = slotNo
  currentTooltip.isShowNext = isShowNextLevel
  currentTooltip.slotType = SlotType
  if SlotType == "itemToSkill" then
    slotNo = 1
  end
  isReserveSkillOn = true == isReserveSkill
  Tooltip_SkillData:showTooltip_Skill_Real(ToolTipSkillUI, skillNo, skillTypeSS, isShowNextLevel, isReserveSkillOn, isResetable)
  if false == isShowNextLevel and Panel_Tooltip_Skill:GetShow() then
    Panel_Tooltip_Skill_forLearning:SetShow(false, false)
  else
    Tooltip_SkillData:showTooltip_Skill_Real(ToolTipSkillUI_learning, skillNo, skillTypeSS, false, isReserveSkillOn)
  end
  local skillStatic = getSkillStaticStatus(skillNo, 1)
  if nil ~= skillStatic then
    local blackSkillNo = skillStatic:getlinkBlackSkillNo()
    local blackSkillTypeSS = getSkillTypeStaticStatus(blackSkillNo)
    if nil ~= blackSkillTypeSS and blackSkillTypeSS:isValidLocalizing() then
      Tooltip_SkillData:showTooltip_Skill_Real(ToolTipSkillUI_blackSpirit, blackSkillNo, blackSkillTypeSS, false, false)
    end
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local positionData
  local posX = 0
  local posY = 0
  if nil ~= positionSet[SlotType] then
    positionData = positionSet[SlotType][slotNo]
    if nil ~= positionData then
      posX = positionData:GetParentPosX()
      posY = positionData:GetParentPosY()
    end
  end
  local isLeft = posX > screenSizeX / 2
  local isTop = posY > screenSizeY / 2
  local tooltipSize = {width = 0, height = 0}
  local tooltipLearningSize = {width = 0, height = 0}
  local tooltipBlackSpiritSize = {width = 0, height = 0}
  local sumSize = {width = 0, height = 0}
  if Panel_Tooltip_Skill:GetShow() then
    tooltipSize.width = Panel_Tooltip_Skill:GetSizeX()
    tooltipSize.height = Panel_Tooltip_Skill:GetSizeY()
    sumSize.width = sumSize.width + tooltipSize.width
    sumSize.height = math.max(sumSize.height, tooltipSize.height)
  end
  if Panel_Tooltip_Skill_forLearning:GetShow() then
    tooltipLearningSize.width = Panel_Tooltip_Skill_forLearning:GetSizeX()
    tooltipLearningSize.height = Panel_Tooltip_Skill_forLearning:GetSizeY()
    if false == isTop then
      posY = posY - ToolTipSkillUI_learning.nextLvTag:GetPosY()
    end
    sumSize.width = sumSize.width + tooltipLearningSize.width
    sumSize.height = math.max(sumSize.height, tooltipLearningSize.height)
  end
  if Panel_Tooltip_Skill_forBlackSpirit:GetShow() then
    tooltipBlackSpiritSize.width = Panel_Tooltip_Skill_forBlackSpirit:GetSizeX()
    tooltipBlackSpiritSize.height = Panel_Tooltip_Skill_forBlackSpirit:GetSizeY()
    sumSize.width = sumSize.width + tooltipBlackSpiritSize.width
    sumSize.height = math.max(sumSize.height, tooltipBlackSpiritSize.height)
  end
  if not isLeft then
    posX = posX + positionData:GetSizeX()
  end
  if isTop then
    posY = posY + positionData:GetSizeY()
    local yDiff = posY - sumSize.height
    if yDiff < 0 then
      posY = posY - yDiff
    end
  else
    local yDiff = screenSizeY - (posY + sumSize.height)
    if yDiff < 0 then
      posY = posY + yDiff
    end
  end
  local blackSkillPosY = 0
  local isUISubAppMode = false
  if nil ~= positionData then
    local parentPanel = positionData:GetParentPanel()
    if nil ~= parentPanel and parentPanel:IsUISubApp() then
      posX = parentPanel:GetScreenParentPosX()
      posY = parentPanel:GetScreenParentPosY()
      tooltipSize.width = parentPanel:GetSizeX()
      tooltipSize.height = parentPanel:GetSizeY()
      tooltipLearningSize.width = Panel_Tooltip_Skill_forLearning:GetSizeX()
      tooltipLearningSize.height = Panel_Tooltip_Skill_forLearning:GetSizeY()
      tooltipBlackSpiritSize.width = Panel_Tooltip_Skill_forBlackSpirit:GetSizeX()
      tooltipBlackSpiritSize.height = Panel_Tooltip_Skill_forBlackSpirit:GetSizeY()
      isUISubAppMode = true
    end
  end
  if Panel_Tooltip_Skill:GetShow() then
    if isLeft then
      posX = posX - tooltipSize.width
    end
    local yTmp = posY
    if isTop then
      yTmp = yTmp - tooltipSize.height
    end
    Panel_Tooltip_Skill:SetPosX(posX)
    Panel_Tooltip_Skill:SetPosY(yTmp)
    blackSkillPosY = Panel_Tooltip_Skill:GetPosY()
    if not isLeft then
      posX = posX + tooltipSize.width
    end
    if isUISubAppMode then
      Panel_Tooltip_Skill:OpenUISubApp()
    end
  end
  if Panel_Tooltip_Skill_forLearning:GetShow() then
    if isLeft then
      posX = posX - tooltipLearningSize.width
    end
    local yTmp = posY
    if isTop then
      yTmp = yTmp - tooltipLearningSize.height
    end
    Panel_Tooltip_Skill_forLearning:SetPosX(posX)
    Panel_Tooltip_Skill_forLearning:SetPosY(yTmp)
    blackSkillPosY = Panel_Tooltip_Skill_forLearning:GetPosY()
    if not isLeft then
      posX = posX + tooltipLearningSize.width
    end
    if isUISubAppMode then
      Panel_Tooltip_Skill_forLearning:OpenUISubApp()
    end
  end
  if Panel_Tooltip_Skill_forBlackSpirit:GetShow() then
    if isLeft then
      posX = posX - tooltipBlackSpiritSize.width
    end
    Panel_Tooltip_Skill_forBlackSpirit:SetPosX(posX)
    Panel_Tooltip_Skill_forBlackSpirit:SetPosY(blackSkillPosY)
    if not isLeft then
      posX = posX + tooltipBlackSpiritSize.width
    end
    if isUISubAppMode then
      Panel_Tooltip_Skill_forBlackSpirit:OpenUISubApp()
    end
  end
end
function Tooltip_SkillData:GetBottomPos(control)
  if nil == control then
    UI.ASSERT(false, "Tooltip_SkillData:GetBottomPos(control) , control nil")
    return
  end
  return control:GetPosY() + control:GetSizeY()
end
local isShowSp = false
function Tooltip_SkillData:showTooltip_Skill_Real(target, skillNo, skillTypeSS, isShowNextLevel, isReserveSkillOn, isResetable)
  target.main:SetShow(false, false)
  local isNextLvWidget = target.main ~= Panel_Tooltip_Skill and target.main ~= Panel_Tooltip_Skill_forBlackSpirit
  local level = getLearnedSkillLevel(skillTypeSS)
  local skillStatic, nextLevelStatic
  if isNextLvWidget then
    level = level + 1
    if isReserveSkillOn then
      target.nextLvTag:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_RESERVATIONSKILL"))
      ToolTipSkillUI_learning.reservation_helpMsg:SetShow(true)
    else
      target.nextLvTag:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NEXTLEVELSKILL"))
      ToolTipSkillUI_learning.reservation_helpMsg:SetShow(false)
    end
  end
  if Panel_Tooltip_Skill == target.main then
    if true == isResetable then
      target.skill_ResetBg:SetShow(true)
    else
      target.skill_ResetBg:SetShow(false)
    end
  end
  skillStatic = getSkillStaticStatus(skillNo, level)
  if nil == skillStatic then
    return
  end
  local skillTypeSSW = skillStatic:getSkillTypeStaticStatusWrapper()
  if nil == skillTypeSSW then
    return
  end
  local elementBiggap = 10
  local elementgap = 0
  local TooltipYPos = 10
  if isNextLvWidget then
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.nextLvTag) + elementgap
  end
  if level <= 1 then
    target.skillLevel:SetText("")
  else
    target.skillLevel:SetText(": " .. PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TooltipSkill_Level", "level", level))
  end
  target.skillIcon:ChangeTextureInfoName("icon/" .. skillTypeSSW:getIconPath())
  target.skillName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.skillName:SetText(skillTypeSSW:getName() .. " [Skill ID: " .. skillNo .. " | Level: " .. level .. "]")
  local needLvLearning = skillStatic:get()._needCharacterLevelForLearning
  local needSkillLearning = skillStatic:get()._needSkillPointForLearning
  local needItemLearning
  local isNeedLvLearning = false
  if isNextLvWidget then
    local needItemLearningItem = skillStatic:get():needItemForLearning()
    if nil ~= needItemLearningItem then
      local needItemLearningKey = needItemLearningItem._key
      needItemLearning = getItemEnchantStaticStatus(needItemLearningKey)
    end
    target.requireLevel_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
    target.requireLevel_value:SetAutoResize(true)
    local compareType
    if "GuildSkillBox" == callTooltipType then
      local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
      if nil == myGuildInfo then
        return
      end
      local myGuildRank = myGuildInfo:getMemberCountLevel()
      compareType = myGuildRank
    else
      compareType = getSelfPlayer():get():getLevel()
    end
    if needLvLearning > 1 then
      if needLvLearning > compareType then
        isNeedLvLearning = true
        local requireLevel_valueText = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedLevel", "needLvLearning", needLvLearning)
        target.requireLevel_value:SetText(": " .. "<PAColor0xFFDB2B2B>" .. requireLevel_valueText .. "<PAOldColor>")
      else
        if "GuildSkillBox" ~= callTooltipType then
          isNeedLvLearning = true
        else
          isNeedLvLearning = false
        end
        target.requireLevel_value:SetText(": " .. PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedLevel", "needLvLearning", needLvLearning))
      end
    elseif 0 == needLvLearning then
      isNeedLvLearning = true
      target.requireLevel_value:SetText(": " .. PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_QuestGain"))
    end
    target.requireSP_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
    target.requireSP_value:SetAutoResize(true)
    if needSkillLearning > getSelfPlayer():get():getRemainSkillPoint() then
      local requireSP_valueText = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedSP", "needSkillLearning", needSkillLearning)
      target.requireSP_value:SetText(": " .. "<PAColor0xFFDB2B2B>" .. requireSP_valueText .. "<PAOldColor>")
    else
      target.requireSP_value:SetText(": " .. PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedSP", "needSkillLearning", needSkillLearning))
    end
    if nil ~= needItemLearning then
      target.requireItem_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
      target.requireItem_value:SetAutoResize(true)
      local needItemName = needItemLearning:getName()
      local needCount = tostring(skillStatic:get()._needItemCountForLearning_s64)
      target.requireItem_value:SetText(": " .. PAGetStringParam2(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedItem", "needItemName", needItemName, "needCount", needCount))
    end
  end
  target.needHP_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.needHP_value:SetAutoResize(true)
  target.needHP_value:SetText(": " .. skillStatic:get()._requireHp)
  local isShowNeedHp = 0 ~= skillStatic:get()._requireHp
  local self = selfPlayerStatusBar
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  if UI_classType.ClassType_Ranger == playerWrapper:getClassType() or UI_classType.ClassType_Orange == playerWrapper:getClassType() then
    target.needMP:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedEP"))
  elseif UI_classType.ClassType_Warrior == playerWrapper:getClassType() or UI_classType.ClassType_Giant == playerWrapper:getClassType() or UI_classType.ClassType_BladeMaster == playerWrapper:getClassType() or UI_classType.ClassType_BladeMasterWomen == playerWrapper:getClassType() or UI_classType.ClassType_NinjaWomen == playerWrapper:getClassType() or UI_classType.ClassType_NinjaMan == playerWrapper:getClassType() or UI_classType.ClassType_Combattant == playerWrapper:getClassType() or UI_classType.ClassType_CombattantWomen == playerWrapper:getClassType() or UI_classType.ClassType_Lahn == playerWrapper:getClassType() then
    target.needMP:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedFP"))
  elseif UI_classType.ClassType_Valkyrie == playerWrapper:getClassType() then
    target.needMP:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedBP"))
  else
    target.needMP:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedMP"))
  end
  target.needMP_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.needMP_value:SetAutoResize(true)
  target.needMP_value:SetText(": " .. skillStatic:get()._requireMp)
  local isShowNeedMp = 0 ~= skillStatic:get()._requireMp
  local isShowNeedSp = false
  target.needSP_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.needSP_value:SetAutoResize(true)
  if 1 < skillStatic:get()._requireSp then
    target.needSP_value:SetText(": " .. skillStatic:get()._requireSp)
    isShowNeedSp = true
  else
    isShowNeedSp = false
  end
  local isShowNeedItem = nil ~= skillStatic:getItemInfo() and nil ~= skillStatic:getItemInfo():get()
  if not isShowNeedItem then
    target.needItem_value:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NoItemConsumed"))
  else
    local useNeedItemName = skillStatic:getItemInfo():getName()
    local s64_useNeedItemCount = skillStatic:get()._needItemCount_s64
    target.needItem_value:SetText(": " .. PAGetStringParam2(Defines.StringSheet_GAME, "Lua_TooltipSkill_UseNeedItem", "useNeedItemName", useNeedItemName, "useNeedItemCount", tostring(Int64toInt32(s64_useNeedItemCount))))
  end
  local _time = skillStatic:get()._reuseCycle / 1000
  target.reuseCycle_value:SetText(": " .. convertStringFromDatetimeForSkillTooltip(_time))
  local isShowReuseCycle = 0 ~= skillStatic:get()._reuseCycle
  local commandText = skillTypeSSW:getCommand()
  local isShowCommand = "" ~= commandText
  target.useMethod:SetAutoResize(true)
  target.useMethod:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.useMethod:SetText(commandText)
  target.skillEffect_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.skillEffect_value:SetAutoResize(true)
  target.skillEffect_value:SetText(skillStatic:getDescription())
  local isAwakeningData = false
  local activeSkillSS
  if skillStatic:isActiveSkillHas() and false == skillStatic:isFusionSkill() then
    activeSkillSS = getActiveSkillStatus(skillStatic)
    if nil == activeSkillSS then
      target.awakeningeffect:SetText("")
    else
      local awakeInfo = ""
      local awakeningDataCount = activeSkillSS:getSkillAwakenInfoCount() - 1
      local realCount = 0
      for idx = 0, awakeningDataCount do
        local skillInfo = activeSkillSS:getSkillAwakenInfo(idx)
        if "" ~= skillInfo then
          awakeInfo = awakeInfo .. "\n" .. skillInfo
          realCount = realCount + 1
        end
      end
      target.awakeningeffect:SetText(awakeInfo)
      isAwakeningData = realCount > 0
    end
  else
    target.awakeningeffect:SetText("")
  end
  target.skillDescription:SetTextMode(UI_TM.eTextMode_AutoWrap)
  target.skillDescription:SetAutoResize(true)
  target.skillDescription:SetText(skillTypeSSW:getDescription())
  local movieName = skillTypeSS:getMoviePath()
  local movieShow = true
  if false == isShowNextLevel and nil ~= movieName and "" ~= movieName then
    target.skill_Movie:SetShow(true)
    if currMovieName ~= movieName then
      target.skill_Movie:TriggerEvent("PlayMovie", "coui://" .. movieName)
      currMovieName = movieName
    end
  else
    currMovieName = nil
    target.skill_Movie:SetShow(false)
    movieShow = false
  end
  local checkAgeType = ToClient_isAdultUser()
  if checkAgeType then
    target.skill_Movie:SetMonoTone(false)
  else
    target.skill_Movie:SetMonoTone(true)
  end
  target.skillIcon:SetPosY(target.skillName:GetPosY() + target.skillName:GetTextSizeY() + 5)
  target.skillLevel:SetPosY(6)
  local iconBottom = Tooltip_SkillData:GetBottomPos(target.skillIcon) + elementgap
  local levelBottom = Tooltip_SkillData:GetBottomPos(target.skillLevel) + elementgap
  target.skillName:SetPosY(5)
  local nameBottom = Tooltip_SkillData:GetBottomPos(target.skillName) + elementgap
  if iconBottom < nameBottom then
    TooltipYPos = nameBottom
  else
    TooltipYPos = iconBottom
  end
  local skillIconPosY = target.skillIcon:GetPosY()
  local skillIconSizeY = target.skillIcon:GetSizeY()
  target.skillDescription:SetPosY(skillIconPosY)
  local skillDescriptionBottom = Tooltip_SkillData:GetBottomPos(target.skillDescription) + elementgap
  if iconBottom < skillDescriptionBottom then
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.skillDescription) + elementgap
  else
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.skillIcon) + elementgap
  end
  target.useMethod:SetPosY(TooltipYPos + 9)
  TooltipYPos = Tooltip_SkillData:GetBottomPos(target.useMethod) + elementgap
  if isNextLvWidget then
    target.learnRequirement_category:SetPosY(TooltipYPos - 5)
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.learnRequirement_category) + elementgap - elementBiggap
    target.learnRequirement_panel:SetPosY(TooltipYPos)
    TooltipYPos = TooltipYPos + elementBiggap / 2
    local isLevelShow = isNeedLvLearning
    target.requireLevel:SetShow(isLevelShow)
    target.requireLevel_value:SetShow(isLevelShow)
    if isLevelShow then
      target.requireLevel:SetPosY(TooltipYPos)
      target.requireLevel_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.requireLevel_value) + elementgap
    end
    local isSpShow = 0 ~= needSkillLearning
    target.requireSP:SetShow(isSpShow)
    target.requireSP_value:SetShow(isSpShow)
    if isSpShow then
      target.requireSP:SetPosY(TooltipYPos)
      target.requireSP_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.requireSP_value) + elementgap
    end
    local isItemShow = nil ~= needItemLearning
    target.requireItem:SetShow(isItemShow)
    target.requireItem_value:SetShow(isItemShow)
    if isItemShow then
      target.requireItem:SetPosY(TooltipYPos)
      target.requireItem_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.requireItem_value) + elementgap
    end
    target.learnRequirement_panel:SetSize(target.learnRequirement_panel:GetSizeX(), TooltipYPos - target.learnRequirement_panel:GetPosY() + elementBiggap)
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.learnRequirement_panel)
  end
  if isShowNeedHp or isShowNeedMp or isShowNeedSp or isShowNeedItem or isShowReuseCycle then
    target.useCondition_category:SetPosY(TooltipYPos - 5)
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.useCondition_category) + elementgap - elementBiggap
    target.useCondition_category_panel:SetPosY(TooltipYPos)
    TooltipYPos = TooltipYPos + elementBiggap / 2
    if isShowNeedHp then
      target.needHP:SetPosY(TooltipYPos)
      target.needHP_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.needHP_value) + elementgap
    end
    target.needHP:SetShow(isShowNeedHp)
    target.needHP_value:SetShow(isShowNeedHp)
    if isShowNeedMp then
      target.needMP:SetPosY(TooltipYPos)
      target.needMP_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.needMP_value) + elementgap
    end
    target.needMP:SetShow(isShowNeedMp)
    target.needMP_value:SetShow(isShowNeedMp)
    if isShowNeedSp then
      target.needSP:SetPosY(TooltipYPos)
      target.needSP_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.needSP_value) + elementgap
    end
    target.needSP:SetShow(isShowNeedSp)
    target.needSP_value:SetShow(isShowNeedSp)
    if isShowNeedItem then
      target.needItem:SetPosY(TooltipYPos)
      target.needItem_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.needItem_value) + elementgap
    end
    target.needItem:SetShow(isShowNeedItem)
    target.needItem_value:SetShow(isShowNeedItem)
    if isShowReuseCycle then
      target.reuseCycle:SetPosY(TooltipYPos)
      if target.reuseCycle_value:GetPosX() < target.reuseCycle:GetTextSizeX() + target.reuseCycle:GetPosX() then
        target.reuseCycle_value:SetPosX(target.reuseCycle:GetTextSizeX() + target.reuseCycle:GetPosX() + 20)
      end
      target.reuseCycle_value:SetPosY(TooltipYPos)
      TooltipYPos = Tooltip_SkillData:GetBottomPos(target.reuseCycle_value) + elementgap
    end
    target.reuseCycle:SetShow(isShowReuseCycle)
    target.reuseCycle_value:SetShow(isShowReuseCycle)
    target.useCondition_category_panel:SetSize(target.useCondition_category_panel:GetSizeX(), TooltipYPos - target.useCondition_category_panel:GetPosY() + elementBiggap)
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.useCondition_category_panel) + elementgap
    target.useCondition_category:SetShow(true)
    target.useCondition_category_panel:SetShow(true)
  else
    target.needHP:SetShow(isShowNeedHp)
    target.needHP_value:SetShow(isShowNeedHp)
    target.needMP:SetShow(isShowNeedMp)
    target.needMP_value:SetShow(isShowNeedMp)
    target.needSP:SetShow(isShowNeedSp)
    target.needSP_value:SetShow(isShowNeedSp)
    target.needItem:SetShow(isShowNeedItem)
    target.needItem_value:SetShow(isShowNeedItem)
    target.reuseCycle:SetShow(isShowReuseCycle)
    target.reuseCycle_value:SetShow(isShowReuseCycle)
    target.useCondition_category:SetShow(false)
    target.useCondition_category_panel:SetShow(false)
  end
  target.skillEffect_category:SetPosY(TooltipYPos - 5)
  TooltipYPos = Tooltip_SkillData:GetBottomPos(target.skillEffect_category) + elementgap - elementBiggap
  target.skillEffect_panel:SetPosY(TooltipYPos)
  TooltipYPos = TooltipYPos + elementBiggap / 2
  target.skillEffect_value:SetPosY(TooltipYPos)
  TooltipYPos = Tooltip_SkillData:GetBottomPos(target.skillEffect_value) + elementgap
  target.skillEffect_panel:SetSize(target.skillEffect_panel:GetSizeX(), TooltipYPos - target.skillEffect_panel:GetPosY() + elementBiggap)
  TooltipYPos = Tooltip_SkillData:GetBottomPos(target.skillEffect_panel) + elementgap
  TooltipYPos = Tooltip_SkillData:GetBottomPos(target.skillEffect_panel)
  target.awakeningEffect_category:SetShow(isAwakeningData)
  target.awakeningEffect_panel:SetShow(isAwakeningData)
  target.awakeningeffect:SetShow(isAwakeningData)
  if isAwakeningData then
    target.awakeningEffect_category:SetPosY(TooltipYPos)
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.awakeningEffect_category) + elementgap
    target.awakeningEffect_panel:SetPosY(TooltipYPos)
    TooltipYPos = TooltipYPos + elementBiggap
    target.awakeningeffect:SetPosY(TooltipYPos)
    TooltipYPos = target.awakeningeffect:GetSizeY()
    target.awakeningEffect_panel:SetSize(target.awakeningEffect_panel:GetSizeX(), target.awakeningeffect:GetSizeY() + elementBiggap + 30)
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.awakeningEffect_panel) + elementgap
  end
  if target.skill_Movie:GetShow() then
    TooltipYPos = TooltipYPos + elementBiggap
    target.skill_Movie:SetPosY(TooltipYPos)
    TooltipYPos = Tooltip_SkillData:GetBottomPos(target.skill_Movie) + elementgap
  end
  target.main:SetSize(target.main:GetSizeX(), TooltipYPos + elementBiggap)
  target.main:SetShow(true, false)
  target.skill_Movie:ComputePos()
  ToolTipSkillUI_learning.reservation_helpMsg:SetPosY(TooltipYPos + 10)
  ToolTipSkillUI_learning.reservation_helpMsg:SetAutoResize(true)
  ToolTipSkillUI_learning.reservation_helpMsg:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ToolTipSkillUI_learning.reservation_helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_RESERVATIONCANCEL"))
  ToolTipSkillUI_learning.reservation_helpMsg:SetSize(ToolTipSkillUI_learning.reservation_helpMsg:GetSizeX(), ToolTipSkillUI_learning.reservation_helpMsg:GetSizeY() + 5)
end
function FGlobal_SetUrl_Tooltip_SkillForLearning()
  ToolTipSkillUI_learning.skill_Movie:SetUrl(320, 240, "coui://UI_Data/UI_Html/Skill_Movie.html")
  ToolTipSkillUI.skill_Movie:SetUrl(320, 240, "coui://UI_Data/UI_Html/Skill_Movie.html")
end
function FGlobal_ResetUrl_Tooltip_SkillForLearning()
  ToolTipSkillUI_learning.skill_Movie:ResetUrl()
  ToolTipSkillUI.skill_Movie:ResetUrl()
end
initialize()