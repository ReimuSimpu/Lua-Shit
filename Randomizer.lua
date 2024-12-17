--https://www.roblox.com/games/5307215810/Randomizer-NIGHTMARE-BEFORE-CHRISTMAS
-- Made by LordHippo (.lordhippo)

getgenv().Config = {
    ['Auto Kill'] = true,
    ['Claim Airdrops'] = true,
    ['Claim Candycorn'] = true,
    ['Med Kits'] = true,
}

local LocalPlayer = game.Players.LocalPlayer

local TriggerTouchInteraction = function(v)
    if v then 
        pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0) end)
    end
end

local GetGun = function()
    local HeldItem = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    local Backpack = LocalPlayer.Backpack:GetChildren()

    if HeldItem and HeldItem:FindFirstChild("Setting") then
        return HeldItem
    else
        for _, v in pairs(Backpack) do
            if v:FindFirstChild("GunLocal") and v:FindFirstChild("Setting") then
                return v
            end
        end
    end
    return nil
end

game.UserInputService.InputBegan:Connect(function(input, GameProcessed)
    if not GameProcessed and input.KeyCode == Enum.KeyCode.V then
        Config['Auto Kill'] = not Config['Auto Kill']
        print("Auto Kill is now", Config['Auto Kill'] and "ON" or "OFF")
    end
end)

if Config['Claim Airdrops'] then
    workspace.Airdrops.ChildAdded:Connect(function(v)
        task.spawn(function()
            while v.Parent == workspace.Airdrops do
                pcall(function() fireproximityprompt(v:FindFirstChild("ProximityPrompt")) end)
                task.wait(0.1)
            end
        end)
    end)
end

if Config['Claim Candycorn'] then
    workspace.CandyCorn.ChildAdded:Connect(function(v)
        task.spawn(function()
            while v.Parent == workspace.CandyCorn do
                TriggerTouchInteraction(v:FindFirstChild("Holder")) task.wait(0.1)
            end
        end)
    end)
end

if Config['Med Kits'] then
    task.spawn(function()
        while task.wait(0.5) do
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "Health" then
                    TriggerTouchInteraction(obj)
                end
            end
        end
    end)
end

while task.wait() do
    pcall(function()
        if Config['Auto Kill'] then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    pcall(function()
                        local Gun = GetGun()
                        local Settings = require(Gun.Setting)
                        
                        if Gun then
                            Gun.GunServer.HitTest:InvokeServer(v.Character.Head, v.Character.Head.Position, Vector3.zero, "Character", Settings.BaseDamage)
                        end
                    end)
                end
            end
        end
    end)
end
