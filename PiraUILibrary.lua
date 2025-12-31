local Module = {}

local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
ScreenGui.Name = "PiraScreenGui"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

local Background = Instance.new("Frame", ScreenGui)
Background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Background.BorderColor3 = Color3.fromRGB(255, 0, 255)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BorderMode = Enum.BorderMode.Inset

local Logo = Instance.new("ImageLabel", Background)
Logo.Position = UDim2.new(0.001, 0, 0.003, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://83339153494444"
Logo.Size = UDim2.new(0.168, 0, 0.212, 0)

local AspectRatio = Instance.new("UIAspectRatioConstraint", Logo)
AspectRatio.AspectRatio = 1

local Frame = Instance.new("Frame", Background)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundTransparency = 1

local ListLayout = Instance.new("UIListLayout", Frame)
ListLayout.Padding = UDim.new(0, 5)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

Module.CreateText = function(Number, Text, Size)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Frame
    TextLabel.Name = tostring(Number)
    TextLabel.LayoutOrder = Number

    TextLabel.Size = UDim2.new(unpack(Size))
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.FredokaOne
    TextLabel.Text = Text
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = true

    return TextLabel
end

Module.CreateSpacer = function(Number)
    local Spacer = Instance.new("Frame")
    Spacer.Parent = Frame
    Spacer.Name = tostring(Number)
    Spacer.LayoutOrder = Number

    Spacer.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    Spacer.Size = UDim2.new(0.391, 0, 0, 1)

    return Spacer
end

Module.Format = function(int)
    local index, Suffix = 1, {"", "K", "M", "B", "T"}
    while int >= 1000 and index < #Suffix do
        int = int / 1000
        index = index + 1
    end
    return string.format(index == 1 and "%d" or "%.2f%s", int, Suffix[index])
end

return Module
