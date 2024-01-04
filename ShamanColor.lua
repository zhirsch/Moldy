local _, _, _, tocversion = GetBuildInfo()

if tocversion == 11500 then
    RAID_CLASS_COLORS["SHAMAN"] = CreateColorFromBytes(0, 112, 221, 255)
    RAID_CLASS_COLORS["SHAMAN"].colorStr = "ff0070dd"
end
