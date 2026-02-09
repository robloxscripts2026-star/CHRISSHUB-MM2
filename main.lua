-- CHRISSHUB MM2 V1 - SCRIPT COMPLETO MÓVIL (todo junto)
-- Intro hacker + Key System + Menú MAIN/ESP/COMBAT + Círculo CH-HUB

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local player = Players.LocalPlayer

-- KEYS (las 10 que me diste)
local validKeys = {
    "123456", "654321", "112233", "445566", "121212",
    "343434", "135790", "246801", "987654", "019283"
}

-- ESTADOS
local toggles = {
    Noclip = false,
    InfJump = false,
    AntiAFK = false,
    AimbotLegit = false,
    AimbotMurder = false,
    KillAura = false,
    TPSheriff = false,
    ESP = false
}

-- Colores predeterminados
local espColors = {
    Murderer = Color3.fromRGB(255, 0, 0),     -- Rojo
    Sheriff = Color3.fromRGB(0, 100, 255),    -- Azul
    Innocent = Color3.fromRGB(0, 255, 0)      -- Verde
}

-- Lista de 15 colores para ciclo
local colorOptions = {
    Color3.fromRGB(255, 0, 0),      -- Rojo
    Color3.fromRGB(255, 165, 0),    -- Naranja
    Color3.fromRGB(255, 255, 0),    -- Amarillo
    Color3.fromRGB(0, 255, 0),      -- Verde
    Color3.fromRGB(0, 0, 255),      -- Azul
    Color3.fromRGB(148, 0, 211),    -- Violeta
    Color3.fromRGB(255, 192, 203),  -- Rosa
    Color3.fromRGB(139, 69, 19),    -- Marrón
    Color3.fromRGB(0, 0, 0),        -- Negro
    Color3.fromRGB(255, 255, 255),  -- Blanco
    Color3.fromRGB(128, 128, 128),  -- Gris
    Color3.fromRGB(0, 255, 255),    -- Cian
    Color3.fromRGB(255, 0, 255),    -- Magenta
    Color3.fromRGB(64, 224, 208),   -- Turquesa
    Color3.fromRGB(255, 215, 0)     -- Dorado
}

local currentColorIndex = 1  -- Índice para ciclo de colores

local espHighlights = {}
local lastAFKJump = 0
local circleButton = nil
local menuFrame = nil
local keyFrame = nil

-- =============================================
-- INTRO HACKER (sin fondo)
-- =============================================
local function showIntro()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "IntroGui"
    introGui.Parent = CoreGui

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0.8, 0, 0.2, 0)
    logo.Position = UDim2.new(0.1, 0, 0.4, 0)
    logo.Text = "CHRISSHUB V1"
    logo.TextColor3 = Color3.fromRGB(0, 255, 120)
    logo.BackgroundTransparency = 1
    logo.Font = Enum.Font.Code
    logo.TextSize = 70
    logo.TextStrokeTransparency = 0.5
    logo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    logo.Parent = introGui

    -- Lluvia de código
    for i = 1, 40 do
        local line = Instance.new("TextLabel")
        line.Size = UDim2.new(0.1, 0, 0.05, 0)
        line.Position = UDim2.new(math.random(), 0, -0.1, 0)
        line.Text = string.rep(math.random(0,1), math.random(8,20))
        line.TextColor3 = Color3.fromRGB(0, 255, 120)
        line.BackgroundTransparency = 1
        line.Font = Enum.Font.Code
        line.TextSize = math.random(10, 16)
        line.Parent = introGui

        spawn(function()
            while line.Parent do
                line.Position = UDim2.new(line.Position.X.Scale, 0, line.Position.Y.Scale + 0.01, 0)
                if line.Position.Y.Scale > 1.2 then
                    line.Position = UDim2.new(math.random(), 0, -0.1, 0)
                end
                task.wait(0.02)
            end
        end)
    end

    task.wait(5)
    local fade = TweenService:Create(logo, TweenInfo.new(1.5), {TextTransparency = 1})
    fade:Play()
    fade.Completed:Connect(function()
        introGui:Destroy()
        showKeySystem()
    end)
end

-- =============================================
-- KEY SYSTEM
-- =============================================
local function showKeySystem()
    keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 280, 0, 160)
    keyFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
    keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = CoreGui
    Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", keyFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "Enter License"
    title.TextColor3 = Color3.fromRGB(0, 255, 120)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22

    local input = Instance.new("TextBox", keyFrame)
    input.Size = UDim2.new(0.8, 0, 0, 45)
    input.Position = UDim2.new(0.1, 0, 0.35, 0)
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    input.TextColor3 = Color3.new(1,1,1)
    input.PlaceholderText = "Enter License..."
    input.Text = ""
    Instance.new("UICorner", input)

    local btn = Instance.new("TextButton", keyFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Position = UDim2.new(0.1, 0, 0.65, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    btn.Text = "VERIFY"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        local key = input.Text
        local valid = false
        for _, v in ipairs(validKeys) do
            if key == v then
                valid = true
                break
            end
        end

        if valid then
            input.Text = "Verifying key..."
            task.wait(5)
            keyFrame:Destroy()
            showMainMenu()
        else
            input.Text = ""
            input.PlaceholderText = "Invalid key"
            input.PlaceholderColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
            input.PlaceholderText = "Enter License..."
            input.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end

-- =============================================
-- MENÚ PRINCIPAL
-- =============================================
local function showMainMenu()
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 300, 0, 380)
    menuFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
    menuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    menuFrame.BorderSizePixel = 0
    menuFrame.Active = true
    menuFrame.Draggable = true
    menuFrame.Parent = CoreGui
    Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)

    local close = Instance.new("TextButton", menuFrame)
    close.Size = UDim2.new(0, 50, 0, 50)
    close.Position = UDim2.new(1, -55, 0, 5)
    close.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    close.Text = "X"
    close.TextColor3 = Color3.new(1,1,1)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 30
    Instance.new("UICorner", close)
    close.Parent = menuFrame

    close.MouseButton1Click:Connect(function()
        menuFrame.Visible = false
        showHubCircle()
    end)

    local title = Instance.new("TextLabel", menuFrame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Text = "CHRISSHUB V1"
    title.TextColor3 = Color3.fromRGB(0, 255, 120)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24

    local tiktok = Instance.new("TextLabel", menuFrame)
    tiktok.Size = UDim2.new(1, 0, 0, 30)
    tiktok.Position = UDim2.new(0, 0, 0, 50)
    tiktok.Text = "SÍGUEME EN TIKTOK @sasware32"
    tiktok.TextColor3 = Color3.fromRGB(0, 255, 120)
    tiktok.BackgroundTransparency = 1
    tiktok.Font = Enum.Font.Gotham
    tiktok.TextSize = 14
    tiktok.Parent = menuFrame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -100)
    scroll.Position = UDim2.new(0, 10, 0, 80)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
    scroll.Parent = menuFrame

    local function createToggle(name, posY)
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.Position = UDim2.new(0, 0, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        Instance.new("UICorner", btn)
        btn.Parent = scroll

        btn.MouseButton1Click:Connect(function()
            toggles[name] = not toggles[name]
            btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
            btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(25, 25, 25)
            -- Animación escala
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 50)}):Play()
            task.wait(0.15)
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 45)}):Play()
        end)
    end

    -- MAIN
    createToggle("Noclip", 30)
    createToggle("InfJump", 85)
    createToggle("AntiAFK", 140)

    local tiktokLabel = Instance.new("TextLabel", scroll)
    tiktokLabel.Size = UDim2.new(1, 0, 0, 60)
    tiktokLabel.Position = UDim2.new(0, 0, 0, 200)
    tiktokLabel.Text = "SÍGUEME EN TIKTOK @sasware32 para sugerencias y errores"
    tiktokLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
    tiktokLabel.BackgroundTransparency = 1
    tiktokLabel.Font = Enum.Font.Gotham
    tiktokLabel.TextSize = 14
    tiktokLabel.TextWrapped = true
    tiktokLabel.Parent = scroll

    -- ESP
    local espTitle = Instance.new("TextLabel", scroll)
    espTitle.Size = UDim2.new(1, 0, 0, 30)
    espTitle.Position = UDim2.new(0, 0, 0, 280)
    espTitle.Text = "ESP"
    espTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
    espTitle.BackgroundTransparency = 1
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 18

    createToggle("ESP", 310)

    -- COMBAT
    local combatTitle = Instance.new("TextLabel", scroll)
    combatTitle.Size = UDim2.new(1, 0, 0, 30)
    combatTitle.Position = UDim2.new(0, 0, 0, 370)
    combatTitle.Text = "COMBAT"
    combatTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
    combatTitle.BackgroundTransparency = 1
    combatTitle.Font = Enum.Font.GothamBold
    combatTitle.TextSize = 18

    createToggle("AimbotLegit", 400)
    createToggle("AimbotMurder", 455)
    createToggle("KillAura", 510)
    createToggle("TPSheriff", 565)

    -- =============================================
    -- FUNCIONES
    -- =============================================

    -- ESP (permanente por ronda)
    local function addESP(plr)
        if plr == player then return end
        
        local function update(char)
            if espHighlights[plr] then espHighlights[plr]:Destroy() end
            local hl = Instance.new("Highlight")
            hl.Parent = char
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            espHighlights[plr] = hl
        end
        
        if plr.Character then update(plr.Character) end
        plr.CharacterAdded:Connect(update)
    end

    for _, plr in Players:GetPlayers() do addESP(plr) end
    Players.PlayerAdded:Connect(addESP)

    -- Loop principal
    RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChild("Humanoid")

        -- Anti-AFK
        if toggles.AntiAFK and hum and tick() - lastAFKJump > 30 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            lastAFKJump = tick()
        end

        -- ESP (revisa roles constantemente)
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

        -- Kill Aura 40 studs
        if toggles.KillAura and char:FindFirstChild("Knife") then
            for _, plr in Players:GetPlayers() do
                if plr \~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 40 then
                        char.Knife.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame
                    end
                end
            end
        end

        -- Aimbot Legit (no paredes)
        if toggles.AimbotLegit then
            local closest, dist = nil, math.huge
            local camPos = camera.CFrame.Position
            
            for _, plr in Players:GetPlayers() do
                if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                    local head = plr.Character.Head
                    local _, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (head.Position - camPos).Magnitude
                        if d < dist then
                            local ray = Ray.new(camPos, (head.Position - camPos).Unit * 1000)
                            local hit, pos = Workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
                            if hit and hit:IsDescendantOf(plr.Character) then
                                closest = head
                                dist = d
                            end
                        end
                    end
                end
            end
            
            if closest then
                local direction = (closest.Position - camPos).Unit
                camera.CFrame = CFrame.new(camPos, camPos + direction * 1000)
            end
        end

        -- Aimbot Murder (solo asesino)
        if toggles.AimbotMurder then
            local closest, dist = nil, math.huge
            local camPos = camera.CFrame.Position
            
            for _, plr in Players:GetPlayers() do
                if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Knife") then
                    local head = plr.Character.Head
                    local _, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (head.Position - camPos).Magnitude
                        if d < dist then
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
            for _, plr in Players:GetPlayers() do
                if plr.Character and plr.Character:FindFirstChild("Gun") then
                    root.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    break
                end
            end
        end
    end)

    -- Noclip
    RunService.Stepped:Connect(function()
        if toggles.Noclip and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    -- Inf Jump
    UserInputService.JumpRequest:Connect(function()
        if toggles.InfJump and player.Character then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    print("[CHRISSHUB MM2 V1] Cargado.")
end

-- Iniciar
showIntro()
