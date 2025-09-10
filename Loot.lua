local MoldyLoot = Moldy:NewModule("Loot", "AceEvent-3.0")

local TEXT_COLOR   = CreateColorFromBytes(0xff, 0xff, 0xff, 0)
local KIND_COLOR   = CreateColorFromBytes(0x33, 0xff, 0x99, 0)
local GOLD_COLOR   = CreateColorFromBytes(0xff, 0xd7, 0x00, 0)
local SILVER_COLOR = CreateColorFromBytes(0xc7, 0xc7, 0xcf, 0)
local COPPER_COLOR = CreateColorFromBytes(0xed, 0xa5, 0x5f, 0)

local MONEY_STRING_GOLD_SILVER_COPPER = string.format("%s, %s, %s", GOLD_AMOUNT, SILVER_AMOUNT, COPPER_AMOUNT)
local MONEY_STRING_GOLD_SILVER = string.format("%s, %s", GOLD_AMOUNT, SILVER_AMOUNT)
local MONEY_STRING_GOLD_COPPER = string.format("%s, %s", GOLD_AMOUNT, COPPER_AMOUNT)
local MONEY_STRING_GOLD = GOLD_AMOUNT
local MONEY_STRING_SILVER_COPPER = string.format("%s, %s", SILVER_AMOUNT, COPPER_AMOUNT)
local MONEY_STRING_SILVER = SILVER_AMOUNT
local MONEY_STRING_COPPER = COPPER_AMOUNT

local ROLL_TYPES = {
    [0] = PASS,
    [1] = NEED,
    [2] = GREED,
    [3] = ROLL_DISENCHANT,
}

local function IsIgnoredLootMessage(chatmsg)
    local _, _, link, _ = Moldy.Deformat(chatmsg, LOOT_ROLL_ROLLED_GREED)
    if link then return true end
    local _, _, link, _ = Moldy.Deformat(chatmsg, LOOT_ROLL_ROLLED_NEED)
    if link then return true end
    local _, link = Moldy.Deformat(chatmsg, LOOT_ROLL_GREED_SELF)
    if link then return true end
    local _, link = Moldy.Deformat(chatmsg, LOOT_ROLL_NEED_SELF)
    if link then return true end
    local _, link = Moldy.Deformat(chatmsg, LOOT_ROLL_PASSED_SELF)
    if link then return true end
    local _, _, link = Moldy.Deformat(chatmsg, LOOT_ROLL_GREED)
    if link then return true end
    local _, _, link = Moldy.Deformat(chatmsg, LOOT_ROLL_NEED)
    if link then return true end
    local _, _, link = Moldy.Deformat(chatmsg, LOOT_ROLL_PASSED)
    if link then return true end
    local _, link = Moldy.Deformat(chatmsg, LOOT_ROLL_STARTED)
    if link then return true end
    return false
end

local function ParseMessageLoot(chatmsg)
    local link, amount, isBonus
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_SELF_MULTIPLE)
        isBonus = false
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_SELF), 1
        isBonus = false
    end
    if not link then
        _, link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_MULTIPLE)
        isBonus = false
    end
    if not link then
        _, link = Moldy.Deformat(chatmsg, LOOT_ITEM)
        amount = 1
        isBonus = false
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE)
        isBonus = true
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_BONUS_ROLL_SELF), 1
        isBonus = true
    end
    if not link then
        _, link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_BONUS_ROLL_MULTIPLE)
        isBonus = true
    end
    if not link then
        _, link = Moldy.Deformat(chatmsg, LOOT_ITEM_BONUS_ROLL)
        amount = 1
        isBonus = true
    end
    if not link then
        _, link = Moldy.Deformat(chatmsg, TRADESKILL_LOG_THIRDPERSON)
        amount = 1
        isBonus = false
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_CREATED_SELF_MULTIPLE)
        isBonus = false
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_CREATED_SELF), 1
        isBonus = false
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_PUSHED_SELF_MULTIPLE)
        isBonus = false
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_PUSHED_SELF), 1
        isBonus = false
    end
    if not link then
        _, link, amount = Moldy.Deformat(chatmsg, LOOT_ITEM_PUSHED_MULTIPLE)
        isBonus = false
    end
    if not link then
        _, link = Moldy.Deformat(chatmsg, LOOT_ITEM_PUSHED)
        amount = 1
        isBonus = false
    end
    if not link then
        return nil
    end
    return link, amount, isBonus
end

local function ParseMessageLootRoll(chatmsg)
    local rollId
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_STARTED)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_GREED_SELF)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_NEED_SELF)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_PASSED_SELF)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_GREED)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_NEED)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_PASSED)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_ROLLED_GREED)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_ROLLED_NEED)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_YOU_WON)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_WON)
    end
    if not rollId then
        rollId = Moldy.Deformat(chatmsg, LOOT_ROLL_ALL_PASSED)
    end
    if not rollId then
        return nil
    end
    return rollId
end

local function ParseMessageMoney(chatmsg, logError)
    local amount
    if not amount then
        amount = Moldy.Deformat(chatmsg, YOU_LOOT_MONEY)
    end
    if not amount then
        amount = Moldy.Deformat(chatmsg, ERR_QUEST_REWARD_MONEY_S)
    end
    if not amount then
        amount = Moldy.Deformat(chatmsg, LOOT_MONEY_SPLIT)
    end
    if not amount then
        if logError then
            Moldy:Printf("BUG: unable to parse message: %s", chatmsg)
        end
        return nil
    end
    local gold, silver, copper
    if not gold or not silver or not copper then
        gold, silver, copper = Moldy.Deformat(amount, MONEY_STRING_GOLD_SILVER_COPPER)
    end
    if not gold or not silver or not copper then
        gold, silver = Moldy.Deformat(amount, MONEY_STRING_GOLD_SILVER)
        copper = 0
    end
    if not gold or not silver or not copper then
        gold, copper = Moldy.Deformat(amount, MONEY_STRING_GOLD_COPPER)
        silver = 0
    end
    if not gold or not silver or not copper then
        gold = Moldy.Deformat(amount, MONEY_STRING_GOLD)
        copper, silver = 0, 0
    end
    if not gold or not silver or not copper then
        silver, copper = Moldy.Deformat(amount, MONEY_STRING_SILVER_COPPER)
        gold = 0
    end
    if not gold or not silver or not copper then
        silver = Moldy.Deformat(amount, MONEY_STRING_SILVER)
        gold, copper = 0, 0
    end
    if not gold or not silver or not copper then
        copper = Moldy.Deformat(amount, MONEY_STRING_COPPER)
        gold, silver = 0, 0
    end
    return gold, silver, copper
end

local function ParseMessageCurrency(chatmsg)
    local link, amount
    if not link then
        link, amount = Moldy.Deformat(chatmsg, CURRENCY_GAINED_MULTIPLE)
    end
    if not link then
        link, amount = Moldy.Deformat(chatmsg, CURRENCY_GAINED), 1
    end
    if not link then
        Moldy:Printf("BUG: unable to parse message: %s", chatmsg)
        return nil
    end
    return link, amount
end

local function FormatMoney(gold, silver, copper)
    return string.format(
        "%s%s %d%s %d%s",
        FormatLargeNumber(gold), GOLD_COLOR:WrapTextInColorCode(GOLD_AMOUNT_SYMBOL),
        silver, SILVER_COLOR:WrapTextInColorCode(SILVER_AMOUNT_SYMBOL),
        copper, COPPER_COLOR:WrapTextInColorCode(COPPER_AMOUNT_SYMBOL))
end

local function MakeMessage(kind, text)
    return TEXT_COLOR:WrapTextInColorCode(string.format("%s: %s", KIND_COLOR:WrapTextInColorCode(kind), text))
end

local function ColorizeByClass(text, class)
    return GetClassColorObj(class):WrapTextInColorCode(text)
end

local function ColorizeName(name)
    if IsInRaid() then
        for i = 1, MAX_RAID_MEMBERS do
            local unit = "raid"..i
            local unitName = GetUnitName(unit, true)
            if unitName and unitName == name then
                return GetClassColoredTextForUnit(unit, unitName)
            end
        end
    elseif GetNumGroupMembers() == 0 then
        local unit = "player"
        local unitName = GetUnitName(unit, true)
        if unitName and unitName == name then
            return GetClassColoredTextForUnit(unit, unitName)
        end
    else
        for i = 1, 4 do
            local unit = "party"..i
            local unitName = GetUnitName(unit, true)
            if unitName and unitName == name then
                return GetClassColoredTextForUnit(unit, unitName)
            end
        end
    end
    return name
end

local function FormatRoll(roll, class, isMe)
    local text = (isMe and string.format("%s*", roll)) or roll
    return ColorizeByClass(text, class)
end

local function HandleLootRoll_Done(itemIdx)
    local _, itemLink, numPlayers, isDone = C_LootHistory.GetItem(itemIdx)
    if not isDone then
        return nil
    end
    local name, class, rollType = C_LootHistory.GetPlayerInfo(itemIdx, 1)
    local text = string.format("%s won by %s (%s) - ", itemLink, ColorizeByClass(name, class), ROLL_TYPES[rollType])
    local rolls = {}
    for playerIdx = 1, numPlayers do
        local _, class, _, roll, _, isMe = C_LootHistory.GetPlayerInfo(itemIdx, playerIdx)
        if roll then
            table.insert(rolls, FormatRoll(roll, class, isMe))
        end
    end
    return text .. table.concat(rolls, ", ")
end

local function HandleLootRoll(rollId)
    for itemIdx = 1, C_LootHistory.GetNumItems() do
        if C_LootHistory.GetItem(itemIdx) == rollId then
            return HandleLootRoll_Done(itemIdx)
        end
    end
    return nil
end

local function CHAT_MSG_LOOT(_, _, chatmsg, ...)
    local _, _, _, name, _, _, _, _, _, lineId = ...
    if MoldyLoot.lineId and MoldyLoot.lineId == lineId then return false, chatmsg, ... end
    MoldyLoot.lineId = lineId

    local rollId = ParseMessageLootRoll(chatmsg)
    if rollId then
        local text = HandleLootRoll(rollId)
        if text then
            return false, MakeMessage(ROLL, text), ...
        end
        return true
    end

    local link, amount, isBonus = ParseMessageLoot(chatmsg)
    if link then
        local text
        if name == UnitName("player") then
            text = string.format("%+d %s (%d)", amount, link, GetItemCount(link) + amount)
        else
            text = string.format("(%s) %+d %s", ColorizeName(name), amount, link)
        end
        local kind = (isBonus and BONUS_LOOT_LABEL) or LOOT_NOUN
        return false, MakeMessage(kind, text), ...
    end

    return false, chatmsg, ...
end

local function CHAT_MSG_MONEY(_, _, chatmsg, ...)
    local gold, silver, copper = ParseMessageMoney(chatmsg, event == "CHAT_MSG_MONEY")
    if not gold then return false, chatmsg, ... end

    local currentMoney = GetMoney()
    local currentGold = floor(currentMoney / 100 / 100)
    local currentSilver = floor(currentMoney / 100 % 100)
    local currentCopper = currentMoney % 100
    local text = string.format("%s (%s)", FormatMoney(gold, silver, copper), FormatMoney(currentGold, currentSilver, currentCopper))
    return false, MakeMessage(MONEY, text), ...
end

local function CHAT_MSG_CURRENCY(_, event, chatmsg, ...)
    local link, amount = ParseMessageCurrency(chatmsg)
    if not link then return false, chatmsg, ... end

    local info = C_CurrencyInfo.GetCurrencyInfoFromLink(link)
    local text
    if info.useTotalEarnedForMaxQty then
        text = string.format("%+d %s (%d) [max: %d / %d]", amount, link, info.quantity, info.totalEarned, info.maxQuantity)
    elseif info.maxQuantity and info.maxQuantity > 0 then
        text = string.format("%+d %s (%d) [max: %d]", amount, link, info.quantity, info.maxQuantity)
    else
        text = string.format("%+d %s (%d)", amount, link, info.quantity)
    end
    return false, MakeMessage(CURRENCY, text), ...
end

function MoldyLoot:OnEnable()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CURRENCY", CHAT_MSG_CURRENCY)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", CHAT_MSG_LOOT)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONEY", CHAT_MSG_MONEY)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", CHAT_MSG_MONEY)
end
