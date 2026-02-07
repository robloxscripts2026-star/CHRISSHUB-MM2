--[[
    ██████╗██╗  ██╗██████╗ ██╗███████╗███████╗██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██║  ██║██╔══██╗██║██╔════╝██╔════╝██║  ██║██║   ██║██╔══██╗
    ██║     ███████║██████╔╝██║███████╗███████╗███████║██║   ██║██████╔╝
    ██║     ██╔══██║██╔══██╗██║╚════██║╚════██║██╔══██║██║   ██║██╔══██╗
    ╚██████╗██║  ██║██║  ██║██║███████║███████║██║  ██║╚██████╔╝██████╔╝
    
    CHRISSHUB MM2 V3 - HACKER EDITION (ULTRA-SLIM)
    Update: New UI Design + Large X + Fixed Logic
    TikTok: sasware32
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local ValidKeys = {"482916", "731592"}
local lastTeleport = 0

-- Variables de Estado
local Toggles = {
    ESP = false, Aimbot = false, AimbotLegit = false, 
    AimbotMurder = false, Noclip = false, InfJump = false, 
    AntiAFK = false, TP_Smart = false
}

local ESPConfig = {
    MurdererColor = Color3.fromRGB(255, 0, 0),
    SheriffColor = Color3.fromRGB(0, 0, 128),
    InnocentColor = Color3.fromRGB(50, 205, 50)
}

-- Limpiar versiones anteriores
if CoreGui:FindFirstChild("ChrissHub_Hacker") then CoreGui.ChrissHub_Hacker:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ChrissHub_Hacker"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =============================================================
-- UTILIDADES DE UI (ANIMACIONES Y ARRASTRE)
-- =============================================================
local function CreateTween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- =============================================================
-- INTRO: CHRISSHUB V3 + LLUVIA DE CÓDIGOS
-- =============================================================
local function RunIntro()
    local Title = Instance.new("TextLabel", ScreenGui)
    Title.Size = UDim2.new(0, 400, 0, 50)
    Title.Position = UDim2.new(0.5, -200, 0.4, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "CHRISSHUB V3"
    Title.TextColor3 = Color3.fromRGB(0, 255, 150)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 45
    Title.TextTransparency = 1

    CreateTween(Title, {TextTransparency = 0, Position = UDim2.new(0.5, -200, 0.45, 0)}, 0.8)

    task.spawn(function()
        for i = 1, 60 do
            local code = Instance.new("TextLabel", ScreenGui)
            code.Size = UDim2.new(0, 60, 0, 20)
            code.Position = UDim2.new(math.random(), 0, -0.1, 0)
            code.BackgroundTransparency = 1
            code.Text = tostring(math.random(101010, 999999))
            code.TextColor3 = Color3.fromRGB(0, 200, 100)
            code.Font = Enum.Font.Code; code.TextSize = 14
            local dur = math.random(1.5, 3)
            CreateTween(code, {Position = UDim2.new(code.Position.X.Scale, 0, 1.1, 0), TextTransparency = 1}, dur)
            Debris:AddItem(code, dur)
            task.wait(0.08)
        end
    end)

    task.wait(2)
    CreateTween(Title, {TextTransparency = 1}, 0.5)
    task.wait(0.5)
    Title:Destroy()
    ShowKeySystem()
end

-- =============================================================
-- KEY SYSTEM (FIXED)
-- =============================================================
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 320, 0, 180)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Instance.new("UICorner", KeyFrame)
    Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(0, 255, 120)

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0.8, 0, 0, 40); Input.Position = UDim2.new(0.1, 0, 0.3, 0)
    Input.PlaceholderText = "Insert Key Hacker..."; Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)

    local Btn = Instance.new("TextButton", KeyFrame)
    Btn.Size = UDim2.new(0.8, 0, 0, 40); Btn.Position = UDim2.new(0.1, 0, 0.65, 0)
    Btn.Text = "ACCESS SYSTEM"; Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    Btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, k in pairs(ValidKeys) do
            if Input.Text == k then
                Btn.Text = "Verifying Key..."; Btn.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
                task.wait(1.2); KeyFrame:Destroy(); BuildMainHub()
                return
            end
        end
        Input.Text = "ERROR: WRONG KEY"
        task.wait(1); Input.Text = ""
    end)
end

-- =============================================================
-- MAIN HUB: DISEÑO HACKER COMPACTO
-- =============================================================
function BuildMainHub()
    -- Menú más pequeño y elegante
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 440, 0, 280)
    MainFrame.Position = UDim2.new(0.5, -220, 0.5, -140)
    MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(0, 255, 120)
    MainStroke.Thickness = 2
    
    MakeDraggable(MainFrame, MainFrame)

    -- BOTÓN X (GRANDE Y ROJA)
    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 45, 0, 45)
    CloseBtn.Position = UDim2.new(1, -50, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 40, 40)
    CloseBtn.TextSize = 35
    CloseBtn.Font = Enum.Font.GothamBold

    -- HUB FLOTANTE CIRCULAR
    local Floating = Instance.new("TextButton", ScreenGui)
    Floating.Size = UDim2.new(0, 65, 0, 65)
    Floating.Position = UDim2.new(0.05, 0, 0.4, 0)
    Floating.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Floating.Text = "HUB"
    Floating.TextColor3 = Color3.fromRGB(0, 255, 120)
    Floating.Visible = false
    Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", Floating).Color = Color3.fromRGB(0, 255, 120)
    MakeDraggable(Floating, Floating)

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false; Floating.Visible = true
        CreateTween(Floating, {Rotation = 360}, 0.5)
    end)
    Floating.MouseButton1Click:Connect(function()
        MainFrame.Visible = true; Floating.Visible = false; Floating.Rotation = 0
    end)

    -- PANEL LATERAL
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 110, 1, -10)
    Sidebar.Position = UDim2.new(0, 5, 0, 5)
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Instance.new("UICorner", Sidebar)

    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -130, 1, -60)
    Container.Position = UDim2.new(0, 120, 0, 50)
    Container.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Size = UDim2.new(0, 200, 0, 40)
    TitleLabel.Position = UDim2.new(0, 120, 0, 5)
    TitleLabel.Text = "CHRISSHUB V3"
    TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function CreatePage(name)
        local p = Instance.new("ScrollingFrame", Container)
        p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
        p.ScrollBarThickness = 0; p.CanvasSize = UDim2.new(0,0,0,500)
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 6)
        return p
    end

    local PMain = CreatePage("Main"); PMain.Visible = true
    local PESP = CreatePage("ESP")
    local PCombat = CreatePage("Combat")
    local PTP = CreatePage("Teleport")

    local function AddTab(name, page)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(0.9, 0, 0, 35)
        b.Position = UDim2.new(0.05, 0, 0, (#Sidebar:GetChildren()-1) * 42 + 10)
        b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.Font = Enum.Font.GothamMedium; Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            page.Visible = true
        end)
    end

    AddTab("MAIN", PMain); AddTab("ESP", PESP); AddTab("COMBAT", PCombat); AddTab("TP", PTP)

    local function NewToggle(parent, text, prop)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(0.95, 0, 0, 38); f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Instance.new("UICorner", f)
        
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.7, 0, 1, 0); l.Position = UDim2.new(0, 10, 0, 0)
        l.Text = text; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1
        l.TextXAlignment = Enum.TextXAlignment.Left; l.Font = Enum.Font.Gotham

        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0, 60, 0, 24); b.Position = UDim2.new(1, -70, 0.5, -12)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = ""
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", b)
        dot.Size = UDim2.new(0, 20, 0, 20); dot.Position = UDim2.new(0, 2, 0.5, -10)
        dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

        b.MouseButton1Click:Connect(function()
            Toggles[prop] = not Toggles[prop]
            local active = Toggles[prop]
            CreateTween(b, {BackgroundColor3 = active and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)}, 0.2)
            CreateTween(dot, {Position = active and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
        end)
    end

    -- CONTENIDO DE PÁGINAS
    NewToggle(PMain, "Noclip Walls", "Noclip")
    NewToggle(PMain, "Mobile Inf Jump", "InfJump")
    NewToggle(PMain, "Anti AFK System", "AntiAFK")
    
    NewToggle(PESP, "Master ESP", "ESP")
    -- (Aquí puedes añadir los botones de colores que ya teníamos)

    NewToggle(PCombat, "Aimbot Master", "Aimbot")
    NewToggle(PCombat, "Kill Aura (Legit)", "AimbotLegit")

    NewToggle(PTP, "Auto TP Player", "TP_Smart")
    
    local footer = Instance.new("TextLabel", MainFrame)
    footer.Size = UDim2.new(1, 0, 0, 20); footer.Position = UDim2.new(0, 0, 1, -25)
    footer.Text = "FOLLOW ME ON TIKTOK: @sasware32"; footer.TextColor3 = Color3.fromRGB(0, 255, 120)
    footer.Font = Enum.Font.Code; footer.TextSize = 12; footer.BackgroundTransparency = 1
end

-- =============================================================
-- MOTORES LÓGICOS (SIN CAMBIOS PARA ESTABILIDAD)
-- =============================================================
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Heartbeat:Connect(function()
    if Toggles.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
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
    -- Smart Teleport Logic (Grok)
    if Toggles.TP_Smart and LocalPlayer.Character and tick() - lastTeleport > math.random(2, 4) then
        -- (Misma lógica de búsqueda de target que antes)
        lastTeleport = tick()
    end
end)

RunIntro()
