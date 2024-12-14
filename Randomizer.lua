--https://www.roblox.com/games/5307215810/Randomizer-NIGHTMARE-BEFORE-CHRISTMAS
-- Made by LordHippo (.lordhippo)

getgenv().Config = {
    ['Claim Airdrops'] = true,
    ['Claim Candycorn'] = true,
    ['Med Kits'] = true,
}

local LocalPlayer, KillEnabled = game.Players.LocalPlayer, false

if Config['Claim Airdrops'] then
    workspace.Airdrops.ChildAdded:Connect(function(v)
        task.spawn(function()
            while v.Parent == workspace.Airdrops do
                pcall(function() 
                    fireproximityprompt(v:FindFirstChild("ProximityPrompt")) 
                end)
                task.wait(0.1)
            end
        end)
    end)
end

if Config['Claim Candycorn'] then
    workspace.CandyCorn.ChildAdded:Connect(function(v)
        task.spawn(function()
            while v.Parent == workspace.CandyCorn do
                pcall(function() 
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Holder, 0) 
                end)
                task.wait(0.1)
            end
        end)
    end)
end

if Config['Med Kits'] then
    task.spawn(function()
        while task.wait() do
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "Health" then
                    pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0) end)
                end
            end
        end
    end)
end

game.UserInputService.InputBegan:Connect(function(input, GameProcessed)
    if GameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        KillEnabled = not KillEnabled
        print("Killing toggled", KillEnabled and "ON" or "OFF")
    end
end)

while task.wait() do
    if KillEnabled then
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                pcall(function()
                    local Gun = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if Gun and Gun:FindFirstChild("Setting") then
                        local GunSettings = require(Gun.Setting)
                        Gun.GunServer.HitTest:InvokeServer(v.Character.Head, v.Character.Head.Position, Vector3.zero, "Character", GunSettings.BaseDamage)
                    end
                end)
            end
        end
    end
end
