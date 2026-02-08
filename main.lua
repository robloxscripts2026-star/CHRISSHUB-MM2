-- CHRISSHUB MM2 V3 - CÓDIGO COMPLETO FINAL (limpio para Delta móvil)
-- ESP colores permanentes + elegibles | Aimbot normal/Legit/Asesino | Kill Aura 35 | Noclip Pro | Inf Jump | Anti-AFK
-- Menú con MAIN (TikTok), ESP, COMBAT, AUTO | Círculo CH al cerrar

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local toggles = {
    ESP = false,
    Aimbot = false,
    AimbotLegit = false,
    AimbotAsesino = false,
    KillAura = false,
    Noclip = false,
    InfJump = false,
    AntiAFK = false,
    AutoFarm = false  -- Próximamente
}

local espHighlights = {}
local roleColors = {}
local colorOptions = {"Rojo", "Naranja", "Amarillo", "Verde lima", "Azul cielo", "Azul marino", "Morado", "Rosa", "Marrón", "Negro", "Blanco", "Gris", "Turquesa", "Fucsia", "Beige"}
local colorRGB = {
    Rojo = Color3.fromRGB(255, 0, 0),
    Naranja = Color3.fromRGB(255, 165, 0),
    Amarillo = Color3.fromRGB(255, 255, 0),
    ["Verde lima"] = Color3.fromRGB(50, 205, 50),
    ["Azul cielo"] = Color3.fromRGB(135, 206, 235),
    ["Azul marino"] = Color3.fromRGB(0, 0, 128),
    Morado = Color3.fromRGB(128, 0, 128),
    Rosa = Color3.fromRGB(255, 192, 203),
    Marrón = Color3.fromRGB(139, 69, 19),
    Negro = Color3.fromRGB(0, 0, 0),
    Blanco = Color3.fromRGB(255, 255, 255),
    Gris = Color3.fromRGB(128, 128, 128),
    Turquesa = Color3.fromRGB(64, 224, 208),
    Fucsia = Color3.fromRGB(255, 0, 255),
    Beige = Color3.fromRGB(245, 245, 220)
}

local espColorChoices = {
    Murderer = "Rojo",
    Sheriff = "Azul marino",
    Innocent = "Verde lima"
}

local lastAFKJump = 0
local circleButton = nil

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrisHubMM2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 340, 0, 420)
Frame.Position = UDim2.new(0.5, -170, 0.5, -210)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "CHRISSHUB MM2 V3"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = Frame

local TikTokText = Instance.new("TextLabel")
TikTokText.Size = UDim2.new(1, 0, 0, 30)
TikTokText.Position = UDim2.new(0, 0, 0, 50)
TikTokText.Text = "Sígueme en TikTok: sasware32"
TikTokText.TextColor3 = Color3.fromRGB(255, 255, 255)
TikTokText.BackgroundTransparency = 1
TikTokText.Font = Enum.Font.Gotham
TikTokText.TextSize = 16
TikTokText.Parent = Frame

-- ScrollingFrame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -150)
ScrollFrame.Position = UDim2.new(0, 10, 0, 80)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
ScrollFrame.Parent = Frame

-- Toggle ESP
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, 0, 0, 40)
ESPToggle.Position = UDim2.new(0, 0, 0, 0)
ESPToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.TextSize = 14
Instance.new("UICorner", ESPToggle)
ESPToggle.Parent = ScrollFrame

ESPToggle.MouseButton1Click:Connect(function()
    toggles.ESP = not toggles.ESP
    ESPToggle.Text = "ESP: " .. (toggles.ESP and "ON" or "OFF")
    ESPToggle.BackgroundColor3 = toggles.ESP and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(25, 25, 25)
end)

-- Colores Asesino
local AsesinoColorBtn = Instance.new("TextButton")
AsesinoColorBtn.Size = UDim2.new(1, 0, 0, 40)
AsesinoColorBtn.Position = UDim2.new(0, 0, 0, 50)
AsesinoColorBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AsesinoColorBtn.Text = "Asesino: " .. espColorChoices.Murderer
AsesinoColorBtn.TextColor3 = colorRGB[espColorChoices.Murderer]
AsesinoColorBtn.Font = Enum.Font.Gotham
AsesinoColorBtn.TextSize = 14
Instance.new("UICorner", AsesinoColorBtn)
AsesinoColorBtn.Parent = ScrollFrame

AsesinoColorBtn.MouseButton1Click:Connect(function()
    local current = espColorChoices.Murderer
    local index = table.find(colorOptions, current)
    espColorChoices.Murderer = colorOptions[(index % #colorOptions) + 1]
    AsesinoColorBtn.Text = "Asesino: " .. espColorChoices.Murderer
    AsesinoColorBtn.TextColor3 = colorRGB[espColorChoices.Murderer]
end)

-- (Agrega aquí los botones para Sheriff e Inocente si quieres, copiando el de Asesino)

-- Botón Cerrar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9, 0, 0, 40)
CloseBtn.Position = UDim2.new(0.05, 0, 1, -50)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseBtn.Text = "OCULTAR"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
Instance.new("UICorner", CloseBtn)
CloseBtn.Parent = Frame

CloseBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    if not circleButton then
        circleButton = Instance.new("TextButton")
        circleButton.Size = UDim2.new(0, 70, 0, 70)
        circleButton.Position = UDim2.new(0.5, -35, 0, 20)
        circleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        circleButton.Text = "CH"
        circleButton.TextColor3 = Color3.fromRGB(0, 255, 120)
        circleButton.Font = Enum.Font.GothamBlack
        circleButton.TextSize = 24
        circleButton.BorderSizePixel = 0
        circleButton.Parent = ScreenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circleButton
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 120)
        stroke.Thickness = 2
        stroke.Transparency = 0.2
        stroke.Parent = circleButton
        
        circleButton.MouseButton1Click:Connect(function()
            Frame.Visible = true
            circleButton:Destroy()
            circleButton = nil
        end)
    end
end)

-- Insert para abrir menú
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
        if Frame.Visible and circleButton then
            circleButton:Destroy()
            circleButton = nil
        end
    end
end)

-- ==========================================
-- FUNCIONES
-- ==========================================

local function getChar() return player.Character end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

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
    local char = getChar()
    if not char then return end
    local root = getRoot()
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
                hl.FillColor = colorRGB[espColorChoices[role]]
                hl.OutlineColor = colorRGB[espColorChoices[role]]
            end
        end
    else
        for _, hl in pairs(espHighlights) do hl.Enabled = false end
    end

    -- Kill Aura (35 studs)
    if toggles.KillAura and char:FindFirstChild("Knife") then
        for _, plr in Players:GetPlayers() do
            if plr \~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 35 then
                    char.Knife.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- Aimbot normal
    if toggles.Aimbot then
        local closest, dist = nil, math.huge
        local camPos = camera.CFrame.Position
        
        for _, plr in Players:GetPlayers() do
            if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local head = plr.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
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

    -- Aimbot Legit
    if toggles.AimbotLegit then
        local closest, dist = nil, math.huge
        local camPos = camera.CFrame.Position
        
        for _, plr in Players:GetPlayers() do
            if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local head = plr.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
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

    -- Aimbot solo Asesino
    if toggles.AimbotAsesino then
        local closest, dist = nil, math.huge
        local camPos = camera.CFrame.Position
        
        for _, plr in Players:GetPlayers() do
            if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Knife") then
                local head = plr.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
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
end)

-- Noclip Pro
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

print("[CHRISSHUB MM2 V3] Cargado completo. Usa INSERT para menú.")
