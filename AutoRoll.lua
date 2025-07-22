-- TODO: classes that change armor type while leveling.
local ARMOR_CLASS_MAP = {
    DEATHKNIGHT = Enum.ItemArmorSubclass.Plate,
    DRUID       = Enum.ItemArmorSubclass.Leather,
    HUNTER      = Enum.ItemArmorSubclass.Mail,
    MAGE        = Enum.ItemArmorSubclass.Cloth,
    MONK        = Enum.ItemArmorSubclass.Leather,
    PALADIN     = Enum.ItemArmorSubclass.Plate,
    PRIEST      = Enum.ItemArmorSubclass.Cloth,
    ROGUE       = Enum.ItemArmorSubclass.Leater,
    SHAMAN      = Enum.ItemArmorSubclass.Mail,
    WARLOCK     = Enum.ItemArmorSubclass.Cloth,
    WARRIOR     = Enum.ItemArmorSubclass.Plate,
}

local PRIMARY_STAT_MAP = {
    DEATHKNIGHT = { ITEM_MOD_STRENGTH_SHORT,  ITEM_MOD_STRENGTH_SHORT,  ITEM_MOD_STRENGTH_SHORT  },
    DRUID       = { ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_AGILITY_SHORT,   ITEM_MOD_INTELLECT_SHORT },
    HUNTER      = { ITEM_MOD_AGILITY_SHORT,   ITEM_MOD_AGILITY_SHORT,   ITEM_MOD_AGILITY_SHORT   },
    MAGE        = { ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_INTELLECT_SHORT },
    MONK        = { ITEM_MOD_AGILITY_SHORT,   ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_AGILITY_SHORT   },
    PALADIN     = { ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_STRENGTH_SHORT,  ITEM_MOD_STRENGTH_SHORT  },
    PRIEST      = { ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_INTELLECT_SHORT },
    ROGUE       = { ITEM_MOD_AGILITY_SHORT,   ITEM_MOD_AGILITY_SHORT,   ITEM_MOD_AGILITY_SHORT   },
    SHAMAN      = { ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_AGILITY_SHORT,   ITEM_MOD_INTELLECT_SHORT },
    WARLOCK     = { ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_INTELLECT_SHORT, ITEM_MOD_INTELLECT_SHORT },
    WARRIOR     = { ITEM_MOD_STRENGTH_SHORT,  ITEM_MOD_STRENGTH_SHORT,  ITEM_MOD_STRENGTH_SHORT  },    
}

local function MyArmorClass()
    local _, class = UnitClass("player")
    return ARMOR_CLASS_MAP[class]
end

local function MyPrimaryStat()
    local _, class = UnitClass("player")
    local tree = GetPrimaryTalentTree()
    return PRIMARY_STAT_MAP[class][tree]
end

local function HasPrimaryStat(itemLink)
    local primaryStat = MyPrimaryStat()
    if not primaryStat then
        return true
    end
    local stats = GetItemStats(itemLink)
    if not stats then
        return true
    end
    for stat, amount in pairs(stats) do
        if _G[stat] == primaryStat and amount > 0 then
            return true
        end
    end
    return false
end

local function IsIdealArmorClass(itemLink)
    local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, subclassId = GetItemInfo(itemLink)
    if itemEquipLoc == "INVTYPE_CLOAK" then
        return true
    end
    if subclassId == Enum.ItemArmorSubclass.Generic then
        return true
    end
    return subclassId == MyArmorClass()
end

function Moldy.ShouldAutoRoll(itemLink)
    local _, _, itemQuality, _, _, _, _, _, _, _, _, classId = GetItemInfo(itemLink)
    if itemQuality > Enum.ItemQuality.Good then
        return false
    end
    if classId == Enum.ItemClass.Weapon then
        if  not C_Item.IsEquippableItem(itemLink) then
            return true
        end
        if not HasPrimaryStat(itemLink) then
            return true
        end
        return false
    end
    if classId == Enum.ItemClass.Armor then
        if not C_Item.IsEquippableItem(itemLink) then
            return true
        end 
        if not HasPrimaryStat(itemLink) then
            return true
        end
        if not IsIdealArmorClass(itemLink) then
            return true
        end
        return false
    end
    return true
end

-- Leather, Agility/Stamina
-- /dump Moldy.ShouldAutoRoll("\124cff1eff00\124Hitem:62142::::::::90:::::\124h[Behemoth Boots]\124h\124r")
