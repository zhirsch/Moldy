local CLASS_WEAPON_TYPES = {
    DEATHKNIGHT = {
        [Enum.ItemWeaponSubclass.Axe1H]    = true,
        [Enum.ItemWeaponSubclass.Axe2H]    = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Mace2H]   = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Sword2H]  = true,
        [Enum.ItemWeaponSubclass.Polearm]  = true,
    },
    DRUID = {
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Unarmed]  = true,
        [Enum.ItemWeaponSubclass.Polearm]  = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Mace2H]   = true,
    },
    HUNTER = {
        [Enum.ItemWeaponSubclass.Axe1H]    = true,
        [Enum.ItemWeaponSubclass.Axe2H]    = true,
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Unarmed]  = true,
        [Enum.ItemWeaponSubclass.Polearm]  = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Sword2H]  = true,
        [Enum.ItemWeaponSubclass.Bows]     = true,
        [Enum.ItemWeaponSubclass.Crossbow] = true,
        [Enum.ItemWeaponSubclass.Guns]     = true,
    },
    MAGE = {
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Wand]     = true,
    },
    MONK = {
        [Enum.ItemWeaponSubclass.Axe1H]    = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Unarmed]  = true,
        [Enum.ItemWeaponSubclass.Polearm]  = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
    },
    PALADIN = {
        [Enum.ItemWeaponSubclass.Axe1H]    = true,
        [Enum.ItemWeaponSubclass.Axe2H]    = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Mace2H]   = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Sword2H]  = true,
        [Enum.ItemWeaponSubclass.Polearm]  = true,
    },
    PRIEST = {
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
        [Enum.ItemWeaponSubclass.Wand]     = true,
    },
    ROGUE = {
        [Enum.ItemWeaponSubclass.Axe1H]    = true,
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Unarmed]  = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Bows]     = true,
        [Enum.ItemWeaponSubclass.Crossbow] = true,
        [Enum.ItemWeaponSubclass.Guns]     = true,
        [Enum.ItemWeaponSubclass.Thrown]   = true,
    },
    SHAMAN = {
        [Enum.ItemWeaponSubclass.Axe1H]    = true,
        [Enum.ItemWeaponSubclass.Axe2H]    = true,
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Unarmed]  = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Mace2H]   = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
    },
    WARLOCK = {
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Wand]     = true,
    },
    WARRIOR = {
        [Enum.ItemWeaponSubclass.Axe1H]    = true,
        [Enum.ItemWeaponSubclass.Axe2H]    = true,
        [Enum.ItemWeaponSubclass.Dagger]   = true,
        [Enum.ItemWeaponSubclass.Unarmed]  = true,
        [Enum.ItemWeaponSubclass.Mace1H]   = true,
        [Enum.ItemWeaponSubclass.Mace2H]   = true,
        [Enum.ItemWeaponSubclass.Polearm]  = true,
        [Enum.ItemWeaponSubclass.Staff]    = true,
        [Enum.ItemWeaponSubclass.Sword1H]  = true,
        [Enum.ItemWeaponSubclass.Sword2H]  = true,
        [Enum.ItemWeaponSubclass.Bows]     = true,
        [Enum.ItemWeaponSubclass.Crossbow] = true,
        [Enum.ItemWeaponSubclass.Guns]     = true,
        [Enum.ItemWeaponSubclass.Thrown]   = true,
    },
}

local CLASS_ARMOR_SPECIALIZATIONS = {
    DEATHKNIGHT = { specialization = Enum.ItemArmorSubclass.Plate,   spells = { 86113, 86536, 86537 } },
    DRUID       = { specialization = Enum.ItemArmorSubclass.Leather, spells = { 86093, 86096, 86097, 86104 } },
    HUNTER      = { specialization = Enum.ItemArmorSubclass.Mail,    spells = { 86538 } },
    --MAGE        = { specialization = Enum.ItemArmorSubclass.Cloth,   spells = {} },
    MONK        = { specialization = Enum.ItemArmorSubclass.Leather, spells = { 120224, 120225, 120227 } },
    PALADIN     = { specialization = Enum.ItemArmorSubclass.Plate,   spells = { 86102, 86103, 86539 } },
    --PRIEST      = { specialization = Enum.ItemArmorSubclass.Cloth,   spells = {} },
    ROGUE       = { specialization = Enum.ItemArmorSubclass.Leather, spells = { 86092 } },
    SHAMAN      = { specialization = Enum.ItemArmorSubclass.Mail,    spells = { 86099, 86100, 86108 } },
    --WARLOCK     = { specialization = Enum.ItemArmorSubclass.Cloth,   spells = {} },
    WARRIOR     = { specialization = Enum.ItemArmorSubclass.Plate,   spells = { 86101, 86110, 86535 } },
}

local function IsPrimaryStat(unit, itemLink)
    if unit ~= "player" then
        return nil
    end
    local _, _, _, _, _, primaryStat = PlayerUtil.GetCurrentSpecID()
    local stats = GetItemStats(itemLink)
    if     not primaryStat  then return true
    elseif not stats        then return true
    elseif primaryStat == 1 then return (stats["ITEM_MOD_STRENGTH_SHORT"]  or 0) > 0
    elseif primaryStat == 2 then return (stats["ITEM_MOD_AGILITY_SHORT"]   or 0) > 0
    elseif primaryStat == 4 then return (stats["ITEM_MOD_INTELLECT_SHORT"] or 0) > 0
    end
    return false
end

local function IsWeaponTypeUseable(unit, itemLink)
    local className = UnitClassBase(unit)
    local _, _, _, _, _, _, _, _, _, _, _, _, subclassId = C_Item.GetItemInfo(itemLink)
    return (not not CLASS_WEAPON_PROFICIENCIES[className][subclassId]) and IsPrimaryStat(unit, itemLink)
end

local function IsArmorSpecializationActive(className, subclassId)
    local info = CLASS_ARMOR_SPECIALIZATIONS[className]
    if not info then
        return false
    end
    for _, spellId in ipairs(info.spells) do
        if IsPlayerSpell(spellId) then
            return info.specialization == subclassId
        end
    end
    return false
end

local function IsArmorTypeUseable(unit, itemLink)
    local className = UnitClassBase(unit)
    local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, subclassId = C_Item.GetItemInfo(itemLink)
    local info = CLASS_ARMOR_SPECIALIZATIONS[className]
    if     IsArmorSpecializationActive(className, subclassId) then return IsPrimaryStat(unit, itemLink)
    elseif itemEquipLoc == "INVTYPE_CLOAK"                    then return IsPrimaryStat(unit, itemLink)
    elseif subclassId == Enum.ItemArmorSubclass.Generic       then return true
    elseif subclassId == Enum.ItemArmorSubclass.Cloth         then return IsPlayerSpell(9078) and IsPrimaryStat(unit, itemLink)
    elseif subclassId == Enum.ItemArmorSubclass.Leather       then return IsPlayerSpell(9077) and IsPrimaryStat(unit, itemLink)
    elseif subclassId == Enum.ItemArmorSubclass.Mail          then return IsPlayerSpell(8737) and IsPrimaryStat(unit, itemLink)
    elseif subclassId == Enum.ItemArmorSubclass.Plate         then return IsPlayerSpell(750)  and IsPrimaryStat(unit, itemLink)
    end
    return false
end

local function IsItemUseable(unit, itemLink)
    local _, _, _, _, _, _, _, _, _, _, _, classId = C_Item.GetItemInfo(itemLink)
    if     classId == Enum.ItemClass.Weapon then return IsWeaponTypeUseable(unit, itemLink)
    elseif classId == Enum.ItemClass.Armor  then return IsArmorTypeUseable(unit, itemLink)
    end
    return true
end

function Moldy.ShouldAutoRoll(itemLink)
    local _, _, itemQuality = C_Item.GetItemInfo(itemLink)
    if itemQuality > Enum.ItemQuality.Good then
        return false
    end
    if IsItemUseable("player", itemLink) then
        return false
    end
    return true
end

-- Leather, Agility/Stamina
-- /dump Moldy.ShouldAutoRoll("\124cff1eff00\124Hitem:62142::::::::90:::::\124h[Behemoth Boots]\124h\124r")
