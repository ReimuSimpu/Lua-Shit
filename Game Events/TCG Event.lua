getgenv().Configuration = {
    ['Auto Mail'] = { -- same config as pira :P
        ["Items"] = {
            ['Lootbox'] = {
                ['Fantasy Pack'] = { Amount = 5 },
            }
        },
        ["Mail All Huges"] = false,
        ["Usernames"] = {"DOLLRVPED"},
    },
    ["Webhook"] = {
        ["UserID"] = "618580498251382824",
        ["WebhookURL"] = "https://discord.com/api/webhooks/",
    },    
    ['Event'] = {
        ['Combine Cards'] = true,
        ['Open Packs'] = {"Retro Pack", "Nightmare Pack"}, -- Opens Listed Packs
        ['Eggs To Hatch'] = {"Fantasy Pack"}, -- Leave Blank for all event
        ['Upgrades'] = {"CheaperPacks", "PurchaseMorePacks", "CheaperTradeIns", "BonusCardChance"}, -- Put in order of wanna max first
    },
    ['Debug'] = {true, true} -- Opt, Menu
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2f34b9422d65ebc3dbcba3aaad820dac.lua"))() 
