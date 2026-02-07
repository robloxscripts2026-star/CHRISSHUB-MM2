--[[
    ██████╗██╗  ██╗██████╗ ██╗███████╗███████╗██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██║  ██║██╔══██╗██║██╔════╝██╔════╝██║  ██║██║   ██║██╔══██╗
    ██║     ███████║██████╔╝██║███████╗███████╗███████║██║   ██║██████╔╝
    ██║     ██╔══██║██╔══██╗██║╚════██║╚════██║██╔══██║██║   ██║██╔══██╗
    ╚██████╗██║  ██║██║  ██║██║███████║███████║██║  ██║╚██████╔╝██████╔╝
     ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    CHRISSHUB MM2 V3 - EDICIÓN FINAL COMPLETA (SIN LÍMITE DE LÍNEAS)
    Desarrollado para: GitHub / Comunidad MM2
    Características: UI Avanzada, Notificaciones, ESP Multi-Color, Aimbots, Combat.
]]

-- =============================================================
-- [1] SERVICIOS DEL NÚCLEO
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

-- =============================================================
-- [2] VARIABLES DE ENTORNO Y REFERENCIAS
-- =============================================================
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- =============================================================
-- [3] DICCIONARIO MAESTRO DE COLORES (20 OPCIONES)
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
-- [4] SISTEMA DE ESTADOS (TOGGLES)
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
    ShowMenu = true
}

local ESPConfig = {
    Murderer = "Rojo",
    Sheriff = "Azul marino",
    Innocent = "Verde lima",
    Highlights = {}
}

local ValidKeys = {"482916", "731592", "264831", "917542", "358269", "621973", "845137"}
local IsAuthenticated = false

-- =============================================================
-- [5] LIBRERÍA DE UTILIDADES (TWEENS Y UI)
-- =============================================================
local UIUtils = {}

function UIUtils:ApplyTween(Instance, Properties, Duration)
    local Info = TweenInfo.new(Duration or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(Instance, Info, Properties)
    Tween:Play()
    return Tween
end

function UIUtils:CreateShadow(Parent)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = Parent.ZIndex - 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = Parent
end

-- =============================================================
-- [6] INTERFAZ DE INTRODUCCIÓN (HACKER STYLE)
-- =============================================================
local function ShowHackerIntro()
    local IntroScreen = Instance.new("ScreenGui")
    IntroScreen.Name = "ChrissHub_Intro"
    IntroScreen.Parent = CoreGui

    local Blackout = Instance.new("Frame")
    Blackout.Size = UDim2.new(1, 0, 1, 0)
    Blackout.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Blackout.Parent = IntroScreen

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 100)
    Title.Position = UDim2.new(0, 0, 0.45, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "INICIALIZANDO CHRISSHUB V3..."
    Title.TextColor3 = Color3.fromRGB(0, 255, 120)
    Title.Font = Enum.Font.Code
    Title.TextSize = 40
    Title.Parent = Blackout

    -- Generador de lluvia de código
    task.spawn(function()
        for i = 1, 100 do
            local Line = Instance.new("TextLabel")
            Line.Size = UDim2.new(0, 150, 0, 20)
            Line.Position = UDim2.new(math.random(), 0, -0.1, 0)
            Line.BackgroundTransparency = 1
            Line.Text = "DECRYPTING_" .. tostring(math.random(1000, 9999))
            Line.TextColor3 = Color3.fromRGB(0, 150, 80)
            Line.Font = Enum.Font.Code
            Line.TextSize = 14
            Line.Parent = Blackout
            
            local Speed = math.random(2, 5)
            UIUtils:ApplyTween(Line, {Position = UDim2.new(Line.Position.X.Scale, 0, 1.1, 0)}, Speed)
            Debris:AddItem(Line, Speed)
            task.wait(0.05)
        end
    end)

    task.wait(4)
    UIUtils:ApplyTween(Title, {TextTransparency = 1}, 1)
    UIUtils:ApplyTween(Blackout, {BackgroundTransparency = 1}, 1.5)
    task.wait(1.5)
    IntroScreen:Destroy()
end

-- =============================================================
-- [7] SISTEMA DE AUTENTICACIÓN (KEY SYSTEM)
-- =============================================
local function ShowKeySystem()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "ChrissHub_KeySystem"
    KeyGui.Parent = CoreGui

    local MainKeyFrame = Instance.new("Frame")
    MainKeyFrame.Size = UDim2.new(0, 350, 0, 220)
    MainKeyFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    MainKeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainKeyFrame.BorderSizePixel = 0
    MainKeyFrame.Parent = KeyGui
    Instance.new("UICorner", MainKeyFrame).CornerRadius = UDim.new(0, 10)
    UIUtils:CreateShadow(MainKeyFrame)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 50)
    KeyTitle.Text = "VERIFICACIÓN REQUERIDA"
    KeyTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.TextSize = 18
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Parent = MainKeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.PlaceholderText = "Ingresa tu llave..."
    KeyInput.Text = ""
    KeyInput.Parent = MainKeyFrame
    Instance.new("UICorner", KeyInput)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45)
    VerifyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    VerifyBtn.Text = "VERIFICAR ACCESO"
    VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 14
    VerifyBtn.Parent = MainKeyFrame
    Instance.new("UICorner", VerifyBtn)

    VerifyBtn.MouseButton1Click:Connect(function()
        for _, Key in ipairs(ValidKeys) do
            if KeyInput.Text == Key then
                IsAuthenticated = true
                KeyGui:Destroy()
                InitializeMainHub()
                return
            end
        end
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "LLAVE INVÁLIDA"
        task.wait(1.5)
        KeyInput.PlaceholderText = "Ingresa tu llave..."
    end)
end

-- =============================================================
-- [8] INICIALIZACIÓN DEL HUB PRINCIPAL
-- =============================================================
function InitializeMainHub()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "ChrissHub_Main"
    MainGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = MainGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    UIUtils:CreateShadow(MainFrame)
    
    -- Dragging Logic
    local Dragging, DragInput, DragStart, StartPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    -- Título y TikTok
    local HubTitle = Instance.new("TextLabel")
    HubTitle.Size = UDim2.new(1, 0, 0, 50)
    HubTitle.Text = "CHRISSHUB MM2 V3"
    HubTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
    HubTitle.Font = Enum.Font.GothamBlack
    HubTitle.TextSize = 22
    HubTitle.BackgroundTransparency = 1
    HubTitle.Parent = MainFrame

    local SocialLabel = Instance.new("TextLabel")
    SocialLabel.Size = UDim2.new(1, 0, 0, 20)
    SocialLabel.Position = UDim2.new(0, 0, 0, 45)
    SocialLabel.Text = "TikTok: sasware32 | Sin Límites"
    SocialLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SocialLabel.Font = Enum.Font.Gotham
    SocialLabel.TextSize = 12
    SocialLabel.BackgroundTransparency = 1
    SocialLabel.Parent = MainFrame

    -- Scrolling Frame para funciones
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -20, 1, -100)
    Scroll.Position = UDim2.new(0, 10, 0, 80)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 950)
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
    Scroll.Parent = MainFrame

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 10)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    List.Parent = Scroll

    -- Generador de Botones (Toggle)
    local function CreateButton(Name, Prop)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.9, 0, 0, 45)
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Btn.Text = Name .. ": OFF"
        Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 14
        Btn.Parent = Scroll
        Instance.new("UICorner", Btn)

        Btn.MouseButton1Click:Connect(function()
            Toggles[Prop] = not Toggles[Prop]
            local Active = Toggles[Prop]
            Btn.Text = Name .. ": " .. (Active and "ON" or "OFF")
            UIUtils:ApplyTween(Btn, {
                BackgroundColor3 = Active and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(25, 25, 25),
                TextColor3 = Active and Color3.new(1,1,1) or Color3.fromRGB(200, 200, 200)
            })
        end)
    end

    -- Generador de Selectores de Color
    local function CreateColorPicker(Role, InternalKey)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0.9, 0, 0, 50)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Frame.Parent = Scroll
        Instance.new("UICorner", Frame)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 1, 0)
        Label.Position = UDim2.new(0.05, 0, 0, 0)
        Label.Text = "Color " .. Role
        Label.TextColor3 = Color3.new(1,1,1)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Frame

        local ColorBtn = Instance.new("TextButton")
        ColorBtn.Size = UDim2.new(0.4, 0, 0.7, 0)
        ColorBtn.Position = UDim2.new(0.55, 0, 0.15, 0)
        ColorBtn.BackgroundColor3 = ColorLibrary[ESPConfig[InternalKey]]
        ColorBtn.Text = ESPConfig[InternalKey]
        ColorBtn.Font = Enum.Font.GothamBold
        ColorBtn.TextSize = 12
        ColorBtn.TextColor3 = Color3.new(1,1,1)
        ColorBtn.Parent = Frame
        Instance.new("UICorner", ColorBtn)

        ColorBtn.MouseButton1Click:Connect(function()
            local Current = ESPConfig[InternalKey]
            local Index = table.find(ColorNames, Current)
            local NextIndex = (Index % #ColorNames) + 1
            local NewColor = ColorNames[NextIndex]
            
            ESPConfig[InternalKey] = NewColor
            ColorBtn.Text = NewColor
            ColorBtn.BackgroundColor3 = ColorLibrary[NewColor]
        end)
    end

    -- Agregar Elementos al Scroll
    CreateButton("Visuales ESP", "ESP")
    CreateButton("Aimbot Normal", "Aimbot")
    CreateButton("Aimbot Legítimo", "AimbotLegit")
    CreateButton("Aimbot (Focus Asesino)", "AimbotAsesino")
    CreateButton("Kill Aura (35 Studs)", "KillAura")
    CreateButton("Noclip Pro", "Noclip")
    CreateButton("Salto Infinito", "InfJump")
    CreateButton("Anti-AFK System", "AntiAFK")
    
    Instance.new("Frame", Scroll).Size = UDim2.new(1,0,0,10) -- Espaciador
    
    CreateColorPicker("Asesino", "Murderer")
    CreateColorPicker("Sheriff", "Sheriff")
    CreateColorPicker("Inocente", "Innocent")
end

-- =============================================================
-- [9] MOTORES FUNCIONALES (LÓGICA DE JUEGO)
-- =============================================================

-- Motor de ESP
local function UpdateESP()
    for _, Plr in ipairs(Players:GetPlayers()) do
        if Plr ~= LocalPlayer then
            local Char = Plr.Character
            if Char then
                local Highlight = Char:FindFirstChild("ChrissHighlight") or Instance.new("Highlight")
                Highlight.Name = "ChrissHighlight"
                Highlight.Parent = Char
                
                if Toggles.ESP then
                    local Role = "Innocent"
                    if Char:FindFirstChild("Knife") or Plr.Backpack:FindFirstChild("Knife") then Role = "Murderer"
                    elseif Char:FindFirstChild("Gun") or Plr.Backpack:FindFirstChild("Gun") then Role = "Sheriff" end
                    
                    Highlight.Enabled = true
                    Highlight.FillColor = ColorLibrary[ESPConfig[Role]]
                    Highlight.OutlineColor = ColorLibrary[ESPConfig[Role]]
                    Highlight.FillTransparency = 0.5
                else
                    Highlight.Enabled = false
                end
            end
        end
    end
end

-- Motor de Aimbot
local function GetAimbotTarget(Mode)
    local Target = nil
    local MaxDist = math.huge
    
    for _, Plr in ipairs(Players:GetPlayers()) do
        if Plr ~= LocalPlayer and Plr.Character and Plr.Character:FindFirstChild("Head") then
            local Head = Plr.Character.Head
            local Pos, OnScreen = Camera:WorldToViewportPoint(Head.Position)
            
            if OnScreen then
                local Mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
                if Mag < 150 and Mag < MaxDist then
                    if Mode == "Asesino" then
                        if Plr.Character:FindFirstChild("Knife") or Plr.Backpack:FindFirstChild("Knife") then
                            Target = Head
                            MaxDist = Mag
                        end
                    else
                        Target = Head
                        MaxDist = Mag
                    end
                end
            end
        end
    end
    return Target
end

-- Loop de ejecución (Heartbeat para máxima precisión)
RunService.Heartbeat:Connect(function()
    UpdateESP()
    
    -- Kill Aura
    if Toggles.KillAura and LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")) then
        for _, Plr in ipairs(Players:GetPlayers()) do
            if Plr ~= LocalPlayer and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
                local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - Plr.Character.HumanoidRootPart.Position).Magnitude
                if Dist <= 35 then
                    local Knife = LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                    if Knife and Knife:FindFirstChild("Handle") then
                        Knife.Handle.CFrame = Plr.Character.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end

    -- Noclip
    if Toggles.Noclip and LocalPlayer.Character then
        for _, Part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if Part:IsA("BasePart") then Part.CanCollide = false end
        end
    end

    -- Anti-AFK
    if Toggles.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Aimbot Render Loop
RunService.RenderStepped:Connect(function()
    local ActiveMode = nil
    if Toggles.Aimbot then ActiveMode = "Normal"
    elseif Toggles.AimbotLegit then ActiveMode = "Legit"
    elseif Toggles.AimbotAsesino then ActiveMode = "Asesino" end
    
    if ActiveMode then
        local Target = GetAimbotTarget(ActiveMode)
        if Target then
            if ActiveMode == "Legit" then
                UIUtils:ApplyTween(Camera, {CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)}, 0.1)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
            end
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            
