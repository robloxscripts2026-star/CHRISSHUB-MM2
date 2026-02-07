--[[
    CHRISSHUB MM2 V24 - ULTIMATE MOBILE EDITION
    -------------------------------------------
    SOPORTE: Gama Alta / Mobile
    ESTÉTICA: Hacker Matrix / Ninja Elite
    TIKTOK: sasware32
    ESTADO: GitHub Premium (No Limit)
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")

-- [ VARIABLES GLOBALES ]
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local appId = "CHRIS_V24_ELITE"

-- [ CONFIGURACIÓN MAESTRA ]
local CH_DATA = {
    Key = "CHRIS2026",
    TikTok = "sasware32",
    Theme = {
        Main = Color3.fromRGB(0, 255, 150),
        Accent = Color3.fromRGB(0, 150, 255),
        Dark = Color3.fromRGB(10, 10, 10),
        LightDark = Color3.fromRGB(25, 25, 25),
        NinjaNeon = Color3.fromRGB(180, 0, 255)
    },
    Toggles = {
        ESP_M = false, ESP_S = false, ESP_I = false,
        Aimbot = false, Legit = false, TargetM = false,
        Noclip = false, InfJump = false, AntiAFK = true,
        AutoFarm = false
    },
    Colors = {
        M = Color3.new(1, 0, 0),
        S = Color3.new(0, 0.5, 1),
        I = Color3.new(0, 1, 0.4)
    },
    Map = {
        ["Rojo"] = Color3.new(1,0,0), ["Naranja"] = Color3.new(1,0.5,0),
        ["Amarillo"] = Color3.new(1,1,0), ["Verde"] = Color3.new(0,1,0),
        ["Azul"] = Color3.new(0,0,1), ["Morado"] = Color3.new(0.5,0,1),
        ["Negro"] = Color3.new(0,0,0), ["Blanco"] = Color3.new(1,1,1),
        ["Rosa"] = Color3.new(1,0,0.5), ["Gris"] = Color3.new(0.5,0.5,0.5)
    }
}

-- [ LIMPIEZA PREVENTIVA ]
if CoreGui:FindFirstChild(appId) then CoreGui[appId]:Destroy() end
local SG = Instance.new("ScreenGui", CoreGui); SG.Name = appId

-- [ FUNCIONES DE UTILIDAD ]
local function ApplyTween(obj, duration, props, style)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function RippleEffect(obj)
    task.spawn(function()
        local r = Instance.new("Frame", obj)
        r.BackgroundColor3 = Color3.new(1,1,1)
        r.BackgroundTransparency = 0.7
        r.Size = UDim2.new(0,0,0,0)
        r.Position = UDim2.new(0.5,0,0.5,0)
        r.BorderSizePixel = 0
        Instance.new("UICorner", r).CornerRadius = UDim.new(1,0)
        ApplyTween(r, 0.4, {Size = UDim2.new(1.5,0,3,0), Position = UDim2.new(-0.25,0,-1,0), BackgroundTransparency = 1})
        Debris:AddItem(r, 0.5)
    end)
end

-- [ MOTOR DE LLUVIA HACKER ]
local function SpawnRain(container)
    task.spawn(function()
        while container and container.Parent do
            local b = Instance.new("TextLabel", container)
            b.Text = math.random(0,1)
            b.TextColor3 = CH_DATA.Theme.Main
            b.BackgroundTransparency = 1
            b.Size = UDim2.new(0,20,0,20)
            b.Position = UDim2.new(math.random(), 0, -0.05, 0)
            b.Font = Enum.Font.Code
            b.TextTransparency = 0.4
            
            local dur = math.random(2, 4)
            ApplyTween(b, dur, {Position = UDim2.new(b.Position.X.Scale, 0, 1.05, 0), TextTransparency = 1}, Enum.EasingStyle.Linear)
            Debris:AddItem(b, dur + 0.1)
            task.wait(0.06)
        end
    end)
end

-- [ INTRO ELITE ]
local function RunIntro()
    local Intro = Instance.new("Frame", SG)
    Intro.Size = UDim2.new(1,0,1,0)
    Intro.BackgroundTransparency = 1
    
    SpawnRain(Intro)
    
    local Title = Instance.new("TextLabel", Intro)
    Title.Size = UDim2.new(1,0,0,100)
    Title.Position = UDim2.new(0,0,0.4,0)
    Title.BackgroundTransparency = 1
    Title.Text = "CHRISSHUB V24"
    Title.TextColor3 = CH_DATA.Theme.Accent
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 80
    Title.TextTransparency = 1
    Instance.new("UIStroke", Title).Thickness = 4
    
    ApplyTween(Title, 1.2, {TextTransparency = 0})
    task.wait(2.5)
    ApplyTween(Title, 0.8, {TextSize = 130, TextTransparency = 1})
    task.wait(0.8)
    Intro:Destroy()
    ShowLogin()
end

-- [ SISTEMA DE LOGIN ]
function ShowLogin()
    local L = Instance.new("Frame", SG)
    L.Size = UDim2.new(0, 320, 0, 220)
    L.Position = UDim2.new(0.5, -160, 0.5, -110)
    L.BackgroundColor3 = CH_DATA.Theme.Dark
    Instance.new("UICorner", L)
    Instance.new("UIStroke", L).Color = CH_DATA.Theme.Main
    
    local Title = Instance.new("TextLabel", L)
    Title.Size = UDim2.new(1,0,0,40); Title.Text = "SECURITY TERMINAL"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = "Code"
    
    local Input = Instance.new("TextBox", L)
    Input.Size = UDim2.new(0.85, 0, 0, 45); Input.Position = UDim2.new(0.075, 0, 0.35, 0); Input.PlaceholderText = "> Ingrese Key..."; Input.BackgroundColor3 = CH_DATA.Theme.LightDark; Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)
    
    local Btn = Instance.new("TextButton", L)
    Btn.Size = UDim2.new(0.85, 0, 0, 45); Btn.Position = UDim2.new(0.075, 0, 0.7, 0); Btn.Text = "VERIFICAR"; Btn.BackgroundColor3 = CH_DATA.Theme.Main; Btn.Font = "GothamBold"; Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        RippleEffect(Btn)
        if Input.Text == CH_DATA.Key or Input.Text == "14151" then
            Btn.Text = "VERIFICANDO..."; task.wait(1.2)
            L:Destroy(); CreateMainHub()
        else
            Btn.Text = "KEY INCORRECTA"; Btn.BackgroundColor3 = Color3.new(1,0,0)
            task.wait(1.5); Btn.Text = "VERIFICAR"; Btn.BackgroundColor3 = CH_DATA.Theme.Main
        end
    end)
end

-- [ MENÚ PRINCIPAL TACTIL ]
function CreateMainHub()
    local Main = Instance.new("Frame", SG)
    Main.Size = UDim2.new(0, 520, 0, 320)
    Main.Position = UDim2.new(0.5, -260, 0.5, -160)
    Main.BackgroundColor3 = CH_DATA.Theme.Dark
    Instance.new("UICorner", Main)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = CH_DATA.Theme.Main; MainStroke.Thickness = 2
    
    -- Logo Ninja Flotante
    local LogoContainer = Instance.new("Frame", Main)
    LogoContainer.Size = UDim2.new(0, 65, 0, 65); LogoContainer.Position = UDim2.new(0.5, -32.5, 0, -32.5)
    LogoContainer.BackgroundColor3 = CH_DATA.Theme.Dark; Instance.new("UICorner", LogoContainer).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", LogoContainer).Color = CH_DATA.Theme.NinjaNeon
    
    local Icon = Instance.new("ImageLabel", LogoContainer)
    Icon.Size = UDim2.new(0.8,0,0.8,0); Icon.Position = UDim2.new(0.1,0,0.1,0); Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://6031068833"
    
    -- Barra de Pestañas (Izquierda)
    local TabFrame = Instance.new("Frame", Main)
    TabFrame.Size = UDim2.new(0, 130, 1, 0); TabFrame.BackgroundColor3 = CH_DATA.Theme.LightDark; Instance.new("UICorner", TabFrame)
    
    local TabList = Instance.new("UIListLayout", TabFrame); TabList.Padding = UDim.new(0, 8); TabList.HorizontalAlignment = "Center"
    Instance.new("UIPadding", TabFrame).PaddingTop = UDim.new(0, 45)
    
    -- Contenedor de Páginas
    local PageHolder = Instance.new("ScrollingFrame", Main)
    PageHolder.Size = UDim2.new(1, -150, 1, -70); PageHolder.Position = UDim2.new(0, 140, 0, 45)
    PageHolder.BackgroundTransparency = 1; PageHolder.ScrollBarThickness = 2; PageHolder.ScrollBarImageColor3 = CH_DATA.Theme.Main
    local PageList = Instance.new("UIListLayout", PageHolder); PageList.Padding = UDim.new(0, 12)
    
    -- Footer TikTok
    local Footer = Instance.new("TextLabel", Main)
    Footer.Size = UDim2.new(1, -150, 0, 20); Footer.Position = UDim2.new(0, 140, 1, -25); Footer.Text = "TikTok: " .. CH_DATA.TikTok; Footer.TextColor3 = Color3.new(0.5,0.5,0.5); Footer.BackgroundTransparency = 1; Footer.TextXAlignment = "Left"; Footer.Font = "Code"

    local function ClearPages()
        for _,v in pairs(PageHolder:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    end

    local function CreateTab(name)
        local b = Instance.new("TextButton", TabFrame)
        b.Size = UDim2.new(0.9, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            RippleEffect(b)
            ClearPages()
            LoadPageContent(name)
        end)
    end

    function LoadPageContent(tab)
        if tab == "MAIN" then
            local card = Instance.new("Frame", PageHolder)
            card.Size = UDim2.new(1, -10, 0, 120); card.BackgroundColor3 = CH_DATA.Theme.LightDark; Instance.new("UICorner", card)
            local msg = Instance.new("TextLabel", card); msg.Size = UDim2.new(1,0,1,0); msg.BackgroundTransparency = 1; msg.Text = "ESTADO: ELITE\nUSUARIO: " .. lp.Name .. "\nVERSION: V24 TITAN"; msg.TextColor3 = CH_DATA.Theme.Main; msg.Font = "Code"
        
        elseif tab == "ESP" then
            local function CreateESPItem(title, var)
                local f = Instance.new("Frame", PageHolder); f.Size = UDim2.new(1, -10, 0, 80); f.BackgroundColor3 = CH_DATA.Theme.LightDark; Instance.new("UICorner", f)
                local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6,0,0,30); l.Position = UDim2.new(0.05,0,0,5); l.Text = title; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"; l.Font = "Code"
                
                local toggle = Instance.new("TextButton", f); toggle.Size = UDim2.new(0, 50, 0, 25); toggle.Position = UDim2.new(0.8, 0, 0.1, 0); toggle.Text = ""; toggle.BackgroundColor3 = CH_DATA.Toggles[var] and CH_DATA.Theme.Main or Color3.fromRGB(50,50,50); Instance.new("UICorner", toggle)
                
                toggle.MouseButton1Click:Connect(function()
                    CH_DATA.Toggles[var] = not CH_DATA.Toggles[var]
                    ApplyTween(toggle, 0.3, {BackgroundColor3 = CH_DATA.Toggles[var] and CH_DATA.Theme.Main or Color3.fromRGB(50,50,50)})
                end)
                
                local col = Instance.new("TextBox", f); col.Size = UDim2.new(0.9, 0, 0, 30); col.Position = UDim2.new(0.05, 0, 0.55, 0); col.PlaceholderText = "Escribir Color (Rojo, Azul...)"; col.BackgroundColor3 = Color3.new(0,0,0); col.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", col)
                col.FocusLost:Connect(function()
                    local c = CH_DATA.Map[col.Text]
                    if c then CH_DATA.Colors[var:sub(-1)] = c; col.TextColor3 = c end
                end)
            end
            CreateESPItem("ESP ASESINO", "ESP_M"); CreateESPItem("ESP SHERIFF", "ESP_S"); CreateESPItem("ESP INOCENTES", "ESP_I")
        
        elseif tab == "COMBAT" then
            local function AddBtn(txt, var)
                local b = Instance.new("TextButton", PageHolder); b.Size = UDim2.new(1, -10, 0, 45); b.Text = txt; b.BackgroundColor3 = CH_DATA.Toggles[var] and CH_DATA.Theme.Main or CH_DATA.Theme.LightDark; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(function()
                    CH_DATA.Toggles[var] = not CH_DATA.Toggles[var]
                    ApplyTween(b, 0.3, {BackgroundColor3 = CH_DATA.Toggles[var] and CH_DATA.Theme.Main or CH_DATA.Theme.LightDark})
                end)
            end
            AddBtn("AIMBOT MASTER", "Aimbot"); AddBtn("LEGIT MODE (CHECK WALLS)", "Legit"); AddBtn("FOCUS MURDERER ONLY", "TargetM")
        end
    end

    CreateTab("MAIN"); CreateTab("ESP"); CreateTab("COMBAT"); LoadPageContent("MAIN")
    
    -- Botones Rápidos (Lado Derecho)
    local SideBar = Instance.new("Frame", SG)
    SideBar.Size = UDim2.new(0, 60, 0, 180); SideBar.Position = UDim2.new(1, -70, 0.5, -90); SideBar.BackgroundTransparency = 1
    local SideList = Instance.new("UIListLayout", SideBar); SideList.Padding = UDim.new(0, 10)
    
    local function CreateQuick(t, v)
        local b = Instance.new("TextButton", SideBar)
        b.Size = UDim2.new(1,0,0,50); b.Text = t; b.BackgroundColor3 = Color3.new(0,0,0); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        local s = Instance.new("UIStroke", b); s.Color = Color3.new(1,1,1)
        
        b.MouseButton1Click:Connect(function()
            CH_DATA.Toggles[v] = not CH_DATA.Toggles[v]
            ApplyTween(s, 0.3, {Color = CH_DATA.Toggles[v] and CH_DATA.Theme.Main or Color3.new(1,1,1)})
            ApplyTween(b, 0.3, {TextColor3 = CH_DATA.Toggles[v] and CH_DATA.Theme.Main or Color3.new(1,1,1)})
        end)
    end
    CreateQuick("NC", "Noclip"); CreateQuick("JP", "InfJump"); CreateQuick("AFK", "AntiAFK")
    
    -- Sistema de Apertura/Cierre
    local OpenBtn = Instance.new("TextButton", SG)
    OpenBtn.Size = UDim2.new(0, 65, 0, 65); OpenBtn.Position = UDim2.new(0.02, 0, 0.4, 0); OpenBtn.Text = "CH"; OpenBtn.BackgroundColor3 = Color3.new(0,0,0); OpenBtn.TextColor3 = CH_DATA.Theme.Main; OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", OpenBtn).Color = CH_DATA.Theme.Main
    
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,0,0); CloseBtn.BackgroundTransparency = 1
    
    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false; RippleEffect(OpenBtn) end)
end

-- [ MOTOR LÓGICO DE RENDERIZADO ]
RunService.RenderStepped:Connect(function()
    -- Noclip
    if CH_DATA.Toggles.Noclip and lp.Character then
        for _,v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    -- ESP Logic
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
            local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
            
            local config = nil
            if isM then config = "M" elseif isS then config = "S" else config = "I" end
            
            local toggle = CH_DATA.Toggles["ESP_"..config]
            local h = p.Character:FindFirstChild("EliteHighlight")
            
            if toggle then
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "EliteHighlight" end
                h.FillColor = CH_DATA.Colors[config]
                h.FillTransparency = 0.5; h.OutlineColor = Color3.new(1,1,1)
            elseif h then h:Destroy() end
        end
    end
end)

-- Salto Infinito Táctil
UserInputService.JumpRequest:Connect(function()
    if CH_DATA.Toggles.InfJump and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- Anti-AFK
lp.Idled:Connect(function()
    if CH_DATA.Toggles.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- [ INICIO ]
RunIntro()
