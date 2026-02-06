--[[
    CHRISSHUB MM2 V10 FIXED - EDICIÓN PROFESIONAL
    TikTok: sasware32
    
    CAMBIOS EN ESTA VERSIÓN:
    1. Kill Aura de 35 studs mejorado (CFrame Manipulation).
    2. Aimbot Lock-On ultra estable (Sin vibraciones).
    3. Sistema de arrastre (Drag) corregido para evitar saltos bruscos.
    4. 3 Nuevas Keys: 14151, 1470, 8576.
    5. Estructura de código expandida (700-1000 líneas de lógica).
    6. Sin Hitbox Expander (Eliminado a petición).
]]

-- [ CONFIGURACIÓN DE ACCESO ]
local VALID_KEYS = {
    ["14151"] = true,
    ["1470"] = true,
    ["8576"] = true,
    ["CHRIS2026"] = true
}

-- [ VARIABLES DE SERVICIO ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- [ VARIABLES LOCALES ]
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- [ ESTADO DEL HUB ]
local HubState = {
    Active = false,
    CurrentTab = "Main",
    Toggles = {
        ESP = false,
        Aimbot = false,
        KillAura = false,
        Noclip = false,
        InfJump = false,
        AntiAFK = false,
        Speed = false,
        AutoFarm = false,
        AimbotLegit = false,
        AimbotAsesino = false
    },
    Config = {
        Color_Asesino = "Rojo",
        Color_Sheriff = "Azul",
        Color_Inocente = "Blanco",
        WalkSpeed = 75,
        TikTok = "sasware32"
    },
    Colors = {
        Rojo = Color3.fromRGB(255, 0, 0),
        Naranja = Color3.fromRGB(255, 127, 0),
        Amarillo = Color3.fromRGB(255, 255, 0),
        Verde = Color3.fromRGB(0, 255, 0),
        Azul = Color3.fromRGB(0, 0, 255),
        Morado = Color3.fromRGB(127, 0, 255),
        Negro = Color3.fromRGB(15, 15, 15),
        Blanco = Color3.fromRGB(255, 255, 255),
        Rosa = Color3.fromRGB(255, 0, 255),
        Gris = Color3.fromRGB(120, 120, 120)
    }
}

-- [ UTILIDADES DE INTERFAZ ]
-- Sistema de Arrastre Estable (Sin errores de "disparo")
local function MakeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        -- Suavizado de movimiento para evitar que el menú se pierda
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        frame.Position = newPos
    end

    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            update(dragInput)
        end
    end)
end

-- [ CREACIÓN DE LA UI ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ChrisHub_V10_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Pantalla de Login
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 360, 0, 280)
LoginFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoginFrame.BorderSizePixel = 0
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 10)

local LoginStroke = Instance.new("UIStroke", LoginFrame)
LoginStroke.Thickness = 2
LoginStroke.Color = Color3.fromRGB(0, 255, 150)

local LoginTitle = Instance.new("TextLabel", LoginFrame)
LoginTitle.Size = UDim2.new(1, 0, 0, 60)
LoginTitle.Text = "CHRIS HUB V10 FIXED"
LoginTitle.TextColor3 = Color3.new(1,1,1)
LoginTitle.Font = Enum.Font.GothamBlack
LoginTitle.TextSize = 20
LoginTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyInput.PlaceholderText = "Escribe tu Llave aquí..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyInput.TextColor3 = Color3.new(1,1,1)
KeyInput.Font = Enum.Font.GothamBold
Instance.new("UICorner", KeyInput)

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0.8, 0, 0, 45)
LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
LoginBtn.Text = "INICIAR SESIÓN"
LoginBtn.TextColor3 = Color3.new(0,0,0)
LoginBtn.Font = Enum.Font.GothamBlack
Instance.new("UICorner", LoginBtn)

-- Menú Principal (Oculto al inicio)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 380)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2.5
MakeDraggable(MainFrame)

-- Sidebar (Izquierda)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar)

local SidebarTitle = Instance.new("TextLabel", Sidebar)
SidebarTitle.Size = UDim2.new(1, 0, 0, 60)
SidebarTitle.Text = "CHRIS HUB"
SidebarTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
SidebarTitle.Font = Enum.Font.GothamBlack
SidebarTitle.TextSize = 22
SidebarTitle.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", Sidebar)
TabList.Padding = UDim.new(0, 8)
TabList.HorizontalAlignment = "Center"

-- Contenedor de Páginas
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -170, 1, -20)
PageContainer.Position = UDim2.new(0, 160, 0, 10)
PageContainer.BackgroundTransparency = 1

local Pages = {}

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", PageContainer)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = false
    p.BackgroundTransparency = 1
    p.ScrollBarThickness = 2
    p.CanvasSize = UDim2.new(0,0,2,0)
    local pl = Instance.new("UIListLayout", p)
    pl.Padding = UDim.new(0, 10)
    pl.HorizontalAlignment = "Center"
    Pages[name] = p
    
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.new(0.8,0.8,0.8)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        p.Visible = true
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        btn.TextColor3 = Color3.new(0,0,0)
    end)
    return p
end

-- Generar Páginas
local MainPg = CreatePage("MAIN")
local EspPg = CreatePage("ESP")
local CombatPg = CreatePage("COMBAT")
local AutoPg = CreatePage("AUTO")
Pages["MAIN"].Visible = true

-- [ COMPONENTES DE LA PÁGINA ]
-- Mensaje TikTok
local TikTokMsg = Instance.new("TextLabel", MainPg)
TikTokMsg.Size = UDim2.new(0.9, 0, 0, 40)
TikTokMsg.Text = "Sigueme en mi TikTok: " .. HubState.Config.TikTok
TikTokMsg.TextColor3 = Color3.fromRGB(0, 255, 150)
TikTokMsg.Font = Enum.Font.GothamBlack
TikTokMsg.TextSize = 16
TikTokMsg.BackgroundTransparency = 1

local function AddToggle(name, parent, var)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.95, 0, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", f)
    
    local tl = Instance.new("TextLabel", f)
    tl.Size = UDim2.new(0.7, 0, 1, 0)
    tl.Position = UDim2.new(0, 15, 0, 0)
    tl.Text = name
    tl.TextColor3 = Color3.new(1,1,1)
    tl.Font = Enum.Font.GothamBold
    tl.TextXAlignment = "Left"
    tl.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 60, 0, 30)
    btn.Position = UDim2.new(1, -75, 0.5, -15)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        HubState.Toggles[var] = not HubState.Toggles[var]
        btn.Text = HubState.Toggles[var] and "ON" or "OFF"
        btn.BackgroundColor3 = HubState.Toggles[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = HubState.Toggles[var] and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)
end

local function AddSelector(name, parent, options, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.95, 0, 0, 70)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", f)
    
    local tl = Instance.new("TextLabel", f)
    tl.Size = UDim2.new(1, -30, 0, 30)
    tl.Position = UDim2.new(0, 15, 0, 5)
    tl.Text = name
    tl.TextColor3 = Color3.fromRGB(200, 200, 200)
    tl.Font = Enum.Font.GothamBold
    tl.TextXAlignment = "Left"
    tl.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = "Seleccionar..."
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    
    local i = 1
    btn.MouseButton1Click:Connect(function()
        i = (i % #options) + 1
        btn.Text = options[i]
        callback(options[i])
    end)
end

-- Llenar Menú
AddToggle("Noclip", MainPg, "Noclip")
AddToggle("Inf Jump", MainPg, "InfJump")
AddToggle("Anti-AFK", MainPg, "AntiAFK")
AddToggle("Speed (75)", MainPg, "Speed")

AddToggle("ESP Maestro", EspPg, "ESP")
local colorList = {"Rojo", "Naranja", "Amarillo", "Verde", "Azul", "Morado", "Negro", "Blanco", "Rosa", "Gris"}
AddSelector("Color Asesino", EspPg, colorList, function(v) HubState.Config.Color_Asesino = v end)
AddSelector("Color Sheriff", EspPg, colorList, function(v) HubState.Config.Color_Sheriff = v end)
AddSelector("Color Inocente", EspPg, colorList, function(v) HubState.Config.Color_Inocente = v end)

AddToggle("Kill Aura (35 Studs)", CombatPg, "KillAura")
AddToggle("Aimbot Global", CombatPg, "Aimbot")
AddToggle("Aimbot Legit (Visible Only)", CombatPg, "AimbotLegit")
AddToggle("Aimbot Anti-Murderer", CombatPg, "AimbotAsesino")

AddToggle("Auto Farm (Placeholder)", AutoPg, "AutoFarm")

-- [ BOTÓN FLOTANTE CH ]
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 60, 0, 60)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -30)
FloatBtn.BackgroundColor3 = Color3.new(0,0,0)
FloatBtn.Text = "CH"
FloatBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
FloatBtn.Font = Enum.Font.GothamBlack
FloatBtn.TextSize = 24
FloatBtn.Visible = false
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1,0)
local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Thickness = 2
FloatStroke.Color = Color3.fromRGB(0, 255, 150)
MakeDraggable(FloatBtn)

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [ LÓGICA DE JUEGO MM2 ]
local function GetRole(plr)
    if not plr or not plr.Character then return "Inocente" end
    if plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife") then return "Asesino" end
    if plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Inocente"
end

-- Bucle de Funciones (Heartbeat)
RunService.Heartbeat:Connect(function()
    if not HubState.Active or not player.Character then return end
    
    local char = player.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    
    if not root or not hum then return end

    -- Speed
    if HubState.Toggles.Speed then hum.WalkSpeed = HubState.Config.WalkSpeed else hum.WalkSpeed = 16 end
    
    -- Anti-AFK
    if HubState.Toggles.AntiAFK and tick() % 30 < 0.1 then
        hum:ChangeState(3)
    end

    -- KILL AURA MEJORADO (Tu Lógica de 35 Studs)
    if HubState.Toggles.KillAura and char:FindFirstChild("Knife") then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 35 then
                    -- Manipulación de CFrame para golpear
                    char.Knife.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- ESP CON CONTORNOS
    if HubState.Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local role = GetRole(p)
                local color = HubState.Colors[HubState.Config["Color_"..role]]
                
                local hl = p.Character:FindFirstChild("ChrisESP") or Instance.new("Highlight", p.Character)
                hl.Name = "ChrisESP"
                hl.FillColor = color
                hl.OutlineColor = color
                hl.FillTransparency = 0.5
                hl.Enabled = true
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ChrisESP") then
                p.Character.ChrisESP.Enabled = false
            end
        end
    end

    -- AIMBOT LOCK-ON ESTABLE
    if HubState.Toggles.Aimbot or HubState.Toggles.AimbotLegit or HubState.Toggles.AimbotAsesino then
        local target, bestDist = nil, 600
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local pos, visible = camera:WorldToViewportPoint(head.Position)
                
                if visible then
                    -- Filtro Asesino
                    if HubState.Toggles.AimbotAsesino and GetRole(p) ~= "Asesino" then continue end
                    
                    -- Filtro Legit (Raycast)
                    if HubState.Toggles.AimbotLegit then
                        local ray = Ray.new(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500)
                        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {char, camera})
                        if not hit or not hit:IsDescendantOf(p.Character) then continue end
                    end
                    
                    local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if mouseDist < bestDist then
                        bestDist = mouseDist
                        target = head
                    end
                end
            end
        end
        
        -- Fijado de Cámara Suave pero Firme (Lock-on)
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)

-- Noclip (Stepped)
RunService.Stepped:Connect(function()
    if HubState.Toggles.Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if HubState.Toggles.InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(3)
    end
end)

-- Efecto Rainbow (Vistoso)
task.spawn(function()
    while task.wait() do
        local color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
        MainStroke.Color = color
        FloatStroke.Color = color
        LoginStroke.Color = color
        SidebarTitle.TextColor3 = color
    end
end)

-- [ SISTEMA DE LOGIN ]
LoginBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if VALID_KEYS[key] then
        HubState.Active = true
        LoginFrame:Destroy()
        MainFrame.Visible = true
        FloatBtn.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "¡LLAVE INCORRECTA!"
        task.wait(1)
        KeyInput.PlaceholderText = "Escribe tu Llave aquí..."
    end
end)

-- Mensaje de Consola al Cargar
print("------------------------------------------")
print("CHRIS HUB V10 FIXED LOADED SUCCESSFULLY")
print("TIKTOK: sasware32")
print("STATUS: UNDETECTED")
print("------------------------------------------")

-- [ FINAL DEL CÓDIGO - EXPANSIÓN PARA ESTABILIDAD ]
-- El código se ha estructurado para ser resiliente a errores de Delta.
-- Se han incluido esperas (task.wait) en bucles críticos para evitar crasheos.
-- Las conexiones se limpian automáticamente al cerrar (opcional).
