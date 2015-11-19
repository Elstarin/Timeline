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
local debugMode = false
do -- Debug mode stuff
  local matched
  local start = debugprofilestop() / 1000
  local printFormat = "|cFF9E5A01(|r|cFF00CCFF%.3f|r|cFF9E5A01)|r |cFF00FF00Timeline|r: %s"
  local t = {}

  if GetUnitName("player") == "Elstari" and GetRealmName() == "Drak'thul" then
    debugMode = true
    matched = true
  end

  function TL.debug(...)
    if debugMode then
      wipe(t)
      local num = select("#", ...)

      for i = 1, num do
        local var = select(i, ...)
        local obj = type(var)

        if obj == "table" then
          t[i] = "|cFF888888" .. tostring(var) .. "|r"
        elseif obj == "function" then
          t[i] = "|cFFDA70D6" .. tostring(var) .. "|r"
        elseif obj == "nil" then
          t[i] = "|cFFFA6022nil|r"
        elseif obj == "boolean" then
          if var == true then
            t[i] = "|cFF4B6CD7true|r"
          elseif var == false then
            t[i] = "|cFFFF9B00false|r"
          end
        elseif obj == "userdata" then
          t[i] = "|cFF888888" .. tostring(var) .. "|r"
        elseif obj == "number" or type(tonumber(obj)) == "number" then
          t[i] = "|cFF00CCFF" .. var .. "|r"
        elseif obj == "string" then
          t[i] = var
        end
      end

      local string = table.concat(t, ", ")

      if string then
        string = string:gsub("(%a+), (|%x*%d+|r)", "%1 %2") -- Remove any commas after a string when it's followed by a number
        string = string:gsub("(%a+), (%a+)", "%1 %2") -- Remove any commas after a string when it's followed by a string
        string = string:gsub("(|%x*%d+|r), %a+", "%1") -- Remove any commas after a number when it's followed by a string
        string = string:gsub("(%p),", "%1") -- Remove any commas after a punctuation character
        string = string:gsub("(%()(.*)(%))", "|cFF9E5A01%1|r|cFF00CCFF%2|r|cFF9E5A01%3|r") -- Make ( and ) orange and anything inside them blue
        string = string:gsub("(%w: )(.+)%p*", "%1|cFFFFCC00%2|r") -- Make any letters after a: gold until next punctuation mark
        if not string:match("%p$") then string = string .. "." end -- If it doesn't end with a puncuation character, add a period

        print(printFormat:format((debugprofilestop() / 1000) - start, string))
      end
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
-- Documentation (How to add new icons)
--[[----------------------------------------------------------------------------
What follows is a list of every possible category and every key that can be
used with that category. Many of the key are optional, and I will use an
asterisk to specify when a key is necessary. If you copy these templates,
make sure you delete the asterisks, as they will cause lua errors if left in.
As mentioned above with the ID and name examples, you need one of them, but
having both is optional. I'll mark both with asterisks anyway, as it doesn't
hurt anything to include them.

-- COOLDOWN --------------------------------------------------------------------
list[0] = {
  category = "cooldown",*
  ID = 20473,*
  name = "Holy Shock",*
  line = true,
  lineHeight = 100,
  lineAnchor = "BOTTOM",
  text = true,
}
-- RUNE ------------------------------------------------------------------------
list[0] = {
  category = "rune",*
  ID = 1,*
  runeNums = {1, 2},*
  name = "Blood",*
  line = true,
  lineHeight = 100,
  lineAnchor = "BOTTOM",
  text = true,
}
-- Buff ------------------------------------------------------------------------
list[0] = {
  category = "buff",*
  ID = 86273,*
  name = "Illuminated Healing",*
  text = true,
}
-- Debuff ----------------------------------------------------------------------
list[0] = {
  category = "debuff",*
  ID = 86273,*
  name = "Illuminated Healing",*
  text = true,
}
-- GCD -------------------------------------------------------------------------
-- NOTE: This does not create a visible icon, it only creates a vertical line.

list[0] = {
  category = "gcd",*
  line = true,*
  lineHeight = 100,
  lineAnchor = "BOTTOM",
  lineColor = {0.5, 1.0, 0.5, 1},
}
-- Castbar ---------------------------------------------------------------------
-- NOTE: Just like the GCD, this does not create a visible icon, only a line

list[-4] = {
  category = "castbar",*
  line = true,*
  lineHeight = 100,
  lineAnchor = "BOTTOM",
  createBar = true,
  lineColor = {0.5, 1.0, 0.5, 1},
}
-- BigWigs ---------------------------------------------------------------------
-- NOTE: This creates lots of icons running on the same list index (same line)

list[0] = {
  category = "bigwigs",*
  name = "bigwigs",
  line = true,
  lineHeight = 100,
  lineAnchor = "BOTTOM",
  createBar = true,
  lineColor = {0.5, 1.0, 0.5, 1},
  text = true,
}
-- Activity -----------------------------------------------------------------------
-- NOTE: Currently broken, do not use!

list[0] = {
  category = "activity",*
  marks = {2, 3},
}
-- Inactivity -----------------------------------------------------------------------
list[0] = {
  category = "inactivity",*
  marks = {2, 3},
}
-- Graph -----------------------------------------------------------------------
-- NOTE: Currently not finished, do not use!

list[0] = {
  category = "graph",*
  power = "mana",*
}
]]------------------------------------------------------------------------------
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
local NUMBER_OF_DECIMALS = 1 -- Default 0

if CLASS == "DEATHKNIGHT" then
  do -- If you aren't developing this addon, ignore all of this stuff that is in this block, it isn't part of the settings. Those are in the function below.
    local partners = {
      [1] = 2,
      [2] = 1,
      [3] = 4,
      [4] = 3,
      [5] = 6,
      [6] = 5
    }

    local names = {
      [1] = "Blood",
      [2] = "Blood",
      [3] = "Unholy",
      [4] = "Unholy",
      [5] = "Frost",
      [6] = "Frost"
    }

    local iconTextures = {
      "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Blood",
      "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Unholy",
      "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Frost",
      "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Death",
    }

    do -- Create the runes
      if not TL.runes then TL.runes = {} end

      TL.runes.textureList = iconTextures
      TL.runes.names = names
      TL.runes.partners = partners

      for i = 1, 6 do
        local rune = TL.runes[i]

        if not rune then
          debug("Creating rune:", names[i])
          rune = CreateFrame("Frame", "Timeline_Rune_" .. names[i] .. "_" .. i, TL)
          rune:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

          local runeType = GetRuneType(i)
          rune.num = i
          rune.defaultType = runeType
          rune.currentType = runeType -- This one can change

          rune.texture = rune:CreateTexture(nil, "ARTWORK")
          rune.texture:SetTexture(iconTextures[runeType])
          rune.texture:SetAllPoints()

          TL.runes[i] = rune
          TL.runes[names[i]] = rune
        end
      end

      for i = 1, 6 do
        local rune = TL.runes[i]
        rune.partner = TL.runes[partners[i]]
      end
    end
  end

  local function deathKnight(specName)
    local list = {}

    if specName == "Blood" then
      list[1] = {
        ID = 1,
        text = true,
        runeNums = {1, 2},
        name = "Blood",
        category = "rune",
      }
      list[2] = {
        ID = 2,
        text = true,
        runeNums = {3, 4},
        name = "Unholy",
        category = "rune",
      }
      list[3] = {
        ID = 3,
        text = true,
        runeNums = {5, 6},
        name = "Frost",
        category = "rune",
      }
      list[4] = {
        ID = 48982,
        name = "Blood Tap",
        category = "cooldown",
      }
      list[5] = {
        name = "Path of Frost",
        category = "buff",
      }
      list[6] = {
        name = "Anti-Magic Shell",
        category = "buff",
      }
      list[7] = {
        name = "Death and Decay",
        category = "cooldown",
        line = true,
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
      list[-6] = {
        category = "graph",
        power = "mana",
        -- YMax = 5,
      }
      list[-4] = {
        category = "castbar",
        line = true,
        lineColor = {0.5, 1.0, 0.5, 1},
        createBar = true,
      }
      list[-3] = {
        name = "bigwigs",
        category = "bigwigs",
        -- text = "title",
        text = true,
      }
      list[-1] = {
        category = "gcd",
        line = true,
        lineColor = {0.5, 0.5, 1, 1},
      }
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
TL.line:SetPoint("TOP", UIParent)
TL.line:SetPoint("BOTTOM", UIParent)

TL.spells = {}
TL.bars = {}
TL.icons = {}
TL.create = {} -- Holds the functions for creating icons for each category
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
  gcd = {},
  castbar = {},
  bigwigs = {},
  graph = {},
}
TL.indexedCategories = {
	"cooldown",
	"buff",
	"debuff",
	"activity",
  "inactivity",
	"rune",
  "gcd",
  "castbar",
  "bigwigs",
  "graph",
}
TL.powerTypesFormatted = {
  [0] = "Mana",
  [1] = "Rage",
  [2] = "Focus",
  [3] = "Energy",
  [4] = "Combo Points",
  [5] = "Runes",
  [6] = "Runic Power",
  [7] = "Soul Shards",
  [8] = "Eclipse",
  [9] = "Holy Power",
  [10] = "Alternate Power",
  [11] = "Dark Force",
  [12] = "Chi",
  [13] = "Shadow Orbs",
  [14] = "Burning Embers",
  [15] = "Demonic Fury",
}
TL.powerTypes = {
  [0] = "MANA",
  [1] = "RAGE",
  [2] = "FOCUS",
  [3] = "ENERGY",
  [4] = "COMBO_POINTS",
  [5] = "RUNES",
  [6] = "RUNIC_POWER",
  [7] = "SOUL_SHARDS",
  [8] = "ECLIPSE",
  [9] = "HOLY_POWER",
  [10] = "ALTERNATE_POWER",
  [11] = "DARK_FORCE",
  [12] = "CHI",
  [13] = "SHADOW_ORBS",
  [14] = "BURNING_EMBERS",
  [15] = "DEMONIC_FURY",
  ["MANA"] = 0,
  ["RAGE"] = 1,
  ["FOCUS"] = 2,
  ["ENERGY"] = 3,
  ["COMBO_POINTS"] = 4,
  ["RUNES"] = 5,
  ["RUNIC_POWER"] = 6,
  ["SOUL_SHARDS"] = 7,
  ["ECLIPSE"] = 8,
  ["HOLY_POWER"] = 9,
  ["ALTERNATE_POWER"] = 10,
  ["DARK_FORCE"] = 11,
  ["CHI"] = 12,
  ["SHADOW_ORBS"] = 13,
  ["BURNING_EMBERS"] = 14,
  ["DEMONIC_FURY"] = 15,
}
-- TL.powerTypes = {
--   [0] = "SPELL_POWER_MANA",
--   [1] = "SPELL_POWER_RAGE",
--   [2] = "SPELL_POWER_FOCUS",
--   [3] = "SPELL_POWER_ENERGY",
--   [4] = "SPELL_POWER_COMBO_POINTS",
--   [5] = "SPELL_POWER_RUNES",
--   [6] = "SPELL_POWER_RUNIC_POWER",
--   [7] = "SPELL_POWER_SOUL_SHARDS",
--   [8] = "SPELL_POWER_ECLIPSE",
--   [9] = "SPELL_POWER_HOLY_POWER",
--   [10] = "SPELL_POWER_ALTERNATE_POWER",
--   [11] = "SPELL_POWER_DARK_FORCE",
--   [12] = "SPELL_POWER_CHI",
--   [13] = "SPELL_POWER_SHADOW_ORBS",
--   [14] = "SPELL_POWER_BURNING_EMBERS",
--   [15] = "SPELL_POWER_DEMONIC_FURY",
--   ["SPELL_POWER_MANA"] = 0,
--   ["SPELL_POWER_RAGE"] = 1,
--   ["SPELL_POWER_FOCUS"] = 2,
--   ["SPELL_POWER_ENERGY"] = 3,
--   ["SPELL_POWER_COMBO_POINTS"] = 4,
--   ["SPELL_POWER_RUNES"] = 5,
--   ["SPELL_POWER_RUNIC_POWER"] = 6,
--   ["SPELL_POWER_SOUL_SHARDS"] = 7,
--   ["SPELL_POWER_ECLIPSE"] = 8,
--   ["SPELL_POWER_HOLY_POWER"] = 9,
--   ["SPELL_POWER_ALTERNATE_POWER"] = 10,
--   ["SPELL_POWER_DARK_FORCE"] = 11,
--   ["SPELL_POWER_CHI"] = 12,
--   ["SPELL_POWER_SHADOW_ORBS"] = 13,
--   ["SPELL_POWER_BURNING_EMBERS"] = 14,
--   ["SPELL_POWER_DEMONIC_FURY"] = 15,
-- }
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
TL.active = {}
TL:SetScript("OnUpdate", function(self, elapsed)
	local cTime = GetTime()
	local timer = (TL.combatStop or cTime) - (TL.combatStart or cTime)

  for icon, func in pairs(TL.active) do
    if func then func() end
  end
  
  if cTime >= (self.graphUpdateDelay or 0) then
    if TL.categories.graph[1] then
      for i = 1, #TL.categories.graph do
        local spell = TL.categories.graph[i]
        local graph = spell.graph
        local data = graph.data
        
        local num = #data + 1
        data[num] = cTime - graph.start
        data[-num] = (spell.currentPower or spell.maxPower)
        
        -- debug(data[num], data[-num])
        
        graph:refresh()
        
        -- spell:update(graph, data)
      end
    end
    
    self.graphUpdateDelay = cTime + 0.05
  end
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
  "UNIT_POWER_FREQUENT",
  }) do
  TL:RegisterEvent(v)
end

local function refreshNormalGraph(self, reset, routine)
  if not self.shown then return debug("Refresh got called when graph was not flagged as shown!", self.name) end
  if not self.frame then return debug("Refresh got called when graph had no frame!", self.name) end -- Happened once, was related to loading a saved fight or returning from one
  if self.updating then return debug("Refresh got called when graph was flagged as updating!", self.name) end
  
  local num = #self.data
  local graphWidth, graphHeight = self.frame:GetSize()

  local stopX = graphWidth * (self.data[num] - self.XMin) / (self.XMax - self.XMin)
  local finalX = stopX
  
  -- if stopX > graphWidth then -- Graph is too long, squish it
    self.frame.anchor:SetSize(graphWidth, graphHeight)
    self.frame:SetHorizontalScroll(stopX - graphWidth)
  -- end

  -- if reset then
  --   -- error("A reset somehow happened!")
  --   self.endNum = 2
  --   local percent = floor(((self.totalLines or 0) / num) * 100)  .. "%"
  --
  --   if num >= (2000) then -- The comparison number is after how many points do we want to switch to a coroutine (default 2000)
  --     self.refresh = wrap(refreshNormalGraph)
  --
  --     debug(percent, num, self.totalLines, #self.recycling, "Refreshing (coroutine):", self.name)
  --     return self:refresh(nil, true) -- Call it again, but now as a coroutine
  --   else
  --     debug(percent, num, self.totalLines, #self.recycling, "Refreshing:", self.name)
  --   end
  -- end

  local start = debugprofilestop()
  local maxX = self.XMax
  local minX = self.XMin
  local maxY = self.YMax
  local minY = self.YMin
  local data = self.data
  local lines = self.lines
  local frame = self.frame.anchor or self.frame
  local anchor = self.anchor or self.frame.anchor or self.frame
  local zoomed = self.frame.zoomed
  local blocked, blockedY = nil, 0, 0

  local c1, c2, c3, c4 = 0.0, 0.0, 1.0, 1.0 -- Default to blue
  if self.color then c1, c2, c3, c4 = self.color[1], self.color[2], self.color[3], self.overrideAlpha or self.color[4] end
  
  if num % 100 == 0 then -- Periodically loop through all the points and find the lines that are no longer visible and recycle them
    local graphLeft = self.frame:GetLeft()
    
    for i = 2, num do
      local line = lines[i]

      if line and graphLeft > line:GetRight() then
        self.recycling[#self.recycling + 1] = line
        line:ClearAllPoints()
        line:Hide()
        lines[i] = nil
      end
    end
    
    local percent = floor(((self.totalLines or 0) / num) * 100)  .. "%"
    debug(percent, num, self.totalLines, #self.recycling)
  end

  for i = (self.endNum or 2), num do
    local stopY = graphHeight * (data[-i] - minY) / (maxY - minY)

    if not zoomed then -- Update maxX and maxY values if necessary, just not while zoomed
      if stopY > graphHeight then -- Graph is too tall
        blocked = true

        if (stopY / graphHeight) > blockedY then
          blockedY = stopY
        end
      end
    end

    if not blocked then -- If out of bounds, finish looping to find the most out of bounds point, but don't waste time calculating everything
      local startX = graphWidth * (data[i - 1] - minX) / (maxX - minX) -- start isn't needed for bounds check
      local startY = graphHeight * (data[-(i - 1)] - minY) / (maxY - minY)
      
      local stopX = graphWidth * (data[i] - minX) / (maxX - minX)

      local lastLine
      local line = lines[i]
      local w = 32
      local dx, dy = stopX - startX, stopY - startY -- This is about the change
      local cx, cy = (startX + stopX) / 2, (startY + stopY) / 2 -- This is about the total

      if (dx < 0) then -- Normalize direction if necessary
        dx, dy = -dx, -dy
      end

      if startX ~= stopX then -- If they match, this can break
        local l = sqrt((dx * dx) + (dy * dy)) -- Calculate actual length of line

        local s, c = -dy / l, dx / l -- Sin and Cosine of rotation, and combination (for later)
        local sc = s * c

        if (i > 2) and self.lastLine then -- Without this, it can fall into an infinite loop
          local passed = nil

          do -- Check if any smoothing should be applied
            local diffDX = dx - (self.lastDX or 0)
            if 0 > diffDX then diffDX = -diffDX end

            local diffDY = dy - (self.lastDY or 0)
            if 0 > diffDY then diffDY = -diffDY end

            local diffS = s - (self.lastSine or 0)
            if 0 > diffS then diffS = -diffS end

            local level = self.smoothingOverride or 0 -- How much smoothing should happen, 0 to mostly disable

            if not level or level == 0 then -- Smoothing disabled, only do horizontal and vertical lines. This usually uses about 70% - 80% of the points, but can vary a ton
              if (diffDX == 0) or (diffDY == 0) then
                passed = true
              end
            elseif level == 1 then -- Very little smoothing, this will probably gradually increase the number of textures, roughly uses around 50% of the points
              if (0 >= diffDX) or (0 >= diffDY) or (diffS > 0.999) or (0.001 > diffS) then
                passed = true
              end
            elseif level == 2 then -- Medium, should be default, this tries to maintain a somewhat steady amount of textures, roughly around 400 - 600
              if (0.001 > diffDX) or (0.001 > diffDY) or (diffS > 0.99) or (0.01 > diffS) then
                passed = true
              end
            elseif level == 3 then -- Lots of smoothing, roughly around 200 - 300 textures most of the time
              if (0.01 > diffDX) or (0.01 > diffDY) or (diffS > 0.95) or (0.05 > diffS) then
                passed = true
              end
            elseif level == 4 then -- Probably too much smoothing, roughly around 140 - 200 textures
              if (0.1 > diffDX) or (0.1 > diffDY) or (diffS > 0.9) or (0.1 > diffS) then
                passed = true
              end
            elseif level == 5 then -- Complete overkill, but whatever, it's usually less than 100 textures
              if (0.2 > diffDX) or (0.2 > diffDY) or (diffS > 0.8) or (0.2 > diffS) then
                passed = true
              end
            end -- If you want to 100% disable smoothing, set the level higher than 5. I can't think of any reason to not extend straight lines though.
          end

          if passed then
            if line then -- If a line exists, recycle it to be used later, instead of throwing it away and creating a new one
              self.recycling[#self.recycling + 1] = line
              line:ClearAllPoints()
              line:Hide()
              lines[i] = nil
            end

            local index = i - 1
            while not lines[index] and (index > 0) do -- Find the most recent line
              index = index - 1
            end

            line = lines[index] -- Now this is used, instead of creating a brand new one

            startX = graphWidth * (data[index - 1] - minX) / (maxX - minX)
            startY = graphHeight * (data[-(index - 1)] - minY) / (maxY - minY)

            dx, dy = stopX - startX, stopY - startY -- Redo all these calculations with the new start points
            cx, cy = (startX + stopX) / 2, (startY + stopY) / 2

            if (dx < 0) then
              dx, dy = -dx, -dy
            end

            l = sqrt((dx * dx) + (dy * dy))

            s, c = -dy / l, dx / l
            sc = s * c
          end
        end

        local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy -- Calculate bounding box size and texture coordinates
        if dy >= 0 then
          Bwid = ((l * c) - (w * s)) * TAXIROUTE_LINEFACTOR_2
          Bhgt = ((w * c) - (l * s)) * TAXIROUTE_LINEFACTOR_2
          BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc
          BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx
          TRy = BRx
        else
          Bwid = ((l * c) + (w * s)) * TAXIROUTE_LINEFACTOR_2
          Bhgt = ((w * c) + (l * s)) * TAXIROUTE_LINEFACTOR_2
          BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc
          BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy
          TRx = TLy
        end

        if not line then
          if self.recycling[1] then -- First try to recycle an old line, if it has at least one
            line = tremove(self.recycling) -- Take the last one
            line:Show()
          else -- Nothing to recycle, create a new one
            line = frame:CreateTexture(nil, (self.drawLayer or "ARTWORK"))
            line:SetTexture("Interface\\addons\\CombatTracker\\Media\\line.tga")
            self.totalLines = (self.totalLines or 0) + 1
          end

          line:SetVertexColor(c1, c2, c3, c4)

          lastLine = line
          self.lastIndex = i
          self.lastLine = line -- Easy access to most recent

          lines[i] = line
        end

        self.lastSine = s
        self.lastDX = dx
        self.lastDY = dy

        line:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy)
        line:SetPoint("TOPRIGHT", anchor, "BOTTOMLEFT", cx + Bwid, cy + Bhgt)
        line:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", cx - Bwid, cy - Bhgt)
      end

      if i == num then -- Done running the graph update
        -- debug("Done running refresh:", debugprofilestop() - start)
        if routine then
          self.refresh = refreshNormalGraph
          self.updating = false
        end

        self.endNum = i + 1
        self.lastLine = lastLine or self.lastLine

        -- debug("TOTALS:", self.totalLines or 0, self.totalBars or 0, self.totalTriangles or 0, i)

        if self.frame.zoomed then
          local firstLine, lastLine = nil, nil

          for i = 1, num do
            if self.lines[i] then
              firstLine = self.lines[i]
              break
            end
          end

          for i = num, 1, -1 do
            if self.lines[i] then
              lastLine = self.lines[i]
              break
            end
          end

          local minimum = firstLine:GetLeft() - self.frame:GetLeft()
          local maximum = lastLine:GetRight() - self.frame:GetRight()

          if 0 < minimum then minimum = 0 end
          if 0 > maximum then maximum = 0 end

          self.frame.slider:SetMinMaxValues(minimum, maximum)
          self.frame.slider:SetValue(0)
        end
      elseif routine and (i % 1000) == 0 then -- The modulo of i is how many lines it will run before calling back, if it's in a coroutine
        local delay = random(-3, 3) / 100 + 0.05 -- The random number is to reduce the chances of multiple graphs refreshing at the exact same time
        after(delay, self.refresh)
        self.updating = true
        yield()
      end
    elseif blocked and i == num then -- It's done
      if routine then
        self.refresh = refreshNormalGraph
        self.updating = false
      end

      if blockedY > 0 then
        self.YMax = maxY * (blockedY / graphHeight) * 1.12 -- 90%
      end

      return self:refresh(true) -- Run agian with the new X/Y value
    end
  end
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
  TL.interrupted = false

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
  
  if TL.categories.castbar[1] then
    for i = 1, #TL.categories.castbar do
      local spell = TL.categories.castbar[i]

      spell:update()
    end
  end
end

function TL.UNIT_SPELLCAST_STOP(unitID, spellName, rank, lineID, spellID)
	if unitID and unitID ~= "player" then return end

  if TL.casting then
    TL.interrupted = true
    TL.casting = false
  end

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
    TL.interrupted = false
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
      
      if TL.categories.gcd[1] then
        for i = 1, #TL.categories.gcd do
          local spell = TL.categories.gcd[i]

          spell:update(startGCD, GCD) -- Make it orange since it's a GCD
        end
      end
    end
  end
end

function TL.RUNE_POWER_UPDATE(runeNum)
	local index = GetRuneType(runeNum)

  local spell = TL.categories.rune[index]
  if spell then
    local start, duration, runeReady = GetRuneCooldown(runeNum)
    local remaining = (start + duration) - GetTime()

    if not runeReady and remaining < duration then -- Rune was already on CD, ignore
      return -- debug("Remaining is lower than duration, returning.", runeNum)
    elseif not runeReady then -- Start the cooldown
      local rune = TL.runes[runeNum]
      spell:update(rune, runeNum, index, start, duration, runeReady, remaining)
    end
  end
end

function TL.RUNE_TYPE_UPDATE(runeNum)
	local runeType = GetRuneType(runeNum)

  local rune = TL.runes[runeNum]

  if rune.currentType ~= runeType then -- Needs its texture updated
    rune.texture:SetTexture(TL.runes.textureList[runeType])
    rune.currentType = runeType
  end
end

function TL.UNIT_POWER_FREQUENT(unit, powerType)
  if unit ~= "player" then return end
  
  local index = TL.powerTypes[powerType] -- Gives the power index, like 0 for mana, 9 for holy power, etc
  local currentPower = UnitPower(unit, index)
  
  if TL.categories.graph[1] then
    for i = 1, #TL.categories.graph do
      local spell = TL.categories.graph[i]
      
      if spell[powerType] then -- Make sure this is a power that is registered in the list
        spell.currentPower = currentPower
        -- spell:update(currentPower)
      end
    end
  end
end

TL:SetScript("OnEvent", function(self, event, ...)
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
    
    if TL.runes then -- Player is a death knight
      print("Trying to set rune textures:")
      for i = 1, 6 do
        local rune = TL.runes[i]
        
        if rune and rune.texture then
          rune.texture:SetTexture(TL.runes.textureList[rune.defaultType])
          rune.texture:SetAllPoints()
          print(i, TL.runes.textureList[rune.defaultType], rune.texture:GetTexture())
        end
      end
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
local function roundFormatted(fontString, num, decimals)
	if (num == math.huge) or (num == -math.huge) then num = 0 end

	decimals = decimals or NUMBER_OF_DECIMALS

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

local function createLine(icon, list)
  local line = icon.line
  if not line then
    line = icon:CreateTexture(nil, "ARTWORK")
    line:Hide()
    
    icon.line = line
  end
  
  local r, g, b, a = 1, 1, 1, 1
  if list.lineColor then
    r, g, b, a = list.lineColor[1], list.lineColor[2], list.lineColor[3], list.lineColor[4]
  end

  line:ClearAllPoints()
  
  line:SetTexture(r, g, b, a)
  line:SetWidth(list.lineWidth or 1)
  line:SetPoint("RIGHT")

  if list.lineHeight then
    line:SetHeight(list.lineHeight)
  else
    line:SetPoint("TOP", UIParent)
    line:SetPoint("BOTTOM", UIParent)
  end
  
  return line
end

local function createText(parent, list, relative) -- Parent needs to be a frame, relative is the holding table and anchor
  if not relative then relative = parent end
  
  local text = relative.text
  if not line then
    text = parent:CreateFontString(nil, "OVERLAY")
    
    relative.text = text
  end
  
  local r, g, b, a = 1, 1, 1, 1
  if list.textColor then
    r, g, b, a = list.textColor[1], list.textColor[2], list.textColor[3], list.textColor[4]
  elseif TEXT_COLOR then
    r, g, b, a = unpack(TEXT_COLOR)
  end
  
  text:ClearAllPoints()
  text:SetPoint("CENTER", relative, 0, 0)
  text:SetFont("Fonts\\FRIZQT__.TTF", 26, "OUTLINE")
  text:SetTextColor(1, 1, 1, 1)
  text:SetJustifyH("LEFT")
  
  return text
end

function TL.create.cooldown(i, spell, list, spellID, spellName, unit)
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

    local line
    if index == 1 and list.line then
      line = createLine(icon, list)
    end

    tinsert(TL.icons, icon)
  end

  return spell.icon
end

function TL.create.buff(i, spell, list, spellID, spellName, unit)
  local icon = spell.icon
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
    
    spell.icon = icon
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

  return icon
end

function TL.create.debuff(i, spell, list, spellID, spellName, unit)
  local icon = spell.icon
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
    
    spell.icon = icon
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

  return icon
end

function TL.create.activity(i, spell, list, spellID, spellName, unit)
  spell.icon = {}

  for index = 1, 2 do
    local icon = spell.icon[index]
    if not icon then
      icon = CreateFrame("Frame", "Timeline_Icon_" .. i .. "_" .. index, TL)
      icon:SetPoint("RIGHT", TL, "TOPLEFT", 0, -((i - 1) * ICON_HEIGHT))
      icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

      icon.texture = icon:CreateTexture(nil, "ARTWORK")
      icon.texture:SetTexture(0.0, 0.0, 0.8, 1.0)
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

    local line = icon.line
    if list.line and not line then
      line = icon:CreateTexture(nil, "ARTWORK")
      line:SetTexture(1, 1, 1, 1)
      line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
      line:SetPoint("RIGHT")
      line:Hide()

      icon.line = line
    end

    icon:Hide()

    tinsert(TL.icons, icon)
  end

  return spell.icon
end

function TL.create.inactivity(i, spell, list, spellID, spellName, unit)
  spell.icon = {}
  spell.icon.filling = {}

  for index = 1, 2 do
    local icon = spell.icon[index]
    if not icon then
      icon = CreateFrame("Frame", "Timeline_Icon_" .. i .. "_" .. index, TL)
      icon:SetPoint("RIGHT", TL, "TOPLEFT", 0, -((i - 1) * ICON_HEIGHT))
      icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)

      icon.texture = icon:CreateTexture(nil, "ARTWORK")
      icon.texture:SetTexture(0.0, 0.0, 0.8, 1.0)
      icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
      icon.texture:SetAlpha(0.0)
      icon.texture:SetAllPoints()
      
      spell.icon[index] = icon
    end

    local fill = icon.fill
    if not fill then
      fill = icon:CreateTexture(nil, "ARTWORK")
      fill:SetTexture(1.0, 0.0, 0.0, 1.0)
      fill:SetHeight(ICON_HEIGHT - 2)
      fill:Hide()

      icon.fill = fill
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

    icon:Hide()

    tinsert(TL.icons, icon)
  end

  return spell.icon
end

function TL.create.rune(index, spell, list, spellID, spellName, unit)
  for i = 1, #list.runeNums do
    local runeIndex = list.runeNums[i]

    local rune = TL.runes[runeIndex]

    rune:SetPoint("TOP", TL, 0, -((index - 1) * ICON_HEIGHT))
    rune:SetPoint("RIGHT", TL.line, ((index + 1) % 2) * ICON_HEIGHT, 0)
    -- rune:SetPoint("RIGHT", TL.line, ((i + 1) % 2) * ICON_HEIGHT, 0)

    local text = rune.text
    if list.text and not text then
      text = rune:CreateFontString(nil, "OVERLAY")
      text:SetPoint("CENTER", rune, 0, 0)
      text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
      text:SetTextColor(unpack(TEXT_COLOR))

      rune.text = text
    end

    local line = rune.line
    if list.line and not line then
      line = rune:CreateTexture(nil, "ARTWORK")
      line:SetTexture(1, 1, 1, 1)
      line:SetSize(list.lineWidth or 1, list.lineHeight or UIParent:GetHeight())
      line:SetPoint("RIGHT")
      line:Hide()

      rune.line = line
    end
  end
end

function TL.create.gcd(index, spell, list, spellID, spellName, unit)
  local icon = spell.icon
  if not icon then
    icon = CreateFrame("Frame", "Timeline_Icon_" .. index, TL)
    
    icon:SetPoint("TOP", TL, 0, -((index - 1) * ICON_HEIGHT))
    icon:SetPoint("RIGHT", TL.line, 0, 0)
    
    icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)
    
    -- icon.texture = icon:CreateTexture(nil, "ARTWORK")
    -- icon.texture:SetTexture(0.0, 0.0, 0.8, 1.0)
    -- icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    -- icon.texture:SetAlpha(1)
    -- icon.texture:SetAllPoints()
    
    spell.icon = icon
  end

  local fill = icon.fill
  if not fill then
    fill = icon:CreateTexture(nil, "ARTWORK")
    fill:SetTexture(1.0, 0.0, 0.0, 1.0)
    fill:SetHeight(ICON_HEIGHT - 2)
    fill:Hide()

    icon.fill = fill
  end

  local text = icon.text
  if list.text and not text then
    text = icon:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER", icon, 0, 0)
    text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
    text:SetTextColor(unpack(TEXT_COLOR))

    icon.text = text
  end

  local line
  if list.line then
    line = createLine(icon, list)
  end

  spell.icon[index] = icon

  tinsert(TL.icons, icon)

  return icon, text, line
end

function TL.create.castbar(index, spell, list, spellID, spellName, unit)
  local icon = spell.icon
  if not icon then
    icon = CreateFrame("Frame", "Timeline_Icon_" .. index, TL)
    
    icon:SetPoint("TOP", TL, 0, -((index - 1) * ICON_HEIGHT))
    icon:SetPoint("RIGHT", TL.line, 0, 0)
    
    icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)
    
    -- icon.texture = icon:CreateTexture(nil, "ARTWORK")
    -- icon.texture:SetTexture(0.0, 0.0, 0.8, 1.0)
    -- icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    -- icon.texture:SetAlpha(1)
    -- icon.texture:SetAllPoints()
    
    spell.icon = icon
  end

  local text = icon.text
  if list.text and not text then
    text = icon:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER", icon, 0, 0)
    text:SetFont("Fonts\\FRIZQT__.TTF", TEXT_HEIGHT, "OUTLINE")
    text:SetTextColor(unpack(TEXT_COLOR))

    icon.text = text
  end

  local line
  if list.line then
    line = createLine(icon, list)
  end

  spell.icon[index] = icon

  tinsert(TL.icons, icon)

  return icon, text, line
end

function TL.create.bigwigs(index, spell, list, spellID, spellName, unit)
  if not spell.icons then spell.icons = {} end
  
  local icon = CreateFrame("Frame", "Timeline_Icon_" .. index, TL) -- Create a new icon every time this is called
  icon:SetPoint("TOP", TL, 0, -((index - 1) * ICON_HEIGHT))
  icon:SetPoint("RIGHT", TL.line, 0, 0)
  
  icon:SetSize(ICON_HEIGHT - 2, ICON_HEIGHT - 2)
  
  icon.texture = icon:CreateTexture(nil, "ARTWORK")
  icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
  icon.texture:SetAllPoints()

  local bar = icon.bar
  if not bar then
    bar = CreateFrame("StatusBar", nil, icon)
    
    -- bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    -- bar.bg:SetAllPoints()

    -- bar:SetStatusBarTexture()
    bar:SetOrientation("HORIZONTAL")
    -- bar:SetTexture(1.0, 0.0, 0.0, 1.0)
    bar:SetSize(100, ICON_HEIGHT - 2)
    bar:SetPoint("LEFT", icon, "RIGHT")
    -- bar:SetFrameStrata("LOW")
    -- bar:SetPoint("RIGHT", icon, "LEFT")
    
    bar.text = bar:CreateFontString(nil, "ARTWORK")
    bar.text:SetPoint("CENTER", bar, 0, 0)
    bar.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    bar.text:SetTextColor(1, 1, 1, 1)
    
    icon.bar = bar
  end

  local text = icon.text
  if list.text and not text then
    text = createText(icon, list)
  end

  local line
  if list.line then
    line = createLine(icon, list)
  end

  spell.icons[#spell.icons + 1] = icon -- Keep all icons in here

  return icon, text, line, bar
end

function TL.create.graph(index, spell, list, spellID, spellName, unit)
  local frame = spell.frame
  if not frame then
    frame = CreateFrame("ScrollFrame", "TL_GRAPH", self)
    frame.anchor = CreateFrame("Frame", "TL_GRAPH_ANCHOR", self)
    frame:SetScrollChild(frame.anchor)
    frame.anchor:SetSize(100, 100)
    frame.anchor:SetAllPoints(frame)
    
    frame:SetPoint("TOP", TL, 0, -((index - 1) * ICON_HEIGHT))
    frame:SetPoint("RIGHT", TL.line, 0, 0)
    frame:SetSize(400, 100)
    frame.bg = frame:CreateTexture("Background", "BACKGROUND")
    frame.bg:SetTexture(0.1, 0.1, 0.1, 0.5)
    frame.bg:SetAllPoints()
    
    -- frame.anchor:SetSize(frame:GetSize())
    -- frame:SetHorizontalScroll(-(frame:GetWidth()))
    
    spell.frame = frame
  end
  
  local graph = spell.graph
  if not graph then
    graph = {}
    graph.name = "Test Graph"
    graph.data = {}
    graph.lines = {}
    graph.bars = {}
    graph.triangles = {}
    graph.recycling = {}
    graph.frame = frame
    graph.XMin = 0
    graph.XMax = 3
    graph.YMin = list.YMin or 0
    graph.YMax = list.YMax or 100
    graph.endNum = 2
    graph.fill = true
    graph.refresh = refreshNormalGraph
    graph.color = {0.0, 0.0, 1.0, 1.0} -- Blue
    graph.shown = true
    graph.start = GetTime()
    
    spell.graph = graph
  end
  
  if list.power then
    local listPower = list.power:lower()
    for i = 0, #TL.powerTypes do
      local maxPower = UnitPowerMax("player", i)
      
      if maxPower > 0 then
        local name = TL.powerTypesFormatted[i]:lower()
        local powerType = TL.powerTypes[i] -- The one used in UNIT_POWER_FREQUENT, like MANA and HOLY_POWER
        
        if (name == listPower) or (name:match(listPower)) then -- This is the power from the list
          graph.YMin = 0
          graph.YMax = maxPower
          
          spell[powerType] = true
          spell.maxPower = maxPower
          break
        end
      end
    end
  end
  
  return frame, graph
end

function TL.loadList(specName)
	local specName = specName or select(2, GetSpecializationInfo(GetSpecialization()))
	local list = classFunc(specName)

	for i = -100, NUMBER_OF_ICONS do
		local list = TL.charDB[i] or list[i] -- Take it from SVars if it exists, otherwise go with the list version

		if list then
			local category = list.category
      
      if category then
        category = category:lower()
      else
        return error("No category set for " .. (list.name or list.ID) .. "! Index is: " .. i .. ". Timeline cannot work without a category set.")
      end
      
			local spellName = list.name or category
			local spellID = list.ID or select(7, GetSpellInfo(spellName)) or spellName
			local unit = list.unit or "player"
      
      if not TL.spells[spellID] then TL.spells[spellID] = {} end
      local spell = TL.spells[spellID]

      local icon, text, line
      if TL.create[category] then
        icon = TL.create[category](i, spell, list, spellID, spellName, unit)
      else
        return error("No update function for category: " .. category .. "!")
      end

      spell.index = i

      if icon then
        text, line = icon.text, icon.line
      end

			if category then
				if spellID then TL.categories[category][spellID] = spell end
				if spellName then TL.categories[category][spellName] = spell end
				tinsert(TL.categories[category], spell)

				if category == "cooldown" then
          local icon = spell.icon[1]
          local icon1 = spell.icon[1]
          local icon2 = spell.icon[2]
          local charges, chargeMax, start, duration = GetSpellCharges(spellID)

          if not charges then -- Don't want the second icon ever shown if it doesn't have a charge system
            icon2:Hide()
          else -- If it does, make sure it's showing stacks
            icon2.stackText:SetText(charges)
          end

					function spell:update()
            local frameWidth = TL:GetWidth()
            local edge = UIParent:GetRight() - TL.line:GetRight()

            local charges, chargeMax, start, duration = GetSpellCharges(spellID)

            if charges and chargeMax > charges then -- It has charges, so make sure both are shown and set text
              icon1:Show()
              icon2:Show()

              icon2.stackText:SetText(charges)
            else -- No charges, so only the first should be visible
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
              if icon.line then icon.line:Show() end
              if icon.text then icon.text:Show() end

              TL.active[icon] = function() -- Create the function in the active list
                local remaining = (start + duration) - GetTime()
                local x = ((frameWidth * remaining) / TOTAL_TIME)
                if x > edge then x = edge end -- Icon is off screen, adjust it

                if remaining <= 0 then
                  if icon.line then icon.line:Hide() end
                  if icon.text then icon.text:Hide() end

                  TL.active[icon] = nil -- Remove it from the active list

                  if spell.queued then -- There is at least one more charge on CD
                    spell.queued = false
                    spell:update()
                  else -- Shouldn't be any more charges
                    icon2.stackText:SetText(chargeMax)
                    spell.charges = false
                  end
                end

                icon:SetPoint("RIGHT", TL.line, x, 0)
                if icon.text then roundFormatted(icon.text, remaining) end
              end
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

            local frameWidth = TL:GetWidth()
            local x = (frameWidth * remaining) / TOTAL_TIME
            local edge = UIParent:GetRight() - TL.line:GetRight()
            if x > edge then x = edge end

            icon:SetPoint("RIGHT", TL.line, x, 0)

            TL.active[icon] = function()
              local remaining = total - GetTime()
              local x = (frameWidth * remaining) / TOTAL_TIME

              if edge > x then
                if 0 >= x then
                  x = 0
                  TL.active[icon] = nil

                  if icon.line then icon.line:Hide() end
                  if icon.text then icon.text:Hide() end
                end

                icon:SetPoint("RIGHT", TL.line, x, 0)
                if icon.text then roundFormatted(icon.text, remaining) end
              end
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

            local frameWidth = TL:GetWidth()
            local x = (frameWidth * remaining) / TOTAL_TIME
            local edge = UIParent:GetRight() - TL.line:GetRight()
            if x > edge then x = edge end

            icon:SetPoint("RIGHT", TL.line, x, 0)

            if icon.ticker then
              icon.ticker:Cancel()
              icon.ticker = nil
            end

            TL.active[icon] = function()
              local remaining = total - GetTime()
              local x = (frameWidth * remaining) / TOTAL_TIME

              if edge > x then
                if 0 >= x then
                  x = 0
                  TL.active[icon] = nil

                  if icon.line then icon.line:Hide() end
                  if icon.text then icon.text:Hide() end
                end

                icon:SetPoint("RIGHT", TL.line, x, 0)
                if icon.text then roundFormatted(icon.text, remaining) end
              end
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
            
            local wasCasting = TL.casting -- Was unit casting at the time this started?

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
              
              local startWidth = x

              local fill = TL:CreateTexture(nil, "ARTWORK")
              fill:SetTexture(1.0, 0.0, 0.0, 1.0)
              fill:SetHeight(ICON_HEIGHT - 2)
              fill:SetPoint("LEFT", hidden, "RIGHT")
              fill:SetPoint("RIGHT", TL.line, "LEFT")

              newTicker(0.001, function(ticker)
                local remaining = total - GetTime()
                
                if wasCasting and TL.interrupted and remaining >= 0 then -- It was started from a cast, but the cast ended
                  wasCasting = false
                  total = GetTime()
                  hidden:SetWidth(startWidth - ((frameWidth * remaining) / TOTAL_TIME))
                  remaining = 0
                end
                
                local x = (frameWidth * remaining) / TOTAL_TIME
                
                hidden:SetPoint("RIGHT", TL, "TOPLEFT", x, -((i - 1) * ICON_HEIGHT))
                
                if 0 > x then --  or (wasCasting and not TL.casting)
                  if hiddenLines[num + 1] and not hiddenLines[num + 1].set then -- This ticker's hidden texture is no longer the most recent one
                    fill:SetPoint("RIGHT", hiddenLines[num + 1], "LEFT")
                    
                    if 3 >= fill:GetWidth() then -- Don't let any that are very small show
                      fill:Hide()
                    end
                    
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

							if icon.line then icon.line:Show() end
							if icon.text then icon.text:Show() end
						end
					end
				elseif category == "rune" then
          function spell:update(rune, runeNum, index, start, duration, runeReady, remaining)
            local cTime = GetTime()

            local partner = rune.partner
            local partnerNum = partner.num

            if rune.line then rune.line:Show() end
            if rune.text then rune.text:Show() end

            local pStart, pDuration, pRuneReady = GetRuneCooldown(partnerNum)

            local remaining = (start + duration) - cTime
            local pRemaining = (pStart + pDuration) - cTime

            if pRuneReady then -- It's currently available, so rune shouldn't be offset
              rune.offset = nil
              partner.offset = nil
            elseif pRemaining > remaining then -- Current rune is lower, so it should be offset
              rune.offset = nil
              partner.offset = true
            elseif pRemaining <= remaining then
              rune.offset = true
              partner.offset = nil
            end

            local frameWidth = TL:GetWidth()
            local edge = UIParent:GetRight() - TL.line:GetRight()

            TL.active[rune] = function()
              local start, duration, runeReady = GetRuneCooldown(runeNum)

              if not runeReady and start > 0 then
                local remaining = (start + duration) - GetTime()
                if remaining > duration then remaining = duration end
                if remaining < 0 then remaining = 0 end
                local x = (frameWidth * remaining) / TOTAL_TIME

                if rune.offset then x = x + ICON_HEIGHT end
                if x > edge then x = edge end -- Icon is off screen, adjust it

                rune:SetPoint("RIGHT", TL.line, x, 0)
                if rune.text then roundFormatted(rune.text, remaining) end
              else
                TL.active[rune] = nil
                rune.offset = nil

                if rune.line then rune.line:Hide() end
                if rune.text then rune.text:Hide() end
              end
            end

              -- rune.ticker = newTicker(0.001, function(ticker)
              --   local start, duration, runeReady = GetRuneCooldown(runeNum)
              --
              --   if not runeReady and start > 0 then
              --     local remaining = (start + duration) - GetTime()
              --     if remaining > duration then remaining = duration end
              --     if remaining < 0 then remaining = 0 end
              --
              --     rune.remaining = remaining
              --
              --     local x = (frameWidth * remaining) / TOTAL_TIME
              --
              --     if rune.offset then x = x + ICON_HEIGHT end
              --     if x > edge then x = edge end -- Icon is off screen, adjust it
              --
              --     rune:SetPoint("RIGHT", TL.line, x, 0)
              --   else
              --     ticker:Cancel()
              --     rune.ticker = nil
              --     rune.remaining = nil
              --     rune.offset = nil
              --
              --     if rune.line then rune.line:Hide() end
              --     if rune.text then rune.text:Hide() end
              --   end
              -- end)
          end
        elseif category == "gcd" then
          function spell:update(startGCD, GCD)
            local frameWidth = TL:GetWidth()
            local edge = UIParent:GetRight() - TL.line:GetRight()
            
            local remaining = (startGCD + GCD) - GetTime()
            local x = ((frameWidth * remaining) / TOTAL_TIME)
            if x > edge then x = edge end

            icon:SetPoint("RIGHT", TL.line, x, 0)
            if icon.line then icon.line:Show() end
            if icon.text then icon.text:Show() end

            TL.active[icon] = function() -- Create the function in the active list
              local remaining = (startGCD + GCD) - GetTime()
              local x = ((frameWidth * remaining) / TOTAL_TIME)
              if x > edge then x = edge end -- Icon is off screen, adjust it

              if remaining <= 0 then
                if icon.line then icon.line:Hide() end
                if icon.text then icon.text:Hide() end

                TL.active[icon] = nil -- Remove it from the active list
              end

              icon:SetPoint("RIGHT", TL.line, x, 0)
              if icon.text then roundFormatted(icon.text, remaining) end
            end
          end
        elseif category == "castbar" then
          function spell:update()
            local cTime = GetTime()
            local frameWidth = TL:GetWidth()
            local edge = UIParent:GetRight() - TL.line:GetRight()
            
            local name, nameSubtext, text, texture, start, stop, tradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
            local startGCD, GCD = GetSpellCooldown(61304) -- This spellID checks the GCD specifically

            local castTime = ((stop or 0) - (start or 0)) / 1000
            local total = max(cTime + castTime, startGCD + GCD)
            local remaining = total - cTime
            
            local x = ((frameWidth * remaining) / TOTAL_TIME)
            if x > edge then x = edge end

            icon:SetPoint("RIGHT", TL.line, x, 0)
            if icon.line then icon.line:Show() end
            if icon.text then icon.text:Show() end

            TL.active[icon] = function() -- Create the function in the active list
              local remaining = total - GetTime()
              local x = ((frameWidth * remaining) / TOTAL_TIME)
              if x > edge then x = edge end -- Icon is off screen, adjust it

              if remaining <= 0 or (not TL.casting) then
                if icon.line then icon.line:Hide() end
                if icon.text then icon.text:Hide() end
                
                x = 0

                TL.active[icon] = nil -- Remove it from the active list
              end

              icon:SetPoint("RIGHT", TL.line, x, 0)
              if icon.text then roundFormatted(icon.text, remaining) end
            end
          end
        elseif category == "bigwigs" then
          if not TL.bigWigsRegistered then TL.registerBigWigs() end
          
          function spell:update(bar, iconTexture, name, start, duration, expiration, backdrop, background)
            local frameWidth = TL:GetWidth()
            local edge = UIParent:GetRight() - TL.line:GetRight()
            
            local remaining = expiration - GetTime()
            local x = ((frameWidth * remaining) / TOTAL_TIME)
            if x > edge then x = edge end
            
            local icon, text, line, sBar = nil, nil, nil, nil
            for i = 1, #spell.icons do -- Try to find a previously used icon that isn't active
              if spell.icons[i] and not spell.icons[i].active then
                icon = spell.icons[i]
                text = icon.text
                line = icon.line
                sBar = icon.bar
                
                icon:Show()
                break
              end
            end
            
            if not icon then -- Failed to find one, make a new one
              icon, text, line, sBar = TL.create.bigwigs(i, spell, list, spellID, spellName, unit)
            end
            
            icon.texture:SetTexture(iconTexture) -- Update the icon
            icon:SetPoint("RIGHT", TL.line, x, 0)
            
            if icon.line then icon.line:Show() end
            if icon.text then icon.text:Show() end
            if icon.bar then icon.bar:Show() end
            
            if sBar then
              local candyBar = bar.candyBarBar
              sBar.text:SetText(name)
              
              local texture = candyBar:GetStatusBarTexture():GetTexture()

              sBar:SetStatusBarTexture(texture)
              sBar:SetStatusBarColor(candyBar:GetStatusBarColor())
              sBar:SetMinMaxValues(0, 10)
              sBar:SetValue(candyBar:GetValue())
              sBar:SetAlpha(candyBar:GetAlpha())
              
              sBar:SetWidth(sBar.text:GetWidth())
            end
            
            if list.text and list.text == "title" then -- Make it display the name
              icon.text:SetText(name)
            end
            
            icon.active = true

            TL.active[icon] = function() -- Create the function in the active list
              local remaining = expiration - GetTime()
              local x = ((frameWidth * remaining) / TOTAL_TIME)
              if x > edge then x = edge end -- Icon is off screen, adjust it
              
              if sBar then
                sBar:SetStatusBarColor(bar.candyBarBar:GetStatusBarColor())
              end
              
              if (remaining <= 0) or (bar.remaining <= 0) or (not bar.running) then
                if icon.line then icon.line:Hide() end
                if icon.text then icon.text:Hide() end
                if icon.bar then icon.bar:Hide() end
                
                icon:Hide()
                icon.active = false
                TL.active[icon] = nil -- Remove it from the active list
              end

              icon:SetPoint("RIGHT", TL.line, x, 0)
              if icon.text and list.text ~= "title" then -- Should mean it's remaining, unless I add more text options
                local decimals = 0
                if 1 > remaining then decimals = 1 end
                roundFormatted(icon.text, remaining, decimals)
              end
            end
          end
        elseif category == "graph" then
          local frame, graph = spell.frame, spell.graph
          
          function spell:update(currentPower)
            debug("Update called", currentPower)
          end
				end
			end
		end
	end
end

function TL.registerBigWigs()
  if BigWigsLoader then
    TL.bigWigsRegistered = true
  else -- BigWigs probably isn't enabled
    return
  end
  
  local function BigWigs_BarCreated(message, plugin, bar, module, key, text, duration, iconTexture, isApprox)
    local originalText = text
    
    local backdrop = bar.candyBarBackdrop.GetTexture and bar.candyBarBackdrop:GetTexture()
    local background = bar.candyBarBackground.GetTexture and bar.candyBarBackground:GetTexture()
    
    -- debug(bar.candyBarBackdrop:GetStatusBarColor())
    
    -- debug(type(bar.candyBarBar))
    
    -- if candyBar then debug(candyBar:GetTexture()) end
    
    -- for k, v in pairs(bar) do
    --   debug(k, v)
    -- end
    
    local spellName, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(tonumber(key))
    
    if spellName and text:match(spellName) then
      local count = tonumber(text:match("%((.+)%)"))
      if count then
        text = ("%s (%d)"):format(spellName, count)
      else
        text = spellName
      end
    end
    
    if TL.categories.bigwigs[1] then
      for i = 1, #TL.categories.bigwigs do
        TL.categories.bigwigs[i]:update(bar, iconTexture, text, bar.start, bar.remaining, bar.exp, backdrop, background)
      end
    end
  end
  
  -- local function bigWigsStopBar(event, module, bestTime) -- Triggers when fight ends and bars are cancelled, also returned Best Time
  --   debug("Bar stop", event, module, bestTime)
  -- end
  
  -- local testBossName = "Hellfire Assault" -- NOTE: Testing only! Important to remove this!
  if testBossName then
    C_Timer.After(1, function()
      LoadAddOn("BigWigs_Core")
      LoadAddOn("BigWigs_HellfireCitadel")
    end)

    local function BigWigs_BossModuleRegistered(message, bossName, mod) -- When a boss mod is registered
    	if bossName == testBossName then
        mod:Enable()
        
        function mod:Say(key, msg, directPrint) -- Hook this to stop the /say spam
        end
        
        if mod.OnEngage then mod:OnEngage() end
        mod:OnBossEnable()
      end
    end
    
    local function BigWigs_PluginRegistered(message, name, mod) -- Need to enable plugins for them to work, only necessary for testing
  		if name == "Bars" then
  			mod:Enable()
  		end
    end
    
    BigWigsLoader:RegisterMessage("BigWigs_BossModuleRegistered", BigWigs_BossModuleRegistered)
    BigWigsLoader:RegisterMessage("BigWigs_PluginRegistered", BigWigs_PluginRegistered)
  end
  
  BigWigsLoader:RegisterMessage("BigWigs_BarCreated", BigWigs_BarCreated)
  -- BigWigsLoader:RegisterMessage("BigWigs_StopBar", bigWigsStopBar)
end

function TL.startCombat()
	TL.inCombat = true
	TL.combatStart = GetTime()
  TL.combatStop = nil
end

function TL.stopCombat()
	TL.inCombat = false
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
    if TL:IsShown() then
      TL:Hide()
    else
      TL:Show()
    end
  elseif command == "options" then
    if not TL.options then TL.createOptionsFrame() end

    if TL.options:IsVisible() then
      TL.options:Hide()
    else
      TL.options:Show()
    end
	elseif command == "show" then
		TL:Show()
	elseif command == "hide" then
		TL:Hide()
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

--------------------------------------------------------------------------------
-- Full explanation
--[[----------------------------------------------------------------------------
First of all, everything that should be edited happens in the setting sections, so
if you see the header for "Main frame and local tables", that's too far.

In this explanation, I'll be surrounding everything that refers to actual code
in the addon in single quotes, like 'local code = 37', to distinguish it from the
rest of this explanation text that is not code.

To add a new icon, first select the class section. For example, if you wanted to
add an icon for paladin, you're interested in the code starting with
'elseif CLASS == PALADIN then' and ending with 'elseif CLASS == PRIEST then'.

Between those lines, there is a function named for that class, like this:
'local function paladin(specName)'. This line is what starts a function, but
the code also needs to be told where the function stops. If you scroll down,
right before going onto the priest section, there will be a line that says:
'return list' then right below it a line that says 'end'. The 'end', as you
might expect, signifies the point where the function stops. Every new icon for
the class belongs INSIDE this function, between where the function is defined
and named and where it is ended. This particular function is a local function
that named 'paladin', and I'll be calling it "the paladin function".

Scroll back up to where the paladin function begins, where it says
'local function paladin(specName)', and a couple lines below that you'll see
the code: 'if specName == "Retribution" then', and if you go down beyond
that you'll find 'elseif specName == "Holy" then', and even farther down you'll
find 'elseif specName == "Protection" then', and finally, below that there will
be another 'end' statement.

Note that this section I just explained is just three simple
'if value == true then' checks. This function gets called when you log into
the game on a Paladin character, and when that happens the function passes
what's called an argument. This argument is called 'specName'. 'specName' is
just a simple variable value, and it contains the text for your currently
selected specialization.

So, then, still within the paladin function, the code checks "Is this specName
variable holding the text 'Retribution'? If it isn't, then is it holding the
text 'Holy'?, if still no, then is it 'Protection'?" Note that it will only
keep going to the later checks if it fails to pass. For example, if your
current spec is Holy, then it will try to match Ret, fail, check Holy,
and pass, and it will not go on to Protection.

Now, once it has figured out what specialization you currently have, then it
will run all the code that goes within that block of code. For example,
again let's say your spec is currently Holy. It will fail to match Retribution,
and it will NOT run any of the code between the lines
'if specName == "Retribution" then' and the line 'if specName == "Holy" then'.
That code, what's between the if/elseif checks only gets run when the check is
passed.

Between where it checks if you are Holy and where it checks if you are Prot
is where we define the new icons for that specific spec. In each of these
sections, there will be code that looks like this:

' list[-4] = {
    category = "castbar",
    line = true,
    lineColor = {0.5, 1.0, 0.5, 1},
    createBar = true,
  }'
  
This is creating an entry in the table that is called 'list'. You can see where
the table is created if you scroll back up to the top of the function, it'll
say 'local list = {}'. That's creating a local variable named list, and putting
a freshly created table in it. '{}' means "Create a new table" to the code.

Like with all variables, the name of 'list' is something that's pretty
arbitrary that I selected. I could name it 'THIS_IS_A_TABLE' or 't'.
It doesn't matter, it would work exactly the same.

Tables are the main way data is stored. For an example of how this works, I'll
show how to put some variables to a table. You do that like this:

'list[1] = 37'
'list[2] = 10'

The value right after 'list' that is in the brackets '[]' is what's called the
key to the value. The value is what's after the equals sign. So, as you'd
expect from a key, you use the key to access the value.

The function 'print()' is just a diagnostics tool that outputs anything that
is passed to it as an argument, so that you can see what it contains.
For example, look at this code:

'local value = 25'
'print(value)'

As you would expect, this would cause the number 25 to show up in chat,
which tells me what is contained in the variable named 'value'. Going back
to the table example, if I want to check what is the value unlocked with
the key of '1', I do this: 'print(list[1])' and that will make a 37 show up
in chat. However, if I did this: 'print(list[3])', it would print a 'nil',
because I didn't assign any value to the key of '3'. I can also do things
like this: 'print(list[1] + list[2])' which would print 47. Tables are actually
pretty simple, when you get down to it.

Now, the key for a table doesn't have to be a number. I could do the exact same
things if I set up the table entries with different keys, like this:

'list["THIS IS A KEY"] = 37'
'list[176] = 10'

If I then did 'print(list["THIS IS A KEY"] + list[176])' it would still be doing
the exact same thing as before, which is just 37 + 10, making a 47 in chat.
The key just gives you whatever is stored in its value.

Its value doesn't have to be a number either. I could do this:
'list[1] = "Some value text"', and as you'd expect, 'print(list[1])' would
put the text "Some value text" into chat. Or, it could be another table.
This is called a nested table, because it's a table within a table. That may
sound confusing, but think of it in exactly the same terms. It's pretty
simple to understand that I could write this:

'local myTable = {}'

and now the variable called 'myTable' holds a table. Doing this:

'list[1] = {}'

is exactly the same sort of thing. Now, contained within the list table is
another table, and to access that table, I use the key of '1'. Now, this finally
brings me back to this code:

' list[-4] = {
    category = "castbar",
    line = true,
    lineColor = {0.5, 1.0, 0.5, 1},
    createBar = true,
  }'
  
I'm sure it looks confusing, but break it down and see what each of the
different parts are doing. First of all, we're assigning a value to
'list[-4]', so '-4' is the key to accessing that value. The value we're putting
there is a table, just the same as if I did this:

'list[-4] = {}'

You can see the closing } at the end of code. The reason the example from the
addon looks different is because I'm putting keys and values in the newly
created table. So, the first bit inside the new table is:

'category = "castbar",'

That is just assigning a new value, '"castbar"', to the key, 'category'. It
could also be written like this:

'list[-4] = {}'
'list[-4]["category"] = "castbar"'

It's exactly the same. It's just creating a table with a key of '-4' and
accessing the new table and assigning the key of 'category' to the value of
'"castbar"'. If the above example makes sense, then you understand the real
code from the addon that I'm explaining. They are different ways of writing
the same thing.

Continuing on, I then assign the value of 'true' to the key of 'line', then
comes another one that may look a bit confusing, but don't worry, it's more
of exactly the same thing, just written slightly differently.

'lineColor = {0.5, 1.0, 0.5, 1}'

is creating another table, within the 'list[-4]' table, and assigning it the
key of 'lineColor'. I'm putting 4 values into this brand new table. Now, you
might notice that there are no keys. However, once again, this is a different
way of writing the same thing. All three of these chunks of code are exactly
the same:

'lineColor = {0.5, 1.0, 0.5, 1}'

'lineColor = {
  [1] = 0.5,
  [2] = 1.0,
  [3] = 0.5,
  [4] = 1,
}'

'lineColor = {}'
'lineColor[1] = 0.5'
'lineColor[2] = 1.0'
'lineColor[3] = 0.5'
'lineColor[4] = 1'

The last example is probably the easiest to understand, but they are the same.
Since in the first one I'm not supplying any keys, the Lua interpretor is
automatically adding them, starting with '1', then '2', etc. I don't have to
actually specify the keys, like in the second and third examples.

]]------------------------------------------------------------------------------
-- Creating a new icon example
--[[----------------------------------------------------------------------------
Here's how to actually create your own new icon.

First, you must choose a key for the new entry in the 'list' table. This should
be a number, between -100 and 100. For this example, I'll use the number 5. The
number you select determines where it will position the icon. 'list[0]' would be
right in the middle, 'list[-5]' would be closer to the top of the screen,
and 'list[5]' is, of course, lower down. I create the new entry like this:

'list[5] = {

}'

Now it's time to fill this newly created table with values that are going to be
read by the addon later and used to tell it exactly how an icon should be setup.

The order doesn't matter, but I'll start with the 'category' value. I'll make
this new icon be a cooldown, so I want the category to be cooldown, like this:

'list[5] = {
  category = "cooldown",
}'

Now when the addon runs this list entry, it will check what the value of the
category is, and that will tell it what type of icon it should create. Every
new icon must have a category assigned.

Okay, now that I've told it that it should be a cooldown, I need to tell it
which cooldown it's suppose to be tracking. This is done by either adding a
'name' entry or an 'ID' entry, or both!

'list[5] = {
  category = "cooldown",
  ID = 20473,
  name = "Holy Shock",
}'

Now it has both the ID and the name of the spell I want to track. It isn't
necessary to have both, it will try to find the ID if you only give it a name
and it will find the name if you only give it an ID. When in doubt, find the
exact spellID, because that guarantees it'll track the correct thing.

This is all we need to create a new cooldown icon for Holy Shock. However,
there are more things that can be added, if we want to.

If you want to give it a vertical line attatched to the right side of the icon,
add this: 'line = true,' in exactly the same manner as the other values. This
tells it a line should be created to go with this icon. By default, it will
attatch this line from the top of the screen to the bottom. If you want to
override this and give it a specific height, add the key 'lineHeight', and
give it a number value, like this: 'lineHeight = 100'. Now it would be centered
on the icon and be 100 pixels tall.

If you don't want it to be centered on the icon, you could use the key
'lineAnchor' with the values of either '"TOP"' or '"BOTTOM"'. All of these
together looks like this:

'list[5] = {
  category = "cooldown",
  ID = 20473,
  name = "Holy Shock",
  line = true,
  lineHeight = 100,
  lineAnchor = "BOTTOM",
}'
]]
