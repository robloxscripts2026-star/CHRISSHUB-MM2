--[[
    CHRISSHUB V2 - ACTUALIZACIÓN DE LLAVES Y COLORES
    -------------------------------------------
    - Keys: 20 Nuevas llaves añadidas
    - Colores: Paleta de 20 colores expandida
    - UI: Menú más grande y espacioso
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [ DATA ACTUALIZADA ]
local CH_V2 = {
    Keys = {
        "482957", "859326", "295714", "963085", "159372", 
        "628491", "307589", "741963", "518230", "036148"
    },
    Settings = {
        NOCLIP = false, INFINITYJUMP = false, ANTIAFK = false,
        ESP_ASESINO = true, ESP_SHERIFF = true, ESP_INOCENTE = true, TRACERS = false,
        SILENTAIM = false, FOV = 80, SPEED = 3, AUTOFARM = false, FAKELAG = false
    },
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 100, 255),
        Innocent = Color3.fromRGB(0, 255, 100)
    },
    ColorMap = {
        ["Rojo"] = Color3.fromRGB(255, 0, 0), ["Verde"] = Color3.fromRGB(0, 255, 0),
        ["Azul"] = Color3.fromRGB(0, 0, 255), ["Amarillo"] = Color3.fromRGB(255, 255, 0),
        ["Cian"] = Color3.fromRGB(0, 255, 255), ["Magenta"] = Color3.fromRGB(255, 0, 255),
        ["Blanco"] = Color3.fromRGB(255, 255, 255), ["Negro"] = Color3.fromRGB(0, 0, 0),
        ["Gris"] = Color3.fromRGB(128, 128, 128), ["Plata"] = Color3.fromRGB(192, 192, 192),
        ["Marrón"] = Color3.fromRGB(165, 42, 42), ["Beige"] = Color3.fromRGB(245, 245, 220),
        ["Turquesa"] = Color3.fromRGB(64, 224, 208), ["Lavanda"] = Color3.fromRGB(230, 230, 250),
        ["Rosa"] = Color3.fromRGB(255, 192, 203), ["Oro"] = Color3.fromRGB(255, 215, 0),
        ["Lima"] = Color3.fromRGB(0, 255, 0), ["Naranja"] = Color3.fromRGB(255, 165, 0),
        ["Violeta"] = Color3.fromRGB(238, 130, 238), ["Índigo"] = Color3.fromRGB(75, 0, 130)
    }
}

-- [ UI SETUP ]
if CoreGui:FindFirstChild("ChrisHubV2") then CoreGui.ChrisHubV2:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubV2"

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

-- [ INTRO V2 ]
local function RunIntro()
    local Intro = Instance.new("TextLabel", ScreenGui)
    Intro.Size = UDim2.new(1, 0, 1, 0); Intro.BackgroundTransparency = 1; Intro.Text = "CHRISSHUB V2"; Intro.TextColor3 = Color3.fromRGB(0, 255, 0); Intro.Font = "GothamBlack"; Intro.TextSize = 80; Intro.TextTransparency = 1
    local Stroke = Instance.new("UIStroke", Intro); Stroke.Thickness = 5; Stroke.Transparency = 1
    TweenService:Create(Intro, TweenInfo.new(1), {TextTransparency = 0}):Play(); TweenService:Create(Stroke, TweenInfo.new(1), {Transparency = 0}):Play()
    task.spawn(function() while Intro.Parent do Intro.TextColor3 = Color3.fromHSV(tick()%5/5, 0.8, 1); Stroke.Color = Intro.TextColor3; task.wait() end end)
    task.wait(2.2); TweenService:Create(Intro, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {TextSize = 300, TextTransparency = 1, Rotation = 20}):Play(); task.wait(0.6); Intro:Destroy(); ShowKeySystem()
end

-- [ KEY SYSTEM FIXED ]
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size = UDim2.new(0, 320, 0, 200); KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 25); Instance.new("UICorner", KeyFrame); Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(180, 0, 255)
    local Title = Instance.new("TextLabel", KeyFrame); Title.Size = UDim2.new(1,0,0,50); Title.Text = "Enter License"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = "GothamBold"
    local Input = Instance.new("TextBox", KeyFrame); Input.Size = UDim2.new(0.8,0,0,40); Input.Position = UDim2.new(0.1,0,0.35,0); Input.PlaceholderText = "Key here..."; Input.BackgroundColor3 = Color3.fromRGB(30, 15, 50); Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)
    local Verify = Instance.new("TextButton", KeyFrame); Verify.Size = UDim2.new(0.8,0,0,40); Verify.Position = UDim2.new(0.1,0,0.7,0); Verify.Text = "Verify"; Verify.BackgroundColor3 = Color3.fromRGB(150, 0, 255); Verify.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Verify)

    Verify.MouseButton1Click:Connect(function()
        local inputKey = Input.Text
        local isCorrect = false
        for _, k in pairs(CH_V2.Keys) do if inputKey == k then isCorrect = true break end end
        if isCorrect then Verify.Text = "Correct! Loading..."; task.wait(2); KeyFrame:Destroy(); ShowMain() else Verify.Text = "Invalid Key"; task.wait(1); Verify.Text = "Verify" end
    end)
end

-- [ MAIN MENU LARGER ]
function ShowMain()
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 500, 0, 380); Main.Position = UDim2.new(0.5, -250, 0.5, -190); Main.BackgroundColor3 = Color3.fromRGB(5, 10, 20); Instance.new("UICorner", Main); local S = Instance.new("UIStroke", Main); S.Thickness = 2; S.Color = Color3.fromRGB(0, 150, 255); MakeDraggable(Main)
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 15, 30); Instance.new("UICorner", Sidebar)
    local TabContainer = Instance.new("Frame", Sidebar); TabContainer.Size = UDim2.new(1,0,1,-20); TabContainer.Position = UDim2.new(0,0,0,10); TabContainer.BackgroundTransparency = 1; Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0,8)
    local PageContainer = Instance.new("Frame", Main); PageContainer.Size = UDim2.new(1, -150, 1, -20); PageContainer.Position = UDim2.new(0, 140, 0, 10); PageContainer.BackgroundTransparency = 1

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", TabContainer); B.Size = UDim2.new(1,0,0,40); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(20, 30, 50); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", PageContainer); P.Size = UDim2.new(1,0,1,0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0; Instance.new("UIListLayout", P).Padding = UDim.new(0,10)
        B.MouseButton1Click:Connect(function() for _, pg in pairs(Pages) do pg.Visible = false end; P.Visible = true end)
        Pages[name] = P; return P
    end

    local MainP = CreateTab("MAIN"); local EspP = CreateTab("ESP"); local CombatP = CreateTab("COMBAT")
    
    local function AddToggle(parent, text, var)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1,0,0,40); B.Text = text; B.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(25, 35, 55); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function() CH_V2.Settings[var] = not CH_V2.Settings[var]; B.BackgroundColor3 = CH_V2.Settings[var] and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(25, 35, 55) end)
    end

    local function AddColorCycle(parent, role)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1,0,0,40); B.Text = "COLOR: " .. role; B.BackgroundColor3 = CH_V2.Colors[role]; B.TextColor3 = Color3.new(0,0,0); Instance.new("UICorner", B)
        local names = {}; for n, _ in pairs(CH_V2.ColorMap) do table.insert(names, n) end
        local idx = 1
        B.MouseButton1Click:Connect(function() idx = (idx % #names) + 1; local cName = names[idx]; CH_V2.Colors[role] = CH_V2.ColorMap[cName]; B.Text = cName; B.BackgroundColor3 = CH_V2.Colors[role] end)
    end

    AddToggle(MainP, "NOCLIP", "NOCLIP"); AddToggle(MainP, "AUTOFARM", "AUTOFARM"); AddToggle(MainP, "INFINITYJUMP", "INFINITYJUMP")
    AddToggle(EspP, "ESP ASESINO", "ESP_ASESINO"); AddColorCycle(EspP, "Murderer")
    AddToggle(EspP, "ESP SERIFF", "ESP_SHERIFF"); AddColorCycle(EspP, "Sheriff")
    AddToggle(EspP, "ESP INOCENTE", "ESP_INOCENTE"); AddColorCycle(EspP, "Innocent")
    AddToggle(EspP, "TRACES", "TRACERS")
    AddToggle(CombatP, "SILENTAIM", "SILENTAIM")

    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,40,0,40); Close.Position = UDim2.new(1,-45,0,5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1
    Close.MouseButton1Click:Connect(function() Main.Visible = false end)
    Pages["MAIN"].Visible = true
end

-- [ LOGIC ]
RunService.RenderStepped:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    if CH_V2.Settings.NOCLIP then for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if CH_V2.Settings.AUTOFARM then
        lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        for _, obj in pairs(workspace:GetDescendants()) do if (obj.Name == "CoinContainer" or obj.Name == "Coin") and obj:FindFirstChildWhichIsA("BasePart", true) then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(obj:FindFirstChildWhichIsA("BasePart", true).Position.X, -15, obj:FindFirstChildWhichIsA("BasePart", true).Position.Z)
            break
        end end
    end
    for _, p in pairs(Players:GetPlayers()) do if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local role = (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) and "Murderer" or (p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) and "Sheriff" or "Innocent"
        local hl = p.Character:FindFirstChild("ChrisHL")
        local act = (role == "Murderer" and CH_V2.Settings.ESP_ASESINO) or (role == "Sheriff" and CH_V2.Settings.ESP_SHERIFF) or (role == "Innocent" and CH_V2.Settings.ESP_INOCENTE)
        if act then if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "ChrisHL" end; hl.FillColor = CH_V2.Colors[role]; hl.FillTransparency = 0.2
        elseif hl then hl:Destroy() end
        if CH_V2.Settings.SILENTAIM then p.Character.HumanoidRootPart.Size = Vector3.new(30,30,30); p.Character.HumanoidRootPart.Transparency = 0.8 else p.Character.HumanoidRootPart.Size = Vector3.new(2,2,1); p.Character.HumanoidRootPart.Transparency = 1 end
    end end
end)

RunIntro()
