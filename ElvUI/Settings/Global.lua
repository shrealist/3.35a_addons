local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

--Global Settings
G.general = {
	UIScale = 0.7111111111111111,
	version = 6.09,
	versionCheck = true,
	locale = "auto",
	eyefinity = false,
	ignoreScalePopup = false,
	smallerWorldMap = true,
	fadeMapWhenMoving = true,
	mapAlphaWhenMoving = 0.35,
	AceGUI = {
		width = 1000,
		height = 720
	},
	WorldMapCoordinates = {
		enable = true,
		position = "BOTTOMLEFT",
		xOffset = 0,
		yOffset = 0
	}
}

G.classtimer = {}

G.chat = {
	classColorMentionExcludedNames = {},
}

G.bags = {
	ignoredItems = {},
}

G.nameplates = {}

G.unitframe = {
	aurafilters = {},
	buffwatch = {},
	raidDebuffIndicator = {
		instanceFilter = "RaidDebuffs",
		otherFilter = "CCDebuffs",
	},
	spellRangeCheck = {
		PRIEST = {
			enemySpells = {
				[585] = true, -- Smite (30 yards)
			},
			longEnemySpells = {
				[589] = true, -- Shadow Word: Pain (30 yards)
			},
			friendlySpells = {
				[2050] = true, -- Lesser Heal (40 yards)
			},
			resSpells = {
				[2006] = true, -- Resurrection (40 yards)
			},
			petSpells = {},
		},
		DRUID = {
			enemySpells = {
				[33786] = true, -- Cyclone (20 yards)
			},
			longEnemySpells = {
				[5176] = true, -- Wrath (30 yards)
			},
			friendlySpells = {
				[5185] = true, -- Healing Touch (40 yards)
			},
			resSpells = {
				[50769] = true, -- Revive (30 yards)
				[20484] = true, -- Rebirth (30 yards)
			},
			petSpells = {},
		},
		PALADIN = {
			enemySpells = {
				[20271] = true, -- Judgement (10 yards)
			},
			longEnemySpells = {
				[879] = true, -- Exorcism (30 yards)
			},
			friendlySpells = {
				[635] = true, -- Holy Light (40 yards)
			},
			resSpells = {
				[7328] = true, -- Redemption (30 yards)
			},
			petSpells = {},
		},
		SHAMAN = {
			enemySpells = {
				[51514] = true, -- Hex (20 yards)
				[8042] = true, -- Earth Shock (25 yards)
			},
			longEnemySpells = {
				[403] = true, -- Lightning Bolt (30 yards)
			},
			friendlySpells = {
				[331] = true, -- Healing Wave (40 yards)
			},
			resSpells = {
				[2008] = true, -- Ancestral Spirit (30 yards)
			},
			petSpells = {},
		},
		WARLOCK = {
			enemySpells = {
				[5782] = true, -- Fear (20 yards)
			},
			longEnemySpells = {
				[686] = true, -- Shadow Bolt (30 yards)
			},
			friendlySpells = {
				[5697] = true, -- Unending Breath (30 yards)
			},
			resSpells = {},
			petSpells = {
				[755] = true, -- Health Funnel (45 yards)
			},
		},
		MAGE = {
			enemySpells = {
				[2136] = true, -- Fire Blast (20 yards)
				[12826] = true, -- Polymorph (30 yards)
			},
			longEnemySpells = {
				[133] = true, -- Fireball (35 yards)
				[44614] = true, -- Frostfire Bolt (40 yards)
			},
			friendlySpells = {
				[475] = true, -- Remove Curse (40 yards)
			},
			resSpells = {},
			petSpells = {},
		},
		HUNTER = {
			enemySpells = {
				[75] = true, -- Auto Shot (35 yards)
			},
			longEnemySpells = {},
			friendlySpells = {},
			resSpells = {},
			petSpells = {
				[136] = true, -- Mend Pet (45 yards)
			},
		},
		DEATHKNIGHT = {
			enemySpells = {
				[49576] = true, -- Death Grip (30 yards)
			},
			longEnemySpells = {},
			friendlySpells = {
				[47541] = true, -- Death Coil (40 yards)
			},
			resSpells = {
				[61999] = true, -- Raise Ally (30 yards)
			},
			petSpells = {},
		},
		ROGUE = {
			enemySpells = {
				[2094] = true, -- Blind (10 yards)
			},
			longEnemySpells = {
				[26679] = true, -- Deadly Throw (30 yards)
			},
			friendlySpells = {
				[57934] = true, -- Tricks of the Trade (20 yards)
			},
			resSpells = {},
			petSpells = {},
		},
		WARRIOR = {
			enemySpells = {
				[5246] = true, -- Intimidating Shout (8 yards)
				[100] = true, -- Charge (25 yards)
			},
			longEnemySpells = {
				[355] = true, -- Taunt (30 yards)
			},
			friendlySpells = {
				[3411] = true, -- Intervene (25 yards)
			},
			resSpells = {},
			petSpells = {},
		}
	}
}

G.profileCopy = {
	--Specific values
	selected = "Minimalistic",
	movers = {},
	--Modules
	actionbar = {
		general = true,
		bar1 = true,
		bar2 = true,
		bar3 = true,
		bar4 = true,
		bar5 = true,
		bar6 = true,
		barPet = true,
		stanceBar = true,
		microbar = true,
		cooldown = true
	},
	auras = {
		general = true,
		buffs = true,
		debuffs = true,
		cooldown = true
	},
	bags = {
		general = true,
		split = true,
		vendorGrays = true,
		bagBar = true,
		cooldown = true
	},
	chat = {
		general = true
	},
	cooldown = {
		general = true,
		fonts = true
	},
	databars = {
		experience = true,
		reputation = true
	},
	datatexts = {
		general = true,
		panels = true
	},
	general = {
		general = true,
		minimap = true,
		threat = true,
		totems = true
	},
	nameplates = {
		general = true,
		cooldown = true,
		reactions = true,
		threat = true,
		units = {
			FRIENDLY_PLAYER = true,
			ENEMY_PLAYER = true,
			FRIENDLY_NPC = true,
			ENEMY_NPC = true
		}
	},
	tooltip = {
		general = true,
		visibility = true,
		healthBar = true
	},
	unitframe = {
		general = true,
		cooldown = true,
		colors = {
			general = true,
			power = true,
			reaction = true,
			healPrediction = true,
			classResources = true,
			frameGlow = true,
			debuffHighlight = true
		},
		units = {
			player = true,
			target = true,
			targettarget = true,
			targettargettarget = true,
			focus = true,
			focustarget = true,
			pet = true,
			pettarget = true,
			boss = true,
			arena = true,
			party = true,
			raid = true,
			raid40 = true,
			raidpet = true,
			tank = true,
			assist = true
		}
	}
}

C_Timer = {}
function C_Timer.After(delay, f)
	LibStub("AceTimer-3.0"):ScheduleTimer(f, delay)
end

EnumUtil = {};

function tInvert(tbl)
	local inverted = {};
	for k, v in pairs(tbl) do
		inverted[v] = k;
	end
	return inverted;
end

function EnumUtil.MakeEnum(...)
	return tInvert({...});
end

function EnumUtil.IsValid(enumClass, enumValue)
	return tContains(enumClass, enumValue);
end

function EnumUtil.GenerateNameTranslation(enum)
	return function (enumValue)
		for key, value in pairs(enum) do
			if value == enumValue then
				return key;
			end
		end

		return UNKNOWN..enumValue;
	end
end

AuraUtil = {};
print("aurautil")

-- For backwards compatibility with old APIs, this helper function returns aura data values unpacked in the same order as before.
function AuraUtil.UnpackAuraData(auraData)
	if not auraData then
		return nil;
	end

	return auraData.name,
		auraData.icon,
		auraData.applications,
		auraData.dispelName,
		auraData.duration,
		auraData.expirationTime,
		auraData.sourceUnit,
		auraData.isStealable,
		auraData.nameplateShowPersonal,
		auraData.spellId,
		auraData.canApplyAura,
		auraData.isBossAura,
		auraData.isFromPlayerOrPlayerPet,
		auraData.nameplateShowAll,
		auraData.timeMod,
		unpack(auraData.points);
end

local function FindAuraRecurse(predicate, unit, filter, auraIndex, predicateArg1, predicateArg2, predicateArg3, ...)
	if ... == nil then
		return nil; -- Not found
	end
	if predicate(predicateArg1, predicateArg2, predicateArg3, ...) then
		return ...;
	end
	auraIndex = auraIndex + 1;
	return FindAuraRecurse(predicate, unit, filter, auraIndex, predicateArg1, predicateArg2, predicateArg3, AuraUtil.UnpackAuraData(C_UnitAuras.GetAuraDataByIndex(unit, auraIndex, filter)));
end

-- Find an aura by any predicate, you can pass in up to 3 predicate specific parameters
-- The predicate will also receive all aura params, if the aura data matches return true
function AuraUtil.FindAura(predicate, unit, filter, predicateArg1, predicateArg2, predicateArg3)
	local auraIndex = 1;
	return FindAuraRecurse(predicate, unit, filter, auraIndex, predicateArg1, predicateArg2, predicateArg3, AuraUtil.UnpackAuraData(C_UnitAuras.GetAuraDataByIndex(unit, auraIndex, filter)));
end

-- Finds the first aura that matches the name
-- Notes:
--		aura names are not unique!
--		aura names are localized, what works in one locale might not work in another
--			consider that in English two auras might have different names, but once localized they have the same name, so even using the localized aura name in a search it could result in different behavior
--		the unit could have multiple auras with the same name, this will only find the first
function AuraUtil.FindAuraByName(auraName, unit, filter)
	--return AuraUtil.UnpackAuraData(C_UnitAuras.GetAuraDataBySpellName(unit, auraName, filter));
	return nil
end

-- do
-- 	local function ForEachAuraHelper(unit, filter, func, usePackedAura, continuationToken, ...)
-- 		-- continuationToken is the first return value of UnitAuraSlots()
-- 		local n = select('#', ...);
-- 		for i=1, n do
-- 			local slot = select(i, ...);
-- 			local done;
-- 			local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
-- 			if usePackedAura then
-- 				done = func(auraInfo);
-- 			else
-- 				done = func(AuraUtil.UnpackAuraData(auraInfo));
-- 			end
-- 			if done then
-- 				-- if func returns true then no further slots are needed, so don't return continuationToken
-- 				return nil;
-- 			end
-- 		end
-- 		return continuationToken;
-- 	end

-- 	function AuraUtil.ForEachAura(unit, filter, maxCount, func, usePackedAura)
-- 		if maxCount and maxCount <= 0 then
-- 			return;
-- 		end
-- 		local continuationToken;
-- 		repeat
-- 			-- continuationToken is the first return value of UnitAuraSltos
-- 			continuationToken = ForEachAuraHelper(unit, filter, func, usePackedAura, C_UnitAuras.GetAuraSlots(unit, filter, maxCount, continuationToken));
-- 		until continuationToken == nil;
-- 	end
-- end

function AuraUtil.DefaultAuraCompare(a, b)
	local aFromPlayer = (a.sourceUnit ~= nil) and UnitIsUnit("player", a.sourceUnit) or false;
	local bFromPlayer = (b.sourceUnit ~= nil) and UnitIsUnit("player", b.sourceUnit) or false;
	if aFromPlayer ~= bFromPlayer then
		return aFromPlayer;
	end

	if a.canApplyAura ~= b.canApplyAura then
		return a.canApplyAura;
	end

	return a.auraInstanceID < b.auraInstanceID;
end

AuraUtil.AuraFilters =
{
	Helpful = "HELPFUL",
	Harmful = "HARMFUL",
	Raid = "RAID",
	IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
	Player = "PLAYER",
	Cancelable = "CANCELABLE",
	NotCancelable = "NOT_CANCELABLE",
	Maw = "MAW",
};

function AuraUtil.CreateFilterString(...)
	return table.concat({...}, '|');
end

AuraUtil.DispellableDebuffTypes =
{
	Magic = true,
	Curse = true,
	Disease = true,
	Poison = true
};

AuraUtil.AuraUpdateChangedType = EnumUtil.MakeEnum(
	"None",
	"Debuff",
	"Buff",
	"Dispel"
);

AuraUtil.UnitFrameDebuffType = EnumUtil.MakeEnum(
	"BossDebuff",
	"BossBuff",
	"PriorityDebuff",
	"NonBossRaidDebuff",
	"NonBossDebuff"
);

function AuraUtil.UnitFrameDebuffComparator(a, b)
	if a.debuffType ~= b.debuffType then
		return a.debuffType < b.debuffType;
	end

	return AuraUtil.DefaultAuraCompare(a, b);
end

function AuraUtil.ProcessAura(aura, displayOnlyDispellableDebuffs, ignoreBuffs, ignoreDebuffs, ignoreDispelDebuffs)
	if aura == nil then
		return AuraUtil.AuraUpdateChangedType.None;
	end

	if aura.isNameplateOnly then
		return AuraUtil.AuraUpdateChangedType.None;
	end

	if aura.isBossAura and not aura.isRaid and not ignoreDebuffs then
		aura.debuffType = aura.isHarmful and AuraUtil.UnitFrameDebuffType.BossDebuff or AuraUtil.UnitFrameDebuffType.BossBuff;
		return AuraUtil.AuraUpdateChangedType.Debuff;
	elseif aura.isHarmful and not aura.isRaid and not ignoreDebuffs then
		if AuraUtil.IsPriorityDebuff(aura.spellId) then
			aura.debuffType = AuraUtil.UnitFrameDebuffType.PriorityDebuff;
			return AuraUtil.AuraUpdateChangedType.Debuff;
		elseif not displayOnlyDispellableDebuffs and AuraUtil.ShouldDisplayDebuff(aura.sourceUnit, aura.spellId) then
			aura.debuffType = AuraUtil.UnitFrameDebuffType.NonBossDebuff;
			return AuraUtil.AuraUpdateChangedType.Debuff;
		end
	elseif aura.isHelpful and not ignoreBuffs and AuraUtil.ShouldDisplayBuff(aura.sourceUnit, aura.spellId, aura.canApplyAura) then
		aura.isBuff = true;
		return AuraUtil.AuraUpdateChangedType.Buff;
	elseif aura.isHarmful and aura.isRaid then
		if displayOnlyDispellableDebuffs and not ignoreDebuffs and not aura.isBossAura and AuraUtil.ShouldDisplayDebuff(aura.sourceUnit, aura.spellId) and not AuraUtil.IsPriorityDebuff(aura.spellId) then
			aura.debuffType = AuraUtil.UnitFrameDebuffType.NonBossRaidDebuff;
			return AuraUtil.AuraUpdateChangedType.Debuff;
		elseif not ignoreDispelDebuffs and AuraUtil.DispellableDebuffTypes[aura.dispelName] ~= nil then
			aura.debuffType = aura.isBossAura and AuraUtil.UnitFrameDebuffType.BossDebuff or AuraUtil.UnitFrameDebuffType.NonBossRaidDebuff;
			return AuraUtil.AuraUpdateChangedType.Dispel;
		end
	end
	
	return AuraUtil.AuraUpdateChangedType.None;
end

-- do
-- 	-- Cache securecallfunction in case it changes in the global environment
-- 	local securecallfunction = securecallfunction;

-- 	local hasValidPlayer = false;
-- 	EventRegistry:RegisterFrameEvent("PLAYER_ENTERING_WORLD");
-- 	EventRegistry:RegisterFrameEvent("PLAYER_LEAVING_WORLD");
-- 	EventRegistry:RegisterCallback("PLAYER_ENTERING_WORLD", function()
-- 		hasValidPlayer = true;
-- 	end, {});
-- 	EventRegistry:RegisterCallback("PLAYER_LEAVING_WORLD", function()
-- 		hasValidPlayer = false;
-- 	end, {});

-- 	local cachedVisualizationInfo = {};
	
-- 	-- Visualization info is specific to the spec it was checked under
-- 	EventRegistry:RegisterFrameEvent("PLAYER_SPECIALIZATION_CHANGED");
-- 	EventRegistry:RegisterCallback("PLAYER_SPECIALIZATION_CHANGED", function()
-- 		cachedVisualizationInfo = {};
-- 	end, {});

-- 	local function GetCachedVisibilityInfo(spellId)
-- 		if cachedVisualizationInfo[spellId] == nil then
-- 			local newInfo = {SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT")};
-- 			if not hasValidPlayer then
-- 				-- Don't cache the info if the player is not valid since we didn't get a valid result
-- 				return unpack(newInfo);
-- 			end
-- 			cachedVisualizationInfo[spellId] = newInfo;
-- 		end

-- 		local info = cachedVisualizationInfo[spellId];
-- 		return unpack(info);
-- 	end

-- 	function AuraUtil.ShouldDisplayDebuff(unitCaster, spellId)
-- 		local hasCustom, alwaysShowMine, showForMySpec = securecallfunction(GetCachedVisibilityInfo, spellId);
-- 		if ( hasCustom ) then
-- 			return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") );	--Would only be "mine" in the case of something like forbearance.
-- 		else
-- 			return true;
-- 		end
-- 	end

-- 	local cachedSelfBuffChecks = {};
-- 	local function CheckIsSelfBuff(spellId)
-- 		if cachedSelfBuffChecks[spellId] == nil then
-- 			cachedSelfBuffChecks[spellId] = SpellIsSelfBuff(spellId);
-- 		end

-- 		return cachedSelfBuffChecks[spellId];
-- 	end

-- 	function AuraUtil.ShouldDisplayBuff(unitCaster, spellId, canApplyAura)
-- 		local hasCustom, alwaysShowMine, showForMySpec = securecallfunction(GetCachedVisibilityInfo, spellId);
	
-- 		if ( hasCustom ) then
-- 			return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
-- 		else
-- 			return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not securecallfunction(CheckIsSelfBuff, spellId);
-- 		end
-- 	end

-- 	local cachedPriorityChecks = {};
-- 	local function CheckIsPriorityAura(spellId)
-- 		if cachedPriorityChecks[spellId] == nil then
-- 			cachedPriorityChecks[spellId] = SpellIsPriorityAura(spellId);
-- 		end

-- 		return cachedPriorityChecks[spellId];
-- 	end

-- 	local _, classFilename = UnitClass("player");
-- 	if ( classFilename == "PALADIN" ) then
-- 		AuraUtil.IsPriorityDebuff = function(spellId)
-- 			local isForbearance = (spellId == 25771);
-- 			return isForbearance or securecallfunction(CheckIsPriorityAura, spellId);
-- 		end
-- 	else
-- 		AuraUtil.IsPriorityDebuff = function(spellId)
-- 			return securecallfunction(CheckIsPriorityAura, spellId);
-- 		end
-- 	end

-- 	local function DumpCaches()
-- 		cachedVisualizationInfo = {};
-- 		cachedSelfBuffChecks = {};
-- 		cachedPriorityChecks = {};
-- 	end
-- 	EventRegistry:RegisterFrameEvent("PLAYER_REGEN_ENABLED");
-- 	EventRegistry:RegisterFrameEvent("PLAYER_REGEN_DISABLED");
-- 	EventRegistry:RegisterCallback("PLAYER_REGEN_ENABLED", DumpCaches, {});
-- 	EventRegistry:RegisterCallback("PLAYER_REGEN_DISABLED", DumpCaches, {});
-- end