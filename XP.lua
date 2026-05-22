local MoldyXP = Moldy:NewModule("XP", "AceEvent-3.0")

local function ParseMessage(chatmsg)
    local reason, amount
    if not reason then
        reason, amount = Moldy.Deformat(chatmsg, COMBATLOG_XPGAIN_FIRSTPERSON)
    end
    if not reason then
        return nil
    end
    return amount, reason
end

function MoldyXP:ChatFilter(_, _, chatmsg, ...)
    local amount, reason = ParseMessage(chatmsg)
    if not amount then
        return false, chatmsg, ...
    end
    local newchatmsg = string.format("+%d XP (%s)", amount, reason)
    return false, newchatmsg, ...
end

function MoldyXP:OnEnable()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_XP_GAIN", function(...)
        return self:ChatFilter(...)
    end)
end
