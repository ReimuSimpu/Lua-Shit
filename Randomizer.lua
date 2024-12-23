--https://www.roblox.com/games/5307215810/Randomizer-NIGHTMARE-BEFORE-CHRISTMAS
-- Made by LordHippo (.lordhippo)

local LocalPlayer = game.Players.LocalPlayer

local GetGun = function()
    local HeldItem = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if HeldItem and HeldItem:FindFirstChild("Setting") then return HeldItem end
    
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:FindFirstChild("GunLocal") and v:FindFirstChild("Setting") then
            return v
        end
    end
end

local Killing = {}

game.Players.PlayerRemoving:Connect(function(v)
    Killing[v.Name] = nil
end)

while task.wait() do
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and not Killing[v.Name] then
            Killing[v.Name] = true
            task.spawn(function()
                while Killing[v.Name] and task.wait() do
                    pcall(function()
                        local Gun = GetGun()
                        if Gun then
                            local Settings = require(Gun.Setting)
                            Gun.GunServer.HitTest:InvokeServer(v.Character.Head, v.Character.Head.Position, Vector3.zero, "Character", Settings.BaseDamage)
                        end
                    end)
                end
            end)
        end
    end
end
