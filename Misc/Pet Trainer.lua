local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local Network = require(Client.Network)
local Savemod = require(Client.Save)

local CheckQuest = function(PetID)
    for i,v in pairs(Savemod.Get().NPCQuests.ElementalQuests.Quests) do
        if v.PetID == PetID and v.Amount > v.Progress then
            return true
        end
    end
    return false
end

local IsQuestsFinished = function()
    for i,v in pairs(Savemod.Get().NPCQuests.ElementalQuests.Quests) do
        if v.Progress < v.Amount then
            return false
        end
    end
    return true
end

while task.wait() do
    for i, v in pairs(Savemod.Get().RoamingPets or {}) do
        if CheckQuest(v.Pet.id) then
            local success = Network.Invoke("RoamingPets_CatchPet", "Pet Cube", i)
            if success then
                print(string.format("Caught: %s (%d%%)", v.Pet.id, v.Chance * 100))
            end
        end
        task.wait(0.1)
    end

    if IsQuestsFinished() then
        -- Claim Gift Remote
    end
end
