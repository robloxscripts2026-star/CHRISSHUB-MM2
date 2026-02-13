--[[
    CHRISSHUB V2 - ULTIMATE CLEAN
    -------------------------------------------
    - FIXED: Error 'FindFirstChild' en Linea 68
    - FIXED: Limpieza total de errores de CoinContainer
    - FIXED: FOV Transparente (Solo borde)
    - FEATURES: Silent Aim Elite, AutoShot, 20 Colors
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [ DATA & CONFIG ]
local CH_V2 = {
    Keys = {"482957", "859326", "295714", "963085", "159372", "628491", "307589", "741963", "518230", "036148"},
    Settings = {
        NOCLIP = false, INFINITYJUMP = false,
        ESP_ASESINO = false, ESP_SHERIFF = false, ESP_INOCENTE = false, TRACES = false,
        SILENTAIM = false, FOV = 100, AUTOSHOT = true, PREDICTION = 0.165
    },
    Colors = { Murderer = Color3.fromRGB(255,0,0), Sheriff = Color3.fromRGB(0,0,255), Innocent = Color3.fromRGB(0,255,0) },
    ColorList = {
        {Name = "Rojo", Color = Color3.fromRGB(255, 0, 0)}, {Name = "Verde", Color = Color3.fromRGB(0, 255, 0)},
        {Name = "Azul", Color = Color3.fromRGB(0, 0, 255)}, {Name = "Amarillo", Color = Color3.fromRGB(255, 255, 0)},
        {Name = "Cian", Color = Color3.fromRGB(0, 255, 255)}, {Name = "Magenta", Color = Color3.fromRGB(255, 0, 255)},
        {Name = "Blanco", Color = Color3.fromRGB(255, 255, 255)}, {Name = "Negro", Color = Color3.fromRGB(0, 0, 0)},
        {Name = "Gris", Color = Color3.fromRGB(128, 128, 128)}, {Name = "Plata", Color = Color3.fromRGB(192, 192, 192)},
        {Name = "Marrón", Color = Color3.fromRGB(165, 42, 42)}, {Name = "Beige", Color = Color3.fromRGB(245, 245, 220)},
        {Name = "Turquesa", Color = Color3.fromRGB(64, 224, 208)}, {Name = "Lavanda", Color = Color3.fromRGB(230, 230, 250)},
        {Name = "Rosa", Color = Color3.fromRGB(255, 192, 203)}, {Name = "Oro", Color = Color3.fromRGB(255, 215, 0)},
        {Name = "Lima", Color = Color3.fromRGB(0, 255, 0)}, {Name = "Naranja", Color = Color3.fromRGB(255, 165, 0)},
        {Name = "Violeta", Color = Color3.fromRGB(238, 130, 238)}, {Name = "Índigo", Color = Color3.fromRGB(75, 0, 130)}
    }
}

-- [ UI ELEMENTS ]
if CoreGui:FindFirstChild("ChrisHubV2") then CoreGui.ChrisHubV2:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubV2"

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function ShowKeySystem()
    -- Blindaje contra error de nil (Linea 68 Fix)
    if not ScreenGui then return end
    
    local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size = UDim2.new(0, 300, 0, 160); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -80); KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20); Instance.new("UICorner", KeyFrame); local S = Instance.new("UIStroke", KeyFrame); S.Color = Color3.fromRGB(0, 200, 255)
    local Input = Instance.new("TextBox", KeyFrame); Input.Size = UDim2.new(0.8, 0, 0, 35); Input.Position = UDim2.new(0.1, 0, 0.3, 0); Input.PlaceholderText = "Escribe la Key..."; Input.BackgroundColor3 = Color3.fromRGB(20, 20, 35); Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)
    local Verify = Instance.new("TextButton", KeyFrame); Verify.Size = UDim2.new(0.8, 0, 0, 35); Verify.Position = UDim2.new(0.1, 0, 0.65, 0); Verify.Text = "ACCEDER"; Verify.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Verify.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Verify)
    
    Verify.MouseButton1Click:Connect(function()
        local match = false
        for _, k in pairs(CH_V2.Keys) do if Input.Text == k then match = true break end end
        if match then KeyFrame:Destroy(); ShowMain() else Verify.Text = "KEY INCORRECTA"; task.wait(0.5); Verify.Text = "ACCEDER" end
    end)
end

function ShowMain()
    local Main = Instance.new("Frame", ScreenGui); Main.Name = "MainHub"; Main.Size = UDim2.new(0, 420, 0, 340); Main.Position = UDim2.new(0.5, -210, 0.5, -170); Main.BackgroundColor3 = Color3.fromRGB(5, 7, 12); Instance.new("UICorner", Main); local S = Instance.new("UIStroke", Main); S.Color = Color3.fromRGB(0, 150, 255); MakeDraggable(Main)
    
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 110, 1, -20); Sidebar.Position = UDim2.new(0, 5, 0, 10); Sidebar.BackgroundTransparency = 1; Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
    local PageContainer = Instance.new("Frame", Main); PageContainer.Size = UDim2.new(1, -125, 1, -20); PageContainer.Position = UDim2.new(0, 120, 0, 10); PageContainer.BackgroundTransparency = 1

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, 0, 0, 35); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 25, 40); B.TextColor3 = Color3.new(0.7,0.7,0.7); B.TextSize = 14; Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", PageContainer); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0; Instance.new("UIListLayout", P).Padding = UDim.new(0, 6)
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true
            for _, btn in pairs(Sidebar:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.new(0.5,0.5,0.5) end end
            B.TextColor3 = Color3.new(1,1,1)
        end)
        Pages[name] = P; return P
    end

    local MainP = CreateTab("GENERAL"); local VisualP = CreateTab("VISUAL"); local CombatP = CreateTab("COMBATE")

    local function AddToggle(parent, text, var)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1, -10, 0, 35); B.Text = text; B.BackgroundColor3 = Color3.fromRGB(20, 25, 35); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        local Ind = Instance.new("Frame", B); Ind.Size = UDim2.new(0, 5, 1, 0); Ind.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50); Instance.new("UICorner", Ind)
        B.MouseButton1Click:Connect(function()
            CH_V2.Settings[var] = not CH_V2.Settings[var]
            Ind.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
        end)
    end

    local function AddColorPicker(parent, role)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1, -10, 0, 30); B.Text = "COLOR: " .. role; B.BackgroundColor3 = CH_V2.Colors[role]; B.TextColor3 = Color3.new(1,1,1); B.TextSize = 12; Instance.new("UICorner", B)
        local i = 1
        B.MouseButton1Click:Connect(function()
            i = (i % #CH_V2.ColorList) + 1
            CH_V2.Colors[role] = CH_V2.ColorList[i].Color
            B.Text = CH_V2.ColorList[i].Name; B.BackgroundColor3 = CH_V2.Colors[role]
        end)
    end

    AddToggle(MainP, "NOCLIP", "NOCLIP"); AddToggle(MainP, "INF. JUMP", "INFINITYJUMP")
    AddToggle(VisualP, "ESP INOCENTE", "ESP_INOCENTE"); AddColorPicker(VisualP, "Innocent")
    AddToggle(VisualP, "ESP ASESINO", "ESP_ASESINO"); AddColorPicker(VisualP, "Murderer")
    AddToggle(VisualP, "ESP SHERIFF", "ESP_SHERIFF"); AddColorPicker(VisualP, "Sheriff")
    AddToggle(VisualP, "TRACERS", "TRACES")
    AddToggle(CombatP, "SILENTAIM", "SILENTAIM"); AddToggle(CombatP, "AUTOSHOT", "AUTOSHOT")
    
    local FOVIn = Instance.new("TextBox", CombatP); FOVIn.Size = UDim2.new(1,-10,0,35); FOVIn.Text = "FOV: 100"; FOVIn.BackgroundColor3 = Color3.fromRGB(25,30,45); FOVIn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", FOVIn)
    FOVIn.FocusLost:Connect(function() local v = tonumber(FOVIn.Text:match("%d+")); if v then CH_V2.Settings.FOV = v end; FOVIn.Text = "FOV: "..CH_V2.Settings.FOV end)

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1
    local Floating = Instance.new("TextButton", ScreenGui); Floating.Name = "CHHUB_BTN"; Floating.Size = UDim2.new(0,55,0,55); Floating.Position = UDim2.new(0,10,0.5,0); Floating.Text = "CH-HUB"; Floating.BackgroundColor3 = Color3.fromRGB(0,150,255); Floating.Visible = false; Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0); MakeDraggable(Floating)
    
    Close.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)
    Pages["GENERAL"].Visible = true
end

-- [ MAIN ENGINE ]
local Tracers = {}

RunService.RenderStepped:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

    -- FOV Update
    FOVCircle.Visible = CH_V2.Settings.SILENTAIM
    FOVCircle.Radius = CH_V2.Settings.FOV
    FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    if CH_V2.Settings.NOCLIP then for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end

    local target = nil
    local dist = CH_V2.Settings.FOV
    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local role = (char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
            
            -- Visuals (ESP & Tracers)
            local act = (role == "Murderer" and CH_V2.Settings.ESP_ASESINO) or (role == "Sheriff" and CH_V2.Settings.ESP_SHERIFF) or (role == "Innocent" and CH_V2.Settings.ESP_INOCENTE)
            local hl = char:FindFirstChild("ChrisV2")
            if act then
                if not hl then hl = Instance.new("Highlight", char); hl.Name = "ChrisV2" end
                hl.FillColor = CH_V2.Colors[role]; hl.OutlineTransparency = 0
            elseif hl then hl:Destroy() end

            if CH_V2.Settings.TRACES and act then
                local pos, vis = camera:WorldToViewportPoint(hrp.Position)
                local line = Tracers[p.Name] or Drawing.new("Line")
                if vis then
                    line.Visible = true; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y); line.Color = CH_V2.Colors[role]; line.Thickness = 1.5
                else line.Visible = false end
                Tracers[p.Name] = line
            elseif Tracers[p.Name] then Tracers[p.Name].Visible = false end

            -- Silent Aim Logic
            if CH_V2.Settings.SILENTAIM then
                hrp.Size = Vector3.new(35,35,35); hrp.Transparency = 0.85
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local m = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    local weight = (role == "Murderer") and 0.5 or 1
                    if (m * weight) < dist then dist = m * weight; target = p end
                end
            else
                hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1
            end
        end
    end

    -- AutoShot con Predicción (Sin errores de arma)
    if CH_V2.Settings.AUTOSHOT and target and target.Character then
        local gun = lp.Character:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")
        if gun and lp.Character:FindFirstChild("Gun") then
            local shootPos = target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * CH_V2.Settings.PREDICTION)
            local remote = gun:FindFirstChild("SendMessage", true) or gun:FindFirstChild("Shoot", true)
            if remote then pcall(function() remote:FireServer(shootPos) end) end
        end
    end
end)

UserInputService.JumpRequest:Connect(function() if CH_V2.Settings.INFINITYJUMP then pcall(function() lp.Character.Humanoid:ChangeState(3) end) end end)

-- [ INICIO ]
ShowKeySystem()
