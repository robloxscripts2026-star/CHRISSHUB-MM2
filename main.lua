-- [[ CHRISSHUB V2 - SUPREME ELITE ]] --
-- Lógica: Grock Improved | UI: Xhub Multi-Tab (Neon Style)
-- Noclip: V2 Doble Toque | ESP: Full Custom Neon

local Services = setmetatable({}, {
    __index = function(t, k) return game:GetService(k) end
})

local lp = Services.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UI = Instance.new("ScreenGui", Services.CoreGui)
UI.Name = "CHRISSHUB_V2_OFFICIAL"

-- [ DATA & CONFIG ]
local Settings = {
    Theme = Color3.fromRGB(130, 0, 255), -- Morado Neón
    Secondary = Color3.fromRGB(0, 150, 255), -- Azul Neón
    Active = true,
    Toggles = {
        Noclip = false, InfJump = false, AntiAFK = false,
        ESP = false, KillAura = false, SilentAim = false
    },
    ESPColors = {
        Murderer = Color3.fromRGB(255, 0, 50), -- Rojo Vivo
        Sheriff = Color3.fromRGB(0, 180, 255), -- Azul Eléctrico
        Innocent = Color3.fromRGB(0, 255, 150) -- Verde Neón
    },
    ColorOptions = {"Rojo", "Azul", "Verde", "Rosa", "Dorado", "Cian", "Blanco"}
}

-- [ UTILIDADES DE ANIMACIÓN ]
local function Tween(obj, t, prop)
    Services.TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quint), prop):Play()
end

-- [ NOCLIP MEJORADO V2 (DOBLE TOQUE) ]
local lastTap = 0
Services.UserInputService.TouchTap:Connect(function()
    if tick() - lastTap < 0.3 then
        Settings.Toggles.Noclip = not Settings.Toggles.Noclip
        -- Animación visual de aviso opcional aquí
    end
    lastTap = tick()
end)

Services.RunService.Stepped:Connect(function()
    if Settings.Toggles.Noclip and lp.Character then
        for _, part in ipairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- [ INTRO GLITCH NEÓN ]
local function StartIntro()
    local T = Instance.new("TextLabel", UI)
    T.Size = UDim2.new(1,0,1,0); T.BackgroundTransparency = 1
    T.Text = "CHRISSHUB V2"; T.Font = "GothamBlack"; T.TextSize = 2; T.TextColor3 = Settings.Theme
    T.TextTransparency = 1
    local Stroke = Instance.new("UIStroke", T); Stroke.Color = Settings.Secondary; Stroke.Thickness = 4; Stroke.Transparency = 1

    Tween(T, 1, {TextTransparency = 0, TextSize = 90})
    Tween(Stroke, 1, {Transparency = 0})
    task.wait(1.5)
    
    -- Efecto Glitch
    for i = 1, 10 do
        T.TextColor3 = (i%2==0) and Settings.Theme or Settings.Secondary
        T.Position = UDim2.new(0, math.random(-5,5), 0, math.random(-5,5))
        task.wait(0.05)
    end
    
    Tween(T, 0.8, {TextSize = 200, TextTransparency = 1})
    task.wait(0.8); T:Destroy()
end

-- [ LÓGICA DE ROLES (GROCK) ]
local function GetRole(p)
    if p.Character then
        if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then return "Murderer" end
        if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then return "Sheriff" end
    end
    return "Innocent"
end

-- [ INTERFAZ ELITE V2 ]
local function MainGUI()
    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 520, 0, 360); Main.Position = UDim2.new(0.5, -260, 0.5, -180)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
    local Grad = Instance.new("UIGradient", Main)
    Grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(15,15,30)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,15))})

    -- Sidebar (Azul/Morado)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Instance.new("UICorner", Sidebar)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -145, 1, -60); PageContainer.Position = UDim2.new(0, 140, 0, 50)
    PageContainer.BackgroundTransparency = 1

    local Pages = {}
    local function NewPage(name)
        local P = Instance.new("ScrollingFrame", PageContainer)
        P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
        Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
        Pages[name] = P; return P
    end

    local P_Main = NewPage("Main"); local P_ESP = NewPage("ESP"); local P_Combat = NewPage("Combat")
    P_Main.Visible = true

    -- Tabs con Iconos Simbolizados
    local function AddTab(name, icon, page, pos)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(1, -10, 0, 45); b.Position = UDim2.new(0, 5, 0, pos)
        b.Text = icon .. "  " .. name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end
            page.Visible = true
            Tween(b, 0.2, {BackgroundColor3 = Settings.Theme, Size = UDim2.new(1, 0, 0, 45)})
            task.wait(0.2)
            Tween(b, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 40), Size = UDim2.new(1, -10, 0, 45)})
        end)
    end

    AddTab("Main", "🤍", P_Main, 20)
    AddTab("ESP", "👁️", P_ESP, 70)
    AddTab("Combat", "⚔️", P_Combat, 120)

    -- Toggles con Animación Neon
    local function AddToggle(text, var, parent)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -5, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        b.Text = text .. ": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            Settings.Toggles[var] = not Settings.Toggles[var]
            b.Text = text .. ": " .. (Settings.Toggles[var] and "ON" or "OFF")
            Tween(b, 0.3, {BackgroundColor3 = Settings.Toggles[var] and Settings.Secondary or Color3.fromRGB(30, 30, 45)})
            b.TextColor3 = Settings.Toggles[var] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    -- Color Picker Simple para ESP
    local function AddColorPicker(role, parent)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -5, 0, 40); b.Text = "Color " .. role; b.BackgroundColor3 = Settings.ESPColors[role]
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            -- Ciclo de colores vivos
            local colors = {Color3.new(1,0,0), Color3.new(0,1,1), Color3.new(1,0,1), Color3.new(1,1,0), Color3.new(0,1,0)}
            Settings.ESPColors[role] = colors[math.random(1, #colors)]
            b.BackgroundColor3 = Settings.ESPColors[role]
        end)
    end

    -- Llenar páginas
    AddToggle("Noclip (Doble Tap)", "Noclip", P_Main)
    AddToggle("Inf Jump", "InfJump", P_Main)
    
    AddToggle("Master ESP", "ESP", P_ESP)
    AddColorPicker("Innocent", P_ESP)
    AddColorPicker("Murderer", P_ESP)
    AddColorPicker("Sheriff", P_ESP)

    AddToggle("Kill Aura (40u)", "KillAura", P_Combat)
    AddToggle("Silent Aim", "SilentAim", P_Combat)

    -- Botón Flotante Draggable
    local Float = Instance.new("TextButton", UI)
    Float.Size = UDim2.new(0, 70, 0, 70); Float.Position = UDim2.new(0.05, 0, 0.2, 0)
    Float.Text = "CH-V2"; Float.BackgroundColor3 = Settings.Theme; Float.TextColor3 = Color3.new(1,1,1)
    Float.Visible = false; Instance.new("UICorner", Float).CornerRadius = UDim.new(1,0)
    
    local dragInfo = {dragging = false}
    Float.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragInfo.dragging = true end end)
    Float.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragInfo.dragging = false end end)
    Services.RunService.RenderStepped:Connect(function()
        if dragInfo.dragging then
            local mp = Services.UserInputService:GetMouseLocation()
            Float.Position = UDim2.new(0, mp.X - 35, 0, mp.Y - 35)
        end
    end)

    local X = Instance.new("TextButton", Main)
    X.Size = UDim2.new(0, 40, 0, 40); X.Position = UDim2.new(1, -45, 0, 5); X.Text = "X"; X.TextColor3 = Color3.new(1,0,0); X.BackgroundTransparency = 1; X.TextSize = 30
    X.MouseButton1Click:Connect(function() Main.Visible = false; Float.Visible = true end)
    Float.MouseButton1Click:Connect(function() Main.Visible = true; Float.Visible = false end)
end

-- [ BUCLE DE LÓGICA DE COMBATE ]
Services.RunService.Heartbeat:Connect(function()
    if not Settings.Active then return end
    
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            -- ESP VIVO
            local hl = p.Character:FindFirstChild("CH2_HL") or Instance.new("Highlight", p.Character)
            hl.Name = "CH2_HL"; hl.Enabled = Settings.Toggles.ESP
            hl.FillColor = Settings.ESPColors[GetRole(p)]
            hl.OutlineTransparency = 0
            
            -- SILENT AIM (GROCK LOGIC)
            if Settings.Toggles.SilentAim and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                p.Character.HumanoidRootPart.Transparency = 0.8
            else
                if p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end

    -- KILL AURA 
    if Settings.Toggles.KillAura and lp.Character and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 40 then
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
                end
            end
        end
    end
end)

-- [ SISTEMA KEY MAESTRA ]
local function KeySystem()
    local K = Instance.new("Frame", UI); K.Size = UDim2.new(0, 340, 0, 220); K.Position = UDim2.new(0.5, -170, 0.5, -110)
    K.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", K)
    local S = Instance.new("UIStroke", K); S.Color = Settings.Theme; S.Thickness = 3
    
    local T = Instance.new("TextLabel", K); T.Size = UDim2.new(1,0,0,60); T.Text = "CH-HUB V2 LICENSE"; T.TextColor3 = Settings.Theme; T.BackgroundTransparency = 1; T.Font = "Code"; T.TextSize = 22
    local I = Instance.new("TextBox", K); I.Size = UDim2.new(0.8,0,0,45); I.Position = UDim2.new(0.1,0,0.4,0); I.PlaceholderText = "Enter License..."; I.BackgroundColor3 = Color3.fromRGB(25,25,35); I.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", I)
    local V = Instance.new("TextButton", K); V.Size = UDim2.new(0.8,0,0,45); V.Position = UDim2.new(0.1,0,0.7,0); V.Text = "VERIFY"; V.BackgroundColor3 = Settings.Theme; Instance.new("UICorner", V)

    V.MouseButton1Click:Connect(function()
        local valid = {"138425", "654321", "482572", "37472", "48590"}
        local found = false; for _, k in pairs(valid) do if I.Text == k then found = true end end
        if found then
            V.Text = "Verifying... "; task.wait(3)
            K:Destroy(); MainGUI()
        else
            T.Text = "Invalid! ❌"; task.wait(1); T.Text = "CH-HUB V2 LICENSE"
        end
    end)
end

StartIntro()
KeySystem()
