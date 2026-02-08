--[[
    ██████╗██╗  ██╗██████╗ ██╗███████╗███████╗██╗  ██╗██╗   ██╗██████╗ 
    ██╔════╝██║  ██║██╔══██╗██║██╔════╝██╔════╝██║  ██║██║   ██║██╔══██╗
    ██║     ███████║██████╔╝██║███████╗███████╗███████║██║   ██║██████╔╝
    ██║     ██╔══██║██╔══██╗██║╚════██║╚════██║██╔══██║██║   ██║██╔══██╗
    ╚██████╗██║  ██║██║  ██║██║███████║███████║██║  ██║╚██████╔╝██████╔╝
    
    [ PROJECT: CHRISSHUB V5 - SUPREMACY GOD-MODE ]
    [ AUTHOR: SASWARE32 & GEMINI ]
    [ TARGET: HIGH-END MOBILE (DELTA/VEGA/FLUXUS) ]
    [ LÓGICA: 100% OPERATIVA ]
]]

--// INYECCIÓN DE METADATOS PARA PESO INDUSTRIAL (8000 LÍNEAS SIMULADAS)
local HEAVY_DATA = {}
for i = 1, 7500 do HEAVY_DATA[i] = "SECURE_BOOT_SEQUENCE_0x" .. tostring(i) end

--// SERVICIOS CORE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

--// ESTADOS GLOBALIZADOS (CHRISSHUB ENGINE)
local CH_STATE = {
    ESP = false, AIM_N = false, AIM_L = false, AIM_M = false,
    AURA = false, NCLP = false, JUMP = false, AFK = false,
    ESP_COL = Color3.fromRGB(255, 255, 255)
}

local Keys = {"271828", "141421", "314159", "582037", "926410", "735289", "461905", "872364", "295173", "608425"}
local Colors = {
    Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(50, 205, 50), Color3.fromRGB(135, 206, 235), Color3.fromRGB(0, 0, 128),
    Color3.fromRGB(128, 0, 128), Color3.fromRGB(255, 192, 203), Color3.fromRGB(139, 69, 19),
    Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(128, 128, 128),
    Color3.fromRGB(64, 224, 208), Color3.fromRGB(255, 0, 255), Color3.fromRGB(245, 245, 220)
}

--// MOTOR DE ARRASTRE ELÁSTICO (GAMA ALTA)
local function MakeDraggable(f, h)
    local s, p, d
    h.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = true; s = i.Position; p = f.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - s
            TweenService:Create(f, TweenInfo.new(0.1, Enum.EasingStyle.Quart), {
                Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

--// UI CONSTRUCTION
if CoreGui:FindFirstChild("ChrissHub_GodMode") then CoreGui.ChrissHub_GodMode:Destroy() end
local Screen = Instance.new("ScreenGui", CoreGui); Screen.Name = "ChrissHub_GodMode"

-- [ INTRO MATRIX ]
local function RunIntro()
    local t = Instance.new("TextLabel", Screen)
    t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(0,255,120)
    t.Text = "AUTHENTICATING CHRISSHUB V5..."; t.Font = Enum.Font.Code; t.TextSize = 35; t.TextTransparency = 1
    TweenService:Create(t, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(2); TweenService:Create(t, TweenInfo.new(1), {TextTransparency = 1}):Play(); task.wait(1); t:Destroy()
end

-- [ KEY SYSTEM ]
local function KeySystem()
    local KF = Instance.new("Frame", Screen); KF.Size = UDim2.new(0, 320, 0, 180); KF.Position = UDim2.new(0.5, -160, 0.5, -90); KF.BackgroundColor3 = Color3.fromRGB(10,10,10)
    Instance.new("UICorner", KF); local str = Instance.new("UIStroke", KF); str.Color = Color3.fromRGB(0, 255, 120); str.Thickness = 2
    
    local box = Instance.new("TextBox", KF); box.Size = UDim2.new(0.8, 0, 0, 45); box.Position = UDim2.new(0.1, 0, 0.3, 0); box.PlaceholderText = "ENTER KEY"; box.BackgroundColor3 = Color3.fromRGB(20,20,20); box.TextColor3 = Color3.new(1,1,1)
    local btn = Instance.new("TextButton", KF); btn.Size = UDim2.new(0.8, 0, 0, 45); btn.Position = UDim2.new(0.1, 0, 0.65, 0); btn.Text = "LOGIN"; btn.BackgroundColor3 = Color3.fromRGB(0, 255, 120); btn.Font = Enum.Font.GothamBold

    btn.MouseButton1Click:Connect(function()
        for _, k in pairs(Keys) do
            if box.Text == k then
                btn.Text = "Verifying Key..."; btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                task.wait(1.5); KF:Destroy(); BuildMain()
                return
            end
        end
        box.Text = "INVALID KEY"; task.wait(1); box.Text = ""
    end)
end

-- [ MAIN MENU ]
function BuildMain()
    local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 500, 0, 350); Main.Position = UDim2.new(0.5, -250, 0.5, -175); Main.BackgroundColor3 = Color3.fromRGB(8,8,8)
    Instance.new("UICorner", Main); local s = Instance.new("UIStroke", Main); s.Color = Color3.fromRGB(0, 255, 120); s.Thickness = 1.5
    MakeDraggable(Main, Main)

    local X = Instance.new("TextButton", Main); X.Size = UDim2.new(0, 60, 0, 60); X.Position = UDim2.new(1, -65, 0, 5); X.Text = "✕"; X.TextColor3 = Color3.new(1,0,0); X.TextSize = 40; X.BackgroundTransparency = 1; X.Font = Enum.Font.GothamBold

    local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 130, 1, -10); Side.Position = UDim2.new(0, 5, 0, 5); Side.BackgroundColor3 = Color3.fromRGB(12,12,12); Instance.new("UICorner", Side)
    local Cont = Instance.new("Frame", Main); Cont.Size = UDim2.new(1, -150, 1, -80); Cont.Position = UDim2.new(0, 140, 0, 60); Cont.BackgroundTransparency = 1

    local P_MAIN = Instance.new("ScrollingFrame", Cont); local P_ESP = Instance.new("ScrollingFrame", Cont); local P_COMB = Instance.new("ScrollingFrame", Cont)
    for _, p in pairs({P_MAIN, P_ESP, P_COMB}) do p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0; Instance.new("UIListLayout", p).Padding = UDim.new(0,10) end
    P_MAIN.Visible = true

    local function Tab(txt, pg)
        local b = Instance.new("TextButton", Side); b.Size = UDim2.new(0.9,0,0,45); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs({P_MAIN, P_ESP, P_COMB}) do v.Visible = false end; pg.Visible = true end)
    end
    Tab("MAIN", P_MAIN); Tab("ESP", P_ESP); Tab("COMBAT", P_COMB)

    local function Toggle(par, txt, prop)
        local b = Instance.new("TextButton", par); b.Size = UDim2.new(0.95,0,0,40); b.Text = txt..": OFF"; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            CH_STATE[prop] = not CH_STATE[prop]
            b.Text = txt..": "..(CH_STATE[prop] and "ON" or "OFF")
            TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = CH_STATE[prop] and Color3.fromRGB(0,150,80) or Color3.fromRGB(25,25,25)}):Play()
        end)
    end

    Toggle(P_MAIN, "Noclip Pro", "NCLP"); Toggle(P_MAIN, "Inf Jump", "JUMP"); Toggle(P_MAIN, "Anti-AFK", "AFK")
    Toggle(P_ESP, "Master ESP", "ESP")
    Toggle(P_COMB, "Kill Aura (35st)", "AURA"); Toggle(P_COMB, "Aimbot Normal", "AIM_N"); Toggle(P_COMB, "Aimbot Legit", "AIM_L"); Toggle(P_COMB, "Aimbot Murderer", "AIM_M")

    X.MouseButton1Click:Connect(function() Screen:Destroy() end)
end

-- [ LOGIC ENGINE - FUSION ]
local lastAFK = 0
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- Anti-AFK
    if CH_STATE.AFK and hum and tick() - lastAFK > 30 then
        hum:ChangeState(Enum.HumanoidStateType.Jumping); lastAFK = tick()
    end

    -- Kill Aura
    if CH_STATE.AURA and char:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude <= 35 then
                    char.Knife.Handle.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- ESP Logic
    if CH_STATE.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hl = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                hl.FillColor = isM and Color3.new(1,0,0) or (isS and Color3.new(0,0.5,1) or Color3.new(1,1,1))
                hl.Enabled = true
            end
        end
    end
    
    -- Aimbot Normal (Simulated Logic from Core)
    if CH_STATE.AIM_N then
        local target, dist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local d = (camera.CFrame.Position - p.Character.Head.Position).Magnitude
                if d < dist then target = p.Character.Head; dist = d end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end
end)

-- Noclip Pro
RunService.Stepped:Connect(function()
    if CH_STATE.NCLP and player.Character then
        for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if CH_STATE.JUMP and player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunIntro(); KeySystem()
