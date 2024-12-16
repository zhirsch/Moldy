-- Colors player names and classes (and more!) in the Friends/Who/Guild panel.
-- Based on https://www.curseforge.com/wow/addons/guildcolors

local GUILD_STATUS_OFFLINE_COLOR = CreateColor(0.5, 0.5, 0.5, 1.0)
local GUILD_STATUS_ONLINE_COLOR = CreateColor(0.5, 1.0, 1.0, 1.0)
local GUILD_STATUS_AFK_COLOR = CreateColor(1.0, 1.0, 0.4, 1.0)
local GUILD_STATUS_DND_COLOR = CreateColor(1.0, 1.0, 0.4, 1.0)

local VALUE_SAME_COLOR = CreateColor(0.5, 1.0, 1.0, 1.0)
local VALUE_DIFFERENT_COLOR = CreateColor(1.0, 1.0, 1.0, 1.0)

local function DelocalizeClassName(needle)
  for class, className in pairs(LOCALIZED_CLASS_NAMES_MALE) do
    if needle == className then
      return class
    end
  end
  for class, className in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
    if needle == className then
      return class
    end
  end
end

local function GetClassColor(class, online)
  local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
  color.a = online and 1.0 or 0.5
  return color
end

local function GetValueColor(same, online)
  local color = same and VALUE_SAME_COLOR or VALUE_DIFFERENT_COLOR
  color.a = online and 1.0 or 0.5
  return color
end

local function SetTextColor(frameName, color)
  local frame = _G[frameName]
  if not frame then
    return
  end
  frame:SetTextColor(color.r, color.g, color.b, color.a)
end

local function FriendList_Entry(i, offset, class, online)
  local class = DelocalizeClassName(class)
  if not class then
    return
  end

  local color = GetClassColor(class, online)
  if not color then
    return
  end

  local index = i - offset
  SetTextColor("FriendsFrameFriendsScrollFrameButton" .. index .. "Name", color)
end

local function FriendList_FriendEntry(i, offset)
  local info = C_FriendList.GetFriendInfoByIndex(i)
  FriendList_Entry(i, offset, info.className, info.connected)
end

local function FriendList_BattleNetFriendEntry(i, offset)
  local info = C_BattleNet.GetFriendAccountInfo(i)
  if info.gameAccountInfo.clientProgram ~= BNET_CLIENT_WOW then
    return
  end
  FriendList_Entry(i, offset, info.gameAccountInfo.className, info.gameAccountInfo.isOnline)
end

local function GuildList_Zone(i, zone, online)
  SetTextColor("GuildFrameButton" .. i .. "Zone", GetValueColor(GetRealZoneText() == zone, online))
end

local function GuildList_Class(i, class, online)
  local color = GetClassColor(class, online)
  SetTextColor("GuildFrameButton" .. i .. "Name", color)
  SetTextColor("GuildFrameButton" .. i .. "Class", color)
  SetTextColor("GuildFrameGuildStatusButton" .. i .. "Name", color)
end

local function GuildList_OnlineStatus(i, online, status)
  local color
  if not online then
    color = GUILD_STATUS_OFFLINE_COLOR
  elseif status == 0 then
    color = GUILD_STATUS_ONLINE_COLOR
  elseif status == 1 then
    color = GUILD_STATUS_AFK_COLOR
  elseif status == 2 then
    color = GUILD_STATUS_DND_COLOR
  end
  SetTextColor("GuildFrameGuildStatusButton" .. i .. "Online", color)
end

local function GuildList_Entry(i, offset)
  local _, _, _, _, _, zone, _, _, online, status, class = GetGuildRosterInfo(i + offset)
  if not class then
    return
  end

  GuildList_Zone(i, zone, online)
  GuildList_Class(i, class, online)
  GuildList_OnlineStatus(i, online, status)
end

local function WhoList_Entry(i, offset)
  local info = C_FriendList.GetWhoInfo(i + offset)
  if not info then
    return
  end

  local selectedId = MenuUtil.GetSelections(WhoFrameDropdown:GetMenuDescription())[1].data.value
  local value1 = ({
    [1] = GetRealZoneText(),
    [2] = GetGuildInfo("player"),
    [3] = UnitRace("player"),
  })[selectedId]
  local value2 = ({
    [1] = info.area,
    [2] = info.fullGuildName,
    [3] = info.raceStr,
  })[selectedId]

  local color = GetClassColor(info.filename, true)
  SetTextColor("WhoFrameButton" .. i .. "Name", color)
  SetTextColor("WhoFrameButton" .. i .. "Class", color)
  SetTextColor("WhoFrameButton" .. i .. "Variable", GetValueColor(value1 == value2, true))
end

local function UpdateFriends()
  local offset = HybridScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)
  local numFriendsOnline = C_FriendList.GetNumOnlineFriends()
  local _, numBattleNetFriendsOnline = BNGetNumFriends()

  for i = 1, numFriendsOnline do
    FriendList_FriendEntry(i, offset)
  end
  for i = 1, numBattleNetFriendsOnline do
    FriendList_BattleNetFriendEntry(i, offset - numFriendsOnline)
  end
end

local function UpdateWho()
  local offset = FauxScrollFrame_GetOffset(WhoListScrollFrame)

  for i = 1, WHOS_TO_DISPLAY do
    WhoList_Entry(i, offset)
  end
end

local function UpdateGuild()
  local offset = FauxScrollFrame_GetOffset(GuildListScrollFrame)

  for i = 1, GUILDMEMBERS_TO_DISPLAY do
    GuildList_Entry(i, offset)
  end
end

hooksecurefunc("FriendsList_Update", UpdateFriends)
hooksecurefunc("HybridScrollFrame_Update", UpdateFriends)
hooksecurefunc("WhoList_Update", UpdateWho)
hooksecurefunc("GuildStatus_Update", UpdateGuild)
