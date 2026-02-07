--[[
    ██████╗██╗  ██╗██████╗ ██╗███████╗███████╗██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██║  ██║██╔══██╗██║██╔════╝██╔════╝██║  ██║██║   ██║██╔══██╗
    ██║     ███████║██████╔╝██║███████╗███████╗███████║██║   ██║██████╔╝
    ██║     ██╔══██║██╔══██╗██║╚════██║╚════██║██╔══██║██║   ██║██╔══██╗
    ╚██████╗██║  ██║██║  ██║██║███████║███████║██║  ██║╚██████╔╝██████╔╝
    
    [ VERSION: 3.5.0 - SUPREMACY HACKER EDITION ]
    [ DEVELOPER: CHRISSHUB & A7EZZ COLLAB ]
    [ PLATFORM: MOBILE / PC ]
    
    FEATURES:
    - Smart Kill Aura (35 Studs)
    - Randomized Anti-Ban Teleport
    - 15-Color ESP Cycle System
    - Ultra-Smooth Elastic UI Animations
    - Floating Drag & Drop Widget
]]

--// SERVICIOS DEL SISTEMA
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

--// VARIABLES GLOBALES
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local lastTeleport = 0

--// TABLAS DE DATOS Y CONFIGURACIÓN
local Toggles = {
    Noclip = false, 
    InfJump = false, 
    AntiAFK = false,
    ESP = false, 
    Aimbot = false, 
    AimbotLegit = false,
    AimbotMurder = false, 
    KillAura = false, 
    TP_Smart = false
}

local ESPConfig = {
    MurdererColor = Color3.fromRGB(255, 0, 0),
    SheriffColor = Color3.fromRGB(0, 0, 128),
    InnocentColor = Color3.fromRGB(50, 205, 50)
}

local Keys = {
    "482916", "731592", "12345678", "98761230", "24353357", 
    "55554444", "19872026", "31415926", "78901234", "65432109", 
    "11223344", "86429753"
}

local ColorList = {
    {"Rojo", Color3.fromRGB(255, 0, 0)}, {"Naranja", Color3.fromRGB(255, 165, 0)},
    {"Amarillo", Color3.fromRGB(255, 255, 0)}, {"Verde lima", Color3.fromRGB(50, 205, 50)},
    {"Azul cielo", Color3.fromRGB(135, 206, 235)}, {"Azul marino", Color3.fromRGB(0, 0, 128)},
    {"Morado", Color3.fromRGB(128, 0, 128)}, {"Rosa", Color3.fromRGB(255, 192, 203)},
    {"Marrón", Color3.fromRGB(139, 69, 19)}, {"Negro", Color3.fromRGB(0, 0, 0)},
    {"Blanco", Color3.fromRGB(255, 255, 255)}, {"Gris", Color3.fromRGB(128, 128, 128)},
    {"Turquesa", Color3.fromRGB(64, 224, 208)}, {"Fucsia", Color3.fromRGB(255, 0, 255)},
    {"Beige", Color3.fromRGB(245, 245, 220)}
}

--// MOTOR DE ANIMACIÓN AVANZADO (SIN ROMPER LOGICA)
local function AnimateSwitch(button, dot, state)
    local targetColor = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(40, 40, 40)
    local targetPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    
    -- Tween de color y escala
    TweenService:Create(button, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        BackgroundColor3 = targetColor
    }):Play()
    
    -- Tween del switch con efecto rebote
    TweenService:Create(dot, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
        Position = targetPos
    }):Play()
end

--// SISTEMA DE ARRASTRE PARA MÓVIL
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

--// UI PRINCIPAL
if CoreGui:FindFirstChild("ChrissHub_Final") then CoreGui.ChrissHub_Final:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ChrissHub_Final"

--// INTRO: CHRISSHUB V3 NEON
local function RunIntro()
    local Title = Instance.new("TextLabel", ScreenGui)
    Title.Text = "CHRISSHUB V3"; Title.Size = UDim2.new(1,0,1,0); Title.TextColor3 = Color3.fromRGB(0,255,150)
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 60; Title.BackgroundTransparency = 1; Title.TextTransparency = 1
    
    -- Lluvia de códigos (Mejorada)
    task.spawn(function()
        for i = 1, 70 do
            local c = Instance.new("TextLabel", ScreenGui)
            c.Text = string.char(math.random(33, 126)); c.Position = UDim2.new(math.random(), 0, -0.1, 0)
            c.TextColor3 = Color3.fromRGB(0, 255, 100); c.BackgroundTransparency = 1; c.Font = Enum.Font.Code; c.TextSize = 20
            local d = math.random(1, 3)
            TweenService:Create(c, TweenInfo.new(d), {Position = UDim2.new(c.Position.X.Scale, 0, 1.1, 0), TextTransparency = 1}):Play()
            Debris:AddItem(c, d); task.wait(0.04)
        end
    end)

    TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(2.5)
    TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1); Title:Destroy(); ShowKey()
end

--// SISTEMA DE KEY (VERIFYING IN ENGLISH)
function ShowKey()
    local F = Instance.new("Frame", ScreenGui)
    F.Size = UDim2.new(0, 320, 0, 180); F.Position = UDim2.new(0.5, -160, 0.5, -90); F.BackgroundColor3 = Color3.fromRGB(10,10,10)
    Instance.new("UICorner", F); local stroke = Instance.new("UIStroke", F); stroke.Color = Color3.fromRGB(0, 255, 120); stroke.Thickness = 2
    
    local I = Instance.new("TextBox", F)
    I.Size = UDim2.new(0.8, 0, 0, 45); I.Position = UDim2.new(0.1, 0, 0.3, 0); I.PlaceholderText = "Input Access Key..."; I.BackgroundColor3 = Color3.fromRGB(20,20,20); I.TextColor3 = Color3.new(1,1,1); I.Font = Enum.Font.Code
    Instance.new("UICorner", I)

    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.65, 0); B.Text = "AUTHENTICATE"; B.BackgroundColor3 = Color3.fromRGB(0, 255, 120); B.Font = Enum.Font.GothamBold; B.TextColor3 = Color3.new(0,0,0)
    Instance.new("UICorner", B)

    B.MouseButton1Click:Connect(function()
        for _, k in pairs(Keys) do
            if I.Text == k then
                B.Text = "Verifying Key..."; B.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                task.wait(1.5); F:Destroy(); BuildMenu()
                return
            end
        end
        I.Text = "ACCESS DENIED"; I.TextColor3 = Color3.new(1,0,0)
        task.wait(1); I.TextColor3 = Color3.new(1,1,1); I.Text = ""
    end)
end

--// HUB PRINCIPAL ESTILO HACKER
function BuildMenu()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 440, 0, 280); Main.Position = UDim2.new(0.5, -220, 0.5, -140); Main.BackgroundColor3 = Color3.fromRGB(5,5,5)
    Instance.new("UICorner", Main); local stroke = Instance.new("UIStroke", Main); stroke.Color = Color3.fromRGB(0, 255, 120); stroke.Thickness = 1.5
    MakeDraggable(Main, Main)

    -- X GIGANTE
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.new(0, 50, 0, 50); Close.Position = UDim2.new(1, -55, 0, 5); Close.Text = "✕"; Close.TextColor3 = Color3.fromRGB(255, 0, 0); Close.TextSize = 45; Close.BackgroundTransparency = 1; Close.Font = Enum.Font.GothamBold

    -- HUB FLOTANTE
    local HubBtn = Instance.new("TextButton", ScreenGui)
    HubBtn.Size = UDim2.new(0, 65, 0, 65); HubBtn.Position = UDim2.new(0.02, 0, 0.5, 0); HubBtn.BackgroundColor3 = Color3.fromRGB(15,15,15); HubBtn.Text = "HUB"; HubBtn.TextColor3 = Color3.fromRGB(0,255,120); HubBtn.Visible = false; HubBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", HubBtn).CornerRadius = UDim.new(1,0); local hstroke = Instance.new("UIStroke", HubBtn); hstroke.Color = Color3.fromRGB(0,255,120)
    MakeDraggable(HubBtn, HubBtn)

    Close.MouseButton1Click:Connect(function() Main.Visible = false; HubBtn.Visible = true end)
    HubBtn.MouseButton1Click:Connect(function() Main.Visible = true; HubBtn.Visible = false end)

    -- PANEL LATERAL NEON
    local Side = Instance.new("Frame", Main)
    Side.Size = UDim2.new(0, 110, 1, -10); Side.Position = UDim2.new(0, 5, 0, 5); Side.BackgroundColor3 = Color3.fromRGB(10,10,10); Instance.new("UICorner", Side)

    local Cont = Instance.new("Frame", Main)
    Cont.Size = UDim2.new(1, -130, 1, -50); Cont.Position = UDim2.new(0, 120, 0, 40); Cont.BackgroundTransparency = 1

    local function CreatePage(name)
        local p = Instance.new("ScrollingFrame", Cont)
        p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0; p.CanvasSize = UDim2.new(0,0,0,500)
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        return p
    end

    local P_Main = CreatePage("Main"); P_Main.Visible = true
    local P_ESP = CreatePage("ESP")
    local P_Comb = CreatePage("Combat")

    local function Tab(txt, pg)
        local b = Instance.new("TextButton", Side)
        b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, (#Side:GetChildren()-1)*40 + 10)
        b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(15,15,15); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamMedium; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(Cont:GetChildren()) do v.Visible = false end; pg.Visible = true end)
    end

    Tab("SYSTEM", P_Main); Tab("VISUALS", P_ESP); Tab("OFFENSE", P_Comb)

    -- SISTEMA DE TOGGLES CON SWITCH ANIMADO
    local function Toggle(par, txt, prop)
        local f = Instance.new("Frame", par)
        f.Size = UDim2.new(0.95, 0, 0, 40); f.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Instance.new("UICorner", f)
        
        local label = Instance.new("TextLabel", f)
        label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.Text = txt; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1; label.Font = Enum.Font.Gotham; label.TextXAlignment = 0

        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0, 50, 0, 24); b.Position = UDim2.new(1, -60, 0.5, -12); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = ""
        Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)

        local dot = Instance.new("Frame", b)
        dot.Size = UDim2.new(0, 20, 0, 20); dot.Position = UDim2.new(0, 2, 0.5, -10); dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

        b.MouseButton1Click:Connect(function()
            Toggles[prop] = not Toggles[prop]
            AnimateSwitch(b, dot, Toggles[prop])
        end)
    end

    -- CONTENIDO MAIN
    Toggle(P_Main, "Noclip Matrix", "Noclip")
    Toggle(P_Main, "Infinite Jump", "InfJump")
    Toggle(P_Main, "Anti AFK Ghost", "AntiAFK")
    Toggle(P_Main, "Smart Target TP", "TP_Smart")
    local tktk = Instance.new("TextLabel", P_Main); tktk.Text = "TikTok: @sasware32"; tktk.TextColor3 = Color3.fromRGB(0,255,120); tktk.Size = UDim2.new(1,0,0,20); tktk.BackgroundTransparency = 1; tktk.Font = Enum.Font.Code

    -- SISTEMA ESP CON CICLO DE 15 COLORES
    Toggle(P_ESP, "Master ESP", "ESP")
    local function ColorCycler(role, conf)
        local cb = Instance.new("TextButton", P_ESP)
        cb.Size = UDim2.new(0.95, 0, 0, 40); cb.Text = "ESP " .. role; cb.BackgroundColor3 = ESPConfig[conf]; cb.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", cb)
        
        local index = 1
        cb.MouseButton1Click:Connect(function()
            index = (index % #ColorList) + 1
            ESPConfig[conf] = ColorList[index][2]
            cb.Text = "ESP " .. role .. " [" .. ColorList[index][1] .. "]"
            TweenService:Create(cb, TweenInfo.new(0.3), {BackgroundColor3 = ESPConfig[conf]}):Play()
        end)
    end

    ColorCycler("Murderer", "MurdererColor")
    ColorCycler("Sheriff", "SheriffColor")
    ColorCycler("Innocent", "InnocentColor")

    -- OFFENSE / COMBAT
    local maintn = Instance.new("TextLabel", P_Comb); maintn.Text = "Silent Aim [MAINTENANCE]"; maintn.TextColor3 = Color3.new(1,0,0); maintn.BackgroundTransparency = 1; maintn.Size = UDim2.new(1,0,0,20); maintn.Font = Enum.Font.GothamBold
    Toggle(P_Comb, "Universal Aimbot", "Aimbot")
    Toggle(P_Comb, "Legit Assist", "AimbotLegit")
    Toggle(P_Comb, "Priority Murder", "AimbotMurder")
    Toggle(P_Comb, "Kill Aura (35 Studs)", "KillAura")
end

--// PROCESAMIENTO HEARTBEAT (LOGICA CORE)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    -- Noclip Motor
    if Toggles.Noclip then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- ESP Motor (Optimizado)
    if Toggles.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                h.FillColor = isM and ESPConfig.MurdererColor or (isS and ESPConfig.SheriffColor or ESPConfig.InnocentColor)
                h.Enabled = true
            end
        end
    end

    -- Kill Aura Motor (Grok Integration)
    if Toggles.KillAura and char:FindFirstChild("Knife") then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 35 then
                    char.Knife.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- Smart TP (Anti-Detection)
    if Toggles.TP_Smart then
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hasK = char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                local tK = plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")
                if hasK and (plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun")) then target = plr; break end
                if not hasK and tK then target = plr; break end
            end
        end
        if target and tick() - lastTeleport > math.random(1, 3) then
            root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            lastTeleport = tick()
        end
    end
end)

--// ACTIVACION INMEDIATA
RunIntro()
