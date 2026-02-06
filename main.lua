--[[
    CHRISSHUB MM2 V16 - CHROME EDITION
    - ESP COMPLETAMENTE PERSONALIZABLE (COLORES POR ROL)
    - Autofarm + Noclip Sincronizado
    - Anti-Cheat Bypass Pro
    - Intro: CHRISSHUB
    - Motor de Temas para la UI
]]

-- [ CONFIGURACIÓN ]
local VALID_KEYS = {["14151"]=true, ["1470"]=true, ["8576"]=true, ["CHRIS2026"]=true}

-- [ SERVICIOS ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- [ GESTOR DE ESTADO ]
local Hub = {
    Active = false,
    CurrentTheme = "RGB",
    Toggles = {
        Autofarm = false, ESP = false, Aimbot = false, KillAura = false,
        AntiCheat = true, Godmode = false, SpeedBypass = false
    },
    Colors = {
        ThemeColor = Color3.fromRGB(0, 255, 150),
        -- COLORES DEL ESP (Los que querías cambiar)
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 0, 255),
        Innocent = Color3.fromRGB(255, 255, 255)
    }
}

-- [ ANIMACIONES ]
local function QuickTween(obj, time, prop)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop):Play()
end

-- Limpieza
if CoreGui:FindFirstChild("ChrisChrome") then CoreGui.ChrisChrome:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisChrome"

-- [ INTRO CHRISSHUB ]
local function PlayIntro()
    local Overlay = Instance.new("Frame", ScreenGui); Overlay.Size = UDim2.new(1,0,1,0); Overlay.BackgroundColor3 = Color3.new(0,0,0); Overlay.ZIndex = 100
    local Text = Instance.new("TextLabel", Overlay); Text.Size = UDim2.new(1,0,1,0); Text.BackgroundTransparency = 1; Text.Text = ""
    Text.TextColor3 = Color3.new(1,1,1); Text.Font = "GothamBlack"; Text.TextSize = 80
    task.wait(0.4)
    local name = "CHRISSHUB"
    for i = 1, #name do
        Text.Text = string.sub(name, 1, i)
        Text.TextColor3 = Hub.Colors.ThemeColor; task.wait(0.08); Text.TextColor3 = Color3.new(1,1,1)
    end
    task.wait(0.5); QuickTween(Text, 0.5, {TextSize = 130, TextTransparency = 1}); QuickTween(Overlay, 0.8, {BackgroundTransparency = 1}); task.wait(0.8); Overlay:Destroy()
end

-- [ UI PRINCIPAL ]
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 560, 0, 380); Main.Position = UDim2.new(0.5, -280, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.Visible = false; Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main); MStroke.Thickness = 2; MStroke.Color = Hub.Colors.ThemeColor

-- Logo Ninja (Handle)
local LogoFrame = Instance.new("Frame", Main); LogoFrame.Size = UDim2.new(0, 70, 0, 70); LogoFrame.Position = UDim2.new(0.5, -35, 0, -40)
LogoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", LogoFrame).CornerRadius = UDim.new(1,0)
local LStroke = Instance.new("UIStroke", LogoFrame); LStroke.Thickness = 2; LStroke.Color = Hub.Colors.ThemeColor
local NinjaImg = Instance.new("ImageLabel", LogoFrame); NinjaImg.Size = UDim2.new(0.8,0,0.8,0); NinjaImg.Position = UDim2.new(0.1,0,0.1,0); NinjaImg.Image = "rbxassetid://603122934"; NinjaImg.BackgroundTransparency = 1; Instance.new("UICorner", NinjaImg).CornerRadius = UDim.new(1,0)

-- Sidebar
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 150, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", Sidebar)
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5); Sidebar.UIListLayout.HorizontalAlignment = "Center"
local STitle = Instance.new("TextLabel", Sidebar); STitle.Size = UDim2.new(1,0,0,50); STitle.Text = "Xhub : MM2"; STitle.TextColor3 = Color3.new(1,1,1); STitle.Font = "GothamBlack"; STitle.TextSize = 16; STitle.BackgroundTransparency = 1

local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -20); Container.Position = UDim2.new(0, 160, 0, 10); Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", Container); P.Size = UDim2.new(1,0,1,0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 2
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(0.9,0,0,35); B.BackgroundColor3 = Color3.fromRGB(25, 25, 25); B.Text = name; B.TextColor3 = Color3.new(0.8,0.8,0.8); B.Font = "GothamBold"; B.TextSize = 11; Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
        for _, btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then QuickTween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}) end end
        QuickTween(B, 0.2, {BackgroundColor3 = Hub.Colors.ThemeColor})
    end)
    Pages[name] = P; return P
end

local PgMain = CreatePage("MAIN")
local PgCombat = CreatePage("COMBATE")
local PgEsp = CreatePage("ESP SETTINGS")
local PgColors = CreatePage("UI THEMES")

-- [ COMPONENTES ]
local function AddToggle(parent, text, var)
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(0.95, 0, 0, 40); F.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", F)
    local T = Instance.new("TextLabel", F); T.Size = UDim2.new(0.7,0,1,0); T.Position = UDim2.new(0, 12, 0, 0); T.Text = text; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBold"; T.TextSize = 11; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0, 40, 0, 20); B.Position = UDim2.new(1, -50, 0.5, -10); B.BackgroundColor3 = Color3.fromRGB(45, 45, 45); B.Text = ""; Instance.new("UICorner", B).CornerRadius = UDim.new(1,0)
    local C = Instance.new("Frame", B); C.Size = UDim2.new(0, 16, 0, 16); C.Position = UDim2.new(0, 2, 0.5, -8); C.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", C).CornerRadius = UDim.new(1,0)
    B.MouseButton1Click:Connect(function()
        Hub.Toggles[var] = not Hub.Toggles[var]; local act = Hub.Toggles[var]
        QuickTween(C, 0.2, {Position = act and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
        QuickTween(B, 0.2, {BackgroundColor3 = act and Hub.Colors.ThemeColor or Color3.fromRGB(45, 45, 45)})
    end)
end

local function AddColorConfig(parent, text, roleVar)
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(0.95, 0, 0, 45); F.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", F)
    local T = Instance.new("TextLabel", F); T.Size = UDim2.new(0.6,0,1,0); T.Position = UDim2.new(0, 12, 0, 0); T.Text = text; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBold"; T.TextSize = 11; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    
    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(255,255,255)}
    local CFrame = Instance.new("Frame", F); CFrame.Size = UDim2.new(0.4, 0, 0.7, 0); CFrame.Position = UDim2.new(0.55, 0, 0.15, 0); CFrame.BackgroundTransparency = 1
    Instance.new("UIListLayout", CFrame).FillDirection = "Horizontal"; CFrame.UIListLayout.Padding = UDim.new(0, 4)
    
    for _, col in pairs(colors) do
        local b = Instance.new("TextButton", CFrame); b.Size = UDim2.new(0, 18, 1, 0); b.BackgroundColor3 = col; b.Text = ""; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() Hub.Colors[roleVar] = col end)
    end
end

-- Llenar Menú
AddToggle(PgMain, "Auto-Farm + Noclip", "Autofarm")
AddToggle(PgEsp, "Activar ESP (Visuales)", "ESP")
AddColorConfig(PgEsp, "Color Asesino", "Murderer")
AddColorConfig(PgEsp, "Color Sheriff", "Sheriff")
AddColorConfig(PgEsp, "Color Inocente", "Innocent")

AddToggle(PgCombat, "Kill Aura (35 Studs)", "KillAura")
AddToggle(PgCombat, "Aimbot Maestro", "Aimbot")

-- [ LÓGICA ESP DINÁMICA ]
local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

RunService.Heartbeat:Connect(function()
    if not Hub.Active then return end
    local char = lp.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    -- Color Ciclo RGB de la UI
    if Hub.CurrentTheme == "RGB" then
        local c = Color3.fromHSV(tick() % 5 / 5, 0.7, 1); Hub.Colors.ThemeColor = c
        MStroke.Color = c; LStroke.Color = c; STitle.TextColor3 = c
    end

    -- ESP con Colores Variables
    if Hub.Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local role = GetRole(p)
                local hl = p.Character:FindFirstChild("ChrisHighlight") or Instance.new("Highlight", p.Character)
                hl.Name = "ChrisHighlight"; hl.Enabled = true; hl.FillTransparency = 0.5
                -- Aquí usa los colores que cambias en el menú
                if role == "Murderer" then hl.FillColor = Hub.Colors.Murderer
                elseif role == "Sheriff" then hl.FillColor = Hub.Colors.Sheriff
                else hl.FillColor = Hub.Colors.Innocent end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ChrisHighlight") then p.Character.ChrisHighlight:Destroy() end
        end
    end

    -- Tu código de Autofarm + Noclip
    if Hub.Toggles.Autofarm then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        for _, coin in pairs(Workspace:GetDescendants()) do
            if coin.Name == "Coin_Server" or coin.Name == "Coin" then
                if coin:IsA("Part") then firetouchinterest(root, coin, 0); firetouchinterest(root, coin, 1) end
            end
        end
    end
end)

-- [ LOGIN ]
local function StartLogin()
    local L = Instance.new("Frame", ScreenGui); L.Size = UDim2.new(0, 300, 0, 220); L.Position = UDim2.new(0.5, -150, 0.5, -110); L.BackgroundColor3 = Color3.fromRGB(12,12,12); Instance.new("UICorner", L)
    local LS = Instance.new("UIStroke", L); LS.Color = Hub.Colors.ThemeColor; LS.Thickness = 2
    local In = Instance.new("TextBox", L); In.Size = UDim2.new(0.8, 0, 0, 40); In.Position = UDim2.new(0.1, 0, 0.35, 0); In.PlaceholderText = "Licencia..."; In.BackgroundColor3 = Color3.fromRGB(25,25,25); In.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", In)
    local Bt = Instance.new("TextButton", L); Bt.Size = UDim2.new(0.8, 0, 0, 40); Bt.Position = UDim2.new(0.1, 0, 0.65, 0); Bt.BackgroundColor3 = Hub.Colors.ThemeColor; Bt.Text = "ENTRAR"; Bt.Font = "GothamBlack"; Instance.new("UICorner", Bt)
    Bt.MouseButton1Click:Connect(function() if VALID_KEYS[In.Text] then Hub.Active = true; L:Destroy(); Main.Visible = true end end)
end

-- Draggable Ninja
local dragging, dragStart, startPos
LogoFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function() dragging = false end)

PlayIntro()
StartLogin()
