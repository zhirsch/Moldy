local MoldyShowCaster = Moldy:NewModule("ShowCaster", "AceHook-3.0")

local function AddDoubleLine(tooltip, name, value)
	if name and value then
		tooltip:AddDoubleLine(name, value, nil, nil, nil, 1, 1, 1)
		tooltip:Show()
	end
end

local function AuraHook(tooltip, unit, index, filter)
	local _, _, _, _, _, _, caster, _, _, spellId = UnitAura(unit, index, filter)
	AddDoubleLine(tooltip, "Cast by:", caster and UnitName(caster))
	AddDoubleLine(tooltip, "Spell ID:", spellId)
end

local function SpellHook(tooltip, ...)
	local _, spellId = tooltip:GetSpell()
	AddDoubleLine(tooltip, "Spell ID:", spellId)
end

MoldyShowCaster:SecureHook(GameTooltip, "SetUnitAura",      AuraHook)
MoldyShowCaster:SecureHook(GameTooltip, "SetSpellByID",     SpellHook)
MoldyShowCaster:SecureHook(GameTooltip, "AddSpellByID",     SpellHook)
MoldyShowCaster:SecureHook(GameTooltip, "SetSpellBookItem", SpellHook)
MoldyShowCaster:SecureHook(GameTooltip, "SetAction",        SpellHook)
