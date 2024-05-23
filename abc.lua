local Webhook = "https://discord.com/api/webhooks/1242988977967861840/TBrt84ndZAzbCLmpbrrfFF0Dp_alrGJczMic9hNFCt4xc3uJtFRqT0ebkA9D8LUvKUYH"
local HttpService = game:GetService("HttpService")
local RepStor = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Library = require(RepStor:WaitForChild("Library"))
local SaveMod = require(RepStor.Library.Client.Save)

local function FormatWithCommas(number)
    return tostring(number):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function FormatInventory()
    local inventoryString = ""
    local Inventory = SaveMod.Get()["Inventory"]
    for Class, Inv in pairs(Inventory) do
        for uid, Item in pairs(Inv) do
            local Amount = Item._am or 1
            if string.find(Item.id, "Huge") or string.find(Item.id, "Titanic") or string.find(Item.id, "Chest Mimic") or string.find(Item.id, "Arcade Egg") or string.find(Item.id, "Key") or string.find(Item.id, "Token") then
                inventoryString = inventoryString .. Item.id .. " x" .. Amount .. "\n"
            end
        end
    end
    return inventoryString
end

local function SendStats()
    local PlayerGems = game.Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
    local msg = {
        content = "",
        embeds = {
            {
                author = {
                    name = "",
                    icon_url = "",
                },
                username = "Touhou Stat Bot",
                title = Player.Name .. " OWNER: <@" .. (LRM_LinkedDiscordID or "UNKNOWN") .. ">",
                color = 0x00FF00,
                timestamp = DateTime.now():ToIsoDate(),
                thumbnail = {
                    url = "",
                },
                fields = {
                    { name = "<:Diamond:1242298786219556914> Gems: " .. FormatWithCommas(PlayerGems) .. "" , value = "", inline = false },
                    { name = "Inventory:", value = FormatInventory(), inline = false },
                },               
                footer = {
                    text = "Touhou Stat Bot | gg/AnDdfX3DX3"
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

SendStats()
