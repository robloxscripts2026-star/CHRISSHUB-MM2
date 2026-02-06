--[[
    CHRISSHUB MM2 V13 - REBORN EDITION
    Inspirado en Xhub & Estilo Minimalista
    TikTok: sasware32
    
    DISEÑO:
    - Sidebar Izquierda con Iconos
    - Logo Circular Superior
    - Toggle Buttons Estilo iOS
    - Kill Aura 35 Studs & Aimbot Lock
]]

-- [ CONFIGURACIÓN Y KEYS ]
local VALID_KEYS = {["14151"]=true, ["1470"]=true, ["8576"]=true, ["CHRIS2026"]=true}
local APP_NAME = "CHRISSHUB"

-- [ SERVICIOS ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local camera = Workspace.CurrentCamera

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild("ChrisReborn") then CoreGui.ChrisReborn:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ChrisReborn"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [ ESTADO ]
local Hub = {
    Active = false,
    Toggles = {
        ESP = false, Aimbot = false, KillAura = false, Noclip = false, 
        InfJump = false, Speed = false, AimbotLegit = false, AimbotAsesino = false
    },
    Config = {
        ThemeColor = Color3.fromRGB(0, 255, 150),
        WalkSpeed = 75
    }
}

-- [ FUNCIONES DE UI ]
local function SmoothTween(obj, time, prop)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop):Play()
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- [ INTRO CHRISSHUB ]
local function PlayIntro()
    local I = Instance.new("Frame", ScreenGui)
    I.Size = UDim2.new(1,0,1,0); I.BackgroundColor3 = Color3.new(0,0,0); I.ZIndex = 100
    local T = Instance.new("TextLabel", I)
    T.Size = UDim2.new(1,0,1,0); T.Text = "CHRISSHUB"; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBlack"; T.TextSize = 2; T.BackgroundTransparency = 1
    task.wait(0.2)
    SmoothTween(T, 0.8, {TextSize = 60})
    task.wait(1)
    SmoothTween(I, 0.5, {BackgroundTransparency = 1})
    SmoothTween(T, 0.5, {TextTransparency = 1})
    task.wait(0.5); I:Destroy()
end

-- [ DISEÑO DEL MENÚ ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 320)
Main.Position = UDim2.new(0.5, -260, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main); MStroke.Color = Hub.Config.ThemeColor; MStroke.Thickness = 2

-- Logo Circular Superior (Como en tu foto)
local LogoHandle = Instance.new("Frame", Main)
LogoHandle.Size = UDim2.new(0, 60, 0, 60)
LogoHandle.Position = UDim2.new(0.5, -30, 0, -35)
LogoHandle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", LogoHandle).CornerRadius = UDim.new(1, 0)
local LStroke = Instance.new("UIStroke", LogoHandle); LStroke.Color = Hub.Config.ThemeColor; LStroke.Thickness = 2

local LogoImg = Instance.new("ImageLabel", LogoHandle)
LogoImg.Size = UDim2.new(0.8, 0, 0.8, 0)
LogoImg.Position = UDim2.new(0.1, 0, 0.1, 0)
LogoImg.Image = "rbxassetid://603122934" -- Icono de Ninja/Asesino
LogoImg.BackgroundTransparency = 1
Instance.new("UICorner", LogoImg).CornerRadius = UDim.new(1, 0)

MakeDraggable(Main, LogoHandle)

-- Sidebar (Estilo Xhub)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar)

local SLayout = Instance.new("UIListLayout", Sidebar); SLayout.Padding = UDim.new(0, 5); SLayout.HorizontalAlignment = "Center"
local STitle = Instance.new("TextLabel", Sidebar)
STitle.Size = UDim2.new(1, 0, 0, 40); STitle.Text = "Xhub : MM2"; STitle.TextColor3 = Color3.new(1,1,1); STitle.Font = "GothamBold"; STitle.TextSize = 14; STitle.BackgroundTransparency = 1

-- Contenedor de Páginas
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -150, 1, -20)
Container.Position = UDim2.new(0, 145, 0, 10)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
    
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 35); B.BackgroundColor3 = Color3.fromRGB(25, 25, 25); B.Text = name
    B.TextColor3 = Color3.new(0.8, 0.8, 0.8); B.Font = "GothamBold"; B.TextSize = 12
    Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        P.Visible = true
    end)
    Pages[name] = P
    return P
end

local MainPg = CreatePage("Main")
local EspPg = CreatePage("ESP")
local CombatPg = CreatePage("Combat")
MainPg.Visible = true

-- [ COMPONENTES ]
local function AddToggle(parent, text, var)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(1, 0, 0, 40); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", F)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(0.7, 0, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.Text = text; T.TextColor3 = Color3.new(1,1,1)
    T.Font = "GothamBold"; T.TextSize = 12; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0, 40, 0, 20); B.Position = UDim2.new(1, -50, 0.5, -10); B.BackgroundColor3 = Color3.fromRGB(45, 45, 45); B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local C = Instance.new("Frame", B)
    C.Size = UDim2.new(0, 16, 0, 16); C.Position = UDim2.new(0, 2, 0.5, -8); C.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", C).CornerRadius = UDim.new(1, 0)
    
    B.MouseButton1Click:Connect(function()
        Hub.Toggles[var] = not Hub.Toggles[var]
        SmoothTween(C, 0.2, {Position = Hub.Toggles[var] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
        SmoothTween(B, 0.2, {BackgroundColor3 = Hub.Toggles[var] and Hub.Config.ThemeColor or Color3.fromRGB(45, 45, 45)})
    end)
end

AddToggle(MainPg, "Noclip", "Noclip")
AddToggle(MainPg, "Inf Jump", "InfJump")
AddToggle(MainPg, "Super Speed", "Speed")

AddToggle(EspPg, "ESP All Players", "ESP")

AddToggle(CombatPg, "Kill Aura (35 Studs)", "KillAura")
AddToggle(CombatPg, "Aimbot Lock", "Aimbot")
AddToggle(CombatPg, "Anti-Murderer", "AimbotAsesino")

-- [ LOGIN ]
local Login = Instance.new("Frame", ScreenGui)
Login.Size = UDim2.new(0, 300, 0, 220); Login.Position = UDim2.new(0.5, -150, 0.5, -110); Login.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", Login)
local LStroke = Instance.new("UIStroke", Login); LStroke.Color = Hub.Config.ThemeColor; LStroke.Thickness = 2

local KInput = Instance.new("TextBox", Login)
KInput.Size = UDim2.new(0.8, 0, 0, 40); KInput.Position = UDim2.new(0.1, 0, 0.35, 0); KInput.PlaceholderText = "Tu Llave..."
KInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); KInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KInput)

local KBtn = Instance.new("TextButton", Login)
KBtn.Size = UDim2.new(0.8, 0, 0, 40); KBtn.Position = UDim2.new(0.1, 0, 0.65, 0); KBtn.BackgroundColor3 = Hub.Config.ThemeColor; KBtn.Text = "ACCEDER"
KBtn.Font = "GothamBlack"; Instance.new("UICorner", KBtn)

KBtn.MouseButton1Click:Connect(function()
    if VALID_KEYS[KInput.Text] then
        Hub.Active = true; Login:Destroy(); Main.Visible = true
    end
end)

-- [ LÓGICA MM2 ]
RunService.Heartbeat:Connect(function()
    if not Hub.Active then return end
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    if Hub.Toggles.Speed then hum.WalkSpeed = Hub.Config.WalkSpeed else hum.WalkSpeed = 16 end

    -- KILL AURA 35 STUDS
    if Hub.Toggles.KillAura and char:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude <= 35 then
                    char.Knife.Handle.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- AIMBOT
    if Hub.Toggles.Aimbot then
        local target, best = nil, 500
        for _, p in pairs(Players:GetPlayers()) do
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
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Hub.Toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- Rainbow Effect
task.spawn(function()
    while task.wait() do
        local c = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
        MStroke.Color = c; LStroke.Color = c; STitle.TextColor3 = c
    end
end)

PlayIntro()
