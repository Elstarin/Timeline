local Timeline = CreateFrame("Frame", "Timeline", UIParent)
local TL = Timeline

local optionsFrame = CreateFrame("Frame", "Timeline_Options_Menu", UIParent)
optionsFrame:SetMovable(true)
local pClass, CLASS = UnitClass("player")
local classFunc
--------------------------------------------------------------------------------
-- Debug mode stuff
--------------------------------------------------------------------------------
local debugMode = false
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
local ICON_HEIGHT = 25 -- Default 10
local TOTAL_TIME = 25 -- Default 60 (Total amount of time for the timeline in seconds)

local TEXT_HEIGHT = 16 -- Default 16
local TEXT_COLOR = {0.93, 0.86, 0.01, 1.0} -- Default 0.93, 0.86, 0.01, 1.0
local NUMBER_OF_DECIMALS = 0 -- Default 0

if CLASS == "DEATHKNIGHT" then
  local function deathKnight(specName)
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

		local list = {}

    if specName == "Blood" then

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
			list[4] = {
				name = "Cast Bar",
				category = "castbar",
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
TL:SetSize(WIDTH, ICON_HEIGHT)
TL:SetPoint("RIGHT", UIParent, 0, 0) -- 400 is the X coords, 0 is the Y coords

TL.line = UIParent:CreateTexture(nil, "OVERLAY")
TL.line:SetTexture(1, 1, 1, 1)
TL.line:SetSize(1, 1080)
TL.line:SetPoint("LEFT", TL)

local pName = GetUnitName("player")
TL.bars = {}
TL.icons = {}
TL.updateList = {}
TL.combatEvents = {}
TL.registeredIDs = {}
TL.categories = { -- NOTE: Make sure to add any new category to the index below
	cooldown = {},
	buff = {},
	debuff = {},
	castbar = {},
	rune = {},
}
TL.indexedCategories = {
	"cooldown",
	"buff",
	"debuff",
	"castbar",
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

local function stopCastBars()
	if TL.categories.castbar[1] then
		for i = 1, #TL.categories.castbar do
			if TL.categories.castbar[i].slide:IsPlaying() then
				TL.categories.castbar[i].slide:Stop()
			end
		end
	end
end

function TL.SPELL_AURA_APPLIED(time, _, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, school, auraType, amount)
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

	if auraType == "BUFF" then
		if TL.categories.buff[spellID] then
			TL.categories.buff[spellID].slide:Stop()
		end
	elseif auraType == "DEBUFF" then
		if TL.categories.debuff[spellID] then
			TL.categories.buff[spellID].slide:Stop()
		end
	end
end

function TL.SPELL_CAST_START(time, event, _, srcGUID, srcName, _, _, dstGUID, dstName, _, _, spellID, spellName, school)
	if srcName ~= pName then return end

	if TL.categories.castbar[1] then
		for i = 1, #TL.categories.castbar do
			TL.categories.castbar[i]:update()
		end
	end
end

function TL.UNIT_SPELLCAST_STOP(unitID, spellName, rank, lineID, spellID)
	if unitID and unitID ~= "player" then return end

	stopCastBars()

	-- after(0., stopCastBars)
end

function TL.SPELL_CAST_SUCCESS(time, event, _, srcGUID, srcName, _, _, dstGUID, dstName, _, _, spellID, spellName, school)
	if srcName ~= pName then return end

	if TL.categories.cooldown[spellID] then
		TL.categories.cooldown[spellID]:update()
	end

	local startGCD, GCD = GetSpellCooldown(61304)

	if startGCD > 0 then
		if TL.categories.castbar[1] then
			for i = 1, #TL.categories.castbar do
				TL.categories.castbar[i]:update()
			end
		end
	end
end

function TL.RUNE_POWER_UPDATE(runeNum)
	local pStart, pDuration, pRuneReady = GetRuneCooldown(TL.partners[runeNum])
	local start, duration, runeReady = GetRuneCooldown(runeNum)
	local remaining = (start + duration) - GetTime()

	local runeType = GetRuneType(runeNum)

	local bar = bars[runeNum]
	local data = types[runeType]

	-- do -- Handle showing/hiding of icons
	-- 	if (not runeReady and not pRuneReady) then -- Both are on CD
	-- 		bar.icon[1]:Hide()
	-- 		bar.icon[2]:Hide()
	-- 	elseif (not runeReady) or (not pRuneReady) then -- One is on CD, one is usable
	-- 		bar.icon[2]:Show()
	-- 		bar.icon[1]:Hide()
	-- 	else -- Both are usable
	-- 		bar.icon[2]:Show()
	-- 		bar.icon[1]:Show()
	-- 	end
	-- end

	if not runeReady and remaining < duration then -- Rune was already on CD, ignore
		return -- debug("Remaining is lower than duration, returning.", runeNum)
	elseif not runeReady then -- Start the cooldown
		if not runes[runeNum] then
			runes[runeNum] = newTicker(0.001, function(ticker)
				local start, duration, runeReady = GetRuneCooldown(runeNum)

				if not runeReady then
					local remaining = (start + duration) - GetTime()

					if remaining <= duration and remaining > 0 then
						bar:SetValue(remaining)
						bar.icon[1]:SetPoint("LEFT", bar, remaining * 10, 0)
						bar.line:SetPoint("LEFT", bar, remaining * 10, 0)
						-- round(bar.text, remaining)
					end
				else
					ticker:Cancel()
					bar:SetValue(0) -- Make sure value is 0, that hides the bar
					-- bar.text:SetText(nil) -- Remove text
					runes[runeNum] = nil
				end
			end)
		end
	end

	if TL.categories.cooldown[spellID] then
		TL.categories.cooldown[spellID]:update()
	end

	local startGCD, GCD = GetSpellCooldown(61304)

	if startGCD > 0 then
		if TL.categories.castbar[1] then
			for i = 1, #TL.categories.castbar do
				TL.categories.castbar[i]:update()
			end
		end
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
			local specID, specName, description, specIcon, background, role, primaryStat = GetSpecializationInfo(GetSpecialization())

			if not TimelineDB then TimelineDB = {} end
			if not TimelineCharDB then TimelineCharDB = {} end
			if not TimelineCharDB[pClass] then TimelineCharDB[pClass] = {} end
			if not TimelineCharDB[pClass][specName] then TimelineCharDB[pClass][specName] = {} end

			TL.charDB = TimelineCharDB[pClass][specName]

			TL.loadList(specName)
			TL.startCombat() -- NOTE: Testing only
		end
	elseif event == "PLAYER_LOGIN" then
		if debugMode then
			TL.createOptionsFrame()

			after(1, function()
				TL.options:Show()
			end)
		end
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

function TL.loadList(specName)
	local specName = specName or select(2, GetSpecializationInfo(GetSpecialization()))
	local list = classFunc(specName)

	for i = 1, NUMBER_OF_ICONS do
		local list = TL.charDB[i] or list[i]

		local spell
		if list then
			spell = {}
		end

		if spell then
			local category = list.category
			local spellName = list.name
			local spellID = list.ID or select(7, GetSpellInfo(spellName))
			local unit = list.unit or "player"

			local icon, slide = spell.icon
			if not icon then
				icon = CreateFrame("Frame", "Timeline_Icon_" .. i, TL)
				icon:SetPoint("RIGHT", TL, "TOPLEFT", 0, -((i - 1) * ICON_HEIGHT))
				icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

				local texture = GetSpellTexture(spellID or spellName) or "Interface\\ChatFrame\\ChatFrameBackground"
				icon.texture = icon:CreateTexture(nil, "ARTWORK")
				icon.texture:SetTexture(texture)
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
						if icon.line then
							icon.line:Hide()
						end

						if icon.text then
							icon.text:Hide()
						end

						if category == "castbar" then
							icon:Hide()
						end
					end)

					icon.slide = slide
					spell.slide = slide
				end

				if list.text == true then
					icon.text = icon:CreateFontString(nil, "OVERLAY")
					icon.text:SetPoint("CENTER", icon, 0, 0)
					icon.text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
					icon.text:SetTextColor(unpack(TEXT_COLOR))
					-- round(text, remaining)

					spell.text = icon.text
				end

				if list.line == true then
					icon.line = icon:CreateTexture(nil, "ARTWORK")
					icon.line:SetTexture(1, 1, 1, 1)
					icon.line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
					icon.line:SetPoint("RIGHT")
					icon.line:Hide()

					spell.line = icon.line
				end

				spell.icon = icon
				tinsert(TL.icons, icon)
			end

			spell.icon = icon

			if category then
				if spellID then TL.categories[category][spellID] = spell end
				if spellName then TL.categories[category][spellName] = spell end
				tinsert(TL.categories[category], spell)

				if category == "cooldown" then
					function spell:update(cTime, timer)
						local cTime = cTime or GetTime()
						-- local baseCD = (GetSpellBaseCooldown(spellID) or 0) * 0.001

						local cooldown, charges, chargeMax, chargeStart, chargeDuration, start, duration, endCD

						local startGCD, GCD = GetSpellCooldown(61304)
						local start, duration = GetSpellCooldown(spellID)
						local remaining = (start + duration) - cTime

						do -- Handles updating the bar's width
							local frameWidth = TL:GetWidth()

							local x = (frameWidth * remaining) / TOTAL_TIME

							if duration ~= GCD then
								if not slide:IsPlaying() then
									if remaining >= TOTAL_TIME then
										local delay = remaining - TOTAL_TIME
										slide[2]:SetStartDelay(remaining - TOTAL_TIME)
										slide[2]:SetDuration(remaining - delay)
									else
										slide[2]:SetStartDelay(0)
										slide[2]:SetDuration(remaining)
									end

									slide[1]:SetDuration(0.001)

									slide[1]:SetOffset(x, 0)
									slide[2]:SetOffset(-x, 0)

									if slide:IsPlaying() then slide:Stop() end
									slide:Play()

									if icon.line then
										icon.line:Show()
									end

									if icon.text then
										icon.text:Show()
									end
								end
							else
								after(0.005, spell.update)
								-- debug("Duration matches GCD, calling back in", 0.005, "seconds")
							end
						end
					end
				elseif category == "buff" then
					function spell:update()
						local cTime = GetTime()

						local name, _, icon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3, index

						while true do
							index = (index or 0) + 1
							name, _, icon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3 = UnitBuff(unit, index)

							if (ID == spellID) or (spellName == name) then -- Found a match
								break
							elseif not name then -- Failed to find a match, return
								return
							end
						end

						local remaining = expires - cTime

						do -- Handles updating the bar's width
							local frameWidth = TL:GetWidth()

							local x = (frameWidth * remaining) / TOTAL_TIME

							if remaining >= TOTAL_TIME then
								local delay = remaining - TOTAL_TIME
								slide[2]:SetStartDelay(remaining - TOTAL_TIME)
								slide[2]:SetDuration(remaining - delay)
							else
								slide[2]:SetStartDelay(0)
								slide[2]:SetDuration(remaining)
							end

							slide[1]:SetDuration(0.001)

							slide[1]:SetOffset(x, 0)
							slide[2]:SetOffset(-x, 0)

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
				elseif category == "debuff" then
					function spell:update()
						local cTime = GetTime()

						local name, _, icon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3, index

						while true do
							index = (index or 0) + 1
							name, _, icon, count, dispel, duration, expires, caster, steal, consolidated, ID, canApply, bossDebuff, v1, v2, v3 = UnitDebuff(unit, index)

							if (ID == spellID) or (spellName == name) then -- Found a match
								break
							elseif not name then -- Failed to find a match, return
								return
							end
						end

						local remaining = expires - cTime

						do -- Handles updating the bar's width
							local x = (TL:GetWidth() * remaining) / TOTAL_TIME

							if remaining >= TOTAL_TIME then
								local delay = remaining - TOTAL_TIME
								slide[2]:SetStartDelay(remaining - TOTAL_TIME)
								slide[2]:SetDuration(remaining - delay)
							else
								slide[2]:SetStartDelay(0)
								slide[2]:SetDuration(remaining)
							end

							slide[1]:SetDuration(0.001)

							slide[1]:SetOffset(x, 0)
							slide[2]:SetOffset(-x, 0)

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
				elseif category == "castbar" then
					function spell:update()
						local cTime = GetTime()

						local name, nameSubtext, text, texture, start, stop, tradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
						local remaining

						if name then
							remaining = (stop - start) / 1000
						else
							local startGCD, GCD = GetSpellCooldown(61304)

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

							slide[1]:SetOffset(x, 0)
							slide[2]:SetOffset(-x, 0)

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
				elseif category == "rune" then

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
	-- TL.charDB

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
			elseif category == "castbar" then
				if not scroll.castbar then
					function scroll:castbar()
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
	local rest = msg:match("^%S* (.+)$"):lower()

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
