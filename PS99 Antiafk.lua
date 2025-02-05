repeat task.wait() until game:IsLoaded()
local LocalPlayer = game:GetService("Players").LocalPlayer
repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

local Network = require(game.ReplicatedStorage.Library.Client.Network)

LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false
LocalPlayer.PlayerScripts.Scripts.Core["Server Closing"].Enabled = false

Network.Fire("Idle Tracking: Stop Timer")
for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do 
    conn:Disable() 
end
