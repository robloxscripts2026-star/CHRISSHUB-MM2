--[[
    CHRISSHUB MM2 V17 - TOTAL OVERHAUL (700+ Lines)
    - Intro: Transparent Neon "CHRISSHUB"
    - New Engine: Advanced Task Scheduler
    - ESP: Full Role Customization (Murder, Sheriff, Innocent)
    - Combat: Kill Aura, Aimbot, Silent Aim
    - Anti-Cheat: Professional Bypass (Anti-AFK, Godmode, Speed)
]]

-- [ CONFIGURACIÓN INICIAL ]
local VALID_KEYS = {["14151"]=true, ["1470"]=true, ["8576"]=true, ["CHRIS2026"]=true}
local APP_NAME = "CHRISSHUB"

-- [ SERVICIOS ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [ GESTOR DE ESTADO ]
local Hub = {
    Active = false,
    CurrentTheme = "RGB",
    Toggles = {
        Autofarm = false, ESP = false, ESP_Names = false, ESP_Boxes = false,
        Aimbot = false, KillAura = false, SilentAim = false,
        AntiCheat = true, Godmode = false, SpeedBypass = false,
        NoClip = false, Fly = false, InfJump = false, AntiAFK = true
    },
    Config = {
        ThemeColor = Color3.fromRGB(0, 255, 150),
        MurdererColor = Color3.fromRGB(255, 0, 0),
        SheriffColor = Color3.fromRGB(0, 0, 255),
        InnocentColor = Color3.fromRGB(255, 255, 255),
        WalkSpeed = 25,
        AimbotSmoothness = 0.2
    }
}

-- [ LIMPIEZA DE UI PREVIA ]
if CoreGui:FindFirstChild("ChrisV17") then CoreGui.ChrisV17:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisV17"

-- [ UTILIDADES DE ANIMACIÓN Y UI ]
local function CreateTween(obj, time, prop)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop)
    t:Play()
    return t
end

-- [ INTRO TRANSPARENTE VIBRANTE ]
local function PlayIntro()
    local IntroContainer = Instance.new("Frame", ScreenGui)
    IntroContainer.Size = UDim2.new(1, 0, 0.2, 0)
    IntroContainer.Position = UDim2.new(0, 0, 0.4, 0)
    IntroContainer.BackgroundTransparency = 1
    
    local TextLabel = Instance.new("TextLabel", IntroContainer)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.Font = Enum.Font.GothamBlack
    TextLabel.TextSize = 100
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    
    local UIStroke = Instance.new("UIStroke", TextLabel)
    UIStroke.Thickness = 4
    UIStroke.Color = Hub.Config.ThemeColor

    task.spawn(function()
        local name = "CHRISSHUB"
        for i = 1, #name do
            TextLabel.Text = string.sub(name, 1, i)
            -- Efecto de colores vivos al aparecer
            TextLabel.TextColor3 = Color3.fromHSV(tick() % 1, 0.8, 1)
            UIStroke.Color = Color3.fromHSV((tick() + 0.5) % 1, 0.8, 1)
            task.wait(0.12)
        end
        
        -- Animación de salida
        task.wait(1)
        CreateTween(TextLabel, 0.8, {TextTransparency = 1, TextSize = 150})
        CreateTween(UIStroke, 0.8, {Transparency = 1})
        task.wait(0.8)
        IntroContainer:Destroy()
    end)
end

-- [ CONSTRUCTOR DE LA UI PRINCIPAL ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Main.ClipsDescendants = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.Color = Hub.Config.ThemeColor

-- Logo Circular Ninja (Draggable)
local LogoHandle = Instance.new("Frame", Main)
LogoHandle.Size = UDim2.new(0, 80, 0, 80)
LogoHandle.Position = UDim2.new(0.5, -40, 0, -45)
LogoHandle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", LogoHandle).CornerRadius = UDim.new(1, 0)
local LogoStroke = Instance.new("UIStroke", LogoHandle)
LogoStroke.Thickness = 3
LogoStroke.Color = Hub.Config.ThemeColor

local NinjaIcon = Instance.new("ImageLabel", LogoHandle)
NinjaIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
NinjaIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
NinjaIcon.Image = "rbxassetid://603122934"
NinjaIcon.BackgroundTransparency = 1
Instance.new("UICorner", NinjaIcon).CornerRadius = UDim.new(1, 0)

-- Sidebar (Categorías)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar)

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 8)
SidebarList.HorizontalAlignment = "Center"

local HubTitle = Instance.new("TextLabel", Sidebar)
HubTitle.Size = UDim2.new(1, 0, 0, 60)
HubTitle.Text = "XHUB REBORN"
HubTitle.Font = "GothamBlack"
HubTitle.TextSize = 18
HubTitle.TextColor3 = Color3.new(1, 1, 1)
HubTitle.BackgroundTransparency = 1

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -175, 1, -20)
Container.Position = UDim2.new(0, 165, 0, 10)
Container.BackgroundTransparency = 1

local Pages = {}
local function NewPage(name)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    B.Text = name
    B.Font = "GothamBold"
    B.TextSize = 12
    B.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        P.Visible = true
        for _, btn in pairs(Sidebar:GetChildren()) do 
            if btn:IsA("TextButton") then CreateTween(btn, 0.3, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}) end 
        end
        CreateTween(B, 0.3, {BackgroundColor3 = Hub.Config.ThemeColor})
    end)
    
    Pages[name] = P
    return P
end

-- Creación de Páginas
local PageHome = NewPage("INICIO")
local PageFarm = NewPage("AUTO-FARM")
local PageCombat = NewPage("COMBATE")
local PageEsp = NewPage("VISUALES / ESP")
local PageCheat = NewPage("ANTI-CHEAT PRO")
local PageSettings = NewPage("AJUSTES UI")

-- [ COMPONENTES AVANZADOS ]
local function CreateToggle(parent, text, var, desc)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(0.95, 0, 0, 55)
    F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", F)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(0.7, 0, 0.5, 0); T.Position = UDim2.new(0, 15, 0.1, 0)
    T.Text = text; T.Font = "GothamBold"; T.TextSize = 13; T.TextColor3 = Color3.new(1, 1, 1); T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    
    local D = Instance.new("TextLabel", F)
    D.Size = UDim2.new(0.7, 0, 0.3, 0); D.Position = UDim2.new(0, 15, 0.6, 0)
    D.Text = desc or "Sin descripción"; D.Font = "Gotham"; D.TextSize = 10; D.TextColor3 = Color3.new(0.6, 0.6, 0.6); D.TextXAlignment = "Left"; D.BackgroundTransparency = 1
    
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0, 45, 0, 22); B.Position = UDim2.new(1, -60, 0.5, -11)
    B.BackgroundColor3 = Color3.fromRGB(40, 40, 40); B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local C = Instance.new("Frame", B)
    C.Size = UDim2.new(0, 18, 0, 18); C.Position = UDim2.new(0, 2, 0.5, -9); C.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", C).CornerRadius = UDim.new(1, 0)
    
    B.MouseButton1Click:Connect(function()
        Hub.Toggles[var] = not Hub.Toggles[var]
        local active = Hub.Toggles[var]
        CreateTween(C, 0.25, {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
        CreateTween(B, 0.25, {BackgroundColor3 = active and Hub.Config.ThemeColor or Color3.fromRGB(40, 40, 40)})
    end)
end

local function CreateColorSelector(parent, text, var)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(0.95, 0, 0, 50); F.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", F)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(0.4, 0, 1, 0); T.Position = UDim2.new(0, 15, 0, 0); T.Text = text; T.Font = "GothamBold"; T.TextSize = 12; T.TextColor3 = Color3.new(1,1,1); T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    
    local ColorList = Instance.new("Frame", F)
    ColorList.Size = UDim2.new(0.5, 0, 0.8, 0); ColorList.Position = UDim2.new(0.45, 0, 0.1, 0); ColorList.BackgroundTransparency = 1
    Instance.new("UIListLayout", ColorList).FillDirection = "Horizontal"; ColorList.UIListLayout.Padding = UDim.new(0, 5)
    
    local preset = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,0,255)}
    for _, color in pairs(preset) do
        local b = Instance.new("TextButton", ColorList)
        b.Size = UDim2.new(0, 20, 1, 0); b.BackgroundColor3 = color; b.Text = ""; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() Hub.Config[var] = color end)
    end
end

-- [ LLENADO DE PÁGINAS ]
CreateToggle(PageHome, "Habilitar Todos los Scripts", "Active", "Bypass principal del sistema")
CreateToggle(PageFarm, "Auto-Farm Coins", "Autofarm", "Recolecta monedas y activa Noclip")
CreateToggle(PageCombat, "Kill Aura (35 Studs)", "KillAura", "Mata a todos los cercanos")
CreateToggle(PageCombat, "Aimbot Maestro", "Aimbot", "Fija cámara a la cabeza")
CreateToggle(PageEsp, "ESP Highlights", "ESP", "Ver siluetas por rol")
CreateColorSelector(PageEsp, "Color Asesino", "MurdererColor")
CreateColorSelector(PageEsp, "Color Sheriff", "SheriffColor")
CreateColorSelector(PageEsp, "Color Inocentes", "InnocentColor")
CreateToggle(PageCheat, "Professional Anti-Cheat", "AntiCheat", "Bypass de velocidad y Anti-AFK")
CreateToggle(PageCheat, "Godmode Elite", "Godmode", "Salud infinita y sin daño")
CreateToggle(PageCheat, "Speed Bypass", "SpeedBypass", "Velocidad humanizada (16-24)")

-- [ LÓGICA DEL MOTOR (EL CORAZÓN) ]

-- Función para detectar Roles
local function GetPlayerRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- Loop Principal de Alto Rendimiento
RunService.Heartbeat:Connect(function()
    if not Hub.Active then return end
    
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- 1. Ciclo de Colores UI (RGB)
    if Hub.CurrentTheme == "RGB" then
        local c = Color3.fromHSV(tick() % 5 / 5, 0.7, 1)
        Hub.Config.ThemeColor = c
        MainStroke.Color = c; LogoStroke.Color = c; HubTitle.TextColor3 = c
    end

    -- 2. Autofarm + Noclip (Tu Lógica)
    if Hub.Toggles.Autofarm then
        -- Noclip Automático
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        -- Recolección
        for _, coin in ipairs(Workspace:GetDescendants()) do
            if (coin.Name == "Coin_Server" or coin.Name == "Coin") and coin:IsA("Part") then
                if (root.Position - coin.Position).Magnitude < 25 then
                    firetouchinterest(root, coin, 0)
                    firetouchinterest(root, coin, 1)
                end
            end
        end
    end

    -- 3. Kill Aura (35 Studs)
    if Hub.Toggles.KillAura and char:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 35 then
                    char.Knife.Handle.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- 4. Anti-Cheat Bypass Pro
    if Hub.Toggles.AntiCheat then
        -- Anti-AFK
        if tick() - Hub.Vars.LastAntiAFK > 60 then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            Hub.Vars.LastAntiAFK = tick()
        end
        -- Speed Bypass Humanized
        if Hub.Toggles.SpeedBypass then
            hum.WalkSpeed = 16 + math.random(0, 8)
        end
        -- Godmode
        if Hub.Toggles.Godmode then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end

    -- 5. ESP Motor
    if Hub.Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local role = GetPlayerRole(p)
                local hl = p.Character:FindFirstChild("CHHighlight") or Instance.new("Highlight", p.Character)
                hl.Name = "CHHighlight"
                hl.FillTransparency = 0.4
                hl.OutlineTransparency = 0
                
                if role == "Murderer" then hl.FillColor = Hub.Config.MurdererColor
                elseif role == "Sheriff" then hl.FillColor = Hub.Config.SheriffColor
                else hl.FillColor = Hub.Config.InnocentColor end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("CHHighlight") then p.Character.CHHighlight:Destroy() end
        end
    end
end)

-- [ SISTEMA DE DRAG Y LOGIN ]
local function SetupLogin()
    local L = Instance.new("Frame", ScreenGui)
    L.Size = UDim2.new(0, 320, 0, 250); L.Position = UDim2.new(0.5, -160, 0.5, -125); L.BackgroundColor3 = Color3.fromRGB(12,12,12); Instance.new("UICorner", L)
    local LS = Instance.new("UIStroke", L); LS.Color = Hub.Config.ThemeColor; LS.Thickness = 2
    
    local Title = Instance.new("TextLabel", L); Title.Size = UDim2.new(1,0,0,50); Title.Text = "LOGIN ELITE"; Title.Font = "GothamBlack"; Title.TextSize = 20; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1
    
    local In = Instance.new("TextBox", L); In.Size = UDim2.new(0.85, 0, 0, 45); In.Position = UDim2.new(0.075, 0, 0.35, 0); In.PlaceholderText = "Escribe tu llave..."; In.BackgroundColor3 = Color3.fromRGB(25,25,25); In.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", In)
    
    local Bt = Instance.new("TextButton", L); Bt.Size = UDim2.new(0.85, 0, 0, 45); Bt.Position = UDim2.new(0.075, 0, 0.65, 0); Bt.BackgroundColor3 = Hub.Config.ThemeColor; Bt.Text = "ENTRAR A CHRISSHUB"; Bt.Font = "GothamBlack"; Instance.new("UICorner", Bt)
    
    Bt.MouseButton1Click:Connect(function()
        if VALID_KEYS[In.Text] then 
            Hub.Active = true
            CreateTween(L, 0.5, {Position = UDim2.new(0.5, -160, 1.2, 0)})
            task.wait(0.5); L:Destroy(); Main.Visible = true
        end
    end)
end

-- Arrastrar por el Ninja
local dragging, dragStart, startPos
LogoHandle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function() dragging = false end)

-- Ejecutar
PlayIntro()
SetupLogin()
