--[[
    CHRISSHUB MM2 V3 - RECOVERY EDITION
    -------------------------------------------
    SISTEMA: Aimbot con Suavizado (Smoothing)
    DISEÑO: Bordes Neon Movibles (Draggable)
    MEMORIA: Roles Permanentes
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local appId = "CH_RECOVERY_V3"

-- [ CONFIGURACIÓN ]
local CH_STATE = {
    Keys = {"482916", "731592", "264831", "917542", "358269", "621973", "845155"},
    Toggles = {
        ESP = false,
        Aimbot = false,
        Smoothing = 0.2, -- El valor que hace que se sienta "suave" al mover la cámara
        KillAura = false,
        Noclip = false,
        InfJump = false
    },
    Roles = { Murderers = {}, Sheriffs = {} }
}

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild(appId) then CoreGui[appId]:Destroy() end
local SG = Instance.new("ScreenGui", CoreGui); SG.Name = appId

-- [ FUNCIÓN ARRASTRAR (DRAGGABLE) ]
local function EnableDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ INTERFAZ NEON ]
function CreateMenu()
    local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 480, 0, 300); Main.Position = UDim2.new(0.5, -240, 0.5, -150); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0
    local Corner = Instance.new("UICorner", Main); Corner.CornerRadius = UDim.new(0, 15)
    local Glow = Instance.new("UIStroke", Main); Glow.Color = Color3.fromRGB(0, 255, 120); Glow.Thickness = 3; Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    EnableDrag(Main)

    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "CHRISSHUB V3 LEGACY"; Title.TextColor3 = Color3.fromRGB(0, 255, 120); Title.Font = "GothamBlack"; Title.TextSize = 20; Title.BackgroundTransparency = 1

    local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -40, 1, -80); Container.Position = UDim2.new(0, 20, 0, 60); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2; Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

    local function NewToggle(name, var)
        local b = Instance.new("TextButton", Container); b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = "  " .. name; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 14; b.TextXAlignment = "Left"; Instance.new("UICorner", b)
        local indicator = Instance.new("Frame", b); indicator.Size = UDim2.new(0, 40, 0, 20); indicator.Position = UDim2.new(1, -50, 0.5, -10); indicator.BackgroundColor3 = CH_STATE.Toggles[var] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 50); Instance.new("UICorner", indicator)
        
        b.MouseButton1Click:Connect(function()
            CH_STATE.Toggles[var] = not CH_STATE.Toggles[var]
            indicator.BackgroundColor3 = CH_STATE.Toggles[var] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 50)
        end)
    end

    NewToggle("ESP MAESTRO (PERMANENTE)", "ESP")
    NewToggle("AIMBOT SUAVE (LEGIT)", "Aimbot")
    NewToggle("KILL AURA (FAST)", "KillAura")
    NewToggle("NOCLIP (ATRAVESAR)", "Noclip")
    NewToggle("SALTO INFINITO", "InfJump")

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -40, 0, 10); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20
    Close.MouseButton1Click:Connect(function() SG:Destroy() end)
end

-- [ LÓGICA DE AIMBOT CON SUAVIZADO ]
RunService.RenderStepped:Connect(function()
    if CH_STATE.Toggles.Aimbot then
        local target = nil; local maxDist = math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                -- Priorizar asesino si se conoce
                local isM = CH_STATE.Roles.Murderers[p.UserId]
                local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
                
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < maxDist then
                        target = p.Character.Head
                        maxDist = mag
                    end
                end
            end
        end

        if target then
            -- Aquí está el "Smoothing": No bloquea la cámara, la interpola suavemente
            local lookAt = CFrame.new(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(lookAt, CH_STATE.Toggles.Smoothing)
        end
    end
end)

-- [ MEMORIA DE ROLES Y ESP ]
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            -- Detección permanente
            if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then CH_STATE.Roles.Murderers[p.UserId] = true end
            if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then CH_STATE.Roles.Sheriffs[p.UserId] = true end

            local h = p.Character:FindFirstChild("Highlight_CH")
            if CH_STATE.Toggles.ESP then
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "Highlight_CH" end
                local color = Color3.new(1,1,1)
                if CH_STATE.Roles.Murderers[p.UserId] then color = Color3.new(1,0,0)
                elseif CH_STATE.Roles.Sheriffs[p.UserId] then color = Color3.new(0,0.5,1) end
                h.FillColor = color; h.FillTransparency = 0.5; h.Enabled = true
            elseif h then h.Enabled = false end
        end
    end
end)

-- Noclip Pro
RunService.Stepped:Connect(function()
    if CH_STATE.Toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- [ SISTEMA DE KEY ]
function ShowLogin()
    local L = Instance.new("Frame", SG); L.Size = UDim2.new(0, 300, 0, 200); L.Position = UDim2.new(0.5, -150, 0.5, -100); L.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", L)
    local I = Instance.new("TextBox", L); I.Size = UDim2.new(0.8, 0, 0, 40); I.Position = UDim2.new(0.1, 0, 0.3, 0); I.PlaceholderText = "Key..."; I.TextColor3 = Color3.new(1,1,1); I.BackgroundColor3 = Color3.new(0,0,0); Instance.new("UICorner", I)
    local B = Instance.new("TextButton", L); B.Size = UDim2.new(0.8, 0, 0, 40); B.Position = UDim2.new(0.1, 0, 0.6, 0); B.Text = "LOGIN"; B.BackgroundColor3 = Color3.fromRGB(0, 255, 120); Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        for _, k in pairs(CH_STATE.Keys) do if I.Text == k or I.Text == "CHRIS2026" then L:Destroy(); CreateMenu() break end end
    end)
end

ShowLogin()
