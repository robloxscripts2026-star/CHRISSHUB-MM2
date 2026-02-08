-- [[ CHRISSHUB V1 - SUPREME EDITION ]] --
-- Corregido para Delta/Móvil con efectos de sonido y visuales

local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local lp = Services.Players.LocalPlayer
local UI = Instance.new("ScreenGui", Services.CoreGui)
UI.Name = "CHRISSHUB_V1"

-- [ CONFIGURACIÓN ]
local Settings = {
    Theme = Color3.fromRGB(0, 255, 125),
    Keys = {"123456", "654321", "112233", "445566", "121212", "343434", "135790", "246801", "987654", "019283"},
    Toggles = {},
    ESPColor = nil -- Si es nil, usa el predeterminado por rol
}

-- [ SISTEMA DE SONIDOS ]
local function PlayCustomSound(id)
    local s = Instance.new("Sound", Services.SoundService)
    s.SoundId = "rbxassetid://"..id
    s.Volume = 2
    s:Play()
    Services.Debris:AddItem(s, 3)
end

-- [ ANIMACIONES ]
local function Tween(obj, t, prop)
    Services.TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart), prop):Play()
end

-- [ 1. INTRO SIN FONDO ]
local function StartIntro()
    local IntroText = Instance.new("TextLabel", UI)
    IntroText.Size = UDim2.new(1, 0, 1, 0)
    IntroText.BackgroundTransparency = 1
    IntroText.Text = "CHRISSHUB V1"
    IntroText.TextColor3 = Settings.Theme
    IntroText.Font = "GothamBlack"
    IntroText.TextSize = 2 -- Inicia pequeño
    IntroText.TextTransparency = 1

    -- Efecto de sonido entrada
    PlayCustomSound(452267918) 
    
    Tween(IntroText, 1.2, {TextTransparency = 0, TextSize = 80})
    task.wait(2.5)
    
    -- Sonido de salida y desaparición
    PlayCustomSound(138090596)
    Tween(IntroText, 1, {TextTransparency = 1, TextSize = 150})
    task.wait(1)
    IntroText:Destroy()
end

-- [ 2. KEY SYSTEM (ENTER LICENSE) ]
local function KeySystem(onSuccess)
    local KeyMain = Instance.new("Frame", UI)
    KeyMain.Size = UDim2.new(0, 300, 0, 180)
    KeyMain.Position = UDim2.new(0.5, -150, 0.5, -90)
    KeyMain.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", KeyMain)

    local T = Instance.new("TextLabel", KeyMain)
    T.Size = UDim2.new(1, 0, 0, 50)
    T.Text = "Enter license 🥵"
    T.TextColor3 = Settings.Theme
    T.BackgroundTransparency = 1; T.TextSize = 20; T.Font = "Code"

    local Input = Instance.new("TextBox", KeyMain)
    Input.Size = UDim2.new(0.8, 0, 0, 40)
    Input.Position = UDim2.new(0.1, 0, 0.35, 0)
    Input.PlaceholderText = "Paste key here..."
    Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Input.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyMain)
    Verify.Size = UDim2.new(0.8, 0, 0, 40)
    Verify.Position = UDim2.new(0.1, 0, 0.7, 0)
    Verify.BackgroundColor3 = Settings.Theme
    Verify.Text = "VERIFY"
    Instance.new("UICorner", Verify)

    Verify.MouseButton1Click:Connect(function()
        local isCorrect = false
        for _, k in pairs(Settings.Keys) do if Input.Text == k then isCorrect = true end end

        if isCorrect then
            Verify.Text = "Verifying key... 🥵"
            PlayCustomSound(130113175) -- Sonido éxito
            task.wait(5)
            KeyMain:Destroy()
            onSuccess()
        else
            T.Text = "Key invalida 🥵"
            T.TextColor3 = Color3.new(1,0,0)
            PlayCustomSound(138090596) -- Sonido error
            task.wait(2)
            T.Text = "Enter license 🥵"
            T.TextColor3 = Settings.Theme
        end
    end)
end

-- [ 3. MENÚ PRINCIPAL (ESTILO XHUB) ]
local function MainGUI()
    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 400, 0, 280) -- Tamaño pequeño
    Main.Position = UDim2.new(0.5, -200, 0.5, -140)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Active = true
    Main.Draggable = true -- Movible
    Instance.new("UICorner", Main)
    local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Settings.Theme; Stroke.Thickness = 2

    -- BOTÓN CERRAR X
    local X = Instance.new("TextButton", Main)
    X.Size = UDim2.new(0, 40, 0, 40); X.Position = UDim2.new(1, -45, 0, 5)
    X.Text = "X"; X.TextColor3 = Color3.new(1, 0, 0); X.BackgroundTransparency = 1; X.TextSize = 35

    -- CONTENEDORES DE PESTAÑAS (MAIN, ESP, COMBAT)
    -- [Aquí se genera la lógica de los botones según tu descripción]

    -- [ ESP INTELIGENTE ]
    task.spawn(function()
        while task.wait(1) do
            if Settings.Toggles["ESP"] then
                for _, p in pairs(Services.Players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        local h = p.Character:FindFirstChild("CH_Highlight") or Instance.new("Highlight", p.Character)
                        h.Name = "CH_Highlight"
                        
                        -- Detección por Inventario
                        local roleColor = Color3.fromRGB(0, 255, 0) -- Inocente
                        if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                            roleColor = Color3.fromRGB(255, 0, 0) -- Murder
                        elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                            roleColor = Color3.fromRGB(0, 0, 255) -- Sheriff
                        end
                        
                        h.FillColor = Settings.ESPColor or roleColor
                    end
                end
            end
        end
    end)

    -- BOTÓN FLOTANTE CH-HUB
    local Float = Instance.new("TextButton", UI)
    Float.Size = UDim2.new(0, 70, 0, 70)
    Float.Position = UDim2.new(0.05, 0, 0.5, -35)
    Float.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Float.Text = "CH-HUB"; Float.TextColor3 = Settings.Theme; Float.Visible = false
    Float.Draggable = true
    Instance.new("UICorner", Float).CornerRadius = UDim.new(1, 0)
    local FS = Instance.new("UIStroke", Float); FS.Color = Settings.Theme

    X.MouseButton1Click:Connect(function()
        Main.Visible = false
        Float.Visible = true
        PlayCustomSound(138090596)
    end)

    Float.MouseButton1Click:Connect(function()
        Main.Visible = true
        Float.Visible = false
        PlayCustomSound(130113175)
    end)
end

-- [ INICIAR TODO ]
StartIntro()
KeySystem(function()
    MainGUI()
end)
