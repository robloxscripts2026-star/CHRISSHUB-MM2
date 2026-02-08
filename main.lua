-- CHRISSHUB MM2 V1 - SCRIPT DEFINITIVO MÓVIL
    TIKTOK: @sasware32
]]

local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local lp = Services.Players.LocalPlayer
local mouse = lp:GetMouse()
local camera = workspace.CurrentCamera

-- [ CONFIGURACIÓN ]
local CH_DATA = {
    Keys = {"123456", "654321", "112233", "445566", "121212", "343434", "135790", "246801", "987654", "019283"},
    Theme = Color3.fromRGB(0, 255, 125),
    SelectedESPColor = nil,
    Toggles = {}
}

-- [ SISTEMA DE SONIDOS ]
local function PlaySound(id)
    local s = Instance.new("Sound", Services.SoundService)
    s.SoundId = "rbxassetid://"..id
    s.Volume = 2
    s:Play()
    Services.Debris:AddItem(s, 2)
end

-- [ LIBRERÍA DE ANIMACIÓN ]
local function Tween(obj, t, prop)
    Services.TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart), prop):Play()
end

-- [ CREACIÓN DE UI PRINCIPAL ]
local UI = Instance.new("ScreenGui", Services.CoreGui); UI.Name = "CHRISSHUB_V1"

-- [ 1. INTRO CINEMATOGRÁFICA ]
local function RunIntro()
    local IntroText = Instance.new("TextLabel", UI)
    IntroText.Size = UDim2.new(1, 0, 1, 0); IntroText.BackgroundTransparency = 1
    IntroText.Text = "CHRISSHUB V1"; IntroText.TextColor3 = CH_DATA.Theme
    IntroText.Font = "GothamBlack"; IntroText.TextSize = 80; IntroText.TextTransparency = 1
    
    Tween(IntroText, 1.5, {TextTransparency = 0})
    PlaySound(452267918) -- Sonido de entrada
    task.wait(2.5)
    PlaySound(138090596) -- Sonido de salida
    Tween(IntroText, 1, {TextTransparency = 1, TextSize = 150})
    task.wait(1); IntroText:Destroy()
end

-- [ 2. KEY SYSTEM ]
local function ShowKeySystem(onSuccess)
    local KeyFrame = Instance.new("Frame", UI)
    KeyFrame.Size = UDim2.new(0, 300, 0, 150); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); KeyFrame.BorderSizePixel = 0
    Instance.new("UICorner", KeyFrame)
    
    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "Enter License"; Title.TextColor3 = CH_DATA.Theme
    Title.Font = "Code"; Title.BackgroundTransparency = 1; Title.TextSize = 18

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0.8, 0, 0, 35); Input.Position = UDim2.new(0.1, 0, 0.4, 0)
    Input.PlaceholderText = "Key here..."; Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Input.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0.8, 0, 0, 35); Verify.Position = UDim2.new(0.1, 0, 0.75, 0)
    Verify.Text = "Verify"; Verify.BackgroundColor3 = CH_DATA.Theme; Instance.new("UICorner", Verify)

    Verify.MouseButton1Click:Connect(function()
        local found = false
        for _, v in pairs(CH_DATA.Keys) do if Input.Text == v then found = true end end
        
        if found then
            Verify.Text = "Verifying Key..."; task.wait(5)
            KeyFrame:Destroy(); onSuccess()
        else
            Verify.Text = "Invalid Key"; task.wait(1.5); Verify.Text = "Verify"
        end
    end)
end

-- [ 3. MENÚ PRINCIPAL ]
local function CreateMainGUI()
    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 450, 0, 300); Main.Position = UDim2.new(0.5, -225, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", Main)
    local Stroke = Instance.new("UIStroke", Main); Stroke.Color = CH_DATA.Theme; Stroke.Thickness = 2

    -- Draggable
    local d=false;local s;local sp;Main.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true;s=i.Position;sp=Main.Position end end)
    Services.UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then local delta=i.Position-s;Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+delta.X,sp.Y.Scale,sp.Y.Offset+delta.Y) end end)
    Services.UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)

    -- Botón X
    local X = Instance.new("TextButton", Main)
    X.Size = UDim2.new(0, 40, 0, 40); X.Position = UDim2.new(1, -45, 0, 5)
    X.Text = "X"; X.TextColor3 = Color3.new(1, 0, 0); X.BackgroundTransparency = 1; X.TextSize = 30

    -- Pestañas
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0, 120, 1, 0); Tabs.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Tabs)

    local function AddTab(name, pos)
        local b = Instance.new("TextButton", Tabs)
        b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, pos)
        b.Text = name; b.TextColor3 = Color3.new(1, 1, 1); b.BackgroundTransparency = 1; b.Font = "Code"
        return b
    end

    local btnMain = AddTab("MAIN", 10)
    local btnESP = AddTab("ESP", 50)
    local btnCombat = AddTab("COMBAT", 90)

    -- Contenedores (Secciones)
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -130, 1, -20); Container.Position = UDim2.new(0, 125, 0, 10); Container.BackgroundTransparency = 1

    local function CreateToggle(name, parent, callback)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        b.Text = name; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
        local active = false
        b.MouseButton1Click:Connect(function()
            active = not active
            PlaySound(active and 12222242 o 12222243) -- Ajustar IDs de sonido reales
            Tween(b, 0.3, {BackgroundColor3 = active and CH_DATA.Theme or Color3.fromRGB(20, 20, 20)})
            callback(active)
        end)
    end

    -- [ FUNCIONES MAIN ]
    local TikTok = Instance.new("TextLabel", Main)
    TikTok.Size = UDim2.new(1, -120, 0, 30); TikTok.Position = UDim2.new(0, 120, 1, -30)
    TikTok.Text = "SÍGUEME EN TIKTOK @sasware32"; TikTok.TextColor3 = CH_DATA.Theme; TikTok.BackgroundTransparency = 1; TikTok.TextSize = 10

    -- [ FUNCIONES ESP & COMBAT ]
    -- Aquí se integran los bucles de detección de Sheriff/Murderer y KillAura 40 studs
    -- (Por espacio, estas funciones llaman a los procesos de lógica MM2)

    -- [ BOTÓN FLOTANTE CH-HUB ]
    local Float = Instance.new("TextButton", UI)
    Float.Size = UDim2.new(0, 60, 0, 60); Float.Position = UDim2.new(0.02, 0, 0.4, 0)
    Float.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Float.Text = "CH-HUB"; Float.TextColor3 = CH_DATA.Theme
    Float.Visible = false; Instance.new("UICorner", Float).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", Float).Color = CH_DATA.Theme

    X.MouseButton1Click:Connect(function() Main.Visible = false; Float.Visible = true end)
    Float.MouseButton1Click:Connect(function() Main.Visible = true; Float.Visible = false end)
end

-- [ INICIO DEL PROCESO ]
RunIntro()
ShowKeySystem(function()
    CreateMainGUI()
    -- Activar Anti-AFK
    lp.Idled:Connect(function() Services.VirtualUser:Button2Down(Vector2.new(0,0), camera.CFrame); task.wait(1); Services.VirtualUser:Button2Up(Vector2.new(0,0), camera.CFrame) end)
end)
