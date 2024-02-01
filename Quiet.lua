local MoldyQuiet = Moldy:NewModule("Quiet", "AceEvent-3.0")

local function Toggle(name)
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "party" or instanceType == "raid") then
		if ChatFrame_ContainsChannel(DEFAULT_CHAT_FRAME, name) then
			Moldy:Printf("Disabling %s", name)
			ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, name)
		end
	else
		if not ChatFrame_ContainsChannel(DEFAULT_CHAT_FRAME, name) then
			Moldy:Printf("Enabling %s", name)
			ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, name)
		end
	end
end

local function ToggleAll()
	Toggle("General")
	Toggle("LocalDefense")
end

local function DelayToggleAll()
	C_Timer.After(5, function()
		ToggleAll()
	end)
end

function MoldyQuiet:OnEnable()
	self:RegisterEvent("ZONE_CHANGED", ToggleAll)
	self:RegisterEvent("ZONE_CHANGED_INDOORS", ToggleAll)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", ToggleAll)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", DelayToggleAll)
end
