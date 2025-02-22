repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local Client = game:GetService('ReplicatedStorage').Library.Client
local OrbCmds = require(Client.OrbCmds.Orb)
local Network = require(Client.Network)

OrbCmds.CombineDelay, OrbCmds.CollectDistance, OrbCmds.DefaultPickupDistance, OrbCmds.CombineDistance = -math.huge, math.huge, math.huge, math.huge

while task.wait() do
    if workspace.__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild("FlowerGarden") then
        for i = 1, 10 do
            task.spawn(function()
                Network.Invoke("Instancing_InvokeCustomFromClient", "FlowerGarden", "PlantSeed", i, "Diamond")
                Network.Invoke("Instancing_InvokeCustomFromClient", "FlowerGarden", "InstaGrowSeed", i)
                Network.Invoke("Instancing_InvokeCustomFromClient", "FlowerGarden", "ClaimPlant", i)
            end)
            task.wait()
        end
    else
        setthreadidentity(2) require(Client.InstancingCmds).Enter("FlowerGarden") setthreadidentity(8) task.wait(1)
    end
end
