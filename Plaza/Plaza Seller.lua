getgenv().HippoSeller = {
    ["Items"] = {
        ['Misc'] = {
            ['Secret Key'] = { Price = "100%", pt = nil, sh = nil, tn = nil },
            ['Seed Bag'] = { Price = "95%" }
        },
    },
}

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService("Players").LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

local Client = game.ReplicatedStorage.Library.Client

local RapCmds = require(Client.DevRAPCmds)
local Network = require(Client.Network)
local Savemod = require(Client.Save)

if game.PlaceId == 8737899170 or game.PlaceId == 16498369169 then
    while true do 
        Network.Invoke("Travel to Trading Plaza") task.wait(1) 
    end
end

local GetRap = function(Class, ItemTable)
    return RapCmds.Get({
        Class = { Name = Class },
        IsA = function(InputClass) return InputClass == Class end,
        GetId = function() return ItemTable.id end,
        StackKey = function()
            return game:GetService("HttpService"):JSONEncode({id = ItemTable.id, sh = ItemTable.sh, pt = ItemTable.pt, tn = ItemTable.tn})
        end
    }) or 0
end
local ConvertPrice = function(Price, Rap)
    if type(Price) == "string" then
        local Percentage = tonumber(Price:match("^(%d+)%%"))
        if Percentage then
            return (Percentage / 100) * Rap
        end
    end
    return Price
end

local ListItems = function()
    local BoothQueue = {}
    for Class, Items in pairs(Savemod.Get().Inventory) do
        local ItemClass = HippoSeller.Items[Class]
        if ItemClass then
            for _, v in pairs(Items) do
                local Item = ItemClass[v.id]
                if Item and Item.pt == v.pt and Item.sh == v.sh and Item.tn == v.tn then
                    if v._lk then repeat task.wait(0.1) until Network.Invoke("Locking_SetLocked", _, false) end
                    table.insert(BoothQueue, {Price = Item.Price, UUID = _, Item = v, Rap = GetRap(Class, v)})
                end
            end
        end
    end
    table.sort(BoothQueue, function(a, b) return a.Rap > b.Rap end)

    for _,v in ipairs(BoothQueue) do
        local MaxAmount = math.min(v.Item._am or 1, 15000, math.floor(25e9 / ConvertPrice(v.Price, v.Rap)))
        local Success, err = false, ""
        while not Success and err ~= "You don't have enough of that item!" do
            Success, err = Network.Invoke("Booths_CreateListing", v.UUID, math.ceil(ConvertPrice(v.Price, v.Rap)), MaxAmount)
            task.wait(1)
        end
    end
end

local HaveBooth = false
while not HaveBooth do 
    local BoothSpawns = game.workspace.TradingPlaza.BoothSpawns:FindFirstChildWhichIsA("Model")
    for _, Booth in ipairs(workspace.__THINGS.Booths:GetChildren()) do
        if Booth:IsA("Model") and Booth.Info.BoothBottom.Frame.Top.Text == LocalPlayer.DisplayName .. "'s Booth!" then
            HaveBooth = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = Booth.Table.CFrame * CFrame.new(5, 0, 0)
            break
        end
    end
    if not HaveBooth then
        LocalPlayer.Character.HumanoidRootPart.CFrame = BoothSpawns.Table.CFrame * CFrame.new(5, 0, 0)
        Network.Invoke("Booths_ClaimBooth", tostring(BoothSpawns:GetAttribute("ID")))
    end
end

while task.wait(5) do
    ListItems()
end
