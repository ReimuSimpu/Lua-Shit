while task.wait(0.1) do
    for i,v in pairs(workspace["Zombie Storage"]:GetChildren()) do
        pcall(function()
            local args = {
                [1] = "Explode",
                [2] = v.PrimaryPart.Position
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RocketEvent"):FireServer(unpack(args)) 
        end)
    end
end
