getgenv().ValentinesMachine = {
    ['Loop Time'] = 60,
}

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local Client = game.ReplicatedStorage.Library.Client

local SaveMod = require(Client.Save)
local Network = require(Client.Network)

local GetItem = function(Class, Id)
    for UID, v in pairs(SaveMod.Get()['Inventory'][Class] or {}) do
        if v.id == Id then
            return UID, v
        end
    end
end

while task.wait(ValentinesMachine['Loop Time']) do
    local HeartUID, HeartInfo = GetItem("Misc", "Valentines Heart")

    if HeartUID and HeartInfo and (HeartInfo._am or 1) >= 10 then
        Network.Invoke("ValentinesMachine_Activate", HeartInfo._am)
    end
end
