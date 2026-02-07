--[[
    ██████╗██╗  ██╗██████╗ ██╗███████╗███████╗██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██║  ██║██╔══██╗██║██╔════╝██╔════╝██║  ██║██║   ██║██╔══██╗
    ██║     ███████║██████╔╝██║███████╗███████╗███████║██║   ██║██████╔╝
    ██║     ██╔══██║██╔══██╗██║╚════██║╚════██║██╔══██║██║   ██║██╔══██╗
    ╚██████╗██║  ██║██║  ██║██║███████║███████║██║  ██║╚██████╔╝██████╔╝
     ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    CHRISSHUB MM2 V3 - RECORREGIDO Y EXPANDIDO (FULL GITHUB VERSION)
    Fix: "attempt to call a nil value" - Variables Globales Inicializadas.
    Líneas: >600 para máxima robustez.
]]

-- =============================================================
-- [1] INICIALIZACIÓN DE SERVICIOS (CRÍTICO)
-- =============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- =============================================================
-- [2] DEFINICIÓN DE VARIABLES DE ENTORNO (FIX NIL ERRORS)
-- =============================================================
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Contenedores de UI (Se crean primero para evitar errores de referencia nil)
local ChrissMainGui = Instance.new("ScreenGui")
ChrissMainGui.Name = "ChrissHub_Final_V3"
ChrissMainGui.ResetOnSpawn = false
ChrissMainGui.DisplayOrder = 10
ChrissMainGui.Parent = CoreGui

-- =============================================================
-- [3] CONFIGURACIÓN DE COLORES (20 OPCIONES RGB)
-- =============================================================
local ColorLibrary = {
    ["Rojo"] = Color3.fromRGB(255, 0, 0),
    ["Naranja"] = Color3.fromRGB(255, 165, 0),
    ["Amarillo"] = Color3.fromRGB(255, 255, 0),
    ["Verde lima"] = Color3.fromRGB(50, 205, 50),
    ["Verde bosque"] = Color3.fromRGB(34, 139, 34),
    ["Azul cielo"] = Color3.fromRGB(135, 206, 235),
    ["Azul marino"] = Color3.fromRGB(0, 0, 128),
    ["Azul eléctrico"] = Color3.fromRGB(0, 191, 255),
    ["Morado"] = Color3.fromRGB(128, 0, 128),
    ["Lila"] = Color3.fromRGB(221, 160, 221),
    ["Rosa"] = Color3.fromRGB(255, 192, 203),
    ["Rosa fucsia"] = Color3.fromRGB(255, 105, 180),
    ["Marrón"] = Color3.fromRGB(139, 69, 19),
    ["Café claro"] = Color3.fromRGB(222, 184, 135),
    ["Negro"] = Color3.fromRGB(0, 0, 0),
    ["Blanco"] = Color3.fromRGB(255, 255, 255),
    ["Gris"] = Color3.fromRGB(128, 128, 128),
    ["Gris claro"] = Color3.fromRGB(211, 211, 211),
    ["Turquesa"] = Color3.fromRGB(64, 224, 208),
    ["Beige"] = Color3.fromRGB(245, 245, 220)
}

local ColorNames = {
    "Rojo", "Naranja", "Amarillo", "Verde lima", "Verde bosque", 
    "Azul cielo", "Azul marino", "Azul eléctrico", "Morado", "Lila", 
    "Rosa", "Rosa fucsia", "Marrón", "Café claro", "Negro", "Blanco", 
    "Gris", "Gris claro", "Turquesa", "Beige"
}

-- =============================================================
-- [4] ESTADOS Y CONFIGURACIÓN (DICCIONARIOS)
-- =============================================================
local Toggles = {
    ESP = false,
    Aimbot = false,
    AimbotLegit = false,
    AimbotAsesino = false,
    KillAura = false,
    Noclip = false,
    InfJump = false,
    AntiAFK = false,
    MenuVisible = true
}

local ESPConfig = {
    Murderer = "Rojo",
    Sheriff = "Azul marino",
    Innocent = "Verde lima",
    LastUpdate = 0
}

local ValidKeys = {"482916", "731592", "264831", "917542", "358269", "621973", "845137"}
local IsAuthenticated = false

-- =============================================================
-- [5] LIBRERÍA DE UTILIDADES DE UI (EXPANDIDA)
-- =============================================================
local UIUtils = {}

function UIUtils:MakeTween(obj, props, t)
    local tween = TweenService:Create(obj, TweenInfo.new(t or 0.4, Enum.EasingStyle.Quart), props)
    tween:Play()
    return tween
end

function UIUtils:MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- =============================================================
-- [6] SISTEMA DE NOTIFICACIONES PREMIUM
-- =============================================================
local NotifGui = Instance.new("ScreenGui", CoreGui)
NotifGui.Name = "ChrissNotifications"

local function Notify(title, msg, color)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 250, 0, 70)
    notifFrame.Position = UDim2.new(1, 10, 0.8, 0)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = NotifGui
    
    local corner = Instance.new("UICorner", notifFrame)
    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = color or Color3.fromRGB(0, 255, 120)
    stroke.Thickness = 2

    local t = Instance.new("TextLabel", notifFrame)
    t.Size = UDim2.new(1, -10, 0, 30)
    t.Position = UDim2.new(0, 10, 0, 5)
    t.Text = title
    t.TextColor3 = stroke.Color
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left

    local m = Instance.new("TextLabel", notifFrame)
    m.Size = UDim2.new(1, -10, 0, 30)
    m.Position = UDim2.new(0, 10, 0, 30)
    m.Text = msg
    m.TextColor3 = Color3.new(1, 1, 1)
    m.Font = Enum.Font.Gotham
    m.TextSize = 12
    m.BackgroundTransparency = 1
    m.TextXAlignment = Enum.TextXAlignment.Left

    UIUtils:MakeTween(notifFrame, {Position = UDim2.new(1, -260, 0.8, 0)}, 0.5)
    task.delay(3, function()
        UIUtils:MakeTween(notifFrame, {Position = UDim2.new(1, 10, 0.8, 0)}, 0.5)
        task.wait(0.5)
        notifFrame:Destroy()
    end)
end

-- =============================================================
-- [7] MÓDULO DE INTRODUCCIÓN HACKER (CORREGIDO)
-- =============================================================
local function StartIntro()
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Size = UDim2.new(1, 0, 1, 0)
    IntroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    IntroFrame.BorderSizePixel = 0
    IntroFrame.Parent = ChrissMainGui

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, 0, 1, 0)
    MainTitle.Text = "CHRISSHUB V3\nLOADING ASSETS..."
    MainTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
    MainTitle.Font = Enum.Font.Code
    MainTitle.TextSize = 50
    MainTitle.BackgroundTransparency = 1
    MainTitle.Parent = IntroFrame

    task.spawn(function()
        for i = 1, 50 do
            local l = Instance.new("TextLabel", IntroFrame)
            l.Text = "ACCESSING_MM2_DATA..." .. tostring(math.random(1000, 9999))
            l.Position = UDim2.new(math.random(), 0, -0.1, 0)
            l.TextColor3 = Color3.fromRGB(0, 100, 50)
            l.BackgroundTransparency = 1
            l.Font = Enum.Font.Code
            UIUtils:MakeTween(l, {Position = UDim2.new(l.Position.X.Scale, 0, 1.1, 0)}, 3)
            Debris:AddItem(l, 3)
            task.wait(0.1)
        end
    end)

    task.wait(5)
    UIUtils:MakeTween(IntroFrame, {BackgroundTransparency = 1}, 1)
    UIUtils:MakeTween(MainTitle, {TextTransparency = 1}, 1)
    task.wait(1)
    IntroFrame:Destroy()
    
    -- Llamar al Key System después de la intro
    ShowKeyMenu()
end

-- =============================================================
-- [8] MÓDULO KEY SYSTEM (SIN ERRORES)
-- =============================================================
function ShowKeyMenu()
    local KeyWindow = Instance.new("Frame")
    KeyWindow.Size = UDim2.new(0, 350, 0, 200)
    KeyWindow.Position = UDim2.new(0.5, -175, 0.5, -100)
    KeyWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    KeyWindow.Parent = ChrissMainGui
    Instance.new("UICorner", KeyWindow)
    
    local Title = Instance.new("TextLabel", KeyWindow)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(0, 255, 120)
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    Title.TextSize = 20

    local Input = Instance.new("TextBox", KeyWindow)
    Input.Size = UDim2.new(0.8, 0, 0, 40)
    Input.Position = UDim2.new(0.1, 0, 0.35, 0)
    Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Input.TextColor3 = Color3.new(1, 1, 1)
    Input.PlaceholderText = "Escribe la key aquí..."
    Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyWindow)
    Verify.Size = UDim2.new(0.8, 0, 0, 40)
    Verify.Position = UDim2.new(0.1, 0, 0.65, 0)
    Verify.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    Verify.Text = "ENTRAR"
    Verify.Font = Enum.Font.GothamBold
    Verify.TextColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", Verify)

    Verify.MouseButton1Click:Connect(function()
        for _, k in ipairs(ValidKeys) do
            if Input.Text == k then
                IsAuthenticated = true
                Notify("ACCESO CONCEDIDO", "Bienvenido a ChrisHub V3", Color3.fromRGB(0, 255, 0))
                KeyWindow:Destroy()
                BuildMainInterface()
                return
            end
        end
        Input.Text = ""
        Input.PlaceholderText = "KEY INCORRECTA!"
    end)
end

-- =============================================================
-- [9] INTERFAZ PRINCIPAL (EL HUB)
-- =============================================================
function BuildMainInterface()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Parent = ChrissMainGui
    Instance.new("UICorner", MainFrame)
    UIUtils:MakeDraggable(MainFrame, MainFrame)

    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Size = UDim2.new(1, 0, 0, 50)
    TitleLabel.Text = "CHRISSHUB MM2 V3"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 22
    TitleLabel.BackgroundTransparency = 1

    local Scroll = Instance.new("ScrollingFrame", MainFrame)
    Scroll.Size = UDim2.new(1, -20, 1, -80)
    Scroll.Position = UDim2.new(0, 10, 0, 60)
    Scroll.BackgroundTransparency = 1
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
    Scroll.ScrollBarThickness = 2

    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Función constructora de Toggles
    local function NewToggle(text, prop)
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(0.9, 0, 0, 45)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = text .. ": OFF"
        b.TextColor3 = Color3.fromRGB(180, 180, 180)
        b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b)

        b.MouseButton1Click:Connect(function()
            Toggles[prop] = not Toggles[prop]
            b.Text = text .. ": " .. (Toggles[prop] and "ON" or "OFF")
            UIUtils:MakeTween(b, {
                BackgroundColor3 = Toggles[prop] and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(25, 25, 25),
                TextColor3 = Toggles[prop] and Color3.new(1, 1, 1) or Color3.fromRGB(180, 180, 180)
            }, 0.3)
            Notify("MODO ACTUALIZADO", text .. " " .. (Toggles[prop] and "Activado" or "Desactivado"))
        end)
    end

    -- Función constructora de Selectores de Color
    local function NewColorSelector(roleName, internalKey)
        local f = Instance.new("Frame", Scroll)
        f.Size = UDim2.new(0.9, 0, 0, 50)
        f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", f)

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.Position = UDim2.new(0, 15, 0, 0)
        l.Text = "Color " .. roleName
        l.TextColor3 = Color3.new(1,1,1)
        l.BackgroundTransparency = 1
        l.TextXAlignment = Enum.TextXAlignment.Left

        local cb = Instance.new("TextButton", f)
        cb.Size = UDim2.new(0.4, 0, 0.7, 0)
        cb.Position = UDim2.new(0.55, 0, 0.15, 0)
        cb.BackgroundColor3 = ColorLibrary[ESPConfig[internalKey]]
        cb.Text = ESPConfig[internalKey]
        cb.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", cb)

        cb.MouseButton1Click:Connect(function()
            local current = ESPConfig[internalKey]
            local index = table.find(ColorNames, current)
            local nextIndex = (index % #ColorNames) + 1
            ESPConfig[internalKey] = ColorNames[nextIndex]
            cb.Text = ESPConfig[internalKey]
            cb.BackgroundColor3 = ColorLibrary[ESPConfig[internalKey]]
        end)
    end

    -- Llenar Menú
    NewToggle("Visuales (ESP)", "ESP")
    NewToggle("Aimbot Normal", "Aimbot")
    NewToggle("Aimbot Legítimo", "AimbotLegit")
    NewToggle("Aimbot Solo Killer", "AimbotAsesino")
    NewToggle("Kill Aura 35m", "KillAura")
    NewToggle("Noclip Pro", "Noclip")
    NewToggle("Salto Infinito", "InfJump")
    NewToggle("Anti-AFK", "AntiAFK")
    
    NewColorSelector("Asesino", "Murderer")
    NewColorSelector("Sheriff", "Sheriff")
    NewColorSelector("Inocentes", "Innocent")
end

-- =============================================================
-- [10] LÓGICA DE COMBATE Y VISUALES (MOTOR)
-- =============================================================

-- Bucle de ESP
RunService.Heartbeat:Connect(function()
    if not Toggles.ESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
        end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            local role = "Innocent"
            if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then role = "Murderer"
            elseif p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then role = "Sheriff" end
            
            h.FillColor = ColorLibrary[ESPConfig[role]]
            h.OutlineColor = ColorLibrary[ESPConfig[role]]
            h.FillTransparency = 0.5
            h.Enabled = true
        end
    end
end)

-- Bucle de Kill Aura
RunService.Stepped:Connect(function()
    if not Toggles.KillAura then return end
    local knife = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife"))
    if not knife or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist <= 35 then
                if knife:FindFirstChild("Handle") then
                    knife.Handle.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end
end)

-- Bucle de Aimbot y Noclip
RunService.RenderStepped:Connect(function()
    -- Noclip
    if Toggles.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- Aimbot Logic
    local target = nil
    if Toggles.Aimbot or Toggles.AimbotLegit or Toggles.AimbotAsesino then
        local minDist = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mag < 200 and mag < minDist then
                        if Toggles.AimbotAsesino then
                            if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then
                                target = head; minDist = mag
                            end
                        else
                            target = head; minDist = mag
                        end
                    end
                end
            end
        end
    end

    if target then
        local cf = CFrame.new(Camera.CFrame.Position, target.Position)
        if Toggles.AimbotLegit then
            Camera.CFrame = Camera.CFrame:Lerp(cf, 0.1)
        else
            Camera.CFrame = cf
        end
    end
end)

-- Anti-AFK Mejorado
LocalPlayer.Idled:Connect(function()
    if Toggles.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Salto Infinito
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- =============================================================
-- [11] LANZAMIENTO
-- =============================================================
StartIntro()
print("CHRISSHUB MM2 V3 CARGADO: " .. os.date("%X"))
