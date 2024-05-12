repeat wait() until game:IsLoaded()
repeat wait() until game:GetService("Players").LocalPlayer
repeat wait() until not game.Players.LocalPlayer.PlayerGui:FindFirstChild("__INTRO")
print("Serverhopping To Plaza")
if game.PlaceId == 8737899170 or game.PlaceId == 15588442388 then 
    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Travel to Trading Plaza"):InvokeServer()
    task.wait(30)
    game:GetService("TeleportService"):Teleport(15502339080, game.Players.LocalPlayer)
else 
    game:GetService("TeleportService"):Teleport(8737899170, game.Players.LocalPlayer)
end
