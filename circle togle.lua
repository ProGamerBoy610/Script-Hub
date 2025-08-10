-- Fryzer Circle Toggle GUI
-- Small circular button to show/hide ModernHubGUI
-- Works on Mobile and PC with drag functionality

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local Config = {
    CircleSize = 60, -- Size of the circle
    Colors = {
        Background = Color3.fromRGB(20, 20, 20),
        Border = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(88, 101, 242),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Position = {
        X = 100, -- Default X position
        Y = 200  -- Default Y position
    }
}

-- Remove existing Fryzer GUI if it exists
if PlayerGui:FindFirstChild("FryzerToggleGUI") then
    PlayerGui:FindFirstChild("FryzerToggleGUI"):Destroy()
end

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FryzerToggleGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999 -- High display order to stay on top

-- Create Shadow Frame (for drop shadow effect)
local ShadowFrame = Instance.new("Frame")
ShadowFrame.Name = "ShadowFrame"
ShadowFrame.Parent = ScreenGui
ShadowFrame.BackgroundColor3 = Config.Colors.Shadow
ShadowFrame.BackgroundTransparency = 0.7
ShadowFrame.BorderSizePixel = 0
ShadowFrame.Position = UDim2.new(0, Config.Position.X + 3, 0, Config.Position.Y + 3)
ShadowFrame.Size = UDim2.new(0, Config.CircleSize, 0, Config.CircleSize)
ShadowFrame.ZIndex = 1

-- Make shadow circular
local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0.5, 0)
ShadowCorner.Parent = ShadowFrame

-- Create Main Circle Frame
local CircleFrame = Instance.new("Frame")
CircleFrame.Name = "CircleFrame"
CircleFrame.Parent = ScreenGui
CircleFrame.BackgroundColor3 = Config.Colors.Background
CircleFrame.BorderSizePixel = 2
CircleFrame.BorderColor3 = Config.Colors.Border
CircleFrame.Position = UDim2.new(0, Config.Position.X, 0, Config.Position.Y)
CircleFrame.Size = UDim2.new(0, Config.CircleSize, 0, Config.CircleSize)
CircleFrame.ZIndex = 2

-- Make frame circular
local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(0.5, 0)
CircleCorner.Parent = CircleFrame

-- Add gradient effect
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(15, 15, 15))
}
Gradient.Rotation = 45
Gradient.Parent = CircleFrame

-- Create Button (invisible but covers the circle)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = CircleFrame
ToggleButton.BackgroundTransparency = 1
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Text = ""
ToggleButton.ZIndex = 4

-- Create Text Label
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Parent = CircleFrame
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Fryzer"
TextLabel.TextColor3 = Config.Colors.Text
TextLabel.TextSize = 12
TextLabel.TextScaled = true
TextLabel.ZIndex = 3

-- Add text size constraint
local TextSizeConstraint = Instance.new("UITextSizeConstraint")
TextSizeConstraint.MaxTextSize = 12
TextSizeConstraint.MinTextSize = 8
TextSizeConstraint.Parent = TextLabel

-- Variables for dragging
local dragging = false
local dragStart = nil
local startPos = nil

-- Mobile and PC drag support
local function InputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = CircleFrame.Position
    end
end

local function InputChanged(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            
            -- Keep within screen bounds
            local screenSize = workspace.CurrentCamera.ViewportSize
            local x = math.clamp(newPosition.X.Offset, 0, screenSize.X - Config.CircleSize)
            local y = math.clamp(newPosition.Y.Offset, GuiService:GetGuiInset().Y, screenSize.Y - Config.CircleSize)
            
            CircleFrame.Position = UDim2.new(0, x, 0, y)
            ShadowFrame.Position = UDim2.new(0, x + 3, 0, y + 3)
        end
    end
end

local function InputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end

-- Connect drag events
ToggleButton.InputBegan:Connect(InputBegan)
UserInputService.InputChanged:Connect(InputChanged)
UserInputService.InputEnded:Connect(InputEnded)

-- Hover/Touch effects
ToggleButton.MouseEnter:Connect(function()
    TweenService:Create(CircleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, Config.CircleSize + 5, 0, Config.CircleSize + 5),
        BorderColor3 = Config.Colors.Accent
    }):Play()
    
    TweenService:Create(ShadowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, Config.CircleSize + 5, 0, Config.CircleSize + 5),
        BackgroundTransparency = 0.5
    }):Play()
    
    TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextColor3 = Config.Colors.Accent
    }):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    TweenService:Create(CircleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, Config.CircleSize, 0, Config.CircleSize),
        BorderColor3 = Config.Colors.Border
    }):Play()
    
    TweenService:Create(ShadowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, Config.CircleSize, 0, Config.CircleSize),
        BackgroundTransparency = 0.7
    }):Play()
    
    TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextColor3 = Config.Colors.Text
    }):Play()
end)

-- Toggle functionality for ModernHubGUI
local isHubVisible = false

local function ToggleModernHub()
    local modernHubGui = PlayerGui:FindFirstChild("ModernHubGUI")
    
    if modernHubGui then
        isHubVisible = not isHubVisible
        modernHubGui.Enabled = isHubVisible
        
        -- Visual feedback
        if isHubVisible then
            -- Hub is now visible - change circle to accent color
            TweenService:Create(CircleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Config.Colors.Accent,
                BorderColor3 = Color3.fromRGB(120, 130, 255)
            }):Play()
            
            TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            
            -- Update gradient for active state
            Gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(100, 110, 255)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(70, 85, 220))
            }
        else
            -- Hub is now hidden - return to normal colors
            TweenService:Create(CircleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Config.Colors.Background,
                BorderColor3 = Config.Colors.Border
            }):Play()
            
            TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                TextColor3 = Config.Colors.Text
            }):Play()
            
            -- Return gradient to normal
            Gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(30, 30, 30)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(15, 15, 15))
            }
        end
        
        -- Click animation
        local clickTween = TweenService:Create(CircleFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Config.CircleSize - 5, 0, Config.CircleSize - 5)
        })
        
        clickTween:Play()
        clickTween.Completed:Connect(function()
            TweenService:Create(CircleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, Config.CircleSize, 0, Config.CircleSize)
            }):Play()
        end)
        
    else
        -- ModernHubGUI not found - visual feedback
        TweenService:Create(CircleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BorderColor3 = Color3.fromRGB(255, 100, 100)
        }):Play()
        
        TweenService:Create(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            TextColor3 = Color3.fromRGB(255, 150, 150)
        }):Play()
        
        -- Return to normal after showing error
        wait(0.5)
        TweenService:Create(CircleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BorderColor3 = Config.Colors.Border
        }):Play()
        
        TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            TextColor3 = Config.Colors.Text
        }):Play()
        
        print("⚠️ ModernHubGUI not found! Make sure it exists in PlayerGui.")
    end
end

-- Click/Touch event for toggling
ToggleButton.MouseButton1Click:Connect(function()
    if not dragging then -- Only toggle if not dragging
        ToggleModernHub()
    end
end)

-- Touch support for mobile
ToggleButton.TouchTap:Connect(function()
    if not dragging then -- Only toggle if not dragging
        ToggleModernHub()
    end
end)

-- Initialize - check if ModernHubGUI exists and set initial state
spawn(function()
    wait(0.5) -- Wait a bit for other scripts to load
    local modernHubGui = PlayerGui:FindFirstChild("ModernHubGUI")
    if modernHubGui then
        isHubVisible = modernHubGui.Enabled
        if isHubVisible then
            -- Set active appearance if hub is already visible
            CircleFrame.BackgroundColor3 = Config.Colors.Accent
            CircleFrame.BorderColor3 = Color3.fromRGB(120, 130, 255)
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            Gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(100, 110, 255)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(70, 85, 220))
            }
        end
    end
end)

-- Prevent dragging from triggering toggle
local dragThreshold = 5
local startDragPos = nil

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDragPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if startDragPos then
            local currentPos = UserInputService:GetMouseLocation()
            local distance = (currentPos - startDragPos).Magnitude
            
            -- If moved less than threshold, consider it a click
            if distance < dragThreshold and not dragging then
                ToggleModernHub()
            end
        end
        dragging = false
        startDragPos = nil
    end
end)

