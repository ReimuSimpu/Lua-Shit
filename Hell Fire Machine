-- U may share it to others idc but dont resale ( the idiots on pira )

getgenv().HellFireMachine = {
    ['Mail User'] = "",
    ['Mail Amount'] = 1,
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

while task.wait(HellFireMachine['Loop Time']) do
    local CrystalUID, CrystalInfo = GetItem("Misc", "Hellfire Crystal")

    if CrystalUID and CrystalInfo and (CrystalInfo._am or 1) >= 10 then
        Network.Invoke("HellfireMachine_Activate", CrystalInfo._am)
    end

    local CoreUID, CoreInfo = GetItem("Misc", "Hellfire Core")

    if CoreUID and CoreInfo and (CoreInfo._am or 1) >= HellFireMachine['Mail Amount'] and HellFireMachine['Mail User'] ~= LocalPlayer.Name then
        Network.Invoke("Mailbox: Send", HellFireMachine['Mail User'], "Hippo", "Misc", CoreUID, CoreInfo._am or 1)
    end
end
