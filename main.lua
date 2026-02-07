--[[
    ██████╗██╗  ██╗██████╗ ██╗███████╗███████╗██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██║  ██║██╔══██╗██║██╔════╝██╔════╝██║  ██║██║   ██║██╔══██╗
    ██║     ███████║██████╔╝██║███████╗███████╗███████║██║   ██║██████╔╝
    ██║     ██╔══██║██╔══██╗██║╚════██║╚════██║██╔══██║██║   ██║██╔══██╗
    ╚██████╗██║  ██║██║  ██║██║███████║███████║██║  ██║╚██████╔╝██████╔╝
    
    CHRISSHUB MM2 V3 - SUPREMACY EDITION (FIXED & EXPANDED)
    Categorías: MAIN, ESP, COMBAT, TELEPORT
    TikTok: sasware32 | Dev: Gemini & Grok Logic
]]

-- =============================================================
-- [1] SERVICIOS Y VARIABLES DEL NÚCLEO
-- =============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Limpieza de ejecuciones previas
if CoreGui:FindFirstChild("ChrissHub_Official") then
    CoreGui:FindFirstChild("ChrissHub_Official"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrissHub_Official"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =============================================================
-- [2] CONFIGURACIÓN MAESTRA
-- =============================================================
local Toggles = {
    ESP = false,
    Aimbot = false,
    AimbotLegit = false,
    AimbotMurder = false,
    Noclip = false,
    InfJump = false,
    AntiAFK = false,
    TP_Smart = false -- Nueva función integrada de Grok
}

local ESPConfig = {
    MurdererColor = Color3.fromRGB(255, 0, 0),
    SheriffColor = Color3.fromRGB(0, 0, 128),
    InnocentColor = Color3.fromRGB(50, 205, 50)
}

local lastTeleport = 0
local ValidKeys = {"482916", "731592"}

local ColorLibrary = {
    ["Rojo"] = Color3.fromRGB(255, 0, 0),
    ["Azul marino"] = Color3.fromRGB(0, 0, 128),
    ["Verde lima"] = Color3.fromRGB(50, 205, 50),
    ["Blanco"] = Color3.fromRGB(255, 255, 255),
    ["Amarillo"] = Color3.fromRGB(255, 255, 0),
    ["Rosa"] = Color3.fromRGB(255, 105, 180)
}
local ColorNames = {"Rojo", "Azul marino", "Verde lima", "Blanco", "Amarillo", "Rosa"}

-- =============================================================
-- [3] UTILIDADES DE ANIMACIÓN Y ARRASTRE
-- =============================================================
local function CreateTween(obj, props, duration)
    local tw = TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
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
-- [4] INTRO (LLUVIA DE CÓDIGO)
-- =============================================================
local function RunIntro()
    task.spawn(function()
        for i = 1, 35 do
            local code = Instance.new("TextLabel", ScreenGui)
            code.Size = UDim2.new(0, 80, 0, 20)
            code.Position = UDim2.new(math.random(), 0, -0.1, 0)
            code.BackgroundTransparency = 1
            code.Text = tostring(math.random(10101, 99999))
            code.TextColor3 = Color3.fromRGB(0, 255, 120)
            code.Font = Enum.Font.Code; code.TextSize = 14
            local d = math.random(2, 4)
            CreateTween(code, {Position = UDim2.new(code.Position.X.Scale, 0, 1.1, 0), TextTransparency = 1}, d)
            Debris:AddItem(code, d)
            task.wait(0.1)
        end
    end)
    task.wait(1.5); ShowKeySystem()
end

-- =============================================================
-- [5] KEY SYSTEM (VERIFYING...)
-- =============================================================
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 300, 0, 180)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", KeyFrame)

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0.8, 0, 0, 40); Input.Position = UDim2.new(0.1, 0, 0.3, 0)
    Input.PlaceholderText = "Enter Key"; Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)

    local Btn = Instance.new("TextButton", KeyFrame)
    Btn.Size = UDim2.new(0.8, 0, 0, 40); Btn.Position = UDim2.new(0.1, 0, 0.65, 0)
    Btn.Text = "SUBMIT"; Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, k in pairs(ValidKeys) do
            if Input.Text == k then
                Btn.Text = "Verifying Key..."; Btn.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
                task.wait(1); KeyFrame:Destroy(); BuildMainHub()
                return
            end
        end
        Input.Text = "INVALID KEY"
    end)
end

-- =============================================================
-- [6] HUB PRINCIPAL (XHUB STYLE)
-- =============================================================
function BuildMainHub()
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 520, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Instance.new("UICorner", MainFrame)
    MakeDraggable(MainFrame, MainFrame)

    -- BOTÓN X (CERRAR)
    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.BackgroundTransparency = 1; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 20

    -- BOTÓN HUB FLOTANTE
    local Floating = Instance.new("TextButton", ScreenGui)
    Floating.Size = UDim2.new(0, 60, 0, 60); Floating.Position = UDim2.new(0, 20, 0.5, 0)
    Floating.BackgroundColor3 = Color3.fromRGB(0, 255, 120); Floating.Text = "HUB"
    Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0)
    MakeDraggable(Floating, Floating)

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false; Floating.Visible = true
    end)
    Floating.MouseButton1Click:Connect(function()
        MainFrame.Visible = true; Floating.Visible = false
    end)

    -- SIDEBAR
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Sidebar)

    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -140, 1, -10); Container.Position = UDim2.new(0, 135, 0, 5)
    Container.BackgroundTransparency = 1

    local function CreatePage(name)
        local p = Instance.new("ScrollingFrame", Container)
        p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
        p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,0,600)
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        return p
    end

    local PMain = CreatePage("Main"); PMain.Visible = true
    local PESP = CreatePage("ESP")
    local PCombat = CreatePage("Combat")
    local PTP = CreatePage("Teleport")

    local function AddTab(name, page)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(0.9, 0, 0, 38); b.Position = UDim2.new(0.05, 0, 0, (#Sidebar:GetChildren()-1) * 45 + 10)
        b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            page.Visible = true
        end)
    end

    AddTab("Main", PMain); AddTab("ESP", PESP); AddTab("Combat", PCombat); AddTab("Teleport", PTP)

    local function NewToggle(parent, text, prop)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.95, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        b.Text = text .. ": OFF"; b.TextColor3 = Color3.fromRGB(150, 150, 150); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Toggles[prop] = not Toggles[prop]
            b.Text = text .. ": " .. (Toggles[prop] and "ON" or "OFF")
            CreateTween(b, {
                BackgroundColor3 = Toggles[prop] and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(20, 20, 20),
                TextColor3 = Toggles[prop] and Color3.new(1,1,1) or Color3.fromRGB(150, 150, 150)
            }, 0.2)
        end)
    end

    -- PÁGINA MAIN
    NewToggle(PMain, "Noclip", "Noclip")
    NewToggle(PMain, "Inf Jump (Móvil)", "InfJump")
    NewToggle(PMain, "Anti AFK", "AntiAFK")
    local s = Instance.new("TextLabel", PMain); s.Size = UDim2.new(1,0,0,30); s.Text = "Sigueme: sasware32"; s.BackgroundTransparency = 1; s.TextColor3 = Color3.new(0.5,0.5,0.5)

    -- PÁGINA ESP
    NewToggle(PESP, "Activar ESP", "ESP")
    local function AddCol(role, key)
        local cb = Instance.new("TextButton", PESP)
        cb.Size = UDim2.new(0.95, 0, 0, 40); cb.Text = "Color " .. role; cb.BackgroundColor3 = ESPConfig[key]
        Instance.new("UICorner", cb)
        cb.MouseButton1Click:Connect(function()
            local cur = ""
            for n, c in pairs(ColorLibrary) do if c == ESPConfig[key] then cur = n end end
            local nextIdx = (table.find(ColorNames, cur) or 1) % #ColorNames + 1
            ESPConfig[key] = ColorLibrary[ColorNames[nextIdx]]
            cb.BackgroundColor3 = ESPConfig[key]
        end)
    end
    AddCol("Murderer", "MurdererColor"); AddCol("Sheriff", "SheriffColor"); AddCol("Innocent", "InnocentColor")

    -- PÁGINA COMBAT
    NewToggle(PCombat, "Aimbot", "Aimbot")
    NewToggle(PCombat, "Aimbot Legit", "AimbotLegit")
    NewToggle(PCombat, "Aimbot Murderer", "AimbotMurder")

    -- PÁGINA TELEPORT (LOGICA GROK)
    local info = Instance.new("TextLabel", PTP)
    info.Size = UDim2.new(1,0,0,40); info.Text = "Teleport Inteligente (Anti-Ban)"; info.TextColor3 = Color3.fromRGB(0,255,120); info.BackgroundTransparency = 1
    NewToggle(PTP, "Auto Teleport", "TP_Smart")
end

-- =============================================================
-- [7] MOTORES LÓGICOS (COMBINADOS)
-- =============================================================

-- Salto Infinito
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Bucle Principal (Heartbeat)
RunService.Heartbeat:Connect(function()
    -- Noclip
    if Toggles.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- ESP Logic
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

    -- SMART TELEPORT (Grok Logic Integrada)
    if Toggles.TP_Smart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        local target = nil
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local tChar = plr.Character
                local hasKnife = myChar:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                local hasGun = myChar:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")

                if hasKnife and (tChar:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun")) then
                    target = plr; break
                elseif hasGun and (tChar:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")) then
                    target = plr; break
                elseif not hasKnife and not hasGun and (tChar:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")) then
                    target = plr; break
                end
            end
        end

        if target and tick() - lastTeleport > math.random(1, 3) then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            lastTeleport = tick()
        end
    end
end)

-- Iniciar
RunIntro()
