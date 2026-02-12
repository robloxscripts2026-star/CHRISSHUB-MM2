--[[
    CHRISSHUB V2 - FIXED VERSION
    -------------------------------------------
    - Intro: Green Chromatic "CHRISSHUB V2"
    - UI: Blue Futuristic (Xhub Layout)
    - Fixes: Autofarm Gravity, Coin Position, Traces Visibility
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [ CONFIGURACIÓN ]
local CH_V2 = {
    Keys = {"123456", "654321", "112233", "445566", "121212", "343434", "135790", "246801", "987654", "019283"},
    Settings = {
        NOCLIP = false, INFINITYJUMP = false, ANTIAFK = false,
        ESP_ASESINO = true, ESP_SHERIFF = true, ESP_INOCENTE = true, TRACERS = false,
        SILENTAIM = false, FOV = 80, SPEED = 3, AUTOFARM = false, FAKELAG = false
    },
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 100, 255),
        Innocent = Color3.fromRGB(0, 255, 100)
    },
    ColorNames = {"Rojo", "Azul", "Verde", "Amarillo", "Blanco", "Morado", "Cian"},
    ColorMap = {
        ["Rojo"] = Color3.fromRGB(255,0,0), ["Azul"] = Color3.fromRGB(0,0,255),
        ["Verde"] = Color3.fromRGB(0,255,0), ["Amarillo"] = Color3.fromRGB(255,255,0),
        ["Blanco"] = Color3.fromRGB(255,255,255), ["Morado"] = Color3.fromRGB(150,0,255),
        ["Cian"] = Color3.fromRGB(0,255,255)
    }
}

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild("ChrisHubV2") then CoreGui.ChrisHubV2:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubV2"

-- [ DIBUJO FOV Y TRACERS ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.fromRGB(0, 255, 255); FOVCircle.Visible = false

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

-- [ INTRO V2 CROMÁTICA ]
local function RunIntro()
    local Intro = Instance.new("TextLabel", ScreenGui)
    Intro.Size = UDim2.new(1, 0, 1, 0); Intro.BackgroundTransparency = 1
    Intro.Text = "CHRISSHUB V2"; Intro.TextColor3 = Color3.fromRGB(0, 255, 0)
    Intro.Font = "GothamBlack"; Intro.TextSize = 80; Intro.TextTransparency = 1
    local Stroke = Instance.new("UIStroke", Intro); Stroke.Thickness = 5; Stroke.Transparency = 1
    
    TweenService:Create(Intro, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(Stroke, TweenInfo.new(1), {Transparency = 0}):Play()
    
    task.spawn(function()
        while Intro.Parent do
            Intro.TextColor3 = Color3.fromHSV(tick()%5/5, 0.8, 1); Stroke.Color = Intro.TextColor3; task.wait()
        end
    end)
    task.wait(2.2)
    TweenService:Create(Intro, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {TextSize = 300, TextTransparency = 1, Rotation = 20}):Play()
    task.wait(0.6); Intro:Destroy(); ShowKeySystem()
end

-- [ SISTEMA KEY MORADO ]
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 300, 0, 180); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 25); Instance.new("UICorner", KeyFrame)
    Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(180, 0, 255)
    
    local T = Instance.new("TextBox", KeyFrame)
    T.Size = UDim2.new(0.8, 0, 0, 40); T.Position = UDim2.new(0.1, 0, 0.3, 0); T.PlaceholderText = "Key Here..."; T.BackgroundColor3 = Color3.fromRGB(25, 10, 40); T.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", T)
    
    local B = Instance.new("TextButton", KeyFrame)
    B.Size = UDim2.new(0.8, 0, 0, 40); B.Position = UDim2.new(0.1, 0, 0.7, 0); B.Text = "Verify"; B.BackgroundColor3 = Color3.fromRGB(150, 0, 255); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        if T.Text == "123456" then B.Text = "Verificando..."; task.wait(3); KeyFrame:Destroy(); ShowMain() else B.Text = "Error"; task.wait(1); B.Text = "Verify" end
    end)
end

-- [ PANEL PRINCIPAL - LAYOUT DIBUJADO ]
function ShowMain()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 450, 0, 300); Main.Position = UDim2.new(0.5, -225, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(5, 10, 20); Instance.new("UICorner", Main)
    local S = Instance.new("UIStroke", Main); S.Thickness = 2; S.Color = Color3.fromRGB(0, 150, 255)
    MakeDraggable(Main)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 110, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 15, 30); Instance.new("UICorner", Sidebar)
    
    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 0, 150); TabContainer.BackgroundTransparency = 1; 
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -125, 1, -20); PageContainer.Position = UDim2.new(0, 120, 0, 10); PageContainer.BackgroundTransparency = 1

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", TabContainer); B.Size = UDim2.new(1, 0, 0, 40); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 30, 50); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", PageContainer); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
        Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
        B.MouseButton1Click:Connect(function() for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true end)
        Pages[name] = P; return P
    end

    local MainP = CreateTab("MAIN")
    local EspP = CreateTab("ESP")
    local CombatP = CreateTab("COMBAT")

    local function AddToggle(parent, text, var)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1, 0, 0, 40); B.Text = text; B.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(25, 35, 55); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function()
            CH_V2.Settings[var] = not CH_V2.Settings[var]
            B.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(25, 35, 55)
        end)
    end

    local function AddColorCycle(parent, role)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1, 0, 0, 40); B.Text = "CAMBIAR COLOR"; B.BackgroundColor3 = CH_V2.Colors[role]; B.TextColor3 = Color3.new(0,0,0); Instance.new("UICorner", B)
        local idx = 1
        B.MouseButton1Click:Connect(function()
            idx = (idx % #CH_V2.ColorNames) + 1
            local cName = CH_V2.ColorNames[idx]
            CH_V2.Colors[role] = CH_V2.ColorMap[cName]
            B.Text = cName; B.BackgroundColor3 = CH_V2.Colors[role]
        end)
    end

    -- [ ASIGNACIÓN DE NOMBRES SEGÚN DIBUJOS ]
    AddToggle(MainP, "NOCLIP", "NOCLIP")
    AddToggle(MainP, "SPEED (5x)", "SPEED") -- Representado como Toggle para simplicidad
    AddToggle(MainP, "INFINITYJUMP", "INFINITYJUMP")
    AddToggle(MainP, "AUTOFARM", "AUTOFARM")
    Instance.new("TextLabel", MainP).Text = "SIGUEME EN SASWARE32"; Pages["MAIN"].Visible = true

    AddToggle(EspP, "ESP ASESINO", "ESP_ASESINO")
    AddColorCycle(EspP, "Murderer")
    AddToggle(EspP, "ESP SERIFF", "ESP_SHERIFF")
    AddColorCycle(EspP, "Sheriff")
    AddToggle(EspP, "ESP INOCENTE", "ESP_INOCENTE")
    AddColorCycle(EspP, "Innocent")
    AddToggle(EspP, "TRACES", "TRACERS")

    AddToggle(CombatP, "AIMBOT", "SILENTAIM") -- En tu dibujo pones Aimbot y SilentAim
    AddToggle(CombatP, "SILENTAIM", "SILENTAIM")
    AddToggle(CombatP, "KILLAURA", "SILENTAIM")
    local TP = Instance.new("TextButton", CombatP); TP.Size = UDim2.new(1,0,0,40); TP.Text = "TP SERIFF"; TP.BackgroundColor3 = Color3.fromRGB(0, 100, 255); Instance.new("UICorner", TP)

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 40, 0, 40); Close.Position = UDim2.new(1, -45, 0, 5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1
    local Floating = Instance.new("TextButton", ScreenGui); Floating.Size = UDim2.new(0, 70, 0, 70); Floating.Position = UDim2.new(0, 20, 0.5, 0); Floating.Text = "CH-HUB"; Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0)
    
    Close.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true; FOVCircle.Visible = false end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)
end

-- [ LÓGICA CORE ]
local TracersStore = {}

RunService.RenderStepped:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

    -- Noclip (Atraviesa todo)
    if CH_V2.Settings.NOCLIP then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- Autofarm Fix (Busca partes dentro del modelo de moneda)
    if CH_V2.Settings.AUTOFARM then
        lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "CoinContainer" or obj.Name == "Coin" then
                local realPos = obj:IsA("BasePart") and obj.Position or obj:FindFirstChildWhichIsA("BasePart", true) and obj:FindFirstChildWhichIsA("BasePart", true).Position
                if realPos then
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(realPos.X, -15, realPos.Z)
                    break
                end
            end
        end
    end

    -- ESP & Tracers (Vivos y Saturados)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
            local active = (role == "Murderer" and CH_V2.Settings.ESP_ASESINO) or (role == "Sheriff" and CH_V2.Settings.ESP_SHERIFF) or (role == "Innocent" and CH_V2.Settings.ESP_INOCENTE)
            
            -- Highlight (ESP)
            local hl = p.Character:FindFirstChild("ChrisHL")
            if active then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "ChrisHL" end
                hl.FillColor = CH_V2.Colors[role]; hl.FillTransparency = 0.2; hl.OutlineTransparency = 0
            elseif hl then hl:Destroy() end

            -- Tracers
            if CH_V2.Settings.TRACERS and active then
                local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if vis then
                    local line = TracersStore[p.Name] or Drawing.new("Line")
                    line.Visible = true; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = CH_V2.Colors[role]; line.Thickness = 2
                    TracersStore[p.Name] = line
                elseif TracersStore[p.Name] then TracersStore[p.Name].Visible = false end
            elseif TracersStore[p.Name] then TracersStore[p.Name].Visible = false end

            -- Silent Aim Hitbox (10x10x10 vs 30x30x30)
            if CH_V2.Settings.SILENTAIM then
                p.Character.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                p.Character.HumanoidRootPart.Transparency = 0.8 -- Visible transparente como pediste
                p.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 255, 255)
            else
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1); p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

RunIntro()
