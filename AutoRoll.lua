local CLASS_TYPES = {
    DEATHKNIGHT = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Axe1H]    = true,
            [Enum.ItemWeaponSubclass.Axe2H]    = true,
            [Enum.ItemWeaponSubclass.Mace1H]   = true,
            [Enum.ItemWeaponSubclass.Mace2H]   = true,
            [Enum.ItemWeaponSubclass.Sword1H]  = true,
            [Enum.ItemWeaponSubclass.Sword2H]  = true,
            [Enum.ItemWeaponSubclass.Polearm]  = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Plate]   = true,
        },
    },
    DRUID = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger]   = true,
            [Enum.ItemWeaponSubclass.Unarmed]  = true,
            [Enum.ItemWeaponSubclass.Polearm]  = true,
            [Enum.ItemWeaponSubclass.Staff]    = true,
            [Enum.ItemWeaponSubclass.Mace1H]   = true,
            [Enum.ItemWeaponSubclass.Mace2H]   = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Leather] = true,
        },
    },
    HUNTER = {
        [Enum.ItemClass.Weapon] = {
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
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Mail]    = true,
        },
    },
    MAGE = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger]   = true,
            [Enum.ItemWeaponSubclass.Staff]    = true,
            [Enum.ItemWeaponSubclass.Sword1H]  = true,
            [Enum.ItemWeaponSubclass.Wand]     = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Cloth]   = true,
        },
    },
    MONK = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Axe1H]    = true,
            [Enum.ItemWeaponSubclass.Mace1H]   = true,
            [Enum.ItemWeaponSubclass.Sword1H]  = true,
            [Enum.ItemWeaponSubclass.Unarmed]  = true,
            [Enum.ItemWeaponSubclass.Polearm]  = true,
            [Enum.ItemWeaponSubclass.Staff]    = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Leather] = true,
        },
    },
    PALADIN = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Axe1H]    = true,
            [Enum.ItemWeaponSubclass.Axe2H]    = true,
            [Enum.ItemWeaponSubclass.Mace1H]   = true,
            [Enum.ItemWeaponSubclass.Mace2H]   = true,
            [Enum.ItemWeaponSubclass.Sword1H]  = true,
            [Enum.ItemWeaponSubclass.Sword2H]  = true,
            [Enum.ItemWeaponSubclass.Polearm]  = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Plate]   = true,
            [Enum.ItemArmorSubclass.Shield]  = true,
        },
    },
    PRIEST = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger]   = true,
            [Enum.ItemWeaponSubclass.Mace1H]   = true,
            [Enum.ItemWeaponSubclass.Staff]    = true,
            [Enum.ItemWeaponSubclass.Wand]     = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Cloth]   = true,
        },
    },
    ROGUE = {
        [Enum.ItemClass.Weapon] = {
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
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Leather] = true,
        },
    },
    SHAMAN = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Axe1H]    = true,
            [Enum.ItemWeaponSubclass.Axe2H]    = true,
            [Enum.ItemWeaponSubclass.Dagger]   = true,
            [Enum.ItemWeaponSubclass.Unarmed]  = true,
            [Enum.ItemWeaponSubclass.Mace1H]   = true,
            [Enum.ItemWeaponSubclass.Mace2H]   = true,
            [Enum.ItemWeaponSubclass.Staff]    = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Mail]    = true,
            [Enum.ItemArmorSubclass.Shield]  = true,
        },
    },
    WARLOCK = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger]   = true,
            [Enum.ItemWeaponSubclass.Staff]    = true,
            [Enum.ItemWeaponSubclass.Sword1H]  = true,
            [Enum.ItemWeaponSubclass.Wand]     = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Cloth]   = true,
        },
    },
    WARRIOR = {
        [Enum.ItemClass.Weapon] = {
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
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true,
            [Enum.ItemArmorSubclass.Plate]   = true,
            [Enum.ItemArmorSubclass.Shield]  = true,
        },
    },

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

function Moldy.IsItemUseable(unit, itemLink)
    local className = UnitClassBase(unit)
    local _, _, _, _, _, _, _, _, _, _, _, classId, subclassId = C_Item.GetItemInfo(itemLink)
    if CLASS_TYPES[className][classId] ~= nil then
        if not CLASS_TYPES[className][classId][subclassId] then
            return false
        end
        if not IsPrimaryStat(unit, itemLink) then
            return false
        end
    end
    return true
end

function Moldy.ShouldAutoRoll(itemLink)
    local _, _, itemQuality = C_Item.GetItemInfo(itemLink)
    if itemQuality > Enum.ItemQuality.Good then
        Moldy:Printf("%s: better than good", itemLink)
        return false
    end
    if Moldy.IsItemUseable("player", itemLink) then
        return false
    end
    return true
end

-- Leather, Agility/Stamina
-- /dump Moldy.ShouldAutoRoll("\124cff1eff00\124Hitem:62142::::::::90:::::\124h[Behemoth Boots]\124h\124r")
