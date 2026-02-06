--[[
    CHRISSHUB MM2 V6 - SUPREMO ELITE EDITION
    Arreglado para Delta (Compatibilidad Total)
    Key: CHRIS2026
]]

local KEY_SISTEMA = "CHRIS2026"

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- ESTADOS
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

-- UI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrisHub_Elite_V6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- FUNCIÓN PARA HACER OBJETOS ARRASTRABLES (MOVIBLES)
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- LOGIN FRAME (DISEÑO ELITE)
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 320, 0, 260)
LoginFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoginFrame.BorderSizePixel = 0
local LCorner = Instance.new("UICorner", LoginFrame); LCorner.CornerRadius = UDim.new(0, 12)
local LStroke = Instance.new("UIStroke", LoginFrame); LStroke.Color = Color3.fromRGB(0, 255, 120); LStroke.Thickness = 2

local LHeader = Instance.new("TextLabel", LoginFrame)
LHeader.Size = UDim2.new(1, 0, 0, 60)
LHeader.Text = "CHRISSHUB ELITE"
LHeader.TextColor3 = Color3.new(1,1,1)
LHeader.Font = Enum.Font.GothamBlack
LHeader.TextSize = 22
LHeader.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
KeyInput.Position = UDim2.new(0.075, 0, 0.38, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyInput.PlaceholderText = "(Enter License)"
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.new(1,1,1)
KeyInput.Font = Enum.Font.GothamBold
Instance.new("UICorner", KeyInput)

local AuthBtn = Instance.new("TextButton", LoginFrame)
AuthBtn.Size = UDim2.new(0.85, 0, 0, 45)
AuthBtn.Position = UDim2.new(0.075, 0, 0.68, 0)
AuthBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
AuthBtn.Text = "ACCESS SYSTEM"
AuthBtn.TextColor3 = Color3.fromRGB(0,0,0)
AuthBtn.Font = Enum.Font.GothamBlack
Instance.new("UICorner", AuthBtn)

-- MENÚ PRINCIPAL (DISEÑO TIPO LISTA PREMIUM)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 480)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local MStroke = Instance.new("UIStroke", MainFrame); MStroke.Color = Color3.fromRGB(0, 255, 120); MStroke.Thickness = 2.5
MakeDraggable(MainFrame)

local MTitle = Instance.new("TextLabel", MainFrame)
MTitle.Size = UDim2.new(1, 0, 0, 60)
MTitle.Text = "CHRISSHUB SUPREMO V6"
MTitle.TextColor3 = Color3.new(1,1,1)
MTitle.Font = Enum.Font.GothamBlack
MTitle.TextSize = 18
MTitle.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -30, 1, -80)
Container.Position = UDim2.new(0, 15, 0, 70)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 0) -- Se ajusta solo
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 12)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- FUNCIÓN PARA BOTONES ESTILO LISTA
local function AddToggle(name, icon)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.95, 0, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    local C = Instance.new("UICorner", Frame); C.CornerRadius = UDim.new(0, 8)
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = name:upper()
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.TextSize = 14
    
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 80, 0, 30)
    Button.Position = UDim2.new(1, -95, 0.5, -15)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Text = "OFF"
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)
    
    Button.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        Button.Text = toggles[name] and "ON" or "OFF"
        local targetColor = toggles[name] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(35, 35, 35)
        local textColor = toggles[name] and Color3.new(0,0,0) or Color3.new(1,1,1)
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = targetColor, TextColor3 = textColor}):Play()
    end)
    
    Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end

-- AGREGAR LAS FUNCIONES A LA LISTA
AddToggle("ESP")
AddToggle("Aimbot")
AddToggle("KillAura")
AddToggle("Noclip")
AddToggle("InfJump")
AddToggle("AntiAFK")
AddToggle("Speed")

-- BOTÓN FLOTANTE (MOVIBLE)
local Float = Instance.new("TextButton", ScreenGui)
Float.Size = UDim2.new(0, 60, 0, 60)
Float.Position = UDim2.new(0.05, 0, 0.45, 0)
Float.BackgroundColor3 = Color3.new(0, 0, 0)
Float.Text = "CH"
Float.TextColor3 = Color3.fromRGB(0, 255, 120)
Float.Font = Enum.Font.GothamBlack
Float.TextSize = 22
Float.Visible = false
Instance.new("UICorner", Float).CornerRadius = UDim.new(1, 0)
local FStroke = Instance.new("UIStroke", Float); FStroke.Color = Color3.fromRGB(0, 255, 120); FStroke.Thickness = 2
MakeDraggable(Float)

Float.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- MOTOR DE LÓGICA (GROK + MEJORAS)
-- ==========================================

local function handleESP(plr)
    if plr == lp then return end
    local function setup(char)
        if espHighlights[plr] then espHighlights[plr]:Destroy() end
        local hl = Instance.new("Highlight")
        hl.Parent = char
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espHighlights[plr] = hl
    end
    if plr.Character then setup(plr.Character) end
    plr.CharacterAdded:Connect(setup)
end

for _, p in Players:GetPlayers() do handleESP(p) end
Players.PlayerAdded:Connect(handleESP)

RunService.Heartbeat:Connect(function()
    if not lp.Character then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character:FindFirstChild("Humanoid")
    if not root or not hum then return end

    -- Speed
    if toggles.Speed then hum.WalkSpeed = 75 else hum.WalkSpeed = 16 end

    -- Anti-AFK
    if toggles.AntiAFK and tick() - lastAFKJump > 25 then
        hum:ChangeState(3)
        lastAFKJump = tick()
    end

    -- ESP Visuals
    if toggles.ESP then
        for p, hl in pairs(espHighlights) do
            if p.Character and hl.Parent then
                hl.Enabled = true
                local m = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                local s = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                hl.FillColor = m and Color3.new(1,0,0) or (s and Color3.new(0,0.4,1) or Color3.new(1,1,1))
            end
        end
    else
        for _, h in pairs(espHighlights) do h.Enabled = false end
    end

    -- Kill Aura 360
    if toggles.KillAura then
        local knife = lp.Character:FindFirstChild("Knife")
        if knife then
            for _, p in Players:GetPlayers() do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude < 18 then
                        firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 0)
                        firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 1)
                    end
                end
            end
        end
    end

    -- Aimbot con Cámara Suave
    if toggles.Aimbot then
        local target, bestD = nil, 400
        for _, p in Players:GetPlayers() do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local mD = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if mD < bestD then bestD = mD; target = p.Character.Head end
                end
            end
        end
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- InfJump
UserInputService.JumpRequest:Connect(function()
    if toggles.InfJump and hum then hum:ChangeState(3) end
end)

-- RAINBOW NEON BORDER (PARA DARLE ESTILO)
task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 0.8, 1)
        LStroke.Color = color
        MStroke.Color = color
        FStroke.Color = color
    end
end)

-- AUTH FINAL
AuthBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY_SISTEMA then
        LoginFrame:Destroy()
        MainFrame.Visible = true
        Float.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "INVALID LICENSE"
    end
end)
