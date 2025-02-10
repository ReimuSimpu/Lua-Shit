local LocalPlayer = game:GetService("Players").LocalPlayer

for _, v in getconnections(LocalPlayer.Idled) do 
    v:Disable() 
end 

LocalPlayer.Idled:Connect(function() 
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new()) 
end)
--test
