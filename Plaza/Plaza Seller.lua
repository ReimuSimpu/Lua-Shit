repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService("Players").LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local RAPCmds = require(Client.RAPCmds)
local Network = require(Client.Network)
local Savemod = require(Client.Save)

if game.PlaceId == 8737899170 or game.PlaceId == 16498369169 then
    while true do 
        Network.Invoke("Travel to Trading Plaza") task.wait(1) 
    end
end

local GetRap = function(Class, ItemTable)
    local Item = require(Library.Items[Class .. "Item"])(ItemTable.id)

    if ItemTable.sh then Item:SetShiny(true) end
    if ItemTable.pt == 1 then Item:SetGolden() end
    if ItemTable.pt == 2 then Item:SetRainbow() end
    if ItemTable.tn then Item:SetTier(ItemTable.tn) end

    return RAPCmds.Get(Item) or 0
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

-- Claim Booth
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

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
LocalPlayer.Idled:Connect(function() VirtualUser:ClickButton2(Vector2.new(math.random(0, 1000), math.random(0, 1000))) end)

old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() then
        local Name = tostring(self)
        if table.find({"Server Closing", "Idle Tracking: Update Timer", "Move Server"}, Name) then
            return nil
        end
    end
    return old(self, ...)
end)
Network.Fire("Idle Tracking: Stop Timer")

-- List Booth
while task.wait(5) do 
    local BoothQueue = {}
    for Class, Items in pairs(Savemod.Get().Inventory) do
        if HippoSeller.Items[Class] then
            for _, v in pairs(Items) do
                local Item = HippoSeller.Items[Class][v.id]
                if Item and Item.pt == v.pt and Item.sh == v.sh and Item.tn == v.tn then
                    table.insert(BoothQueue, {Price = Item.Price, UUID = _, Item = v, Rap = GetRap(Class, v)})
                end
            end
        end
    end
    table.sort(BoothQueue, function(a, b) return a.Rap > b.Rap end)
    
    for _, v in ipairs(BoothQueue) do
        local MaxAmount = math.min(v.Item._am or 1, 15000, math.floor(25e9 / ConvertPrice(v.Price, v.Rap)))
        Network.Invoke("Booths_CreateListing", v.UUID, math.ceil(ConvertPrice(v.Price, v.Rap)), MaxAmount) task.wait(1)
    end
end
