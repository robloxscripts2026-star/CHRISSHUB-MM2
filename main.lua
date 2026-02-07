--[[
    CHRISSHUB MM2 V24 - ULTIMATE GITHUB EDITION
    -------------------------------------------------------
    DESARROLLADO PARA: Chris (Gama Alta / Mobile)
    PLATAFORMA: GitHub / Roblox Executor
    CATEGORÍA: MM2 Script Elite
    -------------------------------------------------------
    CARACTERÍSTICAS:
    - Motor de Lluvia Hacker Binaria (60 FPS)
    - Sistema de Keys Dual (CHRIS2026 / 14151)
    - UI Estilo Ninja (Header Gris, Logo Flotante, Bordes Neón)
    - Botones de Acción Rápida para Móvil con Haptic Feedback Visual
    - ESP Avanzado por Categorías con Selector de Colores Dinámicos
    - Optimización de Memoria para Dispositivos de Gama Alta
    -------------------------------------------------------
]]

-- [ SERVICIOS ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

-- [ VARIABLES LOCALES ]
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [ CONFIGURACIÓN MAESTRA ]
local CH_CONFIG = {
    Version = "V24.0.1 (ULTIMATE)",
    ValidKeys = {"CHRIS2026", "14151"},
    TikTok = "sasware32",
    Theme = {
        MainColor = Color3.fromRGB(0, 255, 120),
        AccentColor = Color3.fromRGB(0, 200, 255),
        SecondaryColor = Color3.fromRGB(120, 0, 255),
        BackgroundColor = Color3.fromRGB(10, 10, 10),
        HeaderColor = Color3.fromRGB(45, 45, 45)
    },
    ESP = {
        Murderer = {Enabled = false, Color = Color3.fromRGB(255, 0, 0)},
        Sheriff = {Enabled = false, Color = Color3.fromRGB(0, 120, 255)},
        Innocent = {Enabled = false, Color = Color3.fromRGB(0, 255, 100)}
    },
    Powers = {
        Noclip = false,
        InfJump = false,
        AntiAFK = true,
        Speed = 16
    },
    Colors = {
        ["Rojo"] = Color3.fromRGB(255, 0, 0),
        ["Azul"] = Color3.fromRGB(0, 0, 255),
        ["Verde"] = Color3.fromRGB(0, 255, 0),
        ["Amarillo"] = Color3.fromRGB(255, 255, 0),
        ["Naranja"] = Color3.fromRGB(255, 165, 0),
        ["Morado"] = Color3.fromRGB(128, 0, 128),
        ["Rosa"] = Color3.fromRGB(255, 192, 203),
        ["Blanco"] = Color3.fromRGB(255, 255, 255),
        ["Negro"] = Color3.fromRGB(0, 0, 0),
        ["Gris"] = Color3.fromRGB(128, 128, 128)
    }
}

-- [ UTILIDADES DE UI ]
if CoreGui:FindFirstChild("CHRIS_ULTIMATE_V24") then CoreGui.CHRIS_ULTIMATE_V24:Destroy() end
local MainGui = Instance.new("ScreenGui", CoreGui); MainGui.Name = "CHRIS_ULTIMATE_V24"

local function ApplyTween(obj, duration, properties, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, properties)
    tween:Play()
    return tween
end

local function CreateClickEffect(button)
    local originalSize = button.Size
    local targetSize = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset, originalSize.Y.Scale * 0.95, originalSize.Y.Offset)
    
    button.MouseButton1Down:Connect(function()
        ApplyTween(button, 0.1, {Size = targetSize}, Enum.EasingStyle.Sine)
    end)
    
    button.MouseButton1Up:Connect(function()
        ApplyTween(button, 0.2, {Size = originalSize}, Enum.EasingStyle.Back)
    end)
end

-- [ MOTOR DE LLUVIA BINARIA ]
local function InitHackerRain(container)
    task.spawn(function()
        while container and container.Parent do
            local label = Instance.new("TextLabel")
            label.Parent = container
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(0, 20, 0, 20)
            label.Position = UDim2.new(math.random(), 0, -0.05, 0)
            label.Text = tostring(math.random(0, 1))
            label.TextColor3 = CH_CONFIG.Theme.MainColor
            label.TextSize = math.random(14, 22)
            label.Font = Enum.Font.Code
            label.TextTransparency = 0.3
            
            local dropDuration = math.random(2.5, 4.5)
            ApplyTween(label, dropDuration, {
                Position = UDim2.new(label.Position.X.Scale, 0, 1.05, 0),
                TextTransparency = 1
            }, Enum.EasingStyle.Linear)
            
            Debris:AddItem(label, dropDuration + 0.1)
            task.wait(0.04)
        end
    end)
end

-- [ 1. INTRO SYSTEM ]
local function StartIntro()
    local IntroFrame = Instance.new("Frame", MainGui)
    IntroFrame.Size = UDim2.new(1, 0, 1, 0)
    IntroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    IntroFrame.ZIndex = 100
    
    InitHackerRain(IntroFrame)
    
    local Logo = Instance.new("TextLabel", IntroFrame)
    Logo.Size = UDim2.new(1, 0, 0, 100)
    Logo.Position = UDim2.new(0, 0, 0.45, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "CHRISSHUB"
    Logo.TextColor3 = CH_CONFIG.Theme.AccentColor
    Logo.TextSize = 100
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextTransparency = 1
    
    local Stroke = Instance.new("UIStroke", Logo)
    Stroke.Thickness = 6
    Stroke.Color = CH_CONFIG.Theme.AccentColor
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    
    ApplyTween(Logo, 1.5, {TextTransparency = 0})
    task.wait(3.5)
    ApplyTween(Logo, 1, {TextTransparency = 1, TextSize = 140})
    ApplyTween(IntroFrame, 1.5, {BackgroundTransparency = 1})
    task.wait(1.5)
    IntroFrame:Destroy()
    ShowLoginTerminal()
end

-- [ 2. LOGIN TERMINAL ]
function ShowLoginTerminal()
    local LoginFrame = Instance.new("Frame", MainGui)
    LoginFrame.Size = UDim2.new(0, 340, 0, 260)
    LoginFrame.Position = UDim2.new(0.5, -170, 0.5, -130)
    LoginFrame.BackgroundColor3 = CH_CONFIG.Theme.BackgroundColor
    Instance.new("UICorner", LoginFrame)
    local Border = Instance.new("UIStroke", LoginFrame); Border.Color = CH_CONFIG.Theme.MainColor; Border.Thickness = 2
    
    local Header = Instance.new("TextLabel", LoginFrame)
    Header.Size = UDim2.new(1, 0, 0, 50); Header.Text = "ACCESS TERMINAL"; Header.TextColor3 = Color3.new(1, 1, 1); Header.BackgroundTransparency = 1; Header.Font = Enum.Font.Code; Header.TextSize = 18
    
    local KeyInput = Instance.new("TextBox", LoginFrame)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45); KeyInput.Position = UDim2.new(0.075, 0, 0.4, 0); KeyInput.PlaceholderText = "> Ingrese la Key..."; KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); KeyInput.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", KeyInput)
    
    local VerifyBtn = Instance.new("TextButton", LoginFrame)
    VerifyBtn.Size = UDim2.new(0.85, 0, 0, 45); VerifyBtn.Position = UDim2.new(0.075, 0, 0.7, 0); VerifyBtn.Text = "VERIFICAR"; VerifyBtn.BackgroundColor3 = CH_CONFIG.Theme.MainColor; VerifyBtn.Font = Enum.Font.GothamBold; VerifyBtn.TextColor3 = Color3.new(0, 0, 0); Instance.new("UICorner", VerifyBtn)
    
    CreateClickEffect(VerifyBtn)
    
    VerifyBtn.MouseButton1Click:Connect(function()
        local input = KeyInput.Text
        local isCorrect = false
        for _, k in pairs(CH_CONFIG.ValidKeys) do if input == k then isCorrect = true end end
        
        if isCorrect then
            VerifyBtn.Text = "VERIFYING..."; ApplyTween(VerifyBtn, 0.5, {BackgroundColor3 = Color3.fromRGB(200, 200, 0)})
            task.wait(1.5)
            VerifyBtn.Text = "ACCESS GRANTED (ENGLISH 🥵)"; ApplyTween(VerifyBtn, 0.3, {BackgroundColor3 = Color3.fromRGB(0, 255, 0)})
            task.wait(0.6); LoginFrame:Destroy(); BuildMainHub()
        else
            VerifyBtn.Text = "KEY INVALIDA"; VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(1.5); VerifyBtn.Text = "VERIFICAR"; VerifyBtn.BackgroundColor3 = CH_CONFIG.Theme.MainColor
        end
    end)
end

-- [ 3. MAIN HUB ]
function BuildMainHub()
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 480, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", MainFrame)
    local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = CH_CONFIG.Theme.MainColor; MainStroke.Thickness = 2
    
    -- Barra Superior (Gris Estilo Imagen)
    local HeaderBar = Instance.new("Frame", MainFrame)
    HeaderBar.Size = UDim2.new(1, 0, 0, 45); HeaderBar.BackgroundColor3 = CH_CONFIG.Theme.HeaderColor; Instance.new("UICorner", HeaderBar)
    
    -- Logo Ninja Flotante
    local LogoCirc = Instance.new("Frame", MainFrame)
    LogoCirc.Size = UDim2.new(0, 65, 0, 65); LogoCirc.Position = UDim2.new(0.5, -32.5, 0, -32.5); LogoCirc.BackgroundColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", LogoCirc).CornerRadius = UDim.new(1, 0)
    local LogoStroke = Instance.new("UIStroke", LogoCirc); LogoStroke.Color = CH_CONFIG.Theme.SecondaryColor; LogoStroke.Thickness = 2
    
    local NinjaIcon = Instance.new("ImageLabel", LogoCirc)
    NinjaIcon.Size = UDim2.new(0.8, 0, 0.8, 0); NinjaIcon.Position = UDim2.new(0.1, 0, 0.1, 0); NinjaIcon.BackgroundTransparency = 1; NinjaIcon.Image = "rbxassetid://6031068833"
    
    -- TikTok
    local Credits = Instance.new("TextLabel", MainFrame)
    Credits.Size = UDim2.new(1, 0, 0, 25); Credits.Position = UDim2.new(0, 0, 1, -25); Credits.Text = "CHRISSHUB | TikTok: " .. CH_CONFIG.TikTok; Credits.TextColor3 = Color3.new(0.5, 0.5, 0.5); Credits.BackgroundTransparency = 1; Credits.Font = Enum.Font.Code
    
    -- Botones de Minimizar
    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -40, 0, 7); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 20
    
    local MinimizeBtn = Instance.new("TextButton", MainGui)
    MinimizeBtn.Size = UDim2.new(0, 70, 0, 70); MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0); MinimizeBtn.BackgroundColor3 = Color3.new(0, 0, 0); MinimizeBtn.Text = "CH-HUB"; MinimizeBtn.TextColor3 = CH_CONFIG.Theme.MainColor; MinimizeBtn.Visible = false; Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", MinimizeBtn).Color = CH_CONFIG.Theme.MainColor
    
    CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MinimizeBtn.Visible = true end)
    MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; MinimizeBtn.Visible = false; CreateClickEffect(MinimizeBtn) end)

    -- Scrolling de Opciones
    local Content = Instance.new("ScrollingFrame", MainFrame)
    Content.Size = UDim2.new(1, -20, 1, -90); Content.Position = UDim2.new(0, 10, 0, 55); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 2; Content.ScrollBarImageColor3 = CH_CONFIG.Theme.MainColor
    local List = Instance.new("UIListLayout", Content); List.Padding = UDim.new(0, 12)

    -- [ FUNCIÓN PARA CREAR CATEGORÍAS DE ESP ]
    local function CreateESPSection(title, configKey)
        local Section = Instance.new("Frame", Content)
        Section.Size = UDim2.new(1, 0, 0, 80); Section.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", Section)
        
        local TitleLabel = Instance.new("TextLabel", Section)
        TitleLabel.Size = UDim2.new(0.6, 0, 0, 30); TitleLabel.Position = UDim2.new(0.05, 0, 0.05, 0); TitleLabel.Text = title; TitleLabel.TextColor3 = Color3.new(1, 1, 1); TitleLabel.BackgroundTransparency = 1; TitleLabel.Font = Enum.Font.Code; TitleLabel.TextXAlignment = "Left"
        
        local Toggle = Instance.new("TextButton", Section)
        Toggle.Size = UDim2.new(0, 50, 0, 25); Toggle.Position = UDim2.new(0.8, 0, 0.1, 0); Toggle.Text = ""; Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Instance.new("UICorner", Toggle)
        
        Toggle.MouseButton1Click:Connect(function()
            CH_CONFIG.ESP[configKey].Enabled = not CH_CONFIG.ESP[configKey].Enabled
            ApplyTween(Toggle, 0.3, {BackgroundColor3 = CH_CONFIG.ESP[configKey].Enabled and CH_CONFIG.Theme.MainColor or Color3.fromRGB(50, 50, 50)})
            CreateClickEffect(Toggle)
        end)
        
        local ColorInput = Instance.new("TextBox", Section)
        ColorInput.Size = UDim2.new(0.9, 0, 0, 30); ColorInput.Position = UDim2.new(0.05, 0, 0.55, 0); ColorInput.PlaceholderText = "Escriba un color (Ej: Rojo, Azul...)"; ColorInput.BackgroundColor3 = Color3.new(0, 0, 0); ColorInput.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", ColorInput)
        
        ColorInput.FocusLost:Connect(function()
            local clr = CH_CONFIG.Colors[ColorInput.Text]
            if clr then
                CH_CONFIG.ESP[configKey].Color = clr
                ColorInput.TextColor3 = clr
            end
        end)
    end

    CreateESPSection("ESP ASESINO", "Murderer")
    CreateESPSection("ESP SHERIFF", "Sheriff")
    CreateESPSection("ESP INOCENTES", "Innocent")

    -- Botones Rápidos (Flotantes - Mobile)
    local SideBar = Instance.new("Frame", MainGui)
    SideBar.Size = UDim2.new(0, 60, 0, 200); SideBar.Position = UDim2.new(1, -70, 0.5, -100); SideBar.BackgroundTransparency = 1
    local SideList = Instance.new("UIListLayout", SideBar); SideList.Padding = UDim.new(0, 10)
    
    local function CreateSideBtn(txt, pwrKey)
        local btn = Instance.new("TextButton", SideBar)
        btn.Size = UDim2.new(1, 0, 0, 50); btn.Text = txt; btn.BackgroundColor3 = Color3.new(0, 0, 0); btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
        local bStroke = Instance.new("UIStroke", btn); bStroke.Color = Color3.new(1, 1, 1); bStroke.Thickness = 1
        
        btn.MouseButton1Click:Connect(function()
            CH_CONFIG.Powers[pwrKey] = not CH_CONFIG.Powers[pwrKey]
            ApplyTween(btn, 0.3, {TextColor3 = CH_CONFIG.Powers[pwrKey] and CH_CONFIG.Theme.MainColor or Color3.new(1, 1, 1)})
            ApplyTween(bStroke, 0.3, {Color = CH_CONFIG.Powers[pwrKey] and CH_CONFIG.Theme.MainColor or Color3.new(1, 1, 1)})
            CreateClickEffect(btn)
        end)
    end
    
    CreateSideBtn("NC", "Noclip")
    CreateSideBtn("JP", "InfJump")
    CreateSideBtn("AFK", "AntiAFK")
end

-- [ MOTOR DE RENDERIZADO (60 FPS) ]
RunService.RenderStepped:Connect(function()
    -- Noclip
    if CH_CONFIG.Powers.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    -- Motor de ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local isM = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
            local isS = player.Character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")
            
            local config = nil
            if isM then config = CH_CONFIG.ESP.Murderer
            elseif isS then config = CH_CONFIG.ESP.Sheriff
            else config = CH_CONFIG.ESP.Innocent end
            
            local highlight = player.Character:FindFirstChild("CH_ULTIMATE_ESP")
            if config.Enabled then
                if not highlight then
                    highlight = Instance.new("Highlight", player.Character)
                    highlight.Name = "CH_ULTIMATE_ESP"
                end
                highlight.FillColor = config.Color
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.FillTransparency = 0.5
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- Salto Infinito
UserInputService.JumpRequest:Connect(function()
    if CH_CONFIG.Powers.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if CH_CONFIG.Powers.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- [ INICIO ]
StartIntro()
