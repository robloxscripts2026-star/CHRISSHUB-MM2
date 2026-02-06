--[[
    CHRISSHUB MM2 V12 - ELITE EXPERIENCE (700+ LINES)
    TikTok: sasware32
    
    ESTA VERSIÓN ESTÁ DISEÑADA PARA DISPOSITIVOS DE ALTA GAMA.
    - SISTEMA DE TEMAS DINÁMICOS (SKINS)
    - CONSOLA DE EVENTOS EN TIEMPO REAL
    - INTRO CINEMATOGRÁFICA GLITCH
    - KILL AURA 35 STUDS (CFRAME MANIPULATION)
    - AIMBOT LOCK-ON CON PREDICCIÓN
]]

-- [ CONSTANTES Y CONFIGURACIÓN ]
local VERSION = "V12.0 ELITE"
local APP_NAME = "CHRISSHUB"
local TIKTOK = "sasware32"
local VALID_KEYS = {["14151"]=true, ["1470"]=true, ["8576"]=true, ["CHRIS2026"]=true}

-- [ SERVICIOS ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [ GESTOR DE ESTADO ]
local Hub = {
    Active = false,
    CurrentTheme = "RGB",
    ActivePage = nil,
    Toggles = {
        ESP = false, Aimbot = false, KillAura = false, Noclip = false, 
        InfJump = false, AntiAFK = false, Speed = false, Fly = false,
        AimbotLegit = false, AimbotAsesino = false, AutoFarm = false,
        FullBright = false
    },
    Config = {
        WalkSpeed = 75,
        JumpPower = 50,
        AimbotSmoothness = 0.1,
        ThemeColor = Color3.fromRGB(0, 255, 150)
    },
    Themes = {
        RGB = Color3.fromRGB(0, 255, 150),
        Dark = Color3.fromRGB(40, 40, 40),
        Sakura = Color3.fromRGB(255, 100, 200),
        Ocean = Color3.fromRGB(0, 150, 255),
        Gold = Color3.fromRGB(255, 200, 0)
    }
}

-- [ UTILIDADES VISUALES ]
local function CreateTween(obj, time, prop)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop)
    t:Play()
    return t
end

-- Limpieza de versiones anteriores
if CoreGui:FindFirstChild("ChrisEliteHub") then CoreGui.ChrisEliteHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ChrisEliteHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [ NOTIFICACIONES ]
local function Notify(title, text, color)
    local NotifFrame = Instance.new("Frame", ScreenGui)
    NotifFrame.Size = UDim2.new(0, 250, 0, 80)
    NotifFrame.Position = UDim2.new(1, 10, 0.8, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", NotifFrame)
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = color or Hub.Config.ThemeColor
    Stroke.Thickness = 2

    local T = Instance.new("TextLabel", NotifFrame)
    T.Size = UDim2.new(1, -20, 0, 30); T.Position = UDim2.new(0, 10, 0, 5)
    T.Text = title; T.TextColor3 = color or Hub.Config.ThemeColor; T.Font = "GothamBlack"; T.TextSize = 16; T.BackgroundTransparency = 1; T.TextXAlignment = "Left"

    local D = Instance.new("TextLabel", NotifFrame)
    D.Size = UDim2.new(1, -20, 0, 40); D.Position = UDim2.new(0, 10, 0, 30)
    D.Text = text; D.TextColor3 = Color3.new(1,1,1); D.Font = "GothamBold"; D.TextSize = 13; D.BackgroundTransparency = 1; D.TextXAlignment = "Left"; D.TextWrapped = true

    CreateTween(NotifFrame, 0.5, {Position = UDim2.new(1, -270, 0.8, 0)})
    task.delay(4, function()
        CreateTween(NotifFrame, 0.5, {Position = UDim2.new(1, 10, 0.8, 0)})
        task.wait(0.5); NotifFrame:Destroy()
    end)
end

-- [ ARRASTRE PROFESIONAL ]
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
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
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ INTRO ANIMADA ]
local function RunIntro()
    local Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.new(0,0,0); Overlay.ZIndex = 999
    
    local Title = Instance.new("TextLabel", Overlay)
    Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = APP_NAME
    Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBlack"; Title.TextSize = 1; Title.TextTransparency = 1

    local Subtitle = Instance.new("TextLabel", Overlay)
    Subtitle.Size = UDim2.new(1, 0, 0, 30); Subtitle.Position = UDim2.new(0,0,0.6,0); Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "CARGANDO ELITE SCRIPTS..."; Subtitle.TextColor3 = Color3.fromRGB(0, 255, 150); Subtitle.Font = "Code"; Subtitle.TextSize = 14; Subtitle.TextTransparency = 1

    CreateTween(Title, 1.5, {TextSize = 80, TextTransparency = 0})
    task.wait(1.5)
    CreateTween(Subtitle, 0.5, {TextTransparency = 0})
    
    -- Efecto Glitch
    for i = 1, 10 do
        Title.TextColor3 = (i % 2 == 0) and Color3.new(1,0,0) or Color3.new(0,1,1)
        task.wait(0.05)
    end
    Title.TextColor3 = Color3.new(1,1,1)
    
    task.wait(1)
    CreateTween(Overlay, 1, {BackgroundTransparency = 1})
    CreateTween(Title, 0.8, {TextTransparency = 1, TextSize = 150})
    CreateTween(Subtitle, 0.5, {TextTransparency = 1})
    task.wait(1); Overlay:Destroy()
end

-- [ UI PRINCIPAL ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 650, 0, 450)
Main.Position = UDim2.new(0.5, -325, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.Visible = false; Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Thickness = 3; MainStroke.Color = Hub.Config.ThemeColor
MakeDraggable(Main)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 70); Logo.Text = APP_NAME; Logo.TextColor3 = Hub.Config.ThemeColor; Logo.Font = "GothamBlack"; Logo.TextSize = 24; Logo.BackgroundTransparency = 1

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -150); TabContainer.Position = UDim2.new(0,0,0,70); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 8); TabContainer.UIListLayout.HorizontalAlignment = "Center"

-- Panel de Consola (Hacker Style)
local Console = Instance.new("ScrollingFrame", Sidebar)
Console.Size = UDim2.new(0.9, 0, 0, 70); Console.Position = UDim2.new(0.05, 0, 1, -80); Console.BackgroundColor3 = Color3.new(0,0,0); Console.BorderSizePixel = 0
Console.ScrollBarThickness = 0; Console.CanvasSize = UDim2.new(0,0,5,0)
local ConsoleList = Instance.new("UIListLayout", Console); ConsoleList.VerticalAlignment = "Bottom"

local function Log(text)
    local l = Instance.new("TextLabel", Console)
    l.Size = UDim2.new(1, 0, 0, 15); l.BackgroundTransparency = 1; l.Text = "> " .. text; l.TextColor3 = Color3.fromRGB(0, 200, 100); l.Font = "Code"; l.TextSize = 10; l.TextXAlignment = "Left"
    Console.CanvasPosition = Vector2.new(0, 9999)
end

-- Contenedor de Páginas
local PageContainer = Instance.new("Frame", Main)
PageContainer.Size = UDim2.new(1, -200, 1, -20); PageContainer.Position = UDim2.new(0, 190, 0, 10); PageContainer.BackgroundTransparency = 1

local Pages = {}

local function CreatePage(name, icon)
    local P = Instance.new("ScrollingFrame", PageContainer)
    P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 3; P.CanvasSize = UDim2.new(0,0,0,0)
    local Layout = Instance.new("UIListLayout", P); Layout.Padding = UDim.new(0, 12); Layout.HorizontalAlignment = "Center"
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        P.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y + 20)
    end)

    local B = Instance.new("TextButton", TabContainer)
    B.Size = UDim2.new(0.85, 0, 0, 45); B.BackgroundColor3 = Color3.fromRGB(25, 25, 25); B.Text = name; B.TextColor3 = Color3.new(0.7,0.7,0.7); B.Font = "GothamBold"; B.TextSize = 14
    Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, btn in pairs(TabContainer:GetChildren()) do if btn:IsA("TextButton") then CreateTween(btn, 0.3, {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.new(0.7,0.7,0.7)}) end end
        P.Visible = true
        CreateTween(B, 0.3, {BackgroundColor3 = Hub.Config.ThemeColor, TextColor3 = Color3.new(0,0,0)})
        Log("Cambiando a: " .. name)
    end)
    
    Pages[name] = P
    return P
end

-- [ COMPONENTES DE UI AVANZADOS ]
local function AddToggle(parent, text, var, callback)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(0.95, 0, 0, 60); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", F)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(0.7, 0, 1, 0); T.Position = UDim2.new(0, 15, 0, 0); T.Text = text; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBold"; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0, 60, 0, 30); B.Position = UDim2.new(1, -75, 0.5, -15); B.BackgroundColor3 = Color3.fromRGB(40, 40, 40); B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1,0)
    
    local C = Instance.new("Frame", B)
    C.Size = UDim2.new(0, 24, 0, 24); C.Position = UDim2.new(0, 3, 0.5, -12); C.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", C).CornerRadius = UDim.new(1,0)
    
    B.MouseButton1Click:Connect(function()
        Hub.Toggles[var] = not Hub.Toggles[var]
        local active = Hub.Toggles[var]
        CreateTween(C, 0.3, {Position = active and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)})
        CreateTween(B, 0.3, {BackgroundColor3 = active and Hub.Config.ThemeColor or Color3.fromRGB(40, 40, 40)})
        Log(text .. ": " .. (active and "Activado" or "Desactivado"))
        if callback then callback(active) end
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local F = Instance.new("Frame", parent)
    F.Size = UDim2.new(0.95, 0, 0, 80); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", F)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(1, -30, 0, 30); T.Position = UDim2.new(0, 15, 0, 5); T.Text = text .. ": " .. default; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBold"; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
    
    local SliderBg = Instance.new("Frame", F)
    SliderBg.Size = UDim2.new(0.9, 0, 0, 6); SliderBg.Position = UDim2.new(0.05, 0, 0, 55); SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", SliderBg)
    
    local Fill = Instance.new("Frame", SliderBg)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Hub.Config.ThemeColor; Instance.new("UICorner", Fill)
    
    local Knob = Instance.new("Frame", SliderBg)
    Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8); Knob.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", Knob)

    local dragging = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        T.Text = text .. ": " .. val
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        callback(val)
    end

    Knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end end)
end

-- [ PÁGINAS DEL HUB ]
local MainPg = CreatePage("PRINCIPAL")
local CombatPg = CreatePage("COMBATE")
local EspPg = CreatePage("VISUALES")
local ThemesPg = CreatePage("TEMAS")
local CreditsPg = CreatePage("CRÉDITOS")

-- Créditos
local C1 = Instance.new("TextLabel", CreditsPg)
C1.Size = UDim2.new(1, 0, 0, 50); C1.Text = "Creado por: CHRIS HUB"; C1.TextColor3 = Color3.new(1,1,1); C1.Font = "GothamBlack"; C1.BackgroundTransparency = 1
local C2 = Instance.new("TextLabel", CreditsPg)
C2.Size = UDim2.new(1, 0, 0, 30); C2.Text = "TikTok: " .. TIKTOK; C2.TextColor3 = Hub.Config.ThemeColor; C2.Font = "GothamBold"; C2.BackgroundTransparency = 1

-- Contenido Principal
AddToggle(MainPg, "Atravesar Paredes (Noclip)", "Noclip")
AddToggle(MainPg, "Salto Infinito", "InfJump")
AddToggle(MainPg, "Anti-AFK Automático", "AntiAFK")
AddToggle(MainPg, "Súper Brillo (FullBright)", "FullBright", function(v) Lighting.Brightness = v and 5 or 1; Lighting.ClockTime = v and 12 or 14 end)
AddSlider(MainPg, "Velocidad Caminado", 16, 200, 75, function(v) Hub.Config.WalkSpeed = v end)

-- Contenido Combate
AddToggle(CombatPg, "Kill Aura (35 Studs)", "KillAura")
AddToggle(CombatPg, "Aimbot Maestro", "Aimbot")
AddToggle(CombatPg, "Aimbot Solo Visible", "AimbotLegit")
AddToggle(CombatPg, "Prioridad Asesino", "AimbotAsesino")
AddSlider(CombatPg, "Suavizado Aimbot", 1, 100, 10, function(v) Hub.Config.AimbotSmoothness = v/100 end)

-- Visuales
AddToggle(EspPg, "Activar ESP", "ESP")

-- Temas
for name, color in pairs(Hub.Themes) do
    local B = Instance.new("TextButton", ThemesPg)
    B.Size = UDim2.new(0.9, 0, 0, 45); B.BackgroundColor3 = color; B.Text = "TEMA: " .. name; B.TextColor3 = Color3.new(0,0,0); B.Font = "GothamBlack"
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        Hub.Config.ThemeColor = color
        MainStroke.Color = color
        Logo.TextColor3 = color
        Notify("Tema Actualizado", "Has activado el modo " .. name, color)
    end)
end

-- [ LÓGICA DE JUEGO MM2 - ELITE ]
local function GetRole(plr)
    if not plr or not plr.Character then return "Inocente" end
    if plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife") then return "Asesino" end
    if plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Inocente"
end

-- Bucle Principal (60 FPS / Heartbeat)
RunService.Heartbeat:Connect(function()
    if not Hub.Active then return end
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Speed
    if Hub.Toggles.Speed or hum.WalkSpeed > 16 then hum.WalkSpeed = Hub.Config.WalkSpeed end

    -- KILL AURA 35 STUDS (Tu Código)
    if Hub.Toggles.KillAura and char:FindFirstChild("Knife") then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 35 then
                    char.Knife.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- AIMBOT LOCK-ON MEJORADO
    if Hub.Toggles.Aimbot or Hub.Toggles.AimbotLegit or Hub.Toggles.AimbotAsesino then
        local target, bestDist = nil, 800
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local pos, vis = camera:WorldToViewportPoint(head.Position)
                
                if vis then
                    if Hub.Toggles.AimbotAsesino and GetRole(p) ~= "Asesino" then continue end
                    if Hub.Toggles.AimbotLegit then
                        local ray = Ray.new(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500)
                        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {char, camera})
                        if not hit or not hit:IsDescendantOf(p.Character) then continue end
                    end
                    
                    local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if mDist < bestDist then bestDist = mDist; target = head end
                end
            end
        end
        if target then
            -- Suavizado Dinámico
            local goal = CFrame.new(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(goal, Hub.Config.AimbotSmoothness or 0.1)
        end
    end

    -- ESP HIGHLIGHTS
    if Hub.Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local role = GetRole(p)
                local hl = p.Character:FindFirstChild("EliteHighlight") or Instance.new("Highlight", p.Character)
                hl.Name = "EliteHighlight"; hl.Enabled = true; hl.FillTransparency = 0.5
                if role == "Asesino" then hl.FillColor = Color3.new(1,0,0); hl.OutlineColor = Color3.new(1,1,1)
                elseif role == "Sheriff" then hl.FillColor = Color3.new(0,0,1); hl.OutlineColor = Color3.new(1,1,1)
                else hl.FillColor = Color3.new(1,1,1); hl.OutlineColor = Color3.new(0,0,0) end
            end
        end
    end
end)

-- Noclip Stepped
RunService.Stepped:Connect(function()
    if Hub.Toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- Salto Infinito
UserInputService.JumpRequest:Connect(function()
    if Hub.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

-- [ SISTEMA DE LOGIN Y ACCESO ]
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 380, 0, 300); LoginFrame.Position = UDim2.new(0.5, -190, 0.5, -150); LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", LoginFrame)
local LStroke = Instance.new("UIStroke", LoginFrame); LStroke.Thickness = 2; LStroke.Color = Color3.fromRGB(0, 255, 150)

local LTitle = Instance.new("TextLabel", LoginFrame)
LTitle.Size = UDim2.new(1, 0, 0, 60); LTitle.Text = "CHRIS HUB ELITE LOGIN"; LTitle.TextColor3 = Color3.new(1,1,1); LTitle.Font = "GothamBlack"; LTitle.TextSize = 20; LTitle.BackgroundTransparency = 1

local KInput = Instance.new("TextBox", LoginFrame)
KInput.Size = UDim2.new(0.8, 0, 0, 45);
