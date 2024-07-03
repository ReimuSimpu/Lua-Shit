local HttpService = game:GetService("HttpService")

local JobIDs = {}
    repeat
        task.wait(0.1)
        local API = HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100" .. (ServerPages and "&cursor=" .. ServerPages or ""))
        )
        for _, v in ipairs(API["data"]) do
            if v["id"] ~= game.JobId and v["playing"] ~= v["maxPlayers"] then
                table.insert(JobIDs, v["id"])
            end
        end
        ServerPages = API.nextPageCursor
    until #JobIDs >= 100
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, JobIDs[math.random(1, #JobIDs)])
