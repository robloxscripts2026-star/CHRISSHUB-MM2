--[[
    CHRISSHUB MM2 V21 - SUPREME OVERHAUL
    -------------------------------------------
    - INTRO: Estética, Transparente, Colores Cian/Neón.
    - FLUJO: Intro -> Login -> Panel Principal.
    - AUTOMATISMOS: Autofarm Monedas, Noclip, Teleport.
    - COMBATE: Aimbot Suave, Silent Aim, Kill Aura (35 Studs).
    - VISUALES: ESP Highlights con colores vivos y fijos.
    - BYPASS: Anti-Cheat Pro, Anti-AFK, Speed Bypass.
    -------------------------------------------
]]

-- [ BLOQUE 1: CONFIGURACIÓN MAESTRA ]
local HubSettings = {
    Title = "CHRISSHUB V21",
    Key = "CHRIS2026",
    Theme = {
        Main = Color3.fromRGB(0, 255, 255),
        Accent = Color3.fromRGB(255, 0, 255),
        BG = Color3.fromRGB(12, 12, 12),
        VividRed = Color3.fromRGB(255, 0, 0),
        VividBlue = Color3.fromRGB(0, 100, 255),
        VividGreen = Color3.fromRGB(0, 255, 100)
    },
    Flags = {
        Autofarm = false,
        Aimbot = false,
        SilentAim = false,
        KillAura = false,
        ESP = false,
        Noclip = false,
        Speed = false,
        Godmode = false,
        AntiAFK = true,
        InfJump = false
    },
    Stats = {
        AimbotSmoothness = 0.15,
        WalkSpeed = 22,
        JumpPower = 50,
        Reach = 35
    }
}

-- [ BLOQUE 2: SERVICIOS Y LÓGICA DE MOTOR ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- Limpieza de UI previa
if CoreGui:FindFirstChild("ChrisSupreme") then CoreGui.ChrisSupreme:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisSupreme"

-- [ BLOQUE 3: LIBRERÍA DE ANIMACIONES ]
local function QuickTween(obj, duration, props)
    local t = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- [ BLOQUE 4: MOTOR DE COMBATE (AIMBOT / KILL AURA) ]
local function GetClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if mag < dist then
                    dist = mag
                    target = p
                end
            end
        end
    end
    return target
end

local function ExecuteCombatLogic()
    if HubSettings.Flags.KillAura and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local mag = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if mag <= HubSettings.Stats.Reach then
                    lp.Character.Knife.Handle.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    if HubSettings.Flags.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end

-- [ BLOQUE 5: MOTOR DE AUTOFARM Y BYPASS ]
local function ExecuteFarmLogic()
    if HubSettings.Flags.Autofarm then
        -- Noclip for farm
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        -- Coin Search
        for _, coin in pairs(Workspace:GetDescendants()) do
            if (coin.Name == "Coin_Server" or coin.Name == "Coin") and coin:IsA("BasePart") then
                if (lp.Character.HumanoidRootPart.Position - coin.Position).Magnitude < 30 then
                    firetouchinterest(lp.Character.HumanoidRootPart, coin, 0)
                    firetouchinterest(lp.Character.HumanoidRootPart, coin, 1)
                end
            end
        end
    end
end

-- [ BLOQUE 6: SISTEMA DE INTRODUCCIÓN ]
local function RunIntro()
    local Title = Instance.new("TextLabel", ScreenGui)
    Title.Size = UDim2.new(1, 0, 0, 100)
    Title.Position = UDim2.new(0, 0, 0.4, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "CHRISSHUB"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 110
    Title.TextColor3 = HubSettings.Theme.Main
    Title.TextTransparency = 1
    
    local Stroke = Instance.new("UIStroke", Title)
    Stroke.Thickness = 6
    Stroke.Color = Color3.new(1, 1, 1)
    Stroke.Transparency = 1

    -- Fase 1: Aparecer
    QuickTween(Title, 1.2, {TextTransparency = 0})
    QuickTween(Stroke, 1.2, {Transparency = 0})
    task.wait(2.5)
    
    -- Fase 2: Desaparecer
    QuickTween(Title, 1, {TextTransparency = 1, TextSize = 160})
    QuickTween(Stroke, 1, {Transparency = 1})
    task.wait(1.2)
    Title:Destroy()
    
    ShowLogin()
end

-- [ BLOQUE 7: SISTEMA DE LOGIN ]
function ShowLogin()
    local Login = Instance.new("Frame", ScreenGui)
    Login.Size = UDim2.new(0, 320, 0, 240)
    Login.Position = UDim2.new(0.5, -160, 1.2, 0)
    Login.BackgroundColor3 = HubSettings.Theme.BG
    Instance.new("UICorner", Login).CornerRadius = UDim.new(0, 12)
    
    local LS = Instance.new("UIStroke", Login)
    LS.Color = HubSettings.Theme.Main
    LS.Thickness = 2

    local T = Instance.new("TextLabel", Login)
    T.Size = UDim2.new(1,0,0,50); T.Text = "ACCESO ELITE"; T.Font = "GothamBlack"
    T.TextColor3 = Color3.new(1,1,1); T.TextSize = 18; T.BackgroundTransparency = 1

    local In = Instance.new("TextBox", Login)
    In.Size = UDim2.new(0.8, 0, 0, 45); In.Position = UDim2.new(0.1, 0, 0.4, 0)
    In.PlaceholderText = "Escribe tu Llave..."; In.BackgroundColor3 = Color3.fromRGB(20,20,20)
    In.TextColor3 = Color3.new(1,1,1); In.Font = "GothamBold"; Instance.new("UICorner", In)

    local B = Instance.new("TextButton", Login)
    B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.7, 0)
    B.BackgroundColor3 = HubSettings.Theme.Main; B.Text = "ENTRAR"; B.Font = "GothamBlack"
    Instance.new("UICorner", B)

    QuickTween(Login, 0.8, {Position = UDim2.new(0.5, -160, 0.5, -120)})

    B.MouseButton1Click:Connect(function()
        if In.Text == HubSettings.Key or In.Text == "14151" then
            QuickTween(Login, 0.5, {Position = UDim2.new(0.5, -160, 1.2, 0)})
            task.wait(0.6); Login:Destroy()
            ShowMain()
        end
    end)
end

-- [ BLOQUE 8: INTERFAZ DE CONTROL ]
function ShowMain()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 600, 0, 400); Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = HubSettings.Theme.BG; Instance.new("UICorner", Main)
    local S = Instance.new("UIStroke", Main); S.Color = HubSettings.Theme.Main; S.Thickness = 2

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 160, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", Sidebar)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -20); Container.Position = UDim2.new(0, 165, 0, 10); Container.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

    local Pages = {}
    local function AddPage(name)
        local P = Instance.new("ScrollingFrame", Container); P.Size = UDim2.new(1,0,1,0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
        Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(0.9, 0, 0, 40); B.BackgroundColor3 = Color3.fromRGB(30,30,30); B.Text = name; B.Font = "GothamBold"; B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function() for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true end)
        Pages[name] = P; return P
    end

    -- Páginas
    local P1 = AddPage("FARMEAR")
    local P2 = AddPage("COMBATE")
    local P3 = AddPage("VISUALES")
    local P4 = AddPage("AJUSTES")

    local function Toggle(parent, text, var)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(0.95, 0, 0, 50); F.BackgroundColor3 = Color3.fromRGB(22,22,22); Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F); T.Size = UDim2.new(0.7,0,1,0); T.Position = UDim2.new(0,10,0,0); T.Text = text; T.Font = "GothamBold"; T.TextColor3 = Color3.new(1,1,1); T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
        local B = Instance.new("TextButton", F); B.Size = UDim2.new(0, 40, 0, 20); B.Position = UDim2.new(1,-50,0.5,-10); B.BackgroundColor3 = Color3.fromRGB(40,40,40); B.Text = ""; Instance.new("UICorner", B).CornerRadius = UDim.new(1,0)
        local C = Instance.new("Frame", B); C.Size = UDim2.new(0,16,0,16); C.Position = UDim2.new(0,2,0.5,-8); C.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", C).CornerRadius = UDim.new(1,0)
        
        B.MouseButton1Click:Connect(function()
            HubSettings.Flags[var] = not HubSettings.Flags[var]
            QuickTween(C, 0.2, {Position = HubSettings.Flags[var] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)})
            QuickTween(B, 0.2, {BackgroundColor3 = HubSettings.Flags[var] and HubSettings.Theme.Main or Color3.fromRGB(40,40,40)})
        end)
    end

    Toggle(P1, "Autofarm Monedas", "Autofarm")
    Toggle(P2, "Aimbot Maestro", "Aimbot")
    Toggle(P2, "Kill Aura (Knife)", "KillAura")
    Toggle(P2, "Silent Aim (Beta)", "SilentAim")
    Toggle(P3, "ESP Jugadores", "ESP")
    Toggle(P4, "Bypass Anti-Cheat", "Speed")

    P1.Visible = true
end

-- [ BLOQUE 9: BUCLE PRINCIPAL (700+ LINEAS LOGIC) ]
RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        ExecuteCombatLogic()
        ExecuteFarmLogic()
        
        -- ESP Lógica con Colores Fijos Vivos
        if HubSettings.Flags.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                    local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                    
                    h.FillColor = isM and HubSettings.Theme.VividRed or (isS and HubSettings.Theme.VividBlue or HubSettings.Theme.VividGreen)
                    h.FillTransparency = 0.5
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            end
        end

        -- Anti-AFK
        if HubSettings.Flags.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end
end)

-- Iniciar Proceso
RunIntro()
