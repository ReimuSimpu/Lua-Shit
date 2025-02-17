-- U may share it to others idc but dont resale ( the idiots on pira )
-- discord.gg/fnxh8zUmTx

getgenv().Webhook = {
    ['ID'] = "",
    ['URL'] = "",
}

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService('Players').LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild('__INTRO')

local Library = game.ReplicatedStorage.Library
local Client = Library.Client

local ExistCmds = require(Client.ExistCountCmds)
local RapCmds = require(Client.DevRAPCmds)
local Network = require(Client.Network)
local SaveMod = require(Client.Save)

local Formatint = function(int)
    local Suffix = {"", "k", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No", "De", "UDe", "DDe", "TDe", "QdDe", "QnDe", "SxDe", "SpDe", "OcDe", "NoDe", "Vg", "UVg", "DVg", "TVg", "QdVg", "QnVg", "SxVg", "SpVg", "OcVg", "NoVg", "Tg", "UTg", "DTg", "TTg", "QdTg", "QnTg", "SxTg", "SpTg", "OcTg", "NoTg", "QdAg", "QnAg", "SxAg", "SpAg", "OcAg", "NoAg", "e141", "e144", "e147", "e150", "e153", "e156", "e159", "e162", "e165", "e168", "e171", "e174", "e177", "e180", "e183", "e186", "e189", "e192", "e195", "e198", "e201", "e204", "e207", "e210", "e213", "e216", "e219", "e222", "e225", "e228", "e231", "e234", "e237", "e240", "e243", "e246", "e249", "e252", "e255", "e258", "e261", "e264", "e267", "e270", "e273", "e276", "e279", "e282", "e285", "e288", "e291", "e294", "e297", "e300", "e303"}
    local Index = 1
    
    if int < 999 then 
        return int
    end
    while int >= 1000 and Index < #Suffix do
        int = int / 1000
        Index = Index + 1
    end
    return string.format("%.2f%s", int, Suffix[Index])
end

local GetAsset = function(Id, pt)
    local Asset = require(Library.Directory.Pets)[Id]
    return string.gsub(Asset and (pt == 1 and Asset.goldenThumbnail or Asset.thumbnail) or "14976456685", "rbxassetid://", "")
end

local GetStats = function(Cmds, Class, ItemTable)
    return Cmds.Get({
        Class = { Name = Class },
        IsA = function(InputClass) return InputClass == Class end,
        GetId = function() return ItemTable.id end,
        StackKey = function()
            return game:GetService("HttpService"):JSONEncode({id = ItemTable.id, sh = ItemTable.sh, pt = ItemTable.pt, tn = ItemTable.tn})
        end
    }) or nil
end

local SendWebhook = function(Id, pt, sh)
    local Img = string.format("https://biggamesapi.io/image/%s", GetAsset(Id, pt))
    local Version = pt == 1 and "Golden " or pt == 2 and "Rainbow " or ""
    local Title = string.format("||%s|| Obtained a %s%s%s", LocalPlayer.Name, Version, sh and "Shiny " or "", Id)

    local Exist = GetStats(ExistCmds, "Pet", { id = Id, pt = pt, sh = sh, tn = nil })
    local Rap = GetStats(RapCmds, "Pet", { id = Id, pt = pt, sh = sh, tn = nil })

    local Body = game:GetService("HttpService"):JSONEncode({
        content = string.format("<@%s>", Webhook['ID']),
        embeds = {
            {
                title = Title,
                color = 0xFF00FF,
                timestamp = DateTime.now():ToIsoDate(),
                thumbnail = { url = Img },
                fields = {
                    { name = string.format("💎 Rap: ``%s`` \n💫 Exist: ``%s``", Formatint(Rap or 0), Formatint(Exist or 0)), value = "" }
                },
                footer = { text = "Hippo" }
            }
        }
    })
    
    local sus, err = pcall(function()
        return request({
            Url = Webhook['URL'],
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = Body
        })
    end)
end

Network.Fired('Items: Update'):Connect(function(Player, Inv)
    if Inv['set'] and Inv['set']['Pet'] then
        for i,v in pairs(Inv['set']['Pet']) do
            if string.find(v.id, "Huge") or string.find(v.id, "Titanic") or string.find(v.id, "Gargantuan") then
                SendWebhook(v.id, v.pt, v.sh)
            end
        end
    end
end)

--SendWebhook("Huge Hippo") --[[ Test thing ]]
