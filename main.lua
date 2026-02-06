--[[
    CHRISSHUB MM2 V5 - SUPREMO ELITE EDITION (PARTE 1/2)
    Key: CHRIS2026
    
    ESTE SCRIPT CONTIENE LÓGICA DE ALTA PRIORIDAD.
    TODOS LOS DERECHOS RESERVADOS A CHRIS.
]]

local KEY_SISTEMA = "CHRIS2026"

-- SERVICIOS DEL SISTEMA
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

-- VARIABLES DEL JUGADOR
local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- CONFIGURACIÓN DE ESTADO
local Settings = {
    ESP = false,
    Aimbot = false,
    KillAura = false,
    Hitbox = false,
    Noclip = false,
    InfJump = false,
    Speed = false,
    JumpPower = false,
    AutoFarm = false,
    AntiAFK = true,
    Visuals = {
        MenuColor = Color3.fromRGB(0, 255, 120),
        Rainbow = true
    }
}

-- ALMACENAMIENTO DE CACHÉ
local Cache = {
    Highlights = {},
    FakeParts = {},
    Connections = {},
    OriginalHitboxSize = {}
}

-- GENERAR INTERFAZ PROTEGIDA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CH_" .. HttpService:GenerateGUID(false):sub(1,8)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- FUNCIÓN PARA ANIMACIONES SUAVES
local function ApplyTween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(info), goal)
    t:Play()
    return t
end

-- DISEÑO DE BORDES NEÓN (RAINBOW OPCIONAL)
local function CreateNeonBorder(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Settings.Visuals.MenuColor
    stroke.ApplyStrokeMode = Enum.UIStrokeMode.Border
    stroke.Parent = parent
    
    if Settings.Visuals.Rainbow then
        task.spawn(function()
            while task.wait() do
                local hue = tick() % 5 / 5
                stroke.Color = Color3.fromHSV(hue, 1, 1)
            end
        end)
    end
    return stroke
end

-- ==========================================
-- MARCO DE SEGURIDAD (LOGIN)
-- ==========================================
local LoginFrame = Instance.new("Frame")
LoginFrame.Name = "SecurityGate"
LoginFrame.Size = UDim2.new(0, 360, 0, 280)
LoginFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
LoginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
LoginFrame.BorderSizePixel = 0
LoginFrame.Parent = ScreenGui
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 15)
CreateNeonBorder(LoginFrame)

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundTransparency = 1
Header.Text = "CHRISSHUB ELITE"
Header.TextColor3 = Color3.new(1, 1, 1)
Header.Font = Enum.Font.GothamBlack
Header.TextSize = 26
Header.Parent = LoginFrame

local SubHeader = Instance.new("TextLabel")
SubHeader.Size = UDim2.new(1, 0, 0, 20)
SubHeader.Position = UDim2.new(0, 0, 0, 55)
SubHeader.BackgroundTransparency = 1
SubHeader.Text = "SISTEMA DE ENCRIPTACIÓN V5"
SubHeader.TextColor3 = Color3.fromRGB(0, 255, 120)
SubHeader.Font = Enum.Font.GothamMedium
SubHeader.TextSize = 12
SubHeader.Parent = LoginFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.85, 0, 0, 55)
KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ingresa tu clave de acceso..." -- NO REVELA LA KEY
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 16
KeyInput.Parent = LoginFrame
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

local AuthButton = Instance.new("TextButton")
AuthButton.Size = UDim2.new(0.85, 0, 0, 55)
AuthButton.Position = UDim2.new(0.075, 0, 0.65, 0)
AuthButton.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
AuthButton.Text = "VALIDAR CREDENCIALES"
AuthButton.TextColor3 = Color3.fromRGB(0, 0, 0)
AuthButton.Font = Enum.Font.GothamBlack
AuthButton.TextSize = 16
AuthButton.Parent = LoginFrame
Instance.new("UICorner", AuthButton).CornerRadius = UDim.new(0, 10)

-- EFECTOS VISUALES AL PASAR EL MOUSE
AuthButton.MouseEnter:Connect(function()
    ApplyTween(AuthButton, 0.2, {BackgroundColor3 = Color3.new(1, 1, 1)})
end)
AuthButton.MouseLeave:Connect(function()
    ApplyTween(AuthButton, 0.2, {BackgroundColor3 = Color3.fromRGB(0, 255, 120)})
end)

-- ==========================================
-- CONTINUACIÓN: PARTE 2 - NÚCLEO SUPREMO
-- ==========================================

-- CREACIÓN DEL MARCO PRINCIPAL (MENÚ ELITE)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "EliteDashboard"
MainFrame.Size = UDim2.new(0, 480, 0, 520)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)
CreateNeonBorder(MainFrame)

-- BARRA LATERAL DE CATEGORÍAS
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 130, 1, -80)
SideBar.Position = UDim2.new(0, 15, 0, 70)
SideBar.BackgroundTransparency = 1

local ContentContainer = Instance.new("ScrollingFrame", MainFrame)
ContentContainer.Size = UDim2.new(1, -170, 1, -95)
ContentContainer.Position = UDim2.new(0, 155, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.CanvasSize = UDim2.new(0, 0, 2.5, 0)
ContentContainer.ScrollBarThickness = 2
ContentContainer.ScrollBarImageColor3 = Settings.Visuals.MenuColor

local ListLayout = Instance.new("UIListLayout", ContentContainer)
ListLayout.Padding = UDim.new(0, 12)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- FUNCIÓN PARA GENERAR MÓDULOS DE FUNCIONES
local function AddEliteFeature(name, description, callback)
    local Card = Instance.new("Frame", ContentContainer)
    Card.Size = UDim2.new(1, -10, 0, 85)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
    
    local NameLabel = Instance.new("TextLabel", Card)
    NameLabel.Size = UDim2.new(1, -80, 0, 35)
    NameLabel.Position = UDim2.new(0, 12, 0, 8)
    NameLabel.Text = name:upper()
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.Font = Enum.Font.GothamBlack
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextSize = 15
    
    local DescLabel = Instance.new("TextLabel", Card)
    DescLabel.Size = UDim2.new(1, -80, 0, 30)
    DescLabel.Position = UDim2.new(0, 12, 0, 40)
    DescLabel.Text = description
    DescLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    DescLabel.Font = Enum.Font.GothamMedium
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextSize = 11
    DescLabel.TextWrapped = true
    
    local ToggleBase = Instance.new("TextButton", Card)
    ToggleBase.Size = UDim2.new(0, 55, 0, 28)
    ToggleBase.Position = UDim2.new(1, -65, 0.5, -14)
    ToggleBase.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleBase.Text = ""
    Instance.new("UICorner", ToggleBase).CornerRadius = UDim.new(1, 0)
    
    local Indicator = Instance.new("Frame", ToggleBase)
    Indicator.Size = UDim2.new(0, 22, 0, 22)
    Indicator.Position = UDim2.new(0, 3, 0.5, -11)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    ToggleBase.MouseButton1Click:Connect(function()
        Settings[name] = not Settings[name]
        local targetPos = Settings[name] and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        local targetColor = Settings[name] and Settings.Visuals.MenuColor or Color3.fromRGB(35, 35, 35)
        
        ApplyTween(Indicator, 0.25, {Position = targetPos})
        ApplyTween(ToggleBase, 0.25, {BackgroundColor3 = targetColor})
        
        if callback then callback(Settings[name]) end
    end)
end

-- ==========================================
-- SISTEMA DE COMBATE SUPREMO
-- ==========================================

-- 1. KILL AURA 360 AVANZADO
task.spawn(function()
    while task.wait(0.05) do
        if Settings.KillAura and lp.Character then
            local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if knife then
                if knife.Parent ~= lp.Character then knife.Parent = lp.Character end
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 28 then
                            -- Bypass de colisión y daño masivo
                            for i = 1, 15 do
                                firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 0)
                                firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- 2. AIMBOT PREDICTIVO PRO
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local target = nil
        local maxDist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local pos, visible = camera:WorldToViewportPoint(p.Character.Head.Position)
                if visible then
                    local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if mouseDist < maxDist and mouseDist < 350 then
                        maxDist = mouseDist
                        target = p
                    end
                end
            end
        end
        if target then
            local moveOffset = target.Character.HumanoidRootPart.Velocity * 0.165
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position + moveOffset)
        end
    end
end)

-- 3. HITBOX EXPANDER (GIGANTES)
task.spawn(function()
    while task.wait(0.8) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if Settings.Hitbox then
                    hrp.Size = Vector3.new(22, 22, 22)
                    hrp.Transparency = 0.75
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end
end)

-- 4. AUTO-FARM DE MONEDAS (MM2)
task.spawn(function()
    while task.wait(0.2) do
        if Settings.AutoFarm and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local coins = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
            if coins then
                for _, coin in pairs(coins:GetChildren()) do
                    if coin:IsA("BasePart") then
                        lp.Character.HumanoidRootPart.CFrame = coin.CFrame
                        task.wait(0.12) -- Pequeño delay para no dar sospecha excesiva
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- REGISTRO DE MÓDULOS EN INTERFAZ
-- ==========================================
AddEliteFeature("ESP", "Rastreo avanzado de Murderer y Sheriff en tiempo real.")
AddEliteFeature("Aimbot", "Fijado de mira con predicción de movimiento enemiga.")
AddEliteFeature("KillAura", "Eliminación automática de jugadores cercanos (Rango: 28).")
AddEliteFeature("Hitbox", "Expansión masiva de área de impacto enemiga.")
AddEliteFeature("AutoFarm", "Recolección automatizada de monedas en todo el mapa.")
AddEliteFeature("Noclip", "Atraviesa estructuras sólidas sin restricciones.")
AddEliteFeature("InfJump", "Habilita saltos ilimitados para movilidad aérea.")
AddEliteFeature("Speed", "Aumenta la velocidad de caminata a nivel Elite (85).")

-- BOTÓN FLOTANTE (EST

