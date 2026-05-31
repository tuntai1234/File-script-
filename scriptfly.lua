-- LocalScript trong StarterPlayerScripts
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local bodyVelocity, bodyGyro
local folded = false
local guiVisible = false

-- ========== SCREEN GUI ==========
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

-- ========== ICON NHỎ ==========
local iconBtn = Instance.new("TextButton", screenGui)
iconBtn.Size = UDim2.new(0, 50, 0, 50)
iconBtn.Position = UDim2.new(0, 20, 0, 60)
iconBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
iconBtn.Text = "✈️"
iconBtn.TextSize = 22
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextColor3 = Color3.new(1,1,1)
iconBtn.ZIndex = 10
Instance.new("UICorner", iconBtn).CornerRadius = UDim.new(1, 0)

-- ========== MAIN FRAME ==========
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 185)
frame.Position = UDim2.new(0, 80, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- ========== TITLE BAR ==========
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✈️ Fly Panel"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Nút gập
local foldBtn = Instance.new("TextButton", titleBar)
foldBtn.Size = UDim2.new(0, 28, 0, 22)
foldBtn.Position = UDim2.new(1, -32, 0.5, -11)
foldBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
foldBtn.Text = "−"
foldBtn.TextColor3 = Color3.new(1,1,1)
foldBtn.Font = Enum.Font.GothamBold
foldBtn.TextSize = 16
Instance.new("UICorner", foldBtn).CornerRadius = UDim.new(0, 5)

-- ========== NỘI DUNG ==========
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1

local toggleBtn = Instance.new("TextButton", content)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 8)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
toggleBtn.Text = "BAY: TẮT"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local speedLabel = Instance.new("TextLabel", content)
speedLabel.Size = UDim2.new(0.9, 0, 0, 22)
speedLabel.Position = UDim2.new(0.05, 0, 0, 58)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Tốc độ: 50"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 13
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderBg = Instance.new("Frame", content)
sliderBg.Size = UDim2.new(0.9, 0, 0, 12)
sliderBg.Position = UDim2.new(0.05, 0, 0, 83)
sliderBg.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(0.25, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local minusBtn = Instance.new("TextButton", content)
minusBtn.Size = UDim2.new(0, 35, 0, 28)
minusBtn.Position = UDim2.new(0.05, 0, 0, 100)
minusBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton", content)
plusBtn.Size = UDim2.new(0, 35, 0, 28)
plusBtn.Position = UDim2.new(0.05, 35, 0, 100)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

-- ========== RESIZE HANDLE ==========
local resizeHandle = Instance.new("TextButton", frame)
resizeHandle.Size = UDim2.new(0, 18, 0, 18)
resizeHandle.Position = UDim2.new(1, -18, 1, -18)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resizeHandle.Text = "⇲"
resizeHandle.TextSize = 11
resizeHandle.TextColor3 = Color3.new(1,1,1)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.ZIndex = 5
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

-- Logic resize
local resizing = false
local resizeStart, startSize, startPos

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = frame.AbsoluteSize
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - resizeStart
        local newW = math.clamp(startSize.X + delta.X, 160, 400)
        local newH = math.clamp(startSize.Y + delta.Y, 120, 500)
        frame.Size = UDim2.new(0, newW, 0, newH)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- ========== NÚT MOBILE ==========
local function makeBtn(parent, text, pos, color)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 55, 0, 55)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BackgroundTransparency = 0.3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    return btn
end

local mobileFrame = Instance.new("Frame", screenGui)
mobileFrame.Size = UDim2.new(0, 175, 0, 175)
mobileFrame.Position = UDim2.new(0, 10, 1, -190)
mobileFrame.BackgroundTransparency = 1
mobileFrame.Active = true
mobileFrame.Visible = false

local btnUp    = makeBtn(mobileFrame, "↑", UDim2.new(0, 60, 0, 0),   Color3.fromRGB(50,100,255))
local btnLeft  = makeBtn(mobileFrame, "←", UDim2.new(0, 0, 0, 60),   Color3.fromRGB(50,100,255))
local btnDown  = makeBtn(mobileFrame, "↓", UDim2.new(0, 60, 0, 120), Color3.fromRGB(50,100,255))
local btnRight = makeBtn(mobileFrame, "→", UDim2.new(0, 120, 0, 60), Color3.fromRGB(50,100,255))
local btnRise  = makeBtn(mobileFrame, "▲", UDim2.new(0, 75, 0, 62),  Color3.fromRGB(80,200,80))
btnRise.Size = UDim2.new(0, 25, 0, 25)
local btnFall  = makeBtn(mobileFrame, "▼", UDim2.new(0, 75, 0, 92),  Color3.fromRGB(200,80,80))
btnFall.Size = UDim2.new(0, 25, 0, 25)

local mobileMove = {up=false, down=false, left=false, right=false, rise=false, fall=false}

local function bindBtn(btn, key)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            mobileMove[key] = true
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            mobileMove[key] = false
        end
    end)
end

bindBtn(btnUp,    "up")
bindBtn(btnDown,  "down")
bindBtn(btnLeft,  "left")
bindBtn(btnRight, "right")
bindBtn(btnRise,  "rise")
bindBtn(btnFall,  "fall")

-- ========== HÀM BAY ==========
local function updateSpeed()
    speedLabel.Text = "Tốc độ: " .. speed
    sliderFill.Size = UDim2.new(math.clamp(speed / 200, 0, 1), 0, 1, 0)
end

local function startFly()
    flying = true
    humanoid.PlatformStand = true
    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 1e4
    toggleBtn.Text = "BAY: BẬT"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
    mobileFrame.Visible = true
end

local function stopFly()
    flying = false
    humanoid.PlatformStand = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    toggleBtn.Text = "BAY: TẮT"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
    mobileFrame.Visible = false
end

-- ========== GẬP / MỞ GUI ==========
foldBtn.MouseButton1Click:Connect(function()
    folded = not folded
    content.Visible = not folded
    resizeHandle.Visible = not folded
    if folded then
        frame.Size = UDim2.new(0, frame.AbsoluteSize.X, 0, 35)
        foldBtn.Text = "+"
    else
        frame.Size = UDim2.new(0, frame.AbsoluteSize.X, 0, 185)
        foldBtn.Text = "−"
    end
end)

-- ========== ICON BẬT/TẮT GUI ==========
local lastTap = 0

iconBtn.MouseButton1Click:Connect(function()
    local now = tick()
    if now - lastTap < 0.4 then
        -- Bấm 2 lần: tắt GUI
        guiVisible = false
        frame.Visible = false
    else
        -- Bấm 1 lần: bật GUI
        guiVisible = true
        frame.Visible = true
    end
    lastTap = now
end)

-- ========== SỰ KIỆN ==========
toggleBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

minusBtn.MouseButton1Click:Connect(function()
    speed = math.max(10, speed - 10)
    updateSpeed()
end)

plusBtn.MouseButton1Click:Connect(function()
    speed = math.min(200, speed + 10)
    updateSpeed()
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    end
end)

RunService.Heartbeat:Connect(function()
    if not flying then return end
    local cam = workspace.CurrentCamera
    local move = Vector3.new(0, 0, 0)

    if UserInputService:IsKeyDown(Enum.KeyCode.W) or mobileMove.up then
        move = move + cam.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) or mobileMove.down then
        move = move - cam.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) or mobileMove.left then
        move = move - cam.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) or mobileMove.right then
        move = move + cam.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or mobileMove.rise then
        move = move + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or mobileMove.fall then
        move = move - Vector3.new(0, 1, 0)
    end

    if move.Magnitude > 0 then
        bodyVelocity.Velocity = move.Unit * speed
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end

    bodyGyro.CFrame = cam.CFrame
end)

updateSpeed()