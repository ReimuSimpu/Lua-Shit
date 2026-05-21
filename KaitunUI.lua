local FarmUI = {}
FarmUI.__index = FarmUI

local SUFFIX = {"", "K", "M", "B", "T"}
local SUFFIX_LEN = #SUFFIX
local UserInputService = game:GetService("UserInputService")
local MB1 = Enum.UserInputType.MouseButton1
local MOUSE_MOVE = Enum.UserInputType.MouseMovement

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
	Logo.Position = UDim2.new(0.015, 0, 0.02, 0)
	Logo.Size = UDim2.new(0.25, 0, 0.25, 0)
	Logo.BackgroundTransparency = 1
	Logo.Image = self.Logo
	Logo.Parent = Background

	local LogoCorner = Instance.new("UICorner")
	LogoCorner.CornerRadius = UDim.new(1, 0)
	LogoCorner.Parent = Logo

	local LogoAspect = Instance.new("UIAspectRatioConstraint")
	LogoAspect.AspectRatio = 1
	LogoAspect.Parent = Logo

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

		local dragStart, startPos, moveConn

		Background.InputBegan:Connect(function(input)
			if input.UserInputType == MB1 then
				dragStart = input.Position
				startPos = Background.Position
				moveConn = UserInputService.InputChanged:Connect(function(moved)
					if moved.UserInputType == MOUSE_MOVE then
						local delta = moved.Position - dragStart
						Background.Position = UDim2.new(
							startPos.X.Scale, startPos.X.Offset + delta.X,
							startPos.Y.Scale, startPos.Y.Offset + delta.Y
						)
					end
				end)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == MB1 and moveConn then
				moveConn:Disconnect()
				moveConn = nil
			end
		end)
	end
end

function FarmUI:_Build(UITable)
	local Sorted = {}
	for Name, Data in pairs(UITable) do
		Sorted[#Sorted + 1] = {Name = Name, Order = Data[1], Text = Data[2], Size = Data[3]}
	end
	table.sort(Sorted, function(A, B) return A.Order < B.Order end)
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
	local index, value = 1, Int
	while value >= 1000 and index < SUFFIX_LEN do
		value = value / 1000
		index = index + 1
	end
	return index == 1 and string.format("%d", value) or string.format("%.2f%s", value, SUFFIX[index])
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
