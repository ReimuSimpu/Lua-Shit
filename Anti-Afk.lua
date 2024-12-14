local LocalPlayer = game:GetService("Players").LocalPlayer

for _, v in getconnections(LocalPlayer.Idled) do 
    v:Disable() 
end 

LocalPlayer.Idled:Connect(function() 
    game.VirtualUser:CaptureController()
    game.VirtualUser:ClickButton2(Vector2.new()) 
end)
