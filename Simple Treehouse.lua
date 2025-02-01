local Client = game.ReplicatedStorage.Library.Client
local SaveMod = require(Client.Save)
local Network = require(Client.Network)

local GetRap = function(Class, Item)
    local StackKey = game.HttpService:JSONEncode({id = Item.id, sh = Item.sh, pt = Item.pt, tn = Item.tn})
    return require(Client.DevRAPCmds).Get({
        Class = {Name = Class},
        IsA = function(InputClass) return InputClass == Class end,
        GetId = function() return Item.id end,
        StackKey = function() return StackKey end
    }, 0)
end

while task.wait() do
    local BR, BI = -math.huge, nil

    while not SaveMod.Get()["SecretRooms"]["Treehouse Merchant"] do 
        Network.Invoke("SecretRoom_Unlock", "Treehouse Merchant") task.wait()
    end

    Network.Invoke("Instancing_PlayerEnterInstance", "TreehouseMerchant")

    local SecretRoom = SaveMod.Get()["SecretRooms"]["Treehouse Merchant"]
    if SecretRoom and type(SecretRoom) == "table" then
        for I,V in pairs(SecretRoom) do
            local Data = V.data
            local ItemRap = (Data.id == "Old Boot" or Data.id == "Rainbow Swirl") and 100 or GetRap(V.class, {id = Data.id, pt = Data.pt, sh = Data.sh, tn = Data.tn})
            if ItemRap > BR then 
                BI, BR = I, ItemRap     
            end
        end
        Network.Invoke("TreehouseMerchant_Purchase", BI)
    end
end


