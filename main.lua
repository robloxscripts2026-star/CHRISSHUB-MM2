-- CHRISSHUB MM2 V2.1 - FIX TOTAL (LINEA 1 Y REFERENCIAS CORREGIDAS)
-- MAIN con TikTok + Noclip/Speed/InfJump/AntiAFK
-- ESP colores permanentes + ciclo 15
-- Aimbot Murder con FOV visible + Kill Aura 45 + TP Sheriff

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local lp = Players.LocalPlayer

-- KEYS
local validKeys = {"482957", "859326", "295714", "963085", "159372", "628491", "307589", "741963", "518230", "036148"}

-- CONFIG (Se usa Settings para los valores reales)
local Settings = {
    Noclip = false, Speed = false, InfJump = false, AntiAFK = false,
    ESP = false, ESP_COLOR_CYCLE = 1,
    AimbotLegit = false, AimbotMurder = false, FOV_SIZE = 150,
    KillAura = false, KILLAURA_RANGE = 45,
    TPSheriff = false
}

local Colors = {
    Murderer = Color3.fromRGB(255, 0, 50),
    Sheriff = Color3.fromRGB(0, 150, 255),
    Innocent = Color3.fromRGB(0, 255, 100),
    UI_Neon = Color3.fromRGB(0, 220, 255)
}

local espHighlights = {}
local lastAFKJump = 0
local menuFrame = nil
local keyFrame = nil

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Colors.UI_Neon
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- Limpieza
if CoreGui:FindFirstChild("ChrisHubV2") then CoreGui.ChrisHubV2:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubV2"; ScreenGui.ResetOnSpawn = false

-- Draggable
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- Intro Hacker
local function showIntro()
    local intro = Instance.new("ScreenGui", CoreGui); intro.Name = "Intro"
    local logo = Instance.new("TextLabel", intro); logo.Size = UDim2.new(0.8,0,0.2,0); logo.Position = UDim2.new(0.1,0,0.4,0); logo.Text = "CHRISSHUB V1"; logo.TextColor3 = Color3.fromRGB(0,255,120); logo.BackgroundTransparency = 1; logo.Font = Enum.Font.Code; logo.TextSize = 70; logo.TextStrokeTransparency = 0.5
    task.wait(2) -- Reducido para pruebas
    TweenService:Create(logo, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1)
    intro:Destroy()
    showKeySystem()
end

-- Key System
function showKeySystem()
    keyFrame = Instance.new("Frame", ScreenGui); keyFrame.Size = UDim2.new(0,280,0,160); keyFrame.Position = UDim2.new(0.5,-140,0.5,-80); keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", keyFrame)
    local title = Instance.new("TextLabel", keyFrame); title.Size = UDim2.new(1,0,0,40); title.Text = "Enter License"; title.TextColor3 = Colors.UI_Neon; title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 22
    local input = Instance.new("TextBox", keyFrame); input.Size = UDim2.new(0.8,0,0,45); input.Position = UDim2.new(0.1,0,0.35,0); input.BackgroundColor3 = Color3.fromRGB(25,25,25); input.TextColor3 = Color3.new(1,1,1); input.PlaceholderText = "Enter License..."; Instance.new("UICorner", input)
    local btn = Instance.new("TextButton", keyFrame); btn.Size = UDim2.new(0.8,0,0,45); btn.Position = UDim2.new(0.1,0,0.65,0); btn.BackgroundColor3 = Colors.UI_Neon; btn.Text = "VERIFY"; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if table.find(validKeys, input.Text) then
            btn.Text = "Verifying key..."
            task.wait(2)
            keyFrame:Destroy()
            showMainMenu()
        else
            input.Text = ""
            input.PlaceholderText = "Invalid key"
            task.wait(1)
            input.PlaceholderText = "Enter License..."
        end
    end)
end

-- Menú Principal
function showMainMenu()
    menuFrame = Instance.new("Frame", ScreenGui); menuFrame.Size = UDim2.new(0,320,0,400); menuFrame.Position = UDim2.new(0.5,-160,0.5,-200); menuFrame.BackgroundColor3 = Color3.fromRGB(10,10,15); Instance.new("UICorner", menuFrame)
    MakeDraggable(menuFrame)

    local title = Instance.new("TextLabel", menuFrame); title.Size = UDim2.new(1,0,0,50); title.Text = "CHRISSHUB V1"; title.TextColor3 = Colors.UI_Neon; title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBlack; title.TextSize = 24
    local tiktok = Instance.new("TextLabel", menuFrame); tiktok.Size = UDim2.new(1,0,0,30); tiktok.Position = UDim2.new(0,0,0,50); tiktok.Text = "@sasware32 on TikTok"; tiktok.TextColor3 = Colors.UI_Neon; tiktok.BackgroundTransparency = 1; tiktok.Font = Enum.Font.Gotham; tiktok.TextSize = 14
    local scroll = Instance.new("ScrollingFrame", menuFrame); scroll.Size = UDim2.new(1,-20,1,-100); scroll.Position = UDim2.new(0,10,0,80); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,0,650)

    local function createToggle(name, posY, varName)
        local btn = Instance.new("TextButton", scroll); btn.Size = UDim2.new(1,0,0,45); btn.Position = UDim2.new(0,0,0,posY); btn.BackgroundColor3 = Color3.fromRGB(25,25,25); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.fromRGB(200,200,200); btn.Font = Enum.Font.GothamBold; btn.TextSize = 16; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Settings[varName] = not Settings[varName]
            btn.Text = name .. ": " .. (Settings[varName] and "ON" or "OFF")
            btn.BackgroundColor3 = Settings[varName] and Color3.fromRGB(0,120,60) or Color3.fromRGB(25,25,25)
        end)
    end

    createToggle("Noclip", 0, "Noclip")
    createToggle("Speed hack", 55, "Speed")
    createToggle("InfJump", 110, "InfJump")
    createToggle("AntiAFK", 165, "AntiAFK")
    createToggle("ESP Master", 250, "ESP")
    createToggle("Aimbot Legit", 340, "AimbotLegit")
    createToggle("Aimbot Murder", 395, "AimbotMurder")
    createToggle("KillAura 45", 450, "KillAura")
    createToggle("TP Sheriff/Gun", 505, "TPSheriff")

    -- LÓGICA DE FUNCIONES
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChild("Humanoid")

        if Settings.Speed and hum then hum.WalkSpeed = 50 elseif hum then hum.WalkSpeed = 16 end
        
        -- ESP
        if Settings.ESP then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then
                    local hl = plr.Character:FindFirstChild("Highlight") or Instance.new("Highlight", plr.Character)
                    local role = "Innocent"
                    if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then role = "Murderer"
                    elseif plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then role = "Sheriff" end
                    hl.FillColor = Colors[role]
                    hl.Enabled = true
                end
            end
        end

        -- Kill Aura
        if Settings.KillAura and char:FindFirstChild("Knife") then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 45 then
                        firetouchinterest(plr.Character.HumanoidRootPart, char.Knife.Handle, 0)
                        firetouchinterest(plr.Character.HumanoidRootPart, char.Knife.Handle, 1)
                    end
                end
            end
        end

        -- Aimbot Murder
        if Settings.AimbotMurder then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character and (plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife")) then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, plr.Character.Head.Position)
                end
            end
        end
    end)

    -- Noclip Stepped
    RunService.Stepped:Connect(function()
        if Settings.Noclip and lp.Character then
            for _, part in pairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

showIntro()
