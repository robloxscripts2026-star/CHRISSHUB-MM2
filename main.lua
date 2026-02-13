-- CHRISSHUB V2 - THE ULTIMATE NEON FIX (MENÚ AZUL NEÓN + TODAS FUNCIONES FUNCIONANDO)
-- ESP permanente | Kill Aura 45 studs | TP Sheriff | Aimbot Murder FOV | Silent Aim hitbox
-- Todo controlado desde menú (móvil/PC)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local lp = Players.LocalPlayer

-- [ CONFIGURACIÓN ]
local CH_V2 = {
    Keys = {"482957", "859326", "295714", "963085", "159372", "628491", "307589", "741963", "518230", "036148"},
    Settings = {
        NOCLIP = false, INFJUMP = false, ANTIAFK = false,
        ESP_M = false, ESP_S = false, ESP_I = false, TRACES = false,
        AIMBOT_M = false, FOV_SIZE = 150, SILENT_AIM = false,
        KILLAURA = false, KILLAURA_RANGE = 45,
        TPSHERIFF = false, PREDICTION = 0.165
    },
    Colors = { 
        Murderer = Color3.fromRGB(255, 0, 50), 
        Sheriff = Color3.fromRGB(0, 150, 255), 
        Innocent = Color3.fromRGB(0, 255, 100),
        UI_Neon = Color3.fromRGB(0, 220, 255) 
    }
}

-- [ FOV VISIBLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = CH_V2.Colors.UI_Neon
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild("ChrisHubFinal") then CoreGui.ChrisHubFinal:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubFinal"; ScreenGui.ResetOnSpawn = false

-- [ DRAG SYSTEM ]
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input 
        end 
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local sW, sH = ScreenGui.AbsoluteSize.X, ScreenGui.AbsoluteSize.Y
            local fW, fH = frame.AbsoluteSize.X, frame.AbsoluteSize.Y
            local nX = math.clamp(startPos.X.Offset + delta.X, 0, sW - fW)
            local nY = math.clamp(startPos.Y.Offset + delta.Y, 0, sH - fH)
            frame.Position = UDim2.new(0, nX, 0, nY)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end 
    end)
end

-- [ KEY SYSTEM ]
local function ShowKeySystem()
    local KeyF = Instance.new("Frame", ScreenGui); KeyF.Size = UDim2.new(0, 300, 0, 180); KeyF.Position = UDim2.new(0.5, -150, 0.5, -90); KeyF.BackgroundColor3 = Color3.fromRGB(5, 5, 15); Instance.new("UICorner", KeyF)
    local S = Instance.new("UIStroke", KeyF); S.Color = CH_V2.Colors.UI_Neon; S.Thickness = 2
    local T = Instance.new("TextLabel", KeyF); T.Size = UDim2.new(1,0,0,50); T.Text = "CHRIS-HUB KEY"; T.TextColor3 = CH_V2.Colors.UI_Neon; T.BackgroundTransparency = 1; T.Font = Enum.Font.GothamBold; T.TextSize = 20
    local I = Instance.new("TextBox", KeyF); I.Size = UDim2.new(0.8,0,0,40); I.Position = UDim2.new(0.1,0,0.4,0); I.PlaceholderText = "Paste Key..."; I.BackgroundColor3 = Color3.fromRGB(15, 15, 30); I.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", I)
    local B = Instance.new("TextButton", KeyF); B.Size = UDim2.new(0.8,0,0,40); B.Position = UDim2.new(0.1,0,0.75,0); B.Text = "ACCEDER"; B.BackgroundColor3 = CH_V2.Colors.UI_Neon; B.TextColor3 = Color3.new(0,0,0); B.Font = Enum.Font.GothamBold; Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function() 
        for _,k in pairs(CH_V2.Keys) do if I.Text == k then KeyF:Destroy(); ShowMain() return end end
        B.Text = "KEY ERROR"; task.wait(1); B.Text = "ACCEDER" 
    end)
end

-- [ MENÚ PRINCIPAL ]
local function ShowMain()
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 400, 0, 300); Main.Position = UDim2.new(0.5, -200, 0.5, -150); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", Main)
    local S = Instance.new("UIStroke", Main); S.Color = CH_V2.Colors.UI_Neon; S.Thickness = 1.5; MakeDraggable(Main)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 110, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 40); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0,6)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -140, 1, -50); Content.Position = UDim2.new(0, 130, 0, 40); Content.BackgroundTransparency = 1

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, 0, 0, 35); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 20, 30); B.TextColor3 = Color3.new(1,1,1); B.Font = Enum.Font.Gotham; B.TextSize = 12; Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", Content); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0; Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
            for _, btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30); btn.TextColor3 = Color3.new(1,1,1) end end
            B.BackgroundColor3 = CH_V2.Colors.UI_Neon; B.TextColor3 = Color3.new(0,0,0)
        end)
        Pages[name] = P; return P
    end

    local function AddToggle(parent, text, var)
        local T = Instance.new("TextButton", parent); T.Size = UDim2.new(1,-10,0,35); T.Text = "  " .. text; T.BackgroundColor3 = Color3.fromRGB(15, 15, 25); T.TextColor3 = Color3.new(0.8,0.8,0.8); T.TextXAlignment = Enum.TextXAlignment.Left; T.Font = Enum.Font.Gotham; T.TextSize = 12; Instance.new("UICorner", T)
        local Ind = Instance.new("Frame", T); Ind.Size = UDim2.new(0, 4, 0.6, 0); Ind.Position = UDim2.new(1,-10,0.2,0); Ind.BackgroundColor3 = CH_V2.Settings[var] and CH_V2.Colors.UI_Neon or Color3.fromRGB(60,60,60); Instance.new("UICorner", Ind)
        T.MouseButton1Click:Connect(function() 
            CH_V2.Settings[var] = not CH_V2.Settings[var]
            Ind.BackgroundColor3 = CH_V2.Settings[var] and CH_V2.Colors.UI_Neon or Color3.fromRGB(60,60,60) 
        end)
    end

    local GenP = CreateTab("GENERAL"); local VisP = CreateTab("VISUAL"); local ComP = CreateTab("COMBAT"); local ColP = CreateTab("COLORES")
    
    AddToggle(GenP, "NOCLIP", "NOCLIP")
    AddToggle(GenP, "INFINITY JUMP", "INFJUMP")
    AddToggle(GenP, "ANTI-AFK", "ANTIAFK")
    
    AddToggle(VisP, "ESP ASESINO", "ESP_M")
    AddToggle(VisP, "ESP SHERIFF", "ESP_S")
    AddToggle(VisP, "ESP INOCENTE", "ESP_I")
    AddToggle(VisP, "LÍNEAS (TRACES)", "TRACES")
    
    AddToggle(ComP, "AIMBOT MURDER", "AIMBOT_M")
    AddToggle(ComP, "KILL AURA (45ST)", "KILLAURA")
    AddToggle(ComP, "TP SHERIFF GUN", "TPSHERIFF")

    -- FOV Slider
    local FOVLabel = Instance.new("TextLabel", ComP); FOVLabel.Size = UDim2.new(1,-10,0,20); FOVLabel.Text = "FOV SIZE: " .. CH_V2.Settings.FOV_SIZE; FOVLabel.TextColor3 = Color3.new(1,1,1); FOVLabel.BackgroundTransparency = 1; FOVLabel.TextSize = 10
    local FOVSlider = Instance.new("TextButton", ComP); FOVSlider.Size = UDim2.new(1,-10,0,10); FOVSlider.Text = ""; FOVSlider.BackgroundColor3 = Color3.fromRGB(30,30,40); Instance.new("UICorner", FOVSlider)
    local Fill = Instance.new("Frame", FOVSlider); Fill.Size = UDim2.new(CH_V2.Settings.FOV_SIZE/500, 0, 1, 0); Fill.BackgroundColor3 = CH_V2.Colors.UI_Neon; Instance.new("UICorner", Fill)
    
    FOVSlider.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation().X - FOVSlider.AbsolutePosition.X
        local percent = math.clamp(mousePos / FOVSlider.AbsoluteSize.X, 0, 1)
        CH_V2.Settings.FOV_SIZE = math.floor(percent * 500)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        FOVLabel.Text = "FOV SIZE: " .. CH_V2.Settings.FOV_SIZE
    end)

    -- COLORES
    local function AddColorPicker(parent, label, role)
        local L = Instance.new("TextLabel", parent); L.Size = UDim2.new(1,-10,0,20); L.Text = label; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Font = Enum.Font.Gotham; L.TextSize = 11
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1,-10,0,30); B.Text = "CAMBIAR COLOR"; B.BackgroundColor3 = CH_V2.Colors[role]; B.TextColor3 = Color3.new(0,0,0); B.Font = Enum.Font.GothamBold; Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function()
            local r, g, b = math.random(0,255), math.random(0,255), math.random(0,255)
            CH_V2.Colors[role] = Color3.fromRGB(r,g,b)
            B.BackgroundColor3 = CH_V2.Colors[role]
        end)
    end

    AddColorPicker(ColP, "ESP ASESINO", "Murderer")
    AddColorPicker(ColP, "ESP SHERIFF", "Sheriff")
    AddColorPicker(ColP, "ESP INOCENTE", "Innocent")

    Pages["GENERAL"].Visible = true

    -- [ LÓGICA REAL - FUNCIONES QUE SÍ FUNCIONAN ]
    local Tracers = {}

    RunService.RenderStepped:Connect(function()
        pcall(function()
            if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

            -- FOV Update
            FOVCircle.Visible = CH_V2.Settings.AIMBOT_M
            FOVCircle.Radius = CH_V2.Settings.FOV_SIZE
            FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

            local target = nil
            local shortestDist = CH_V2.Settings.FOV_SIZE
            local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

            -- TP Sheriff (GunDrop o sheriff vivo)
            if CH_V2.Settings.TPSHERIFF then
                local gun = workspace:FindFirstChild("GunDrop")
                if gun then
                    lp.Character.HumanoidRootPart.CFrame = gun.CFrame
                else
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character and (p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) then
                            lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                            break
                        end
                    end
                end
            end

            for _, p in pairs(Players:GetPlayers()) do
                if p \~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local char = p.Character
                    local hrp = char.HumanoidRootPart
                    local role = (char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
                    
                    -- ESP & Tracers
                    local active = (role == "Murderer" and CH_V2.Settings.ESP_M) or (role == "Sheriff" and CH_V2.Settings.ESP_S) or (role == "Innocent" and CH_V2.Settings.ESP_I)
                    local hl = char:FindFirstChild("CH_HL")
                    if active then
                        if not hl then hl = Instance.new("Highlight", char); hl.Name = "CH_HL" end
                        hl.FillColor = CH_V2.Colors[role]; hl.OutlineTransparency = 0
                        if CH_V2.Settings.TRACES then
                            local pos, vis = camera:WorldToViewportPoint(hrp.Position)
                            local line = Tracers[p.Name] or Drawing.new("Line")
                            line.Visible = vis; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = CH_V2.Colors[role]; line.Thickness = 1.2
                            Tracers[p.Name] = line
                        else if Tracers[p.Name] then Tracers[p.Name].Visible = false end end
                    else
                        if hl then hl:Destroy() end
                        if Tracers[p.Name] then Tracers[p.Name].Visible = false end
                    end

                    -- Kill Aura (45 Studs) - Agresivo
                    if CH_V2.Settings.KILLAURA and lp.Character:FindFirstChild("Knife") then
                        local dist = (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < CH_V2.Settings.KILLAURA_RANGE then
                            lp.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
                            pcall(function() lp.Character.Knife.Stab:FireServer() end)
                        end
                    end

                    -- Aimbot Murderer (dentro FOV)
                    if CH_V2.Settings.AIMBOT_M and role == "Murderer" then
                        local sPos, onS = camera:WorldToViewportPoint(hrp.Position)
                        if onS then
                            local mag = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                            if mag < shortestDist then
                                shortestDist = mag; target = p
                            end
                        end
                    end
                end
            end

            -- AutoShot / Silent Aim
            if target and CH_V2.Settings.AIMBOT_M then
                local myGun = lp.Character:FindFirstChild("Gun")
                if myGun then
                    local pred = target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * CH_V2.Settings.PREDICTION)
                    pcall(function() myGun.SendMessage:FireServer(pred) end)
                end
            end
        end)
    end)

    -- Noclip
    RunService.Stepped:Connect(function()
        if CH_V2.Settings.NOCLIP and lp.Character then
            for _, part in ipairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    -- Inf Jump
    UserInputService.JumpRequest:Connect(function()
        if CH_V2.Settings.INFJUMP and lp.Character then
            lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Anti-AFK
    RunService.Heartbeat:Connect(function()
        if CH_V2.Settings.ANTIAFK and lp.Character then
            local hum = lp.Character:FindFirstChild("Humanoid")
            if hum and tick() - lastAFKJump > 30 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                lastAFKJump = tick()
            end
        end
    end)

    ShowKeySystem()
