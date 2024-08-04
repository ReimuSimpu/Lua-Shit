local Library = require(game.ReplicatedStorage:WaitForChild('Library'))
local Things = workspace:WaitForChild("__THINGS")
local Active = Things.__INSTANCE_CONTAINER:WaitForChild("Active")
local Player = game.Players.LocalPlayer
local character = Player.Character
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local Network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local HttpService = game:GetService("HttpService")

pcall(function()
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for i, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end
    for i, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
    workspace.DescendantAdded:Connect(function(child)
        task.spawn(function()
            if child:IsA('ForceField') then
                game.RunService.Heartbeat:Wait()
                child:Destroy()
            elseif child:IsA('Sparkles') then
                game.RunService.Heartbeat:Wait()
                child:Destroy()
            elseif child:IsA('Smoke') or child:IsA('Fire') then
                game.RunService.Heartbeat:Wait()
                child:Destroy()
            end
        end)
    end)
end)

for i, v in workspace:GetChildren() do
    pcall(function()
        if v.Name == "animate" then
            v.Parent = game.ReplicatedStorage
        end
    end)
end
for i, v in pairs(Things:GetChildren()) do
    pcall(function()
        if v.Name == "Sounds" then
            v.Parent = game.ReplicatedStorage
        end
    end)
end
pcall(function()
    workspace.__THINGS.__INSTANCE_CONTAINER.ServerOwned.Parent = game.ReplicatedStorage
end)

spawn(function()
    while true do
        task.wait(30)
        for i, v in game.Players:GetPlayers() do
            if v ~= game.Players.LocalPlayer then
                pcall(function()
                    local Character = v.Character
                    Character:Destroy()
                end)
            end
        end
    end
end)
