--[[
    CHRISSHUB V2 - PREEMINENT EDITION
    -------------------------------------------
    - UI: Compact, Organized, Modern (Blue/Neon)
    - Fixes: Gravity, Coin Models, Menu Visibility
    - New: Animations, Fixed Tracers, Floating Button
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
    Keys = {"482957", "859326", "295714", "963085", "159372", "628491", "307589", "741963", "518230", "036148"},
    Settings = {
        NOCLIP = false, INFINITYJUMP = false, AUTOFARM = false,
        ESP_ASESINO = false, ESP_SHERIFF = false, ESP_INOCENTE = false, TRACES = false,
        SILENTAIM = false, FOV = 100, KILLAURA = false
    },
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 150, 255),
        Innocent = Color3.fromRGB(0, 255, 100)
    },
    ColorList = {
        {Name = "Rojo", Color = Color3.fromRGB(255, 0, 0)},
        {Name = "Verde", Color = Color3.fromRGB(0, 255, 0)},
        {Name = "Azul", Color = Color3.fromRGB(0, 0, 255)},
        {Name = "Amarillo", Color = Color3.fromRGB(255, 255, 0)},
        {Name = "Cian", Color = Color3.fromRGB(0, 255, 255)},
        {Name = "Magenta", Color = Color3.fromRGB(255, 0, 255)},
        {Name = "Blanco", Color = Color3.fromRGB(255, 255, 255)},
        {Name = "Oro", Color = Color3.fromRGB(255, 215, 0)},
        {Name = "Naranja", Color = Color3.fromRGB(255, 165, 0)},
        {Name = "Violeta", Color = Color3.fromRGB(238, 130, 238)}
    }
}

-- [ UI ELEMENTS ]
if CoreGui:FindFirstChild("ChrisHubV2") then CoreGui.ChrisHubV2:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubV2"

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

-- [ INTRO V2 ]
local function RunIntro()
    local Intro = Instance.new("TextLabel", ScreenGui)
    Intro.Size = UDim2.new(1, 0, 1, 0); Intro.BackgroundTransparency = 1; Intro.Text = "CHRISSHUB V2"; Intro.TextColor3 = Color3.fromRGB(0, 255, 0); Intro.Font = "GothamBlack"; Intro.TextSize = 80; Intro.TextTransparency = 1
    local Stroke = Instance.new("UIStroke", Intro); Stroke.Thickness = 5; Stroke.Transparency = 1
    TweenService:Create(Intro, TweenInfo.new(0.8), {TextTransparency = 0}):Play(); TweenService:Create(Stroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
    task.spawn(function() while Intro.Parent do Intro.TextColor3 = Color3.fromHSV(tick()%5/5, 0.8, 1); Stroke.Color = Intro.TextColor3; task.wait() end end)
    task.wait(2); TweenService:Create(Intro, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {TextSize = 400, TextTransparency = 1}):Play(); task.wait(0.5); Intro:Destroy(); ShowKeySystem()
end

-- [ KEY SYSTEM ]
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size = UDim2.new(0, 300, 0, 180); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25); Instance.new("UICorner", KeyFrame); Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(180, 0, 255)
    local Input = Instance.new("TextBox", KeyFrame); Input.Size = UDim2.new(0.8, 0, 0, 40); Input.Position = UDim2.new(0.1, 0, 0.3, 0); Input.PlaceholderText = "Ingrese Key..."; Input.BackgroundColor3 = Color3.fromRGB(25, 20, 40); Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)
    local Verify = Instance.new("TextButton", KeyFrame); Verify.Size = UDim2.new(0.8, 0, 0, 40); Verify.Position = UDim2.new(0.1, 0, 0.7, 0); Verify.Text = "VERIFICAR"; Verify.BackgroundColor3 = Color3.fromRGB(150, 0, 255); Verify.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Verify)
    Verify.MouseButton1Click:Connect(function()
        for _, k in pairs(CH_V2.Keys) do if Input.Text == k then KeyFrame:Destroy(); ShowMain() return end end
        Verify.Text = "KEY INCORRECTA"; task.wait(1); Verify.Text = "VERIFICAR"
    end)
end

-- [ MAIN MENU COMPACT ]
function ShowMain()
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 420, 0, 320); Main.Position = UDim2.new(0.5, -210, 0.5, -160); Main.BackgroundColor3 = Color3.fromRGB(10, 12, 18); Instance.new("UICorner", Main); local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 180, 255); Stroke.Thickness = 2; MakeDraggable(Main)
    
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 100, 1, -40); Sidebar.Position = UDim2.new(0, 10, 0, 30); Sidebar.BackgroundTransparency = 1
    local List = Instance.new("UIListLayout", Sidebar); List.Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame", Main); PageContainer.Size = UDim2.new(1, -130, 1, -50); PageContainer.Position = UDim2.new(0, 120, 0, 40); PageContainer.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = "CHRISSHUB V2"; Title.TextColor3 = Color3.fromRGB(0, 200, 255); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, 0, 0, 35); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 25, 35); B.TextColor3 = Color3.new(0.7,0.7,0.7); Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", PageContainer); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 2; Instance.new("UIListLayout", P).Padding = UDim.new(0, 6)
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
            for _, btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.new(0.5,0.5,0.5) end end
            B.TextColor3 = Color3.new(1,1,1)
        end)
        Pages[name] = P; return P
    end

    local MainP = CreateTab("PRINCIPAL"); local EspP = CreateTab("VISUAL"); local CombatP = CreateTab("COMBATE")

    -- COMPONENTES OPTIMIZADOS
    local function AddToggle(parent, text, var)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1, -10, 0, 38); B.Text = text; B.BackgroundColor3 = Color3.fromRGB(25, 30, 45); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        local Indicator = Instance.new("Frame", B); Indicator.Size = UDim2.new(0, 4, 1, 0); Indicator.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 0, 50); Instance.new("UICorner", Indicator)
        B.MouseButton1Click:Connect(function()
            CH_V2.Settings[var] = not CH_V2.Settings[var]
            Indicator.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 0, 50)
            -- Animación
            B.Size = UDim2.new(1, 0, 0, 40); task.wait(0.1); B.Size = UDim2.new(1, -10, 0, 38)
        end)
    end

    local function AddColorPicker(parent, text, role)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, -10, 0, 40); F.BackgroundTransparency = 1
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(0.6, 0, 1, 0); L.Text = text; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
        local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.35, 0, 0.8, 0); B.Position = UDim2.new(0.65, 0, 0.1, 0); B.Text = "COLOR"; B.BackgroundColor3 = CH_V2.Colors[role]; B.TextColor3 = Color3.new(0,0,0); Instance.new("UICorner", B)
        local colorIdx = 1
        B.MouseButton1Click:Connect(function()
            colorIdx = (colorIdx % #CH_V2.ColorList) + 1
            CH_V2.Colors[role] = CH_V2.ColorList[colorIdx].Color
            B.Text = CH_V2.ColorList[colorIdx].Name; B.BackgroundColor3 = CH_V2.Colors[role]
        end)
    end

    AddToggle(MainP, "NOCLIP", "NOCLIP"); AddToggle(MainP, "AUTOFARM", "AUTOFARM"); AddToggle(MainP, "INFINITYJUMP", "INFINITYJUMP")
    
    AddToggle(EspP, "ESP INOCENTE", "ESP_INOCENTE"); AddColorPicker(EspP, "COLOR INOCENTE", "Innocent")
    AddToggle(EspP, "ESP ASESINO", "ESP_ASESINO"); AddColorPicker(EspP, "COLOR ASESINO", "Murderer")
    AddToggle(EspP, "ESP SHERIFF", "ESP_SHERIFF"); AddColorPicker(EspP, "COLOR SHERIFF", "Sheriff")
    AddToggle(EspP, "TRACES", "TRACES")

    AddToggle(CombatP, "SILENTAIM", "SILENTAIM")
    AddToggle(CombatP, "KILLAURA", "KILLAURA")
    local FOVSlider = Instance.new("TextBox", CombatP); FOVSlider.Size = UDim2.new(1, -10, 0, 35); FOVSlider.Text = "FOV: 100"; FOVSlider.BackgroundColor3 = Color3.fromRGB(30, 35, 50); FOVSlider.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", FOVSlider)
    FOVSlider.FocusLost:Connect(function() local val = tonumber(FOVSlider.Text:match("%d+")); if val then CH_V2.Settings.FOV = math.clamp(val, 40, 300) end; FOVSlider.Text = "FOV: "..CH_V2.Settings.FOV end)

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20
    local Floating = Instance.new("TextButton", ScreenGui); Floating.Size = UDim2.new(0, 60, 0, 60); Floating.Position = UDim2.new(0.05, 0, 0.5, 0); Floating.Text = "CH-HUB"; Floating.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Floating.TextColor3 = Color3.new(1,1,1); Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0); MakeDraggable(Floating)
    
    Close.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true; FOVCircle.Visible = false end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)
    Pages["PRINCIPAL"].Visible = true
end

-- [ LOGICA DE JUEGO ]
local Tracers = {}

RunService.RenderStepped:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

    -- FOV Update
    FOVCircle.Visible = CH_V2.Settings.SILENTAIM and ScreenGui:FindFirstChild("Frame") and ScreenGui.Frame.Visible
    FOVCircle.Radius = CH_V2.Settings.FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()

    -- Noclip (Fix Gravedad)
    if CH_V2.Settings.NOCLIP then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- Autofarm Fix (Captura de imagen corregida)
    if CH_V2.Settings.AUTOFARM then
        lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj.Name == "CoinContainer" or obj.Name == "Coin") then
                local p = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                if p then lp.Character.HumanoidRootPart.CFrame = CFrame.new(p.Position.X, -15, p.Position.Z); break end
            end
        end
    end

    -- ESP & Traces
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local role = (char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
            local active = (role == "Murderer" and CH_V2.Settings.ESP_ASESINO) or (role == "Sheriff" and CH_V2.Settings.ESP_SHERIFF) or (role == "Innocent" and CH_V2.Settings.ESP_INOCENTE)
            
            local hl = char:FindFirstChild("ChrisV2")
            if active then
                if not hl then hl = Instance.new("Highlight", char); hl.Name = "ChrisV2" end
                hl.FillColor = CH_V2.Colors[role]; hl.FillTransparency = 0.2; hl.OutlineTransparency = 0
            elseif hl then hl:Destroy() end

            -- Traces Fix
            if CH_V2.Settings.TRACES and active then
                local pos, vis = camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                local line = Tracers[p.Name] or Drawing.new("Line")
                if vis then
                    line.Visible = true; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = CH_V2.Colors[role]; line.Thickness = 1.5
                else line.Visible = false end
                Tracers[p.Name] = line
            elseif Tracers[p.Name] then Tracers[p.Name].Visible = false end

            -- Silent Aim Hitbox
            if CH_V2.Settings.SILENTAIM then
                char.HumanoidRootPart.Size = Vector3.new(30, 30, 30); char.HumanoidRootPart.Transparency = 0.8; char.HumanoidRootPart.Color = Color3.new(1,1,1)
            else
                char.HumanoidRootPart.Size = Vector3.new(2, 2, 1); char.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function() if CH_V2.Settings.INFINITYJUMP then lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

RunIntro()
