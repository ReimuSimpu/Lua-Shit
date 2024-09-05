local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local Library = require(ReplicatedStorage:WaitForChild('Library'))
local Active = workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER:WaitForChild("Active")
local Things = workspace:WaitForChild("__THINGS")
local LocalPlayer = game.Players.LocalPlayer
local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local Lighting = game:GetService("Lighting")

local Destroy_WorkSpace = {"Map", "Border", "FlyBorder"}
local Move_Replicated_StorageItems = {"ALWAYS_RENDERING"}
local Destroy_Game_Entities = {"Stats", "Chat", "Debris","CoreGui"}
local Move__THINGS_RepStorage = {"Sounds", "RandomEvents", "Flags", "Hoverboards", "Booths", "ExclusiveEggs", "ExclusiveEggPets", "BalloonGifts", "Sprinklers", "Eggs", "ShinyRelics"}
local function MoveRepStorage(item) if item then item.Parent = ReplicatedStorage end end

pcall(function()
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass('Terrain')

    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    for _, v in pairs(game:GetDescendants()) do
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
    
    for _, v in pairs(Lighting:GetDescendants()) do
        v:Destroy()
    end
    
    workspace.DescendantAdded:Connect(function(child)
        if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') then
            game.RunService.Heartbeat:Wait()
            child:Destroy()
        end
    end)
end)

for _, name in ipairs(Move_Replicated_StorageItems) do
    pcall(function()
        MoveRepStorage(workspace:FindFirstChild(name))
    end)
end

for _, name in ipairs(Move__THINGS_RepStorage) do
    pcall(function()
        local item = Things:FindFirstChild(name)
        MoveRepStorage(item)
    end)
end

pcall(function() workspace.__THINGS.__INSTANCE_CONTAINER.ServerOwned.Parent = game.ReplicatedStorage end)
workspace.Gravity = 0

for i, v in pairs(workspace:GetChildren()) do
    pcall(function() if not (v.Name == "__THINGS" or v.Name == Player.Name) then pcall(function() v:Destroy() end) end end)
end

for i,v in pairs(Destroy_WorkSpace) do
    pcall(function() workspace[v]:Destroy() end)
end

for i, v in workspace.__THINGS:GetChildren() do
    pcall(function() v:Destroy() end)
end

for i, v in LocalPlayer.PlayerScripts:GetChildren() do pcall(function() v:Destroy() end) end
for i, v in LocalPlayer.PlayerGui:GetDescendants() do pcall(function() v:Destroy() end) end

for _, entity in ipairs(Destroy_Game_Entities) do
    pcall(function()
        for _, v in pairs(game[entity]:GetDescendants()) do
            v:Destroy()
        end
    end)
end
