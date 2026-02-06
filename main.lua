--[[
    CHRISSHUB MM2 V11 - ULTRASHUB GAMA ALTA
    TikTok: sasware32
    
    ESTE SCRIPT ESTÁ DISEÑADO PARA DISPOSITIVOS POTENTES.
    LÓGICA EXPANDIDA, EFECTOS VISUALES Y FILTROS AVANZADOS.
]]

-- CONFIGURACIÓN INICIAL
local KEY_SISTEMA = "CHRIS2026"
local TIKTOK_USER = "sasware32"

-- SERVICIOS DE ROBLOX
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- TABLA DE ESTADOS GLOBAL
local HubState = {
    Toggles = {
        ESP = false,
        Aimbot = false,
        KillAura = false,
        Noclip = false,
        InfJump = false,
        AntiAFK = false,
        Speed = false,
        AutoFarm = false,
        Hitbox = false,
        Fly = false
    },
    Config = {
        ESP_Asesino = "Rojo",
        ESP_Sheriff = "Azul",
        ESP_Inocente = "Blanco",
        AimbotMode = "Normal", -- Normal, Legit, Asesino
        HitboxSize = 15,
        WalkSpeed = 75
    },
    Colors = {
        Rojo = Color3.fromRGB(255, 0, 0),
        Naranja = Color3.fromRGB(255, 127, 0),
        Amarillo = Color3.fromRGB(255, 255, 0),
        Verde = Color3.fromRGB(0, 255, 0),
        Azul = Color3.fromRGB(0, 0, 255),
        Morado = Color3.fromRGB(127, 0, 255),
        Negro = Color3.fromRGB(10, 10, 10),
        Blanco = Color3.fromRGB(255, 255, 255),
        Rosa = Color3.fromRGB(255, 0, 255),
        Gris = Color3.fromRGB(127, 127, 127)
    },
    Connections = {},
    LastJump = 0
}

-- LIMPIEZA DE UI PREVIA
if CoreGui:FindFirstChild("ChrisHub_V11") then
    CoreGui:FindFirstChild("ChrisHub_V11"):Destroy()
end

-- CREACIÓN DE INTERFAZ
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ChrisHub_V11"
ScreenGui.IgnoreGuiInset = true

-- FUNCIÓN DE ARRASTRE (OPTIMIZADA)
local function MakeDraggable(obj)
    local dragging, input, startPos, startInputPos
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInputPos = i.Position
            startPos = obj.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            input = i
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and input then
            local delta = input.Position - startInputPos
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- VENTANA PRINCIPAL
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 400)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MakeDraggable(MainFrame)

-- SIDEBAR
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BorderSizePixel = 0
local SideCorner = Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Text = "CHRIS HUB"
Logo.TextColor3 = Color3.fromRGB(0, 255, 120)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 22
Logo.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -70)
TabContainer.Position = UDim2.new(0, 0, 0, 65)
TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 5)

-- CONTENEDOR DE PÁGINAS
local PageHolder = Instance.new("Frame", MainFrame)
PageHolder.Size = UDim2.new(1, -165, 1, -20)
PageHolder.Position = UDim2.new(0, 160, 0, 10)
PageHolder.BackgroundTransparency = 1

local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageHolder)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding = UDim.new(0, 10)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
    end)

    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.85, 0, 0, 40)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 120), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    end)
    
    Pages[name] = Page
    return Page
end

-- COMPONENTES DE UI (TOGGLES Y SELECTORES)
local function AddToggle(parent, text, var)
    local TFrame = Instance.new("Frame", parent)
    TFrame.Size = UDim2.new(0.95, 0, 0, 50)
    TFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", TFrame)
    
    local TText = Instance.new("TextLabel", TFrame)
    TText.Size = UDim2.new(0.6, 0, 1, 0)
    TText.Position = UDim2.new(0, 15, 0, 0)
    TText.Text = text
    TText.TextColor3 = Color3.new(1,1,1)
    TText.Font = Enum.Font.GothamBold
    TText.TextSize = 14
    TText.TextXAlignment = Enum.TextXAlignment.Left
    TText.BackgroundTransparency = 1
    
    local Switch = Instance.new("TextButton", TFrame)
    Switch.Size = UDim2.new(0, 50, 0, 26)
    Switch.Position = UDim2.new(1, -65, 0.5, -13)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame", Switch)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 3, 0.5, -10)
    Circle.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    Switch.MouseButton1Click:Connect(function()
        HubState.Toggles[var] = not HubState.Toggles[var]
        local targetPos = HubState.Toggles[var] and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        local targetColor = HubState.Toggles[var] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(40, 40, 40)
        
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
end

local function AddSelector(parent, text, options, callback)
    local SFrame = Instance.new("Frame", parent)
    SFrame.Size = UDim2.new(0.95, 0, 0, 70)
    SFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", SFrame)
    
    local SText = Instance.new("TextLabel", SFrame)
    SText.Size = UDim2.new(1, -30, 0, 30)
    SText.Position = UDim2.new(0, 15, 0, 5)
    SText.Text = text
    SText.TextColor3 = Color3.fromRGB(180, 180, 180)
    SText.Font = Enum.Font.GothamBold
    SText.TextSize = 13
    SText.TextXAlignment = Enum.TextXAlignment.Left
    SText.BackgroundTransparency = 1
    
    local SBtn = Instance.new("TextButton", SFrame)
    SBtn.Size = UDim2.new(0.9, 0, 0, 30)
    SBtn.Position = UDim2.new(0.05, 0, 0, 35)
    SBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SBtn.Text = options[1]
    SBtn.TextColor3 = Color3.new(1,1,1)
    SBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SBtn)
    
    local index = 1
    SBtn.MouseButton1Click:Connect(function()
        index = (index % #options) + 1
        SBtn.Text = options[index]
        callback(options[index])
    end)
end

-- CREACIÓN DE PÁGINAS
local MainPg = CreatePage("MAIN")
local EspPg = CreatePage("ESP")
local CombatPg = CreatePage("COMBAT")
local AutoPg = CreatePage("AUTO")

-- PÁGINA MAIN
local UserLabel = Instance.new("TextLabel", MainPg)
UserLabel.Size = UDim2.new(1, 0, 0, 40)
UserLabel.Text = "Sigueme en mi TikTok: " .. TIKTOK_USER
UserLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
UserLabel.Font = Enum.Font.GothamBlack
UserLabel.TextSize = 16
UserLabel.BackgroundTransparency = 1

AddToggle(MainPg, "Noclip (Atravesar)", "Noclip")
AddToggle(MainPg, "Infinite Jump", "InfJump")
AddToggle(MainPg, "Anti-AFK (Modo Dios)", "AntiAFK")
AddToggle(MainPg, "Super Speed", "Speed")

-- PÁGINA ESP
AddToggle(EspPg, "Activar Visuales (ESP)", "ESP")
local colorOptions = {"Rojo", "Naranja", "Amarillo", "Verde", "Azul", "Morado", "Negro", "Blanco", "Rosa", "Gris"}
AddSelector(EspPg, "Color Asesino", colorOptions, function(v) HubState.Config.ESP_Asesino = v end)
AddSelector(EspPg, "Color Sheriff", colorOptions, function(v) HubState.Config.ESP_Sheriff = v end)
AddSelector(EspPg, "Color Inocente", colorOptions, function(v) HubState.Config.ESP_Inocente = v end)

-- PÁGINA COMBAT
AddToggle(CombatPg, "Kill Aura (360°)", "KillAura")
AddToggle(CombatPg, "Master Aimbot", "Aimbot")
AddSelector(CombatPg, "Filtro Aimbot", {"Normal", "Legit", "Asesino"}, function(v) HubState.Config.AimbotMode = v end)
AddToggle(CombatPg, "Expandir Hitbox", "Hitbox")

-- PÁGINA AUTO
AddToggle(AutoPg, "Auto Farm (Coming Soon)", "AutoFarm")

-- BOTÓN FLOTANTE (ESTILO CH)
local Float = Instance.new("TextButton", ScreenGui)
Float.Size = UDim2.new(0, 65, 0, 65)
Float.Position = UDim2.new(0, 20, 0.4, 0)
Float.BackgroundColor3 = Color3.new(0,0,0)
Float.Text = "CH"
Float.TextColor3 = Color3.fromRGB(0, 255, 120)
Float.Font = Enum.Font.GothamBlack
Float.TextSize = 26
Float.Visible = false
Instance.new("UICorner", Float).CornerRadius = UDim.new(1,0)
local FloatStroke = Instance.new("UIStroke", Float)
FloatStroke.Color = Color3.fromRGB(0, 255, 120)
FloatStroke.Thickness = 2
MakeDraggable(Float)

Float.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- SISTEMA DE LOGIN (CONSOLA HACKER)
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 350, 0, 250)
LoginFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", LoginFrame)
local LStroke = Instance.new("UIStroke", LoginFrame)
LStroke.Thickness = 2

local LLog = Instance.new("TextLabel", LoginFrame)
LLog.Size = UDim2.new(0.9, 0, 0, 100)
LLog.Position = UDim2.new(0.05, 0, 0.1, 0)
LLog.Text = "ChrisHub V11 Loading...\nWaiting for connection..."
LLog.TextColor3 = Color3.fromRGB(0, 255, 120)
LLog.Font = Enum.Font.Code
LLog.TextSize = 14
LLog.BackgroundTransparency = 1
LLog.TextXAlignment = Enum.TextXAlignment.Left
LLog.TextYAlignment = Enum.TextYAlignment.Top

local KInput = Instance.new("TextBox", LoginFrame)
KInput.Size = UDim2.new(0.8, 0, 0, 40)
KInput.Position = UDim2.new(0.1, 0, 0.55, 0)
KInput.PlaceholderText = "Enter License Key"
KInput.Text = ""
KInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KInput)

local KBtn = Instance.new("TextButton", LoginFrame)
KBtn.Size = UDim2.new(0.8, 0, 0, 40)
KBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
KBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
KBtn.Text = "VALIDATE SYSTEM"
KBtn.Font = Enum.Font.GothamBlack
Instance.new("UICorner", KBtn)

-- LÓGICA DE DETECCIÓN DE ROLES MM2
local function GetPlayerRole(plr)
    if not plr or not plr.Character then return "Inocente" end
    local backpack = plr:FindFirstChild("Backpack")
    local char = plr.Character
    
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
        return "Asesino"
    elseif char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Inocente"
end

-- BUCLE PRINCIPAL (RENDER STEPPED)
RunService.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("Humanoid") then return end
    local char = lp.Character
    local hum = char.Humanoid
    local root = char:FindFirstChild("HumanoidRootPart")
    
    -- Speed
    if HubState.Toggles.Speed then hum.WalkSpeed = HubState.Config.WalkSpeed else hum.WalkSpeed = 16 end
    
    -- Anti-AFK
    if HubState.Toggles.AntiAFK and tick() - HubState.LastJump > 30 then
        hum:ChangeState(3)
        HubState.LastJump = tick()
    end
    
    -- ESP
    if HubState.Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local role = GetPlayerRole(p)
                local color = HubState.Colors[HubState.Config["ESP_"..role]]
                
                local hl = p.Character:FindFirstChild("CH_Highlight") or Instance.new("Highlight", p.Character)
                hl.Name = "CH_Highlight"
                hl.Enabled = true
                hl.FillColor = color
                hl.OutlineColor = color
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("CH_Highlight") then
                p.Character.CH_Highlight.Enabled = false
            end
        end
    end
    
    -- KILL AURA (Optimizado Gama Alta)
    if HubState.Toggles.KillAura and char:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pRoot = p.Character.HumanoidRootPart
                if (root.Position - pRoot.Position).Magnitude < 19 then
                    firetouchinterest(pRoot, char.Knife.Handle, 0)
                    firetouchinterest(pRoot, char.Knife.Handle, 1)
                end
            end
        end
    end
    
    -- AIMBOT (Lógica Avanzada)
    if HubState.Toggles.Aimbot then
        local target, dist = nil, 500
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local role = GetPlayerRole(p)
                if HubState.Config.AimbotMode == "Asesino" and role ~= "Asesino" then continue end
                
                local head = p.Character.Head
                local pos, vis = camera:WorldToViewportPoint(head.Position)
                
                if vis then
                    if HubState.Config.AimbotMode == "Legit" then
                        local parts = camera:GetPartsObscuringTarget({camera.CFrame.Position, head.Position}, {char, p.Character})
                        if #parts > 0 then continue end
                    end
                    
                    local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if mDist < dist then
                        dist = mDist
                        target = head
                    end
                end
            end
        end
        if target then
            local aimPos = target.Position
            -- Predicción básica
            if target.Parent:FindFirstChild("HumanoidRootPart") then
                aimPos = aimPos + (target.Parent.HumanoidRootPart.Velocity * 0.1)
            end
            camera.CFrame = CFrame.new(camera.CFrame.Position, aimPos)
        end
    end

    -- HITBOX EXPANDER
    if HubState.Toggles.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(HubState.Config.HitboxSize, HubState.Config.HitboxSize, HubState.Config.HitboxSize)
                hrp.Transparency = 0.8
                hrp.CanCollide = false
            end
        end
    end
end)

-- NOCLIP STEPPED
RunService.Stepped:Connect(function()
    if HubState.Toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if HubState.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- EFECTO RAINBOW NEON GLOBAL
task.spawn(function()
    while task.wait() do
        local h = tick() % 5 / 5
        local color = Color3.fromHSV(h, 0.8, 1)
        MainStroke.Color = color
        LStroke.Color = color
        FloatStroke.Color = color
        Logo.TextColor3 = color
    end
end)

-- LOGIC LOGIN
KBtn.MouseButton1Click:Connect(function()
    if KInput.Text == KEY_SISTEMA then
        LLog.Text = "Key Validated!\nBypassing MM2 Security...\nInjecting ChrisHub V11..."
        task.wait(1)
        LoginFrame:Destroy()
        MainFrame.Visible = true
        Float.Visible = true
    else
        LLog.Text = "ACCESS DENIED\nInvalid Key Provided."
        KInput.Text = ""
    end
end)

-- AUTO-OPEN PARA PRUEBAS
Pages["MAIN"].Visible = true
