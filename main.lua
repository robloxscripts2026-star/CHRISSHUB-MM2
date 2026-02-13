--[[
    CHRISSHUB V2 - AIMBOT & FOV FIX
    -------------------------------------------
    - FIX: FOV Visible (Aro Neón)
    - FIX: AutoShot funcional (Trigger bot)
    - NEW: Aimbot Murder (Prioridad Asesino)
    - UI: Futurista Movible (Límites de pantalla)
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [ CONFIG ]
local CH_V2 = {
    Keys = {"482957", "859326", "295714", "963085", "159372", "628491", "307589", "741963", "518230", "036148"},
    Settings = {
        NOCLIP = false, INFJUMP = false,
        ESP_M = false, ESP_S = false, ESP_I = false, TRACES = false,
        AIMBOT_M = false, FOV_SIZE = 120, AUTOSHOT = true, 
        KILLAURA = false, TPSHERIFF = false, PREDICTION = 0.165
    },
    Colors = { 
        Murderer = Color3.fromRGB(255, 0, 100), 
        Sheriff = Color3.fromRGB(0, 180, 255), 
        Innocent = Color3.fromRGB(0, 255, 150),
        NeonPurple = Color3.fromRGB(180, 0, 255) 
    }
}

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild("ChrisHubFix") then CoreGui.ChrisHubFix:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubFix"

-- [ MOVIMIENTO DE MENÚ ]
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local sW, sH = ScreenGui.AbsoluteSize.X, ScreenGui.AbsoluteSize.Y
            local fW, fH = frame.AbsoluteSize.X, frame.AbsoluteSize.Y
            local newX = math.clamp(startPos.X.Offset + delta.X, 0, sW - fW)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, sH - fH)
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size = UDim2.new(0, 280, 0, 160); KeyFrame.Position = UDim2.new(0.5, -140, 0.5, -80); KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 20); Instance.new("UICorner", KeyFrame);
    local Stroke = Instance.new("UIStroke", KeyFrame); Stroke.Color = CH_V2.Colors.NeonPurple; Stroke.Thickness = 2
    local T = Instance.new("TextLabel", KeyFrame); T.Size = UDim2.new(1,0,0,40); T.Text = "CHRIS-HUB KEY"; T.TextColor3 = CH_V2.Colors.NeonPurple; T.BackgroundTransparency = 1; T.Font = Enum.Font.GothamBold; T.TextSize = 18
    local Input = Instance.new("TextBox", KeyFrame); Input.Size = UDim2.new(0.8,0,0,35); Input.Position = UDim2.new(0.1,0,0.35,0); Input.PlaceholderText = "Pegar Key..."; Input.BackgroundColor3 = Color3.fromRGB(20, 10, 40); Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)
    local B = Instance.new("TextButton", KeyFrame); B.Size = UDim2.new(0.8,0,0,35); B.Position = UDim2.new(0.1,0,0.7,0); B.Text = "LOGIN"; B.BackgroundColor3 = CH_V2.Colors.NeonPurple; B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for _,k in pairs(CH_V2.Keys) do if Input.Text == k then KeyFrame:Destroy(); ShowMain() return end end
        B.Text = "KEY INCORRECTA"; task.wait(0.8); B.Text = "LOGIN"
    end)
end

function ShowMain()
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 360, 0, 250); Main.Position = UDim2.new(0.5, -180, 0.5, -125); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", Main);
    local Stroke = Instance.new("UIStroke", Main); Stroke.Color = CH_V2.Colors.NeonPurple; Stroke.Thickness = 1.2; MakeDraggable(Main)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 100, 1, -40); Sidebar.Position = UDim2.new(0, 5, 0, 35); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0,4)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -115, 1, -40); Content.Position = UDim2.new(0, 110, 0, 35); Content.BackgroundTransparency = 1

    local Floating = Instance.new("TextButton", ScreenGui); Floating.Size = UDim2.new(0,50,0,50); Floating.Position = UDim2.new(0,20,0.5,-25); Floating.BackgroundColor3 = CH_V2.Colors.NeonPurple; Floating.Text = "CH-HUB"; Floating.TextColor3 = Color3.new(1,1,1); Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0); MakeDraggable(Floating)

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1
    Close.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, 0, 0, 30); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 20, 30); B.TextColor3 = Color3.new(0.6,0.6,0.6); B.Font = Enum.Font.Gotham; B.TextSize = 11; Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", Content); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0; Instance.new("UIListLayout", P).Padding = UDim.new(0, 6)
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
            for _, btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.new(0.6,0.6,0.6); btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30) end end
            B.TextColor3 = Color3.new(1,1,1); B.BackgroundColor3 = CH_V2.Colors.NeonPurple
        end)
        Pages[name] = P; return P
    end

    local function AddToggle(parent, text, var)
        local T = Instance.new("TextButton", parent); T.Size = UDim2.new(1,-5,0,32); T.Text = "  " .. text; T.BackgroundColor3 = Color3.fromRGB(15, 15, 20); T.TextColor3 = Color3.new(0.7,0.7,0.7); T.TextXAlignment = Enum.TextXAlignment.Left; T.Font = Enum.Font.Gotham; T.TextSize = 11; Instance.new("UICorner", T)
        local Ind = Instance.new("Frame", T); Ind.Size = UDim2.new(0, 4, 0.6, 0); Ind.Position = UDim2.new(1,-8,0.2,0); Ind.BackgroundColor3 = CH_V2.Settings[var] and CH_V2.Colors.NeonPurple or Color3.fromRGB(50,50,50); Instance.new("UICorner", Ind)
        T.MouseButton1Click:Connect(function()
            CH_V2.Settings[var] = not CH_V2.Settings[var]
            Ind.BackgroundColor3 = CH_V2.Settings[var] and CH_V2.Colors.NeonPurple or Color3.fromRGB(50,50,50)
            T.TextColor3 = CH_V2.Settings[var] and Color3.new(1,1,1) or Color3.new(0.7,0.7,0.7)
        end)
    end

    local GeneralP = CreateTab("GENERAL"); local VisualP = CreateTab("VISUAL"); local CombatP = CreateTab("COMBAT")
    
    AddToggle(GeneralP, "NOCLIP", "NOCLIP"); AddToggle(GeneralP, "INF. JUMP", "INFJUMP")
    AddToggle(VisualP, "ESP MURDER", "ESP_M"); AddToggle(VisualP, "ESP SHERIFF", "ESP_S"); AddToggle(VisualP, "LÍNEAS", "TRACES")
    AddToggle(CombatP, "AIMBOT MURDER", "AIMBOT_M"); AddToggle(CombatP, "AUTO-SHOT", "AUTOSHOT")
    AddToggle(CombatP, "KILL AURA (45ST)", "KILLAURA"); AddToggle(CombatP, "TP SHERIFF", "TPSHERIFF")

    local FOVBox = Instance.new("TextBox", CombatP); FOVBox.Size = UDim2.new(1,-5,0,30); FOVBox.Text = "FOV: 120"; FOVBox.BackgroundColor3 = Color3.fromRGB(20,20,30); FOVBox.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", FOVBox)
    FOVBox.FocusLost:Connect(function() local n = tonumber(FOVBox.Text:match("%d+")); if n then CH_V2.Settings.FOV_SIZE = n end; FOVBox.Text = "FOV: "..CH_V2.Settings.FOV_SIZE end)

    Pages["GENERAL"].Visible = true
end

-- [ MOTOR DE FUNCIONES ]
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

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                local hrp = char.HumanoidRootPart
                local role = (char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
                
                -- Visuals
                local active = (role == "Murderer" and CH_V2.Settings.ESP_M) or (role == "Sheriff" and CH_V2.Settings.ESP_S) or (role == "Innocent" and CH_V2.Settings.ESP_I)
                if active then
                    local hl = char:FindFirstChild("CH_Highlight") or Instance.new("Highlight", char); hl.Name = "CH_Highlight"; hl.FillColor = CH_V2.Colors[role]; hl.OutlineTransparency = 0.2
                    if CH_V2.Settings.TRACES then
                        local pos, vis = camera:WorldToViewportPoint(hrp.Position)
                        local line = Tracers[p.Name] or Drawing.new("Line")
                        line.Visible = vis; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = CH_V2.Colors[role]; line.Thickness = 1
                        Tracers[p.Name] = line
                    end
                elseif char:FindFirstChild("CH_Highlight") then char.CH_Highlight:Destroy() end

                -- Aimbot Murder Logic (Inside FOV Only)
                if CH_V2.Settings.AIMBOT_M and role == "Murderer" then
                    local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local mag = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if mag < shortestDist then
                            shortestDist = mag
                            target = p
                        end
                    end
                end

                -- Kill Aura (45 Studs)
                if CH_V2.Settings.KILLAURA and role == "Murderer" then
                    if (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 45 then
                        local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                        if knife then lp.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,2) end
                    end
                end
            end
        end

        -- AutoShot Execution (Improved)
        if CH_V2.Settings.AUTOSHOT and target then
            local gun = lp.Character:FindFirstChild("Gun")
            if gun then
                local shootPos = target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * CH_V2.Settings.PREDICTION)
                local remote = gun:FindFirstChild("SendMessage", true) or gun:FindFirstChild("Shoot", true)
                if remote then remote:FireServer(shootPos) end
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function() if CH_V2.Settings.INFJUMP then pcall(function() lp.Character.Humanoid:ChangeState(3) end) end end)
workspace.ChildRemoved:Connect(function(c) if c.Name == "Map" then for _,l in pairs(Tracers) do l.Visible = false end end end)

ShowKeySystem()
