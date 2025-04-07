-- discord.gg/cvo1
--[[
getgenv().HippoSniper = {
    ["Items"] = {
        ['Misc'] = {
            ['Secret Key'] = { Price = 15000, pt = nil, sh = nil, tn = nil, Limit = 1000000, Terminal = true },
            ['Seed Bag'] = { Price = 2500, Terminal = false }
        },
    },
    ['All'] = {
        ['Pet'] = { 
            ['Huge'] = { Price = 15000000 },
            ['Titanic'] = { Price = 15000000 },
            ['Gargantuan'] = { Price = 15000000 },
        },
    },
    ['Url'] = "https://discord.com/api/webhooks/",
}
]]
repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService("Players").LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("__INTRO")
HippoSniper['All'] = HippoSniper['All'] or {}

local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local RAPCmds = require(Client.RAPCmds)
local Network = require(Client.Network)
local SaveMod = require(Client.Save)

if game.PlaceId == 8737899170 or game.PlaceId == 16498369169 then
    while true do
        Network.Invoke("Travel to Trading Plaza") task.wait(1)
    end
end

local SpecialClassCases, DirClassesTable = {Lootbox = "Lootboxes", Box = "Boxes", Misc = "MiscItems"}, {}
for Class, _ in pairs(require(Library.Items.Types).Types) do DirClassesTable[Class] = SpecialClassCases[Class] or Class .. "s" end

local FormatInt = function(int)
    local index, Suffix = 1, {"", "K", "M", "B", "T"}
    while int >= 1000 and index < #Suffix do
        int = int / 1000
        index = index + 1
    end
    return string.format(index == 1 and "%d" or "%.2f%s", int, Suffix[index])
end

local GetItem = function(Class, Id)
    local Inventory = SaveMod.Get().Inventory[Class] or {}
    for UID, v in pairs(Inventory) do
        if v.id == Id then return UID, v end
    end
end

local GetAssetId = function(Class, Info)
    local Directory = require(Library.Directory)
    local ItemTable = Directory[Class][Info.id]

    local Icon = nil

    if Info.tn then
        if ItemTable.Icon and type(ItemTable.Icon) == "function" then
            Icon = unpack(getupvalues(ItemTable.Icon))[Info.tn]
        elseif ItemTable.Tiers and ItemTable.Tiers[1] and ItemTable.Tiers[1].Effect then
            local EffectType = ItemTable.Tiers[1].Effect.Type
            Icon = EffectType and EffectType.Tiers and EffectType.Tiers[Info.tn].Icon
        end        
    end

    Icon = Icon or ItemTable.Icon or ItemTable.icon or ItemTable.thumbnail or "rbxassetid://0"
    return Icon
end

local GetRap = function(Class, ItemTable)
    local Item = require(Library.Items[Class .. "Item"])(ItemTable.id)

    if ItemTable.sh then Item:SetShiny(true) end
    if ItemTable.pt == 1 then Item:SetGolden() end
    if ItemTable.pt == 2 then Item:SetRainbow() end
    if ItemTable.tn then Item:SetTier(ItemTable.tn) end

    return RAPCmds.Get(Item) or 0
end

local SendWebhook = function(Class, ItemData, Gems)
    local AssetID = string.gsub(GetAssetId(DirClassesTable[Class], ItemData), "rbxassetid://", "")
    local Version = ItemData.pt == 1 and "Golden " or ItemData.pt == 2 and "Rainbow " or ""
    local Title = string.format("%s Sniped a %s%s%s (%sx)", LocalPlayer.Name, Version, ItemData.sh and "Shiny " or "", ItemData.id, ItemData._am or 1)
    local Rap = GetRap(Class, ItemData)
    local itmamt = 0

    for i,v in pairs(SaveMod.Get().Inventory[Class] or {}) do
        if string.find(ItemData.id, v.id) then
            itmamt = v._am or 1
        end
    end

    local Body = game:GetService("HttpService"):JSONEncode({
        content = "",
        embeds = {{
            title = Title,
            color = 0xFF00FF,
            timestamp = DateTime.now():ToIsoDate(),
            thumbnail = { url = string.format("https://biggamesapi.io/image/%s", AssetID) },
            fields = {{
                name = string.format("<:Booth:1242309582760448020> Price: %s ( %s Each )\n<:Pet:1242299008605749301> RAP: %s ( %s Each )\n<:Diamond:1242298786219556914> Gems Left: %s ( %s Inv Items)", FormatInt(Gems * (ItemData._am or 1)), FormatInt(Gems), FormatInt(Rap * (ItemData._am or 1)), FormatInt(Rap), FormatInt(LocalPlayer.leaderstats["💎 Diamonds"].Value), FormatInt(itmamt)), value = ""
            }},
            footer = { text = "Hippo" }
        }}
    })

    local sus err = pcall(function()
        return request({
            Url = HippoSniper['Url'],
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = Body
        })
    end)
end

local ValidItem = function(Class, Cost, Info)
    local ConfigItem = HippoSniper['Items'][Class] and HippoSniper['Items'][Class][Info.id]
    if ConfigItem and Cost <= ConfigItem.Price then
        local _, InvInfo = GetItem(Class, Info.id)
        local AmountToBuy = math.min(Info._am or 1, (ConfigItem.Limit or 0) - (InvInfo and InvInfo._am or 0))
        
        if AmountToBuy > 0 and Info.pt == ConfigItem.pt and Info.sh == ConfigItem.sh and Info.tn == ConfigItem.tn then
            return AmountToBuy
        end
    end

    if HippoSniper['All'][Class] then
        for i,v in pairs(HippoSniper['All'][Class]) do
            if string.find(Info.id, i) and Cost <= v.Price then
                return Info._am or 1
            end
        end
    end
    
    return 0
end

local CheckAllListings = function()
    local BoothFrontend = getsenv(LocalPlayer.PlayerScripts.Scripts.Game["Trading Plaza"]["Booths Frontend"])
    for _, Player in ipairs(game.Players:GetPlayers()) do
        local BoothInfo = BoothFrontend.getState(Player)
        if BoothInfo and BoothInfo.Listings then
            for ListingUID, Listing in pairs(BoothInfo.Listings) do
                if type(Listing.Item) == "table" then
                    local ListingPrice, Class, ItemData = Listing.DiamondCost, Listing.Item.Class.Name, Listing.Item._data
                    local AmountToBuy = ValidItem(Class, ListingPrice, ItemData)

                    if AmountToBuy > 0 then
                        local Bought = Network.Invoke("Booths_RequestPurchase", Player.UserId, { [ListingUID] = AmountToBuy })
                        if Bought then SendWebhook(Class, ItemData, ListingPrice) end
                    end
                end
            end
        end
    end
end

--SendWebhook("Misc", {id = "Secret Key" }, 1)
CheckAllListings()

while task.wait() do
    local TerminalItems, Classes = {}, {}

    for ClassName, _ in pairs(HippoSniper['Items']) do
        table.insert(Classes, ClassName)
    end

    local RandomClass = Classes[math.random(#Classes)]
    local ClassItems = HippoSniper['Items'][RandomClass]

    for ItemId, ItemInfo in pairs(ClassItems) do
        if ItemInfo.Terminal then
            table.insert(TerminalItems, ItemId)
        end
    end

    if #TerminalItems == 0 then
        continue
    end

    local RandomId = TerminalItems[math.random(#TerminalItems)]
    local ItemInfo = ClassItems[RandomId]

    local StackKey = game.HttpService:JSONEncode({id = RandomId, pt = ItemInfo.pt, sh = ItemInfo.sh, tn = ItemInfo.tn})
    local QueryResults = Network.Invoke("TradingTerminal_Search", RandomClass, StackKey, nil, true)
    
    if QueryResults then
        game:GetService("TeleportService"):TeleportToPlaceInstance(QueryResults.place_id, QueryResults.job_id, game.Players.LocalPlayer, nil, {TargetBoothId = QueryResults.booth, IsTerminalTeleport = true, TerminalStackKey = StackKey, TerminalClassName = RandomClass})
    end
end
