-- Ik not worth much or have much use but posting anyways

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local CurrencyCmds = require(Client.CurrencyCmds)
local TycoonCmds = require(Client.TycoonCmds)
local Network = require(Client.Network)
local SaveMod = require(Client.Save)

local GetPurchasableButtons = function()
    local Data = TycoonCmds.Get()
    local PlayerCurrency = CurrencyCmds.Get("CannonTycoonCoins")
    local ButtonNames = {}

    if Data then
        for Name, Ref in pairs(Data._buttonRefs) do
            local ButtonData = Data._dir.Purchasables[Name]
            local Price = ButtonData and ButtonData.Price and ButtonData.Price._data and ButtonData.Price._data._am or 0
            if PlayerCurrency >= Price then
                table.insert(ButtonNames, Name)
            end
        end
    end

    return ButtonNames
end

-- Button shit
task.spawn(function()
    while task.wait(0.15) do
        for _, button in pairs(GetPurchasableButtons()) do
            Network.Invoke("Tycoons: Purchase", button)
        end
    end
end)

-- Rebrith
task.spawn(function()
    while task.wait(1) do
        if TycoonCmds.Get()._progressCache >= 1 then
            Network.Invoke("Tycoons: Rebirth")
        end
    end
end)
