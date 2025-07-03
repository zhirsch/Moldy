local QuestieDB = QuestieLoader:ImportModule("QuestieDB")
local ZoneDB = QuestieLoader:ImportModule("ZoneDB")

local function IsBonfireQuest(quest)
    if quest and (quest.zoneOrSort == -369 or quest.zoneOrSort == -22) and quest.name then
        return quest.name:find("Honor the Flame")
            or quest.name:find("Desecrate this Fire")
    end
end

local function AddWaypointForQuest(quest)
    local name = quest.name .. " (" .. quest.Id .. ")"
    local spawns = {}
    for _, objectId in pairs(quest.Finisher.GameObject or {}) do
        local obj = QuestieDB:GetObject(objectId)
        tinsert(spawns, obj.spawns)
    end
    for _, npcId in pairs(quest.Finisher.NPC or {}) do
        local npc = QuestieDB:GetNPC(npcId)
        tinsert(spawns, npc.spawns)
    end
    for _, spawn in ipairs(spawns) do
        for zone, coords in pairs(spawn) do
            local mapID = ZoneDB:GetUiMapIdByAreaId(zone)
            if not mapID then return end
            local x, y = coords[1][1]/100, coords[1][2]/100
            TomTom:AddWaypoint(mapID, x, y, { 
                title = name,
                persistent = false,
                crazy = true,
                from = "MoldyMidsummer",
            })
        end
    end
end


local function AddWaypointForQuests()
    for questId in pairs(QuestieDB.QuestPointers) do
        if QuestieDB.IsDoable(questId) then
            local quest = QuestieDB.GetQuest(questId)
            if IsBonfireQuest(quest) then
                AddWaypointForQuest(quest)
            end
        end
    end
end

SLASH_MIDSUMMER1 = "/msq"
SlashCmdList["MIDSUMMER"] = function()
    AddWaypointForQuests()
end
