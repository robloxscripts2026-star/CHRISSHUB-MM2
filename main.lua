--[[
    CHRISSHUB MM2 V7 - ELITE SUPREMO EDITION
    Key: CHRIS2026
    
    Fusionando Lógica Grok + Interfaz Elite de Gemini.
    Optimizado para carga desde GitHub/Raw.
]]

local KEY_SISTEMA = "CHRIS2026"

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- ESTADOS DEL HUB
local toggles = {
    ESP = false,
    Aimbot = false,
    KillAura = false,
    Noclip = false,
    InfJump = false,
    AntiAFK = false,
    Speed = false,
    Hitbox = false
}

local espHighlights = {}
local lastAFKJump = 0

-- UI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrisHub_Elite_V7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- NOTIFICACIONES ELITE
local function Notify(text, color)
    local nFrame = Instance.new("Frame", ScreenGui)
    nFrame.Size = UDim2.new(0, 200, 0, 40)
    nFrame.Position = UDim2.new(1, 10, 0.85, 0)
    nFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", nFrame)
    local ns = Instance.new("UIStroke", nFrame); ns.Color = color or Color3.fromRGB(0, 255, 120); ns.Thickness = 1
    
    local nText = Instance.new("TextLabel", nFrame)
    nText.Size = UDim2.new(1, 0, 1, 0)
    nText.BackgroundTransparency = 1
    nText.Text = text
    nText.TextColor3 = Color3.new(1,1,1)
    nText.Font = Enum.Font.GothamBold
    nText.TextSize = 12
    
    nFrame:TweenPosition(UDim2.new(1, -210, 0.85, 0), "Out", "Back", 0.5)
    task.wait(2.5)
    nFrame:TweenPosition(UDim2.new(1, 10, 0.85, 0), "In", "Linear", 0.5)
    Debris:AddItem(nFrame, 0.5)
end

-- FUNCIÓN ARRASTRABLE
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    RunService.RenderStepped:Connect(function() if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
end

-- LOGIN FRAME (CON EFECTO DE CARGA)
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 320, 0, 280)
LoginFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", LoginFrame)
local LStroke = Instance.new("UIStroke", LoginFrame); LStroke.Thickness = 2

local LHeader = Instance.new("TextLabel", LoginFrame)
LHeader.Size = UDim2.new(1, 0, 0, 60)
LHeader.Text = "CHRISSHUB ELITE V7"
LHeader.TextColor3 = Color3.new(1,1,1)
LHeader.Font = Enum.Font.GothamBlack
LHeader.TextSize = 22
LHeader.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyInput.PlaceholderText = "(Enter License)"
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.new(1,1,1)
KeyInput.Font = Enum.Font.GothamBold
Instance.new("UICorner", KeyInput)

local AuthBtn = Instance.new("TextButton", LoginFrame)
AuthBtn.Size = UDim2.new(0.85, 0, 0, 45)
AuthBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
AuthBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
AuthBtn.Text = "LOG IN"
AuthBtn.Font = Enum.Font.GothamBlack
Instance.new("UICorner", AuthBtn)

local LoadingBar = Instance.new("Frame", LoginFrame)
LoadingBar.Size = UDim2.new(0, 0, 0, 4)
LoadingBar.Position = UDim2.new(0.075, 0, 0.85, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
LoadingBar.Visible = false
Instance.new("UICorner", LoadingBar)

-- MENÚ PRINCIPAL
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local MStroke = Instance.new("UIStroke", MainFrame); MStroke.Thickness = 2.5
MakeDraggable(MainFrame)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.Position = UDim2.new(0, 10, 0, 70)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0,0,2.2,0)
local UIList = Instance.new("UIListLayout", Container); UIList.Padding = UDim.new(0, 10); UIList.HorizontalAlignment = "Center"

local function AddLabel(text)
    local l = Instance.new("TextLabel", Container)
    l.Size = UDim2.new(0.9, 0, 0, 25)
    l.Text = "-- " .. text .. " --"
    l.TextColor3 = Color3.fromRGB(150, 150, 150)
    l.Font = Enum.Font.GothamBold
    l.BackgroundTransparency = 1
    l.TextSize = 12
end

local function AddToggle(name)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name .. (toggles[name] and " [ON]" or " [OFF]")
        local col = toggles[name] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(20, 20, 20)
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = col, TextColor3 = (toggles[name] and Color3.new(0,0,0) or Color3.new(1,1,1))}):Play()
        Notify(name .. (toggles[name] and " ACTIVATED" or " DEACTIVATED"), col)
    end)
end

-- AGREGAR CONTENIDO AL MENÚ
AddLabel("COMBAT")
AddToggle("KillAura")
AddToggle("Aimbot")
AddToggle("Hitbox")
AddLabel("VISUALS")
AddToggle("ESP")
AddLabel("MOVEMENT & UTILITY")
AddToggle("Speed")
AddToggle("Noclip")
AddToggle("InfJump")
AddToggle("AntiAFK")

-- BOTÓN FLOTANTE
local Float = Instance.new("TextButton", ScreenGui)
Float.Size = UDim2.new(0, 60, 0, 60)
Float.Position = UDim2.new(0, 20, 0.4, 0)
Float.BackgroundColor3 = Color3.new(0,0,0)
Float.Text = "CH"
Float.TextColor3 = Color3.fromRGB(0, 255, 120)
Float.Font = Enum.Font.GothamBlack
Float.Visible = false
Instance.new("UICorner", Float).CornerRadius = UDim.new(1,0)
local FStroke = Instance.new("UIStroke", Float); FStroke.Thickness = 2
MakeDraggable(Float)
Float.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- MOTOR DE FUNCIONES (Grok Logic)
local function handleESP(plr)
    if plr == lp then return end
    local function setup(char)
        if espHighlights[plr] then espHighlights[plr]:Destroy() end
        local hl = Instance.new("Highlight", char)
        hl.FillTransparency = 0.5; hl.DepthMode = "AlwaysOnTop"
        espHighlights[plr] = hl
    end
    if plr.Character then setup(plr.Character) end
    plr.CharacterAdded:Connect(setup)
end
for _, p in Players:GetPlayers() do handleESP(p) end
Players.PlayerAdded:Connect(handleESP)

RunService.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local hum = lp.Character.Humanoid

    if toggles.Speed then hum.WalkSpeed = 80 else hum.WalkSpeed = 16 end
    if toggles.AntiAFK and tick() - lastAFKJump > 25 then hum:ChangeState(3); lastAFKJump = tick() end

    if toggles.ESP then
        for p, hl in pairs(espHighlights) do
            if p.Character and hl.Parent then
                hl.Enabled = true
                local m = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                local s = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                hl.FillColor = m and Color3.new(1,0,0) or (s and Color3.new(0,0.5,1) or Color3.new(1,1,1))
            end
        end
    else
        for _, h in pairs(espHighlights) do h.Enabled = false end
    end

    if toggles.KillAura then
        local kn = lp.Character:FindFirstChild("Knife")
        if kn then
            for _, p in Players:GetPlayers() do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude < 20 then
                        firetouchinterest(p.Character.HumanoidRootPart, kn.Handle, 0)
                        firetouchinterest(p.Character.HumanoidRootPart, kn.Handle, 1)
                    end
                end
            end
        end
    end

    if toggles.Aimbot then
        local target, best = nil, 400
        for _, p in Players:GetPlayers() do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if d < best then best = d; target = p.Character.Head end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end
    
    if toggles.Hitbox then
        for _, p in Players:GetPlayers() do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.Shape = "Ball"
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- RAINBOW & AUTH
task.spawn(function()
    while task.wait() do
        local color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
        LStroke.Color = color; MStroke.Color = color; FStroke.Color = color
    end
end)

AuthBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY_SISTEMA then
        AuthBtn.Visible = false
        KeyInput.Visible = false
        LoadingBar.Visible = true
        LHeader.Text = "Checking License..."
        LoadingBar:TweenSize(UDim2.new(0.85, 0, 0, 4), "Out", "Linear", 1.5)
        task.wait(1.6)
        LoginFrame:Destroy()
        MainFrame.Visible = true
        Float.Visible = true
        Notify("WELCOME CHRIS - HUB LOADED", Color3.new(1,1,1))
    else
        KeyInput.Text = ""; KeyInput.PlaceholderText = "WRONG KEY"
    end
end)
