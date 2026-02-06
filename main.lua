--[[
    CHRISSHUB MM2 V5 - SUPREMO ELITE EDITION (FULL VERSION)
    Key: CHRIS2026
    
    ESTE SCRIPT CONTIENE LÓGICA DE ALTA PRIORIDAD.
    TODOS LOS DERECHOS RESERVADOS A CHRIS.
]]

local KEY_SISTEMA = "CHRIS2026"

-- SERVICIOS DEL SISTEMA
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

-- VARIABLES DEL JUGADOR
local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- CONFIGURACIÓN DE ESTADO
local Settings = {
    ESP = false,
    Aimbot = false,
    KillAura = false,
    Hitbox = false,
    Noclip = false,
    InfJump = false,
    Speed = false,
    AutoFarm = false,
    Visuals = {
        MenuColor = Color3.fromRGB(0, 255, 120),
        Rainbow = true
    }
}

-- ALMACENAMIENTO DE CACHÉ
local Cache = {
    Highlights = {},
    Connections = {}
}

-- GENERAR INTERFAZ PROTEGIDA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CH_" .. HttpService:GenerateGUID(false):sub(1,8)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- FUNCIÓN PARA ANIMACIONES SUAVES
local function ApplyTween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(info), goal)
    t:Play()
    return t
end

-- DISEÑO DE BORDES NEÓN (RAINBOW)
local function CreateNeonBorder(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Settings.Visuals.MenuColor
    stroke.ApplyStrokeMode = Enum.UIStrokeMode.Border
    stroke.Parent = parent
    
    task.spawn(function()
        while task.wait() do
            local hue = tick() % 5 / 5
            stroke.Color = Color3.fromHSV(hue, 1, 1)
        end
    end)
    return stroke
end

-- ==========================================
-- MARCO DE SEGURIDAD (LOGIN)
-- ==========================================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 360, 0, 280)
LoginFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
LoginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 15)
CreateNeonBorder(LoginFrame)

local Header = Instance.new("TextLabel", LoginFrame)
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundTransparency = 1
Header.Text = "CHRISSHUB ELITE"
Header.TextColor3 = Color3.new(1, 1, 1)
Header.Font = Enum.Font.GothamBlack
Header.TextSize = 26

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.85, 0, 0, 55)
KeyInput.Position = UDim2.new(0.075, 0, 0.4, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyInput.Text = ""
KeyInput.PlaceholderText = "(Enter License)" -- CAMBIADO A INGLÉS COMO PEDISTE
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 16
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

local AuthButton = Instance.new("TextButton", LoginFrame)
AuthButton.Size = UDim2.new(0.85, 0, 0, 55)
AuthButton.Position = UDim2.new(0.075, 0, 0.7, 0)
AuthButton.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
AuthButton.Text = "SUBMIT"
AuthButton.TextColor3 = Color3.new(0, 0, 0)
AuthButton.Font = Enum.Font.GothamBlack
Instance.new("UICorner", AuthButton).CornerRadius = UDim.new(0, 10)

-- ==========================================
-- MENÚ PRINCIPAL (DISEÑO ELITE)
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 520)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)
CreateNeonBorder(MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "CHRISSHUB MM2 V5 SUPREMO"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -40, 1, -100)
Container.Position = UDim2.new(0, 20, 0, 80)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 2, 0)
Container.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 10)

local function AddFeature(name, desc, callback)
    local Card = Instance.new("Frame", Container)
    Card.Size = UDim2.new(1, 0, 0, 70)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", Card)
    
    local T = Instance.new("TextLabel", Card)
    T.Text = name:upper()
    T.Size = UDim2.new(1, -100, 0, 30)
    T.Position = UDim2.new(0, 15, 0, 10)
    T.TextColor3 = Color3.new(1, 1, 1)
    T.Font = Enum.Font.GothamBold
    T.BackgroundTransparency = 1
    T.TextXAlignment = "Left"
    
    local D = Instance.new("TextLabel", Card)
    D.Text = desc
    D.Size = UDim2.new(1, -100, 0, 20)
    D.Position = UDim2.new(0, 15, 0, 35)
    D.TextColor3 = Color3.fromRGB(150,150,150)
    D.Font = Enum.Font.Gotham
    D.TextSize = 11
    D.BackgroundTransparency = 1
    D.TextXAlignment = "Left"
    
    local Toggle = Instance.new("TextButton", Card)
    Toggle.Size = UDim2.new(0, 60, 0, 30)
    Toggle.Position = UDim2.new(1, -75, 0.5, -15)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
    
    Toggle.MouseButton1Click:Connect(function()
        Settings[name] = not Settings[name]
        Toggle.Text = Settings[name] and "ON" or "OFF"
        ApplyTween(Toggle, 0.2, {BackgroundColor3 = Settings[name] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(35, 35, 35)})
        if callback then callback(Settings[name]) end
    end)
end

-- ==========================================
-- LÓGICA DE FUNCIONES MEJORADAS
-- ==========================================

-- Kill Aura 360 Pro
task.spawn(function()
    while task.wait(0.05) do
        if Settings.KillAura and lp.Character then
            local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if knife then
                if knife.Parent ~= lp.Character then knife.Parent = lp.Character end
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 28 then
                            firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 0)
                            firetouchinterest(p.Character.HumanoidRootPart, knife.Handle, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- Aimbot con Predicción
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local target, dist = nil, 400
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if mDist < dist then dist = mDist; target = p end
                end
            end
        end
        if target then
            local prediction = target.Character.HumanoidRootPart.Velocity * 0.16
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position + prediction)
        end
    end
end)

-- Auto-Farm Monedas
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoFarm and lp.Character:FindFirstChild("HumanoidRootPart") then
            local coins = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
            if coins then
                for _, c in pairs(coins:GetChildren()) do
                    if c:IsA("BasePart") then
                        lp.Character.HumanoidRootPart.CFrame = c.CFrame
                        task.wait(0.15)
                    end
                end
            end
        end
    end
end)

-- Hitbox Expander
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Settings.Hitbox and Vector3.new(20, 20, 20) or Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = Settings.Hitbox and 0.7 or 1
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- ==========================================
-- REGISTRO Y ACTIVACIÓN
-- ==========================================
AddFeature("ESP", "Muestra roles de Murderer y Sheriff.")
AddFeature("Aimbot", "Apunta automáticamente al enemigo.")
AddFeature("KillAura", "Mata a todos los que estén cerca.")
AddFeature("Hitbox", "Hace a los enemigos más fáciles de golpear.")
AddFeature("AutoFarm", "Recolecta monedas automáticamente.")
AddFeature("Noclip", "Atraviesa todas las paredes.")
AddFeature("Speed", "Velocidad de movimiento máxima (85).")
AddFeature("InfJump", "Salto infinito habilitado.")

local Floating = Instance.new("TextButton", ScreenGui)
Floating.Size = UDim2.new(0, 60, 0, 60)
Floating.Position = UDim2.new(0, 20, 0.4, 0)
Floating.BackgroundColor3 = Color3.new(0,0,0)
Floating.Text = "CH"
Floating.TextColor3 = Color3.fromRGB(0, 255, 120)
Floating.Font = Enum.Font.GothamBlack
Floating.Visible = false
Instance.new("UICorner", Floating).CornerRadius = UDim.new(1, 0)
CreateNeonBorder(Floating)

Floating.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

AuthButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY_SISTEMA then
        LoginFrame:Destroy()
        MainFrame.Visible = true
        Floating.Visible = true
        
        -- Iniciar ESP
        local function doESP(p)
            if p == lp then return end
            p.CharacterAdded:Connect(function(c)
                local h = Instance.new("Highlight", c)
                h.DepthMode = "AlwaysOnTop"
                Cache.Highlights[p] = h
            end)
        end
        for _, p in pairs(Players:GetPlayers()) do doESP(p) end
        Players.PlayerAdded:Connect(doESP)
        
        RunService.Heartbeat:Connect(function()
            if Settings.ESP then
                for p, h in pairs(Cache.Highlights) do
                    if p.Character then
                        h.Enabled = true
                        local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                        local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                        h.FillColor = isM and Color3.new(1,0,0) or (isS and Color3.new(0,0.5,1) or Color3.new(1,1,1))
                    end
                end
            else
                for _, h in pairs(Cache.Highlights) do h.Enabled = false end
            end
            if Settings.Speed and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = 85 end
            if Settings.Noclip and lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end)
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "WRONG LICENSE"
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState(3) end
end)
