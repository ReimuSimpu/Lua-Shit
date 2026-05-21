local FarmUI = {}
FarmUI.__index = FarmUI

local SUFFIX = {"", "K", "M", "B", "T"}
local UserInputService = game:GetService("UserInputService")

function FarmUI.new(Config)
	local Self = setmetatable({}, FarmUI)
	
	Config = Config or {}
	Self.Player = Config.Player or game.Players.LocalPlayer
	Self.GuiName = Config.Name or "PiraScreenGui"
	Self.Logo = Config.Logo or "rbxassetid://119275169229649"
	Self.Elements = {}
	Self.Parent = Config.Parent or Self.Player:WaitForChild("PlayerGui")
	
	Self:_CreateGui(Config.Small)
	
	if Config.UI then
		Self:_Build(Config.UI)
	end
	
	return Self
end

function FarmUI:_CreateGui(Small)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = self.GuiName
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = self.Parent
	self.ScreenGui = ScreenGui

	local Background = Instance.new("Frame")
	Background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Background.BorderColor3 = Color3.fromRGB(255, 0, 255)
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.BorderMode = Enum.BorderMode.Inset
	Background.Parent = ScreenGui
	self.Background = Background

	local Logo = Instance.new("ImageLabel")
	Logo.Position = UDim2.new(0.001, 0, 0.003, 0)
	Logo.BackgroundTransparency = 1
	Logo.Image = self.Logo
	Logo.Size = UDim2.new(0.168, 0, 0.212, 0)
	Logo.Parent = Background

	local AspectRatio = Instance.new("UIAspectRatioConstraint")
	AspectRatio.AspectRatio = 1
	AspectRatio.Parent = Logo

	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 1, 0)
	Container.BackgroundTransparency = 1
	Container.Parent = Background
	self.Container = Container

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0.005, 0)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.VerticalAlignment = Enum.VerticalAlignment.Center
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Container

	if Small then
		local UIAspectRatio = Instance.new("UIAspectRatioConstraint")
		UIAspectRatio.AspectRatio = 1.852
		UIAspectRatio.Parent = Background

		Background.Size = UDim2.new(0.175, 0, 0.175, 0)
		Background.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background.AnchorPoint = Vector2.new(0.5, 0.5)

		local dragging, dragInput, dragStart, startPos, changed
		
		local function update(input)
			local delta = input.Position - dragStart
			Background.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
		
		local mouseButton1 = Enum.UserInputType.MouseButton1
		local mouseMovement = Enum.UserInputType.MouseMovement
		local inputStateEnd = Enum.UserInputState.End
		
		Background.InputBegan:Connect(function(input)
			if input.UserInputType == mouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = Background.Position
				
				if changed then changed:Disconnect() end
				changed = input.Changed:Connect(function()
					if input.UserInputState == inputStateEnd then
						dragging = false
					end
				end)
			end
		end)

		Background.InputChanged:Connect(function(input)
			if input.UserInputType == mouseMovement then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end
end

function FarmUI:_Build(UITable)
	local Sorted = {}
	for Name, Data in pairs(UITable) do
		Sorted[#Sorted + 1] = {
			Name = Name,
			Order = Data[1],
			Text = Data[2],
			Size = Data[3]
		}
	end

	table.sort(Sorted, function(A, B)
		return A.Order < B.Order
	end)

	for Index, Item in ipairs(Sorted) do
		self:_CreateLabel(Item.Name, Item.Order, Item.Text, Item.Size)
		if Index < #Sorted then
			self:_CreateSpacer(Item.Order + 1)
		end
	end
end

function FarmUI:_CreateLabel(Name, Order, Text, Size)
	local Label = Instance.new("TextLabel")
	Label.Name = Name
	Label.LayoutOrder = Order
	Label.Size = Size and UDim2.new(unpack(Size)) or UDim2.new(0.6, 0, 0.08, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.FredokaOne
	Label.Text = Text or ""
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextScaled = true
	Label.Parent = self.Container

	self.Elements[Name] = Label
end

function FarmUI:_CreateSpacer(Order)
	local Spacer = Instance.new("Frame")
	Spacer.LayoutOrder = Order
	Spacer.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
	Spacer.Size = UDim2.new(0.391, 0, 0, 1)
	Spacer.Parent = self.Container
end

function FarmUI:SetText(Name, Text)
	local Element = self.Elements[Name]
	if Element and Element.Text ~= Text then
		Element.Text = Text
	end
end

function FarmUI:Format(Int)
	local index = 1
	local value = Int
	
	while value >= 1000 and index < #SUFFIX do
		value = value / 1000
		index = index + 1
	end
	
	if index == 1 then
		return string.format("%d", value)
	end
	
	return string.format("%.2f%s", value, SUFFIX[index])
end

function FarmUI:TimeToString(t)
	t = math.floor(t or 0)
	local s = t % 60
	t = (t - s) / 60
	local m = t % 60
	local h = (t - m) / 60
	return string.format("%02d:%02d:%02d", h, m, s)
end

function FarmUI:Destroy()
	if self.ScreenGui then
		self.ScreenGui:Destroy()
	end
end

return FarmUI
