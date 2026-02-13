--[[
    CHRISSHUB V2 - 20 COLORS & PRO FIX
    -------------------------------------------
    - UI: Azul Neón Futurista (Movible y Compacto)
    - ESP: Murderer, Sheriff, Innocent (Colores Seleccionables)
    - COLORS: 20 Tonos Premium para elegir
    - COMBAT: Aimbot Murder (FOV Azul) + Kill Aura 45st
    - FIX: Limpieza total de Tracers al apagar
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [ CONFIGURACIÓN ]
local CH_V2 = {
    Keys = {"482957", "859326", "295714", "963085", "159372", "628491", "307589", "741963", "518230", "036148"},
    Settings = {
        NOCLIP = false, INFJUMP = false,
        ESP_M = false, ESP_S = false, ESP_I = false, TRACES = false,
        AIMBOT_M = false, FOV_SIZE = 120, AUTOSHOT = true, 
        KILLAURA = false, TPSHERIFF = false, PREDICTION = 0.165
    },
    Colors = { 
        Murderer = Color3.fromRGB(255, 0, 0), 
        Sheriff = Color3.fromRGB(0, 150, 255), 
        Innocent = Color3.fromRGB(0, 255, 100),
        UI_Neon = Color3.fromRGB(0, 220, 255) 
    },
    Palette = {
        {Name = "Rojo Neón", Color = Color3.fromRGB(255, 0, 50)},
        {Name = "Azul Eléctrico", Color = Color3.fromRGB(0, 150, 255)},
        {Name = "Verde Lima", Color = Color3.fromRGB(150, 255, 0)},
        {Name = "Morado Intenso", Color = Color3.fromRGB(180, 0, 255)},
        {Name = "Amarillo Sol", Color = Color3.fromRGB(255, 255, 0)},
        {Name = "Cian Ártico", Color = Color3.fromRGB(0, 255, 255)},
        {Name = "Rosa Chicle", Color = Color3.fromRGB(255, 0, 150)},
        {Name = "Naranja Fuego", Color = Color3.fromRGB(255, 100, 0)},
        {Name = "Blanco Puro", Color = Color3.fromRGB(255, 255, 255)},
        {Name = "Oro", Color = Color3.fromRGB(255, 215, 0)},
        {Name = "Esmeralda", Color = Color3.fromRGB(0, 200, 100)},
        {Name = "Vino", Color = Color3.fromRGB(150, 0, 50)},
        {Name = "Cielo", Color = Color3.fromRGB(135, 206, 235)},
        {Name = "Violeta", Color = Color3.fromRGB(127, 0, 255)},
        {Name = "Turquesa", Color = Color3.fromRGB(64, 224, 208)},
        {Name = "Plata", Color = Color3.fromRGB(192, 192, 192)},
        {Name = "Menta", Color = Color3.fromRGB(170, 255, 195)},
        {Name = "Sangre", Color = Color3.fromRGB(100, 0, 0)},
        {Name = "Lavanda", Color = Color3.fromRGB(230, 190, 255)},
        {Name = "Negro Mate", Color = Color3.fromRGB(20, 20, 20)}
    }
}

-- [ FOV DRAWING ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = CH_V2.Colors.UI_Neon
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- [ LIMPIEZA ]
if CoreGui:FindFirstChild("ChrisHubElite") then CoreGui.ChrisHubElite:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubElite"

-- [ DRAG SYSTEM: COMPACTO ]
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
            local nX = math.clamp(startPos.X.Offset + delta.X, 0, sW - fW)
            local nY = math.clamp(startPos.Y.Offset + delta.Y, 0, sH - fH)
            frame.Position = UDim2.new(0, nX, 0, nY)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

function ShowKeySystem()
    local KeyF = Instance.new("Frame", ScreenGui); KeyF.Size = UDim2.new(0, 280, 0, 160); KeyF.Position = UDim2.new(0.5, -140, 0.5, -80); KeyF.BackgroundColor3 = Color3.fromRGB(5, 5, 15); Instance.new("UICorner", KeyF)
    local S = Instance.new("UIStroke", KeyF); S.Color = CH_V2.Colors.UI_Neon; S.Thickness = 2
    local T = Instance.new("TextLabel", KeyF); T.Size = UDim2.new(1,0,0,40); T.Text = "CHRIS-HUB V2 KEY"; T.TextColor3 = CH_V2.Colors.UI_Neon; T.BackgroundTransparency = 1; T.Font = Enum.Font.GothamBold; T.TextSize = 16
    local I = Instance.new("TextBox", KeyF); I.Size = UDim2.new(0.8,0,0,35); I.Position = UDim2.new(0.1,0,0.35,0); I.PlaceholderText = "Paste Key..."; I.BackgroundColor3 = Color3.fromRGB(15, 15, 30); I.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", I)
    local B = Instance.new("TextButton", KeyF); B.Size = UDim2.new(0.8,0,0,35); B.Position = UDim2.new(0.1,0,0.7,0); B.Text = "LOGIN"; B.BackgroundColor3 = CH_V2.Colors.UI_Neon; B.TextColor3 = Color3.new(0,0,0); B.Font = Enum.Font.GothamBold; Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function() for _,k in pairs(CH_V2.Keys) do if I.Text == k then KeyF:Destroy(); ShowMain() return end end; B.Text = "ERROR"; task.wait(1); B.Text = "LOGIN" end)
end

function ShowMain()
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 360, 0, 240); Main.Position = UDim2.new(0.5, -180, 0.5, -120); Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12); Instance.new("UICorner", Main);
    local S = Instance.new("UIStroke", Main); S.Color = CH_V2.Colors.UI_Neon; S.Thickness = 1.2; MakeDraggable(Main)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 100, 1, -40); Sidebar.Position = UDim2.new(0, 8, 0, 35); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0,4)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -125, 1, -40); Content.Position = UDim2.new(0, 115, 0, 35); Content.BackgroundTransparency = 1

    local Floating = Instance.new("TextButton", ScreenGui); Floating.Size = UDim2.new(0,50,0,50); Floating.Position = UDim2.new(0,20,0.5,-25); Floating.BackgroundColor3 = CH_V2.Colors.UI_Neon; Floating.Text = "CH"; Floating.TextColor3 = Color3.new(0,0,0); Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0); MakeDraggable(Floating)
    
    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,25,0,25); Close.Position = UDim2.new(1,-30,0,5); Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255,50,50); Close.BackgroundTransparency = 1; Close.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, 0, 0, 28); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(15, 15, 25); B.TextColor3 = Color3.new(0.7,0.7,0.7); B.Font = Enum.Font.Gotham; B.TextSize = 10; Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", Content); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0; Instance.new("UIListLayout", P).Padding = UDim.new(0, 5)
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
            for _, btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(15, 15, 25); btn.TextColor3 = Color3.new(0.7,0.7,0.7) end end
            B.BackgroundColor3 = CH_V2.Colors.UI_Neon; B.TextColor3 = Color3.new(0,0,0)
        end)
        Pages[name] = P; return P
    end

    local function AddToggle(parent, text, var)
        local T = Instance.new("TextButton", parent); T.Size = UDim2.new(1,-5,0,30); T.Text = "  " .. text; T.BackgroundColor3 = Color3.fromRGB(12, 12, 18); T.TextColor3 = Color3.new(0.8,0.8,0.8); T.TextXAlignment = Enum.TextXAlignment.Left; T.Font = Enum.Font.Gotham; T.TextSize = 10; Instance.new("UICorner", T)
        local Ind = Instance.new("Frame", T); Ind.Size = UDim2.new(0, 3, 0.6, 0); Ind.Position = UDim2.new(1,-6,0.2,0); Ind.BackgroundColor3 = CH_V2.Settings[var] and CH_V2.Colors.UI_Neon or Color3.fromRGB(60,60,60); Instance.new("UICorner", Ind)
        T.MouseButton1Click:Connect(function() CH_V2.Settings[var] = not CH_V2.Settings[var]; Ind.BackgroundColor3 = CH_V2.Settings[var] and CH_V2.Colors.UI_Neon or Color3.fromRGB(60,60,60) end)
    end

    local GenP = CreateTab("GENERAL"); local VisP = CreateTab("VISUAL"); local ComP = CreateTab("COMBAT"); local ColP = CreateTab("COLORES")
    
    AddToggle(GenP, "NOCLIP", "NOCLIP"); AddToggle(GenP, "SALTO INF.", "INFJUMP")
    AddToggle(VisP, "ESP ASESINO", "ESP_M"); AddToggle(VisP, "ESP SHERIFF", "ESP_S"); AddToggle(VisP, "ESP INOCENTE", "ESP_I"); AddToggle(VisP, "LÍNEAS", "TRACES")
    AddToggle(ComP, "AIMBOT MURDER", "AIMBOT_M"); AddToggle(ComP, "AUTO-SHOT", "AUTOSHOT"); AddToggle(ComP, "KILL AURA (45ST)", "KILLAURA"); AddToggle(ComP, "TP SHERIFF", "TPSHERIFF")

    -- SECCIÓN DE 20 COLORES
    local SelectedRole = "Innocent"
    local RoleLabel = Instance.new("TextLabel", ColP); RoleLabel.Size = UDim2.new(1,0,0,25); RoleLabel.Text = "EDITANDO: INOCENTE"; RoleLabel.TextColor3 = Color3.new(1,1,1); RoleLabel.BackgroundTransparency = 1; RoleLabel.Font = Enum.Font.GothamBold; RoleLabel.TextSize = 10
    
    local RoleSel = Instance.new("TextButton", ColP); RoleSel.Size = UDim2.new(1,-5,0,25); RoleSel.Text = "CAMBIAR ROL A EDITAR"; RoleSel.BackgroundColor3 = Color3.fromRGB(30,30,45); RoleSel.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", RoleSel)
    RoleSel.MouseButton1Click:Connect(function()
        if SelectedRole == "Innocent" then SelectedRole = "Murderer"
        elseif SelectedRole == "Murderer" then SelectedRole = "Sheriff"
        else SelectedRole = "Innocent" end
        RoleLabel.Text = "EDITANDO: " .. SelectedRole:upper()
    end)

    local Grid = Instance.new("Frame", ColP); Grid.Size = UDim2.new(1,0,0,150); Grid.BackgroundTransparency = 1; local G = Instance.new("UIGridLayout", Grid); G.CellSize = UDim2.new(0, 42, 0, 25); G.Padding = UDim2.new(0,5,0,5)
    
    for _, item in pairs(CH_V2.Palette) do
        local cbtn = Instance.new("TextButton", Grid); cbtn.Text = ""; cbtn.BackgroundColor3 = item.Color; Instance.new("UICorner", cbtn)
        cbtn.MouseButton1Click:Connect(function() CH_V2.Colors[SelectedRole] = item.Color; RoleLabel.TextColor3 = item.Color end)
    end

    Pages["GENERAL"].Visible = true
end

-- [ MOTOR DE RENDER ]
local Tracers = {}
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
        FOVCircle.Visible = CH_V2.Settings.AIMBOT_M
        FOVCircle.Radius = CH_V2.Settings.FOV_SIZE
        FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

        local target = nil; local dist = CH_V2.Settings.FOV_SIZE; local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character; local hrp = char.HumanoidRootPart
                local role = (char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
                
                local act = (role == "Murderer" and CH_V2.Settings.ESP_M) or (role == "Sheriff" and CH_V2.Settings.ESP_S) or (role == "Innocent" and CH_V2.Settings.ESP_I)
                
                local hl = char:FindFirstChild("CH_HL")
                if act then
                    if not hl then hl = Instance.new("Highlight", char); hl.Name = "CH_HL" end
                    hl.FillColor = CH_V2.Colors[role]; hl.OutlineTransparency = 0
                    if CH_V2.Settings.TRACES then
                        local pos, vis = camera:WorldToViewportPoint(hrp.Position)
                        local line = Tracers[p.Name] or Drawing.new("Line")
                        line.Visible = vis; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = CH_V2.Colors[role]; line.Thickness = 1
                        Tracers[p.Name] = line
                    else if Tracers[p.Name] then Tracers[p.Name].Visible = false end end
                else
                    if hl then hl:Destroy() end
                    if Tracers[p.Name] then Tracers[p.Name].Visible = false end
                end

                if CH_V2.Settings.KILLAURA and role == "Murderer" and (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 45 then
                    local k = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                    if k then lp.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,2) end
                end

                if CH_V2.Settings.AIMBOT_M and role == "Murderer" then
                    local sP, onS = camera:WorldToViewportPoint(hrp.Position)
                    if onS then
                        local m = (Vector2.new(sP.X, sP.Y) - center).Magnitude
                        if m < dist then dist = m; target = p end
                    end
                end
            elseif Tracers[p.Name] then Tracers[p.Name].Visible = false end
        end

        if target and CH_V2.Settings.AUTOSHOT then
            local g = lp.Character:FindFirstChild("Gun"); if g then pcall(function() g.SendMessage:FireServer(target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * CH_V2.Settings.PREDICTION)) end) end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function() if CH_V2.Settings.INFJUMP then lp.Character.Humanoid:ChangeState(3) end end)
ShowKeySystem()
