getgenv().Config = {
    ['Farm Account'] = "Lucaslucky1511"
}

repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService("Players").LocalPlayer
local ClientToServer = game.ReplicatedStorage.Remotes.ClientToServer
local VirtualUser = cloneref(game:GetService("VirtualUser"))

for _, v in getconnections(game.Players.LocalPlayer.Idled) do
    v:Disable()
end

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

if LocalPlayer:FindFirstChild("PlayerScripts") then
    LocalPlayer.PlayerScripts.Fatigue.Enabled = false
end

local GetAbilities = function()
    local Abilities = {}
    for _, v in pairs(LocalPlayer.PlayerGui.HUD.Interface.Skillbar:GetChildren()) do
        if v.Name ~= "UIListLayout" then
            if v.ImageLabel.ImageColor3 ~= Color3.fromRGB(255, 57, 57) then
                Abilities[v.Name] = true
            else
                Abilities[v.Name] = false
            end
        end
    end
    return Abilities
end

task.spawn(function()
    while game:GetService("RunService").Heartbeat:Wait() do
        pcall(function()
            if Config['Farm Account'] == LocalPlayer.Name then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-500, 145, -295)
            else
                LocalPlayer.Character.Humanoid.PlatformStand = true
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-500, 145, -300)
            end 
        end)
    end
end)

if Config['Farm Account'] == LocalPlayer.Name then
    task.spawn(function()
        while task.wait(0.1) do
            ClientToServer:FireServer({["Type"] = "BasicAttack", ["MoveType"] = "None"})
        end
    end)

    while task.wait() do
        pcall(function()
            local Abilities = GetAbilities()
            for MoveName, isValid in pairs(Abilities) do
                if isValid then
                    ClientToServer:FireServer({
                        ["Type"] = "UseSkill",
                        ["SkillName"] = MoveName,
                        ["HRPCFrame"] = LocalPlayer.Character.HumanoidRootPart.CFrame
                    })
                    task.wait(0.2)
                end
            end
            if LocalPlayer:GetAttribute("Streak") >= 25 then
                while task.wait(1) do
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end
            elseif LocalPlayer:GetAttribute("AwakeningValue") == 100 then
                ClientToServer:FireServer({
                    ["Type"] = "Awakening",
                })
            end
        end)
    end
end
