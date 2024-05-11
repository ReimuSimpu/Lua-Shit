local TradingPlaza = 15502339080
local PS99 = 8737899170

repeat wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until not game.Players.LocalPlayer.PlayerGui:FindFirstChild("__INTRO")
print("Serverhopping To Plaza")
wait(10)

local function jumpToServer(placeId)
    local function getServerList(placeId)
        local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true"
        local req = request({ Url = string.format(sfUrl, placeId, "Desc", 50) })
        local body = game:GetService("HttpService"):JSONDecode(req.Body)
        local deep = math.random(1, 3)

        if deep > 1 then
            for i = 1, deep do
                req = request({ Url = string.format(sfUrl .. "&cursor=" .. body.nextPageCursor, placeId, "Desc", 50) })
                body = game:GetService("HttpService"):JSONDecode(req.Body)
                task.wait(0.1)
            end
        end
        local servers = {}
        if body and body.data then
            for i, v in ipairs(body.data) do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
        end
        return servers
    end
    local servers = getServerList(placeId)
    if #servers > 0 then
        local randomServerIndex = math.random(1, #servers)
        game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, servers[randomServerIndex], game:GetService("Players").LocalPlayer)
    end
end

while wait() do
    if game.PlaceId == PS99 or game.PlaceId == 16498369169 then
        jumpToServer(TradingPlaza)
    else
        jumpToServer(PS99)
    end
end
