-- [[ CHRISSHUB V1 - ELITE EDITION (GAMA ALTA) ]] --
-- Fusión de Lógica Grock + Interfaz Multi-Tab Profesional

local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local lp = Services.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UI = Instance.new("ScreenGui", Services.CoreGui)
UI.Name = "CHRISSHUB_ELITE"

-- [ CONFIGURACIÓN Y ESTADOS ]
local Settings = {
    Theme = Color3.fromRGB(0, 255, 125),
    Keys = {"123456", "654321", "112233", "445566", "121212", "343434", "135790", "246801", "987654", "019283"},
    Toggles = {},
    ESPColors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 100, 255),
        Innocent = Color3.fromRGB(0, 255, 0)
    }
}

-- [ MOTOR DE ANIMACIÓN ]
local function Tween(obj, t, prop)
    local info = TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = Services.TweenService:Create(obj, info, prop)
    tween:Play()
    return tween
end

-- [ 1. INTRO SIN FONDO ]
local function StartIntro()
    local IntroText = Instance.new("TextLabel", UI)
    IntroText.Size = UDim2.new(1, 0, 1, 0)
    IntroText.BackgroundTransparency = 1
    IntroText.Text = "CHRISSHUB V1"
    IntroText.TextColor3 = Settings.Theme
    IntroText.Font = "GothamBlack"
    IntroText.TextSize = 5
    IntroText.TextTransparency = 1

    Tween(IntroText, 1.5, {TextTransparency = 0, TextSize = 100})
    task.wait(2.5)
    Tween(IntroText, 1, {TextTransparency = 1, TextSize = 180})
    task.wait(1)
    IntroText:Destroy()
end

-- [ 2. KEY SYSTEM ]
local function KeySystem(onSuccess)
    local KeyMain = Instance.new("Frame", UI)
    KeyMain.Size = UDim2.new(0, 320, 0, 200)
    KeyMain.Position = UDim2.new(0.5, -160, 0.5, -100)
    KeyMain.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", KeyMain).CornerRadius = UDim.new(0, 15)
    
    local T = Instance.new("TextLabel", KeyMain)
    T.Size = UDim2.new(1, 0, 0, 60); T.Text = "Enter License "; T.TextColor3 = Settings.Theme
    T.BackgroundTransparency = 1; T.TextSize = 22; T.Font = "Code"

    local Input = Instance.new("TextBox", KeyMain)
    Input.Size = UDim2.new(0.8, 0, 0, 45); Input.Position = UDim2.new(0.1, 0, 0.4, 0)
    Input.PlaceholderText = "License Key..."; Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyMain)
    Verify.Size = UDim2.new(0.8, 0, 0, 45); Verify.Position = UDim2.new(0.1, 0, 0.7, 0)
    Verify.BackgroundColor3 = Settings.Theme; Verify.Text = "VERIFY"; Verify.Font = "GothamBold"
    Instance.new("UICorner", Verify)

    Verify.MouseButton1Click:Connect(function()
        local correct = false
        for _, k in pairs(Settings.Keys) do if Input.Text == k then correct = true end end
        if correct then
            Verify.Text = "Verifying... 5s"; task.wait(5)
            KeyMain:Destroy(); onSuccess()
        else
            T.Text = "Invalid Key "; T.TextColor3 = Color3.new(1,0,0)
            task.wait(2); T.Text = "Enter License "; T.TextColor3 = Settings.Theme
        end
    end)
end

-- [ 3. LÓGICA DE MM2 (GROCK IMPROVED) ]
local function GetRole(plr)
    if plr.Character then
        if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then return "Murderer" end
        if plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then return "Sheriff" end
    end
    return "Innocent"
end

Services.RunService.Heartbeat:Connect(function()
    if not Settings.Active then return end
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    if Settings.Toggles.ESP then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hl = p.Character:FindFirstChild("CH_Highlight") or Instance.new("Highlight", p.Character)
                hl.Name = "CH_Highlight"
                hl.FillColor = Settings.ESPColors[GetRole(p)]
                hl.Enabled = true
            end
        end
    end

    if Settings.Toggles.KillAura and char:FindFirstChild("Knife") then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 40 then
                    firetouchinterest(p.Character.HumanoidRootPart, char.Knife.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, char.Knife.Handle, 1)
                end
            end
        end
    end
end)

-- [ 4. INTERFAZ ELITE (MULTI-TAB) ]
local function MainGUI()
    Settings.Active = true
    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", Main).Color = Settings.Theme

    -- Sidebar de Pestañas
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 120, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", Sidebar)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -130, 1, -50)
    Container.Position = UDim2.new(0, 125, 0, 40)
    Container.BackgroundTransparency = 1

    local Pages = {}
    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        local Layout = Instance.new("UIListLayout", Page); Layout.Padding = UDim.new(0, 10)
        Pages[name] = Page
        return Page
    end

    local PageMain = CreatePage("MAIN")
    local PageESP = CreatePage("ESP")
    local PageCombat = CreatePage("COMBAT")
    PageMain.Visible = true

    -- Botones de Pestaña
    local function TabBtn(name, pos, page)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(1, -10, 0, 45); b.Position = UDim2.new(0, 5, 0, pos)
        b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1,1,1)
        b.Font = "GothamBold"; Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            page.Visible = true
            Tween(b, 0.3, {BackgroundColor3 = Settings.Theme})
            task.wait(0.3)
            Tween(b, 0.3, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
        end)
    end

    TabBtn("MAIN", 10, PageMain)
    TabBtn("ESP", 60, PageESP)
    TabBtn("COMBAT", 110, PageCombat)

    -- Botones de Función (Toggles)
    local function AddToggle(text, var, parent)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30); btn.Text = text .. ": OFF"
        btn.TextColor3 = Color3.new(1,1,1); btn.Font = "Code"
        Instance.new("UICorner", btn)
        
        btn.MouseButton1Click:Connect(function()
            Settings.Toggles[var] = not Settings.Toggles[var]
            btn.Text = text .. ": " .. (Settings.Toggles[var] and "ON" or "OFF")
            Tween(btn, 0.3, {BackgroundColor3 = Settings.Toggles[var] and Settings.Theme or Color3.fromRGB(30,30,30)})
            btn.TextColor3 = Settings.Toggles[var] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    AddToggle("Noclip", "Noclip", PageMain)
    AddToggle("Inf Jump", "InfJump", PageMain)
    AddToggle("Anti AFK", "AntiAFK", PageMain)
    
    AddToggle("Master ESP", "ESP", PageESP)
    -- Selector de colores iría aquí...

    AddToggle("Kill Aura", "KillAura", PageCombat)
    AddToggle("Murder Aimbot", "AimbotMurder", PageCombat)

    -- Créditos TikTok
    local TT = Instance.new("TextLabel", Sidebar)
    TT.Size = UDim2.new(1,0,0,50); TT.Position = UDim2.new(0,0,1,-50)
    TT.Text = "@sasware32"; TT.TextColor3 = Settings.Theme; TT.BackgroundTransparency = 1

    -- CIERRE Y FLOTANTE
    local X = Instance.new("TextButton", Main)
    X.Size = UDim2.new(0, 40, 0, 40); X.Position = UDim2.new(1, -45, 0, 5)
    X.Text = "X"; X.TextColor3 = Color3.new(1,0,0); X.BackgroundTransparency = 1; X.TextSize = 30
    
    local Float = Instance.new("TextButton", UI)
    Float.Size = UDim2.new(0, 75, 0, 75); Float.Position = UDim2.new(0.05, 0, 0.4, 0)
    Float.Text = "CH-HUB"; Float.BackgroundColor3 = Color3.fromRGB(15,15,15); Float.TextColor3 = Settings.Theme
    Float.Visible = false; Float.Draggable = true; Instance.new("UICorner", Float).CornerRadius = UDim.new(1,0)

    X.MouseButton1Click:Connect(function() Main.Visible = false; Float.Visible = true end)
    Float.MouseButton1Click:Connect(function() Main.Visible = true; Float.Visible = false end)
end

-- [ INICIAR ]
StartIntro()
KeySystem(function()
    MainGUI()
end)
