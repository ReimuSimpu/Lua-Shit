-- U may share it to others idc but dont resale ( the idiots on pira )

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local SaveMod = require(game.ReplicatedStorage.Library.Client.Save)
local Network = require(game.ReplicatedStorage.Library.Client.Network)

local GetItem = function(Class, Id)
    local Inventory = SaveMod.Get().Inventory[Class] or {}
    for UID, v in pairs(Inventory) do
        if v.id == Id then
            return UID, v
        end
    end
end

while task.wait() do
    local CoreUID, CoreInfo = GetItem("Misc", "Hellfire Core")
    if not CoreUID then break end
    Network.Invoke("HellFireCore_SpawnRequest", CoreUID)
end
