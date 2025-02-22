-- Publishing my old stuff

getgenv().CFG = {
    Wheels = {"VoidWheel"}, -- (NEED TO BE IN SAME WORLD)
    Items = { -- You can add more items using the same names as in Wheels
        ['VoidWheel'] = {
            {Class = "Currency", ID = "Diamonds", TN = nil, PT = nil, SH = nil}
        },
        ['Try Huges'] = true,
    },
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function GetWheelItems(Wheel)
    local WheelItemsTable = require(ReplicatedStorage.Library.Client.SpinnyWheelCmds).Get(Wheel).DropTable._caches.flatTable
    local WheelItems = {}
    for _, value in pairs(WheelItemsTable) do
        for _, v in pairs(value) do
            if type(v) == "table" then
                local Class, Item, Amount = v.Class.Name, v._data.id, v._data._am or 1
                local TN, PT, SH = v._data.tn, v._data.pt, v._data.sh
                table.insert(WheelItems, {Class = Class, Item = Item, Amount = Amount, TN = TN, PT = PT, SH = SH})
            end
        end
    end
    return WheelItems
end

function ServerHop()
    local JobIDs = {} 
    repeat
        task.wait(0.1) 
        local API = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"..(ServerPages and "&cursor="..ServerPages or ""))) 
        for i, v in pairs(API["data"] or {}) do 
            if v["id"] ~= game.JobId and v["playing"] < v["maxPlayers"] then
                table.insert(JobIDs, v["id"]) 
            end
        end
        ServerPages = API.nextPageCursor
    until #JobIDs >= 300 or not ServerPages 
    if #JobIDs > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, JobIDs[math.random(1, #JobIDs)]) 
    else
        warn("No valid servers found.")
    end
end

local Found_Item = true
while Found_Item do
    Found_Item = false
    for _, Wheel in pairs(CFG.Wheels) do
        local WheelItems = GetWheelItems(Wheel)
        for _, Config in pairs(CFG.Items[Wheel]) do
            local Huge, ConfigMatched = false, false
            
            for _, WI in pairs(WheelItems) do
                Huge = CFG.Items['Try Huges'] and WI.Class == "Pet" and string.find(WI.Item, "Huge")
                ConfigMatched = Config.Class == WI.Class and Config.ID == WI.Item and Config.TN == WI.TN and Config.SH == WI.SH
                
                if Huge or ConfigMatched then Found_Item = true
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Spinny Wheel: Request Spin"):InvokeServer(Wheel) task.wait(0.5)
                end
            end
        end
    end
    if not Found_Item then
        break
    end
end

while true do
    ServerHop() task.wait(0.1)
end
