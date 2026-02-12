--[[
    CHRISSHUB V2 - THE FUTURE OF MM2
    -------------------------------------------
    - Intro: Green Chromatic "CHRISSHUB V2"
    - Key System: Purple Neon
    - UI: Futuristic Blue/Cromático
    - Features: Under-map Autofarm, FOV Slider, Tracers, Config System
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [ CONFIGURACIÓN Y PERSISTENCIA ]
local CH_V2 = {
    Keys = {"123456", "654321", "112233", "445566", "121212", "343434", "135790", "246801", "987654", "019283"},
    Settings = {
        Noclip = false, InfJump = false, AntiAFK = false,
        ESP_M = true, ESP_S = true, ESP_I = true, Tracers = false,
        SilentAim = false, FOV = 80, FarmSpeed = 3, Autofarm = false,
        FakeLag = false
    },
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 150, 255),
        Innocent = Color3.fromRGB(0, 255, 100)
    }
}

-- Función para guardar config
local function SaveConfig()
    local success, err = pcall(function()
        writefile("ChrisHubV2_Config.json", HttpService:JSONEncode({Settings = CH_V2.Settings, Colors = {
            M = {CH_V2.Colors.Murderer.R, CH_V2.Colors.Murderer.G, CH_V2.Colors.Murderer.B},
            S = {CH_V2.Colors.Sheriff.R, CH_V2.Colors.Sheriff.G, CH_V2.Colors.Sheriff.B},
            I = {CH_V2.Colors.Innocent.R, CH_V2.Colors.Innocent.G, CH_V2.Colors.Innocent.B}
        }}))
    end)
end

-- [ ELEMENTOS VISUALES ]
if CoreGui:FindFirstChild("ChrisHubV2") then CoreGui.ChrisHubV2:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubV1"

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ INTRO V2 VERDE CROMÁTICO ]
local function RunIntro()
    local Intro = Instance.new("TextLabel", ScreenGui)
    Intro.Size = UDim2.new(1, 0, 1, 0); Intro.BackgroundTransparency = 1
    Intro.Text = "CHRISSHUB V2"; Intro.TextColor3 = Color3.fromRGB(0, 255, 100)
    Intro.Font = "GothamBlack"; Intro.TextSize = 85; Intro.TextTransparency = 1
    local Stroke = Instance.new("UIStroke", Intro); Stroke.Thickness = 6; Stroke.Transparency = 1

    TweenService:Create(Intro, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(Stroke, TweenInfo.new(1), {Transparency = 0}):Play()
    
    -- Efecto Cromático Verde
    task.spawn(function()
        local t = 0
        while Intro.Parent do
            t = t + 0.1
            local col = Color3.fromHSV((math.sin(t)/5 + 0.3), 0.8, 1) -- Variaciones de verde
            Intro.TextColor3 = col
            Stroke.Color = col
            task.wait(0.05)
        end
    end)

    task.wait(2.5)
    -- Animación Destrucción
    TweenService:Create(Intro, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {TextSize = 300, TextTransparency = 1, Rotation = 15}):Play()
    task.wait(0.7); Intro:Destroy(); ShowKeySystem()
end

-- [ SISTEMA KEY MORADO NEÓN ]
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 320, 0, 200); KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 15); Instance.new("UICorner", KeyFrame)
    local S = Instance.new("UIStroke", KeyFrame); S.Color = Color3.fromRGB(180, 0, 255); S.Thickness = 3
    
    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "Enter license"; Title.TextColor3 = Color3.fromRGB(200, 100, 255); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1
    
    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0.8, 0, 0, 40); Input.Position = UDim2.new(0.1, 0, 0.35, 0); Input.PlaceholderText = "License Key..."; Input.BackgroundColor3 = Color3.fromRGB(30, 20, 40); Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)
    
    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0.8, 0, 0, 40); Verify.Position = UDim2.new(0.1, 0, 0.7, 0); Verify.Text = "Verify Access"; Verify.BackgroundColor3 = Color3.fromRGB(150, 0, 255); Verify.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Verify)
    
    Verify.MouseButton1Click:Connect(function()
        local valid = false
        for _, k in pairs(CH_V2.Keys) do if Input.Text == k then valid = true end end
        if valid then
            Verify.Text = "Verifying License..."; task.wait(5)
            KeyFrame:Destroy(); ShowMain()
        else
            Verify.Text = "Invalid Key 🥵"; task.wait(1.5); Verify.Text = "Verify Access"
        end
    end)
end

-- [ MENU V2 AZUL CROMÁTICO ]
function ShowMain()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 350); Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(5, 10, 20); Instance.new("UICorner", Main)
    local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2
    MakeDraggable(Main)

    -- Animación Cromática de Borde (Azul/Cian)
    task.spawn(function()
        while Main.Parent do
            local t = tick()
            Stroke.Color = Color3.fromHSV((math.sin(t*0.5)*0.1 + 0.6), 0.8, 1)
            task.wait(0.05)
        end
    end)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 15, 30); Instance.new("UICorner", Sidebar)
    
    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -60); TabContainer.Position = UDim2.new(0, 0, 0, 10); TabContainer.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6); Instance.new("UIListLayout", TabContainer).HorizontalAlignment = "Center"

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -150, 1, -50); PageContainer.Position = UDim2.new(0, 140, 0, 15); PageContainer.BackgroundTransparency = 1

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", TabContainer); B.Size = UDim2.new(0.9, 0, 0, 38); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 30, 50); B.TextColor3 = Color3.new(0.8, 0.9, 1); Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", PageContainer); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 2; Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
        B.MouseButton1Click:Connect(function() for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true end)
        Pages[name] = P; return P
    end

    local MainPg = CreateTab("MAIN")
    local EspPg = CreateTab("ESP")
    local CombatPg = CreateTab("COMBAT")
    local ConfigPg = CreateTab("CONFIG")

    -- COMPONENTES V2
    local function AddToggle(parent, text, var)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundColor3 = Color3.fromRGB(15, 25, 45); Instance.new("UICorner", F)
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(0.7, 0, 1, 0); L.Position = UDim2.new(0, 12, 0, 0); L.Text = text; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"; L.Font = "Gotham"
        local T = Instance.new("TextButton", F); T.Size = UDim2.new(0, 44, 0, 22); T.Position = UDim2.new(1, -55, 0.5, -11); T.Text = ""; T.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 50, 70); Instance.new("UICorner", T).CornerRadius = UDim.new(1,0)
        
        T.MouseButton1Click:Connect(function()
            CH_V2.Settings[var] = not CH_V2.Settings[var]
            local goal = CH_V2.Settings[var] and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(40, 50, 70)
            TweenService:Create(T, TweenInfo.new(0.3), {BackgroundColor3 = goal}):Play()
            -- Animación de escala al activar
            T.Size = UDim2.new(0, 48, 0, 24); task.wait(0.1); T.Size = UDim2.new(0, 44, 0, 22)
        end)
    end

    local function AddSlider(parent, text, min, max, var)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 65); F.BackgroundColor3 = Color3.fromRGB(15, 25, 45); Instance.new("UICorner", F)
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 25); L.Position = UDim2.new(0, 12, 0, 5); L.Text = text .. ": " .. CH_V2.Settings[var]; L.TextColor3 = Color3.new(0.8,0.8,0.8); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
        local S = Instance.new("TextButton", F); S.Size = UDim2.new(0.9, 0, 0, 6); S.Position = UDim2.new(0.05, 0, 0.7, 0); S.BackgroundColor3 = Color3.fromRGB(40, 50, 70); S.Text = ""; Instance.new("UICorner", S)
        local Fill = Instance.new("Frame", S); Fill.Size = UDim2.new((CH_V2.Settings[var]-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Instance.new("UICorner", Fill)
        
        S.MouseButton1Click:Connect(function()
            local move = math.clamp((mouse.X - S.AbsolutePosition.X) / S.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * move)
            CH_V2.Settings[var] = val
            L.Text = text .. ": " .. val
            Fill.Size = UDim2.new(move, 0, 1, 0)
        end)
    end

    -- MAIN PAGE
    AddToggle(MainPg, "Noclip V2", "Noclip")
    AddToggle(MainPg, "Infinite Jump", "InfJump")
    AddToggle(MainPg, "Autofarm Subterráneo", "Autofarm")
    AddSlider(MainPg, "Velocidad Farm", 1, 5, "FarmSpeed")
    local TikTok = Instance.new("TextLabel", MainPg); TikTok.Size = UDim2.new(1,0,0,30); TikTok.Text = "TIKTOK @sasware32"; TikTok.TextColor3 = Color3.fromRGB(0,180,255); TikTok.BackgroundTransparency = 1

    -- ESP PAGE
    AddToggle(EspPg, "ESP Murderer", "ESP_M")
    AddToggle(EspPg, "ESP Sheriff", "ESP_S")
    AddToggle(EspPg, "ESP Innocent", "ESP_I")
    AddToggle(EspPg, "Tracers", "Tracers")

    -- COMBAT PAGE
    AddToggle(CombatPg, "Silent Aim", "SilentAim")
    AddSlider(CombatPg, "Rango FOV", 40, 180, "FOV")
    AddToggle(CombatPg, "Fake Lag", "FakeLag")

    -- CONFIG PAGE
    local SaveBtn = Instance.new("TextButton", ConfigPg); SaveBtn.Size = UDim2.new(1, 0, 0, 45); SaveBtn.Text = "SAVE SETTINGS"; SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); SaveBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SaveBtn)
    SaveBtn.MouseButton1Click:Connect(function() SaveConfig(); SaveBtn.Text = "SAVED! ✅"; task.wait(2); SaveBtn.Text = "SAVE SETTINGS" end)

    -- BOTONES FLOTANTES
    local CloseBtn = Instance.new("TextButton", Main); CloseBtn.Size = UDim2.new(0, 40, 0, 40); CloseBtn.Position = UDim2.new(1, -45, 0, 5); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,0,0); CloseBtn.BackgroundTransparency = 1; CloseBtn.TextSize = 24
    local Floating = Instance.new("TextButton", ScreenGui); Floating.Size = UDim2.new(0, 75, 0, 75); Floating.Position = UDim2.new(0.05, 0, 0.4, 0); Floating.BackgroundColor3 = Color3.new(0,0,0); Floating.Text = "CH-V2"; Floating.TextColor3 = Color3.fromRGB(0,200,255); Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Floating).Color = Color3.fromRGB(0,150,255); MakeDraggable(Floating)

    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true; FOVCircle.Visible = false end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)
    Pages["MAIN"].Visible = true
end

-- [ LÓGICA DE JUEGO MEJORADA ]
local function GetRole(p)
    if p.Character and p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character and p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

RunService.RenderStepped:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

    -- FOV Update
    FOVCircle.Visible = (CH_V2.Settings.SilentAim and ScreenGui:FindFirstChild("Frame") and ScreenGui.Frame.Visible) or CH_V2.Settings.SilentAim
    FOVCircle.Radius = CH_V2.Settings.FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()

    -- Noclip V2 (Mejorado)
    if CH_V2.Settings.Noclip then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then 
                v.CanCollide = false 
                if v.Name == "HumanoidRootPart" then v.Velocity = Vector3.new(0,0,0) end -- Evita rebote
            end
        end
    end

    -- Autofarm Subterráneo
    if CH_V2.Settings.Autofarm then
        lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        local farmY = -15 -- Altura bajo el mapa
        for _, coin in pairs(workspace:GetDescendants()) do
            if coin.Name == "CoinContainer" or coin.Name == "Coin" then
                local targetPos = coin.Position
                lp.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, farmY, targetPos.Z)
                task.wait(0.1 / CH_V2.Settings.FarmSpeed)
            end
        end
    end

    -- ESP & Tracers
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p)
            local char = p.Character
            local hl = char:FindFirstChild("ChrisESP_V2")
            local active = (role == "Murderer" and CH_V2.Settings.ESP_M) or (role == "Sheriff" and CH_V2.Settings.ESP_S) or (role == "Innocent" and CH_V2.Settings.ESP_I)
            
            if active then
                if not hl then hl = Instance.new("Highlight", char); hl.Name = "ChrisESP_V2"; hl.OutlineTransparency = 0 end
                hl.FillColor = CH_V2.Colors[role]
                hl.FillTransparency = 0.4 -- Más vivo
            elseif hl then hl:Destroy() end

            -- Silent Aim Hitbox
            if CH_V2.Settings.SilentAim then
                char.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                char.HumanoidRootPart.Transparency = 0.8
            else
                char.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                char.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

-- Fake Lag
task.spawn(function()
    while true do
        if CH_V2.Settings.FakeLag and lp.Character then
            lp.Character.HumanoidRootPart.Anchored = true
            task.wait(0.2)
            lp.Character.HumanoidRootPart.Anchored = false
        end
        task.wait(0.1)
    end
end)

RunIntro()
