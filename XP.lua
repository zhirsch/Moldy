local MoldyXP = Moldy:NewModule("XP", "AceEvent-3.0")

local function ParseMessage(chatmsg)
    local reason, amount, bonus, bonusreason
    if not reason then
        reason, amount = Moldy.Deformat(chatmsg, COMBATLOG_XPGAIN_FIRSTPERSON)
    end
    if not reason then
        reason, amount, bonus, bonusreason = Moldy.Deformat(chatmsg, COMBATLOG_XPGAIN_EXHAUSTION1)
    end
    if not reason then
        return nil
    end
    return amount, reason, bonus, bonusreason
end

function MoldyXP:ChatFilter(_, _, chatmsg, ...)
    local amount, reason, bonus, bonusreason = ParseMessage(chatmsg)
    if not amount then
        return false, chatmsg, ...
    end
    local newchatmsg
    if bonus then
        newchatmsg = string.format("%+d XP (%s) [%+d %s]", amount, reason, bonus, bonusreason)
    else
        newchatmsg = string.format("%+d XP (%s)", amount, reason)
    end
    return false, newchatmsg, ...
end

function MoldyXP:OnEnable()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_XP_GAIN", function(...)
        return self:ChatFilter(...)
    end)
end
