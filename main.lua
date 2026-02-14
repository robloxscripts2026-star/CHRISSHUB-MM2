-- CHRISSHUB V2 - SCRIPT COMPLETO MÓVIL (futurista azul neón, tabs separados)
-- Intro verde neón + Key morado + Menú MAIN/ESP/COMBAT + FOV dorado + Kill Aura 40 + TP Sheriff solo vivo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local player = Players.LocalPlayer

-- KEYS (las nuevas que me diste)
local validKeys = {
    "CHKEY_8621973540", "CHKEY_3917528640", "CHKEY_7149265830",
    "CHKEY_9361852740", "CHKEY_6297148350", "CHKEY_5813927640",
    "CHKEY_2751839640", "CHKEY_4178392560", "CHKEY_1593728460",
    "CHKEY_8326915740"
}

-- ESTADOS
local toggles = {
    Noclip = false,
    Speed = false,
    InfJump = false,
    AntiAFK = false,
    ESP = false,
    Aimbot = false,
    KillAura = false,
    TPSheriff = false
}

-- Colores por rol (5 opciones cada uno)
local espColors = {
    Murderer = {
        Color3.fromRGB(255, 0, 50),   -- Rojo Sangre Neón
        Color3.fromRGB(150, 0, 0),    -- Carmesí Intenso
        Color3.fromRGB(255, 0, 255),  -- Magenta Eléctrico
        Color3.fromRGB(255, 60, 0),   -- Naranja Volcánico
        Color3.fromRGB(200, 0, 100)   -- Rojo Rubí
    },
    Sheriff = {
        Color3.fromRGB(0, 150, 255),  -- Azul Eléctrico
        Color3.fromRGB(0, 255, 255),  -- Cian Glaciar
        Color3.fromRGB(0, 50, 255),   -- Azul Cobalto
        Color3.fromRGB(30, 144, 255), -- Azul Zafiro
        Color3.fromRGB(100, 200, 255) -- Celeste Neón
    },
    Innocent = {
        Color3.fromRGB(0, 255, 120),  -- Verde Esmeralda
        Color3.fromRGB(255, 255, 0),  -- Amarillo Neón
        Color3.fromRGB(255, 255, 255),-- Blanco Puro
        Color3.fromRGB(180, 255, 0),  -- Lima Brillante
        Color3.fromRGB(255, 215, 0)   -- Dorado Premium
    }
}

local espColorIndex = {Murderer = 1, Sheriff = 1, Innocent = 1}
local espHighlights = {}
local lastAFKJump = 0
local circleButton = nil
local menuFrame = nil
local keyFrame = nil

-- FOV Circle (dorado puro)
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 215, 0)
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Visible = false
fovCircle.Radius = 150

-- =============================================
-- MÓDULO 1: INTRO
-- =============================================
local function showIntro()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "IntroGui"
    introGui.Parent = CoreGui

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0.8, 0, 0.2, 0)
    logo.Position = UDim2.new(0.1, 0, 0.4, 0)
    logo.Text = "CHRISSHUB V2"
    logo.TextColor3 = Color3.fromRGB(0, 255, 120)
    logo.BackgroundTransparency = 1
    logo.Font = Enum.Font.Code
    logo.TextSize = 70
    logo.TextStrokeTransparency = 0.5
    logo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    logo.Parent = introGui

    -- Lluvia sutil
    for i = 1, 25 do
        local line = Instance.new("TextLabel")
        line.Size = UDim2.new(0.1, 0, 0.05, 0)
        line.Position = UDim2.new(math.random(), 0, -0.1, 0)
        line.Text = string.rep(math.random(0,1), math.random(6,12))
        line.TextColor3 = Color3.fromRGB(0, 255, 120)
        line.BackgroundTransparency = 1
        line.Font = Enum.Font.Code
        line.TextSize = math.random(10, 16)
        line.Parent = introGui

        spawn(function()
            while line.Parent do
                line.Position = UDim2.new(line.Position.X.Scale, 0, line.Position.Y.Scale + 0.008, 0)
                if line.Position.Y.Scale > 1.2 then
                    line.Position = UDim2.new(math.random(), 0, -0.1, 0)
                end
                task.wait(0.03)
            end
        end)
    end

    task.wait(4.5)
    local fade = TweenService:Create(logo, TweenInfo.new(1.2), {TextTransparency = 1})
    fade:Play()
    fade.Completed:Connect(function()
        introGui:Destroy()
        showKeySystem()
    end)
end

-- =============================================
-- MÓDULO 2: KEY SYSTEM (morado neón)
-- =============================================
local function showKeySystem()
    keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 300, 0, 180)
    keyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    keyFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 50) -- Morado oscuro
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = CoreGui
    Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", keyFrame)
    stroke.Color = Color3.fromRGB(180, 0, 255)
    stroke.Thickness = 2

    local title = Instance.new("TextLabel", keyFrame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Text = "ENTER KEY"
    title.TextColor3 = Color3.fromRGB(180, 0, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24

    local input = Instance.new("TextBox", keyFrame)
    input.Size = UDim2.new(0.8, 0, 0, 50)
    input.Position = UDim2.new(0.1, 0, 0.35, 0)
    input.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
    input.TextColor3 = Color3.new(1,1,1)
    input.PlaceholderText = "ENTER KEY..."
    input.Text = ""
    Instance.new("UICorner", input)

    local btn = Instance.new("TextButton", keyFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 50)
    btn.Position = UDim2.new(0.1, 0, 0.65, 0)
    btn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    btn.Text = "VERIFY"
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner", btn)

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
            input.PlaceholderColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
            input.PlaceholderText = "ENTER KEY..."
            input.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end

-- =============================================
-- MÓDULO 3: MENÚ PRINCIPAL (futurista azul neón)
-- =============================================
local function showMainMenu()
    menuFrame = Instance.new("Frame", CoreGui)
    menuFrame.Size = UDim2.new(0, 340, 0, 420)
    menuFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
    menuFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
    menuFrame.BorderSizePixel = 0
    menuFrame.Active = true
    menuFrame.Draggable = true
    Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", menuFrame)
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 1.5

    -- X grande
    local closeBtn = Instance.new("TextButton", menuFrame)
    closeBtn.Size = UDim2.new(0, 50, 0, 50)
    closeBtn.Position = UDim2.new(1, -55, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 28
    Instance.new("UICorner", closeBtn)
    closeBtn.MouseButton1Click:Connect(function()
        menuFrame.Visible = false
        showHubCircle()
    end)

    -- Título
    local title = Instance.new("TextLabel", menuFrame)
    title.Size = UDim2.new(1,0,0,50)
    title.Text = "CHRISSHUB V2"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24

    -- Tabs (MAIN / ESP / COMBAT)
    local tabButtons = {}
    local tabContents = {}

    local function createTab(name, xPos)
        local btn = Instance.new("TextButton", menuFrame)
        btn.Size = UDim2.new(0.33, -5, 0, 40)
        btn.Position = UDim2.new(xPos, 0, 0, 50)
        btn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
        btn.Text = name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        Instance.new("UICorner", btn)
        btn.Parent = menuFrame

        local content = Instance.new("ScrollingFrame", menuFrame)
        content.Size = UDim2.new(1, -20, 1, -110)
        content.Position = UDim2.new(0, 10, 0, 90)
        content.BackgroundTransparency = 1
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
        content.Visible = false
        content.Parent = menuFrame

        btn.MouseButton1Click:Connect(function()
            for _, tab in pairs(tabContents) do tab.Visible = false end
            content.Visible = true
            for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(20, 25, 35) end
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)

        table.insert(tabButtons, btn)
        tabContents[name] = content
        return content
    end

    local mainContent = createTab("MAIN", 0)
    local espContent = createTab("ESP", 0.33)
    local combatContent = createTab("COMBAT", 0.66)

    mainContent.Visible = true

    -- =============================================
    -- MAIN CONTENT
    -- =============================================
    local function createToggle(parent, name, posY)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.Position = UDim2.new(0, 5, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            toggles[name] = not toggles[name]
            btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
            btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(25, 25, 35)
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(1, -10, 0, 50)}):Play()
            task.wait(0.15)
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(1, -10, 0, 45)}):Play()
        end)
    end

    createToggle(mainContent, "Noclip", 0)
    createToggle(mainContent, "Speed", 55)
    createToggle(mainContent, "InfJump", 110)
    createToggle(mainContent, "AntiAFK", 165)

    local tiktokLabel = Instance.new("TextLabel", mainContent)
    tiktokLabel.Size = UDim2.new(1, -10, 0, 80)
    tiktokLabel.Position = UDim2.new(0, 5, 0, 220)
    tiktokLabel.Text = "SÍGUEME EN TIKTOK @sasware32 para sugerencias y errores en mi Script"
    tiktokLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    tiktokLabel.BackgroundTransparency = 1
    tiktokLabel.Font = Enum.Font.Gotham
    tiktokLabel.TextSize = 14
    tiktokLabel.TextWrapped = true

    -- =============================================
    -- ESP CONTENT (toggles + colores)
    -- =============================================
    local espToggles = {}
    local function createESPToggle(name, posY)
        local btn = Instance.new("TextButton", espContent)
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.Position = UDim2.new(0, 5, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            toggles[name] = not toggles[name]
            btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
            btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(25, 25, 35)
        end)
        table.insert(espToggles, btn)
    end

    createESPToggle("ESP ASESINO", 0)
    createESPToggle("ESP SHERIFF", 55)
    createESPToggle("ESP INOCENTE", 110)

    -- =============================================
    -- COMBAT CONTENT
    -- =============================================
    local combatToggles = {}
    local function createCombatToggle(name, posY)
        local btn = Instance.new("TextButton", combatContent)
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.Position = UDim2.new(0, 5, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            toggles[name] = not toggles[name]
            btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
            btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(25, 25, 35)
        end)
        table.insert(combatToggles, btn)
    end

    createCombatToggle("Aimbot", 0)
    createCombatToggle("KillAura", 55)
    createCombatToggle("TP Sheriff", 110)

    -- =============================================
    -- CÍRCULO CH-HUB
    -- =============================================
    local function showHubCircle()
        if circleButton then return end
        circleButton = Instance.new("TextButton", CoreGui)
        circleButton.Size = UDim2.new(0, 80, 0, 80)
        circleButton.Position = UDim2.new(0.5, -40, 0, 20)
        circleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        circleButton.Text = "CH-HUB"
        circleButton.TextColor3 = Color3.fromRGB(0, 200, 255)
        circleButton.Font = Enum.Font.GothamBlack
        circleButton.TextSize = 18
        Instance.new("UICorner", circleButton).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", circleButton).Color = Color3.fromRGB(0, 200, 255)
        Instance.new("UIStroke", circleButton).Thickness = 2

        circleButton.MouseButton1Click:Connect(function()
            menuFrame.Visible = true
            circleButton:Destroy()
            circleButton = nil
        end)
    end

    -- =============================================
    -- FUNCIONES
    -- =============================================

    -- ESP
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

        -- Aimbot con FOV
        if toggles.Aimbot then
            local closest, dist = nil, math.huge
            local camPos = camera.CFrame.Position
            
            for _, plr in Players:GetPlayers() do
                if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Knife") then
                    local head = plr.Character.Head
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                        if d < 180 and d < dist then
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

        -- TP Sheriff (solo si vivo)
        if toggles.TPSheriff then
            for _, plr in Players:GetPlayers() do
                if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Gun") then
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

    print("[CHRISSHUB V2] Cargado.")
end

-- Iniciar
showIntro()
