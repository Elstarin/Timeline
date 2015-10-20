local Timeline = CreateFrame("Frame", "Timeline", UIParent)
local TL = Timeline

local optionsFrame = CreateFrame("Frame", "Timeline_Options_Menu", UIParent)
optionsFrame:SetMovable(true)
local pName = GetUnitName("player")
local pClass, CLASS = UnitClass("player")
local classFunc
--------------------------------------------------------------------------------
-- Debug mode stuff
--------------------------------------------------------------------------------
local debugMode = true
do -- Debug mode stuff
  local matched
  local start = debugprofilestop() / 1000
  local printFormat = "|cFF9E5A01(|r|cFF00CCFF%.3f|r|cFF9E5A01)|r |cFF00FF00Timeline|r: %s"

  if GetUnitName("player") == "Elstari" and GetRealmName() == "Drak'thul" then
    debugMode = true
    matched = true
  end

  function TL.debug(...)
    if debugMode then
      local cTime = GetTime()
      local t = {...}

      for i = 1, #t do
        local obj = type(t[i])

        if obj == "table" then
          t[i] = "|cFF888888" .. tostring(t[i]) .. "|r"
        elseif obj == "function" then
          t[i] = "|cFFDA70D6" .. tostring(t[i]) .. "|r"
        elseif obj == "nil" then
          t[i] = "|cffFF4500nil|r"
        elseif obj == "boolean" then
          if t[i] == true then
            t[i] = "|cFF4B6CD7true|r"
          elseif t[i] == false then
            t[i] = "|cFFFF9B00false|r"
          end
        elseif obj == "userdata" then
          t[i] = "|cFF888888" .. tostring(t[i]) .. "|r"
        elseif obj == "number" or type(tonumber(obj)) == "number" then
          t[i] = "|cFF00CCFF" .. t[i] .. "|r"
        end
      end

      local string = table.concat(t, " ")

      if string then
        if not string:find("%.$") and not string:find("%!$") and not string:find("%)$") then
          string = string .. "."
        end

        if string:find("%(.*%)") then
          string = string:gsub("(%()(.*)(%))", "|cFF9E5A01%1|r|cFF00CCFF%2|r|cFF9E5A01%3|r")
        end
      end

      print(printFormat:format((debugprofilestop() / 1000) - start, string))
    end
  end

  if not matched then
    TL.debug("If you aren't developing this addon and you see this message,",
      "that means I, being the genius that I am, released it with debug mode enabled.",
      "\n\nYou can easily fix it by opening the Main.lua document with any text editor,",
      "and finding the line |cFF00CCFFlocal debugMode = true|r and changing the |cFF00CCFFtrue|r to |cFF00CCFFfalse|r. Sorry!")
  end
end
local debug = TL.debug
--------------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------------
local WIDTH = 800 -- Default 300

local NUMBER_OF_ICONS = 10 -- Default 30
local ICON_HEIGHT = 30 -- Default 10
local TOTAL_TIME = 30 -- Default 60 (Total amount of time for the timeline in seconds)

local TEXT_HEIGHT = 16 -- Default 16
local STACK_TEXT_HEIGHT = 20 -- Default 20
local TEXT_COLOR = {0.93, 0.86, 0.01, 1.0} -- Default 0.93, 0.86, 0.01, 1.0
local STACK_TEXT_COLOR = {0.93, 0.86, 0.01, 1.0} -- Default 0.93, 0.86, 0.01, 1.0
local NUMBER_OF_DECIMALS = 0 -- Default 0

if CLASS == "DEATHKNIGHT" then
  local function deathKnight(specName)
		local list = {}

    if specName == "Blood" then
      list[1] = {
        ID = 1,
        runeNums = {1, 2},
        name = "Blood",
        category = "rune",
      }
      list[2] = {
        ID = 2,
        runeNums = {3, 4},
        name = "Unholy",
        category = "rune",
      }
      list[3] = {
        ID = 3,
        runeNums = {5, 6},
        name = "Frost",
        category = "rune",
      }
      list[4] = {
        ID = 48982,
        name = "Blood Tap",
        category = "cooldown",
      }
    elseif specName == "Unholy" then

    elseif specName == "Frost" then

    end

		return list
  end

  classFunc = deathKnight
elseif CLASS == "DRUID" then
  local function druid(specName)
		local list = {}

    if specName == "Feral" then

    elseif specName == "Balance" then

    elseif specName == "Restoration" then

    elseif specName == "Guardian" then

    end

		return list
  end

  classFunc = druid
elseif CLASS == "HUNTER" then
  local function hunter(specName)
    local list = {}

    if specName == "Survival" then

    elseif specName == "Marksmanship" then

    elseif specName == "Beast Master" then

    end

    return list
  end

  classFunc = hunter
elseif CLASS == "MAGE" then
  local function mage(specName)
		local list = {}

    if specName == "Frost" then

    elseif specName == "Arcane" then

    elseif specName == "Fire" then

    end

		return list
  end

  classFunc = mage
elseif CLASS == "MONK" then
  local function monk(specName)
		local list = {}

    if specName == "Windwalker" then

    elseif specName == "Mistweaver" then

    elseif specName == "Brewmaster" then

    end

		return list
  end

  classFunc = monk
elseif CLASS == "PALADIN" then
  local function paladin(specName)
    local list = {}

    if specName == "Retribution" then

    elseif specName == "Holy" then
			list[1] = {
				ID = 86273,
				name = "Illuminated Healing",
				category = "buff",
			}
			list[2] = {
				ID = 20473,
				name = "Holy Shock",
				category = "cooldown",
				line = true,
				lineHeight = 100,
				lineAnchor = "BOTTOM",
			}
			list[3] = {
				ID = 114165,
				name = "Holy Prism",
				category = "cooldown",
			}
			-- list[4] = {
			-- 	name = "Cast Bar",
			-- 	category = "activity",
			-- 	marks = {2, 3},
			-- }
			list[5] = {
				name = "Cast Bar Negative",
				category = "inactivity",
				marks = {2, 3},
			}
    elseif specName == "Protection" then

    end

    return list
  end

  classFunc = paladin
elseif CLASS == "PRIEST" then
  local function priest(specName)
		local list = {}

    if specName == "Discipline" then

    elseif specName == "Holy" then

    elseif specName == "Shadow" then

    end

		return list
  end

  classFunc = priest
elseif CLASS == "ROGUE" then
  local function rogue(specName)
		local list = {}

    if specName == "Subtlety" then

    elseif specName == "Assassination" then

    elseif specName == "Combat" then

    end

    return list
  end

  classFunc = rogue
elseif CLASS == "SHAMAN" then
  local function shaman(specName)
		local list = {}

    if specName == "Enhancement" then

    elseif specName == "Elemental" then
      list[4] = {
        ID = 61882,
        name = "Earthquake",
        category = "cooldown",
      }
      list[1] = {
        ID = 324,
        name = "Lightning Shield",
        category = "buff",
      }
      list[2] = {
        -- ID = 324,
        name = "Unleash Flame",
        category = "buff",
      }
    elseif specName == "Restoration" then

    end

		return list
  end

  classFunc = shaman
elseif CLASS == "WARLOCK" then
	local list = {}

  local function warlock(specName)
    if specName == "Demonology" then

    elseif specName == "Affliction" then

    elseif specName == "Destruction" then

		end

		return list
  end

  classFunc = warlock
elseif CLASS == "WARRIOR" then
  local function warrior(specName)
		local list = {}

    if specName == "Arms" then

    elseif specName == "Fury" then

    elseif specName == "Protection" then

    end

		return list
  end

  classFunc = warrior
end
--------------------------------------------------------------------------------
-- Main frame and local tables
--------------------------------------------------------------------------------
TL:SetSize(WIDTH - 40, ICON_HEIGHT)
TL:SetPoint("RIGHT", UIParent, -40, 0) -- 400 is the X coords, 0 is the Y coords
-- TL:SetPoint("CENTER", UIParent, 500, 0) -- 400 is the X coords, 0 is the Y coords

TL.line = UIParent:CreateTexture(nil, "OVERLAY")
TL.line:SetTexture(1, 1, 1, 1)
TL.line:SetSize(1, 1080)
TL.line:SetPoint("LEFT", TL)

TL.bars = {}
TL.icons = {}
TL.updateList = {}
TL.combatEvents = {}
TL.registeredIDs = {}
TL.categories = { -- NOTE: Make sure to add any new category to the index below
	cooldown = {},
	buff = {},
	debuff = {},
	activity = {},
  inactivity = {},
	rune = {},
}
TL.indexedCategories = {
	"cooldown",
	"buff",
	"debuff",
	"activity",
  "inactivity",
	"rune",
}
--------------------------------------------------------------------------------
-- Upvalues
--------------------------------------------------------------------------------
local GetRuneType, GetRuneCooldown, GetRuneCount, GetSpellCooldown
			= GetRuneType, GetRuneCooldown, GetRuneCount, GetSpellCooldown
local after, newTicker
			= C_Timer.After, C_Timer.NewTicker
local SetHeight, SetWidth, SetSize, GetWidth
			= SetHeight, SetWidth, SetSize, GetWidth
--------------------------------------------------------------------------------
-- Main engine
--------------------------------------------------------------------------------
TL:SetScript("OnUpdate", function(self, elapsed)
	if TL.active then
		local cTime = GetTime()

		local timer = (TL.combatStop or cTime) - (TL.combatStart or cTime)

		-- if TL.updateList[1] then -- Make sure there is at least one
		-- 	for i = 1, #TL.updateList do
		-- 		if TL.updateList[i] then
		-- 			TL.updateList[i]:update(cTime, timer)
		-- 		end
		-- 	end
		-- end

		-- if TL.forceUpdate or cTime >= (self.timeSinceLastUpdate or 0) then
		-- 	debug("Update", timer)
		--
		-- 	local frameWidth = self:GetWidth()
		--
		-- 	for i = 1, NUMBER_OF_ICONS do
		-- 		local bar = TL.bars[i]
		-- 		local icon = bar.icon
		--
		-- 		local point = bar.point or random(1, TOTAL_TIME)
		-- 		local x = (frameWidth * point) / TOTAL_TIME
		--
		-- 		bar:SetWidth(x)
		-- 	end
		--
		-- 	self.timeSinceLastUpdate = cTime + 2.1
		-- end
	end

	if TL.forceUpdate then TL.forceUpdate = false end
end)
--------------------------------------------------------------------------------
-- Event handler
--------------------------------------------------------------------------------
for i, v in ipairs({ -- Register events here
  "RUNE_POWER_UPDATE",
  "RUNE_TYPE_UPDATE",
  "PLAYER_SPECIALIZATION_CHANGED",
  "PLAYER_REGEN_DISABLED",
  "PLAYER_REGEN_ENABLED",
  "PLAYER_LOGIN",
  "UNIT_SPELLCAST_SENT",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"UNIT_AURA",
	"UNIT_SPELLCAST_STOP",
	"ADDON_LOADED",
  "UNIT_SPELLCAST_SUCCEEDED",
  }) do
  TL:RegisterEvent(v)
end

local function runAuras(unitID)
	local filter
	local index = 0

	debug("Running auras")

	while true do
		index = index + 1

		local spellName, rank, icon, count, dispelType, duration, expires, caster, stealable, consolidated, spellID, canApply, bossDebuff, v1, v2, v3 = UnitAura(unitID, index, filter)
		if not spellName then break end

		if TL.UNIT_AURA.BUFF and TL.UNIT_AURA.BUFF[spellID] then
			return TL.UNIT_AURA.BUFF[spellID]:update()
		elseif TL.UNIT_AURA.DEBUFF and TL.UNIT_AURA.DEBUFF[spellID] then
			return TL.UNIT_AURA.DEBUFF[spellID]:update()
		end
	end
end

function TL.SPELL_AURA_APPLIED(time, _, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, school, auraType, amount)
	if srcName ~= pName then return end

	if auraType == "BUFF" then
    local aura = TL.categories.buff[spellID]
		if aura then
			aura:update()
		end
	elseif auraType == "DEBUFF" then
    local aura = TL.categories.debuff[spellID]
    if aura then
      aura:update()
    end
	end
end

function TL.SPELL_AURA_REFRESH(time, _, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, school, auraType, amount)
	if srcName ~= pName then return end

	if auraType == "BUFF" then
		if TL.categories.buff[spellID] then
			TL.categories.buff[spellID]:update()
		end
	elseif auraType == "DEBUFF" then
		if TL.categories.debuff[spellID] then
			TL.categories.debuff[spellID]:update()
		end
	end
end

function TL.SPELL_AURA_REMOVED(time, _, _, srcGUID, srcName, _, _, dstGUID, dstName, _, _, spellID, spellName, school, auraType, amount)
	if srcName ~= pName then return end

  local aura
  if auraType == "BUFF" then
    aura = TL.categories.buff[spellID]
  elseif auraType == "DEBUFF" then
    aura = TL.categories.debuff[spellID]
  end

  if aura and aura.icon then
    aura.icon:SetPoint("RIGHT", TL.line, 0, 0)

    if aura.icon.ticker then
      aura.icon.ticker:Cancel()
    end
  end
end

function TL.SPELL_CAST_START(time, event, _, srcGUID, srcName, _, _, dstGUID, dstName, _, _, spellID, spellName, school)
	if srcName ~= pName then return end

  TL.casting = true

	if TL.categories.activity[1] then
		for i = 1, #TL.categories.activity do
      local spell = TL.categories.activity[i]

			spell:update()
		end
	end

	if TL.categories.inactivity[1] then
		for i = 1, #TL.categories.inactivity do
      local spell = TL.categories.inactivity[i]

			spell:update()
		end
	end
end

function TL.UNIT_SPELLCAST_STOP(unitID, spellName, rank, lineID, spellID)
	if unitID and unitID ~= "player" then return end

  TL.casting = false

  -- if TL.categories.activity[1] then
  --   for i = 1, #TL.categories.activity do
  --     local spell = TL.categories.activity[i]
  --     local icon1 = spell.icon[1]
  --     local icon2 = spell.icon[2]
  --
  --     local icon = spell.icon[spell.currentIcon]
  --
  --     if icon.slide:IsPlaying() then
  --       debug("Stopping current icon:", spell.currentIcon)
  --       icon.slide:Stop()
  --     end
  --
  --     -- if icon1.slide:IsPlaying() then
  --     --   debug("Stopping icon1")
  --     --   icon1.slide:Stop()
  --     -- end
  --     --
  --     -- if icon2.slide:IsPlaying() then
  --     --   debug("Stopping icon2")
  --     --   icon2.slide:Stop()
  --     -- end
  --   end
  -- end
end

function TL.UNIT_SPELLCAST_SUCCEEDED(unitID, spellName, rank, lineID, spellID)
	if unitID ~= "player" then return end

	if TL.categories.cooldown[spellID] then
    local spell = TL.categories.cooldown[spellID]
    -- spell.charges = false
		-- TL.categories.cooldown[spellID]:update()
    after(0.005, spell.update) -- Give the spell cooldown some time to update
	end

  if TL.casting then -- It was a hard cast that finished
    TL.casting = false
  else -- Should mean it was an instant cast
    local startGCD, GCD = GetSpellCooldown(61304)

    if startGCD > 0 then -- Make sure it's on the GCD
      if TL.categories.activity[1] then
        for i = 1, #TL.categories.activity do
          local spell = TL.categories.activity[i]

          spell:update(0.82, 0.35, 0.09, 1.0) -- Make it orange since it's a GCD
        end
      end

      if TL.categories.inactivity[1] then
        for i = 1, #TL.categories.inactivity do
          local spell = TL.categories.inactivity[i]

          spell:update(0.82, 0.35, 0.09, 1.0) -- Make it orange since it's a GCD
        end
      end
    end
  end
end

function TL.RUNE_POWER_UPDATE(runeNum) -- TODO: Set this up
	local index = GetRuneType(runeNum)

	-- local bar = bars[runeNum]
	-- local data = types[runeType]
  --
	-- if not runeReady and remaining < duration then -- Rune was already on CD, ignore
	-- 	return -- debug("Remaining is lower than duration, returning.", runeNum)
	-- elseif not runeReady then -- Start the cooldown
  --
	-- end

  if TL.categories.rune[index] then
    TL.categories.rune[index]:update(runeNum, TL.partners[runeNum], index)
  end
end

function TL.RUNE_TYPE_UPDATE(runeNum)
	local runeType = GetRuneType(runeNum)

	-- local bar = bars[runeNum]
	-- bar:SetStatusBarColor(unpack(BAR_COLOR[runeType]))

	-- if TL.categories.cooldown[spellID] then
	-- 	TL.categories.cooldown[spellID]:update()
	-- end
end

TL:SetScript("OnEvent", function(self, event, ...)
	if TL.active then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local _, event = ...

			if TL[event] then
				return TL[event](...)
			end
		else
			if TL[event] then
				return TL[event](...)
			end
		end
	end

	if event == "ADDON_LOADED" then
		local name = ...

		if name == "Timeline" then
      local specNum = GetSpecialization()

      if specNum then
  			local specID, specName, description, specIcon, background, role, primaryStat = GetSpecializationInfo(specNum)

  			if not TimelineDB then TimelineDB = {} end
  			if not TimelineCharDB then TimelineCharDB = {} end
  			if not TimelineCharDB[pClass] then TimelineCharDB[pClass] = {} end
  			if not TimelineCharDB[pClass][specName] then TimelineCharDB[pClass][specName] = {} end

  			TL.charDB = TimelineCharDB[pClass][specName]

  			TL.loadList(specName)
  			TL.startCombat() -- NOTE: Testing only
      else -- When logging in, spec information isn't available right away, so create a function and handle it on PLAYER_LOGIN.
        function TL.setupSVars()
          local specID, specName, description, specIcon, background, role, primaryStat = GetSpecializationInfo(GetSpecialization())

          if not TimelineDB then TimelineDB = {} end
          if not TimelineCharDB then TimelineCharDB = {} end
          if not TimelineCharDB[pClass] then TimelineCharDB[pClass] = {} end
          if not TimelineCharDB[pClass][specName] then TimelineCharDB[pClass][specName] = {} end

          TL.charDB = TimelineCharDB[pClass][specName]

          TL.loadList(specName)
          TL.startCombat() -- NOTE: Testing only
        end
      end
		end
	elseif event == "PLAYER_LOGIN" then
    if TL.setupSVars then
      debug("Delayed loading of SVars until login.")
      TL.setupSVars()
    end

		-- if debugMode then
		-- 	TL.createOptionsFrame()
    --
		-- 	after(1, function()
		-- 		TL.options:Show()
		-- 	end)
		-- end
  elseif event == "PLAYER_REGEN_ENABLED" then -- Leaving combat
		TL.stopCombat()
  elseif event == "PLAYER_REGEN_DISABLED" then -- Entering combat
		TL.startCombat()
  elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		debug(event)
  end
end)
--------------------------------------------------------------------------------
-- Main addon
--------------------------------------------------------------------------------
local function roundFormatted(fontString, num)
	if (num == math.huge) or (num == -math.huge) then num = 0 end

	local decimals = NUMBER_OF_DECIMALS

	if decimals == 0 then
		return fontString:SetFormattedText("%.0f", num)
	elseif decimals == 1 then
		return fontString:SetFormattedText("%.1f", num)
	elseif decimals == 2 then
		return fontString:SetFormattedText("%.2f", num)
	elseif decimals == 3 then
		return fontString:SetFormattedText("%.3f", num)
	elseif decimals == 4 then
		return fontString:SetFormattedText("%.4f", num)
	elseif decimals == 5 then
		return fontString:SetFormattedText("%.5f", num)
	elseif decimals == 6 then
		return fontString:SetFormattedText("%.6f", num)
	elseif decimals == 7 then
		return fontString:SetFormattedText("%.7f", num)
	elseif decimals == 8 then
		return fontString:SetFormattedText("%.8f", num)
	elseif decimals == 9 then
		return fontString:SetFormattedText("%.9f", num)
	elseif decimals == 10 then
		return fontString:SetFormattedText("%.10f", num)
	else -- No decimals
		local str = gsub("%.(0)f", decimals)
		return fontString:SetFormattedText(str, num)
	end
end

local function round(num, decimals)
	if (num == math.huge) or (num == -math.huge) then num = 0 end

	if decimals == 0 then
		return ("%.0f"):format(num) + 0
	elseif decimals == 1 then
		return ("%.1f"):format(num) + 0
	elseif decimals == 2 then
		return ("%.2f"):format(num) + 0
	elseif decimals == 3 then
		return ("%.3f"):format(num) + 0
	elseif decimals == 4 then
		return ("%.4f"):format(num) + 0
	elseif decimals == 5 then
		return ("%.5f"):format(num) + 0
	elseif decimals == 6 then
		return ("%.6f"):format(num) + 0
	elseif decimals == 7 then
		return ("%.7f"):format(num) + 0
	elseif decimals == 8 then
		return ("%.8f"):format(num) + 0
	elseif decimals == 9 then
		return ("%.9f"):format(num) + 0
	elseif decimals == 10 then
		return ("%.10f"):format(num) + 0
	else -- No decimals
		return ("%.0f"):format(num) + 0
	end
end

do -- Create list frame type functions
  TL.categoryFuncs = {}
  local funcs = TL.categoryFuncs

  for i = 1, #TL.indexedCategories do
    local category = TL.indexedCategories[i]

    if category == "cooldown" then
      if not funcs.cooldown then
        function funcs.cooldown(i, spell, list, spellID, spellName, unit)
          spell.icon = {}

          for index = 1, 2 do
            local icon = spell.icon[index]
            if not icon then
              icon = CreateFrame("Frame", "Timeline_Icon_" .. i .. "_" .. spellName, TL)
              icon:SetPoint("TOP", TL, 0, -((i - 1) * ICON_HEIGHT))
              if index == 1 then -- Left side
                icon:SetPoint("RIGHT", TL.line, 0, 0)
              else -- Right side
                icon:SetPoint("RIGHT", TL.line, ICON_HEIGHT, 0)
              end
              icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

              local texture = GetSpellTexture(list.ID or list.name)
              icon.texture = icon:CreateTexture(nil, "ARTWORK")
              icon.texture:SetTexture(texture or 0, 0, 0.8, 1.0)
              icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
              icon.texture:SetAlpha(0.9)
              icon.texture:SetAllPoints()

              spell.icon[index] = icon
            end

            local text = icon.text
            if list.text and not text then
              text = icon:CreateFontString(nil, "OVERLAY")
              text:SetPoint("CENTER", icon, 0, 0)
              text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
              text:SetTextColor(unpack(TEXT_COLOR))

              icon.text = text
            end

            local stackText = icon.stackText
            if index == 2 and not stackText then
              stackText = icon:CreateFontString(nil, "OVERLAY")
              stackText:SetPoint("CENTER", icon, 0, 0)
              stackText:SetFont("Fonts\\FRIZQT__.TTF", STACK_TEXT_HEIGHT or TEXT_HEIGHT, "OUTLINE")
              stackText:SetTextColor(unpack(STACK_TEXT_COLOR or TEXT_COLOR))

              icon.stackText = stackText
            end

            local line = icon.line
            if list.line and not line then
              line = icon:CreateTexture(nil, "ARTWORK")
              line:SetTexture(1, 1, 1, 1)
              line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
              line:SetPoint("RIGHT")
              line:Hide()

              icon.line = line
            end

            tinsert(TL.icons, icon)
          end

          return spell.icon, slide, text, line
        end
      end
    elseif category == "buff" then
      if not funcs.buff then
        function funcs.buff(i, spell, list, spellID, spellName, unit)
          local icon, slide, text, line

          icon = spell.icon
          if not icon then
            icon = CreateFrame("Frame", "Timeline_Icon_" .. i, TL)
            icon:SetPoint("TOP", TL, 0, -((i - 1) * ICON_HEIGHT))
            icon:SetPoint("RIGHT", TL.line, 0, 0)
            icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

            local texture = GetSpellTexture(spellID or spellName)
            icon.texture = icon:CreateTexture(nil, "ARTWORK")
            icon.texture:SetTexture(texture or 0, 0, 0.8, 1.0)
            icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            icon.texture:SetAlpha(0.9)
            icon.texture:SetAllPoints()

            slide = icon.slide
            if not slide then -- Create animation
              slide = icon:CreateAnimationGroup("SlideButtons")

              slide[1] = slide:CreateAnimation("Translation")
              slide[1]:SetOrder(1)

              slide[2] = slide:CreateAnimation("Translation")
              slide[2]:SetOrder(2)

              slide:SetScript("OnFinished", function(self, requested)
                if icon.line then icon.line:Hide() end
                if icon.text then icon.text:Hide() end

                if category == "activity" then icon:Hide() end
              end)

              icon.slide = slide
            end

            text = icon.text
            if list.text and not text then
              text = icon:CreateFontString(nil, "OVERLAY")
              text:SetPoint("CENTER", icon, 0, 0)
              text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
              text:SetTextColor(unpack(TEXT_COLOR))

              icon.text = text
            end

            line = icon.line
            if list.line and not line then
              line = icon:CreateTexture(nil, "ARTWORK")
              line:SetTexture(1, 1, 1, 1)
              line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
              line:SetPoint("RIGHT")
              line:Hide()

              icon.line = line
            end

            tinsert(TL.icons, icon)
          end

          return icon, slide, text, line
        end
      end
    elseif category == "debuff" then
      if not funcs.debuff then
        function funcs.debuff(i, spell, list, spellID, spellName, unit)
          local icon, slide, text, line

          icon = spell.icon
          if not icon then
            icon = CreateFrame("Frame", "Timeline_Icon_" .. i, TL)
            icon:SetPoint("TOP", TL, 0, -((i - 1) * ICON_HEIGHT))
            icon:SetPoint("RIGHT", TL.line, 0, 0)
            icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

            local texture = GetSpellTexture(spellID or spellName)
            icon.texture = icon:CreateTexture(nil, "ARTWORK")
            icon.texture:SetTexture(texture or 0, 0, 0.8, 1.0)
            icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            icon.texture:SetAlpha(0.9)
            icon.texture:SetAllPoints()

            slide = icon.slide
            if not slide then -- Create animation
              slide = icon:CreateAnimationGroup("SlideButtons")

              slide[1] = slide:CreateAnimation("Translation")
              slide[1]:SetOrder(1)

              slide[2] = slide:CreateAnimation("Translation")
              slide[2]:SetOrder(2)

              slide:SetScript("OnFinished", function(self, requested)
                if icon.line then icon.line:Hide() end
                if icon.text then icon.text:Hide() end

                if category == "activity" then icon:Hide() end
              end)

              icon.slide = slide
            end

            text = icon.text
            if list.text and not text then
              text = icon:CreateFontString(nil, "OVERLAY")
              text:SetPoint("CENTER", icon, 0, 0)
              text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
              text:SetTextColor(unpack(TEXT_COLOR))

              icon.text = text
            end

            line = icon.line
            if list.line and not line then
              line = icon:CreateTexture(nil, "ARTWORK")
              line:SetTexture(1, 1, 1, 1)
              line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
              line:SetPoint("RIGHT")
              line:Hide()

              icon.line = line
            end

            tinsert(TL.icons, icon)
          end

          return icon, slide, text, line
        end
      end
    elseif category == "activity" then
      if not funcs.activity then
        function funcs.activity(i, spell, list, spellID, spellName, unit)
          spell.icon = {}

          for index = 1, 2 do
            local icon, slide, text, line

            icon = spell.icon[index]
            if not icon then
              icon = CreateFrame("Frame", "Timeline_Icon_" .. i .. "_" .. index, TL)
              -- icon:SetPoint("TOP", TL, 0, -((i - 1) * ICON_HEIGHT))
              -- icon:SetPoint("RIGHT", TL.line, 0, 0)
              icon:SetPoint("RIGHT", TL, "TOPLEFT", 0, -((i - 1) * ICON_HEIGHT))
              icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

              icon.texture = icon:CreateTexture(nil, "ARTWORK")
              icon.texture:SetTexture(0.0, 0.0, 0.8, 1.0)
              icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
              icon.texture:SetAlpha(0.9)
              icon.texture:SetAllPoints()

              slide = icon.slide
              if not slide then -- Create animation
                slide = icon:CreateAnimationGroup("SlideButtons")

                slide[1] = slide:CreateAnimation("Translation")
                slide[1]:SetOrder(1)

                slide[2] = slide:CreateAnimation("Translation")
                slide[2]:SetOrder(2)

                slide[3] = slide:CreateAnimation("Translation")
                slide[3]:SetOrder(3)

                slide:SetScript("OnFinished", function(self, requested)
                  if icon.line then icon.line:Hide() end
                  if icon.text then icon.text:Hide() end

                  if category == "activity" then icon:Hide() end
                end)

                icon.slide = slide
              end

              text = icon.text
              if list.text and not text then
                text = icon:CreateFontString(nil, "OVERLAY")
                text:SetPoint("CENTER", icon, 0, 0)
                text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
                text:SetTextColor(unpack(TEXT_COLOR))

                icon.text = text
              end

              line = icon.line
              if list.line and not line then
                line = icon:CreateTexture(nil, "ARTWORK")
                line:SetTexture(1, 1, 1, 1)
                line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
                line:SetPoint("RIGHT")
                line:Hide()

                icon.line = line
              end

              icon:Hide()
              spell.icon[index] = icon
            end

            tinsert(TL.icons, icon)
          end

          return spell.icon, slide, text, line
        end
      end
    elseif category == "inactivity" then
      if not funcs.inactivity then
        function funcs.inactivity(i, spell, list, spellID, spellName, unit)
          spell.icon = {}
          spell.icon.filling = {}

          for index = 1, 2 do
            local icon, slide, text, line

            icon = spell.icon[index]
            if not icon then
              icon = CreateFrame("Frame", "Timeline_Icon_" .. i .. "_" .. index, TL)
              -- icon:SetPoint("TOP", TL, 0, -((i - 1) * ICON_HEIGHT))
              -- icon:SetPoint("RIGHT", TL.line, 0, 0)
              icon:SetPoint("RIGHT", TL, "TOPLEFT", 0, -((i - 1) * ICON_HEIGHT))
              icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

              icon.texture = icon:CreateTexture(nil, "ARTWORK")
              icon.texture:SetTexture(0.0, 0.0, 0.8, 1.0)
              icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
              icon.texture:SetAlpha(0.0)
              icon.texture:SetAllPoints()

              local fill = icon.fill
              if not fill then
                fill = icon:CreateTexture(nil, "ARTWORK")
                fill:SetTexture(1.0, 0.0, 0.0, 1.0)
                fill:SetHeight(ICON_HEIGHT - 2)
                fill:Hide()

                icon.fill = fill
              end

              slide = icon.slide
              if not slide then -- Create animation
                slide = icon:CreateAnimationGroup()

                slide[1] = slide:CreateAnimation("Path")
                slide[1]:SetOrder(1)

                slide[2] = slide:CreateAnimation("Path")
                slide[2]:SetOrder(2)

                slide[3] = slide:CreateAnimation("Path")
                slide[3]:SetOrder(3)

                slide:SetScript("OnFinished", function(self, requested)
                  if icon.line then icon.line:Hide() end
                  if icon.text then icon.text:Hide() end

                  if category == "activity" then
                    icon:Hide()
                  elseif category == "inactivity" then
                    icon:Hide()
                    icon.fill:Hide()
                  end
                end)

                icon.slide = slide
              end

              text = icon.text
              if list.text and not text then
                text = icon:CreateFontString(nil, "OVERLAY")
                text:SetPoint("CENTER", icon, 0, 0)
                text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
                text:SetTextColor(unpack(TEXT_COLOR))

                icon.text = text
              end

              line = icon.line
              if list.line and not line then
                line = icon:CreateTexture(nil, "ARTWORK")
                line:SetTexture(1, 1, 1, 1)
                line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
                line:SetPoint("RIGHT")
                line:Hide()

                icon.line = line
              end

              icon:Hide()
              spell.icon[index] = icon
            end

            tinsert(TL.icons, icon)
          end

          return spell.icon, slide, text, line
        end
      end
    elseif category == "rune" then
      do -- Load the DK specific rune data
        if not TL.runeIcons then
          TL.runeIcons = {
            "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood",
            "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Unholy",
            "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Frost",
            "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Death",}
        end

        if not TL.partners then
          TL.partners = {
            [1] = 2,
            [2] = 1,
            [3] = 4,
            [4] = 3,
            [5] = 6,
            [6] = 5
          }
        end

        if not TL.runeTypes then
          TL.runeTypes = {}
          TL.runeTypes[1] = {
            name = "Blood",
            texture = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood",
            timer = 0,
            duration = 10,
            start = 0,
            type = 1,
            ready = true,
          }
          TL.runeTypes[2] = {
            name = "Unholy",
            texture = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Unholy",
            timer = 0,
            duration = 10,
            start = 0,
            type = 2,
            ready = true,
          }
          TL.runeTypes[3] = {
            name = "Frost",
            texture = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Frost",
            timer = 0,
            duration = 10,
            start = 0,
            type = 3,
            ready = true,
          }
          TL.runeTypes[4] = {
            name = "Death",
            texture = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Death",
            timer = 0,
            duration = 10,
            start = 0,
            type = 4,
            ready = true,
          }
        end
      end

      if not funcs.rune then
        function funcs.rune(i, spell, list, spellID, spellName, unit)
          spell.icon = {}
          local runeNums = list.runeNums

          for index = runeNums[1], runeNums[2] do
            local icon = spell.icon[index]
            if not icon then
              icon = CreateFrame("Frame", "Timeline_Icon_" .. i .. "_" .. spellName, TL)
              icon:SetPoint("TOP", TL, 0, -((i - 1) * ICON_HEIGHT))
              if index == runeNums[1] then -- Left side
                icon:SetPoint("RIGHT", TL.line, 0, 0)
              else -- Right side
                icon:SetPoint("RIGHT", TL.line, ICON_HEIGHT, 0)
              end
              -- icon:SetPoint("RIGHT", TL, "TOPLEFT", 0, -((i - 1) * ICON_HEIGHT))
              icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

              icon.texture = icon:CreateTexture(nil, "ARTWORK")
              icon.texture:SetTexture(TL.runeIcons[list.ID])
              icon.texture:SetAllPoints()

              spell.icon[index] = icon
            end

            local text = icon.text
            if list.text and not text then
              text = icon:CreateFontString(nil, "OVERLAY")
              text:SetPoint("CENTER", icon, 0, 0)
              text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
              text:SetTextColor(unpack(TEXT_COLOR))

              icon.text = text
            end

            local line = icon.line
            if list.line and not line then
              line = icon:CreateTexture(nil, "ARTWORK")
              line:SetTexture(1, 1, 1, 1)
              line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
              line:SetPoint("RIGHT")
              line:Hide()

              icon.line = line
            end

            tinsert(TL.icons, icon)
          end

          return spell.icon, slide, text, line
        end
      end
    else
      debug("No category for:", category)
    end
  end
end

function TL.loadList(specName)
	local specName = specName or select(2, GetSpecializationInfo(GetSpecialization()))
	local list = classFunc(specName)

	for i = 1, NUMBER_OF_ICONS do
		local list = TL.charDB[i] or list[i] -- Take it from SVars if it exists, otherwise go with the list version

		local spell
		if list then
			spell = {}
		end

		if spell then
			local category = list.category
			local spellName = list.name
			local spellID = list.ID or select(7, GetSpellInfo(spellName))
			local unit = list.unit or "player"

      if TL.categoryFuncs[category] then
        spell.icon, spell.slide, spell.text, spell.line = TL.categoryFuncs[category](i, spell, list, spellID, spellName, unit)
      end

      spell.index = i

      local icon, slide, text, line = spell.icon, spell.slide, spell.text, spell.line

			if category then
				if spellID then TL.categories[category][spellID] = spell end
				if spellName then TL.categories[category][spellName] = spell end
				tinsert(TL.categories[category], spell)

				if category == "cooldown" then
          local icon = spell.icon[1]
          local icon1 = spell.icon[1]
          local icon2 = spell.icon[2]
          icon2:Hide()

					function spell:update()
            local frameWidth = TL:GetWidth()
            local edge = UIParent:GetRight() - TL.line:GetRight()

            local charges, chargeMax, start, duration = GetSpellCharges(spellID)

            if charges and chargeMax > charges then
              icon1:Show()
              icon2:Show()

              icon2.stackText:SetText(charges)
            else
              icon1:Show()
              icon2:Hide() -- No charges, so keep the second icon hidden
              start, duration = GetSpellCooldown(spellID) -- No charges, so go with the standard CD
            end

            if not spell.charges then -- Handle the cooldown in here
              if charges then
                if charges < chargeMax and not spell.queued then
                  spell.charges = true
                end

                if charges > 0 then -- There is a charge at the ready, so icon should be by line
                  spell.icon[2]:SetPoint("RIGHT", TL.line, ICON_HEIGHT, 0)
                end
              end

              local icon = spell.icon[1]

              local remaining = (start + duration) - GetTime()
              local x = ((frameWidth * remaining) / TOTAL_TIME)
              if x > edge then x = edge end
              icon:SetPoint("RIGHT", TL.line, x, 0)

              icon.ticker = newTicker(0.001, function(ticker)
                local remaining = (start + duration) - GetTime()
                local x = ((frameWidth * remaining) / TOTAL_TIME)
                if x > edge then x = edge end -- Icon is off screen, adjust it

                if remaining <= 0 then
                  if icon.line then icon.line:Hide() end
                  if icon.text then icon.text:Hide() end

                  ticker:Cancel()
                  icon.ticker = nil

                  if spell.queued then -- There is at least one more charge on CD
                    spell.queued = false
                    spell:update()
                  else -- Shouldn't be any more charges
                    icon2.stackText:SetText(chargeMax)
                    spell.charges = false
                  end
                end

                icon:SetPoint("RIGHT", TL.line, x, 0)
              end)
            else
              spell.queued = true
              spell.charges = false

              if charges and charges == 0 then -- No charges are available, so move the second icon to its max duration to wait
                local x = (frameWidth * duration) / TOTAL_TIME
                if x > edge then x = edge end

                spell.icon[2]:SetPoint("RIGHT", TL.line, x, 0)
              end
            end
					end
				elseif category == "buff" then
					function spell:update()
						local cTime = GetTime()

						local name, _, spellIcon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3, index

						while true do -- Find the buff (there are more efficient ways to do this, but I haven't found one I like. It seems unreliable...)
							index = (index or 0) + 1
							name, _, spellIcon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3 = UnitBuff(unit, index)

							if (ID == spellID) or (spellName == name) then -- Found a match
								break
							elseif not name then -- Failed to find a match, return
								return
							end
						end

						local remaining = expires - cTime
            local total = expires

            do -- Creates the ticker
              local frameWidth = TL:GetWidth()
              local x = (frameWidth * remaining) / TOTAL_TIME
              local edge = UIParent:GetRight() - TL.line:GetRight()
              if x > edge then x = edge end

              icon:SetPoint("RIGHT", TL.line, x, 0)

              if icon.ticker then
                icon.ticker:Cancel()
                icon.ticker = nil
              end

              icon.ticker = newTicker(0.001, function(ticker)
                local remaining = total - GetTime()
                local x = (frameWidth * remaining) / TOTAL_TIME

                if edge > x then
                  if 0 >= x then
                    x = 0
                    ticker:Cancel()
                    icon.ticker = nil

                    if icon.line then icon.line:Hide() end
                    if icon.text then icon.text:Hide() end
                  end

                  icon:SetPoint("RIGHT", TL.line, x, 0)
                end
              end)
            end

            if icon.line then icon.line:Show() end
            if icon.text then icon.text:Show() end
					end
				elseif category == "debuff" then
					function spell:update()
						local cTime = GetTime()

						local name, _, icon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3, index

						while true do -- Find the debuff (there are more efficient ways to do this, but I haven't found one I like. It seems unreliable...)
							index = (index or 0) + 1
							name, _, icon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3 = UnitDebuff(unit, index)

							if (ID == spellID) or (spellName == name) then -- Found a match
								break
							elseif not name then -- Failed to find a match, return
								return
							end
						end

            local remaining = expires - cTime
            local total = expires

            do -- Creates the ticker
              local frameWidth = TL:GetWidth()
              local x = (frameWidth * remaining) / TOTAL_TIME
              local edge = UIParent:GetRight() - TL.line:GetRight()
              if x > edge then x = edge end

              icon:SetPoint("RIGHT", TL.line, x, 0)

              if icon.ticker then
                icon.ticker:Cancel()
                icon.ticker = nil
              end

              icon.ticker = newTicker(0.001, function(ticker)
                local remaining = total - GetTime()
                local x = (frameWidth * remaining) / TOTAL_TIME

                if edge > x then
                  if 0 >= x then
                    x = 0
                    ticker:Cancel()
                    icon.ticker = nil

                    if icon.line then icon.line:Hide() end
                    if icon.text then icon.text:Hide() end
                  end

                  icon:SetPoint("RIGHT", TL.line, x, 0)
                end
              end)
            end

            if icon.line then icon.line:Show() end
            if icon.text then icon.text:Show() end
					end
				elseif category == "activity" then
          local count = 1

					function spell:update(c1, c2, c3, c4)
						local cTime = GetTime()

						local remaining
            count = count + 1

						local name, nameSubtext, text, texture, start, stop, tradeSkill, castID, notInterruptible = UnitCastingInfo(unit)

						if name then -- There is an active cast
							remaining = (stop - start) / 1000
						else -- No active cast, check GCD instead
							local startGCD, GCD = GetSpellCooldown(61304) -- This spellID checks the GCD specifically

							if GCD then
								remaining = (startGCD + GCD) - cTime
							else
								return
							end
						end

						if spell.marks then
							for i = 1, #spell.marks do
								local mark = spell.marks[i]

								local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(mark)

								if name then
									local haste = GetHaste()

									local baseCastLength = round(castTime * (1 + (haste / 100)) / 1000, 1)
									local castLength = baseCastLength / (1 + (haste / 100))
								end
							end
						end

            spell.currentIcon = (count % 2) + 1
            local icon = spell.icon[(count % 2) + 1]
            local slide, text, line = icon.slide, icon.text, icon.line

            if c1 then -- Override color sent
              icon.texture:SetTexture(c1, c2, c3, c4)
            else
              icon.texture:SetTexture(0.0, 0.0, 0.8, 1.0)
            end

						do -- Handles updating the bar's width
							local x = (TL:GetWidth() * remaining) / TOTAL_TIME

							icon:SetWidth(x)
							icon:Show()

							if remaining >= TOTAL_TIME then
								local delay = remaining - TOTAL_TIME
								slide[2]:SetStartDelay(remaining - TOTAL_TIME)
								slide[2]:SetDuration(remaining - delay)
							else
								slide[2]:SetStartDelay(0)
								slide[2]:SetDuration(remaining)
							end

							slide[1]:SetDuration(0.001)
              slide[3]:SetDuration(remaining * 2)

							slide[1]:SetOffset(x, 0)
							slide[2]:SetOffset(-x, 0)
							slide[3]:SetOffset(-(x * 2), 0)

							if slide:IsPlaying() then slide:Stop() end
							slide:Play()

							if icon.line then
								icon.line:Show()
							end

							if icon.text then
								icon.text:Show()
							end
						end
					end
				elseif category == "inactivity" then
          local count = 0
          local hiddenLines = {}

					function spell:update(c1, c2, c3, c4)
						local cTime = GetTime()

            count = count + 1

						local name, nameSubtext, text, texture, start, stop, tradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
            local startGCD, GCD = GetSpellCooldown(61304) -- This spellID checks the GCD specifically

            local castTime = ((stop or 0) - (start or 0)) / 1000
            local total = max(cTime + castTime, startGCD + GCD)
            local remaining = total - GetTime()

						if spell.marks then
							for i = 1, #spell.marks do
								local mark = spell.marks[i]

								local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(mark)

								if name then
									local haste = GetHaste()

									local baseCastLength = round(castTime * (1 + (haste / 100)) / 1000, 1)
									local castLength = baseCastLength / (1 + (haste / 100))
								end
							end
						end

						do -- Handles updating the bar's width
              local frameWidth = TL:GetWidth()
              local x = (frameWidth * remaining) / TOTAL_TIME

              local hidden = TL:CreateTexture(nil, "ARTWORK")
              hidden:SetSize(x, ICON_HEIGHT - 2)
              hidden:SetPoint("RIGHT", TL, "TOPLEFT", x, -((i - 1) * ICON_HEIGHT))
              local num = #hiddenLines + 1 -- Keep this num index, it's used in the ticker
              hiddenLines[num] = hidden

              local fill = TL:CreateTexture(nil, "ARTWORK")
              fill:SetTexture(1.0, 0.0, 0.0, 1.0)
              fill:SetHeight(ICON_HEIGHT - 2)
              fill:SetPoint("LEFT", hidden, "RIGHT")
              fill:SetPoint("RIGHT", TL.line, "LEFT")

              newTicker(0.001, function(ticker)
                local remaining = total - GetTime()
                local x = (frameWidth * remaining) / TOTAL_TIME

                hidden:SetPoint("RIGHT", TL, "TOPLEFT", x, -((i - 1) * ICON_HEIGHT))

                if 0 >= x then
                  if hiddenLines[num + 1] and not hiddenLines[num + 1].set then -- This ticker's hidden texture is no longer the most recent one
                    fill:SetPoint("RIGHT", hiddenLines[num + 1], "LEFT")
                    hiddenLines[num + 1].set = true
                  end

                  if hiddenLines[num + 1] and hiddenLines[num + 1]:GetLeft() < 0 then -- Make sure the most recent doesn't get cancelled
                    ticker:Cancel()
                    fill:Hide()
                    hiddenLines[num] = false
                    hidden = nil
                    fill = nil
                  end
                end
              end)

							if icon.line then
								icon.line:Show()
							end

							if icon.text then
								icon.text:Show()
							end
						end
					end
				elseif category == "rune" then
          function spell:update(runeNum, partnerNum, index)
            local start, duration, runeReady = GetRuneCooldown(runeNum)
            local remaining = (start + duration) - GetTime()

            if not runeReady and remaining < duration then -- Rune was already on CD, ignore
            	return -- debug("Remaining is lower than duration, returning.", runeNum)
            elseif not runeReady then -- Start the cooldown
              if icon.line then icon.line:Show() end
              if icon.text then icon.text:Show() end

              local rune = self.icon[runeNum]
              local partner = self.icon[partnerNum]

              local start, duration, runeReady = GetRuneCooldown(runeNum)
              local pStart, pDuration, pRuneReady = GetRuneCooldown(partnerNum)

              local cTime = GetTime()
              local remaining = (start + duration) - cTime
              if remaining > duration then remaining = duration end
              if remaining < 0 then remaining = 0 end

              local frameWidth = TL:GetWidth()
              local x = (frameWidth * remaining) / TOTAL_TIME
              local edge = UIParent:GetRight() - TL.line:GetRight()
              if x > edge then x = edge end

              rune:SetPoint("RIGHT", TL.line, x, 0)

              if rune.ticker then
                rune.ticker:Cancel()
                rune.ticker = nil
              end

              rune.ticker = newTicker(0.001, function(ticker)
                local start, duration, runeReady = GetRuneCooldown(runeNum)

                if not runeReady and start > 0 then
                  local remaining = (start + duration) - GetTime()
                  if remaining > duration then remaining = duration end
                  if remaining < 0 then remaining = 0 end

                  rune.remaining = remaining

                  local x = (frameWidth * remaining) / TOTAL_TIME

                  if not pRuneReady and (partner.remaining or 0) <= remaining then -- Partner rune is not ready, AKA it's cooling down
                    x = x + ICON_HEIGHT
                  end
                  if x > edge then x = edge end -- Icon is off screen, adjust it

                  rune:SetPoint("RIGHT", TL.line, x, 0)
                else
                  -- debug("Stopping ticker")
                  ticker:Cancel()
                  rune.ticker = nil
                  rune.remaining = 0

                  if rune.line then rune.line:Hide() end
                  if rune.text then rune.text:Hide() end
                end
              end)
            end
          end
				end
			end
		end
	end
end

function TL.startCombat()
	TL.active = true
	TL.combatStart = GetTime()
end

function TL.stopCombat()
	TL.active = false
	TL.combatStop = GetTime()
end

local function createMainButton(button)
  -- button:SetPoint("TOPLEFT", 0, 0)
  -- button:SetPoint("TOPRIGHT", 0, 0)
  button:SetSize(150, 44)

  do -- Basic textures and stuff
    button.background = button:CreateTexture(nil, "BACKGROUND")
    button.background:SetPoint("TOPLEFT", button, 4.5, -4)
    button.background:SetPoint("BOTTOMRIGHT", button, -4, 3)
    button.background:SetTexture(0.07, 0.07, 0.07, 1.0)

    button.normal = button:CreateTexture(nil, "BACKGROUND")
    button.normal:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
    button.normal:SetTexCoord(0.00195313, 0.58789063, 0.87304688, 0.92773438)
    button.normal:SetAllPoints(button)
    button:SetNormalTexture(button.normal)

    button.highlight = button:CreateTexture(nil, "BACKGROUND")
    button.highlight:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
    button.highlight:SetTexCoord(0.00195313, 0.58789063, 0.87304688, 0.92773438)
    button.highlight:SetVertexColor(0.7, 0.7, 0.7, 1.0)
    button.highlight:SetAllPoints(button)
    button:SetHighlightTexture(button.highlight)

    button.disabled = button:CreateTexture(nil, "BACKGROUND")
    button.disabled:SetTexture("Interface\\PetBattles\\PetJournal")
    button.disabled:SetTexCoord(0.49804688, 0.90625000, 0.12792969, 0.17285156)
    button.disabled:SetAllPoints(button)
    button:SetDisabledTexture(button.disabled)

    button.pushed = button:CreateTexture(nil, "BACKGROUND")
    button.pushed:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
    button.pushed:SetTexCoord(0.00195313, 0.58789063, 0.92968750, 0.98437500)
    button.pushed:SetAllPoints(button)
    button:SetPushedTexture(button.pushed)
  end

  local icon = button.icon
  if not icon then -- Create Icon
    icon = button:CreateTexture(nil, "OVERLAY")
    icon:SetSize(32, 32)
    icon:SetPoint("LEFT", 30, 0)
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    icon:SetAlpha(0.9)

    button.icon = icon
  end

  local expander = button.expander
  if not expander then
    expander = button:CreateTexture(nil, "BACKGROUND")
    expander:SetSize(button:GetWidth(), button:GetHeight())
    expander:SetPoint("TOPLEFT")
    expander:SetPoint("TOPRIGHT")
    expander.defaultHeight = button:GetHeight()
    expander.height = expander:GetHeight()
    expander.expanded = false

    button.expander = expander
  end

  local dropDown = button.dropDown
  if not dropDown then
    dropDown = CreateFrame("Frame", nil, button)
    dropDown.texture = dropDown:CreateTexture(nil, "BACKGROUND")
    dropDown:SetSize(button:GetWidth(), 70)
    dropDown:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 5, 2)
    dropDown:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", -5, 2)
    dropDown.texture:SetTexture(0.07, 0.07, 0.07, 1.0)
    dropDown.texture:SetAllPoints()
    dropDown.lineHeight = 13
    dropDown.numLines = 0
    dropDown:Hide()

    button.dropDown = dropDown
  end

  do -- Main Text
    button.value = button:CreateFontString(nil, "ARTWORK")
    -- button.value:SetPoint("RIGHT", button, -13, 0)
    button.value:SetPoint("TOPRIGHT", button, -13, 0)
    button.value:SetPoint("BOTTOMRIGHT", button, -13, 0)
    button.value:SetFont("Fonts\\FRIZQT__.TTF", 22)
    button.value:SetTextColor(1, 1, 0, 1)

    button.title = button:CreateFontString(nil, "ARTWORK")
    -- button.title:SetPoint("LEFT", button.icon, "RIGHT", 5, 0)
    -- button.title:SetPoint("TOP", button, 5, 0)
    -- button.title:SetPoint("BOTTOM", button, 5, 0)
    -- button.title:SetPoint("RIGHT", button.value, "LEFT", -3, 0)

    button.title:SetPoint("CENTER", button, 0, 0)
    button.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
    button.title:SetTextColor(1, 1, 0, 1)
    -- button.title:SetJustifyH("LEFT")
  end
end

function TL.scrollFrameUpdate(table)
  local height = 0

  local spacing = 2

  for i, button in ipairs(table) do
    height = height + button:GetHeight() + spacing
  end

  TL.scrollBar:SetMinMaxValues(0, max(height - TL.scrollBar:GetHeight(), 0))
end

function TL.createMainOptionButtons(parent) -- Create the default main buttons
	if not TL.buttons then TL.buttons = {} end

  for i = 1, #TL.indexedCategories do
    local b = TL.buttons[i]

    if not b then
      TL.buttons[i] = CreateFrame("CheckButton", "Timeline_Options_Button_" .. i, parent)
      b = TL.buttons[i]

      b.text = {}

      createMainButton(b)

      do -- Button Scripts
        local lastClickTime = GetTime()
        b:RegisterForClicks("LeftButtonUp", "RightButtonUp")

        b:SetScript("OnClick", function(self, click)
          if GetTime() > lastClickTime then

            if not self.checked then -- Create checked texture
              self.checked = self:CreateTexture(nil, "BACKGROUND")
              self.checked:SetTexture("Interface\\PetBattles\\PetJournal")
              self.checked:SetTexCoord(0.49804688, 0.90625000, 0.17480469, 0.21972656) -- Blue highlight border
              self.checked:SetBlendMode("ADD")
              self.checked:SetPoint("TOPLEFT", 2, -2)
              self.checked:SetPoint("BOTTOMRIGHT", -2, 2)
              self:SetCheckedTexture(self.checked)

              self.checked:SetVertexColor(0.3, 0.5, 0.8, 0.8) -- Blue: Dark and more subtle blue
            end

            if click == "LeftButton" then
              if self:GetChecked() then
                -- self:expand("show")
                self.expanded = true
              else
                -- self:expand("hide")
                self.expanded = false
              end

              for i = 1, #TL.buttons do
                if TL.buttons[i] ~= self and TL.buttons[i]:GetChecked() then
                  TL.buttons[i]:SetChecked(false)
                  TL.buttons[i].expanded = false
                end
              end
            elseif click == "RightButton" then
              if not self.dropDown:IsShown() then -- Expand drop down
								if self.update then
									self:update()
								else
									debug("No update function for button:", i, self.title:GetText())
								end

								self:SetChecked(true)
								self.dropDown:Show()
								-- self.dropDown:SetHeight(150)
								-- self.expander:SetHeight(self.dropDown:GetHeight() + self:GetHeight())
              else -- Collapse drop down
								self:SetChecked(false)
								self.dropDown:Hide()
								self.dropDown:SetHeight(self:GetHeight())
								self.expander:SetHeight(self.dropDown:GetHeight())

                -- TL.updateButtonList()
                -- TL.scrollFrameUpdate()
              end
            end

            PlaySound("igMainMenuOptionCheckBoxOn")
            lastClickTime = GetTime() + 0.1
          end
        end)
      end
    end

    b.title:SetFormattedText("Create new %s.", TL.indexedCategories[i])

		b.update = parent[TL.indexedCategories[i]]

		parent[i] = b
  end

  if TL.buttons[1] then
    if not TL.topAnchor1 then TL.topAnchor1 = {TL.buttons[1]:GetPoint(1)} end
    if not TL.topAnchor2 then TL.topAnchor2 = {TL.buttons[1]:GetPoint(2)} end
  end

  -- TL.contentFrame:displayMainButtons(TL.buttons)
end

local function addListEntry(input)
	local tableDB = TL.charDB[input.index]

	if not tableDB and input.index then
		debug("Creating table")

		tableDB = {}
		TL.charDB[input.index] = tableDB
	end

	if tableDB then
		tableDB.category = input.category
		tableDB.ID = input.spellID
		tableDB.name = input.spellName
		tableDB.line = input.line
		tableDB.lineHeight = input.lineHeight

		debug("CURRENT DB STATUS:")
		for k, v in pairs(tableDB) do
			debug(k, v)
		end
	end
end

function TL.createOptionsFrame()
	local f = TL.options
	if not f then
		f = optionsFrame -- NOTE: Frame is created at the top so that its position gets saved properly.

		if not f:GetPoint() then
			debug("Options frame has no point set, adding it.")
			f:SetPoint("CENTER")
		end

		f:SetSize(350, 556)

		local backdrop = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tileSize = 32,
		edgeSize = 16,}

		f:SetBackdrop(backdrop)
		f:SetBackdropColor(0.15, 0.15, 0.15, 1)
		f:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.7)

		f:EnableMouse(true)
		f:EnableKeyboard(true)
		f:SetResizable(true)
		f:SetUserPlaced(true)
		f:SetFrameStrata("HIGH")

		f:SetScript("OnMouseDown", function(self, click)
			if click == "LeftButton" and not self.isMoving then
				self:StartMoving()
				self.isMoving = true
			end
		end)

		f:SetScript("OnMouseUp", function(self, click)
			if click == "LeftButton" and self.isMoving then
				self:StopMovingOrSizing()
				self.isMoving = false
			end
		end)

		f:SetScript("OnShow", function(self)
			debug("Main frame showing.")
		end)

		f:SetScript("OnHide", function(self)
			debug("Main frame hiding.")
		end)

		TL.options = f
	end

	local header, title = f.header, f.title
	if not header and not title then -- Header and title text and close button
		header = CreateFrame("Frame", "Timeline_Options_Header", f)
		header:SetPoint("TOPLEFT", f, 15, -15)
		header:SetPoint("TOPRIGHT", f, -15, -15)
		header:SetHeight(40)
		header.texture = header:CreateTexture(nil, "BACKGROUND")
		header.texture:SetTexture(0.1, 0.1, 0.1, 1)
		header.texture:SetAllPoints(header)

		title = header:CreateFontString(nil, "ARTWORK")
		title:SetPoint("LEFT", header.texture, 10, 0)
		title:SetFont("Fonts\\FRIZQT__.TTF", 30)
		title:SetTextColor(0.8, 0.8, 0, 1)
		title:SetShadowOffset(3, -3)
		title:SetText("Timeline")

		f.header = header
		f.title = title
	end

	local close = f.closeButton
	if not close then -- Close button
		close = CreateFrame("Button", nil, header)
		close:SetSize(40, 40)
		close:SetPoint("RIGHT", 0, 0)
		close:SetNormalTexture("Interface\\RaidFrame\\ReadyCheck-NotReady.png")
		close:SetHighlightTexture("Interface\\RaidFrame\\ReadyCheck-NotReady.png")

		close.BG = close:CreateTexture(nil, "BORDER")
		close.BG:SetAllPoints()
		close.BG:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMaskSmall.png")
		close.BG:SetVertexColor(0, 0, 0, 0.3)

		close:SetScript("OnClick", function(self)
			f:Hide()
		end)

		f.closeButton = close
	end

	local scroll = f.scroll
	if not scroll then -- Middle frame
		scroll = CreateFrame("Frame", "Timeline_Options_Middle", f)
		scroll.anchor = CreateFrame("ScrollFrame", nil, f)
		scroll.anchor:SetScrollChild(scroll)
		scroll:SetAllPoints(scroll.anchor)

		scroll.anchor:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -15)
		scroll.anchor:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -15)
		scroll.anchor:SetHeight(f:GetHeight() - 100)

		scroll.anchor.texture = scroll.anchor:CreateTexture(nil, "BACKGROUND")
		scroll.anchor.texture:SetTexture(0.1, 0.1, 0.1, 1)
		scroll.anchor.texture:SetAllPoints(scroll.anchor)

		function scroll:setButtonAnchors()
			local y = -2

			for i = 1, #self do
				local button = self[i]
				local prevButton = self[i - 1]

				if i == 1 then
					button:ClearAllPoints()
					button:SetPoint("TOPLEFT", 0, 0)
					button:SetPoint("TOPRIGHT")
				else
					if i > 2 and prevButton and prevButton.dragging then
						local prevButtonExpander = self[i - 2].expander
						local height = prevButton:GetHeight()
						button:ClearAllPoints()
						button:SetPoint("TOPRIGHT", prevButtonExpander, "BOTTOMRIGHT", 0, (y * 2) - height)
						button:SetPoint("TOPLEFT", prevButtonExpander, "BOTTOMLEFT", 0, (y * 2) - height)
					else
						local prevButtonExpander = self[i - 1].expander
						button:ClearAllPoints()
						button:SetPoint("TOPRIGHT", prevButtonExpander, "BOTTOMRIGHT", 0, y)
						button:SetPoint("TOPLEFT", prevButtonExpander, "BOTTOMLEFT", 0, y)
					end
				end
			end

			-- TL.scrollFrameUpdate(self)
		end

		f.scroll = scroll
	end

	local slider = f.slider
	if not slider then
		slider = CreateFrame("Slider", nil, scroll)
		slider:SetSize(100, 20)
		slider:SetPoint("TOPLEFT", f, 5, -3)
		slider:SetPoint("TOPRIGHT", f, -5, -3)

		slider:SetBackdrop({
			bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
			edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
			tile = true,
			tileSize = 8,
			edgeSize = 8,})
		slider:SetBackdropColor(0.15, 0.15, 0.15, 0)
		slider:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.5)

		slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Vertical")
		slider:SetOrientation("VERTICAL")
		slider:SetMinMaxValues(0, 600)
		slider:SetValue(0)

		slider:SetScript("OnValueChanged", function(self, value)
			scroll:SetSize(scroll.anchor:GetSize())
			scroll.anchor:SetVerticalScroll(value)
		end)

		scroll.scrollMultiplier = 10 -- Percent of total distance per scroll

		if not slider.mouseWheelFunc then
			function slider.mouseWheelFunc(self, value)
				local current = slider:GetValue()
				local minimum, maximum = slider:GetMinMaxValues()

				local onePercent = (maximum - minimum) / 100
				local percent = (current - minimum) / (maximum - minimum) * 100

				if value < 0 and current < maximum then
					current = min(maximum, current + (onePercent * scroll.scrollMultiplier))
				elseif value > 0 and current > minimum then
					current = max(minimum, current - (onePercent * scroll.scrollMultiplier))
				end

				slider:SetValue(current)
			end
		end

		slider:SetScript("OnMouseWheel", slider.mouseWheelFunc)
		scroll.anchor:SetScript("OnMouseWheel", slider.mouseWheelFunc)

		slider:Hide()
		f.slider = slider
	end

	do -- Create buttons and options functions
		for i = 1, #TL.indexedCategories do
			local category = TL.indexedCategories[i]

			if category == "cooldown" then
				if not scroll.cooldown then
					function scroll:cooldown()
						local height = 0
						local dropDown = self.dropDown
						local expander = self.expander

						if not dropDown.input then
							dropDown.input = {}
						end

						dropDown.input.category = category

						local ID = dropDown.ID
						if not ID then
							ID = CreateFrame("Frame", nil, dropDown)

							ID:SetSize(80, 30)
							ID:SetPoint("TOPRIGHT", -3, -3)
							ID:SetPoint("TOPLEFT", 3, -3)

							ID.background = ID:CreateTexture(nil, "BACKGROUND")
							ID.background:SetAllPoints()
							ID.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							ID.title = ID:CreateFontString(nil, "ARTWORK")
							ID.title:SetPoint("LEFT", 2, 0)
							ID.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
							ID.title:SetTextColor(1, 1, 1, 1)
							ID.title:SetText("Enter a spellID:")

							local e = CreateFrame("EditBox", nil, ID)
							-- e:SetSize(100, ID:GetHeight() - 10)
							e:SetPoint("LEFT", ID.title, "RIGHT", 10, 0)
							e:SetPoint("RIGHT", ID, -10, 0)
							e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
							e:SetTextColor(0.0, 0.5, 0.5, 1)

							e.texture = e:CreateTexture(nil, "BACKGROUND")
							e.texture:SetTexture(0, 0, 0, 1)
							e.texture:SetAllPoints()

							e:SetMultiLine(true)
							e:SetMaxLetters(100)
							e:SetAutoFocus(false)

							do -- Scripts
								e:SetScript("OnEscapePressed", function(self)
									e:ClearFocus()
								end)

								e:SetScript("OnEnterPressed", function(self)
									e:ClearFocus()
								end)

								-- e:SetScript("OnEditFocusGained", function(self)
								--   self:HighlightText()
								-- end)

								e:SetScript("OnEditFocusLost", function(self)
									local string = self:GetText():trim()

									dropDown.input.spellID = nil
									dropDown.input.spellName = nil

									if string ~= "" then
										local num = string:match("(%d+)")
										local num = tonumber(num)

										if num then
											local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(num)

											if spellID then
												dropDown.currentSpell.title:SetText("Current spell: |cFF00CCFF" .. spellName .. "|r")
												dropDown.currentSpell.icon:SetTexture(icon)

												dropDown.input.spellID = spellID
												dropDown.input.spellName = spellName
											else
												dropDown.currentSpell.title:SetText("Current spell: |cFF9E5A01Invalid ID|r.")
												dropDown.currentSpell.icon:SetTexture(nil)
											end
										else
											dropDown.currentSpell.title:SetText("Enter a spellID in the edit box.")
											dropDown.currentSpell.icon:SetTexture(nil)
										end
									end

									addListEntry(dropDown.input)
								end)
							end

							ID.editBox = e
							dropDown.ID = ID
						end

						local currentSpell = dropDown.currentSpell
						if not currentSpell then
							currentSpell = CreateFrame("Frame", nil, dropDown)

							currentSpell:SetSize(80, 30)
							currentSpell:SetPoint("TOPRIGHT", ID, "BOTTOMRIGHT", 0, -3)
							currentSpell:SetPoint("TOPLEFT", ID, "BOTTOMLEFT", 0, -3)

							currentSpell.background = currentSpell:CreateTexture(nil, "BACKGROUND")
							currentSpell.background:SetAllPoints()
							currentSpell.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local icon = currentSpell.icon
							if not icon then -- Create Icon
								local iconHeight = currentSpell:GetHeight() - 10

								icon = currentSpell:CreateTexture(nil, "OVERLAY")
								icon:SetSize(iconHeight, iconHeight)
								icon:SetPoint("RIGHT", -10, 0)
								icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
								icon:SetAlpha(0.9)

								currentSpell.icon = icon
							end

							local title = currentSpell.title
							if not title then
								title = currentSpell:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Current spell:")

								currentSpell.title = title
							end

							dropDown.currentSpell = currentSpell
						end

						local index = dropDown.index
						if not index then
							index = CreateFrame("Frame", nil, dropDown)

							index:SetSize(80, 30)
							index:SetPoint("TOPRIGHT", currentSpell, "BOTTOMRIGHT", 0, -3)
							index:SetPoint("TOPLEFT", currentSpell, "BOTTOMLEFT", 0, -3)

							index.background = index:CreateTexture(nil, "BACKGROUND")
							index.background:SetAllPoints()
							index.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = index.title
							if not title then
								title = index:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Index: ")

								index.title = title
							end

							local e = index.editBox
							if not e then
								e = CreateFrame("EditBox", nil, index)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", index, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.index = nil

										if string ~= "" then
											local num = string:match("%d+")
											local num = tonumber(num)

											if num then
												if num > NUMBER_OF_ICONS then
													num = NUMBER_OF_ICONS
													self:SetText(NUMBER_OF_ICONS)
												end

												dropDown.input.index = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								index.editBox = e
							end

							dropDown.index = index
						end

						local line = dropDown.line
						if not line then
							line = CreateFrame("Frame", nil, dropDown)

							line:SetSize(80, 60)
							line:SetPoint("TOPRIGHT", index, "BOTTOMRIGHT", 0, -3)
							line:SetPoint("TOPLEFT", index, "BOTTOMLEFT", 0, -3)

							line.background = line:CreateTexture(nil, "BACKGROUND")
							line.background:SetAllPoints()
							line.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = line.title
							if not title then
								title = line:CreateFontString(nil, "ARTWORK")
								title:SetPoint("TOPLEFT", 2, -10)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Vertical line: (Yes/No)")

								line.title = title
							end

							local e = line.editBox1
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.line = nil

										if string ~= "" then
											if string:match("yes") or string:match("y") then
												debug(string, "Matched yes")
												dropDown.input.line = true
											elseif string:match("no") or string:match("n") or string:match("nil") then
												debug(string, "Matched no")
											else
												debug(string, "Didn't match either")
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox1 = e
							end

							local lineHeight = line.lineHeight
							if not lineHeight then
								lineHeight = line:CreateFontString(nil, "ARTWORK")
								lineHeight:SetPoint("BOTTOMLEFT", 2, 8)
								lineHeight:SetFont("Fonts\\FRIZQT__.TTF", 15)
								lineHeight:SetTextColor(1, 1, 1, 1)
								lineHeight:SetText("Line height:")

								line.lineHeight = lineHeight
							end

							local e = line.editBox2
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", lineHeight, 0, 5)
								e:SetPoint("BOTTOM", lineHeight, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():trim()

										dropDown.input.lineHeight = nil

										if string ~= "" then
											local num = string:match("(%d+)")
											local num = tonumber(num)

											if num then
												dropDown.input.lineHeight = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox2 = e
							end

							dropDown.line = line
						end

						height = height + ID:GetHeight() + 3
						height = height + currentSpell:GetHeight() + 3
						height = height + index:GetHeight() + 3
						height = height + line:GetHeight() + 3

						dropDown:SetHeight(height + 3)
						expander:SetHeight(dropDown:GetHeight() + self:GetHeight())
					end
				end
			elseif category == "buff" then
				if not scroll.buff then
					function scroll:buff()
						local height = 0
						local dropDown = self.dropDown
						local expander = self.expander

						if not dropDown.input then
							dropDown.input = {}
						end

						dropDown.input.category = category

						local ID = dropDown.ID
						if not ID then
							ID = CreateFrame("Frame", nil, dropDown)

							ID:SetSize(80, 30)
							ID:SetPoint("TOPRIGHT", -3, -3)
							ID:SetPoint("TOPLEFT", 3, -3)

							ID.background = ID:CreateTexture(nil, "BACKGROUND")
							ID.background:SetAllPoints()
							ID.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							ID.title = ID:CreateFontString(nil, "ARTWORK")
							ID.title:SetPoint("LEFT", 2, 0)
							ID.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
							ID.title:SetTextColor(1, 1, 1, 1)
							ID.title:SetText("Enter a spellID:")

							local e = CreateFrame("EditBox", nil, ID)
							-- e:SetSize(100, ID:GetHeight() - 10)
							e:SetPoint("LEFT", ID.title, "RIGHT", 10, 0)
							e:SetPoint("RIGHT", ID, -10, 0)
							e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
							e:SetTextColor(0.0, 0.5, 0.5, 1)

							e.texture = e:CreateTexture(nil, "BACKGROUND")
							e.texture:SetTexture(0, 0, 0, 1)
							e.texture:SetAllPoints()

							e:SetMultiLine(true)
							e:SetMaxLetters(100)
							e:SetAutoFocus(false)

							do -- Scripts
								e:SetScript("OnEscapePressed", function(self)
									e:ClearFocus()
								end)

								e:SetScript("OnEnterPressed", function(self)
									e:ClearFocus()
								end)

								-- e:SetScript("OnEditFocusGained", function(self)
								--   self:HighlightText()
								-- end)

								e:SetScript("OnEditFocusLost", function(self)
									local string = self:GetText():trim()

									dropDown.input.spellID = nil
									dropDown.input.spellName = nil

									if string ~= "" then
										local num = string:match("(%d+)")
										local num = tonumber(num)

										if num then
											local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(num)

											if spellID then
												dropDown.currentSpell.title:SetText("Current spell: |cFF00CCFF" .. spellName .. "|r")
												dropDown.currentSpell.icon:SetTexture(icon)

												dropDown.input.spellID = spellID
												dropDown.input.spellName = spellName
											else
												dropDown.currentSpell.title:SetText("Current spell: |cFF9E5A01Invalid ID|r.")
												dropDown.currentSpell.icon:SetTexture(nil)
											end
										else
											dropDown.currentSpell.title:SetText("Enter a spellID in the edit box.")
											dropDown.currentSpell.icon:SetTexture(nil)
										end
									end

									addListEntry(dropDown.input)
								end)
							end

							ID.editBox = e
							dropDown.ID = ID
						end

						local currentSpell = dropDown.currentSpell
						if not currentSpell then
							currentSpell = CreateFrame("Frame", nil, dropDown)

							currentSpell:SetSize(80, 30)
							currentSpell:SetPoint("TOPRIGHT", ID, "BOTTOMRIGHT", 0, -3)
							currentSpell:SetPoint("TOPLEFT", ID, "BOTTOMLEFT", 0, -3)

							currentSpell.background = currentSpell:CreateTexture(nil, "BACKGROUND")
							currentSpell.background:SetAllPoints()
							currentSpell.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local icon = currentSpell.icon
							if not icon then -- Create Icon
								local iconHeight = currentSpell:GetHeight() - 10

								icon = currentSpell:CreateTexture(nil, "OVERLAY")
								icon:SetSize(iconHeight, iconHeight)
								icon:SetPoint("RIGHT", -10, 0)
								icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
								icon:SetAlpha(0.9)

								currentSpell.icon = icon
							end

							local title = currentSpell.title
							if not title then
								title = currentSpell:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Current spell:")

								currentSpell.title = title
							end

							dropDown.currentSpell = currentSpell
						end

						local index = dropDown.index
						if not index then
							index = CreateFrame("Frame", nil, dropDown)

							index:SetSize(80, 30)
							index:SetPoint("TOPRIGHT", currentSpell, "BOTTOMRIGHT", 0, -3)
							index:SetPoint("TOPLEFT", currentSpell, "BOTTOMLEFT", 0, -3)

							index.background = index:CreateTexture(nil, "BACKGROUND")
							index.background:SetAllPoints()
							index.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = index.title
							if not title then
								title = index:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Index: ")

								index.title = title
							end

							local e = index.editBox
							if not e then
								e = CreateFrame("EditBox", nil, index)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", index, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.index = nil

										if string ~= "" then
											local num = string:match("%d+")
											local num = tonumber(num)

											if num then
												if num > NUMBER_OF_ICONS then
													num = NUMBER_OF_ICONS
													self:SetText(NUMBER_OF_ICONS)
												end

												dropDown.input.index = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								index.editBox = e
							end

							dropDown.index = index
						end

						local line = dropDown.line
						if not line then
							line = CreateFrame("Frame", nil, dropDown)

							line:SetSize(80, 60)
							line:SetPoint("TOPRIGHT", index, "BOTTOMRIGHT", 0, -3)
							line:SetPoint("TOPLEFT", index, "BOTTOMLEFT", 0, -3)

							line.background = line:CreateTexture(nil, "BACKGROUND")
							line.background:SetAllPoints()
							line.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = line.title
							if not title then
								title = line:CreateFontString(nil, "ARTWORK")
								title:SetPoint("TOPLEFT", 2, -10)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Vertical line: (Yes/No)")

								line.title = title
							end

							local e = line.editBox1
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.line = nil

										if string ~= "" then
											if string:match("yes") or string:match("y") then
												debug(string, "Matched yes")
												dropDown.input.line = true
											elseif string:match("no") or string:match("n") or string:match("nil") then
												debug(string, "Matched no")
											else
												debug(string, "Didn't match either")
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox1 = e
							end

							local lineHeight = line.lineHeight
							if not lineHeight then
								lineHeight = line:CreateFontString(nil, "ARTWORK")
								lineHeight:SetPoint("BOTTOMLEFT", 2, 8)
								lineHeight:SetFont("Fonts\\FRIZQT__.TTF", 15)
								lineHeight:SetTextColor(1, 1, 1, 1)
								lineHeight:SetText("Line height:")

								line.lineHeight = lineHeight
							end

							local e = line.editBox2
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", lineHeight, 0, 5)
								e:SetPoint("BOTTOM", lineHeight, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():trim()

										dropDown.input.lineHeight = nil

										if string ~= "" then
											local num = string:match("(%d+)")
											local num = tonumber(num)

											if num then
												dropDown.input.lineHeight = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox2 = e
							end

							dropDown.line = line
						end

						height = height + ID:GetHeight() + 3
						height = height + currentSpell:GetHeight() + 3
						height = height + index:GetHeight() + 3
						height = height + line:GetHeight() + 3

						dropDown:SetHeight(height + 3)
						expander:SetHeight(dropDown:GetHeight() + self:GetHeight())
					end
				end
			elseif category == "debuff" then
				if not scroll.debuff then
					function scroll:debuff()
						local height = 0
						local dropDown = self.dropDown
						local expander = self.expander

						if not dropDown.input then
							dropDown.input = {}
						end

						dropDown.input.category = category

						local ID = dropDown.ID
						if not ID then
							ID = CreateFrame("Frame", nil, dropDown)

							ID:SetSize(80, 30)
							ID:SetPoint("TOPRIGHT", -3, -3)
							ID:SetPoint("TOPLEFT", 3, -3)

							ID.background = ID:CreateTexture(nil, "BACKGROUND")
							ID.background:SetAllPoints()
							ID.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							ID.title = ID:CreateFontString(nil, "ARTWORK")
							ID.title:SetPoint("LEFT", 2, 0)
							ID.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
							ID.title:SetTextColor(1, 1, 1, 1)
							ID.title:SetText("Enter a spellID:")

							local e = CreateFrame("EditBox", nil, ID)
							-- e:SetSize(100, ID:GetHeight() - 10)
							e:SetPoint("LEFT", ID.title, "RIGHT", 10, 0)
							e:SetPoint("RIGHT", ID, -10, 0)
							e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
							e:SetTextColor(0.0, 0.5, 0.5, 1)

							e.texture = e:CreateTexture(nil, "BACKGROUND")
							e.texture:SetTexture(0, 0, 0, 1)
							e.texture:SetAllPoints()

							e:SetMultiLine(true)
							e:SetMaxLetters(100)
							e:SetAutoFocus(false)

							do -- Scripts
								e:SetScript("OnEscapePressed", function(self)
									e:ClearFocus()
								end)

								e:SetScript("OnEnterPressed", function(self)
									e:ClearFocus()
								end)

								-- e:SetScript("OnEditFocusGained", function(self)
								--   self:HighlightText()
								-- end)

								e:SetScript("OnEditFocusLost", function(self)
									local string = self:GetText():trim()

									dropDown.input.spellID = nil
									dropDown.input.spellName = nil

									if string ~= "" then
										local num = string:match("(%d+)")
										local num = tonumber(num)

										if num then
											local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(num)

											if spellID then
												dropDown.currentSpell.title:SetText("Current spell: |cFF00CCFF" .. spellName .. "|r")
												dropDown.currentSpell.icon:SetTexture(icon)

												dropDown.input.spellID = spellID
												dropDown.input.spellName = spellName
											else
												dropDown.currentSpell.title:SetText("Current spell: |cFF9E5A01Invalid ID|r.")
												dropDown.currentSpell.icon:SetTexture(nil)
											end
										else
											dropDown.currentSpell.title:SetText("Enter a spellID in the edit box.")
											dropDown.currentSpell.icon:SetTexture(nil)
										end
									end

									addListEntry(dropDown.input)
								end)
							end

							ID.editBox = e
							dropDown.ID = ID
						end

						local currentSpell = dropDown.currentSpell
						if not currentSpell then
							currentSpell = CreateFrame("Frame", nil, dropDown)

							currentSpell:SetSize(80, 30)
							currentSpell:SetPoint("TOPRIGHT", ID, "BOTTOMRIGHT", 0, -3)
							currentSpell:SetPoint("TOPLEFT", ID, "BOTTOMLEFT", 0, -3)

							currentSpell.background = currentSpell:CreateTexture(nil, "BACKGROUND")
							currentSpell.background:SetAllPoints()
							currentSpell.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local icon = currentSpell.icon
							if not icon then -- Create Icon
								local iconHeight = currentSpell:GetHeight() - 10

								icon = currentSpell:CreateTexture(nil, "OVERLAY")
								icon:SetSize(iconHeight, iconHeight)
								icon:SetPoint("RIGHT", -10, 0)
								icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
								icon:SetAlpha(0.9)

								currentSpell.icon = icon
							end

							local title = currentSpell.title
							if not title then
								title = currentSpell:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Current spell:")

								currentSpell.title = title
							end

							dropDown.currentSpell = currentSpell
						end

						local index = dropDown.index
						if not index then
							index = CreateFrame("Frame", nil, dropDown)

							index:SetSize(80, 30)
							index:SetPoint("TOPRIGHT", currentSpell, "BOTTOMRIGHT", 0, -3)
							index:SetPoint("TOPLEFT", currentSpell, "BOTTOMLEFT", 0, -3)

							index.background = index:CreateTexture(nil, "BACKGROUND")
							index.background:SetAllPoints()
							index.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = index.title
							if not title then
								title = index:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Index: ")

								index.title = title
							end

							local e = index.editBox
							if not e then
								e = CreateFrame("EditBox", nil, index)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", index, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.index = nil

										if string ~= "" then
											local num = string:match("%d+")
											local num = tonumber(num)

											if num then
												if num > NUMBER_OF_ICONS then
													num = NUMBER_OF_ICONS
													self:SetText(NUMBER_OF_ICONS)
												end

												dropDown.input.index = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								index.editBox = e
							end

							dropDown.index = index
						end

						local line = dropDown.line
						if not line then
							line = CreateFrame("Frame", nil, dropDown)

							line:SetSize(80, 60)
							line:SetPoint("TOPRIGHT", index, "BOTTOMRIGHT", 0, -3)
							line:SetPoint("TOPLEFT", index, "BOTTOMLEFT", 0, -3)

							line.background = line:CreateTexture(nil, "BACKGROUND")
							line.background:SetAllPoints()
							line.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = line.title
							if not title then
								title = line:CreateFontString(nil, "ARTWORK")
								title:SetPoint("TOPLEFT", 2, -10)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Vertical line: (Yes/No)")

								line.title = title
							end

							local e = line.editBox1
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.line = nil

										if string ~= "" then
											if string:match("yes") or string:match("y") then
												debug(string, "Matched yes")
												dropDown.input.line = true
											elseif string:match("no") or string:match("n") or string:match("nil") then
												debug(string, "Matched no")
											else
												debug(string, "Didn't match either")
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox1 = e
							end

							local lineHeight = line.lineHeight
							if not lineHeight then
								lineHeight = line:CreateFontString(nil, "ARTWORK")
								lineHeight:SetPoint("BOTTOMLEFT", 2, 8)
								lineHeight:SetFont("Fonts\\FRIZQT__.TTF", 15)
								lineHeight:SetTextColor(1, 1, 1, 1)
								lineHeight:SetText("Line height:")

								line.lineHeight = lineHeight
							end

							local e = line.editBox2
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", lineHeight, 0, 5)
								e:SetPoint("BOTTOM", lineHeight, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():trim()

										dropDown.input.lineHeight = nil

										if string ~= "" then
											local num = string:match("(%d+)")
											local num = tonumber(num)

											if num then
												dropDown.input.lineHeight = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox2 = e
							end

							dropDown.line = line
						end

						height = height + ID:GetHeight() + 3
						height = height + currentSpell:GetHeight() + 3
						height = height + index:GetHeight() + 3
						height = height + line:GetHeight() + 3

						dropDown:SetHeight(height + 3)
						expander:SetHeight(dropDown:GetHeight() + self:GetHeight())
					end
				end
			elseif category == "activity" then
				if not scroll.activity then
					function scroll:activity()
						local height = 0
						local dropDown = self.dropDown
						local expander = self.expander

						if not dropDown.input then
							dropDown.input = {}
						end

						dropDown.input.category = category

						local ID = dropDown.ID
						if not ID then
							ID = CreateFrame("Frame", nil, dropDown)

							ID:SetSize(80, 30)
							ID:SetPoint("TOPRIGHT", -3, -3)
							ID:SetPoint("TOPLEFT", 3, -3)

							ID.background = ID:CreateTexture(nil, "BACKGROUND")
							ID.background:SetAllPoints()
							ID.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							ID.title = ID:CreateFontString(nil, "ARTWORK")
							ID.title:SetPoint("LEFT", 2, 0)
							ID.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
							ID.title:SetTextColor(1, 1, 1, 1)
							ID.title:SetText("Enter a spellID:")

							local e = CreateFrame("EditBox", nil, ID)
							-- e:SetSize(100, ID:GetHeight() - 10)
							e:SetPoint("LEFT", ID.title, "RIGHT", 10, 0)
							e:SetPoint("RIGHT", ID, -10, 0)
							e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
							e:SetTextColor(0.0, 0.5, 0.5, 1)

							e.texture = e:CreateTexture(nil, "BACKGROUND")
							e.texture:SetTexture(0, 0, 0, 1)
							e.texture:SetAllPoints()

							e:SetMultiLine(true)
							e:SetMaxLetters(100)
							e:SetAutoFocus(false)

							do -- Scripts
								e:SetScript("OnEscapePressed", function(self)
									e:ClearFocus()
								end)

								e:SetScript("OnEnterPressed", function(self)
									e:ClearFocus()
								end)

								-- e:SetScript("OnEditFocusGained", function(self)
								--   self:HighlightText()
								-- end)

								e:SetScript("OnEditFocusLost", function(self)
									local string = self:GetText():trim()

									dropDown.input.spellID = nil
									dropDown.input.spellName = nil

									if string ~= "" then
										local num = string:match("(%d+)")
										local num = tonumber(num)

										if num then
											local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(num)

											if spellID then
												dropDown.currentSpell.title:SetText("Current spell: |cFF00CCFF" .. spellName .. "|r")
												dropDown.currentSpell.icon:SetTexture(icon)

												dropDown.input.spellID = spellID
												dropDown.input.spellName = spellName
											else
												dropDown.currentSpell.title:SetText("Current spell: |cFF9E5A01Invalid ID|r.")
												dropDown.currentSpell.icon:SetTexture(nil)
											end
										else
											dropDown.currentSpell.title:SetText("Enter a spellID in the edit box.")
											dropDown.currentSpell.icon:SetTexture(nil)
										end
									end

									addListEntry(dropDown.input)
								end)
							end

							ID.editBox = e
							dropDown.ID = ID
						end

						local currentSpell = dropDown.currentSpell
						if not currentSpell then
							currentSpell = CreateFrame("Frame", nil, dropDown)

							currentSpell:SetSize(80, 30)
							currentSpell:SetPoint("TOPRIGHT", ID, "BOTTOMRIGHT", 0, -3)
							currentSpell:SetPoint("TOPLEFT", ID, "BOTTOMLEFT", 0, -3)

							currentSpell.background = currentSpell:CreateTexture(nil, "BACKGROUND")
							currentSpell.background:SetAllPoints()
							currentSpell.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local icon = currentSpell.icon
							if not icon then -- Create Icon
								local iconHeight = currentSpell:GetHeight() - 10

								icon = currentSpell:CreateTexture(nil, "OVERLAY")
								icon:SetSize(iconHeight, iconHeight)
								icon:SetPoint("RIGHT", -10, 0)
								icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
								icon:SetAlpha(0.9)

								currentSpell.icon = icon
							end

							local title = currentSpell.title
							if not title then
								title = currentSpell:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Current spell:")

								currentSpell.title = title
							end

							dropDown.currentSpell = currentSpell
						end

						local index = dropDown.index
						if not index then
							index = CreateFrame("Frame", nil, dropDown)

							index:SetSize(80, 30)
							index:SetPoint("TOPRIGHT", currentSpell, "BOTTOMRIGHT", 0, -3)
							index:SetPoint("TOPLEFT", currentSpell, "BOTTOMLEFT", 0, -3)

							index.background = index:CreateTexture(nil, "BACKGROUND")
							index.background:SetAllPoints()
							index.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = index.title
							if not title then
								title = index:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Index: ")

								index.title = title
							end

							local e = index.editBox
							if not e then
								e = CreateFrame("EditBox", nil, index)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", index, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.index = nil

										if string ~= "" then
											local num = string:match("%d+")
											local num = tonumber(num)

											if num then
												if num > NUMBER_OF_ICONS then
													num = NUMBER_OF_ICONS
													self:SetText(NUMBER_OF_ICONS)
												end

												dropDown.input.index = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								index.editBox = e
							end

							dropDown.index = index
						end

						local line = dropDown.line
						if not line then
							line = CreateFrame("Frame", nil, dropDown)

							line:SetSize(80, 60)
							line:SetPoint("TOPRIGHT", index, "BOTTOMRIGHT", 0, -3)
							line:SetPoint("TOPLEFT", index, "BOTTOMLEFT", 0, -3)

							line.background = line:CreateTexture(nil, "BACKGROUND")
							line.background:SetAllPoints()
							line.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = line.title
							if not title then
								title = line:CreateFontString(nil, "ARTWORK")
								title:SetPoint("TOPLEFT", 2, -10)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Vertical line: (Yes/No)")

								line.title = title
							end

							local e = line.editBox1
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.line = nil

										if string ~= "" then
											if string:match("yes") or string:match("y") then
												debug(string, "Matched yes")
												dropDown.input.line = true
											elseif string:match("no") or string:match("n") or string:match("nil") then
												debug(string, "Matched no")
											else
												debug(string, "Didn't match either")
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox1 = e
							end

							local lineHeight = line.lineHeight
							if not lineHeight then
								lineHeight = line:CreateFontString(nil, "ARTWORK")
								lineHeight:SetPoint("BOTTOMLEFT", 2, 8)
								lineHeight:SetFont("Fonts\\FRIZQT__.TTF", 15)
								lineHeight:SetTextColor(1, 1, 1, 1)
								lineHeight:SetText("Line height:")

								line.lineHeight = lineHeight
							end

							local e = line.editBox2
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", lineHeight, 0, 5)
								e:SetPoint("BOTTOM", lineHeight, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():trim()

										dropDown.input.lineHeight = nil

										if string ~= "" then
											local num = string:match("(%d+)")
											local num = tonumber(num)

											if num then
												dropDown.input.lineHeight = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox2 = e
							end

							dropDown.line = line
						end

						height = height + ID:GetHeight() + 3
						height = height + currentSpell:GetHeight() + 3
						height = height + index:GetHeight() + 3
						height = height + line:GetHeight() + 3

						dropDown:SetHeight(height + 3)
						expander:SetHeight(dropDown:GetHeight() + self:GetHeight())
					end
				end
			elseif category == "inactivity" then
				if not scroll.inactivity then
					function scroll:inactivity()
						local height = 0
						local dropDown = self.dropDown
						local expander = self.expander

						if not dropDown.input then
							dropDown.input = {}
						end

						dropDown.input.category = category

						local ID = dropDown.ID
						if not ID then
							ID = CreateFrame("Frame", nil, dropDown)

							ID:SetSize(80, 30)
							ID:SetPoint("TOPRIGHT", -3, -3)
							ID:SetPoint("TOPLEFT", 3, -3)

							ID.background = ID:CreateTexture(nil, "BACKGROUND")
							ID.background:SetAllPoints()
							ID.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							ID.title = ID:CreateFontString(nil, "ARTWORK")
							ID.title:SetPoint("LEFT", 2, 0)
							ID.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
							ID.title:SetTextColor(1, 1, 1, 1)
							ID.title:SetText("Enter a spellID:")

							local e = CreateFrame("EditBox", nil, ID)
							-- e:SetSize(100, ID:GetHeight() - 10)
							e:SetPoint("LEFT", ID.title, "RIGHT", 10, 0)
							e:SetPoint("RIGHT", ID, -10, 0)
							e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
							e:SetTextColor(0.0, 0.5, 0.5, 1)

							e.texture = e:CreateTexture(nil, "BACKGROUND")
							e.texture:SetTexture(0, 0, 0, 1)
							e.texture:SetAllPoints()

							e:SetMultiLine(true)
							e:SetMaxLetters(100)
							e:SetAutoFocus(false)

							do -- Scripts
								e:SetScript("OnEscapePressed", function(self)
									e:ClearFocus()
								end)

								e:SetScript("OnEnterPressed", function(self)
									e:ClearFocus()
								end)

								-- e:SetScript("OnEditFocusGained", function(self)
								--   self:HighlightText()
								-- end)

								e:SetScript("OnEditFocusLost", function(self)
									local string = self:GetText():trim()

									dropDown.input.spellID = nil
									dropDown.input.spellName = nil

									if string ~= "" then
										local num = string:match("(%d+)")
										local num = tonumber(num)

										if num then
											local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(num)

											if spellID then
												dropDown.currentSpell.title:SetText("Current spell: |cFF00CCFF" .. spellName .. "|r")
												dropDown.currentSpell.icon:SetTexture(icon)

												dropDown.input.spellID = spellID
												dropDown.input.spellName = spellName
											else
												dropDown.currentSpell.title:SetText("Current spell: |cFF9E5A01Invalid ID|r.")
												dropDown.currentSpell.icon:SetTexture(nil)
											end
										else
											dropDown.currentSpell.title:SetText("Enter a spellID in the edit box.")
											dropDown.currentSpell.icon:SetTexture(nil)
										end
									end

									addListEntry(dropDown.input)
								end)
							end

							ID.editBox = e
							dropDown.ID = ID
						end

						local currentSpell = dropDown.currentSpell
						if not currentSpell then
							currentSpell = CreateFrame("Frame", nil, dropDown)

							currentSpell:SetSize(80, 30)
							currentSpell:SetPoint("TOPRIGHT", ID, "BOTTOMRIGHT", 0, -3)
							currentSpell:SetPoint("TOPLEFT", ID, "BOTTOMLEFT", 0, -3)

							currentSpell.background = currentSpell:CreateTexture(nil, "BACKGROUND")
							currentSpell.background:SetAllPoints()
							currentSpell.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local icon = currentSpell.icon
							if not icon then -- Create Icon
								local iconHeight = currentSpell:GetHeight() - 10

								icon = currentSpell:CreateTexture(nil, "OVERLAY")
								icon:SetSize(iconHeight, iconHeight)
								icon:SetPoint("RIGHT", -10, 0)
								icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
								icon:SetAlpha(0.9)

								currentSpell.icon = icon
							end

							local title = currentSpell.title
							if not title then
								title = currentSpell:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Current spell:")

								currentSpell.title = title
							end

							dropDown.currentSpell = currentSpell
						end

						local index = dropDown.index
						if not index then
							index = CreateFrame("Frame", nil, dropDown)

							index:SetSize(80, 30)
							index:SetPoint("TOPRIGHT", currentSpell, "BOTTOMRIGHT", 0, -3)
							index:SetPoint("TOPLEFT", currentSpell, "BOTTOMLEFT", 0, -3)

							index.background = index:CreateTexture(nil, "BACKGROUND")
							index.background:SetAllPoints()
							index.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = index.title
							if not title then
								title = index:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Index: ")

								index.title = title
							end

							local e = index.editBox
							if not e then
								e = CreateFrame("EditBox", nil, index)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", index, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.index = nil

										if string ~= "" then
											local num = string:match("%d+")
											local num = tonumber(num)

											if num then
												if num > NUMBER_OF_ICONS then
													num = NUMBER_OF_ICONS
													self:SetText(NUMBER_OF_ICONS)
												end

												dropDown.input.index = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								index.editBox = e
							end

							dropDown.index = index
						end

						local line = dropDown.line
						if not line then
							line = CreateFrame("Frame", nil, dropDown)

							line:SetSize(80, 60)
							line:SetPoint("TOPRIGHT", index, "BOTTOMRIGHT", 0, -3)
							line:SetPoint("TOPLEFT", index, "BOTTOMLEFT", 0, -3)

							line.background = line:CreateTexture(nil, "BACKGROUND")
							line.background:SetAllPoints()
							line.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = line.title
							if not title then
								title = line:CreateFontString(nil, "ARTWORK")
								title:SetPoint("TOPLEFT", 2, -10)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Vertical line: (Yes/No)")

								line.title = title
							end

							local e = line.editBox1
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.line = nil

										if string ~= "" then
											if string:match("yes") or string:match("y") then
												debug(string, "Matched yes")
												dropDown.input.line = true
											elseif string:match("no") or string:match("n") or string:match("nil") then
												debug(string, "Matched no")
											else
												debug(string, "Didn't match either")
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox1 = e
							end

							local lineHeight = line.lineHeight
							if not lineHeight then
								lineHeight = line:CreateFontString(nil, "ARTWORK")
								lineHeight:SetPoint("BOTTOMLEFT", 2, 8)
								lineHeight:SetFont("Fonts\\FRIZQT__.TTF", 15)
								lineHeight:SetTextColor(1, 1, 1, 1)
								lineHeight:SetText("Line height:")

								line.lineHeight = lineHeight
							end

							local e = line.editBox2
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", lineHeight, 0, 5)
								e:SetPoint("BOTTOM", lineHeight, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():trim()

										dropDown.input.lineHeight = nil

										if string ~= "" then
											local num = string:match("(%d+)")
											local num = tonumber(num)

											if num then
												dropDown.input.lineHeight = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox2 = e
							end

							dropDown.line = line
						end

						height = height + ID:GetHeight() + 3
						height = height + currentSpell:GetHeight() + 3
						height = height + index:GetHeight() + 3
						height = height + line:GetHeight() + 3

						dropDown:SetHeight(height + 3)
						expander:SetHeight(dropDown:GetHeight() + self:GetHeight())
					end
				end
			elseif category == "rune" then
				if not scroll.rune then
					function scroll:rune()
						local height = 0
						local dropDown = self.dropDown
						local expander = self.expander

						if not dropDown.input then
							dropDown.input = {}
						end

						dropDown.input.category = category

						local ID = dropDown.ID
						if not ID then
							ID = CreateFrame("Frame", nil, dropDown)

							ID:SetSize(80, 30)
							ID:SetPoint("TOPRIGHT", -3, -3)
							ID:SetPoint("TOPLEFT", 3, -3)

							ID.background = ID:CreateTexture(nil, "BACKGROUND")
							ID.background:SetAllPoints()
							ID.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							ID.title = ID:CreateFontString(nil, "ARTWORK")
							ID.title:SetPoint("LEFT", 2, 0)
							ID.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
							ID.title:SetTextColor(1, 1, 1, 1)
							ID.title:SetText("Enter a spellID:")

							local e = CreateFrame("EditBox", nil, ID)
							-- e:SetSize(100, ID:GetHeight() - 10)
							e:SetPoint("LEFT", ID.title, "RIGHT", 10, 0)
							e:SetPoint("RIGHT", ID, -10, 0)
							e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
							e:SetTextColor(0.0, 0.5, 0.5, 1)

							e.texture = e:CreateTexture(nil, "BACKGROUND")
							e.texture:SetTexture(0, 0, 0, 1)
							e.texture:SetAllPoints()

							e:SetMultiLine(true)
							e:SetMaxLetters(100)
							e:SetAutoFocus(false)

							do -- Scripts
								e:SetScript("OnEscapePressed", function(self)
									e:ClearFocus()
								end)

								e:SetScript("OnEnterPressed", function(self)
									e:ClearFocus()
								end)

								-- e:SetScript("OnEditFocusGained", function(self)
								--   self:HighlightText()
								-- end)

								e:SetScript("OnEditFocusLost", function(self)
									local string = self:GetText():trim()

									dropDown.input.spellID = nil
									dropDown.input.spellName = nil

									if string ~= "" then
										local num = string:match("(%d+)")
										local num = tonumber(num)

										if num then
											local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(num)

											if spellID then
												dropDown.currentSpell.title:SetText("Current spell: |cFF00CCFF" .. spellName .. "|r")
												dropDown.currentSpell.icon:SetTexture(icon)

												dropDown.input.spellID = spellID
												dropDown.input.spellName = spellName
											else
												dropDown.currentSpell.title:SetText("Current spell: |cFF9E5A01Invalid ID|r.")
												dropDown.currentSpell.icon:SetTexture(nil)
											end
										else
											dropDown.currentSpell.title:SetText("Enter a spellID in the edit box.")
											dropDown.currentSpell.icon:SetTexture(nil)
										end
									end

									addListEntry(dropDown.input)
								end)
							end

							ID.editBox = e
							dropDown.ID = ID
						end

						local currentSpell = dropDown.currentSpell
						if not currentSpell then
							currentSpell = CreateFrame("Frame", nil, dropDown)

							currentSpell:SetSize(80, 30)
							currentSpell:SetPoint("TOPRIGHT", ID, "BOTTOMRIGHT", 0, -3)
							currentSpell:SetPoint("TOPLEFT", ID, "BOTTOMLEFT", 0, -3)

							currentSpell.background = currentSpell:CreateTexture(nil, "BACKGROUND")
							currentSpell.background:SetAllPoints()
							currentSpell.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local icon = currentSpell.icon
							if not icon then -- Create Icon
								local iconHeight = currentSpell:GetHeight() - 10

								icon = currentSpell:CreateTexture(nil, "OVERLAY")
								icon:SetSize(iconHeight, iconHeight)
								icon:SetPoint("RIGHT", -10, 0)
								icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
								icon:SetAlpha(0.9)

								currentSpell.icon = icon
							end

							local title = currentSpell.title
							if not title then
								title = currentSpell:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Current spell:")

								currentSpell.title = title
							end

							dropDown.currentSpell = currentSpell
						end

						local index = dropDown.index
						if not index then
							index = CreateFrame("Frame", nil, dropDown)

							index:SetSize(80, 30)
							index:SetPoint("TOPRIGHT", currentSpell, "BOTTOMRIGHT", 0, -3)
							index:SetPoint("TOPLEFT", currentSpell, "BOTTOMLEFT", 0, -3)

							index.background = index:CreateTexture(nil, "BACKGROUND")
							index.background:SetAllPoints()
							index.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = index.title
							if not title then
								title = index:CreateFontString(nil, "ARTWORK")
								title:SetPoint("LEFT", 2, 0)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Index: ")

								index.title = title
							end

							local e = index.editBox
							if not e then
								e = CreateFrame("EditBox", nil, index)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", index, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.index = nil

										if string ~= "" then
											local num = string:match("%d+")
											local num = tonumber(num)

											if num then
												if num > NUMBER_OF_ICONS then
													num = NUMBER_OF_ICONS
													self:SetText(NUMBER_OF_ICONS)
												end

												dropDown.input.index = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								index.editBox = e
							end

							dropDown.index = index
						end

						local line = dropDown.line
						if not line then
							line = CreateFrame("Frame", nil, dropDown)

							line:SetSize(80, 60)
							line:SetPoint("TOPRIGHT", index, "BOTTOMRIGHT", 0, -3)
							line:SetPoint("TOPLEFT", index, "BOTTOMLEFT", 0, -3)

							line.background = line:CreateTexture(nil, "BACKGROUND")
							line.background:SetAllPoints()
							line.background:SetTexture(0.7, 0.7, 0.7, 0.1)

							local title = line.title
							if not title then
								title = line:CreateFontString(nil, "ARTWORK")
								title:SetPoint("TOPLEFT", 2, -10)
								title:SetFont("Fonts\\FRIZQT__.TTF", 15)
								title:SetTextColor(1, 1, 1, 1)
								title:SetText("Vertical line: (Yes/No)")

								line.title = title
							end

							local e = line.editBox1
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", title, 0, 5)
								e:SetPoint("BOTTOM", title, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():lower():trim()

										dropDown.input.line = nil

										if string ~= "" then
											if string:match("yes") or string:match("y") then
												debug(string, "Matched yes")
												dropDown.input.line = true
											elseif string:match("no") or string:match("n") or string:match("nil") then
												debug(string, "Matched no")
											else
												debug(string, "Didn't match either")
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox1 = e
							end

							local lineHeight = line.lineHeight
							if not lineHeight then
								lineHeight = line:CreateFontString(nil, "ARTWORK")
								lineHeight:SetPoint("BOTTOMLEFT", 2, 8)
								lineHeight:SetFont("Fonts\\FRIZQT__.TTF", 15)
								lineHeight:SetTextColor(1, 1, 1, 1)
								lineHeight:SetText("Line height:")

								line.lineHeight = lineHeight
							end

							local e = line.editBox2
							if not e then
								e = CreateFrame("EditBox", nil, line)
								e:SetSize(100, 100)
								e:SetPoint("TOP", lineHeight, 0, 5)
								e:SetPoint("BOTTOM", lineHeight, 0, -5)
								e:SetPoint("RIGHT", line, -10, 0)
								e:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
								e:SetTextColor(0.0, 0.5, 0.5, 1)

								e.texture = e:CreateTexture(nil, "BACKGROUND")
								e.texture:SetTexture(0, 0, 0, 1)
								e.texture:SetAllPoints()

								e:SetMultiLine(true)
								e:SetMaxLetters(100)
								e:SetAutoFocus(false)

								do -- Scripts
									e:SetScript("OnEscapePressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEnterPressed", function(self)
										e:ClearFocus()
									end)

									e:SetScript("OnEditFocusLost", function(self)
										local string = self:GetText():trim()

										dropDown.input.lineHeight = nil

										if string ~= "" then
											local num = string:match("(%d+)")
											local num = tonumber(num)

											if num then
												dropDown.input.lineHeight = num
											else
												self:SetText(nil)
											end
										end

										addListEntry(dropDown.input)
									end)
								end

								line.editBox2 = e
							end

							dropDown.line = line
						end

						height = height + ID:GetHeight() + 3
						height = height + currentSpell:GetHeight() + 3
						height = height + index:GetHeight() + 3
						height = height + line:GetHeight() + 3

						dropDown:SetHeight(height + 3)
						expander:SetHeight(dropDown:GetHeight() + self:GetHeight())
					end
				end
			else
				debug("No option category for:", category)
			end
		end

		TL.createMainOptionButtons(scroll)
		scroll:setButtonAnchors()
	end

	tinsert(UISpecialFrames, TL.options:GetName())
end
--------------------------------------------------------------------------------
-- Slash command stuff
--------------------------------------------------------------------------------
SLASH_Timeline1 = "/tl"
function SlashCmdList.Timeline(msg, editbox)
	local direction, offSet = msg:match("([xXyY])([+-]?%d+)")
	if direction then direction = direction:lower() end
	-- local command, rest = msg:match("^(%S*)%s*(.-)$"):lower()
	local command = msg:match("^(%S*)"):lower()
	local rest = (msg or ""):match("^%S* (.+)$")
  if rest then rest = rest:lower() end

	debug(msg, command, rest)

	if command == "toggle" or command == "" then
		if not TL.options then TL.createOptionsFrame() end

		if TL.options:IsVisible() then
			TL.options:Hide()
		else
			TL.options:Show()
		end
	elseif command == "show" then
		TL.options:Show()
	elseif command == "hide" then
		TL.options:Hide()
	elseif command == "delete" then
		if TL.charDB then
			if rest == "all" then
				for k, v in pairs(TL.charDB) do
					v = nil
				end

				debug("Deleting all saved list entries.")
			else
				local num = tonumber(rest)

				if num and TL.charDB[num] then
					TL.charDB[num] = nil
					debug("Successfully deleted list entry:", num)
				end
			end
		end
	elseif command == "reset" then
		TL:ClearAllPoints()
		TL:SetPoint("CENTER", "UIParent", 0, 0)
		print("Position reset.")
	elseif command == "cmd" or command == "commands" or command == "options" then
		print("TL COMMANDS:\ntoggle - Toggles Show/Hide.\nshow - Shows Timeline.\nhide - Hides Timeline.\nreset - Moves Timeline frame to the center.\nxNUMBER - Adjusts X axis by number\nyNUMBER - Adjusts Y axis by number")
	elseif direction == "x" and offSet then
		local p1, p2, p3, p4, p5 = TL:GetPoint()
		TL:ClearAllPoints()
		TL:SetPoint(p1, p2, p3, p4 + tonumber(offSet), p5)
	elseif direction == "y" and offSet then
		local p1, p2, p3, p4, p5 = TL:GetPoint()
		TL:ClearAllPoints()
		TL:SetPoint(p1, p2, p3, p4, p5 + tonumber(offSet))
	end
end

local function COOLDOWN_UPDATE_BACKUP()
  local icon = spell.icon[1]
  local offset = 0

  local charges, chargeMax, start, duration = GetSpellCharges(spellID)

  if not charges then
    start, duration = GetSpellCooldown(spellID)
  else
    if (chargeMax - 1) == charges then -- Missing one charge
      icon = spell.icon[1]
    else
      offset = ICON_HEIGHT
      icon = spell.icon[2]
    end
  end

  local remaining = (start + duration) - GetTime()

  local frameWidth = TL:GetWidth()
  local x = (frameWidth * duration) / TOTAL_TIME
  local edge = UIParent:GetRight() - TL.line:GetRight()
  if x > edge then x = edge end

  icon:SetPoint("RIGHT", TL.line, x + offset, 0)

  if icon.active then -- If the current icon is active, switch to the other one
    if icon == spell.icon[1] then
      icon = spell.icon[2]
    elseif icon == spell.icon[2] then
      icon = spell.icon[1]
    end
  end

  if not spell.ticker then
    spell.ticker = newTicker(0.001, function(ticker)
      local remaining = (start + duration) - GetTime()
      local x = ((frameWidth * remaining) / TOTAL_TIME)
      icon.remaining = remaining
      icon.active = true

      if remaining <= 0 then
        charges, chargeMax, start, duration = GetSpellCharges(spellID)

        if chargeMax > charges then
          if icon == spell.icon[1] then
            icon = spell.icon[2]
            offset = ICON_HEIGHT
          elseif icon == spell.icon[2] then
            icon = spell.icon[1]
          end

          if (chargeMax - 1) == charges then -- Missing one charge
            offset = 0
          else
            offset = ICON_HEIGHT
          end

          remaining = (start + duration) - GetTime()
          x = ((frameWidth * remaining) / TOTAL_TIME)

          debug("Extending ticker and switching icon")
        else
          debug("Stopping ticker")

          if icon.line then icon.line:Hide() end
          if icon.text then icon.text:Hide() end

          ticker:Cancel()
          spell.ticker = nil
          icon.remaining = nil
          icon.active = false
        end
      end

      if x > edge then x = edge end -- Icon is off screen, adjust it

      icon:SetPoint("RIGHT", TL.line, x + offset, 0)
    end)
  end
end
