local MoldyChatSounds = Moldy:NewModule("ChatSounds", "AceEvent-3.0")
MoldyChatSounds.enabled = true

SLASH_MOLDY1 = "/moldy"

function SlashCmdList.MOLDY(command)
	if command == "chatsounds on" then
		MoldyChatSounds.enabled = true
		Moldy:Printf("Chat sounds enabled")
		return
	end
	if command == "chatsounds off" then
		MoldyChatSounds.enabled = false
		Moldy:Printf("Chat sounds disabled")
		return
	end
	Moldy:Printf("Unknown command: "..command)
end

local prefix = "Interface/AddOns/Moldy/media/"
local sounds = {
    ["CHAT_MSG_BN_WHISPER"]           = "whisper.ogg",
    ["CHAT_MSG_GUILD"]                = "guild.ogg",
    ["CHAT_MSG_INSTANCE_CHAT"]        = "party.ogg",
    ["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "party.ogg",
    ["CHAT_MSG_OFFICER"]              = "guild.ogg",
    ["CHAT_MSG_PARTY"]                = "party.ogg",
    ["CHAT_MSG_PARTY_LEADER"]         = "party.ogg",
    ["CHAT_MSG_RAID"]                 = "party.ogg",
    ["CHAT_MSG_RAID_LEADER"]          = "party.ogg",
    ["CHAT_MSG_WHISPER"]              = "whisper.ogg",
}

local function Play(file)
	if MoldyChatSounds.enabled then
		PlaySoundFile(file, "MASTER")
	end
end

function MoldyChatSounds:OnEnable()
	for event, file in pairs(sounds) do
		self:RegisterEvent(event, Play, prefix..file)
	end
end
