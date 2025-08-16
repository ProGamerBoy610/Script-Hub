-- MY HUB


-- Modern Hub GUI for Roblox Executor (Updated with Fixed Dropdown System)
-- Compatible with Fryzer Circle Toggle

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remove existing GUI if it exists
if PlayerGui:FindFirstChild("ModernHubGUI") then
    PlayerGui:FindFirstChild("ModernHubGUI"):Destroy()
end

-- Configuration
local Config = {
    Colors = {
        Primary = Color3.fromRGB(15, 15, 20),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(104, 117, 255),
        Success = Color3.fromRGB(67, 181, 129),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 190),
        Border = Color3.fromRGB(45, 45, 55),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabActive = Color3.fromRGB(70, 85, 220),
        Warning = Color3.fromRGB(255, 140, 66),
        Error = Color3.fromRGB(237, 66, 69),
        StrokeGreen = Color3.fromRGB(0, 255, 0)
    },
    Animations = {
        Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad),
        Normal = TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    }
}

-- Create Library
local Library = {}
Library.Tabs = {}
Library.CurrentTab = nil

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernHubGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.Enabled = true

-- Create Main Frame (Much Smaller)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Config.Colors.Primary
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 450, 0, 300) -- Much smaller size
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Active = true
MainFrame.Draggable = true

-- Add corner rounding (REMOVED UICorner for cleaner look)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Config.Colors.StrokeGreen
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Header Frame
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "Header"
HeaderFrame.Parent = MainFrame
HeaderFrame.BackgroundColor3 = Config.Colors.Secondary
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Size = UDim2.new(1, 0, 0, 40) -- Smaller header
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 0) -- Removed corner rounding
HeaderCorner.Parent = HeaderFrame

-- Fix header corners (only top corners rounded)
local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = HeaderFrame
HeaderFix.BackgroundColor3 = Config.Colors.Secondary
HeaderFix.BorderSizePixel = 0
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = HeaderFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -80, 0, 20)
TitleLabel.Position = UDim2.new(0, 10, 0, 2)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "MODERN HUB"
TitleLabel.TextColor3 = Config.Colors.Text
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle Label
local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "Subtitle"
SubtitleLabel.Parent = HeaderFrame
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Size = UDim2.new(1, -80, 0, 12)
SubtitleLabel.Position = UDim2.new(0, 10, 0, 22)
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.Text = "Advanced Script Hub"
SubtitleLabel.TextColor3 = Config.Colors.TextSecondary
SubtitleLabel.TextSize = 10
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Control Buttons Container
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "Controls"
ControlsFrame.Parent = HeaderFrame
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Size = UDim2.new(0, 60, 1, 0)
ControlsFrame.Position = UDim2.new(1, -65, 0, 0)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = ControlsFrame
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(0, 0, 0.5, -12.5)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Config.Colors.Text
MinimizeButton.TextSize = 16

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = ControlsFrame
CloseButton.BackgroundTransparency = 1
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(0, 30, 0.5, -12.5)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Config.Colors.Text
CloseButton.TextSize = 16

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)

-- Left Sidebar for Tabs (Smaller)
local SidebarFrame = Instance.new("Frame")
SidebarFrame.Name = "Sidebar"
SidebarFrame.Parent = ContentFrame
SidebarFrame.BackgroundColor3 = Config.Colors.Secondary
SidebarFrame.BorderSizePixel = 0
SidebarFrame.Size = UDim2.new(0, 120, 1, 0) -- Smaller sidebar
SidebarFrame.Position = UDim2.new(0, 0, 0, 0)

-- Add green stroke to sidebar
local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Color = Config.Colors.StrokeGreen
SidebarStroke.Thickness = 1
SidebarStroke.Parent = SidebarFrame

-- Sidebar ScrollingFrame
local TabScrollFrame = Instance.new("ScrollingFrame")
TabScrollFrame.Name = "TabScroll"
TabScrollFrame.Parent = SidebarFrame
TabScrollFrame.BackgroundTransparency = 1
TabScrollFrame.Size = UDim2.new(1, -8, 1, -8)
TabScrollFrame.Position = UDim2.new(0, 4, 0, 4)
TabScrollFrame.ScrollBarThickness = 3
TabScrollFrame.ScrollBarImageColor3 = Config.Colors.StrokeGreen
TabScrollFrame.BorderSizePixel = 0
TabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Tab Layout
local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabScrollFrame
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 3)

-- Right Content Area
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = ContentFrame
ContentContainer.BackgroundColor3 = Config.Colors.Primary
ContentContainer.BorderSizePixel = 0
ContentContainer.Size = UDim2.new(1, -120, 1, 0)
ContentContainer.Position = UDim2.new(0, 120, 0, 0)

-- Add green stroke to content area
local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Config.Colors.StrokeGreen
ContentStroke.Thickness = 1
ContentStroke.Parent = ContentContainer

-- Content ScrollingFrame
local ContentScrollFrame = Instance.new("ScrollingFrame")
ContentScrollFrame.Name = "ContentScroll"
ContentScrollFrame.Parent = ContentContainer
ContentScrollFrame.BackgroundTransparency = 1
ContentScrollFrame.Size = UDim2.new(1, -16, 1, -16)
ContentScrollFrame.Position = UDim2.new(0, 8, 0, 8)
ContentScrollFrame.ScrollBarThickness = 3
ContentScrollFrame.ScrollBarImageColor3 = Config.Colors.StrokeGreen
ContentScrollFrame.BorderSizePixel = 0
ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Content Layout
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentScrollFrame
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)

-- Functions
function Library:CreateTab(name, icon)
    local Tab = {}
    Tab.Name = name
    Tab.Components = {}
    
    -- Create Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabScrollFrame
    TabButton.BackgroundColor3 = Config.Colors.Primary
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 30) -- Smaller tab buttons
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = (icon and icon .. " " or "") .. name
    TabButton.TextColor3 = Config.Colors.TextSecondary
    TabButton.TextSize = 11
    TabButton.TextXAlignment = Enum.TextXAlignment.Center
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 0) -- No corners
    TabCorner.Parent = TabButton
    
    -- Create Tab Content Frame
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentScrollFrame
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.Visible = false
    TabContent.LayoutOrder = #Library.Tabs + 1
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.Parent = TabContent
    TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabContentLayout.Padding = UDim.new(0, 5)
    
    -- Update tab content size when items are added
    TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    -- Tab Selection Logic
    TabButton.MouseButton1Click:Connect(function()
        Library:SelectTab(Tab)
    end)
    
    -- Hover Effects
    TabButton.MouseEnter:Connect(function()
        if Library.CurrentTab ~= Tab then
            TweenService:Create(TabButton, Config.Animations.Fast, {
                BackgroundColor3 = Config.Colors.Border,
                TextColor3 = Config.Colors.Text
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if Library.CurrentTab ~= Tab then
            TweenService:Create(TabButton, Config.Animations.Fast, {
                BackgroundColor3 = Config.Colors.Primary,
                TextColor3 = Config.Colors.TextSecondary
            }):Play()
        end
    end)
    
    Tab.Button = TabButton
    Tab.Content = TabContent
    Tab.Layout = TabContentLayout
    
    table.insert(Library.Tabs, Tab)
    
    -- Auto-select first tab
    if #Library.Tabs == 1 then
        Library:SelectTab(Tab)
    end
    
    -- Update canvas size
    TabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    return Tab
end

function Library:SelectTab(tab)
    -- Deselect current tab
    if Library.CurrentTab then
        TweenService:Create(Library.CurrentTab.Button, Config.Animations.Normal, {
            BackgroundColor3 = Config.Colors.Primary,
            TextColor3 = Config.Colors.TextSecondary
        }):Play()
        Library.CurrentTab.Content.Visible = false
    end
    
    -- Select new tab
    Library.CurrentTab = tab
    TweenService:Create(tab.Button, Config.Animations.Normal, {
        BackgroundColor3 = Config.Colors.TabActive,
        TextColor3 = Config.Colors.Text
    }):Play()
    tab.Content.Visible = true
    
    -- Update content canvas size
    ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

-- Component Creation Functions
function Library:CreateButton(tab, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Parent = tab.Content
    Button.BackgroundColor3 = Config.Colors.Secondary
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 28) -- Smaller buttons
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Config.Colors.Text
    Button.TextSize = 11
    Button.LayoutOrder = #tab.Components + 1
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 0) -- No corners
    ButtonCorner.Parent = Button
    
    -- Add green stroke
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Config.Colors.StrokeGreen
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button
    
    -- Status indicator
    local StatusBox = Instance.new("Frame")
    StatusBox.Name = "StatusBox"
    StatusBox.Parent = Button
    StatusBox.BackgroundColor3 = Config.Colors.Border
    StatusBox.BorderSizePixel = 0
    StatusBox.Size = UDim2.new(0, 16, 0, 16)
    StatusBox.Position = UDim2.new(1, -20, 0.5, -8)
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 0) -- No corners
    StatusCorner.Parent = StatusBox
    
    -- Button functionality
    Button.MouseButton1Click:Connect(function()
        -- Green flash effect
        TweenService:Create(StatusBox, Config.Animations.Fast, {
            BackgroundColor3 = Config.Colors.Success
        }):Play()
        
        -- Call callback if provided
        if callback then
            callback()
        end
        
        -- Return to normal after 1 second
        spawn(function()
            wait(1)
            TweenService:Create(StatusBox, Config.Animations.Normal, {
                BackgroundColor3 = Config.Colors.Border
            }):Play()
        end)
    end)
    
    -- Hover effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, Config.Animations.Fast, {
            BackgroundColor3 = Config.Colors.Border
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, Config.Animations.Fast, {
            BackgroundColor3 = Config.Colors.Secondary
        }):Play()
    end)
    
    table.insert(tab.Components, Button)
    
    -- Update tab content size
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    return Button
end

function Library:CreateToggle(tab, text, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = text
    Toggle.Parent = tab.Content
    Toggle.BackgroundColor3 = Config.Colors.Secondary
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(1, 0, 0, 28) -- Smaller toggles
    Toggle.LayoutOrder = #tab.Components + 1
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 0) -- No corners
    ToggleCorner.Parent = Toggle
    
    -- Add green stroke
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Config.Colors.StrokeGreen
    ToggleStroke.Thickness = 1
    ToggleStroke.Parent = Toggle
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = Toggle
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(1, -45, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 8, 0, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Config.Colors.Text
    ToggleLabel.TextSize = 11
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = Toggle
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.Text = ""
    
    local StatusBox = Instance.new("Frame")
    StatusBox.Name = "StatusBox"
    StatusBox.Parent = Toggle
    StatusBox.BackgroundColor3 = default and Config.Colors.Success or Config.Colors.Border
    StatusBox.BorderSizePixel = 0
    StatusBox.Size = UDim2.new(0, 16, 0, 16)
    StatusBox.Position = UDim2.new(1, -20, 0.5, -8)
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 0) -- No corners  
    StatusCorner.Parent = StatusBox
    
    local isToggled = default or false
    
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        TweenService:Create(StatusBox, Config.Animations.Normal, {
            BackgroundColor3 = isToggled and Config.Colors.Success or Config.Colors.Border
        }):Play()
        
        if callback then
            callback(isToggled)
        end
    end)
    
    -- Hover effects
    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(Toggle, Config.Animations.Fast, {
            BackgroundColor3 = Config.Colors.Border
        }):Play()
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(Toggle, Config.Animations.Fast, {
            BackgroundColor3 = Config.Colors.Secondary
        }):Play()
    end)
    
    table.insert(tab.Components, Toggle)
    
    -- Update tab content size
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    return {Toggle = Toggle, SetValue = function(value) isToggled = value StatusBox.BackgroundColor3 = value and Config.Colors.Success or Config.Colors.Border end}
end

function Library:CreateLabel(tab, text, color)
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = text
    LabelFrame.Parent = tab.Content
    LabelFrame.BackgroundColor3 = Config.Colors.Warning
    LabelFrame.BorderSizePixel = 0
    LabelFrame.Size = UDim2.new(1, 0, 0, 25) -- Smaller labels
    LabelFrame.LayoutOrder = #tab.Components + 1
    
    local LabelCorner = Instance.new("UICorner")
    LabelCorner.CornerRadius = UDim.new(0, 0) -- No corners
    LabelCorner.Parent = LabelFrame
    
    -- Add green stroke
    local LabelStroke = Instance.new("UIStroke")
    LabelStroke.Color = Config.Colors.StrokeGreen
    LabelStroke.Thickness = 1
    LabelStroke.Parent = LabelFrame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = LabelFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -16, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextColor3 = color or Config.Colors.Primary
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Center
    
    table.insert(tab.Components, LabelFrame)
    
    -- Update tab content size
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    return {Label = LabelFrame, SetText = function(newText) Label.Text = newText end}
end

-- NEW FUNCTION: Create Text Label (Like button but only shows text)
function Library:CreateTextLabel(tab, text, color)
    local TextLabelFrame = Instance.new("Frame")
    TextLabelFrame.Name = text
    TextLabelFrame.Parent = tab.Content
    TextLabelFrame.BackgroundColor3 = Config.Colors.Secondary
    TextLabelFrame.BorderSizePixel = 0
    TextLabelFrame.Size = UDim2.new(1, 0, 0, 28) -- Same size as buttons
    TextLabelFrame.LayoutOrder = #tab.Components + 1
    
    local TextLabelCorner = Instance.new("UICorner")
    TextLabelCorner.CornerRadius = UDim.new(0, 0) -- No corners
    TextLabelCorner.Parent = TextLabelFrame
    
    -- Add green stroke
    local TextLabelStroke = Instance.new("UIStroke")
    TextLabelStroke.Color = Config.Colors.StrokeGreen
    TextLabelStroke.Thickness = 1
    TextLabelStroke.Parent = TextLabelFrame
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = TextLabelFrame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, -16, 1, 0)
    TextLabel.Position = UDim2.new(0, 8, 0, 0)
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.Text = text
    TextLabel.TextColor3 = color or Config.Colors.Text
    TextLabel.TextSize = 11
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    table.insert(tab.Components, TextLabelFrame)
    
    -- Update tab content size
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    return {Frame = TextLabelFrame, SetText = function(newText) TextLabel.Text = newText end}
end

-- NEW FUNCTION: Create Slider
function Library:CreateSlider(tab, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = text
    SliderFrame.Parent = tab.Content
    SliderFrame.BackgroundColor3 = Config.Colors.Secondary
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 45)
    SliderFrame.LayoutOrder = #tab.Components + 1
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 0)
    SliderCorner.Parent = SliderFrame
    
    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.Color = Config.Colors.StrokeGreen
    SliderStroke.Thickness = 1
    SliderStroke.Parent = SliderFrame
    
    -- Label
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, -50, 0, 20)
    SliderLabel.Position = UDim2.new(0, 8, 0, 2)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Config.Colors.Text
    SliderLabel.TextSize = 11
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Value Label
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Position = UDim2.new(1, -48, 0, 2)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default or min)
    ValueLabel.TextColor3 = Config.Colors.Accent
    ValueLabel.TextSize = 10
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Slider Track
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Parent = SliderFrame
    SliderTrack.BackgroundColor3 = Config.Colors.Border
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Size = UDim2.new(1, -16, 0, 4)
    SliderTrack.Position = UDim2.new(0, 8, 1, -12)
    
    -- Slider Fill
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderTrack
    SliderFill.BackgroundColor3 = Config.Colors.StrokeGreen
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default or min) / max, 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    
    -- Slider Button
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderFrame
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    
    local currentValue = default or min
    local dragging = false
    
    local function UpdateSlider(input)
        local relativeX = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * relativeX)
        
        ValueLabel.Text = tostring(currentValue)
        TweenService:Create(SliderFill, Config.Animations.Fast, {
            Size = UDim2.new(relativeX, 0, 1, 0)
        }):Play()
        
        if callback then
            callback(currentValue)
        end
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    table.insert(tab.Components, SliderFrame)
    
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    return {Slider = SliderFrame, SetValue = function(value) currentValue = value ValueLabel.Text = tostring(value) SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0) end}
end

-- FIXED DROPDOWN FUNCTION - Complete rewrite with proper z-index handling
function Library:CreateDropdown(tab, text, options, default, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = text
    DropdownFrame.Parent = tab.Content
    DropdownFrame.BackgroundColor3 = Config.Colors.Secondary
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, 0, 0, 28)
    DropdownFrame.LayoutOrder = #tab.Components + 1
    DropdownFrame.ZIndex = 1  -- Base z-index
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 0)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.Color = Config.Colors.StrokeGreen
    DropdownStroke.Thickness = 1
    DropdownStroke.Parent = DropdownFrame
    
    -- Main Button
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Size = UDim2.new(1, -25, 1, 0)
    DropdownButton.Position = UDim2.new(0, 8, 0, 0)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = text .. ": " .. (default or options[1] or "None")
    DropdownButton.TextColor3 = Config.Colors.Text
    DropdownButton.TextSize = 11
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownButton.ZIndex = 2
    
    -- Arrow
    local Arrow = Instance.new("TextLabel")
    Arrow.Parent = DropdownFrame
    Arrow.BackgroundTransparency = 1
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -20, 0, 0)
    Arrow.Font = Enum.Font.Gotham
    Arrow.Text = "▼"
    Arrow.TextColor3 = Config.Colors.TextSecondary
    Arrow.TextSize = 8
    Arrow.TextXAlignment = Enum.TextXAlignment.Center
    Arrow.ZIndex = 2
    
    -- Create Options Frame OUTSIDE of the dropdown frame hierarchy
    -- This prevents clipping and z-index issues
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = text .. "_Options"
    OptionsFrame.Parent = ScreenGui  -- Parent to ScreenGui instead of DropdownFrame
    OptionsFrame.BackgroundColor3 = Config.Colors.Primary
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, math.min(#options * 25, 150)) -- Max height of 150
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 100  -- Very high z-index to appear above everything
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 0)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsStroke = Instance.new("UIStroke")
    OptionsStroke.Color = Config.Colors.StrokeGreen
    OptionsStroke.Thickness = 1
    OptionsStroke.Parent = OptionsFrame
    
    -- Add scrolling if too many options
    local OptionsScrollFrame = Instance.new("ScrollingFrame")
    OptionsScrollFrame.Parent = OptionsFrame
    OptionsScrollFrame.BackgroundTransparency = 1
    OptionsScrollFrame.Size = UDim2.new(1, -4, 1, -4)
    OptionsScrollFrame.Position = UDim2.new(0, 2, 0, 2)
    OptionsScrollFrame.ScrollBarThickness = 3
    OptionsScrollFrame.ScrollBarImageColor3 = Config.Colors.StrokeGreen
    OptionsScrollFrame.BorderSizePixel = 0
    OptionsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
    OptionsScrollFrame.ZIndex = 101
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Parent = OptionsScrollFrame
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 0)
    
    local currentValue = default or options[1] or "None"
    local isOpen = false
    
    -- Function to update options frame position
    local function UpdateOptionsPosition()
        local dropdownPos = DropdownFrame.AbsolutePosition
        local dropdownSize = DropdownFrame.AbsoluteSize
        
        -- Position below the dropdown
        local newX = dropdownPos.X
        local newY = dropdownPos.Y + dropdownSize.Y + 2
        
        -- Check if it would go off screen bottom
        local screenHeight = ScreenGui.AbsoluteSize.Y
        local optionsHeight = OptionsFrame.AbsoluteSize.Y
        
        if newY + optionsHeight > screenHeight then
            -- Position above the dropdown instead
            newY = dropdownPos.Y - optionsHeight - 2
        end
        
        -- Check if it would go off screen right
        local screenWidth = ScreenGui.AbsoluteSize.X
        local optionsWidth = OptionsFrame.AbsoluteSize.X
        
        if newX + optionsWidth > screenWidth then
            newX = screenWidth - optionsWidth - 10
        end
        
        OptionsFrame.Position = UDim2.new(0, newX, 0, newY)
        OptionsFrame.Size = UDim2.new(0, dropdownSize.X, 0, math.min(#options * 25, 150))
    end
    
    -- Create option buttons
    for i, option in pairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = OptionsScrollFrame
        OptionButton.BackgroundColor3 = Config.Colors.Secondary
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, 0, 0, 25)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Config.Colors.Text
        OptionButton.TextSize = 10
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.LayoutOrder = i
        OptionButton.ZIndex = 102
        
        -- Add padding to text
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.Parent = OptionButton
        OptionPadding.PaddingLeft = UDim.new(0, 8)
        OptionPadding.PaddingRight = UDim.new(0, 8)
        
        OptionButton.MouseButton1Click:Connect(function()
            currentValue = option
            DropdownButton.Text = text .. ": " .. option
            OptionsFrame.Visible = false
            isOpen = false
            Arrow.Text = "▼"
            
            -- Animate arrow rotation
            TweenService:Create(Arrow, Config.Animations.Fast, {
                Rotation = 0
            }):Play()
            
            if callback then
                callback(option)
            end
        end)
        
        -- Hover effect
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, Config.Animations.Fast, {
                BackgroundColor3 = Config.Colors.Border
            }):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, Config.Animations.Fast, {
                BackgroundColor3 = Config.Colors.Secondary
            }):Play()
        end)
    end
    
    -- Main dropdown click handler
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        OptionsFrame.Visible = isOpen
        
        if isOpen then
            UpdateOptionsPosition()
            Arrow.Text = "▲"
            -- Animate arrow rotation
            TweenService:Create(Arrow, Config.Animations.Fast, {
                Rotation = 180
            }):Play()
            
            -- Animate options frame appearance
            OptionsFrame.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, 0)
            TweenService:Create(OptionsFrame, Config.Animations.Normal, {
                Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, math.min(#options * 25, 150))
            }):Play()
        else
            Arrow.Text = "▼"
            -- Animate arrow rotation
            TweenService:Create(Arrow, Config.Animations.Fast, {
                Rotation = 0
            }):Play()
        end
    end)
    
    -- Close dropdown when clicking elsewhere
    local function CloseDropdown()
        if isOpen then
            isOpen = false
            OptionsFrame.Visible = false
            Arrow.Text = "▼"
            TweenService:Create(Arrow, Config.Animations.Fast, {
                Rotation = 0
            }):Play()
        end
    end
    
    -- Connect to UserInputService to detect clicks outside
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isOpen then
                local mousePos = input.Position
                local dropdownPos = DropdownFrame.AbsolutePosition
                local dropdownSize = DropdownFrame.AbsoluteSize
                local optionsPos = OptionsFrame.AbsolutePosition
                local optionsSize = OptionsFrame.AbsoluteSize
                
                -- Check if click is outside both dropdown and options
                local clickInDropdown = mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                                       mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y
                
                local clickInOptions = mousePos.X >= optionsPos.X and mousePos.X <= optionsPos.X + optionsSize.X and
                                      mousePos.Y >= optionsPos.Y and mousePos.Y <= optionsPos.Y + optionsSize.Y
                
                if not clickInDropdown and not clickInOptions then
                    CloseDropdown()
                end
            end
        end
    end)
    
    -- Update position when parent moves (for draggable GUI)
    spawn(function()
        while DropdownFrame.Parent do
            if isOpen then
                UpdateOptionsPosition()
            end
            wait(0.1)
        end
    end)
    
    -- Clean up options frame when dropdown is destroyed
    DropdownFrame.AncestryChanged:Connect(function()
        if not DropdownFrame.Parent then
            OptionsFrame:Destroy()
        end
    end)
    
    -- Hover effects for main dropdown
    DropdownButton.MouseEnter:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, Config.Animations.Fast, {
                BackgroundColor3 = Config.Colors.Border
            }):Play()
        end
    end)
    
    DropdownButton.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, Config.Animations.Fast, {
                BackgroundColor3 = Config.Colors.Secondary
            }):Play()
        end
    end)
    
    table.insert(tab.Components, DropdownFrame)
    
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    return {
        Dropdown = DropdownFrame, 
        SetValue = function(value) 
            currentValue = value 
            DropdownButton.Text = text .. ": " .. value 
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- NEW FUNCTION: Create TextBox
function Library:CreateTextBox(tab, text, placeholder, callback)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = text
    TextBoxFrame.Parent = tab.Content
    TextBoxFrame.BackgroundColor3 = Config.Colors.Secondary
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 45)
    TextBoxFrame.LayoutOrder = #tab.Components + 1
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 0)
    TextBoxCorner.Parent = TextBoxFrame
    
    local TextBoxStroke = Instance.new("UIStroke")
    TextBoxStroke.Color = Config.Colors.StrokeGreen
    TextBoxStroke.Thickness = 1
    TextBoxStroke.Parent = TextBoxFrame
    
    -- Label
    local TextBoxLabel = Instance.new("TextLabel")
    TextBoxLabel.Parent = TextBoxFrame
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Size = UDim2.new(1, -16, 0, 20)
    TextBoxLabel.Position = UDim2.new(0, 8, 0, 2)
    TextBoxLabel.Font = Enum.Font.Gotham
    TextBoxLabel.Text = text
    TextBoxLabel.TextColor3 = Config.Colors.Text
    TextBoxLabel.TextSize = 11
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- TextBox
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = TextBoxFrame
    TextBox.BackgroundColor3 = Config.Colors.Primary
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.new(1, -16, 0, 18)
    TextBox.Position = UDim2.new(0, 8, 1, -22)
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = placeholder or "Enter text..."
    TextBox.Text = ""
    TextBox.TextColor3 = Config.Colors.Text
    TextBox.PlaceholderColor3 = Config.Colors.TextSecondary
    TextBox.TextSize = 10
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextBoxInputStroke = Instance.new("UIStroke")
    TextBoxInputStroke.Color = Config.Colors.Border
    TextBoxInputStroke.Thickness = 1
    TextBoxInputStroke.Parent = TextBox
    
    -- Focus effects
    TextBox.Focused:Connect(function()
        TweenService:Create(TextBoxInputStroke, Config.Animations.Fast, {
            Color = Config.Colors.StrokeGreen
        }):Play()
    end)
    
    TextBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(TextBoxInputStroke, Config.Animations.Fast, {
            Color = Config.Colors.Border
        }):Play()
        
        if callback and enterPressed then
            callback(TextBox.Text)
        end
    end)
    
    table.insert(tab.Components, TextBoxFrame)
    
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.Size = UDim2.new(1, 0, 0, tab.Layout.AbsoluteContentSize.Y)
        ContentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    return {TextBox = TextBoxFrame, GetText = function() return TextBox.Text end, SetText = function(newText) TextBox.Text = newText end}
end

-- Control Button Functions
MinimizeButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    
    -- Update circle toggle color when minimized
    local fryzerGUI = PlayerGui:FindFirstChild("FryzerToggleGUI")
    if fryzerGUI and fryzerGUI:FindFirstChild("CircleFrame") then
        local circleFrame = fryzerGUI.CircleFrame
        local textLabel = circleFrame:FindFirstChild("TextLabel")
        local gradient = circleFrame:FindFirstChild("UIGradient")
        
        -- Set to inactive appearance
        TweenService:Create(circleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
        
        if textLabel then
            TweenService:Create(textLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end
        
        if gradient then
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(30, 30, 30)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(15, 15, 15))
            }
        end
    end
end)

-- Close Confirmation Dialog (FIXED - No background overlay)
local function CreateConfirmDialog()
    local ConfirmGui = Instance.new("ScreenGui")
    ConfirmGui.Name = "ConfirmDialog"
    ConfirmGui.Parent = PlayerGui
    ConfirmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConfirmGui.DisplayOrder = 200
    
    -- REMOVED: No overlay/background frame that covers full screen
    
    local ConfirmFrame = Instance.new("Frame")
    ConfirmFrame.Parent = ConfirmGui
    ConfirmFrame.BackgroundColor3 = Config.Colors.Primary
    ConfirmFrame.BorderSizePixel = 0
    ConfirmFrame.Size = UDim2.new(0, 300, 0, 120)
    ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 0) -- Removed corner rounding
    ConfirmCorner.Parent = ConfirmFrame
    
    local ConfirmStroke = Instance.new("UIStroke")
    ConfirmStroke.Color = Config.Colors.StrokeGreen
    ConfirmStroke.Thickness = 2
    ConfirmStroke.Parent = ConfirmFrame
    
    local ConfirmTitle = Instance.new("TextLabel")
    ConfirmTitle.Parent = ConfirmFrame
    ConfirmTitle.BackgroundTransparency = 1
    ConfirmTitle.Size = UDim2.new(1, 0, 0, 30)
    ConfirmTitle.Position = UDim2.new(0, 0, 0, 8)
    ConfirmTitle.Font = Enum.Font.GothamBold
    ConfirmTitle.Text = "Confirm Close"
    ConfirmTitle.TextColor3 = Config.Colors.Text
    ConfirmTitle.TextSize = 14
    
    local ConfirmText = Instance.new("TextLabel")
    ConfirmText.Parent = ConfirmFrame
    ConfirmText.BackgroundTransparency = 1
    ConfirmText.Size = UDim2.new(1, -16, 0, 25)
    ConfirmText.Position = UDim2.new(0, 8, 0, 35)
    ConfirmText.Font = Enum.Font.Gotham
    ConfirmText.Text = "Are you sure you want to close the hub?"
    ConfirmText.TextColor3 = Config.Colors.TextSecondary
    ConfirmText.TextSize = 11
    ConfirmText.TextWrapped = true
    
    local ButtonsFrame = Instance.new("Frame")
    ButtonsFrame.Parent = ConfirmFrame
    ButtonsFrame.BackgroundTransparency = 1
    ButtonsFrame.Size = UDim2.new(1, -16, 0, 30)
    ButtonsFrame.Position = UDim2.new(0, 8, 1, -38)
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.Parent = ButtonsFrame
    CancelButton.BackgroundColor3 = Config.Colors.Secondary
    CancelButton.BorderSizePixel = 0
    CancelButton.Size = UDim2.new(0.45, 0, 1, 0)
    CancelButton.Position = UDim2.new(0, 0, 0, 0)
    CancelButton.Font = Enum.Font.Gotham
    CancelButton.Text = "Cancel"
    CancelButton.TextColor3 = Config.Colors.Text
    CancelButton.TextSize = 11
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 0) -- Removed corner rounding
    CancelCorner.Parent = CancelButton
    
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Parent = ButtonsFrame
    ConfirmButton.BackgroundColor3 = Config.Colors.Error
    ConfirmButton.BorderSizePixel = 0
    ConfirmButton.Size = UDim2.new(0.45, 0, 1, 0)
    ConfirmButton.Position = UDim2.new(0.55, 0, 0, 0)
    ConfirmButton.Font = Enum.Font.Gotham
    ConfirmButton.Text = "Close"
    ConfirmButton.TextColor3 = Config.Colors.Text
    ConfirmButton.TextSize = 11
    
    local ConfirmButtonCorner = Instance.new("UICorner")
    ConfirmButtonCorner.CornerRadius = UDim.new(0, 0) -- Removed corner rounding
    ConfirmButtonCorner.Parent = ConfirmButton
    
    -- Animate in
    ConfirmFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(ConfirmFrame, Config.Animations.Bounce, {
        Size = UDim2.new(0, 300, 0, 120)
    }):Play()
    
    CancelButton.MouseButton1Click:Connect(function()
        ConfirmGui:Destroy()
    end)
    
    ConfirmButton.MouseButton1Click:Connect(function()
        -- Close both GUIs when confirmed
        ScreenGui:Destroy()
        ConfirmGui:Destroy()
        
        -- Also close the circle toggle GUI
        local fryzerGUI = PlayerGui:FindFirstChild("FryzerToggleGUI")
        if fryzerGUI then
            fryzerGUI:Destroy()
        end
    end)
    
    -- Hover effects
    CancelButton.MouseEnter:Connect(function()
        TweenService:Create(CancelButton, Config.Animations.Fast, {BackgroundColor3 = Config.Colors.Border}):Play()
    end)
    CancelButton.MouseLeave:Connect(function()
        TweenService:Create(CancelButton, Config.Animations.Fast, {BackgroundColor3 = Config.Colors.Secondary}):Play()
    end)
    
    ConfirmButton.MouseEnter:Connect(function()
        TweenService:Create(ConfirmButton, Config.Animations.Fast, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
    end)
    ConfirmButton.MouseLeave:Connect(function()
        TweenService:Create(ConfirmButton, Config.Animations.Fast, {BackgroundColor3 = Config.Colors.Error}):Play()
    end)
end

CloseButton.MouseButton1Click:Connect(function()
    CreateConfirmDialog()
end)

-- Control button hover effects (FIXED - Reset on mouse leave)
local minimizeHovered = false

MinimizeButton.MouseEnter:Connect(function()
    minimizeHovered = true
    TweenService:Create(MinimizeButton, Config.Animations.Fast, {
        TextColor3 = Config.Colors.Accent
    }):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    minimizeHovered = false
    TweenService:Create(MinimizeButton, Config.Animations.Fast, {
        TextColor3 = Config.Colors.Text
    }):Play()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, Config.Animations.Fast, {
        TextColor3 = Config.Colors.Error
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, Config.Animations.Fast, {
        TextColor3 = Config.Colors.Text
    }):Play()
end)

-- Animate GUI entrance
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(MainFrame, Config.Animations.Bounce, {
    Size = UDim2.new(0, 450, 0, 300),
    Position = UDim2.new(0.5, -225, 0.5, -150)
}):Play()
