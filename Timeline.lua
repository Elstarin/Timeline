local list = {}
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
--------------------------------------------------------------------------------
-- Main frame and local tables
--------------------------------------------------------------------------------
local Timeline = CreateFrame("Frame", "Timeline", UIParent)
local TL = Timeline
TL:SetSize(WIDTH, ICON_HEIGHT)
TL:SetPoint("RIGHT", UIParent, 0, 0) -- 400 is the X coords, 0 is the Y coords

TL.line = UIParent:CreateTexture(nil, "OVERLAY")
TL.line:SetTexture(1, 1, 1, 1)
TL.line:SetSize(1, 1080)
TL.line:SetPoint("LEFT", TL)

local pClass = UnitClass("player")
local pName = GetUnitName("player")
TL.bars = {}
TL.icons = {}
TL.updateList = {}
TL.combatEvents = {}
TL.registeredIDs = {}
TL.categories = {
	cooldown = {},
	buff = {},
	debuff = {},
	castbar = {},
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
-- Debug mode stuff
--------------------------------------------------------------------------------
do -- Debug mode stuff
  local matched
  local start = debugprofilestop() / 1000
  local printFormat = "|cFF9E5A01(|r|cFF00CCFF%.3f|r|cFF9E5A01)|r |cFF00FF00Timeline|r: %s"
  local debugMode = false

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
for i, v in ipairs({
  "RUNE_POWER_UPDATE",
  "RUNE_TYPE_UPDATE",
  "PLAYER_SPECIALIZATION_CHANGED",
  "PLAYER_REGEN_DISABLED",
  "PLAYER_REGEN_ENABLED",
  -- "PLAYER_LOGIN",
  "UNIT_SPELLCAST_SENT",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"UNIT_AURA",
	"UNIT_SPELLCAST_STOP",
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

  if event == "PLAYER_REGEN_ENABLED" then -- Leaving combat
		stopCombat()
  elseif event == "PLAYER_REGEN_DISABLED" then -- Entering combat
		startCombat()
  elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
	elseif event == "RUNE_POWER_UPDATE" then
		local runeNum = ...

		local pStart, pDuration, pRuneReady = GetRuneCooldown(partners[runeNum])
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
	elseif event == "RUNE_TYPE_UPDATE" then
		local runeNum = ...
		local runeType = GetRuneType(runeNum)

		local bar = bars[runeNum]
		bar:SetStatusBarColor(unpack(BAR_COLOR[runeType]))
		-- bar.icon[1]:SetTexture(iconTextures[runeType])
		-- bar.icon[2]:SetTexture(iconTextures[runeType])
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

if pClass == "Death Knight" then -- Rune stuff
	local runeIcons = {
		"Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood",
		"Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Unholy",
		"Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Frost",
		"Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Death",
	}

	local partners = {
		[1] = 2,
		[2] = 1,
		[3] = 4,
		[4] = 3,
		[5] = 6,
		[6] = 5
	}

	local types = {}
	do -- Rune data
		types[1] = {
			name = "Blood",
			texture = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood",
			timer = 0,
			duration = 10,
			start = 0,
			type = 1,
			ready = true,
		}
		types[2] = {
			name = "Unholy",
			texture = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Unholy",
			timer = 0,
			duration = 10,
			start = 0,
			type = 2,
			ready = true,
		}
		types[3] = {
			name = "Frost",
			texture = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Frost",
			timer = 0,
			duration = 10,
			start = 0,
			type = 3,
			ready = true,
		}
		types[4] = {
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

local function createBars()
	local y = 0

	local width = TL:GetWidth()

	for i = 1, NUMBER_OF_ICONS do
		f = CreateFrame("Frame", "Timeline_Bar_" .. i, TL)
		f:SetSize(1, ICON_HEIGHT)
		f:SetPoint("LEFT", TL)
		f:SetPoint("TOP", TL, 0, y)
		f.texture = f:CreateTexture(nil, "BACKGROUND")
		f.texture:SetTexture(0.0, 0.0, 0.5, 0.5)
		f.texture:SetAllPoints()

		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood")
		f.icon:SetPoint("LEFT", f, "RIGHT", 0, 0)
		-- f.icon:SetPoint("RIGHT", 0, 0)
		f.icon:SetSize(ICON_HEIGHT, ICON_HEIGHT)
		-- f.icon:Hide()

		-- f.line = f:CreateTexture(nil, "OVERLAY")
		-- f.line:SetTexture(1, 1, 1, 1)
		-- f.line:SetSize(1, 1080)
		-- f.line:SetPoint("CENTER", UIParent)

		f.text = f:CreateFontString(nil, "OVERLAY")
		f.text:SetPoint("CENTER", f.icon, 0, 0)
		f.text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
		f.text:SetTextColor(unpack(TEXT_COLOR))
		f.text:Hide()

		y = y - f:GetHeight()

		tinsert(TL.bars, f)
	end

	TL:SetHeight(-y)
end

local function loadList()
	for i = 1, NUMBER_OF_ICONS do
		local spell = list[i]

		if spell then
			local category = spell.category
			local spellName = spell.name
			local spellID = spell.ID or select(7, GetSpellInfo(spellName))
			local unit = spell.unit or "player"

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

				if spell.text == true then
					icon.text = icon:CreateFontString(nil, "OVERLAY")
					icon.text:SetPoint("CENTER", icon, 0, 0)
					icon.text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
					icon.text:SetTextColor(unpack(TEXT_COLOR))
					-- round(text, remaining)

					spell.text = icon.text
				end

				if spell.line == true then
					icon.line = icon:CreateTexture(nil, "ARTWORK")
					icon.line:SetTexture(1, 1, 1, 1)
					icon.line:SetSize(spell.lineWidth or 1, spell.lineHeight or UIParent:GetHeight())
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

local function startCombat()
	TL.active = true
	TL.combatStart = GetTime()
end

local function stopCombat()
	TL.active = false
	TL.combatStop = GetTime()
end

-- createBars()
loadList()
startCombat() -- NOTE: Testing only
--------------------------------------------------------------------------------
-- Slash command stuff
--------------------------------------------------------------------------------
SLASH_RuneTracker1 = "/rt"
function SlashCmdList.RuneTracker(msg, editbox)
	local direction, offSet = msg:match("([xXyY])([+-]?%d+)")
	if direction then direction = direction:lower() end
	local command, rest = msg:match("^(%S*)%s*(.-)$"):lower()

	if command == "toggle" or command == "" then
		if TL:IsVisible() then
			TL:Hide()
		else
			TL:Show()
		end
	elseif command == "show" then
		TL:Show()
	elseif command == "hide" then
		TL:Hide()
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
