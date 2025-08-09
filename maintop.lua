--My Script Hub

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Library = {}

-- Configuration
local config = {
    colors = {
        background = Color3.fromRGB(25, 25, 35),
        secondary = Color3.fromRGB(35, 35, 45),
        accent = Color3.fromRGB(88, 101, 242),
        success = Color3.fromRGB(87, 242, 135),
        danger = Color3.fromRGB(242, 87, 87),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(180, 180, 180),
        border = Color3.fromRGB(45, 45, 55)
    },
    tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    fastTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
}

-- Utility Functions
local function tween(object, properties, tweenInfo)
    local tween = TweenService:Create(object, tweenInfo or config.tweenInfo, properties)
    tween:Play()
    return tween
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or config.colors.border
    stroke.Parent = parent
    return stroke
end

-- Component Creation Functions (parent is optional)
local function createHeader(text, parent)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -10, 0, 30)
    header.BackgroundColor3 = config.colors.accent
    header.BorderSizePixel = 0
    header.Text = text
    header.TextColor3 = config.colors.text
    header.TextScaled = true
    header.Font = Enum.Font.GothamBold
    
    createCorner(header, 6)
    if parent then header.Parent = parent end
    return header
end

local function createLabel(text, parent)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 22)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = config.colors.textSecondary
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    if parent then label.Parent = parent end
    return label
end

local function createButton(text, callback, parent, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 32)
    button.BackgroundColor3 = color or config.colors.accent
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = config.colors.text
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    
    createCorner(button, 6)
    
    -- Button hover and click effects
    button.MouseEnter:Connect(function()
        tween(button, {BackgroundColor3 = Color3.new(
            math.min(button.BackgroundColor3.R + 0.1, 1),
            math.min(button.BackgroundColor3.G + 0.1, 1),
            math.min(button.BackgroundColor3.B + 0.1, 1)
        )}, config.fastTweenInfo)
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {BackgroundColor3 = color or config.colors.accent}, config.fastTweenInfo)
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Flash effect
        local originalColor = button.BackgroundColor3
        tween(button, {BackgroundColor3 = config.colors.success}, config.fastTweenInfo)
        spawn(function()
            wait(1)
            tween(button, {BackgroundColor3 = originalColor}, config.fastTweenInfo)
        end)
        
        if callback then
            callback()
        end
    end)
    
    if parent then button.Parent = parent end
    return button
end

local function createToggle(text, defaultState, callback, parent)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 32)
    toggleFrame.BackgroundColor3 = config.colors.background
    toggleFrame.BorderSizePixel = 0
    
    createCorner(toggleFrame, 6)
    createStroke(toggleFrame, 1)
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = config.colors.text
    toggleLabel.TextScaled = true
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 22)
    toggleButton.Position = UDim2.new(1, -45, 0.5, -11)
    toggleButton.BackgroundColor3 = defaultState and config.colors.success or Color3.fromRGB(100, 100, 100)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    createCorner(toggleButton, 11)
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Size = UDim2.new(0, 18, 0, 18)
    toggleIndicator.Position = defaultState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    toggleIndicator.BackgroundColor3 = config.colors.text
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    createCorner(toggleIndicator, 9)
    
    local isToggled = defaultState
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        tween(toggleButton, {
            BackgroundColor3 = isToggled and config.colors.success or Color3.fromRGB(100, 100, 100)
        })
        
        tween(toggleIndicator, {
            Position = isToggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        })
        
        if callback then
            callback(isToggled)
        end
    end)
    
    if parent then toggleFrame.Parent = parent end
    return toggleFrame
end

local function createSlider(text, minVal, maxVal, defaultVal, callback, parent)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 45)
    sliderFrame.BackgroundColor3 = config.colors.background
    sliderFrame.BorderSizePixel = 0
    
    createCorner(sliderFrame, 6)
    createStroke(sliderFrame, 1)
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -10, 0, 20)
    sliderLabel.Position = UDim2.new(0, 5, 0, 3)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. defaultVal
    sliderLabel.TextColor3 = config.colors.text
    sliderLabel.TextScaled = true
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -20, 0, 6)
    sliderTrack.Position = UDim2.new(0, 10, 1, -15)
    sliderTrack.BackgroundColor3 = config.colors.border
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    createCorner(sliderTrack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = config.colors.accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    createCorner(sliderFill, 3)
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0.5, -8)
    sliderHandle.BackgroundColor3 = config.colors.text
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderTrack
    
    createCorner(sliderHandle, 8)
    
    local currentValue = defaultVal
    local isDragging = false
    
    local function updateSlider(input)
        local relativePos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(minVal + (maxVal - minVal) * relativePos)
        
        tween(sliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)}, config.fastTweenInfo)
        tween(sliderHandle, {Position = UDim2.new(relativePos, -8, 0.5, -8)}, config.fastTweenInfo)
        
        sliderLabel.Text = text .. ": " .. currentValue
        
        if callback then
            callback(currentValue)
        end
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    if parent then sliderFrame.Parent = parent end
    return sliderFrame
end

local function createDropdown(text, options, callback, parent)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, -10, 0, 32)
    dropdownFrame.BackgroundColor3 = config.colors.background
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.ZIndex = 5
    
    createCorner(dropdownFrame, 6)
    createStroke(dropdownFrame, 1)
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, -10, 1, 0)
    dropdownButton.Position = UDim2.new(0, 5, 0, 0)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = text .. ": " .. options[1]
    dropdownButton.TextColor3 = config.colors.text
    dropdownButton.TextScaled = true
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    local dropdownArrow = Instance.new("TextLabel")
    dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    dropdownArrow.Position = UDim2.new(1, -25, 0, 0)
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = config.colors.textSecondary
    dropdownArrow.TextScaled = true
    dropdownArrow.Font = Enum.Font.Gotham
    dropdownArrow.Parent = dropdownFrame
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(1, 0, 0, #options * 28)
    dropdownList.Position = UDim2.new(0, 0, 1, 2)
    dropdownList.BackgroundColor3 = config.colors.background
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 10
    dropdownList.Parent = dropdownFrame
    
    createCorner(dropdownList, 6)
    createStroke(dropdownList, 1)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = dropdownList
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 28)
        optionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        optionButton.BackgroundTransparency = 1
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = config.colors.text
        optionButton.TextScaled = true
        optionButton.Font = Enum.Font.Gotham
        optionButton.LayoutOrder = i
        optionButton.ZIndex = 11
        optionButton.Parent = dropdownList
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundTransparency = 0.9
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundTransparency = 1
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = text .. ": " .. option
            dropdownList.Visible = false
            tween(dropdownArrow, {Rotation = 0}, config.fastTweenInfo)
            
            if callback then
                callback(option)
            end
        end)
    end
    
    local isOpen = false
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        dropdownList.Visible = isOpen
        
        if isOpen then
            tween(dropdownArrow, {Rotation = 180}, config.fastTweenInfo)
        else
            tween(dropdownArrow, {Rotation = 0}, config.fastTweenInfo)
        end
    end)
    
    if parent then dropdownFrame.Parent = parent end
    return dropdownFrame
end

local function createTextBox(placeholderText, callback, parent)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Size = UDim2.new(1, -10, 0, 32)
    textBoxFrame.BackgroundColor3 = config.colors.background
    textBoxFrame.BorderSizePixel = 0
    
    createCorner(textBoxFrame, 6)
    createStroke(textBoxFrame, 1)
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 1, 0)
    textBox.Position = UDim2.new(0, 5, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.PlaceholderText = placeholderText
    textBox.Text = ""
    textBox.TextColor3 = config.colors.text
    textBox.PlaceholderColor3 = config.colors.textSecondary
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.Parent = textBoxFrame
    
    textBox.FocusLost:Connect(function()
        if callback then
            callback(textBox.Text)
        end
    end)
    
    if parent then textBoxFrame.Parent = parent end
    return textBoxFrame
end

local function createNavButton(name, index)
    local navButton = Instance.new("TextButton")
    navButton.Name = name
    navButton.Size = UDim2.new(1, -6, 0, 28)
    navButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    navButton.BackgroundTransparency = 1
    navButton.BorderSizePixel = 0
    navButton.Text = name
    navButton.TextColor3 = config.colors.text
    navButton.TextScaled = true
    navButton.Font = Enum.Font.Gotham
    navButton.LayoutOrder = index
    
    createCorner(navButton, 6)
    
    return navButton
end

-- Notification System
local function createNotification(screenGui, title, message, duration, notifType)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 280, 0, 60)
    notifFrame.Position = UDim2.new(1, 300, 0.1, 0)
    notifFrame.BackgroundColor3 = config.colors.background
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = screenGui
    
    createCorner(notifFrame, 8)
    createStroke(notifFrame, 1, config.colors.border)
    
    local notifIcon = Instance.new("Frame")
    notifIcon.Size = UDim2.new(0, 6, 1, 0)
    notifIcon.Position = UDim2.new(0, 0, 0, 0)
    notifIcon.BackgroundColor3 = notifType == "success" and config.colors.success or 
                               notifType == "error" and config.colors.danger or 
                               config.colors.accent
    notifIcon.BorderSizePixel = 0
    notifIcon.Parent = notifFrame
    
    createCorner(notifIcon, 8)
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -15, 0, 20)
    notifTitle.Position = UDim2.new(0, 12, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = config.colors.text
    notifTitle.TextScaled = true
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.Parent = notifFrame
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Size = UDim2.new(1, -15, 0, 25)
    notifMessage.Position = UDim2.new(0, 12, 0, 25)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = message
    notifMessage.TextColor3 = config.colors.textSecondary
    notifMessage.TextScaled = true
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    notifMessage.Font = Enum.Font.Gotham
    notifMessage.Parent = notifFrame
    
    -- Animate in
    tween(notifFrame, {Position = UDim2.new(1, -290, 0.1, 0)})
    
    -- Auto dismiss
    spawn(function()
        wait(duration or 3)
        tween(notifFrame, {Position = UDim2.new(1, 300, 0.1, 0)})
        wait(0.3)
        notifFrame:Destroy()
    end)
    
    return notifFrame
end

function Library:CreateWindow(options)
    local title = options.Title or "Modern Hub GUI"
    local windowSize = options.Size or UDim2.new(0, 420, 0, 280)
    local windowPosition = options.Position or UDim2.new(0.5, -210, 0.5, -140)

    -- Main GUI Container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernHubGUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = windowSize
    mainFrame.Position = windowPosition
    mainFrame.BackgroundColor3 = config.colors.background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    createCorner(mainFrame, 12)
    createStroke(mainFrame, 1, config.colors.border)

    -- Drop Shadow Effect
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Name = "Shadow"
    shadowFrame.Size = UDim2.new(1, 4, 1, 4)
    shadowFrame.Position = UDim2.new(0, -2, 0, -2)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.7
    shadowFrame.BorderSizePixel = 0
    shadowFrame.ZIndex = mainFrame.ZIndex - 1
    shadowFrame.Parent = mainFrame

    createCorner(shadowFrame, 12)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = config.colors.secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    createCorner(titleBar, 12)

    -- Fix corner clipping
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = config.colors.secondary
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = config.colors.text
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = config.colors.danger
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = config.colors.text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar

    createCorner(closeButton, 6)

    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -58, 0, 5)
    minimizeButton.BackgroundColor3 = config.colors.accent
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = config.colors.text
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleBar

    createCorner(minimizeButton, 6)

    -- Navigation Panel
    local navPanel = Instance.new("Frame")
    navPanel.Name = "NavPanel"
    navPanel.Size = UDim2.new(0, 100, 1, -40)
    navPanel.Position = UDim2.new(0, 5, 0, 38)
    navPanel.BackgroundColor3 = config.colors.secondary
    navPanel.BorderSizePixel = 0
    navPanel.Parent = mainFrame

    createCorner(navPanel, 8)

    local navScrollFrame = Instance.new("ScrollingFrame")
    navScrollFrame.Size = UDim2.new(1, -6, 1, -6)
    navScrollFrame.Position = UDim2.new(0, 3, 0, 3)
    navScrollFrame.BackgroundTransparency = 1
    navScrollFrame.BorderSizePixel = 0
    navScrollFrame.ScrollBarThickness = 4
    navScrollFrame.ScrollBarImageColor3 = config.colors.accent
    navScrollFrame.Parent = navPanel

    local navLayout = Instance.new("UIListLayout")
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 3)
    navLayout.Parent = navScrollFrame

    -- Update nav canvas size
    navScrollFrame.ChildAdded:Connect(function()
        RunService.Heartbeat:Wait()
        navScrollFrame.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 20)
    end)

    -- Content Panel
    local contentPanel = Instance.new("Frame")
    contentPanel.Name = "ContentPanel"
    contentPanel.Size = UDim2.new(1, -115, 1, -40)
    contentPanel.Position = UDim2.new(0, 110, 0, 38)
    contentPanel.BackgroundColor3 = config.colors.secondary
    contentPanel.BorderSizePixel = 0
    contentPanel.Parent = mainFrame

    createCorner(contentPanel, 8)

    -- Mini Bar for minimize functionality
    local miniBar = Instance.new("Frame")
    miniBar.Name = "MiniBar"
    miniBar.Size = UDim2.new(0, 180, 0, 28)
    miniBar.Position = UDim2.new(0.5, -90, 0.1, 0)
    miniBar.BackgroundColor3 = config.colors.background
    miniBar.BorderSizePixel = 0
    miniBar.Parent = screenGui
    miniBar.Visible = false
    miniBar.Active = true
    miniBar.Draggable = true

    createCorner(miniBar, 8)
    createStroke(miniBar, 1, config.colors.border)

    local miniText = Instance.new("TextLabel")
    miniText.Size = UDim2.new(1, -30, 1, 0)
    miniText.Position = UDim2.new(0, 8, 0, 0)
    miniText.BackgroundTransparency = 1
    miniText.Text = title
    miniText.TextColor3 = config.colors.text
    miniText.TextScaled = true
    miniText.TextXAlignment = Enum.TextXAlignment.Left
    miniText.Font = Enum.Font.GothamBold
    miniText.Parent = miniBar

    local restoreButton = Instance.new("TextButton")
    restoreButton.Size = UDim2.new(0, 22, 0, 22)
    restoreButton.Position = UDim2.new(1, -25, 0, 3)
    restoreButton.BackgroundColor3 = config.colors.accent
    restoreButton.BorderSizePixel = 0
    restoreButton.Text = "+"
    restoreButton.TextColor3 = config.colors.text
    restoreButton.TextScaled = true
    restoreButton.Font = Enum.Font.GothamBold
    restoreButton.Parent = miniBar

    createCorner(restoreButton, 6)

    -- Event Connections
    closeButton.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)})
        wait(0.3)
        screenGui:Destroy()
    end)

    minimizeButton.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)})
        wait(0.3)
        mainFrame.Visible = false
        miniBar.Visible = true
        tween(miniBar, {Position = UDim2.new(0.5, -90, 0.1, 0)})
    end)

    restoreButton.MouseButton1Click:Connect(function()
        tween(miniBar, {Position = UDim2.new(0.5, -90, -0.1, 0)})
        wait(0.1)
        miniBar.Visible = false
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        tween(mainFrame, {Size = windowSize})
    end)

    -- Hover effects for title bar buttons
    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}, config.fastTweenInfo)
    end)

    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {BackgroundColor3 = config.colors.danger}, config.fastTweenInfo)
    end)

    minimizeButton.MouseEnter:Connect(function()
        tween(minimizeButton, {BackgroundColor3 = Color3.fromRGB(108, 121, 255)}, config.fastTweenInfo)
    end)

    minimizeButton.MouseLeave:Connect(function()
        tween(minimizeButton, {BackgroundColor3 = config.colors.accent}, config.fastTweenInfo)
    end)

    restoreButton.MouseEnter:Connect(function()
        tween(restoreButton, {BackgroundColor3 = Color3.fromRGB(108, 121, 255)}, config.fastTweenInfo)
    end)

    restoreButton.MouseLeave:Connect(function()
        tween(restoreButton, {BackgroundColor3 = config.colors.accent}, config.fastTweenInfo)
    end)

    -- Keyboard shortcuts
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F4 then
            if mainFrame.Visible then
                minimizeButton.MouseButton1Click:Fire()
            else
                restoreButton.MouseButton1Click:Fire()
            end
        elseif input.KeyCode == Enum.KeyCode.F5 then
            -- Refresh/reload GUI
            createNotification(screenGui, "System", "GUI Refreshed", 2, "success")
            -- You can add refresh logic if needed
        end
    end)

    -- Mobile touch compatibility
    local isMobile = UserInputService.TouchEnabled
    if isMobile then
        mainFrame.Size = UDim2.new(0, 380, 0, 260)
        mainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
    end

    local Window = {
        Tabs = {},
        NavButtons = {},
        CurrentTab = nil
    }

    function Window:CreateTab(name)
        local Tab = {}
        local index = #self.Tabs + 1
        local navButton = createNavButton(name, index)
        navButton.Parent = navScrollFrame
        self.NavButtons[name] = navButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, -10, 1, -10)
        tabContent.Position = UDim2.new(0, 5, 0, 5)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = config.colors.accent
        tabContent.Parent = contentPanel
        tabContent.Visible = false

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.Parent = tabContent

        tabContent.ChildAdded:Connect(function()
            RunService.Heartbeat:Wait()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Hover effects
        navButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= name then
                tween(navButton, {BackgroundTransparency = 0.9})
            end
        end)
        
        navButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= name then
                tween(navButton, {BackgroundTransparency = 1})
            end
        end)

        -- Click to switch tab
        navButton.MouseButton1Click:Connect(function()
            if self.CurrentTab then
                local prevButton = self.NavButtons[self.CurrentTab]
                tween(prevButton, {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1})
                self.Tabs[self.CurrentTab].Content.Visible = false
            end
            self.CurrentTab = name
            tween(navButton, {BackgroundColor3 = config.colors.accent, BackgroundTransparency = 0})
            tabContent.Visible = true
        end)

        Tab.Content = tabContent

        function Tab:CreateHeader(text)
            local header = createHeader(text, self.Content)
            if isMobile then
                header.Size = UDim2.new(1, -10, 0, 35)
            end
            return header
        end

        function Tab:CreateLabel(text)
            local label = createLabel(text, self.Content)
            if isMobile then
                label.Size = UDim2.new(1, -10, 0, 28)
            end
            return label
        end

        function Tab:CreateButton(text, callback, color)
            local button = createButton(text, callback, self.Content, color)
            if isMobile then
                button.Size = UDim2.new(1, -10, 0, 38)
            end
            return button
        end

        function Tab:CreateToggle(text, defaultState, callback)
            local toggle = createToggle(text, defaultState, callback, self.Content)
            if isMobile then
                toggle.Size = UDim2.new(1, -10, 0, 38)
            end
            return toggle
        end

        function Tab:CreateSlider(text, minVal, maxVal, defaultVal, callback)
            local slider = createSlider(text, minVal, maxVal, defaultVal, callback, self.Content)
            if isMobile then
                slider.Size = UDim2.new(1, -10, 0, 50)
            end
            return slider
        end

        function Tab:CreateDropdown(text, options, callback)
            local dropdown = createDropdown(text, options, callback, self.Content)
            if isMobile then
                dropdown.Size = UDim2.new(1, -10, 0, 38)
            end
            return dropdown
        end

        function Tab:CreateInput(placeholderText, callback)
            local input = createTextBox(placeholderText, callback, self.Content)
            if isMobile then
                input.Size = UDim2.new(1, -10, 0, 38)
            end
            return input
        end

        self.Tabs[name] = Tab

        -- Select first tab automatically
        if not self.CurrentTab then
            self.CurrentTab = name
            navButton.BackgroundColor3 = config.colors.accent
            navButton.BackgroundTransparency = 0
            tabContent.Visible = true
        end

        return Tab
    end

    function Window:Notify(title, message, duration, notifType)
        createNotification(screenGui, title, message, duration, notifType)
    end

    function Window:Destroy()
        screenGui:Destroy()
    end

    return Window
end

-- Add this line at the very end of your maintop.lua file (after line 868)

return Library
