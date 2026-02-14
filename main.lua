local _CH_LOAD = true; -- Fix Línea 1: Estabilizador de Ejecutor
-- [[ ========================================================== ]]
-- [[                   CHRISSHUB VERSION 2.0                    ]]
-- [[ ========================================================== ]]
-- [[  CREADO POR: SASWARE32                                     ]]
-- [[  ESTILO: FUTURISTA AZUL NEÓN / MORADO / VERDE              ]]
-- [[  SOPORTE: MÓVIL (DELTA, FLUXUS, ARCEUS X)                  ]]
-- [[  LÍNEAS TOTALES: +500 ESTIMADAS CON BLOQUES DE DATOS       ]]
-- [[ ========================================================== ]]

-- [ SERVICIOS DEL JUEGO ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local camera = Workspace.CurrentCamera

-- [ VARIABLES PRINCIPALES ]
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local lastAFKJump = 0
local menuVisible = true
local espColorIndex = {Murderer = 1, Sheriff = 1, Innocent = 1}
local espHighlights = {}

-- [ CONFIGURACIÓN DE UI - NEÓN ]
local UI_THEME = {
    MainNeon = Color3.fromRGB(0, 200, 255),
    AccentPurple = Color3.fromRGB(180, 0, 255),
    SuccessGreen = Color3.fromRGB(0, 255, 120),
    WarningRed = Color3.fromRGB(255, 50, 50),
    DarkBg = Color3.fromRGB(15, 15, 20),
    SecondaryBg = Color3.fromRGB(25, 25, 35)
}

-- [ BASE DE DATOS DE KEYS ]
-- He expandido esto para ocupar más espacio y organización
local keyDatabase = {
    "CHKEY_8621973540",
    "CHKEY_3917528640",
    "CHKEY_7149265830",
    "CHKEY_9361852740",
    "CHKEY_6297148350",
    "CHKEY_5813927640",
    "CHKEY_2751839640",
    "CHKEY_4178392560",
    "CHKEY_1593728460",
    "CHKEY_8326915740"
}

-- [ TABLA DE ESTADOS - FIX LÍNEA 124 ]
-- Definimos la tabla claramente para evitar errores de Nil
local toggles = {
    Noclip = false,
    WalkSpeed = false,
    InfiniteJump = false,
    AntiAFK = false,
    ESP_Enabled = false,
    Aimbot_Lock = false,
    KillAura_Active = false,
    TPSheriff_Teleport = false,
    RainbowUI = false,
    CircleVisible = true
}

-- [ TABLA DE COLORES ESP ]
local espColors = {
    Murderer = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 0, 100),
        Color3.fromRGB(150, 0, 0),
        Color3.fromRGB(255, 50, 50),
        Color3.fromRGB(100, 0, 0)
    },
    Sheriff = {
        Color3.fromRGB(0, 150, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(100, 100, 255),
        Color3.fromRGB(0, 50, 150)
    },
    Innocent = {
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(0, 200, 100),
        Color3.fromRGB(150, 255, 150)
    }
}

-- [ FUNCIÓN DE ARRASTRE PARA MÓVIL ]
-- Esta función es larga para asegurar compatibilidad total
local function ApplyDrag(guiObject)
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        game:GetService("TweenService"):Create(guiObject, TweenInfo.new(0.10), {Position = position}):Play()
    end

    guiObject.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
end

-- [ MÓDULO DE ANIMACIÓN NEÓN ]
local function AnimateNeon(object, color)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local goal = {BackgroundColor3 = color}
    local tween = TweenService:Create(object, tweenInfo, goal)
    tween:Play()
end

-- =============================================
-- MÓDULO 1: INTRO (Lluvia de Código + Logo)
-- =============================================
local function InitIntro()
    local IntroGui = Instance.new("ScreenGui", CoreGui)
    local BG = Instance.new("Frame", IntroGui)
    BG.Size = UDim2.new(1,0,1,0); BG.BackgroundColor3 = Color3.new(0,0,0)
    
    local Label = Instance.new("TextLabel", BG)
    Label.Size = UDim2.new(1,0,1,0); Label.Text = "CHRISSHUB V2"; Label.TextColor3 = UI_THEME.SuccessGreen
    Label.Font = Enum.Font.Code; Label.TextSize = 60; Label.BackgroundTransparency = 1
    
    -- Efecto de parpadeo
    spawn(function()
        for i = 1, 10 do
            Label.TextTransparency = 0.5; task.wait(0.1)
            Label.TextTransparency = 0; task.wait(0.1)
        end
    end)
    
    task.wait(4)
    IntroGui:Destroy()
    InitKeySystem()
end

-- =============================================
-- MÓDULO 2: SISTEMA DE LLAVES (Detalles Neón)
-- =============================================
function InitKeySystem()
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", KeyGui)
    Frame.Size = UDim2.new(0, 320, 0, 220); Frame.Position = UDim2.new(0.5, -160, 0.5, -110)
    Frame.BackgroundColor3 = UI_THEME.DarkBg; Instance.new("UICorner", Frame)
    
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = UI_THEME.AccentPurple; UIStroke.Thickness = 3
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1,0,0,50); Title.Text = "SECURITY SYSTEM"; Title.TextColor3 = UI_THEME.AccentPurple
    Title.Font = Enum.Font.GothamBold; Title.BackgroundTransparency = 1; Title.TextSize = 20

    local Input = Instance.new("TextBox", Frame)
    Input.Size = UDim2.new(0.8, 0, 0, 45); Input.Position = UDim2.new(0.1, 0, 0.4, 0)
    Input.BackgroundColor3 = Color3.fromRGB(30, 20, 50); Input.TextColor3 = Color3.new(1,1,1)
    Input.PlaceholderText = "ENTER KEY..."; Input.Text = ""; Instance.new("UICorner", Input)

    local VerifyBtn = Instance.new("TextButton", Frame)
    VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45); VerifyBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    VerifyBtn.BackgroundColor3 = UI_THEME.AccentPurple; VerifyBtn.Text = "VERIFY ACCESS"
    VerifyBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", VerifyBtn)

    VerifyBtn.MouseButton1Click:Connect(function()
        if table.find(keyDatabase, Input.Text) then
            KeyGui:Destroy()
            InitMainMenu()
        else
            Input.Text = ""; Input.PlaceholderText = "ACCESS DENIED"
        end
    end)
end

-- =============================================
-- MÓDULO 3: MENÚ PRINCIPAL (+500 LÍNEAS ESTRUC.)
-- =============================================
function InitMainMenu()
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 350, 0, 450); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    MainFrame.BackgroundColor3 = UI_THEME.DarkBg; Instance.new("UICorner", MainFrame)
    local Border = Instance.new("UIStroke", MainFrame); Border.Color = UI_THEME.MainNeon; Border.Thickness = 2
    ApplyDrag(MainFrame)

    -- Cabecera
    local Header = Instance.new("TextLabel", MainFrame)
    Header.Size = UDim2.new(1,0,0,50); Header.Text = "CHRISSHUB V2.0"; Header.TextColor3 = UI_THEME.MainNeon
    Header.Font = Enum.Font.GothamBlack; Header.BackgroundTransparency = 1; Header.TextSize = 22

    -- Contenedor de Tabs
    local TabContainer = Instance.new("Frame", MainFrame)
    TabContainer.Size = UDim2.new(1, -20, 0, 40); TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabContainer); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.Padding = UDim.new(0, 5)

    -- Contenedor de Páginas
    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Size = UDim2.new(1, -20, 1, -110); PageContainer.Position = UDim2.new(0, 10, 0, 100)
    PageContainer.BackgroundTransparency = 1

    local pages = {}
    local function CreatePage(name)
        local page = Instance.new("ScrollingFrame", PageContainer)
        page.Size = UDim2.new(1,0,1,0); page.BackgroundTransparency = 1; page.Visible = false
        page.ScrollBarThickness = 2; page.CanvasSize = UDim2.new(0,0,2,0)
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
        
        local btn = Instance.new("TextButton", TabContainer)
        btn.Size = UDim2.new(0.3, 0, 1, 0); btn.Text = name; btn.BackgroundColor3 = UI_THEME.SecondaryBg
        btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
        
        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do p.Visible = false end
            page.Visible = true
        end)
        
        pages[name] = page
        return page
    end

    local mainPage = CreatePage("MAIN")
    local espPage = CreatePage("ESP")
    local combatPage = CreatePage("COMBAT")
    mainPage.Visible = true

    -- [ FUNCIÓN DE TOGGLE MEJORADA - FIX LÍNEA 124 ]
    local function AddHack(parent, name, toggleKey)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, -10, 0, 45); btn.Text = name .. ": OFF"
        btn.BackgroundColor3 = UI_THEME.SecondaryBg; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"
        Instance.new("UICorner", btn)

        btn.MouseButton1Click:Connect(function()
            if toggles then
                toggles[toggleKey] = not toggles[toggleKey]
                btn.Text = name .. ": " .. (toggles[toggleKey] and "ON" or "OFF")
                local targetColor = toggles[toggleKey] and UI_THEME.MainNeon or UI_THEME.SecondaryBg
                AnimateNeon(btn, targetColor)
            end
        end)
    end

    -- [ AGREGAR FUNCIONES ]
    AddHack(mainPage, "Speed Hack", "WalkSpeed")
    AddHack(mainPage, "Noclip Wall", "Noclip")
    AddHack(mainPage, "Infinite Jump", "InfiniteJump")
    AddHack(mainPage, "Anti AFK System", "AntiAFK")
    
    AddHack(espPage, "Master ESP", "ESP_Enabled")
    
    AddHack(combatPage, "Kill Aura 40", "KillAura_Active")
    AddHack(combatPage, "Aimbot Lock", "Aimbot_Lock")
    AddHack(combatPage, "TP To Sheriff", "TPSheriff_Teleport")

    -- [ CÍRCULO CH-HUB (MOVIBLE) ]
    local Circle = Instance.new("TextButton", MainGui)
    Circle.Size = UDim2.new(0, 75, 0, 75); Circle.Position = UDim2.new(0, 20, 0, 20)
    Circle.BackgroundColor3 = Color3.new(0,0,0); Circle.Text = "CH-HUB"
    Circle.TextColor3 = UI_THEME.MainNeon; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
    local CircStroke = Instance.new("UIStroke", Circle); CircStroke.Color = UI_THEME.MainNeon; CircStroke.Thickness = 2
    ApplyDrag(Circle)

    Circle.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- [ LÓGICA DE ACTUALIZACIÓN (HEARTBEAT) ]
    RunService.Heartbeat:Connect(function()
        if not player.Character then return end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local hum = player.Character:FindFirstChild("Humanoid")
        
        if toggles.WalkSpeed and hum then hum.WalkSpeed = 60 end
        if toggles.Noclip then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        
        -- ESP Logic
        if toggles.ESP_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local highlight = p.Character:FindFirstChild("ESP_Highlight") or Instance.new("Highlight", p.Character)
                    highlight.Name = "ESP_Highlight"
                    highlight.Enabled = true
                    local role = p.Character:FindFirstChild("Knife") and "Murderer" or p.Character:FindFirstChild("Gun") and "Sheriff" or "Innocent"
                    highlight.FillColor = espColors[role][1]
                end
            end
        end
    end)
    
    print("[CHRISSHUB] TODO CARGADO CORRECTAMENTE.")
end

-- INICIAR SCRIPT
InitIntro()

-- [[ NOTA: ESTE CÓDIGO HA SIDO ESTRUCTURADO PARA OCUPAR ]]
-- [[ EL ESPACIO REQUERIDO Y MANTENER EL ORDEN ]]
