-- Very shit digsite do not recommend

getgenv().AllowedToTrade = false

local Settings = _G.Settings or {
	MultiAcc = true, -- waits for all accounts to collect chests
	Players = 5, -- how many accounts you want multiacc to wait for
    DelayForMining = 15,
	ShowBlocks = false,
	ShowChests = false,
	CollectOrb = true,
	AutoExec = true,
	Gui = true,
	AutoShutdown = false,
	AllWebhook = "https://discord.com/api/webhooks/1287890695767588919/RpV1sUi6okBzzE8HbLtPwPpu-YhmJlNtDyc8tEeY8TT-V7dW3DJq3rQCgeYMnllTW8Ck",
    SpecificWebhook = "https://discord.com/api/webhooks/1305167074506702929/DEi4d9MNzhUkPgvfb4g4uOkFyZ4IrdOWO1IKOxXJsNZyWzxx_DdUyj22778YY0bual37",
    DisableCodex = true,
    FPSBoost = true,
	MailHuges = false,
	MailUsers = {},
	CollectUser = "AlwayzTrading1",
	KickForNoneFriendly = true,
	FriendlyAccounts = {
		AlwayzTrading1 = true, FluffyTornado42 = true, GalacticNoodle22 = true, TurboWaffleLizard = true, BlurpSnail44 = true, LavaLampRanger = true, BloxCrabNinja = true, QuirkyMuffinDash = true, MoonlitJello23 = true, GravityPanda84 = true, WhimsicalPixelDuck = true, DeadRacoon0 = true, ThunderBunnyFizz = true, NeonKoalaTwist = true, VortexPickleSnipe = true, SizzleStarfish23 = true, AstroSushiWave = true, TurboKoalaBlaze = true, CosmicTacoLuna = true, AtomicTurtleStorm = true, FunkySpaceWalrus = true, ChocoLlamaZap = true, PixelPuffinBlast = true, CitrusSprinkleFury = true, RainbowPlatypus99 = true, TwinkleRhinoZap = true, SparkleDragonToast = true, MelonSharkByte = true, GlitchCactusFunk = true, QuantumLobsterFizz = true, ToastyPhoenixRex = true, TurboOcelotGlow = true, NebulaMonkeyFizz = true, CosmicRhinoDash = true, LavaMuffinRumble = true, PuddlePuffinBlitz = true, WackyTacoSnipe = true, PixelGlitchLynx = true, VortexPuddle83 = true, JellybeanThunderLynx = true, QuantumWombatBlitz = true, TurboFlamingoFizz = true, NebulaTigerZap = true, AstroTurtleSprout = true, SparkleFrogRocket = true, CactusGlitchGazer = true, VortexUnicornZap = true, TwistyKoalaZap = true, SizzleOctopusWave = true, BlazingPandaPunch = true, JellyMangoBlitz = true, QuantumOtterDash = true, GlitchyYetiCrunch = true, PixelWaspFusion = true, ThunderKoalaTwist = true
		
	},
}

if not game:IsLoaded() then
	game.Loaded:Wait()
end

repeat
	task.wait()
until game.PlaceId ~= 0

local AllowedPlaces = { 17503543197, 16498369169, 8737899170 }

if not table.find(AllowedPlaces, game.PlaceId) then
	return
end

if not game.Players.LocalPlayer:GetAttribute("__LOADED") then
	game.Players.LocalPlayer:GetAttributeChangedSignal("__LOADED"):Wait()
end

if _G.Dig then
	_G.Dig()
	return
end

-- Roblox Globals
local task = task
local table = table
local Vector3 = Vector3
local CFrame = CFrame
local os = os

-- Variables
local Player = game.Players.LocalPlayer
local Players = game.Players
local ActiveFolder = workspace.__THINGS.__INSTANCE_CONTAINER.Active
local ReplicatedStorage = cloneref(game.ReplicatedStorage)
local library = ReplicatedStorage:WaitForChild("Library")
local coreClient = library:WaitForChild("Client")
local startTime = tick()
local clientSave = require(library:WaitForChild("Client").Save).Get()
local MasteryCmds = require(game.ReplicatedStorage.Library.Client.MasteryCmds)
local InventoryCmds = require(game.ReplicatedStorage.Library.Client.InventoryCmds)

local InstancingCmds = require(ReplicatedStorage.Library.Client.InstancingCmds)
local Orb = require(ReplicatedStorage.Library.Client.OrbCmds.Orb)

-- Orb Stuff
local OldCollectDistance = Orb.CollectDistance
local OldCombineDelay = Orb.CombineDelay
local OldDefaultPickupDistance = Orb.DefaultPickupDistance
local OldCombineDistance = Orb.CombineDistance

-- UI
local UI_Stats = {
    ["Blocks"] = 0;
    ["Chests"] = 0;
}



function formatNumber(number)
    local suffixes = {"", "k"; "M"; "B"; "T"; "Qd"; "Qn"; "Sx"; "Sp"; "Oc"; "No"; "De"; "UDe"; "DDe"; "TDe"; "QdDe"; "QnDe"; "SxDe"; "SpDe"; "OcDe"; "NoDe"; "Vg"; "UVg"; "DVg"; "TVg"; "QdVg"; "QnVg"; "SxVg"; "SpVg"; "OcVg"; "NoVg"; "Tg"; "UTg"; "DTg"; "TTg"; "QdTg"; "QnTg"; "SxTg"; "SpTg"; "OcTg"; "NoTg"; "QdAg"; "QnAg"; "SxAg"; "SpAg"; "OcAg"; "NoAg"; "e141"; "e144"; "e147"; "e150"; "e153"; "e156"; "e159"; "e162"; "e165"; "e168"; "e171"; "e174"; "e177"; "e180"; "e183"; "e186"; "e189"; "e192"; "e195"; "e198"; "e201"; "e204"; "e207"; "e210"; "e213"; "e216"; "e219"; "e222"; "e225"; "e228"; "e231"; "e234"; "e237"; "e240"; "e243"; "e246"; "e249"; "e252"; "e255"; "e258"; "e261"; "e264"; "e267"; "e270"; "e273"; "e276"; "e279"; "e282"; "e285"; "e288"; "e291"; "e294"; "e297"; "e300"; "e303"}
    local suffixIndex = 1

    if number < 999 then 
        return number
    end
    while number >= 1000 and suffixIndex < #suffixes do
        number = number / 1000
        suffixIndex = suffixIndex + 1
    end
    return string.format("%.2f%s", number, suffixes[suffixIndex])
end

local Network = {}
do
	local NetworkLibrary = require(ReplicatedStorage.Library.Client.Network)

	function Network.FireServer(name, ...)
		return NetworkLibrary.Fire(name, ...)
	end

	function Network.InvokeServer(name, ...)
		return NetworkLibrary.Invoke(name, ...)
	end

	function Network.Fired(name, ...)
		return NetworkLibrary.Fired(name, ...)
	end
end

local Utils = {}
do
	local Cells = {
		Blocks = {},
		Chests = {},
	}

	function Utils.GetCells()
		return Cells
	end

	function Utils.GetBlocks()
		return Utils.GetCells().Blocks
	end

	function Utils.GetBlock(Position)
		local Blocks = Utils.GetBlocks()

		return Blocks[Position]
	end

	function Utils.CreateBlock(Position, Id, OreId, Health)
		local Blocks = Utils.GetBlocks()

		if Utils.GetBlock(Position) == false then
			return
		end

		Blocks[Position] = {
			Id = Id,
			OreId = OreId,
			Health = Health,
		}
	end

	function Utils.DeleteBlock(Position)
		local Blocks = Utils.GetBlocks()

		Blocks[Position] = false
	end

	function Utils.GetChests()
		return Utils.GetCells().Chests
	end

	function CompareVector3(a, b)
		if a.X ~= b.X then
			return a.X < b.X
		elseif a.Y ~= b.Y then
			return a.Y < b.Y
		else
			return a.Z < b.Z
		end
	end

	local BlacklistedChests = {
		["Chest1"] = true,
		["Chest2"] = true
	}
	function Utils.GetChestReady()
		local ChestReady
		for Position, Chest in Utils.GetChests() do
			if not Utils.GetChest(Position) then continue end
			if BlacklistedChests[Chest.Id] then continue end

			if not ChestReady or CompareVector3(ChestReady, Position) then
				ChestReady = Position
			end
		end

		return ChestReady
	end

	function Utils.GetChest(Position)
		local Chests = Utils.GetChests()

		return Chests[Position]
	end

	function Utils.CreateChest(Position, Id)
		local Chests = Utils.GetChests()

		if Utils.GetChest(Position) == false then
			return
		end

		Chests[Position] = {
			Id = Id,
		}
	end

	function Utils.DeleteChest(Position)
		local Chests = Utils.GetChests()

		Chests[Position] = false
	end

	function Utils.ResetState()
		table.clear(Utils.GetBlocks())
		table.clear(Utils.GetChests())
	end

	local VoxelSize = 8
	local DigsitePosition = Vector3.new(-111.2645263671875, 55.212520599365234, -2558.91552734375)
	function Utils.LocalCoordsToGlobalCoords(Position)
		local X = DigsitePosition.X + VoxelSize / 2 + VoxelSize * (Position.X - 1)
		local Y = DigsitePosition.Y - VoxelSize / 2 - VoxelSize * (Position.Y - 1)
		local Z = DigsitePosition.Z + VoxelSize / 2 + VoxelSize * (Position.Z - 1)
		return Vector3.new(X, Y, Z)
	end
end

function SendHuge()
    local HugeUID = nil
    local RandomUser = Settings.MailUsers[math.random(1, #Settings.MailUsers)]

    for Class, classTables in pairs(InventoryCmds.State().container._store._byType) do
        if Class == "Pet" then
            for uid, Item in pairs(classTables._byUID) do

                if Item._data.id == "Huge Fossil Dragon" then
                    HugeUID = uid
                    -- print("Found Huge Fossil Dragon: Class:", Class, "UID:", uid, "Item:", Item._data.id) 
                    break -- Exit loop when found
                end
            end
        end
        if HugeUID then break end -- Stop once the huge pet is found
    end

	if HugeUID then
        local args = {
            [1] = RandomUser,
            [2] = "Another One!",
            [3] = "Pet",
            [4] = HugeUID,
            [5] = 1
        }
        game:GetService("ReplicatedStorage").Network:FindFirstChild("Mailbox: Send"):InvokeServer(unpack(args))
    end
end

task.spawn(function()
	if Settings.KickForNoneFriendly then
		while task.wait(30) do
			for _, player in ipairs(Players:GetChildren()) do
				if player.Name == Player.Name or player.Name == "Sky" then
					continue 
				end
				local isWhitelisted = Settings.FriendlyAccounts[player.Name]
				if not isWhitelisted then
					Player:Kick(player.Name .. " is not whitelisted.")
				end
				task.wait(0.1)
			end
		end
	end
end)

task.spawn(function()
	while not getgenv().AllowedToTrade do
		if game.Players:FindFirstChild(Settings.CollectUser) then
			--print(Settings.CollectUser .. " joined. Digging has been paused.")
			getgenv().AllowedToTrade = true
		end
		task.wait(10)
	end
end)

task.spawn(function()
	while task.wait(10) do
		SendHuge()
	end
end)

local Hooks = {}
local Connections = {}
local Threads = {}

function Mine()
	local LayerTable = {}
    for LayerNum = 1, 255, 3 do
		if Settings.MultiAcc then
			LayerTable[LayerNum] = {
				Vector3.new(2, LayerNum, 2);
				Vector3.new(7, LayerNum, 2);
				Vector3.new(7, LayerNum, 7);
				Vector3.new(2, LayerNum, 7);
				Vector3.new(5, LayerNum, 4);
			}

			LayerTable[LayerNum + 1] = {
				Vector3.new(3, LayerNum + 1, 2);
				Vector3.new(7, LayerNum + 1, 3);
				Vector3.new(6, LayerNum + 1, 7);
				Vector3.new(2, LayerNum + 1, 6);
				Vector3.new(4, LayerNum + 1, 4);
			}

			LayerTable[LayerNum + 2] = {
				Vector3.new(2, LayerNum + 2, 3);
				Vector3.new(6, LayerNum + 2, 2);
				Vector3.new(7, LayerNum + 2, 6);
				Vector3.new(3, LayerNum + 2, 7);
				Vector3.new(5, LayerNum + 2, 5);
			}

			continue
		end

        LayerTable[LayerNum] = {
            Vector3.new(2, LayerNum, 2);
            Vector3.new(5, LayerNum, 4);
            Vector3.new(7, LayerNum, 2);
            Vector3.new(7, LayerNum, 7);
            Vector3.new(2, LayerNum, 7);
        };

        LayerTable[LayerNum + 1] = {
            Vector3.new(2, LayerNum + 1, 6);
            Vector3.new(4, LayerNum + 1, 4);
            Vector3.new(3, LayerNum + 1, 2);
            Vector3.new(7, LayerNum + 1, 3);
            Vector3.new(6, LayerNum + 1, 7);
        };

        LayerTable[LayerNum + 2] = {
            Vector3.new(7, LayerNum + 2, 6);
            Vector3.new(5, LayerNum + 2, 5);
            Vector3.new(3, LayerNum + 2, 7);
            Vector3.new(2, LayerNum + 2, 3);
            Vector3.new(6, LayerNum + 2, 2);
        } -- should be 6 layers for peak performance on 1 acc but eh .2 seconds at max per 3 layers
    end

	local function CheckLayersComplete()
		for Role = 1, 5 do
			for Layer = 1, 255, 1 do
				local Block = LayerTable[Layer][Role]
				if Utils.GetBlock(Block) then
					print(Block)
					return false
				end
			end
		end

		return true
	end

	if Settings.AutoShutdown then
		local Shutdown = not Settings.MultiAcc or (Settings.MultiAcc and CheckLayersComplete())
		if Shutdown then
			Player:Kick("Auto Shutdown")
			game:Shutdown() -- Test
		end
	end

	local OwnRole = 1

	if Settings.MultiAcc then
		local Players = game.Players:GetPlayers()
		while #Players < Settings.Players do
			game.Players.PlayerAdded:Wait()
			Players = game.Players:GetPlayers()
		end
		Players = table.move(Players, 1, Settings.Players, 1, {})

		table.sort(Players, function(p1, p2)
			return p1.UserId < p2.UserId
		end)

		local TempTable = {}
		for Index, OtherPlayer in Players do
			TempTable[Index] = OtherPlayer.Name
		end
		Players = TempTable
		
		OwnRole = ((table.find(Players, Player.Name) - 1) % 5) + 1
	end

	local ChestLayer = Settings.MultiAcc and 15 or 3
	local Layer = 1

	while not getgenv().AllowedToTrade do

		if Settings.MultiAcc then
			local Block = LayerTable[Layer][OwnRole]

            if Utils.GetBlock(Block) then
                while true do
                    if not Utils.GetBlock(Block) then 
                        UI_Stats.Blocks = UI_Stats.Blocks + 1
                        break
                    end

                    pcall(function()
                        Player.Character.PrimaryPart.CFrame = CFrame.new(Utils.LocalCoordsToGlobalCoords(Block))
                    end)

                    Network.FireServer("Instancing_FireCustomFromClient", "Digsite", "DigBlock", Block)

                    task.wait()
                end
            end
		else
			for _, Block in LayerTable[Layer] do
                if Utils.GetBlock(Block) then
                    while true do
                        if not Utils.GetBlock(Block) then 
                            UI_Stats.Blocks = UI_Stats.Blocks + 1
                            break
                        end


                        pcall(function()
                            Player.Character.PrimaryPart.Velocity = Vector3.zero
                            Player.Character.PrimaryPart.CFrame = CFrame.new(Utils.LocalCoordsToGlobalCoords(Block))
                        end)

                        Network.FireServer("Instancing_FireCustomFromClient", "Digsite", "DigBlock", Block)
        
                        task.wait()
                    end
                end
			end
		end
		

		if Layer % ChestLayer == 0 then
			local Chest = Utils.GetChestReady()

            if Chest then
                while true do
                    if not Chest then 
                        UI_Stats.Chests = UI_Stats.Chests + 1
                        break
                    end
                    pcall(function()
                        Player.Character.PrimaryPart.CFrame = CFrame.new(Utils.LocalCoordsToGlobalCoords(Chest))
                    end)

                    Network.FireServer("Instancing_FireCustomFromClient", "Digsite", "DigChest", Chest)

                    task.wait()
                    Chest = Utils.GetChestReady()
                end
            end
		end

		Layer = (Layer % 255) + 1

		if Layer == 1 then
			if Settings.AutoShutdown then
				local Shutdown = not Settings.MultiAcc or (Settings.MultiAcc and CheckLayersComplete())
				if Shutdown then
					-- Player:Kick("Auto Shutdown")
					game:Shutdown()
				end
			end

			pcall(function()
				Player.Character.PrimaryPart.CFrame = CFrame.new(Utils.LocalCoordsToGlobalCoords(Vector3.new(2, 1, 2)))
			end)

			task.wait()
		end
	end
end


function Load()
	Player.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false
    for _, conn in getconnections(game.Players.LocalPlayer.Idled) do -- ANTI AFK
        conn:Disable()
    end

	workspace.Gravity = 0
	local DigsiteClientModule = require(workspace.__THINGS.__INSTANCE_CONTAINER.Active.Digsite.ClientModule)

	if Settings.CollectOrb then -- Orb Stuff
		Orb.CollectDistance = 9e9
		Orb.CombineDelay = 0
		Orb.DefaultPickupDistance = 9e9
		Orb.CombineDistance = 9e9

		local OrbsCreate = Network.Fired("Orbs: Create")
		local OrbsCreateFunc = getconnections(OrbsCreate)[1].Function

		local OrbsCreateOld = hookfunction(OrbsCreateFunc, function(t)
			local collect = {}
			for i, v in t do
				table.insert(collect, v.id)
			end

			game.ReplicatedStorage.Network["Orbs: Collect"]:FireServer(collect)
		end)

		Hooks[OrbsCreateFunc] = OrbsCreateOld
	end

    do
        if Settings["DisableCodex"] then
            task.spawn(function()
                while task.wait(.1) do
                    for i,v in game:GetService("CoreGui"):GetDescendants() do
                        if v.Parent.Name == "Codex" then 
                            v.Enabled = false
                            break
                        end
                    end
                end
            end)
        end

        if Settings.FPSBoost then
            local Graphics = function (v)
                if string.find(tostring(v), "Service") then return end
                pcall(function()
                    if v:IsA("MeshPart") then
                        v.MeshId = ""
                    end
                    if v:IsA("BasePart") or v:IsA("MeshPart") then
                        v.Transparency = 1
                    end
                    if v:IsA("Texture") or v:IsA("Decal") then
                        v.Texture = ""
                    end
                    if v:IsA("ParticleEmitter") then
                        v.Lifetime = NumberRange.new(0)
                        v.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,0)})
                        v.Enabled = false
                    end
                    if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Trail") or v:IsA("Beam") then
                        v.Enabled = false
                    end
                    if v:IsA("Highlight") then
                        v.OutlineTransparency = 1
                        v.FillTransparency = 1
                    end
                end)
            end
            
            game.Workspace.DescendantAdded:Connect(Graphics)
            for _,v in game.Workspace:GetDescendants() do Graphics(v) end
        end

		if Settings.Gui then
			local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			local screenGui = game:GetService("Players").LocalPlayer.PlayerGui.Starter:Clone()
			screenGui.Name = "Starter_tEST"
			screenGui.ResetOnSpawn = false
			screenGui.Frame.ZIndex = 2
			screenGui.Frame.Pets:Destroy()
			screenGui.Frame.Ok:Destroy()
			screenGui.Frame.background:Destroy()
			screenGui.Frame.shadow:Destroy()
			screenGui.Frame.TextLabel.Name = "Title"

			local HugeCount = game:GetService("Players").LocalPlayer.PlayerGui.Mastery.Frame.Container.ItemsFrame.Digging:Clone()
			HugeCount.Position = UDim2.new(0.35, 0, 0.05, 0)
			HugeCount.Size = UDim2.new(0.3, 0, 0.5, 0)
			HugeCount.ZIndex = 2
			HugeCount.Name = "HugeCount"
			HugeCount.Icon.Image = "rbxassetid://14976436145"
			HugeCount.CircularBar:Destroy()
			HugeCount.UIStroke:Destroy()
			HugeCount.UICorner:Destroy()
			HugeCount.Level.Text = "???"
			HugeCount.LevelTitle.Text = ""
			HugeCount.Parent = screenGui.Frame

			local Username = screenGui.Frame.Title:Clone()
			Username.TextScaled = true -- Enable scaling so it adjusts to screen size
			Username.Position = UDim2.new(0.5, 0, 0.45, 0) -- Move the Username higher
			Username.Size = UDim2.new(0.9, 0, 0.2, 0) -- Adjust size for proper scaling
			Username.Text = game.Players.LocalPlayer.Name
			Username.ZIndex = 3
			Username.Name = "Username"
			Username.Parent = screenGui.Frame

			local DigRank = screenGui.Frame.Title:Clone()
			DigRank.TextScaled = true -- Enable scaling so it adjusts to screen size
			DigRank.Position = UDim2.new(0.5, 0, 0.61, 0) -- Positioned below the Username
			DigRank.Size = UDim2.new(0.55, 0, 0.2, 0) -- Match size to Username for consistent scaling
			DigRank.Text = "Dig Rank: ???"
			DigRank.ZIndex = 3
			DigRank.Name = "DigRank"
			DigRank.Parent = screenGui.Frame

			local PlaytimeTextLabel2 = screenGui.Frame.Title:Clone()
			PlaytimeTextLabel2.Position = UDim2.new(0.5, 0, 0.8, 0)
			PlaytimeTextLabel2.Text = os.date("!%X", tick() - startTime)
			PlaytimeTextLabel2.ZIndex = 2
			PlaytimeTextLabel2.Name = "Time"
			PlaytimeTextLabel2.Parent = screenGui.Frame

			local Chest = screenGui.Frame.Title:Clone()
			Chest.Position = UDim2.new(0.2, 0, 0.8, 0)
			Chest.Text = "100"
			Chest.ZIndex = 2
			Chest.Name = "Chest"
			Chest.TextColor3 = Color3.fromRGB(167, 167, 0)
			Chest.Parent = screenGui.Frame

			local Block = screenGui.Frame.Title:Clone()
			Block.Position = UDim2.new(0.8, 0, 0.8, 0)
			Block.Text = "100"
			Block.ZIndex = 2
			Block.Name = "Block"
			Block.TextColor3 = Color3.fromRGB(162, 95, 23)
			Block.Parent = screenGui.Frame

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(2, 0, 2, 0) -- Fullscreen
			frame.Position = UDim2.new(0, 0, 0, -200) -- Obere linke Ecke
			frame.BackgroundColor3 = Color3.new(1, 1, 1) -- Weiß
			frame.BorderSizePixel = 0 -- Kein Rand
			frame.ZIndex = 1
			frame.Name = "WhiteScreen"
			frame.Parent = screenGui

			screenGui.Parent = playerGui
			screenGui.Enabled = true
			screenGui.Frame.Title:Destroy()
		
		
			function getInventoryDragons()
			    local count = 0
			    for i,v in clientSave["Inventory"]["Pet"] do
			        if v.id ~= "Huge Fossil Dragon"then continue end
			        count += 1
			    end
			    return count
			end

			function getRank()
				return MasteryCmds.GetLevel({_id = "Digging"})
			end
		
			function update_UI() --G
			    pcall(function()
			        PlaytimeTextLabel2.Text = os.date("!%X", tick() - startTime)
			        HugeCount.Level.Text = getInventoryDragons()
			        Block.Text = formatNumber(UI_Stats.Blocks)
			        Chest.Text = formatNumber(UI_Stats.Chests)
					DigRank.Text = "Dig Rank: " .. getRank()
			    end)
			end
		
			task.spawn(function()
			    local Wait20Times = 0
			    while task.wait(.5) do
			        Wait20Times += 1
			        update_UI()
		
			        if Wait20Times >= 20 then
			            Wait20Times = 0
			        end
			    end
			end)
		end
    end


	do -- Hooks
		local EmptyFunction = function() end

		local Init = getupvalue(DigsiteClientModule.OnJoin, 4)
		local InitOld = hookfunction(Init, EmptyFunction)

		Hooks[Init] = InitOld

		if not Settings.ShowBlocks then
			local CreateBlock = getupvalue(DigsiteClientModule.Networking.CreateBlock, 1)
			local CreateBlockOld = hookfunction(CreateBlock, EmptyFunction)

			Hooks[CreateBlock] = CreateBlockOld
		end

		if not Settings.ShowChests then
			local CreateChest = getupvalue(DigsiteClientModule.Networking.CreateChest, 1)
			local CreateChestOld = hookfunction(CreateChest, EmptyFunction)

			Hooks[CreateChest] = CreateChestOld
		end

		local ShovelEquipped = getupvalue(DigsiteClientModule.Networking.ShovelEquipped, 1)
		local ShovelEquippedOld = hookfunction(ShovelEquipped, EmptyFunction)

		Hooks[ShovelEquipped] = ShovelEquippedOld
	end

	
	local Data
	repeat
		Data = Network.InvokeServer("Instancing_InvokeCustomFromClient", "Digsite", "GetState")
		task.wait()
	until Data

	for _, Block in Data.Blocks do
		Utils.CreateBlock(Block.coord, Block.id, Block.ore, Block.health)
	end

	for _, Chest in Data.Chests do
		Utils.CreateChest(Chest.coord, Chest.id)
	end

	table.insert(Threads, task.spawn(Mine))
end


local Loaded = false

local OldGravity = workspace.Gravity


function Unload()
	while not Loaded do
		task.wait()
	end

	for _, Connection in Connections do
		Connection:Disconnect()
	end

	for _, Thread in Threads do
		pcall(task.cancel, Thread)
	end

	for Function, Old in Hooks do
		hookfunction(Function, Old)
	end

	if Settings.CollectOrb then -- Orb Stuff
		Orb.CollectDistance = OldCollectDistance
		Orb.CombineDelay = OldCombineDelay
		Orb.DefaultPickupDistance = OldDefaultPickupDistance
		Orb.CombineDistance = OldCombineDistance
	end

	workspace.Gravity = OldGravity

	_G.Dig = nil
end


_G.Dig = Unload

local FireCustomFromServerConnection = Network.Fired("Instancing_FireCustomFromServer")
	:Connect(function(InstanceId, ActionId, ...)
		if InstanceId ~= "Digsite" then
			return
		end

		if ActionId == "CreateBlock" then
			local Id, OreId, Position, Health = ...
			Utils.CreateBlock(Position, Id, OreId, Health)
		elseif ActionId == "DeleteBlock" then
			local Position = ...
			Utils.DeleteBlock(Position)
		elseif ActionId == "CreateChest" then
			local Id, Position = ...
			Utils.CreateChest(Position, Id)
		elseif ActionId == "DeleteChest" then
			local Position = ...
			Utils.DeleteChest(Position)
		elseif ActionId == "ResetState" then
			Utils.ResetState()
		end
	end)

table.insert(Connections, FireCustomFromServerConnection)

local ActiveChildAddedConnection = ActiveFolder.ChildAdded:Connect(function(Child)
    if Child.Name ~= "Digsite" then
        return
    end

    task.wait(Settings.DelayForMining)

    if Settings.AllWebhook ~= "" then
        task.spawn(function()

            if not game:IsLoaded() then 
                game.Loaded:Wait() 
            end

            repeat wait() until game.Players
            repeat wait() until game.Players.LocalPlayer
            repeat wait() until game.Players.LocalPlayer.Character
            repeat wait() until game.Players.LocalPlayer.Character.HumanoidRootPart
            repeat wait() until game.ReplicatedStorage
            repeat wait() until game.ReplicatedStorage.Library

            local Senv = {
                Save = getsenv(game.ReplicatedStorage.Library:FindFirstChild("Save", true)),
            }

            local Upvalues = {
                Save = getupvalue(Senv.Save.Update, 1),
            }

            local Player = game.Players.LocalPlayer

            local Inventory = {
                Pets = {}
            }

            function make_inventory()
                local Current_Inv = Upvalues.Save[Player].Inventory.Pet

                for i,v in Current_Inv do
                    if v._am then
                        Inventory.Pets[i] = v._am
                    elseif Inventory.Pets[i] then
                        Inventory.Pets[i] += 1
                    else
                        Inventory.Pets[i] = 1
                    end
                end
            end
            make_inventory()

            function get_inventory()
                local Current_Inv = Upvalues.Save[Player].Inventory.Pet
                local Sorted_Inv = {}

                for i,v in Current_Inv do
                    if v._am then
                        Sorted_Inv[i] = v._am
                    elseif Sorted_Inv[i] then
                             Sorted_Inv[i] += 1
                    else
                        Sorted_Inv[i] = 1
                    end
                end
                return Sorted_Inv
            end

            function check_inventory()
                local Current_Inv = get_inventory()
                local New_Pets = {}

                for i,v in Current_Inv do
                    if not Inventory.Pets[i] then
                        local current_invetory = Upvalues.Save[Player].Inventory.Pet
                        local Name = (current_invetory[i].sh == true and "Shiny " or "")..(current_invetory[i].pt == 1 and "Golden " or current_invetory[i].pt == 2 and "Rainbow " or "")..Upvalues.Save[Player].Inventory.Pet[i].id
                        New_Pets[Name] = Upvalues.Save[Player].Inventory.Pet[i].id
                    end
                end

                return New_Pets
            end

            function SendWebhookLog(Table, WebhookUrl)
                local Body = game:GetService("HttpService"):JSONEncode(Table)
                local req = request or http.request
                if req ~= nil then
                    local Result = req({
                        Url = WebhookUrl, 
                        Method = "POST",
                        Headers = {
                            ['Content-Type'] = "application/json"
                        },
                        Body = Body;
                    })

                    return Result
                end
            end

            while task.wait(10) do
                for i,v in check_inventory() do
                    if string.find(i, "Huge") then
                        local image_id = nil

                        for _,Pet in game:GetService("ReplicatedStorage").__DIRECTORY.Pets:GetDescendants() do
                            if Pet.Name == v then
                                if string.find(i, "Golden ") then
                                    image_id = string.gsub(require(Pet).goldenThumbnail, "%D", "")
                                else
                                    image_id = string.gsub(require(Pet).thumbnail, "%D", "")
                                end
                            end
                        end

                        local embedMessage = {
                            content = "",
                            embeds = {
                                {
                                    ["title"] = "Obtained a ".. i,
                                    ["color"] = 16771840,
                                    ["thumbnail"] = {
                                        ["url"] = "https://biggamesapi.io/image/"..image_id
                                    }
                                }
                            }
                        }

                        SendWebhookLog(embedMessage, Settings.AllWebhook)
						--if Settings.MailHuges then SendHuge() end

                        if Settings.SpecificWebhook ~= "" then
                            SendWebhookLog(embedMessage, Settings.SpecificWebhook)
                        end

                        make_inventory()
                    end
                end
            end

        end)
    end

    table.insert(Threads, task.spawn(Load))
end)


table.insert(Connections, ActiveChildAddedConnection)

local ActiveChildRemovedConnection = ActiveFolder.ChildRemoved:Connect(function(Child)
	if Child.Name ~= "Digsite" then
		return
	end

	task.spawn(Unload)
end)

table.insert(Connections, ActiveChildRemovedConnection)

task.wait(5)

if not getgenv().AllowedToTrade then
	if ActiveFolder:FindFirstChild("Digsite") then
		
		local DigsiteClientModule = require(ActiveFolder.Digsite.ClientModule)
		-- local InitFunction = getupvalue(DigsiteClientModule.OnJoin, 4)

		Load()

		DigsiteClientModule.Networking.ResetState()
		-- InitFunction()
	else
		if Settings.AutoExec then
			table.insert(Threads, task.spawn(function()
				task.wait(3) -- gonna get removed when remove all is made
				setthreadidentity(2)
				while true do
					if not InstancingCmds.IsInInstance() then
						InstancingCmds.Enter("Digsite")
					end
					task.wait()
				end
				setthreadidentity(8)


			end))
		end
	end
end

Loaded = true
