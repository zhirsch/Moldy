local BRACKET_SIZE = 1000
local MAX_SCORE = 6 * BRACKET_SIZE - 1

local GS_ItemTypes = {
    INVTYPE_2HWEAPON = { weight = 2.0000 },
    INVTYPE_BODY = { weight = 0.0000 },
    INVTYPE_CHEST = { weight = 1.0000 },
    INVTYPE_CLOAK = { weight = 0.5625 },
    INVTYPE_FEET = { weight = 0.7500 },
    INVTYPE_FINGER = { weight = 0.5625 },
    INVTYPE_HAND = { weight = 0.7500 },
    INVTYPE_HEAD = { weight = 1.0000 },
    INVTYPE_HOLDABLE = { weight = 1.0000 },
    INVTYPE_LEGS = { weight = 1.0000 },
    INVTYPE_NECK = { weight = 0.5625 },
    INVTYPE_RANGED = { weight = 0.3164 },
    INVTYPE_RANGEDRIGHT = { weight = 0.3164 },
    INVTYPE_RELIC = { weight = 0.3164 },
    INVTYPE_ROBE = { weight = 1.0000 },
    INVTYPE_SHIELD = { weight = 1.0000 },
    INVTYPE_SHOULDER = { weight = 0.7500 },
    INVTYPE_TABARD = { weight = 0.0000 },
    INVTYPE_THROWN = { weight = 0.3164 },
    INVTYPE_TRINKET = { weight = 0.5625 },
    INVTYPE_WAIST = { weight = 0.7500 },
    INVTYPE_WEAPON = { weight = 1.0000 },
    INVTYPE_WEAPONMAINHAND = { weight = 1.0000 },
    INVTYPE_WEAPONOFFHAND = { weight = 1.0000 },
    INVTYPE_WRIST = { weight = 0.5625 },
}

local GS_Qualities = {
    [Enum.ItemQuality.Poor] = { base = 73.0000, weight = 0.009309 },
    [Enum.ItemQuality.Standard] = { base = 73.0000, weight = 0.009309 },
    [Enum.ItemQuality.Good] = { base = 73.0000, weight = 1.861800 },
    [Enum.ItemQuality.Rare] = { base = 81.3750, weight = 2.291446 },
    [Enum.ItemQuality.Heirloom] = { base = 81.3750, weight = 2.291446 },
    [Enum.ItemQuality.Epic] = { base = 91.4500, weight = 2.864307 },
    [Enum.ItemQuality.Legendary] = { base = 91.4500, weight = 3.723600 },
}

local GS_Colors = {
    [5] = {
        r = { base = 0.94, weight = 0.00006 },
        g = { base = 0.47, weight = -0.00047 },
        b = { base = 0.00, weight = 0.00000 },
    },
    [4] = {
        r = { base = 0.69, weight = 0.00025 },
        g = { base = 0.28, weight = 0.00019 },
        b = { base = 0.97, weight = -0.00096 },
    },
    [3] = {
        r = { base = 0.00, weight = 0.00069 },
        g = { base = 0.50, weight = -0.00022 },
        b = { base = 1.00, weight = -0.00003 },
    },
    [2] = {
        r = { base = 0.12, weight = -0.00012 },
        g = { base = 1.00, weight = -0.00050 },
        b = { base = 0.00, weight = 0.00100 },
    },
    [1] = {
        r = { base = 1.00, weight = -0.00088 },
        g = { base = 1.00, weight = 0.00000 },
        b = { base = 1.00, weight = -0.00100 },
    },
    [0] = {
        r = { base = 0.55, weight = 0.00045 },
        g = { base = 0.55, weight = 0.00045 },
        b = { base = 0.55, weight = 0.00045 },
    },
}

local function GetItemScore(itemLink)
    local _, _, itemQuality, itemLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
    if itemQuality == Enum.ItemQuality.Heirloom then
        itemLevel = 187
    end
    local quality = GS_Qualities[itemQuality]
    local type = GS_ItemTypes[itemEquipLoc]
    local offset = itemLevel - quality.base
    local score = floor(offset * quality.weight * type.weight)
    if score < 0 then
        return 0
    end
    if score > MAX_SCORE then
        return MAX_SCORE
    end
    return score
end

local function GetColor(score)
    if score > MAX_SCORE then
        score = MAX_SCORE
    end
    local bracket = floor(score / BRACKET_SIZE)
    local offset = score - bracket * BRACKET_SIZE
    local table = GS_Colors[bracket]
    local r = table.r.base + offset * table.r.weight
    local g = table.g.base + offset * table.g.weight
    local b = table.b.base + offset * table.b.weight
    return CreateColor(r, g, b, 1)
end

local function IsTitanGrip(unit)
    local mainHandLink, offHandLink = GetInventoryItemLink(unit, 16), GetInventoryItemLink(unit, 17)
    if mainHandLink and offHandLink then
        local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(mainHandLink)
        return itemEquipLoc == "INVTYPE_2HWEAPON"
    end
    if offHandLink then
        local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(offHandLink)
        return itemEquipLoc == "INVTYPE_2HWEAPON"
    end
    return false
end

function Moldy.GetGearScore(unit)
    local titanGrip = IsTitanGrip(unit) and 0.5 or 1

    local score = 0
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local itemLink = GetInventoryItemLink(unit, slot)
        if itemLink then
            local temp = GetItemScore(itemLink)
            if UnitClassBase(unit) == "HUNTER" then
                if slot == INVSLOT_MAINHAND then
                    temp = temp * 0.3164
                end
                if slot == INVSLOT_OFFHAND then
                    temp = temp * 0.3164
                end
                if slot == INVSLOT_RANGED then
                    temp = temp * 5.3224
                end
            end
            if slot == INVSLOT_MAINHAND then
                temp = temp * titanGrip
            end
            if slot == INVSLOT_OFFHAND then
                temp = temp * titanGrip
            end
            score = score + temp
        end
    end
    score = floor(score)
    return score, GetColor(score)
end
