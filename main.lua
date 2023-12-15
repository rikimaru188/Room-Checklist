roomChecklistMod = RegisterMod("Room Checklist", 1)

local game = Game()
local json = require("json")
local f = Font() -- init font object
f:Load("font/terminus.fnt") -- load a font into the font object

local isNewlyVisited = ""

function roomChecklistMod:EvaluateRoom()
    local listOfRoomsSeen = {}
    if roomChecklistMod:HasData() then
        listOfRoomsSeen = json.decode(Isaac.LoadModData(roomChecklistMod))
    end

    local level = game:GetLevel()
    local variant = string.format("%s",level:GetCurrentRoomDesc().Data.Variant)
    local roomType = string.format("%s",level:GetCurrentRoomDesc().Data.Type)
    local stageId = string.format("%s",level:GetCurrentRoomDesc().Data.StageID)
    local isVisited = false

    if listOfRoomsSeen[stageId] == nil then
        listOfRoomsSeen[stageId] = {}
        listOfRoomsSeen[stageId][roomType] = {}
        isVisited = false
    elseif listOfRoomsSeen[stageId][roomType] == nil then
        listOfRoomsSeen[stageId][roomType] = {}
    else
        for _,v in pairs(listOfRoomsSeen[stageId][roomType]) do
            if v == variant then
                isVisited = true
                break
            end
        end
    end

    if isVisited then
        isNewlyVisited=""
        f:DrawString(isNewlyVisited,130,0,KColor(1,1,1,1),0,true)
    else
        table.insert(listOfRoomsSeen[stageId][roomType],variant)
        Isaac.SaveModData(roomChecklistMod, json.encode(listOfRoomsSeen))
        isNewlyVisited="New Room"
    --add sound effect for new room found?
    end
end

function roomChecklistMod:newPlace()
    f:DrawString(isNewlyVisited,130,0,KColor(1,1,1,1),0,true)
end


roomChecklistMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, roomChecklistMod.EvaluateRoom)
roomChecklistMod:AddCallback(ModCallbacks.MC_POST_RENDER, roomChecklistMod.newPlace)

