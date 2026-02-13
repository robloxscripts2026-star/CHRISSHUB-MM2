--[[
    CHRISHUB V2 - ELITE DEFINITIVE FIX
    -------------------------------------------
    - FIX: Aimbot con FOV Real (Visible)
    - FIX: Kill Aura Agresivo (Auto-Stab)
    - FIX: TP Sheriff (Auto-pickup Gun)
    - UI: Estilo de lista con selectores de color
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- [ CONFIGURACIÓN ]
local CH_V2 = {
    Keys = {"482957", "859326", "295714", "963085", "159372", "628491", "307589", "741963", "518230", "036148"},
    Settings = {
        NOCLIP = false, INFJUMP = false,
        ESP_M = false, ESP_S = false, ESP_I = false, TRACES = false,
        AIMBOT_M = false, FOV_SIZE = 150, AUTOSHOT = true, 
        KILLAURA = false, TPSHERIFF = false, PREDICTION = 0.165
    },
    Colors = { 
        Murderer = Color3.fromRGB(255, 0, 50), 
        Sheriff = Color3.fromRGB(0, 150, 255), 
        Innocent = Color3.fromRGB(0, 255, 100),
        UI_Neon = Color3.fromRGB(0, 220, 255) 
    }
}

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = CH_V2.Colors.UI_Neon
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild("ChrisHubFinal") then CoreGui.ChrisHubFinal:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubFinal"

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
            frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) dragging = false end)
end

function ShowMain()
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 380, 0, 320); Main.Position = UDim2.new(0.5, -190, 0.5, -160); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", Main);
    local S = Instance.new("UIStroke", Main); S.Color = CH_V2.Colors.UI_Neon; S.Thickness = 1.5; MakeDraggable(Main)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 110, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0,6)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -140, 1, -50); Content.Position = UDim2.new(0, 130, 0, 45); Content.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1,0,0,40); Title.Text = "CHRIS-HUB ELITE"; Title.TextColor3 = CH_V2.Colors.UI_Neon; Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.BackgroundTransparency = 1

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, 0, 0, 35); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 20, 30); B.TextColor3 = Color3.new(1,1,1); B.Font = Enum.Font.Gotham; B.TextSize = 12; Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", Content); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0; Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
            for _, btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30) end end
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

    local VisP = CreateTab("VISUAL"); local ComP = CreateTab("COMBAT"); local ColP = CreateTab("COLORES")
    
    AddToggle(VisP, "ESP ASESINO", "ESP_M"); AddToggle(VisP, "ESP SHERIFF", "ESP_S"); AddToggle(VisP, "ESP INOCENTE", "ESP_I")
    
    AddToggle(ComP, "AIMBOT MURDER", "AIMBOT_M"); AddToggle(ComP, "KILL AURA 45ST", "KILLAURA"); AddToggle(ComP, "TP SHERIFF GUN", "TPSHERIFF")

    -- FOV Slider Simple
    local FovB = Instance.new("TextButton", ComP); FovB.Size = UDim2.new(1,-10,0,30); FovB.Text = "AJUSTAR FOV (+50)"; FovB.BackgroundColor3 = Color3.fromRGB(30,30,45); FovB.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", FovB)
    FovB.MouseButton1Click:Connect(function()
        CH_V2.Settings.FOV_SIZE = (CH_V2.Settings.FOV_SIZE >= 400) and 50 or CH_V2.Settings.FOV_SIZE + 50
        FovB.Text = "FOV SIZE: " .. CH_V2.Settings.FOV_SIZE
    end)

    -- [ SECCIÓN COLORES - COMO PEDISTE ]
    local function AddColorRow(parent, label, role)
        local L = Instance.new("TextLabel", parent); L.Size = UDim2.new(1,-10,0,20); L.Text = label; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"; L.Font = Enum.Font.Gotham; L.TextSize = 12
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1,-10,0,30); B.Text = "CAMBIAR COLOR"; B.BackgroundColor3 = CH_V2.Colors[role]; B.TextColor3 = Color3.new(0,0,0); B.Font = Enum.Font.GothamBold; Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function()
            local r, g, b = math.random(0,255), math.random(0,255), math.random(0,255)
            CH_V2.Colors[role] = Color3.fromRGB(r,g,b); B.BackgroundColor3 = CH_V2.Colors[role]
        end)
    end

    AddColorRow(ColP, "ESP ASESINO", "Murderer")
    AddColorRow(ColP, "ESP SHERIFF", "Sheriff")
    AddColorRow(ColP, "ESP INOCENTE", "Innocent")

    Pages["VISUAL"].Visible = true
end

-- [ MOTOR DE FUNCIONES ]
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
        local myHrp = lp.Character.HumanoidRootPart

        -- Update FOV
        FOVCircle.Visible = CH_V2.Settings.AIMBOT_M
        FOVCircle.Radius = CH_V2.Settings.FOV_SIZE
        FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

        -- TP SHERIFF GUN
        if CH_V2.Settings.TPSHERIFF then
            local gunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun", true)
            if gunDrop and gunDrop:IsA("BasePart") then myHrp.CFrame = gunDrop.CFrame end
        end

        local target = nil; local dist = CH_V2.Settings.FOV_SIZE
        local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character; local hrp = char.HumanoidRootPart
                local role = (char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
                
                -- ESP
                local act = (role == "Murderer" and CH_V2.Settings.ESP_M) or (role == "Sheriff" and CH_V2.Settings.ESP_S) or (role == "Innocent" and CH_V2.Settings.ESP_I)
                local hl = char:FindFirstChild("CH_HL")
                if act then
                    if not hl then hl = Instance.new("Highlight", char); hl.Name = "CH_HL" end
                    hl.FillColor = CH_V2.Colors[role]; hl.OutlineTransparency = 0
                elseif hl then hl:Destroy() end

                -- KILL AURA 45ST (Solo si eres Murderer o para defenderte)
                if CH_V2.Settings.KILLAURA and role == "Murderer" then
                    local mag = (myHrp.Position - hrp.Position).Magnitude
                    if mag < 45 then
                        local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                        if knife then
                            myHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 2.5)
                            pcall(function() knife.Stab:FireServer() end) -- Ataque remoto
                        end
                    end
                end

                -- AIMBOT MURDER
                if CH_V2.Settings.AIMBOT_M and role == "Murderer" then
                    local sPos, onS = camera:WorldToViewportPoint(hrp.Position)
                    if onS then
                        local m = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                        if m < dist then dist = m; target = p end
                    end
                end
            end
        end

        -- AUTO SHOT
        if target and CH_V2.Settings.AIMBOT_M then
            local myGun = lp.Character:FindFirstChild("Gun")
            if myGun then
                local pred = target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * CH_V2.Settings.PREDICTION)
                pcall(function() myGun.SendMessage:FireServer(pred) end)
            end
        end
    end)
end)

-- Noclip & Inf Jump
RunService.Stepped:Connect(function()
    if CH_V2.Settings.NOCLIP and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if CH_V2.Settings.INFJUMP and lp.Character then lp.Character.Humanoid:ChangeState(3) end
end)

ShowMain()
