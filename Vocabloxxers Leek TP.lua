local LocalPlayer = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local GetNearestPlayer = function()
    local ClosestV, ClosestDistance = nil, math.huge
    local LocalPlayerHRP = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart
    if not LocalPlayerHRP then return nil end

    for _, V in pairs(game.Players:GetPlayers()) do
        if V ~= LocalPlayer and V.Character and V.Character.HumanoidRootPart then
            local Distance = (V.Character.HumanoidRootPart.Position - LocalPlayerHRP.Position).Magnitude
            if Distance < ClosestDistance then
                ClosestV, ClosestDistance = V, Distance
            end
        end
    end
    return ClosestV
end

local LeekKill = function()
    pcall(function()
        local Closest = GetNearestPlayer()
        local LocalPlayerHRP = LocalPlayer.Character.HumanoidRootPart
        local OldCframe = LocalPlayerHRP.CFrame
        
        LocalPlayerHRP.CFrame = Closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)

        game.ReplicatedStorage.Remotes.ClientToServer:FireServer({
            ["Type"] = "UseSkill",
            ["SkillName"] = "Leek Impale",
            ["HRPCFrame"] = Closest.Character.HumanoidRootPart.CFrame,
        })
        
        task.wait(0.7)

        LocalPlayerHRP.Anchored, LocalPlayerHRP.CFrame = true, CFrame.new(-500, 145, -300)

        task.wait(0.5)
        if (LocalPlayerHRP.Position - Closest.Character.HumanoidRootPart.Position).Magnitude > 10 then
            LocalPlayerHRP.Anchored, LocalPlayerHRP.CFrame = false, OldCframe
        end

        task.wait(5)
        LocalPlayerHRP.Anchored, LocalPlayerHRP.CFrame = false, OldCframe
    end)
end


UserInputService.InputBegan:Connect(function(input, a)
    if not a then 
        if input.KeyCode == Enum.KeyCode.L then
            LeekKill()
        end
    end
end)
