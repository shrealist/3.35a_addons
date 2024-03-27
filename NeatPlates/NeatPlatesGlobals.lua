NEATPLATES_IS_CLASSIC_WOTLKC = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
NEATPLATES_IS_CLASSIC_TBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
NEATPLATES_IS_CLASSIC_ERA = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
NEATPLATES_IS_CLASSIC = NEATPLATES_IS_CLASSIC_TBC or NEATPLATES_IS_CLASSIC_ERA or NEATPLATES_IS_CLASSIC_WOTLKC
NEATPLATES_IS_CLASSIC=0
local wowversion, wowbuild, wowdate, wowtocversion = GetBuildInfo()
if wowtocversion and (wowtocversion > 90000 or (NEATPLATES_IS_CLASSIC and wowtocversion >= 11400)) then
	--NeatPlatesBackdrop = "BackdropTemplate"
end

-- Fill CUSTOM_CLASS_COLORS with the default colors
NEATPLATES_CLASS_COLORS = {}
for class, color in pairs(RAID_CLASS_COLORS) do
	NEATPLATES_CLASS_COLORS[class] = {r = color.r, g = color.g, b = color.b}
end


Enum = {}
Enum.PowerType = {}
Enum.PowerType.Mana = 0
Enum.PowerType.Rage = 1
Enum.PowerType.Focus = 2
Enum.PowerType.Energy = 3
Enum.PowerType.ComboPoints = 4
Enum.PowerType.Runes = 5
Enum.PowerType.RunicPower = 6
Enum.PowerType.SoulShards = 7
Enum.PowerType.LunarPower = 8
Enum.PowerType.HolyPower = 9
Enum.PowerType.Alternate = 10
Enum.PowerType.Maelstrom = 11
Enum.PowerType.Chi = 12
Enum.PowerType.Insanity = 13
Enum.PowerType.Obsolete = 14
Enum.PowerType.Obsolete2 = 15
Enum.PowerType.ArcaneCharges = 16
Enum.PowerType.Fury = 17
Enum.PowerType.Pain = 18


function IsInGroup()
	return GetNumPartyMembers() > 1 or GetNumRaidMembers() > 1
end