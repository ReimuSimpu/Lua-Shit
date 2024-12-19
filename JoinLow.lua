local ServerList = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

function ListServers(cursor)
   local Raw = game:HttpGet(ServerList .. ((cursor and "&cursor="..cursor) or ""))
   return game.HttpService:JSONDecode(Raw)
end

local Server, Next; repeat
   local Servers = ListServers(Next)
   Server = Servers.data[1]
   Next = Servers.nextPageCursor
until Server

game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId , Server.id, game.Players.LocalPlayer)
