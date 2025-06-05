local MoldyReputation = Moldy:NewModule("Reputation", "AceEvent-3.0")

MoldyReputation.stats = {
    session = {},
}

local STANDINGS = {
    [1] = { name = FACTION_STANDING_LABEL1, max = 36000, color = CreateColorFromHexString("ffcc2222") }, -- Hated
    [2] = { name = FACTION_STANDING_LABEL2, max = 3000, color = CreateColorFromHexString("ffff0000") }, -- Hostile
    [3] = { name = FACTION_STANDING_LABEL3, max = 3000, color = CreateColorFromHexString("ffee6622") }, -- Unfriendly
    [4] = { name = FACTION_STANDING_LABEL4, max = 3000, color = CreateColorFromHexString("ffffff00") }, -- Neutral
    [5] = { name = FACTION_STANDING_LABEL5, max = 6000, color = CreateColorFromHexString("ff00ff00") }, -- Friendly
    [6] = { name = FACTION_STANDING_LABEL6, max = 12000, color = CreateColorFromHexString("ff00ff88") }, -- Honored
    [7] = { name = FACTION_STANDING_LABEL7, max = 21000, color = CreateColorFromHexString("ff00ffcc") }, -- Revered
    [8] = { name = FACTION_STANDING_LABEL8, max = 999, color = CreateColorFromHexString("ff00ffff") }, -- Exalted
}

local function ParseMessage(chatmsg)
    local faction, amount
    if not faction then
        faction, amount = Moldy.Deformat(chatmsg, FACTION_STANDING_INCREASED)
    end
    if not faction then
        faction, amount = Moldy.Deformat(chatmsg, FACTION_STANDING_DECREASED)
        if amount then
            amount = -amount
        end
    end
    if not faction then
        return nil
    end
    for i = 1, GetNumFactions() do
        local name, _, _, _, _, _, _, _, _, _, _, _, _, factionId = GetFactionInfo(i)
        if name == faction then
            return factionId, amount
        end
    end
    return nil
end

local function GetStanding(factionId)
    local _, _, standingId, _, _, value = GetFactionInfoByID(factionId)

    if value < -6000 then
        value = value + 42000
    elseif value < -3000 then
        value = value + 6000
    elseif value < 0 then
        value = value + 3000
    elseif value < 3000 then
        value = value + 0
    elseif value < 9000 then
        value = value - 3000
    elseif value < 21000 then
        value = value - 9000
    elseif value < 42000 then
        value = value - 21000
    elseif value < 42999 then
        value = value - 42000
    end

    local standing = STANDINGS[standingId]
    return string.format("%s %d / %d", standing.color:WrapTextInColorCode(standing.name), value, standing.max)
end

local function MakeLink(factionId)
    local name = GetFactionInfoByID(factionId)
    return LinkUtil.FormatLink("moldyfaction", "[" .. name .. "]", factionId)
end

local function ParseLink(link)
    local factionId = link:match("^moldyfaction:(%d+)$")
    if not factionId then
        return
    end
    return tonumber(factionId)
end

function MoldyReputation:ReputationChangeFilter(_, _, chatmsg, ...)
    local factionId, change = ParseMessage(chatmsg)
    if not factionId then
        return false, chatmsg, ...
    end
    if factionId == 1169 then factionId = 1168 end
    local standing = GetStanding(factionId)
    local link = MakeLink(factionId)
    local newchatmsg = string.format("%s %+d (%s)", link, change, standing)
    return false, newchatmsg, ...
end

function MoldyReputation:ShowTooltip(_, link, ...)
    local factionId = ParseLink(link)
    if not factionId then
        return
    end

    local faction, description = GetFactionInfoByID(factionId)
    local standing = GetStanding(factionId)
    local sessionTotal = self.stats.session[factionId] and self.stats.session[factionId].total or 0

    GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", 0, 20)
    GameTooltip:AddLine(faction)
    GameTooltip:AddLine(description, 1, 1, 1, 1)
    GameTooltip_AddBlankLineToTooltip(GameTooltip)
    GameTooltip:AddDoubleLine(standing, string.format("%+d", sessionTotal))
    GameTooltip:Show()
end

function MoldyReputation:HideTooltip(...)
    GameTooltip:Hide()
end

function MoldyReputation:ShowReputationDetails(...)
    local _, link = ...
    local factionId = ParseLink(link)
    if not factionId then
        ChatFrame_OnHyperlinkShow(...)
        return
    end
    ToggleCharacter("ReputationFrame", true)
end

function MoldyReputation:CHAT_MSG_COMBAT_FACTION_CHANGE(event, chatmsg, ...)
    local factionId, change = ParseMessage(chatmsg)

    if not self.stats.session[factionId] then
        self.stats.session[factionId] = { total = 0 }
    end
    self.stats.session[factionId].total = self.stats.session[factionId].total + change
end

function MoldyReputation:OnEnable()
    self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", function(...)
        return self:ReputationChangeFilter(...)
    end)
    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame" .. i]
        if frame then
            frame:SetScript("OnHyperlinkEnter", function(...)
                self:ShowTooltip(...)
            end)
            frame:SetScript("OnHyperlinkLeave", function(...)
                self:HideTooltip(...)
            end)
            frame:SetScript("OnHyperlinkClick", function(...)
                self:ShowReputationDetails(...)
            end)
        end
    end
end
