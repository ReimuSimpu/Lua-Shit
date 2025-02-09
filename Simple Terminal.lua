-- U may share it to others idc but dont resale ( the idiots on pira )
-- discord.gg/fnxh8zUmTx

getgenv().HippoSniper = {
    ["Items"] = {
        ['Misc'] = {
            ['Secret Key'] = { Price = 15000, pt = nil, sh = nil, tn = nil, Limit = 1000000, Terminal = true },
            ['Seed Bag'] = { Price = 2500, Terminal = true }
        },
        ['Consumable'] = {
            ['Tower Luck Booster'] = { Price = 1, pt = nil, sh = nil, tn = 1, Limit = 1000000, Terminal = true },
        },
    },
    ['Url'] = "https://discord.com/api/webhooks/",
}

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService("Players").LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local RapCmds = require(Client.DevRAPCmds)
local Network = require(Client.Network)
local SaveMod = require(Client.Save)

local SpecialClassCases, DirClassesTable = {Lootbox = "es", Box = "es", Misc = "MiscItems"}, {}
for Class, _ in pairs(require(Library.Items.Types).Types) do DirClassesTable[Class] = SpecialClassCases[Class] or Class .. "s" end

local FormatInt = function(int)
    local index, Suffix = 1, {"", "k", "M", "B", "T"}
    while int >= 1000 and index < #Suffix do
        int, index = int / 1000, index + 1
    end
    return string.format(int < 1000 and "%d" or "%.2f%s", int, Suffix[index])
end

local GetItem = function(Class, Id)
    local Inventory = SaveMod.Get().Inventory[Class] or {}
    for UID, v in pairs(Inventory) do
        if v.id == Id then return UID, v end
    end
end

local GetAssetId = function(Class, Info)
    local ItemTable = require(Library.Directory)[Class][Info.id]
    return Info.tn and unpack(getupvalues(ItemTable.Icon))[Info.tn] or ItemTable.Icon or ItemTable.icon or ItemTable.thumbnail
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

local SendWebhook = function(Class, ItemData, Gems)
    local AssetID = string.gsub(GetAssetId(DirClassesTable[Class], ItemData), "rbxassetid://", "")
    local Version = ItemData.pt == 1 and "Golden " or ItemData.pt == 2 and "Rainbow " or ""
    local Title = string.format("||%s|| Sniped a %s%s%s (%sx)", LocalPlayer.Name, Version, ItemData.sh and "Shiny " or "", ItemData.id, ItemData._am or 1)
    local Rap = GetRap(Class, ItemData)

    local Body = game:GetService("HttpService"):JSONEncode({
        content = "",
        embeds = {{
            title = Title,
            color = 0xFF00FF,
            timestamp = DateTime.now():ToIsoDate(),
            thumbnail = { url = string.format("https://biggamesapi.io/image/%s", AssetID) },
            fields = {{
                name = string.format("<:Booth:1242309582760448020> Price: %s ( %s Each )\n<:Pet:1242299008605749301> RAP: %s ( %s Each )\n<:Diamond:1242298786219556914> Gems Left: %s", FormatInt(Gems * (ItemData._am or 1)), FormatInt(Gems), FormatInt(Rap * (ItemData._am or 1)), FormatInt(Rap), FormatInt(LocalPlayer.leaderstats["💎 Diamonds"].Value)), value = ""
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

CheckAllListings()

while task.wait() do
    local TerminalItems, Classes = {}, {}

    for Name, _ in pairs(HippoSniper['Items']) do table.insert(Classes, Name) end

    local RandomClass = Classes[math.random(#Classes)]
    local ClassItems = HippoSniper['Items'][RandomClass]

    for ItemId, ItemInfo in pairs(ClassItems) do if ItemInfo.Terminal then table.insert(TerminalItems, ItemId) end end

    local RandomId = TerminalItems[math.random(#TerminalItems)]
    local ItemInfo = ClassItems[RandomId]

    local StackKey = game.HttpService:JSONEncode({id = RandomId, pt = ItemInfo.pt, sh = ItemInfo.sh, tn = ItemInfo.tn})
    local QueryResults = Network.Invoke("TradingTerminal_Search", RandomClass, StackKey, nil, true)
    
    if QueryResults then
        game:GetService("TeleportService"):TeleportToPlaceInstance(QueryResults.place_id, QueryResults.job_id, game.Players.LocalPlayer, nil, {TargetBoothId = QueryResults.booth, IsTerminalTeleport = true, TerminalStackKey = StackKey, TerminalClassName = RandomClass})
    end
end
