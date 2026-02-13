--
-- CHRISSHUB MM2 V2.1 - FIX TOTAL (MENÚ MAIN VISIBLE + TODAS FUNCIONES)
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

-- CONFIG
local Settings = {
    NOCLIP = false, SPEED = 16, INFJUMP = false, ANTIAFK = false,
    ESP = false, ESP_COLOR_CYCLE = 1,
    AIMBOT_MURDER = false, FOV_SIZE = 150,
    KILLAURA = false, KILLAURA_RANGE = 45,
    TPSHERIFF = false
}

local Colors = {
    Murderer = Color3.fromRGB(255, 0, 50),
    Sheriff = Color3.fromRGB(0, 150, 255),
    Innocent = Color3.fromRGB(0, 255, 100),
    UI_Neon = Color3.fromRGB(0, 220, 255)
}

local espHighlights = {}
local lastAFKJump = 0
local circleButton = nil
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
            local nX = startPos.X.Offset + delta.X
            local nY = startPos.Y.Offset + delta.Y
            frame.Position = UDim2.new(0, nX, 0, nY)
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
    task.wait(4)
    TweenService:Create(logo, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1)
    intro:Destroy()
    showKeySystem()
end

-- Key System
local function showKeySystem()
    keyFrame = Instance.new("Frame", ScreenGui); keyFrame.Size = UDim2.new(0,280,0,160); keyFrame.Position = UDim2.new(0.5,-140,0.5,-80); keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", keyFrame)
    local title = Instance.new("TextLabel", keyFrame); title.Size = UDim2.new(1,0,0,40); title.Text = "Enter License"; title.TextColor3 = Colors.UI_Neon; title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 22
    local input = Instance.new("TextBox", keyFrame); input.Size = UDim2.new(0.8,0,0,45); input.Position = UDim2.new(0.1,0,0.35,0); input.BackgroundColor3 = Color3.fromRGB(25,25,25); input.TextColor3 = Color3.new(1,1,1); input.PlaceholderText = "Enter License..."; Instance.new("UICorner", input)
    local btn = Instance.new("TextButton", keyFrame); btn.Size = UDim2.new(0.8,0,0,45); btn.Position = UDim2.new(0.1,0,0.65,0); btn.BackgroundColor3 = Colors.UI_Neon; btn.Text = "VERIFY"; btn.TextColor3 = Color3.new(0,0,0); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        local key = input.Text
        if table.find(validKeys, key) then
            input.Text = "Verifying key..."
            task.wait(5)
            keyFrame:Destroy()
            showMainMenu()
        else
            input.Text = ""
            input.PlaceholderText = "Invalid key"
            input.PlaceholderColor3 = Color3.fromRGB(255,0,0)
            task.wait(2)
            input.PlaceholderText = "Enter License..."
            input.PlaceholderColor3 = Color3.fromRGB(200,200,200)
        end
    end)
end

-- Menú Principal
local function showMainMenu()
    menuFrame = Instance.new("Frame", ScreenGui); menuFrame.Size = UDim2.new(0,320,0,400); menuFrame.Position = UDim2.new(0.5,-160,0.5,-200); menuFrame.BackgroundColor3 = Color3.fromRGB(10,10,15); Instance.new("UICorner", menuFrame)
    MakeDraggable(menuFrame)

    local close = Instance.new("TextButton", menuFrame); close.Size = UDim2.new(0,40,0,40); close.Position = UDim2.new(1,-45,0,5); close.BackgroundColor3 = Color3.fromRGB(200,40,40); close.Text = "X"; close.TextColor3 = Color3.new(1,1,1); close.Font = Enum.Font.GothamBold; close.TextSize = 24; Instance.new("UICorner", close)
    close.MouseButton1Click:Connect(function()
        menuFrame.Visible = false
        showHubCircle()
    end)

    local title = Instance.new("TextLabel", menuFrame); title.Size = UDim2.new(1,0,0,50); title.Text = "CHRISSHUB V1"; title.TextColor3 = Colors.UI_Neon; title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBlack; title.TextSize = 24

    local tiktok = Instance.new("TextLabel", menuFrame); tiktok.Size = UDim2.new(1,0,0,30); tiktok.Position = UDim2.new(0,0,0,50); tiktok.Text = "SÍGUEME EN TIKTOK @sasware32"; tiktok.TextColor3 = Colors.UI_Neon; tiktok.BackgroundTransparency = 1; tiktok.Font = Enum.Font.Gotham; tiktok.TextSize = 14

    local scroll = Instance.new("ScrollingFrame", menuFrame); scroll.Size = UDim2.new(1,-20,1,-100); scroll.Position = UDim2.new(0,10,0,80); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = Colors.UI_Neon

    local function createToggle(name, posY)
        local btn = Instance.new("TextButton", scroll); btn.Size = UDim2.new(1,0,0,45); btn.Position = UDim2.new(0,0,0,posY); btn.BackgroundColor3 = Color3.fromRGB(25,25,25); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.fromRGB(200,200,200); btn.Font = Enum.Font.GothamBold; btn.TextSize = 16; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            toggles[name] = not toggles[name]
            btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
            btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0,120,60) or Color3.fromRGB(25,25,25)
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,50)}):Play()
            task.wait(0.15)
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,45)}):Play()
        end)
    end

    -- MAIN
    createToggle("Noclip", 0)
    createToggle("Speed", 55)  -- Speed hack simple
    createToggle("InfJump", 110)
    createToggle("AntiAFK", 165)

    local tiktokLabel = Instance.new("TextLabel", scroll); tiktokLabel.Size = UDim2.new(1,0,0,60); tiktokLabel.Position = UDim2.new(0,0,0,220); tiktokLabel.Text = "SÍGUEME EN TIKTOK @sasware32 para sugerencias y errores"; tiktokLabel.TextColor3 = Colors.UI_Neon; tiktokLabel.BackgroundTransparency = 1; tiktokLabel.Font = Enum.Font.Gotham; tiktokLabel.TextSize = 14; tiktokLabel.TextWrapped = true

    -- ESP
    local espTitle = Instance.new("TextLabel", scroll); espTitle.Size = UDim2.new(1,0,0,30); espTitle.Position = UDim2.new(0,0,0,290); espTitle.Text = "ESP"; espTitle.TextColor3 = Colors.UI_Neon; espTitle.BackgroundTransparency = 1; espTitle.Font = Enum.Font.GothamBold; espTitle.TextSize = 18
    createToggle("ESP", 320)

    -- COMBAT
    local combatTitle = Instance.new("TextLabel", scroll); combatTitle.Size = UDim2.new(1,0,0,30); combatTitle.Position = UDim2.new(0,0,0,380); combatTitle.Text = "COMBAT"; combatTitle.TextColor3 = Colors.UI_Neon; combatTitle.BackgroundTransparency = 1; combatTitle.Font = Enum.Font.GothamBold; combatTitle.TextSize = 18
    createToggle("AimbotLegit", 410)
    createToggle("AimbotMurder", 465)
    createToggle("KillAura", 520)
    createToggle("TPSheriff", 575)

    -- =============================================
    -- FUNCIONES
    -- =============================================

    -- ESP
    local function addESP(plr)
        if plr == lp then return end
        plr.CharacterAdded:Connect(function(char)
            local hl = Instance.new("Highlight", char)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            espHighlights[plr] = hl
        end)
        if plr.Character then
            local hl = Instance.new("Highlight", plr.Character)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            espHighlights[plr] = hl
        end
    end

    for _, plr in Players:GetPlayers() do addESP(plr) end
    Players.PlayerAdded:Connect(addESP)

    -- Loop principal
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChild("Humanoid")

        -- Anti-AFK
        if toggles.AntiAFK and hum and tick() - lastAFKJump > 30 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            lastAFKJump = tick()
        end

        -- ESP
        if toggles.ESP then
            for plr, hl in pairs(espHighlights) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local role = "Innocent"
                    if plr.Character:FindFirstChild("Knife") then role = "Murderer" end
                    if plr.Character:FindFirstChild("Gun") then role = "Sheriff" end
                    hl.Enabled = true
                    hl.FillColor = espColors[role]
                    hl.OutlineColor = espColors[role]
                end
            end
        else
            for _, hl in pairs(espHighlights) do hl.Enabled = false end
        end

        -- Kill Aura 45 studs
        if toggles.KillAura and char:FindFirstChild("Knife") then
            for _, plr in Players:GetPlayers() do
                if plr \~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 45 then
                        char.Knife.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame
                    end
                end
            end
        end

        -- Aimbot Murder con FOV
        if toggles.AimbotMurder then
            local closest, dist = nil, math.huge
            local camPos = camera.CFrame.Position
            
            for _, plr in Players:GetPlayers() do
                if plr \~= lp and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Knife") then
                    local head = plr.Character.Head
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                        if d < CH_V2.Settings.FOV_SIZE and d < dist then
                            closest = head
                            dist = d
                        end
                    end
                end
            end
            
            if closest then
                local direction = (closest.Position - camPos).Unit
                camera.CFrame = CFrame.new(camPos, camPos + direction * 1000)
            end
        end

        -- TP Sheriff
        if toggles.TPSheriff and char:FindFirstChild("Knife") then
            local gunDrop = Workspace:FindFirstChild("GunDrop")
            if gunDrop then
                root.CFrame = gunDrop.CFrame * CFrame.new(0, 3, 0)
            else
                for _, plr in Players:GetPlayers() do
                    if plr.Character and plr.Character:FindFirstChild("Gun") then
                        root.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                        break
                    end
                end
            end
        end
    end)

    -- Noclip
    RunService.Stepped:Connect(function()
        if toggles.Noclip and lp.Character then
            for _, part in ipairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    -- Inf Jump
    UserInputService.JumpRequest:Connect(function()
        if toggles.InfJump and lp.Character then
            lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Speed hack
    RunService.Heartbeat:Connect(function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = toggles.Speed and 50 or 16
        end
    end)

    -- FOV Update
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = toggles.AimbotMurder
        FOVCircle.Radius = CH_V2.Settings.FOV_SIZE
        FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    end)

    print("[CHRISSHUB V2.1] Cargado completo.")
end

-- Iniciar
showIntro()
