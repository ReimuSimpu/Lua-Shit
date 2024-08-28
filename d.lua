local Network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local Library = require(game.ReplicatedStorage:WaitForChild('Library'))
local Active = workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER:WaitForChild("Active")
local Things = workspace:WaitForChild("__THINGS")
local Player = game.Players.LocalPlayer
local Character = Player.Character
local HRP = Character:FindFirstChild("HumanoidRootPart")

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
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
    
    workspace.DescendantAdded:Connect(function(child)
        if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') then
            game.RunService.Heartbeat:Wait()
            child:Destroy()
        end
    end)
end)

local function moveToReplicatedStorage(name)
    local item = workspace:FindFirstChild(name)
    if item then
        item.Parent = game.ReplicatedStorage
    end
end

-- Low Processing
local itemsToMove = {"animate", "PhantrancDGtp", "ALWAYS_RENDERING"}
for _, name in ipairs(itemsToMove) do
    pcall(moveToReplicatedStorage, name)
end

local thingsToMove = {"Sounds", "RandomEvents", "Flags", "Hoverboards", "Booths", "ExclusiveEggs", "ExclusiveEggPets", "BalloonGifts", "Sprinklers", "Eggs", "ShinyRelics"}
for _, name in ipairs(thingsToMove) do
    pcall(function()
        local item = Things:FindFirstChild(name)
        if item then
            item.Parent = game.ReplicatedStorage
        end
    end)
end

pcall(function()
    workspace.__THINGS.__INSTANCE_CONTAINER.ServerOwned.Parent = game.ReplicatedStorage
end)

local entities = {"Stats", "Chat", "Debris"}
for _, entity in ipairs(entities) do
    pcall(function()
        for _, v in pairs(game[entity]:GetDescendants()) do
            v:Destroy()
        end
    end)
end

workspace.Gravity = 0
local Player = game.Players.LocalPlayer
for i, v in Player.PlayerScripts:GetChildren() do
    pcall(function()
        v:Destroy()
    end)
end
for i, v in workspace:GetChildren() do
    if not (v.Name == "__THINGS" or v.Name == Player.Name)  then
        pcall(function()
            v:Destroy()
        end)
    end
end
for i, v in workspace.__THINGS:GetChildren() do
    if not (v.Name == "__INSTANCE_CONTAINER" or v.Name == "Instances") then
        pcall(function()
            v:Destroy()
        end)
    end
end
