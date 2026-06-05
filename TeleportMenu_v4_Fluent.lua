-- ================================================================
--  TELEPORT MENU v4  ·  Fluent Design  |  by Claude
--  Fluent Design System:
--    • Acrylic/Mica dark background với noise texture giả
--    • Reveal Highlight khi hover (light sweep effect)
--    • Depth layers: shadow + glow border
--    • Rounded corners nhất quán (8 / 12 / 16px)
--    • Typography: Gotham hierarchy (9 / 11 / 13 / 15px)
--    • Accent color: Windows 11 Blue #0078D4
--    • Micro-animations mượt (0.15s ease)
--    • Multi-tab: Home · Waypoints · Settings
--    • Profile Manager, Export/Import, Distance realtime
--    • AutoFarm, NoClip, WalkSpeed, JumpPower
--    • Hotkeys: H=Toggle · F=Save · G=Nearest
-- ================================================================

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local LocalPlayer  = Players.LocalPlayer

-- Dọn GUI cũ
local CoreGui = game:GetService("CoreGui")
for _, n in ipairs({"TeleportGUI_v3","TeleportGUI_v4","TeleportGUI_Fluent"}) do
    if CoreGui:FindFirstChild(n) then CoreGui[n]:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "TeleportGUI_Fluent"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = CoreGui

-- ================================================================
-- FLUENT PALETTE
-- ================================================================
local F = {
    -- Mica/Acrylic layers
    Mica0      = Color3.fromRGB(20,  20,  28),   -- deepest bg
    Mica1      = Color3.fromRGB(28,  28,  38),   -- card bg
    Mica2      = Color3.fromRGB(36,  36,  50),   -- elevated card
    Mica3      = Color3.fromRGB(44,  44,  62),   -- control bg
    Mica4      = Color3.fromRGB(58,  58,  80),   -- hover state

    -- Accent (Windows 11 blue)
    Accent     = Color3.fromRGB(0,   120, 212),
    AccentHov  = Color3.fromRGB(24,  140, 230),
    AccentPrs  = Color3.fromRGB(0,   100, 180),
    AccentLight= Color3.fromRGB(96,  180, 255),

    -- Semantic
    Success    = Color3.fromRGB(16,  196,  105),
    Danger     = Color3.fromRGB(232,  17,  35),
    Warning    = Color3.fromRGB(255, 185,   0),
    Info       = Color3.fromRGB(0,   153, 188),

    -- Text
    TextPri    = Color3.fromRGB(255, 255, 255),
    TextSec    = Color3.fromRGB(160, 160, 185),
    TextDis    = Color3.fromRGB(100, 100, 130),

    -- Borders
    Border     = Color3.fromRGB(255, 255, 255),  -- opacity handled via UIStroke
    BorderSub  = Color3.fromRGB(60,  60,  85),

    -- Misc
    White      = Color3.fromRGB(255, 255, 255),
    Black      = Color3.fromRGB(0,   0,   0),
    Teal       = Color3.fromRGB(0,   188, 188),
    Purple     = Color3.fromRGB(136,  37, 255),
}

local FW, FH = 340, 440

-- ================================================================
-- BASE HELPERS
-- ================================================================
local function Corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end

local function MkStroke(p, col, thick, trans)
    local s = Instance.new("UIStroke", p)
    s.Color = col or F.Border
    s.Thickness = thick or 1
    s.Transparency = trans or 0.7
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function MkGrad(p, c0, c1, rot, t0, t1)
    local g = Instance.new("UIGradient", p)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c0),
        ColorSequenceKeypoint.new(1, c1),
    })
    if t0 or t1 then
        g.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, t0 or 0),
            NumberSequenceKeypoint.new(1, t1 or 0),
        })
    end
    g.Rotation = rot or 90
    return g
end

local function MkLabel(p, props)
    local l = Instance.new("TextLabel", p)
    l.BackgroundTransparency = 1
    l.TextColor3  = F.TextPri
    l.Font        = Enum.Font.GothamBold
    l.TextSize    = 13
    l.RichText    = false
    for k, v in pairs(props or {}) do l[k] = v end
    return l
end

local function MkFrame(p, props)
    local f = Instance.new("Frame", p)
    f.BackgroundColor3 = F.Mica1
    f.BorderSizePixel  = 0
    for k, v in pairs(props or {}) do f[k] = v end
    return f
end

-- Fluent Card: Mica2 bg + subtle border + corner
local function MkCard(parent, size, pos, radius, zindex)
    local f = MkFrame(parent, {
        Size = size, Position = pos,
        BackgroundColor3 = F.Mica2,
        ZIndex = zindex or 12,
    })
    Corner(f, radius or 12)
    MkStroke(f, F.Border, 1, 0.82)
    return f
end

-- Fluent Button
local function MkBtn(parent, size, pos, text, accent, zindex)
    accent = accent or F.Accent
    local b = Instance.new("TextButton", parent)
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = accent
    b.Text = text
    b.TextColor3 = F.White
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.ZIndex = zindex or 13
    b.BorderSizePixel = 0
    Corner(b, 8)

    -- Reveal highlight overlay
    local hl = Instance.new("Frame", b)
    hl.Size = UDim2.new(1,0,1,0)
    hl.BackgroundColor3 = F.White
    hl.BackgroundTransparency = 1
    hl.ZIndex = b.ZIndex + 1
    hl.BorderSizePixel = 0
    Corner(hl, 8)

    b.MouseEnter:Connect(function()
        TweenService:Create(b,   TweenInfo.new(0.15), {BackgroundColor3 = F.AccentHov}):Play()
        TweenService:Create(hl,  TweenInfo.new(0.15), {BackgroundTransparency = 0.88}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,   TweenInfo.new(0.15), {BackgroundColor3 = accent}):Play()
        TweenService:Create(hl,  TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    end)
    b.MouseButton1Down:Connect(function()
        TweenService:Create(b,   TweenInfo.new(0.08), {BackgroundColor3 = F.AccentPrs}):Play()
    end)
    b.MouseButton1Up:Connect(function()
        TweenService:Create(b,   TweenInfo.new(0.15), {BackgroundColor3 = F.AccentHov}):Play()
    end)
    return b
end

-- Fluent ghost/subtle button
local function MkGhostBtn(parent, size, pos, text, zindex)
    local b = Instance.new("TextButton", parent)
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = F.Mica3
    b.Text = text
    b.TextColor3 = F.TextSec
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.ZIndex = zindex or 13
    b.BorderSizePixel = 0
    Corner(b, 8)
    MkStroke(b, F.Border, 1, 0.85)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3=F.Mica4, TextColor3=F.TextPri}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3=F.Mica3, TextColor3=F.TextSec}):Play()
    end)
    b.MouseButton1Down:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=F.Mica2}):Play()
    end)
    b.MouseButton1Up:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3=F.Mica4}):Play()
    end)
    return b
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch
        or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = inp.Position; startPos = frame.Position
        end
    end)
    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch
        or inp.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = inp
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X,
                                        startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch
        or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function SmoothTeleport(cf)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp then return end
    if hum then hum.WalkSpeed = 0 end
    local origin = hrp.CFrame
    for i = 1, 10 do hrp.CFrame = origin:Lerp(cf, i/10); RunService.Heartbeat:Wait() end
    if hum then hum.WalkSpeed = _G.TM4_Speed or 16 end
end

local function FmtDist(d)
    return d>=1000 and string.format("%.1fk m",d/1000) or string.format("%.0f m",d)
end

-- ================================================================
-- FLUENT TOAST
-- ================================================================
local toastQ, toastBusy = {}, false
local function Toast(msg, color, icon)
    color = color or F.Success
    icon  = icon  or "●"
    table.insert(toastQ, {msg=msg, color=color, icon=icon})
    if toastBusy then return end
    toastBusy = true
    task.spawn(function()
        while #toastQ > 0 do
            local item = table.remove(toastQ, 1)
            local T = MkFrame(ScreenGui, {
                Size=UDim2.new(0,260,0,48),
                Position=UDim2.new(0.5,-130,1,70),
                BackgroundColor3=F.Mica2, ZIndex=99,
            })
            Corner(T, 12)
            MkStroke(T, item.color, 1.5, 0.3)

            -- Left accent bar
            local bar = MkFrame(T, {
                Size=UDim2.new(0,3,1,-16), Position=UDim2.new(0,0,0,8),
                BackgroundColor3=item.color, ZIndex=100,
            })
            Corner(bar, 2)

            MkLabel(T, {
                Size=UDim2.new(1,-18,1,0), Position=UDim2.new(0,14,0,0),
                Text=item.msg, TextSize=12, Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=100,
                TextColor3=F.TextPri,
            })

            -- Drop shadow illusion
            local sh = MkFrame(ScreenGui, {
                Size=UDim2.new(0,264,0,52),
                Position=UDim2.new(0.5,-132,1,68),
                BackgroundColor3=F.Black, ZIndex=98,
            })
            Corner(sh, 13)
            sh.BackgroundTransparency = 0.6

            local slideIn  = {Position=UDim2.new(0.5,-130,1,-68)}
            local slideInS = {Position=UDim2.new(0.5,-132,1,-70)}
            TweenService:Create(T,  TweenInfo.new(0.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out), slideIn):Play()
            TweenService:Create(sh, TweenInfo.new(0.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out), slideInS):Play()
            task.wait(2.2)
            local fadeOut = {Position=UDim2.new(0.5,-130,1,90), BackgroundTransparency=1}
            TweenService:Create(T,  TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In), fadeOut):Play()
            TweenService:Create(sh, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundTransparency=1}):Play()
            task.wait(0.3)
            T:Destroy(); sh:Destroy()
        end
        toastBusy = false
    end)
end

-- ================================================================
-- GLOBAL STATE
-- ================================================================
_G.TM4_Waypoints = _G.TM4_Waypoints or {}
_G.TM4_WPNames   = _G.TM4_WPNames   or {}
_G.TM4_WPCount   = _G.TM4_WPCount   or 0
_G.TM4_Speed     = _G.TM4_Speed     or 16
_G.TM4_Jump      = _G.TM4_Jump      or 50
_G.TM4_NoClip    = _G.TM4_NoClip    or false

-- ================================================================
-- TOGGLE BUTTON  (Fluent FAB style)
-- ================================================================
local FAB = Instance.new("TextButton", ScreenGui)
FAB.Name = "TM4_FAB"
FAB.Size = UDim2.new(0,52,0,52)
FAB.Position = UDim2.new(0.05,0,0.15,0)
FAB.BackgroundColor3 = F.Accent
FAB.Text = "📍"
FAB.TextSize = 22
FAB.TextColor3 = F.White
FAB.AutoButtonColor = false
FAB.ZIndex = 20
FAB.BorderSizePixel = 0
Corner(FAB, 26)

-- Fluent depth shadow
local FABShadow = MkFrame(ScreenGui, {
    Size=UDim2.new(0,56,0,56), Position=UDim2.new(0.05,-2,0.15,-2),
    BackgroundColor3=F.Accent, ZIndex=19,
})
Corner(FABShadow, 28)
FABShadow.BackgroundTransparency = 0.7

-- v4 chip
local Chip = MkLabel(FAB, {
    Size=UDim2.new(0,22,0,13), Position=UDim2.new(1,-6,0,-2),
    Text="v4", TextSize=8, Font=Enum.Font.GothamBold,
    BackgroundColor3=F.Warning, BackgroundTransparency=0,
    TextColor3=Color3.fromRGB(20,20,20), ZIndex=21,
})
Corner(Chip, 6)
Chip.BackgroundTransparency = 0

FAB.MouseEnter:Connect(function()
    TweenService:Create(FAB,       TweenInfo.new(0.2,Enum.EasingStyle.Quint), {BackgroundColor3=F.AccentHov}):Play()
    TweenService:Create(FABShadow, TweenInfo.new(0.2), {BackgroundTransparency=0.55}):Play()
end)
FAB.MouseLeave:Connect(function()
    TweenService:Create(FAB,       TweenInfo.new(0.2), {BackgroundColor3=F.Accent}):Play()
    TweenService:Create(FABShadow, TweenInfo.new(0.2), {BackgroundTransparency=0.7}):Play()
end)
MakeDraggable(FAB)

-- Sync shadow position with FAB drag
RunService.RenderStepped:Connect(function()
    FABShadow.Position = UDim2.new(
        FAB.Position.X.Scale, FAB.Position.X.Offset-2,
        FAB.Position.Y.Scale, FAB.Position.Y.Offset-2
    )
end)

-- ================================================================
-- MAIN WINDOW  (Mica Acrylic style)
-- ================================================================
-- Drop shadow frame
local Shadow = MkFrame(ScreenGui, {
    Size=UDim2.new(0,FW+20,0,FH+20),
    Position=UDim2.new(0.5,-(FW+20)/2,0.5,-(FH+20)/2),
    BackgroundColor3=F.Black, ZIndex=8, Visible=false,
})
Corner(Shadow, 22)
Shadow.BackgroundTransparency = 0.5
MkGrad(Shadow, F.Black, Color3.fromRGB(10,10,20), 160, 0.4, 0.6)

local Win = MkFrame(ScreenGui, {
    Size=UDim2.new(0,FW,0,FH),
    Position=UDim2.new(0.5,-FW/2,0.5,-FH/2),
    BackgroundColor3=F.Mica0, ZIndex=10, Visible=false,
})
Corner(Win, 16)
Win.ClipsDescendants = true

-- Acrylic noise overlay (simulated via gradient)
local Noise = MkFrame(Win, {Size=UDim2.new(1,0,1,0), ZIndex=10, BackgroundColor3=F.White})
Noise.BackgroundTransparency = 0.97
MkGrad(Noise, Color3.fromRGB(200,210,255), Color3.fromRGB(180,160,255), 45, 0.96, 0.94)

-- Subtle top-light (Fluent depth cue)
local TopLight = MkFrame(Win, {
    Size=UDim2.new(1,0,0,1), BackgroundColor3=F.White, ZIndex=11,
})
TopLight.BackgroundTransparency = 0.6

-- Window border (Fluent: 1px top-highlight + dark sides)
MkStroke(Win, F.Border, 1, 0.75)

-- ================================================================
-- TITLEBAR
-- ================================================================
local TitleBar = MkFrame(Win, {
    Size=UDim2.new(1,0,0,52),
    BackgroundColor3=F.Mica1, ZIndex=11,
})
-- Bottom separator
local TitleSep = MkFrame(TitleBar, {
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=F.BorderSub, ZIndex=12,
})

-- App icon circle
local IconCircle = MkFrame(TitleBar, {
    Size=UDim2.new(0,28,0,28), Position=UDim2.new(0,12,0.5,-14),
    BackgroundColor3=F.Accent, ZIndex=12,
})
Corner(IconCircle, 8)
MkGrad(IconCircle, F.Accent, F.Purple, 135)
MkLabel(IconCircle, {Size=UDim2.new(1,0,1,0),Text="📍",TextSize=14,ZIndex=13})

-- Title text
MkLabel(TitleBar, {
    Size=UDim2.new(0,120,0,18), Position=UDim2.new(0,48,0,8),
    Text="Teleport Menu", TextSize=13, Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=12,
})
MkLabel(TitleBar, {
    Size=UDim2.new(0,100,0,14), Position=UDim2.new(0,48,0,26),
    Text="v4  ·  Fluent Design", TextSize=10, Font=Enum.Font.Gotham,
    TextColor3=F.TextSec, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=12,
})

-- Waypoint count badge
local WPBadge = MkFrame(TitleBar, {
    Size=UDim2.new(0,30,0,20), Position=UDim2.new(0,168,0.5,-10),
    BackgroundColor3=F.Accent, ZIndex=12,
})
Corner(WPBadge, 10)
local WPBadgeLbl = MkLabel(WPBadge, {
    Size=UDim2.new(1,0,1,0), Text="0", TextSize=11,
    TextColor3=F.White, ZIndex=13,
})

local function UpdateBadge()
    local n=0; for _ in pairs(_G.TM4_Waypoints) do n+=1 end
    WPBadgeLbl.Text = tostring(n)
    TweenService:Create(WPBadge,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,36,0,24),Position=UDim2.new(0,165,0.5,-12)}):Play()
    task.delay(0.18,function()
        TweenService:Create(WPBadge,TweenInfo.new(0.15),
            {Size=UDim2.new(0,30,0,20),Position=UDim2.new(0,168,0.5,-10)}):Play()
    end)
end

-- Window control buttons (macOS-inspired circles on left, Windows close on right)
local function WinBtn(xOff, color, text, zi)
    local b = Instance.new("TextButton", TitleBar)
    b.Size = UDim2.new(0,28,0,28)
    b.Position = UDim2.new(1, xOff, 0.5, -14)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextSize = 11
    b.TextColor3 = F.White
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.ZIndex = zi or 12
    b.BorderSizePixel = 0
    Corner(b, 7)
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0.2}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play()
    end)
    return b
end

local BtnClose = WinBtn(-34,  F.Danger,  "✕", 12)
local BtnMin   = WinBtn(-68,  F.Warning, "—", 12)
BtnMin.TextColor3 = Color3.fromRGB(20,20,20)
local BtnPP    = WinBtn(-104, F.Mica3,   "👤", 12)

MakeDraggable(Win, TitleBar)

-- ================================================================
-- TAB BAR  (Fluent pivot)
-- ================================================================
local TABS = {"Home","Waypoints","Settings"}
local TABS_ICON = {"⌂","📍","⚙"}
local tabBtns, tabPages = {}, {}
local activeTab = 1

local TabBar = MkFrame(Win, {
    Size=UDim2.new(1,0,0,40),
    Position=UDim2.new(0,0,0,52),
    BackgroundColor3=F.Mica0, ZIndex=11,
})
local TabSep = MkFrame(TabBar, {
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=F.BorderSub, ZIndex=12,
})

for i, name in ipairs(TABS) do
    local b = Instance.new("TextButton", TabBar)
    b.Size = UDim2.new(1/#TABS, 0, 1, -4)
    b.Position = UDim2.new((i-1)/#TABS, 0, 0, 2)
    b.BackgroundTransparency = 1
    b.Text = TABS_ICON[i].."  "..name
    b.TextSize = 11
    b.TextColor3 = F.TextDis
    b.Font = Enum.Font.GothamBold
    b.ZIndex = 12
    b.BorderSizePixel = 0
    b.AutoButtonColor = false

    -- Active indicator (bottom pill)
    local ind = MkFrame(b, {
        Size=UDim2.new(0.5,0,0,2),
        Position=UDim2.new(0.25,0,1,-2),
        BackgroundColor3=F.Accent, ZIndex=13,
    })
    Corner(ind, 1)
    ind.BackgroundTransparency = 1

    b:SetAttribute("Ind", true)  -- marker
    b.MouseEnter:Connect(function()
        if activeTab ~= i then
            TweenService:Create(b,TweenInfo.new(0.15),{TextColor3=F.TextSec}):Play()
            TweenService:Create(b,TweenInfo.new(0.15),{BackgroundTransparency=0.95}):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if activeTab ~= i then
            TweenService:Create(b,TweenInfo.new(0.15),{TextColor3=F.TextDis}):Play()
            TweenService:Create(b,TweenInfo.new(0.15),{BackgroundTransparency=1}):Play()
        end
    end)
    tabBtns[i] = {btn=b, ind=ind}
end

-- Page container
local PageCont = MkFrame(Win, {
    Size=UDim2.new(1,0,1,-92),
    Position=UDim2.new(0,0,0,92),
    BackgroundTransparency=1, ZIndex=11,
})
PageCont.ClipsDescendants = true

local function NewPage()
    local p = MkFrame(PageCont, {
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, ZIndex=11, Visible=false,
    })
    return p
end

local function SetTab(i)
    for j, t in ipairs(tabBtns) do
        local active = (j==i)
        TweenService:Create(t.btn, TweenInfo.new(0.18),
            {TextColor3 = active and F.TextPri or F.TextDis,
             BackgroundTransparency = active and 0.9 or 1}):Play()
        TweenService:Create(t.ind, TweenInfo.new(0.2,Enum.EasingStyle.Quint),
            {BackgroundTransparency = active and 0 or 1}):Play()
        if tabPages[j] then tabPages[j].Visible = (j==i) end
    end
    activeTab = i
end

for i, t in ipairs(tabBtns) do
    t.btn.MouseButton1Click:Connect(function() SetTab(i) end)
end

-- ================================================================
-- PAGE 1 · HOME
-- ================================================================
local PgHome = NewPage(); tabPages[1] = PgHome

-- Profile bar
local ProfBar = MkCard(PgHome, UDim2.new(1,-16,0,36), UDim2.new(0,8,0,8), 10, 12)
ProfBar.BackgroundColor3 = F.Mica1
local ProfIcon = MkLabel(ProfBar, {
    Size=UDim2.new(0,20,1,0), Position=UDim2.new(0,10,0,0),
    Text="📁", TextSize=13, ZIndex=13,
})
local ProfLbl = MkLabel(ProfBar, {
    Size=UDim2.new(0,140,1,0), Position=UDim2.new(0,32,0,0),
    Text="Default", TextSize=12, TextColor3=F.TextSec,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=13,
})
local NewProfBtn = MkGhostBtn(ProfBar,
    UDim2.new(0,72,0,24), UDim2.new(1,-80,0.5,-12), "+ Profile", 13)

-- Save button (Fluent: full-width accent)
local SaveBtn = MkBtn(PgHome,
    UDim2.new(1,-16,0,44), UDim2.new(0,8,0,52),
    "💾   Save Current Position", F.Accent, 12)

-- Coord display
local CoordCard = MkCard(PgHome, UDim2.new(1,-16,0,30), UDim2.new(0,8,0,104), 8, 12)
CoordCard.BackgroundColor3 = F.Mica1
local CoordLbl = MkLabel(CoordCard, {
    Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,6,0,0),
    Text="  X: 0  ·  Y: 0  ·  Z: 0", TextSize=11,
    Font=Enum.Font.Gotham, TextColor3=F.TextSec,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=13,
})
task.spawn(function()
    while task.wait(0.35) do
        local ch = LocalPlayer.Character
        if ch then
            local h = ch:FindFirstChild("HumanoidRootPart")
            if h then
                local p = h.Position
                CoordLbl.Text = string.format("  X: %.0f  ·  Y: %.0f  ·  Z: %.0f",p.X,p.Y,p.Z)
            end
        end
    end
end)

-- Stats row (3 cards)
local function MkStatCard(parent, x, icon, val, color)
    local c = MkCard(parent, UDim2.new(0.31,0,1,0), UDim2.new(x,0,0,0), 10, 12)
    c.BackgroundColor3 = F.Mica1
    MkLabel(c, {Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,3),Text=icon,TextSize=15,ZIndex=13})
    local vl = MkLabel(c, {Size=UDim2.new(1,-4,0,14),Position=UDim2.new(0,2,1,-18),
        Text=val, TextSize=10, TextColor3=color, Font=Enum.Font.Gotham, ZIndex=13})
    MkStroke(c, color, 1, 0.7)
    return c, vl
end

local StatRow = MkFrame(PgHome, {
    Size=UDim2.new(1,-16,0,54),Position=UDim2.new(0,8,0,142),BackgroundTransparency=1,ZIndex=12,
})
local _,WPStat  = MkStatCard(StatRow, 0,      "📍","0 pts",   F.Accent)
local _,FmStat  = MkStatCard(StatRow, 0.345,  "🔄","Off",     F.Success)
local _,DstStat = MkStatCard(StatRow, 0.69,   "📏","-- m",    F.Warning)

-- AutoFarm row
local FarmCard = MkCard(PgHome, UDim2.new(1,-16,0,40), UDim2.new(0,8,0,204), 10, 12)
FarmCard.BackgroundColor3 = F.Mica1
local FarmBtn  = MkBtn(FarmCard, UDim2.new(0,118,0,28), UDim2.new(0,4,0.5,-14),
    "▶ Auto Farm", F.Success, 13)
local DlyM = MkGhostBtn(FarmCard, UDim2.new(0,28,0,28), UDim2.new(0,128,0.5,-14), "−", 13)
local DlyL = MkLabel(FarmCard, {
    Size=UDim2.new(0,50,1,0), Position=UDim2.new(0,160,0,0),
    Text="1.5 s", TextSize=11, Font=Enum.Font.Gotham, TextColor3=F.TextSec, ZIndex=13,
})
local DlyP = MkGhostBtn(FarmCard, UDim2.new(0,28,0,28), UDim2.new(0,214,0.5,-14), "+", 13)

-- Clear + Export + Import
local ClearBtn = MkBtn(PgHome, UDim2.new(1,-16,0,34), UDim2.new(0,8,0,252),
    "🗑   Clear All Waypoints", F.Danger, 12)

local BkRow = MkFrame(PgHome, {
    Size=UDim2.new(1,-16,0,34),Position=UDim2.new(0,8,0,294),BackgroundTransparency=1,ZIndex=12,
})
local ExportBtn = MkGhostBtn(BkRow, UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), "📤 Export JSON", 13)
local ImportBtn = MkGhostBtn(BkRow, UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), "📥 Import JSON", 13)

-- ================================================================
-- PAGE 2 · WAYPOINTS
-- ================================================================
local PgWP = NewPage(); tabPages[2] = PgWP

-- Search bar
local SearchCard = MkCard(PgWP, UDim2.new(1,-16,0,36), UDim2.new(0,8,0,8), 10, 12)
SearchCard.BackgroundColor3 = F.Mica1
local SearchIcon = MkLabel(SearchCard, {
    Size=UDim2.new(0,24,1,0), Position=UDim2.new(0,6,0,0),
    Text="🔍", TextSize=12, ZIndex=13,
})
local SBox = Instance.new("TextBox", SearchCard)
SBox.Size = UDim2.new(1,-36,1,0)
SBox.Position = UDim2.new(0,30,0,0)
SBox.BackgroundTransparency = 1
SBox.PlaceholderText = "Search waypoints..."
SBox.PlaceholderColor3 = F.TextDis
SBox.Text = ""
SBox.TextColor3 = F.TextPri
SBox.TextSize = 12
SBox.Font = Enum.Font.Gotham
SBox.ClearTextOnFocus = false
SBox.ZIndex = 13

-- Scroll list (FIX: AutomaticCanvasSize)
local WPScroll = Instance.new("ScrollingFrame", PgWP)
WPScroll.Size = UDim2.new(1,-16,1,-52)
WPScroll.Position = UDim2.new(0,8,0,52)
WPScroll.BackgroundTransparency = 1
WPScroll.BorderSizePixel = 0
WPScroll.CanvasSize = UDim2.new(0,0,0,0)
WPScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
WPScroll.ScrollBarThickness = 3
WPScroll.ScrollBarImageColor3 = F.Accent
WPScroll.ScrollBarImageTransparency = 0.4
WPScroll.ZIndex = 12

local WPLayout = Instance.new("UIListLayout", WPScroll)
WPLayout.SortOrder = Enum.SortOrder.LayoutOrder
WPLayout.Padding   = UDim.new(0,6)
local WPPad = Instance.new("UIPadding", WPScroll)
WPPad.PaddingTop = UDim.new(0,4)
WPPad.PaddingBottom = UDim.new(0,8)

-- Empty state label
local EmptyLbl = MkLabel(WPScroll, {
    Size=UDim2.new(1,0,0,60), Text="No waypoints yet\nPress F or Save to add one",
    TextSize=12, Font=Enum.Font.Gotham, TextColor3=F.TextDis,
    TextWrapped=true, ZIndex=13, LayoutOrder=9999,
})

local function RefreshEmpty()
    local n=0; for _ in pairs(_G.TM4_Waypoints) do n+=1 end
    EmptyLbl.Visible = (n==0)
end

-- ================================================================
-- PAGE 3 · SETTINGS
-- ================================================================
local PgSet = NewPage(); tabPages[3] = PgSet

local function MkSlider(parent, yOff, icon, label, minV, maxV, defV, onCh)
    local card = MkCard(parent, UDim2.new(1,-16,0,60), UDim2.new(0,8,0,yOff), 12, 12)
    card.BackgroundColor3 = F.Mica1

    local lbl = MkLabel(card, {
        Size=UDim2.new(1,-12,0,18), Position=UDim2.new(0,10,0,6),
        Text=icon.."  "..label.."   "..defV,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=13,
    })
    local track = MkFrame(card, {
        Size=UDim2.new(1,-20,0,6), Position=UDim2.new(0,10,0,34),
        BackgroundColor3=F.Mica3, ZIndex=13,
    })
    Corner(track, 3)

    local fill = MkFrame(track, {
        Size=UDim2.new((defV-minV)/(maxV-minV),0,1,0),
        BackgroundColor3=F.Accent, ZIndex=14,
    })
    Corner(fill, 3)
    MkGrad(fill, F.Accent, F.AccentLight, 90)

    local thumb = Instance.new("TextButton", track)
    thumb.Size = UDim2.new(0,14,0,14)
    thumb.Position = UDim2.new((defV-minV)/(maxV-minV),-7,0.5,-7)
    thumb.BackgroundColor3 = F.White
    thumb.Text = ""
    thumb.AutoButtonColor = false
    thumb.ZIndex = 15
    thumb.BorderSizePixel = 0
    Corner(thumb, 7)
    MkStroke(thumb, F.Accent, 1.5, 0.2)

    local drag = false
    thumb.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            drag=true
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            drag=false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local ax = track.AbsolutePosition.X
            local aw = track.AbsoluteSize.X
            local rx = math.clamp((inp.Position.X-ax)/aw, 0, 1)
            local val = math.round(minV + rx*(maxV-minV))
            fill.Size = UDim2.new(rx,0,1,0)
            thumb.Position = UDim2.new(rx,-7,0.5,-7)
            lbl.Text = icon.."  "..label.."   "..val
            if onCh then onCh(val) end
        end
    end)
    return card
end

MkSlider(PgSet, 8,   "🏃", "Walk Speed",  4, 100, 16, function(v) _G.TM4_Speed=v end)
MkSlider(PgSet, 78,  "⬆", "Jump Power",  4, 200, 50, function(v) _G.TM4_Jump =v end)

-- NoClip toggle card
local NcCard = MkCard(PgSet, UDim2.new(1,-16,0,48), UDim2.new(0,8,0,148), 12, 12)
NcCard.BackgroundColor3 = F.Mica1
MkLabel(NcCard, {
    Size=UDim2.new(1,-80,1,0), Position=UDim2.new(0,12,0,0),
    Text="👻  NoClip", TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=13,
})

-- Fluent toggle switch
local TogBg = MkFrame(NcCard, {
    Size=UDim2.new(0,44,0,24), Position=UDim2.new(1,-56,0.5,-12),
    BackgroundColor3=F.Mica3, ZIndex=13,
})
Corner(TogBg, 12)
MkStroke(TogBg, F.Border, 1, 0.7)
local TogThumb = MkFrame(TogBg, {
    Size=UDim2.new(0,18,0,18), Position=UDim2.new(0,3,0.5,-9),
    BackgroundColor3=F.TextSec, ZIndex=14,
})
Corner(TogThumb, 9)

local NcActive = false
local NcHit = Instance.new("TextButton", NcCard)
NcHit.Size = UDim2.new(1,0,1,0)
NcHit.BackgroundTransparency = 1
NcHit.Text = ""
NcHit.ZIndex = 15
NcHit.AutoButtonColor = false
NcHit.MouseButton1Click:Connect(function()
    NcActive = not NcActive
    _G.TM4_NoClip = NcActive
    if NcActive then
        TweenService:Create(TogBg,    TweenInfo.new(0.2), {BackgroundColor3=F.Accent}):Play()
        TweenService:Create(TogThumb, TweenInfo.new(0.2,Enum.EasingStyle.Quint),
            {Position=UDim2.new(1,-21,0.5,-9), BackgroundColor3=F.White}):Play()
        Toast("NoClip ON", F.Success)
    else
        TweenService:Create(TogBg,    TweenInfo.new(0.2), {BackgroundColor3=F.Mica3}):Play()
        TweenService:Create(TogThumb, TweenInfo.new(0.2,Enum.EasingStyle.Quint),
            {Position=UDim2.new(0,3,0.5,-9), BackgroundColor3=F.TextSec}):Play()
        Toast("NoClip OFF", F.Warning)
    end
end)

-- Hotkeys info card
local HkCard = MkCard(PgSet, UDim2.new(1,-16,0,70), UDim2.new(0,8,0,204), 12, 12)
HkCard.BackgroundColor3 = F.Mica1
MkLabel(HkCard, {
    Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,10,0,0),
    Text="⌨  H = Toggle Menu\n    F = Save Position\n    G = Nearest Waypoint",
    TextSize=11, Font=Enum.Font.Gotham, TextColor3=F.TextSec,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    TextWrapped=true, ZIndex=13,
})

-- NoClip & stat loop
RunService.Stepped:Connect(function()
    local ch = LocalPlayer.Character
    if not ch then return end
    local hum = ch:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = _G.TM4_Speed or 16
        hum.JumpPower = _G.TM4_Jump  or 50
    end
    if _G.TM4_NoClip then
        for _, p in ipairs(ch:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- ================================================================
-- PLAYER PANEL
-- ================================================================
local PP_W, PP_H = 220, 290
local PPWin = MkFrame(ScreenGui, {
    Size=UDim2.new(0,PP_W,0,PP_H),
    Position=UDim2.new(0.5,FW/2+16,0.5,-FH/2),
    BackgroundColor3=F.Mica0, Visible=false, ZIndex=15,
})
Corner(PPWin, 14)
PPWin.ClipsDescendants = true
MkStroke(PPWin, F.Border, 1, 0.75)

local PPTitle = MkFrame(PPWin, {
    Size=UDim2.new(1,0,0,44), BackgroundColor3=F.Mica1, ZIndex=16,
})
MkFrame(PPTitle, {
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=F.BorderSub, ZIndex=17,
})
MkLabel(PPTitle, {
    Size=UDim2.new(1,-40,1,0), Position=UDim2.new(0,12,0,0),
    Text="👥  Players", TextSize=13,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=17,
})
local PPCloseBtn = WinBtn(-8, F.Danger, "✕", 17)
PPCloseBtn.Parent = PPTitle
PPCloseBtn.Position = UDim2.new(1,-34,0.5,-14)
MakeDraggable(PPWin, PPTitle)

local PPScroll = Instance.new("ScrollingFrame", PPWin)
PPScroll.Size = UDim2.new(1,-12,1,-52)
PPScroll.Position = UDim2.new(0,6,0,48)
PPScroll.BackgroundTransparency = 1
PPScroll.BorderSizePixel = 0
PPScroll.CanvasSize = UDim2.new(0,0,0,0)
PPScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PPScroll.ScrollBarThickness = 3
PPScroll.ScrollBarImageColor3 = F.Purple
PPScroll.ZIndex = 16

local PPList = Instance.new("UIListLayout", PPScroll)
PPList.SortOrder = Enum.SortOrder.LayoutOrder
PPList.Padding   = UDim.new(0,5)
local PPPad2 = Instance.new("UIPadding", PPScroll)
PPPad2.PaddingTop = UDim.new(0,4)

local function RefreshPP()
    for _, c in ipairs(PPScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local plrs = Players:GetPlayers()
    for _, plr in ipairs(plrs) do
        if plr ~= LocalPlayer then
            local row = MkCard(PPScroll, UDim2.new(1,-4,0,44), UDim2.new(0,2,0,0), 10, 17)
            row.BackgroundColor3 = F.Mica2

            MkLabel(row, {
                Size=UDim2.new(1,-70,1,0), Position=UDim2.new(0,10,0,0),
                Text="🎮  "..plr.Name, TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=18,
            })

            local tb = MkBtn(row, UDim2.new(0,54,0,28), UDim2.new(1,-60,0.5,-14),
                "Tele", F.Purple, 18)
            tb.MouseButton1Click:Connect(function()
                local tgt = plr.Character
                if tgt then
                    local hrp2 = tgt:FindFirstChild("HumanoidRootPart")
                    if hrp2 then
                        SmoothTeleport(hrp2.CFrame+Vector3.new(3,0,0))
                        Toast("Teleported to "..plr.Name, F.Purple)
                    end
                end
            end)
        end
    end
end

-- ================================================================
-- WAYPOINT ITEM CREATOR
-- ================================================================
local function CreateWPItem(id, cf)
    EmptyLbl.Visible = false
    local row = MkCard(WPScroll, UDim2.new(1,-4,0,62), UDim2.new(0,2,0,0), 10, 13)
    row.Name = "WP_"..id
    row.LayoutOrder = id
    row.BackgroundColor3 = F.Mica2

    -- Left accent
    local acc = MkFrame(row, {
        Size=UDim2.new(0,3,0.7,0), Position=UDim2.new(0,0,0.15,0),
        BackgroundColor3=F.Accent, ZIndex=14,
    })
    Corner(acc, 2)
    MkGrad(acc, F.Accent, F.Purple, 90)

    -- Name textbox
    local NBox = Instance.new("TextBox", row)
    NBox.Size = UDim2.new(0,108,0,22)
    NBox.Position = UDim2.new(0,10,0,7)
    NBox.BackgroundColor3 = F.Mica3
    NBox.Text = _G.TM4_WPNames[id] or ("Point "..id)
    NBox.TextColor3 = F.TextPri
    NBox.PlaceholderText = "Name..."
    NBox.PlaceholderColor3 = F.TextDis
    NBox.TextSize = 12
    NBox.Font = Enum.Font.GothamBold
    NBox.ClearTextOnFocus = false
    NBox.ZIndex = 14
    NBox.BorderSizePixel = 0
    Corner(NBox, 6)
    MkStroke(NBox, F.Border, 1, 0.85)
    NBox.FocusLost:Connect(function() _G.TM4_WPNames[id] = NBox.Text end)

    -- Coord
    local p = cf.Position
    MkLabel(row, {
        Size=UDim2.new(0,108,0,14), Position=UDim2.new(0,10,1,-20),
        Text=string.format("%.0f · %.0f · %.0f",p.X,p.Y,p.Z),
        TextSize=9, Font=Enum.Font.Gotham, TextColor3=F.TextDis,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
    })

    -- Distance (realtime)
    local DLbl = MkLabel(row, {
        Size=UDim2.new(0,108,0,14), Position=UDim2.new(0,10,0,31),
        Text="📏  -- m", TextSize=10, Font=Enum.Font.Gotham,
        TextColor3=F.Info, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
    })

    -- Tele button
    local TBtn = MkBtn(row, UDim2.new(0,52,0,28), UDim2.new(1,-118,0.5,-14), "🚀", F.Accent, 14)
    -- Delete button
    local DBtn = MkGhostBtn(row, UDim2.new(0,52,0,28), UDim2.new(1,-60,0.5,-14), "🗑", 14)

    TBtn.MouseButton1Click:Connect(function()
        SmoothTeleport(cf)
        Toast("→ "..((_G.TM4_WPNames[id]) or "Point "..id), F.Accent)
    end)
    DBtn.MouseButton1Click:Connect(function()
        local name = _G.TM4_WPNames[id] or ("Point "..id)
        TweenService:Create(row, TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {BackgroundTransparency=1, Size=UDim2.new(1,-4,0,0)}):Play()
        task.delay(0.22, function()
            row:Destroy()
            _G.TM4_Waypoints[id] = nil
            _G.TM4_WPNames[id]   = nil
            UpdateBadge(); RefreshEmpty()
            Toast("Deleted: "..name, F.Warning)
        end)
    end)

    -- Slide-in
    row.Size = UDim2.new(1,-4,0,0)
    TweenService:Create(row, TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {Size=UDim2.new(1,-4,0,62)}):Play()

    -- Distance updater
    task.spawn(function()
        while row.Parent do
            local ch = LocalPlayer.Character
            if ch then
                local h = ch:FindFirstChild("HumanoidRootPart")
                if h then
                    local d = (h.Position-cf.Position).Magnitude
                    DLbl.Text = "📏  "..FmtDist(d)
                    DLbl.TextColor3 = d<20 and F.Success or (d<100 and F.Warning or F.Info)
                end
            end
            task.wait(0.5)
        end
    end)
end

-- ================================================================
-- SAVE LOGIC
-- ================================================================
local function DoSave()
    local ch = LocalPlayer.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    _G.TM4_WPCount += 1
    local id = _G.TM4_WPCount
    local cf = hrp.CFrame
    _G.TM4_Waypoints[id] = cf
    _G.TM4_WPNames[id]   = "Point "..id
    CreateWPItem(id, cf)
    UpdateBadge(); RefreshEmpty()
    WPStat.Text = id.." pts"
    Toast("Saved Point "..id, F.Success)
end

SaveBtn.MouseButton1Click:Connect(DoSave)

ClearBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(WPScroll:GetChildren()) do
        if c:IsA("Frame") and c.Name ~= "EmptyLbl" then c:Destroy() end
    end
    _G.TM4_Waypoints={}; _G.TM4_WPNames={}; _G.TM4_WPCount=0
    UpdateBadge(); RefreshEmpty(); WPStat.Text="0 pts"
    Toast("All waypoints cleared", F.Danger)
end)

-- Search debounce
local srchDeb
SBox:GetPropertyChangedSignal("Text"):Connect(function()
    if srchDeb then task.cancel(srchDeb) end
    srchDeb = task.delay(0.12, function()
        local q = SBox.Text:lower()
        for _, c in ipairs(WPScroll:GetChildren()) do
            if c:IsA("Frame") then
                local id = tonumber(c.Name:sub(4))
                if id then
                    local nm = (_G.TM4_WPNames[id] or ""):lower()
                    c.Visible = (q=="" or nm:find(q,1,true)~=nil)
                end
            end
        end
    end)
end)

-- Auto Farm
local farmOn, farmThr = false, nil
local DELAY = 1.5

DlyM.MouseButton1Click:Connect(function()
    DELAY=math.max(0.3,DELAY-0.5); DlyL.Text=string.format("%.1f s",DELAY)
end)
DlyP.MouseButton1Click:Connect(function()
    DELAY=DELAY+0.5; DlyL.Text=string.format("%.1f s",DELAY)
end)

FarmBtn.MouseButton1Click:Connect(function()
    if farmOn then
        farmOn=false
        if farmThr then task.cancel(farmThr) end
        FarmBtn.Text="▶ Auto Farm"
        TweenService:Create(FarmBtn,TweenInfo.new(0.15),{BackgroundColor3=F.Success}):Play()
        FmStat.Text="Off"; Toast("Auto Farm stopped",F.Warning)
    else
        local ids={}
        for id,cf in pairs(_G.TM4_Waypoints) do if cf then table.insert(ids,id) end end
        if #ids==0 then Toast("No waypoints!",F.Danger) return end
        table.sort(ids)
        farmOn=true
        FarmBtn.Text="⏹ Stop Farm"
        TweenService:Create(FarmBtn,TweenInfo.new(0.15),{BackgroundColor3=F.Danger}):Play()
        FmStat.Text="ON"
        Toast("Auto Farm started ("..#ids.." pts)",F.Success)
        farmThr=task.spawn(function()
            local i=1
            while farmOn do
                local id=ids[i]
                if _G.TM4_Waypoints[id] then SmoothTeleport(_G.TM4_Waypoints[id]); task.wait(DELAY) end
                i=i%#ids+1
            end
        end)
    end
end)

-- Export / Import
ExportBtn.MouseButton1Click:Connect(function()
    local t={}
    for id,cf in pairs(_G.TM4_Waypoints) do
        local p=cf.Position
        table.insert(t,string.format('{"id":%d,"name":"%s","x":%.2f,"y":%.2f,"z":%.2f}',
            id,_G.TM4_WPNames[id] or "Point "..id,p.X,p.Y,p.Z))
    end
    local json="["..table.concat(t,",").."]"
    local tb=Instance.new("TextBox",ScreenGui)
    tb.Size=UDim2.new(0,1,0,1); tb.Position=UDim2.new(0,-10,0,-10)
    tb.Text=json; tb.BackgroundTransparency=1; tb.ZIndex=1
    tb:CaptureFocus()
    task.delay(0.1,function() tb:ReleaseFocus(); tb:Destroy() end)
    Toast("JSON copied to clipboard!",F.Info)
end)

ImportBtn.MouseButton1Click:Connect(function()
    Toast("Paste JSON into search bar then Enter",F.Warning)
    SBox.PlaceholderText="📥 Paste JSON here..."
    SBox:CaptureFocus()
    local conn
    conn=SBox.FocusLost:Connect(function(enter)
        if enter then
            local raw=SBox.Text; SBox.Text=""; SBox.PlaceholderText="Search waypoints..."
            local ok=pcall(function()
                for item in raw:gmatch("{(.-)}") do
                    local id=tonumber(item:match('"id":(%d+)'))
                    local nm=item:match('"name":"([^"]+)"')
                    local x=tonumber(item:match('"x":(%-?[%d%.]+)'))
                    local y=tonumber(item:match('"y":(%-?[%d%.]+)'))
                    local z=tonumber(item:match('"z":(%-?[%d%.]+)'))
                    if id and x and y and z then
                        _G.TM4_WPCount=math.max(_G.TM4_WPCount,id)
                        local cf=CFrame.new(x,y,z)
                        _G.TM4_Waypoints[id]=cf; _G.TM4_WPNames[id]=nm or ("Point "..id)
                        CreateWPItem(id,cf)
                    end
                end
            end)
            UpdateBadge(); RefreshEmpty()
            Toast(ok and "Import successful!" or "Invalid JSON!",ok and F.Success or F.Danger)
        end
        conn:Disconnect()
    end)
end)

-- Profile
local profiles={Default={wp={},nm={},cnt=0}}
local curProf="Default"

NewProfBtn.MouseButton1Click:Connect(function()
    profiles[curProf]={wp=_G.TM4_Waypoints,nm=_G.TM4_WPNames,cnt=_G.TM4_WPCount}
    local nm="Profile "..tostring(#profiles+1)
    profiles[nm]={wp={},nm={},cnt=0}; curProf=nm
    _G.TM4_Waypoints={}; _G.TM4_WPNames={}; _G.TM4_WPCount=0
    for _,c in ipairs(WPScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    ProfLbl.Text=nm; UpdateBadge(); RefreshEmpty()
    Toast("New profile: "..nm,F.Info)
end)

-- Nearest dist stat updater
task.spawn(function()
    while task.wait(0.6) do
        local ch=LocalPlayer.Character
        if ch then
            local h=ch:FindFirstChild("HumanoidRootPart")
            if h then
                local near=math.huge
                for _,cf in pairs(_G.TM4_Waypoints) do
                    if cf then local d=(h.Position-cf.Position).Magnitude; if d<near then near=d end end
                end
                DstStat.Text = near==math.huge and "-- m" or FmtDist(near)
            end
        end
    end
end)

-- ================================================================
-- OPEN / CLOSE ANIMATION
-- ================================================================
local menuOpen=false
local twO=TweenInfo.new(0.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
local twC=TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In)

local function OpenMenu()
    menuOpen=true
    Win.Visible=true; Shadow.Visible=true
    Win.Size=UDim2.new(0,FW*0.8,0,FH*0.8)
    Win.Position=UDim2.new(0.5,-FW/2,0.5,-FH/2)
    Win.BackgroundTransparency=0.4
    Shadow.BackgroundTransparency=0.8
    TweenService:Create(Win,twO,{Size=UDim2.new(0,FW,0,FH),BackgroundTransparency=0}):Play()
    TweenService:Create(Shadow,twO,{Size=UDim2.new(0,FW+20,0,FH+20),BackgroundTransparency=0.5}):Play()
end

local function CloseMenu()
    menuOpen=false
    PPWin.Visible=false
    TweenService:Create(Win,twC,{Size=UDim2.new(0,FW*0.8,0,FH*0.8),BackgroundTransparency=1}):Play()
    TweenService:Create(Shadow,twC,{BackgroundTransparency=1}):Play()
    task.delay(0.24,function() Win.Visible=false; Shadow.Visible=false end)
end

FAB.MouseButton1Click:Connect(function()
    if menuOpen then CloseMenu() else OpenMenu() end
end)
BtnClose.MouseButton1Click:Connect(CloseMenu)

local minned=false
BtnMin.MouseButton1Click:Connect(function()
    minned=not minned
    PageCont.Visible=not minned; TabBar.Visible=not minned
    local th=minned and 52 or FH
    TweenService:Create(Win,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,FW,0,th)}):Play()
    TweenService:Create(Shadow,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,FW+20,0,th+20)}):Play()
    BtnMin.Text=minned and "▲" or "—"
end)

BtnPP.MouseButton1Click:Connect(function()
    PPWin.Visible=not PPWin.Visible
    if PPWin.Visible then RefreshPP() end
end)
PPCloseBtn.MouseButton1Click:Connect(function() PPWin.Visible=false end)

-- ================================================================
-- HOTKEYS
-- ================================================================
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.KeyCode==Enum.KeyCode.H then
        if menuOpen then CloseMenu() else OpenMenu() end
    elseif inp.KeyCode==Enum.KeyCode.F then
        DoSave()
    elseif inp.KeyCode==Enum.KeyCode.G then
        local ch=LocalPlayer.Character
        if not ch then return end
        local hrp=ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local near,nearCF=math.huge,nil
        for id,cf in pairs(_G.TM4_Waypoints) do
            if cf then
                local d=(cf.Position-hrp.Position).Magnitude
                if d<near then near=d; nearCF={id=id,cf=cf} end
            end
        end
        if nearCF then
            SmoothTeleport(nearCF.cf)
            Toast("[G] Đã dịch chuyển tới "..((_G.TM4_WPNames[nearCF.id]) or "Point "..nearCF.id), F.Accent)
        else
            Toast("No waypoints!", F.Danger)
        end
    end
end)

SetTab(1)
RefreshEmpty()
Toast("✅  Teleport v4 · Fluent Design", F.Accent)
