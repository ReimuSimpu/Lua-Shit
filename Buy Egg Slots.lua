repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService("Players").LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Client = Library.Client

local Savemod = require(Client.Save)
local Network = require(Client.Network)
local RankCmds = require(Client.RankCmds)

local PurchasedSlots = Savemod.Get()["EggSlotsPurchased"]

while PurchasedSlots < RankCmds.GetMaxPurchasableEggSlots() do
    local EggSlotInfo = RankCmds.GetEggBundle(PurchasedSlots + 1)
    if Network.Invoke("EggHatchSlotsMachine_RequestPurchase", EggSlotInfo) then
        PurchasedSlots += 1
    end
    task.wait(0.1)
end
