--[[
    CHRISSHUB MM2 V5 - SUPREMO EDITION (DELTA COMPATIBLE)
    Key: CHRIS2026
    
    Fusionando Funciones Pro de Grok + Interfaz Elite de Gemini.
]]

local KEY_SISTEMA = "CHRIS2026"

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ESTADOS DEL MOTOR (Respetando lógica de Grok)
local toggles = {
    ESP = false,
    Aimbot = false,
    KillAura = false,
    Noclip = false,
    InfJump = false,
    AntiAFK = false,
    Speed = false
}

local espHighlights = {}
local lastAFKJump = 0

-- ==========================================
-- INTERFAZ VISUAL (Mejorada y Compatible)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrisHub_Elite_V5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- LOGIN FRAME
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 300, 0, 220)
LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
LoginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LoginFrame.BorderSizePixel = 2
LoginFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", LoginFrame)

local LTitle = Instance.new("TextLabel", LoginFrame)
LTitle.Size = UDim2.new(1, 0, 0, 50)
LTitle.Text = "CHRISSHUB ELITE V5"
LTitle.TextColor3 = Color3.new(1,1,1)
LTitle.Font = Enum.Font.GothamBlack
LTitle.TextSize = 20
LTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.38, 0)
KeyInput.PlaceholderText = "(Enter License)" -- Tu pedido en inglés
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.new(1,1,1)
KeyInput.Font = Enum.Font.Gotham
Instance.new("UICorner", KeyInput)

local AuthBtn = Instance.new("TextButton", LoginFrame)
AuthBtn.Size = UDim2.new(0.8, 0, 0, 40)
AuthBtn.Position = UDim2.new(0.1, 0, 0.68, 0)
AuthBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
AuthBtn.Text = "VALIDATE"
AuthBtn.Font = Enum.Font.GothamBold
AuthBtn.TextColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", AuthBtn)

-- MENÚ PRINCIPAL
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 420)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 10)

-- BOTONES TÁCTILES DEL MENÚ
local function AddMenuToggle(name, desc)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name .. (toggles[name] and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(25, 25, 25)
        btn.TextColor3 = toggles[name] and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)
end

AddMenuToggle("ESP")
AddMenuToggle("Aimbot")
AddMenuToggle("KillAura")
AddMenuToggle("Noclip")
AddMenuToggle("InfJump")
AddMenuToggle("AntiAFK")
AddMenuToggle("Speed")

-- BOTÓN FLOTANTE
local Float = Instance.new("TextButton", ScreenGui)
Float.Size = UDim2.new(0, 55, 0, 55)
Float.Position = UDim2.new(0, 15, 0.45, 0)
Float.BackgroundColor3 = Color3.new(0,0,0)
Float.Text = "CH"
Float.TextColor3 = Color3.fromRGB(0, 255, 150)
Float.Font = Enum.Font.GothamBlack
Float.Visible = false
Instance.new("UICorner", Float).CornerRadius = UDim.new(1, 0)

Float.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ==========================================
-- MOTOR DE FUNCIONES (Lógica Grok + Mejoras)
-- ==========================================

-- ESP Lógica
local function addESP(plr)
    if plr == player then return end
    local function update(char)
        if espHighlights[plr] then espHighlights[plr]:Destroy() end
        local hl = Instance.new("Highlight")
        hl.Parent = char
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espHighlights[plr] = hl
    end
    if plr.Character then update(plr.Character) end
    plr.CharacterAdded:Connect(update)
end

for _, plr in Players:GetPlayers() do addESP(plr) end
Players.PlayerAdded:Connect(addESP)

-- LOOP PRINCIPAL
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    -- Speed Hack
    if toggles.Speed then hum.WalkSpeed = 85 else hum.WalkSpeed = 16 end

    -- Anti-AFK
    if toggles.AntiAFK and tick() - lastAFKJump > 30 then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        lastAFKJump = tick()
    end

    -- ESP Visuals
    if toggles.ESP then
        for plr, hl in pairs(espHighlights) do
            if plr.Character and hl.Parent then
                hl.Enabled = true
                local isM = plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")
                local isS = plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun")
                
                if isM then hl.FillColor = Color3.new(1, 0, 0)
                elseif isS then hl.FillColor = Color3.new(0, 0.4, 1)
                else hl.FillColor = Color3.new(1, 1, 1) end
            end
        end
    else
        for _, hl in pairs(espHighlights) do hl.Enabled = false end
    end

    -- Kill Aura
    if toggles.KillAura then
        local knife = char:FindFirstChild("Knife")
        if knife then
            for _, plr in Players:GetPlayers() do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 18 then
                        firetouchinterest(plr.Character.HumanoidRootPart, knife.Handle, 0)
                        firetouchinterest(plr.Character.HumanoidRootPart, knife.Handle, 1)
                    end
                end
            end
        end
    end

    -- Aimbot
    if toggles.Aimbot then
        local closest, dist = nil, 400
        for _, plr in Players:GetPlayers() do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if d < dist then
                        closest = head
                        dist = d
                    end
                end
            end
        end
        if closest then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position)
        end
    end
end)

-- Noclip Logic
RunService.Stepped:Connect(function()
    if toggles.Noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Inf Jump Logic
UserInputService.JumpRequest:Connect(function()
    if toggles.InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- SISTEMA DE ACCESO (KEY)
AuthBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY_SISTEMA then
        LoginFrame:Destroy()
        MainFrame.Visible = true
        Float.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "WRONG LICENSE"
    end
end)
