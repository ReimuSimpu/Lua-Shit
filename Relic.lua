repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local Active = workspace.__THINGS.__INSTANCE_CONTAINER.Active
local Client = game:GetService('ReplicatedStorage').Library.Client
local Network = require(Client.Network)
local SaveMod = require(Client.Save)
local InstancingCmds = require(Client.InstancingCmds)

local Relics = {}

for i, v in pairs(Network.Invoke("Relics_Request")) do
    if not SaveMod.Get().ShinyRelics[i] then
        Relics[i] = v
    end
end

local ClaimRelic = function(Id, Data)
    local Claimed = false
    while not Claimed do
        LocalPlayer.Character.HumanoidRootPart.CFrame = Data.Position
        Claimed = Network.Invoke("Relic_Found", Id)
        task.wait(0.1)
    end
end

for i, v in pairs(Relics) do
    if v.ParentType == 1 then
        ClaimRelic(i, v)
    elseif v.ParentType == 2 and InstancingCmds.DoesMeetRequirement(v.ParentId) then
        while not Active:FindFirstChild(v.ParentId) do
            setthreadidentity(2) InstancingCmds.Enter(v.ParentId) setthreadidentity(8) task.wait(1)
        end

        ClaimRelic(i, v)

        while Active:FindFirstChild(v.ParentId) do
            setthreadidentity(2) InstancingCmds.Leave(v.ParentId) setthreadidentity(8) task.wait(1)
        end
    end
end
