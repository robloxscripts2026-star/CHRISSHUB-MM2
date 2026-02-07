--[[
    CHRISSHUB MM2 V3 - SUPREMACY EDITION
    GitHub: CHRISSHUB/MM2_V3
    Fix: Categorized UI & Clean Intro
]]

-- =============================================================
-- [1] INICIALIZACIÓN Y SERVICIOS
-- =============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Contenedor Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrissHub_Official"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =============================================================
-- [2] CONFIGURACIÓN MAESTRA
-- =============================================================
local Toggles = {
    ESP = false,
    Aimbot = false,
    AimbotLegit = false,
    AimbotMurder = false,
    KillAura = false,
    Noclip = false,
    InfJump = false,
    AntiAFK = false
}

local ESPConfig = {
    MurdererColor = Color3.fromRGB(255, 0, 0),       -- Rojo
    SheriffColor = Color3.fromRGB(0, 0, 128),        -- Azul Marino
    InnocentColor = Color3.fromRGB(50, 205, 50)      -- Verde Lima
}

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

local ColorNames = {"Rojo", "Naranja", "Amarillo", "Verde lima", "Verde bosque", "Azul cielo", "Azul marino", "Azul eléctrico", "Morado", "Lila", "Rosa", "Rosa fucsia", "Marrón", "Café claro", "Negro", "Blanco", "Gris", "Gris claro", "Turquesa", "Beige"}
local ValidKeys = {"482916", "731592", "264831"}

-- =============================================================
-- [3] LÓGICA DE INTERFAZ (UI UTILS)
-- =============================================================
local function CreateTween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart), props):Play()
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- =============================================================
-- [4] INTRO SIN FONDO NEGRO
-- =============================================================
local function RunIntro()
    local IntroText = Instance.new("TextLabel")
    IntroText.Size = UDim2.new(0, 400, 0, 50)
    IntroText.Position = UDim2.new(0.5, -200, 0.45, 0)
    IntroText.BackgroundTransparency = 1
    IntroText.Text = "CHRISSHUB V3 LOADING..."
    IntroText.TextColor3 = Color3.fromRGB(0, 255, 120)
    IntroText.Font = Enum.Font.Code
    IntroText.TextSize = 30
    IntroText.TextTransparency = 1
    IntroText.Parent = ScreenGui

    CreateTween(IntroText, {TextTransparency = 0, Position = UDim2.new(0.5, -200, 0.4, 0)}, 1)
    task.wait(2)
    CreateTween(IntroText, {TextTransparency = 1}, 1)
    task.wait(1)
    IntroText:Destroy()
    ShowKeySystem()
end

-- =============================================================
-- [5] KEY SYSTEM (VERIFYING KEY...)
-- =============================================================
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 300, 0, 150)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    KeyFrame.Parent = ScreenGui
    Instance.new("UICorner", KeyFrame)

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0.8, 0, 0, 40)
    Input.Position = UDim2.new(0.1, 0, 0.2, 0)
    Input.PlaceholderText = "Enter Key"
    Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Input.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Input)

    local Btn = Instance.new("TextButton", KeyFrame)
    Btn.Size = UDim2.new(0.8, 0, 0, 40)
    Btn.Position = UDim2.new(0.1, 0, 0.6, 0)
    Btn.Text = "SUBMIT"
    Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, k in pairs(ValidKeys) do
            if Input.Text == k then
                Btn.Text = "Verifying Key..."
                Btn.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
                task.wait(1.5)
                KeyFrame:Destroy()
                BuildMainHub()
                return
            end
        end
        Input.Text = "INVALID KEY"
        task.wait(1)
        Input.Text = ""
    end)
end

-- =============================================================
-- [6] BUILD MAIN HUB (POR APARTADOS)
-- =============================================================
function BuildMainHub()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame)
    MakeDraggable(MainFrame, MainFrame)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Sidebar)

    local Content = Instance.new("ScrollingFrame", MainFrame)
    Content.Size = UDim2.new(1, -170, 1, -20)
    Content.Position = UDim2.new(0, 160, 0, 10)
    Content.BackgroundTransparency = 1
    Content.CanvasSize = UDim2.new(0,0,0,1000)
    Content.ScrollBarThickness = 2

    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0, 10)

    -- Función para Títulos de Apartado
    local function AddHeader(txt)
        local h = Instance.new("TextLabel", Content)
        h.Size = UDim2.new(1, 0, 0, 30)
        h.Text = "--- " .. txt .. " ---"
        h.TextColor3 = Color3.fromRGB(0, 255, 120)
        h.Font = Enum.Font.GothamBold
        h.BackgroundTransparency = 1
    end

    -- Función para Toggles
    local function AddToggle(txt, prop)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(0.9, 0, 0, 40)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = txt .. ": OFF"
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)

        b.MouseButton1Click:Connect(function()
            Toggles[prop] = not Toggles[prop]
            b.Text = txt .. ": " .. (Toggles[prop] and "ON" or "OFF")
            b.BackgroundColor3 = Toggles[prop] and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(25, 25, 25)
        end)
    end

    -- Función para Selectores de Color
    local function AddColorESP(role, configKey)
        local f = Instance.new("Frame", Content)
        f.Size = UDim2.new(0.9, 0, 0, 40)
        f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", f)

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.Text = "ESP " .. role
        l.TextColor3 = Color3.new(1,1,1)
        l.BackgroundTransparency = 1

        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0.4, 0, 0.8, 0)
        b.Position = UDim2.new(0.55, 0, 0.1, 0)
        b.BackgroundColor3 = ESPConfig[configKey]
        b.Text = "Cambiar"
        Instance.new("UICorner", b)

        b.MouseButton1Click:Connect(function()
            local current = ""
            for name, color in pairs(ColorLibrary) do
                if color == ESPConfig[configKey] then current = name end
            end
            local nextIdx = (table.find(ColorNames, current) or 1) % #ColorNames + 1
            ESPConfig[configKey] = ColorLibrary[ColorNames[nextIdx]]
            b.BackgroundColor3 = ESPConfig[configKey]
        end)
    end

    -- [APARTADO MAIN]
    AddHeader("MAIN")
    AddToggle("Noclip", "Noclip")
    AddToggle("Inf Jump", "InfJump")
    AddToggle("Anti AFK", "AntiAFK")
    local tt = Instance.new("TextLabel", Content)
    tt.Size = UDim2.new(1,0,0,20); tt.Text = "TikTok: sasware32"; tt.TextColor3 = Color3.new(0.5,0.5,0.5); tt.BackgroundTransparency = 1

    -- [APARTADO ESP]
    AddHeader("ESP")
    AddToggle("Activar Visuales", "ESP")
    AddColorESP("Asesino", "MurdererColor")
    AddColorESP("Sheriff", "SheriffColor")
    AddColorESP("Inocente", "InnocentColor")

    -- [APARTADO COMBAT]
    AddHeader("COMBAT")
    local maint = Instance.new("TextLabel", Content)
    maint.Size = UDim2.new(1,0,0,30); maint.Text = "Silent Aim (Mantenimiento)"; maint.TextColor3 = Color3.new(1,0,0); maint.BackgroundTransparency = 1
    AddToggle("Aimbot", "Aimbot")
    AddToggle("Aimbot Legit", "AimbotLegit")
    AddToggle("Aimbot Murder", "AimbotMurder")
end

-- =============================================================
-- [7] MOTORES LÓGICOS (SIN CAMBIOS PARA QUE NO FALLE)
-- =============================================================
RunService.Heartbeat:Connect(function()
    if Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                h.FillColor = isM and ESPConfig.MurdererColor or (isS and ESPConfig.SheriffColor or ESPConfig.InnocentColor)
                h.Enabled = true
            end
        end
    end
    if Toggles.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Ejecutar
RunIntro()
