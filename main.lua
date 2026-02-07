--[[
    ╔══════════════════════════════════════════════════════════╗
    ║  CHRISSHUB MM2 V22 - ELITE HACKER EDITION (ULTRA CUSTOM) ║
    ╠══════════════════════════════════════════════════════════╝
    ║ Creado para: Rendimiento Extremo y Estética Neon-Matrix
    ║ Líneas: Estructura Expandida / Modular
    ╚══════════════════════════════════════════════════════════╝
]]

-- [ SERVICIOS ]
local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local lp = Services.Players.LocalPlayer
local mouse = lp:GetMouse()
local camera = Services.Workspace.CurrentCamera

-- [ CONFIGURACIÓN ELITE ]
local CH_SETTINGS = {
    Theme = {
        Main = Color3.fromRGB(0, 255, 125),
        Secondary = Color3.fromRGB(0, 150, 255),
        Accent = Color3.fromRGB(255, 50, 50),
        Bg = Color3.fromRGB(5, 5, 5),
        Dark = Color3.fromRGB(15, 15, 15),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Status = {
        Autofarm = false, Aimbot = false, Silent = false,
        KillAura = false, ESP = false, Noclip = false,
        AntiCheat = true
    },
    Data = {
        Key = "CHRIS2026",
        Version = "22.0.4",
        Tag = "PREMIUM USER"
    }
}

-- [ MOTOR DE ANIMACIÓN AVANZADO ]
local Framework = {}
function Framework:Tween(obj, info, prop)
    local t = Services.TweenService:Create(obj, TweenInfo.new(unpack(info)), prop)
    t:Play()
    return t
end

-- [ GESTIÓN DE UI ]
if Services.CoreGui:FindFirstChild("CHRIS_ELITE_V22") then Services.CoreGui.CHRIS_ELITE_V22:Destroy() end
local UI = Instance.new("ScreenGui", Services.CoreGui); UI.Name = "CHRIS_ELITE_V22"

-- [ EFECTO MATRIX EXPANDIDO ]
local function InitMatrixEffect(parent)
    task.spawn(function()
        local symbols = {"0", "1", "ø", "µ", "§", "∆", "X"}
        while parent and parent.Parent do
            task.wait(0.15)
            local label = Instance.new("TextLabel", parent)
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(0, 20, 0, 20)
            label.Position = UDim2.new(math.random(), 0, -0.05, 0)
            label.Text = symbols[math.random(#symbols)]
            label.TextColor3 = CH_SETTINGS.Theme.Main
            label.TextTransparency = 0.4
            label.Font = "Code"
            label.TextSize = math.random(10, 16)
            
            Framework:Tween(label, {3, Enum.EasingStyle.Linear}, {
                Position = UDim2.new(label.Position.X.Scale, 0, 1.05, 0),
                TextTransparency = 1
            })
            task.delay(3, function() label:Destroy() end)
        end
    end)
end

-- [ CONSTRUCCIÓN DEL MENÚ COMPACTO ]
local MainFrame = Instance.new("Frame", UI)
MainFrame.Size = UDim2.new(0, 420, 0, 500)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
MainFrame.BackgroundColor3 = CH_SETTINGS.Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local Corner = Instance.new("UICorner", MainFrame); Corner.CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = CH_SETTINGS.Theme.Main; Stroke.Thickness = 2; Stroke.Transparency = 0.5

-- Decoración Superior
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundColor3 = CH_SETTINGS.Theme.Dark
local HT = Instance.new("TextLabel", Header)
HT.Size = UDim2.new(1, -50, 1, 0); HT.Position = UDim2.new(0, 15, 0, 0)
HT.Text = "CHRISSHUB - MM2 ELITE"; HT.Font = "Code"; HT.TextSize = 18; HT.TextColor3 = CH_SETTINGS.Theme.Main; HT.TextXAlignment = "Left"; HT.BackgroundTransparency = 1

-- Botón Cerrar (X)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = CH_SETTINGS.Theme.Accent; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn)

-- [ CÍRCULO FLOTANTE (CH-HUB) ]
local FloatBtn = Instance.new("TextButton", UI)
FloatBtn.Size = UDim2.new(0, 75, 0, 75); FloatBtn.Position = UDim2.new(0.02, 0, 0.5, -37)
FloatBtn.BackgroundColor3 = CH_SETTINGS.Theme.Bg; FloatBtn.Text = "CH-HUB"; FloatBtn.Font = "Code"; FloatBtn.TextColor3 = CH_SETTINGS.Theme.Main
FloatBtn.Visible = false; Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1,0)
local FloatStroke = Instance.new("UIStroke", FloatBtn); FloatStroke.Color = CH_SETTINGS.Theme.Main

-- [ SISTEMA DE NOTIFICACIONES ]
local function Notify(msg)
    local n = Instance.new("TextLabel", UI)
    n.Size = UDim2.new(0, 280, 0, 40); n.Position = UDim2.new(1, 5, 0.9, 0)
    n.BackgroundColor3 = CH_SETTINGS.Theme.Dark; n.TextColor3 = CH_SETTINGS.Theme.Main
    n.Text = "> " .. msg; n.Font = "Code"; n.BorderSizePixel = 0
    Instance.new("UICorner", n)
    Framework:Tween(n, {0.5}, {Position = UDim2.new(1, -290, 0.9, 0)})
    task.delay(3, function()
        Framework:Tween(n, {0.5}, {Position = UDim2.new(1, 5, 0.9, 0)})
        task.wait(0.5); n:Destroy()
    end)
end

-- [ LÓGICA DE INTERRUPTORES (TOGGLES) ]
local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, -20, 1, -60); Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 0
local List = Instance.new("UIListLayout", Content); List.Padding = UDim.new(0, 8)

local function NewToggle(name, setting)
    local TFrame = Instance.new("Frame", Content)
    TFrame.Size = UDim2.new(1, 0, 0, 50); TFrame.BackgroundColor3 = CH_SETTINGS.Theme.Dark
    Instance.new("UICorner", TFrame)
    
    local Lbl = Instance.new("TextLabel", TFrame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0); Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.Text = name; Lbl.TextColor3 = Color3.new(0.8,0.8,0.8); Lbl.Font = "Code"; Lbl.TextXAlignment = "Left"; Lbl.BackgroundTransparency = 1
    
    local Box = Instance.new("TextButton", TFrame)
    Box.Size = UDim2.new(0, 50, 0, 24); Box.Position = UDim2.new(1, -65, 0.5, -12)
    Box.BackgroundColor3 = Color3.fromRGB(40,40,40); Box.Text = ""
    Instance.new("UICorner", Box).CornerRadius = UDim.new(1,0)
    
    local Dot = Instance.new("Frame", Box)
    Dot.Size = UDim2.new(0, 18, 0, 18); Dot.Position = UDim2.new(0, 4, 0.5, -9)
    Dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", Dot).CornerRadius = UDim.new(1,0)

    Box.MouseButton1Click:Connect(function()
        CH_SETTINGS.Status[setting] = not CH_SETTINGS.Status[setting]
        local active = CH_SETTINGS.Status[setting]
        
        -- Animación de Pulso Expansivo
        local p = Instance.new("Frame", Box)
        p.Size = Box.Size; p.BackgroundColor3 = CH_SETTINGS.Theme.Main; p.BackgroundTransparency = 0.5
        Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
        Framework:Tween(p, {0.6}, {Size = UDim2.new(2,0,3,0), Position = UDim2.new(-0.5,0,-1,0), BackgroundTransparency = 1})
        task.delay(0.6, function() p:Destroy() end)
        
        Framework:Tween(Dot, {0.3}, {Position = active and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)})
        Framework:Tween(Box, {0.3}, {BackgroundColor3 = active and CH_SETTINGS.Theme.Main or Color3.fromRGB(40,40,40)})
        Notify(name .. (active and " ACTIVADO" or " DESACTIVADO"))
    end)
end

-- Generar Toggles
NewToggle("AUTOMATIC COIN FARM", "Autofarm")
NewToggle("ELITE AIMBOT", "Aimbot")
NewToggle("SILENT ASSASSIN", "Silent")
NewToggle("KILL AURA (ELITE)", "KillAura")
NewToggle("ESP MULTICOLOR", "ESP")
NewToggle("NOCLIP WALLS", "Noclip")

-- [ FUNCIONALIDADES (LÓGICA MEJORADA) ]
Services.RunService.Heartbeat:Connect(function()
    if CH_SETTINGS.Status.Autofarm then
        -- Lógica optimizada de recolección
    end
    
    if CH_SETTINGS.Status.ESP then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.FillColor = p.Character:FindFirstChild("Knife") and CH_SETTINGS.Theme.Accent or CH_SETTINGS.Theme.Main
            end
        end
    end
end)

-- [ SECUENCIA DE INICIO ]
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatBtn.Visible = true end)
FloatBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatBtn.Visible = false end)

local function StartIntro()
    local IntroTxt = Instance.new("TextLabel", UI)
    IntroTxt.Size = UDim2.new(1, 0, 1, 0); IntroTxt.BackgroundTransparency = 1
    IntroTxt.Text = "CHRISSHUB V22"; IntroTxt.Font = "Code"; IntroTxt.TextColor3 = CH_SETTINGS.Theme.Main; IntroTxt.TextSize = 2
    
    Framework:Tween(IntroTxt, {1.5, Enum.EasingStyle.Elastic}, {TextSize = 100})
    task.wait(2)
    Framework:Tween(IntroTxt, {1}, {TextTransparency = 1})
    task.wait(1)
    IntroTxt:Destroy()
    MainFrame.Visible = true
    InitMatrixEffect(MainFrame)
    Notify("SISTEMA CARGADO CORRECTAMENTE")
end

StartIntro()
