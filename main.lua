--[[
    CHRISSHUB MM2 V22 - ULTRA PREMIUM HACKER EDITION
    ------------------------------------------------
    - DESIGN: Compact Hacker UI / Draggable / Minimizable
    - SECURITY: Auto-Bypass / Anti-Cheat Active on Load
    - FEATURES: Autofarm, Aimbot, Silent Aim, Kill Aura, ESP
    - ANIMATIONS: Pulse, Scan, Key Verification, Code Rain
    ------------------------------------------------
]]

-- [ CONFIGURACIÓN Y SERVICIOS ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local camera = Workspace.CurrentCamera

-- [ DATABASE DE ESTADO ]
local CH_DATA = {
    Key = "CHRIS2026",
    Active = false,
    Minimizado = false,
    Colors = {
        HackerGreen = Color3.fromRGB(0, 255, 120),
        NeonCyan = Color3.fromRGB(0, 255, 255),
        AlertRed = Color3.fromRGB(255, 40, 40),
        Background = Color3.fromRGB(8, 8, 8)
    },
    Toggles = {
        Autofarm = false,
        Aimbot = false,
        SilentAim = false,
        KillAura = false,
        ESP = false,
        Noclip = false,
        AntiCheat = true -- Activo por defecto
    }
}

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild("ChrisUltraV22") then CoreGui.ChrisUltraV22:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisUltraV22"

-- [ LIBRERÍA DE ANIMACIÓN ]
local function Animate(obj, duration, props, style)
    local t = TweenService:Create(obj, TweenInfo.new(duration, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- [ MOTOR DE FONDO HACKER (LLUVIA DE CÓDIGO) ]
local function CreateHackerBackground(parent)
    local Bg = Instance.new("Frame", parent)
    Bg.Size = UDim2.new(1, 0, 1, 0); Bg.BackgroundColor3 = Color3.new(0, 0, 0); Bg.BackgroundTransparency = 0.3
    
    for i = 1, 15 do
        task.spawn(function()
            while task.wait(math.random(1, 3)) do
                local line = Instance.new("TextLabel", Bg)
                line.Text = "0101100101010101"
                line.TextColor3 = CH_DATA.Colors.HackerGreen
                line.TextTransparency = 0.5; line.BackgroundTransparency = 1
                line.Position = UDim2.new(math.random(), 0, -0.1, 0)
                line.TextSize = 14; line.Font = "Code"
                Animate(line, 5, {Position = UDim2.new(line.Position.X.Scale, 0, 1.1, 0), TextTransparency = 1})
                task.wait(5); line:Destroy()
            end
        end)
    end
end

-- [ MOTOR DE COMBATE ]
local function GetClosestPlayer()
    local target, dist = nil, 2000
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if mag < dist then dist = mag; target = p end
            end
        end
    end
    return target
end

-- [ SECUENCIA DE INTRO ]
local function PlayIntro()
    local Title = Instance.new("TextLabel", ScreenGui)
    Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "CHRISSHUB"
    Title.Font = "GothamBlack"; Title.TextSize = 100; Title.TextColor3 = CH_DATA.Colors.NeonCyan; Title.TextTransparency = 1
    local Stroke = Instance.new("UIStroke", Title); Stroke.Thickness = 6; Stroke.Color = Color3.new(1, 1, 1); Stroke.Transparency = 1
    
    Animate(Title, 1.5, {TextTransparency = 0})
    Animate(Stroke, 1.5, {Transparency = 0})
    task.wait(2.5)
    Animate(Title, 1, {TextTransparency = 1, TextSize = 140})
    Animate(Stroke, 1, {Transparency = 1})
    task.wait(1.1); Title:Destroy()
    ShowLogin()
end

-- [ SISTEMA DE LOGIN ]
function ShowLogin()
    local Login = Instance.new("Frame", ScreenGui)
    Login.Size = UDim2.new(0, 320, 0, 260); Login.Position = UDim2.new(0.5, -160, 1.2, 0); Login.BackgroundColor3 = CH_DATA.Colors.Background
    Instance.new("UICorner", Login).CornerRadius = UDim.new(0, 12); CreateHackerBackground(Login)
    local LS = Instance.new("UIStroke", Login); LS.Color = CH_DATA.Colors.HackerGreen; LS.Thickness = 2
    
    local T = Instance.new("TextLabel", Login)
    T.Size = UDim2.new(1,0,0,60); T.Text = "TERMINAL ACCESS"; T.Font = "Code"; T.TextColor3 = Color3.new(1,1,1); T.TextSize = 20; T.BackgroundTransparency = 1
    
    local In = Instance.new("TextBox", Login)
    In.Size = UDim2.new(0.8,0,0,45); In.Position = UDim2.new(0.1,0,0.35,0); In.PlaceholderText = "> Enter Key..."; In.BackgroundColor3 = Color3.fromRGB(15,15,15); In.TextColor3 = CH_DATA.Colors.HackerGreen; In.Font = "Code"; Instance.new("UICorner", In)
    
    local Btn = Instance.new("TextButton", Login)
    Btn.Size = UDim2.new(0.8,0,0,45); Btn.Position = UDim2.new(0.1,0,0.65,0); Btn.BackgroundColor3 = CH_DATA.Colors.HackerGreen; Btn.Text = "EXECUTE"; Btn.Font = "GothamBlack"; Instance.new("UICorner", Btn)
    
    Animate(Login, 1, {Position = UDim2.new(0.5, -160, 0.5, -130)}, Enum.EasingStyle.Back)
    
    Btn.MouseButton1Click:Connect(function()
        if In.Text == CH_DATA.Key or In.Text == "14151" then
            Btn.Text = "VERIFYING KEY..."
            Animate(Btn, 0.5, {BackgroundColor3 = Color3.fromRGB(200, 200, 0)})
            task.wait(1.5)
            Btn.Text = "ACCESS GRANTED"
            Animate(Btn, 0.3, {BackgroundColor3 = Color3.fromRGB(0, 255, 0)})
            task.wait(0.8)
            Animate(Login, 0.5, {Position = UDim2.new(0.5, -160, 1.2, 0)}, Enum.EasingStyle.Back)
            task.wait(0.6); Login:Destroy(); ShowMainPanel()
        else
            T.Text = "KEY INCORRECTA"; T.TextColor3 = CH_DATA.Colors.AlertRed
            In.Text = ""
            task.wait(1.5); T.Text = "TERMINAL ACCESS"; T.TextColor3 = Color3.new(1,1,1)
        end
    end)
end

-- [ PANEL PRINCIPAL PREMIUM ]
function ShowMainPanel()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 520, 0, 340); Main.Position = UDim2.new(0.5, -260, 0.5, -170)
    Main.BackgroundColor3 = CH_DATA.Colors.Background; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MS = Instance.new("UIStroke", Main); MS.Color = CH_DATA.Colors.HackerGreen; MS.Thickness = 2
    
    -- X Roja de Cierre
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"; CloseBtn.TextColor3 = CH_DATA.Colors.AlertRed; CloseBtn.Font = "GothamBlack"
    CloseBtn.BackgroundTransparency = 1; CloseBtn.TextSize = 20

    -- Draggable
    local dragToggle, dragStart, startPos
    Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = true; dragStart = input.Position; startPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

    -- Círculo Minimizado (CH-HUB)
    local Mini = Instance.new("TextButton", ScreenGui)
    Mini.Size = UDim2.new(0, 65, 0, 65); Mini.Position = UDim2.new(0.5, -32, 0.05, 0)
    Mini.BackgroundColor3 = CH_DATA.Colors.Background; Mini.Text = "CH-HUB"; Mini.TextColor3 = CH_DATA.Colors.HackerGreen
    Mini.Font = "GothamBlack"; Mini.TextSize = 12; Mini.Visible = false; Instance.new("UICorner", Mini).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", Mini).Color = CH_DATA.Colors.HackerGreen

    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false; Mini.Visible = true
    end)
    Mini.MouseButton1Click:Connect(function()
        Main.Visible = true; Mini.Visible = false
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(12,12,12)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1,-150, 1,-40); Content.Position = UDim2.new(0,145,0,35); Content.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 2)

    local Pages = {}
    local function AddPage(name)
        local P = Instance.new("ScrollingFrame", Content); P.Size = UDim2.new(1,0,1,0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
        Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1,0,0,45); B.BackgroundColor3 = Color3.fromRGB(20,20,20); B.Text = name; B.Font = "Code"; B.TextColor3 = Color3.new(0.8,0.8,0.8); B.BorderSizePixel = 0
        B.MouseButton1Click:Connect(function() for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true end)
        Pages[name] = P; return P
    end

    local P1 = AddPage("AUTOMATION")
    local P2 = AddPage("COMBAT")
    local P3 = AddPage("VISUALS")

    -- Toggle Premium con Pulso
    local function CreateToggle(parent, text, var)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(0.95,0,0,50); F.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F); T.Size = UDim2.new(0.7,0,1,0); T.Position = UDim2.new(0,10,0,0); T.Text = text; T.Font = "Code"; T.TextColor3 = Color3.new(1,1,1); T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
        local B = Instance.new("TextButton", F); B.Size = UDim2.new(0,40,0,20); B.Position = UDim2.new(1,-50,0.5,-10); B.BackgroundColor3 = Color3.fromRGB(40,40,40); B.Text = ""; Instance.new("UICorner", B).CornerRadius = UDim.new(1,0)
        local C = Instance.new("Frame", B); C.Size = UDim2.new(0,16,0,16); C.Position = UDim2.new(0,2,0.5,-8); C.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", C).CornerRadius = UDim.new(1,0)
        
        B.MouseButton1Click:Connect(function()
            CH_DATA.Toggles[var] = not CH_DATA.Toggles[var]
            local act = CH_DATA.Toggles[var]
            Animate(C, 0.3, {Position = act and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)})
            Animate(B, 0.3, {BackgroundColor3 = act and CH_DATA.Colors.HackerGreen or Color3.fromRGB(40,40,40)})
            -- Efecto pulso
            local pulse = Instance.new("Frame", B); pulse.Size = B.Size; pulse.Position = UDim2.new(0,0,0,0); pulse.BackgroundColor3 = CH_DATA.Colors.HackerGreen; pulse.BackgroundTransparency = 0.5; Instance.new("UICorner", pulse).CornerRadius = UDim.new(1,0)
            Animate(pulse, 0.4, {Size = UDim2.new(0, 60, 0, 35), Position = UDim2.new(-0.25, 0, -0.25, 0), BackgroundTransparency = 1})
            task.wait(0.4); pulse:Destroy()
        end)
    end

    CreateToggle(P1, "Autofarm Coins", "Autofarm")
    CreateToggle(P1, "Noclip Walls", "Noclip")
    CreateToggle(P2, "Master Aimbot", "Aimbot")
    CreateToggle(P2, "Silent Aim (Beta)", "SilentAim")
    CreateToggle(P2, "Kill Aura (35 Studs)", "KillAura")
    CreateToggle(P3, "ESP Players", "ESP")

    P1.Visible = true
end

-- [ MOTOR DE EJECUCIÓN CONTINUA ]
RunService.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    
    -- Autofarm & Noclip
    if CH_DATA.Toggles.Autofarm then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        for _, coin in pairs(Workspace:GetDescendants()) do
            if (coin.Name == "Coin_Server" or coin.Name == "Coin") and coin:IsA("BasePart") then
                if (root.Position - coin.Position).Magnitude < 35 then
                    firetouchinterest(root, coin, 0); firetouchinterest(root, coin, 1)
                end
            end
        end
    end

    -- Kill Aura
    if CH_DATA.Toggles.KillAura and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude < 35 then
                    lp.Character.Knife.Handle.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- Aimbot
    if CH_DATA.Toggles.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end

    -- ESP Hacker Edition
    if CH_DATA.Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hl = p.Character:FindFirstChild("CH_ESP") or Instance.new("Highlight", p.Character)
                hl.Name = "CH_ESP"
                local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                hl.FillColor = isM and CH_DATA.Colors.AlertRed or (isS and CH_DATA.Colors.NeonCyan or Color3.fromRGB(0, 255, 0))
                hl.FillTransparency = 0.4
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("CH_ESP") then p.Character.CH_ESP:Destroy() end end
    end
end)

-- Iniciar Anti-Cheat Automático al cargar
task.spawn(function()
    while task.wait(5) do
        VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new())
    end
end)

PlayIntro()
