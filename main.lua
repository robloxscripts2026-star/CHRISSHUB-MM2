--[[
    CHRISSHUB V1 - OFFICIAL RELEASE
    -------------------------------------------
    - Intro: Green Neon "CHRISSHUB V1"
    - UI: Xhub Style (Main, ESP, Combat)
    - Logic: Silent Aim (30x30x30), Auto-Role ESP, Kill Aura
    - TikTok: @sasware32
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

-- [ DATA MAESTRA ]
local CH_DATA = {
    Keys = {"123456", "654321", "112233", "445566", "121212", "343434", "135790", "246801", "987654", "019283"},
    Toggles = {
        Noclip = false, InfJump = false, AntiAFK = false,
        ESP_M = true, ESP_S = true, ESP_I = true,
        AimbotLegit = false, AimbotMurder = false,
        SilentAim = false, KillAura = false
    },
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 100, 255),
        Innocent = Color3.fromRGB(0, 255, 100)
    },
    ColorOptions = {
        "Rojo", "Naranja", "Amarillo", "Verde", "Azul", "Violeta", "Rosa", "Marrón", "Negro", "Blanco", "Gris", "Cian", "Magenta", "Turquesa", "Dorado"
    },
    ColorMap = {
        ["Rojo"] = Color3.fromRGB(255, 0, 0), ["Naranja"] = Color3.fromRGB(255, 127, 0),
        ["Amarillo"] = Color3.fromRGB(255, 255, 0), ["Verde"] = Color3.fromRGB(0, 255, 0),
        ["Azul"] = Color3.fromRGB(0, 0, 255), ["Violeta"] = Color3.fromRGB(127, 0, 255),
        ["Rosa"] = Color3.fromRGB(255, 105, 180), ["Marrón"] = Color3.fromRGB(139, 69, 19),
        ["Negro"] = Color3.fromRGB(0,0,0), ["Blanco"] = Color3.fromRGB(255,255,255),
        ["Gris"] = Color3.fromRGB(128,128,128), ["Cian"] = Color3.fromRGB(0,255,255),
        ["Magenta"] = Color3.fromRGB(255,0,255), ["Turquesa"] = Color3.fromRGB(64,224,208),
        ["Dorado"] = Color3.fromRGB(255,215,0)
    }
}

-- [ UTILIDADES ]
if CoreGui:FindFirstChild("ChrisHubV1") then CoreGui.ChrisHubV1:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisHubV1"

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ INTRO ]
local function RunIntro()
    local Intro = Instance.new("TextLabel", ScreenGui)
    Intro.Size = UDim2.new(1, 0, 1, 0); Intro.BackgroundTransparency = 1
    Intro.Text = "CHRISSHUB V1"; Intro.TextColor3 = Color3.fromRGB(0, 255, 100)
    Intro.Font = "GothamBlack"; Intro.TextSize = 80; Intro.TextTransparency = 1
    
    TweenService:Create(Intro, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(2.5)
    TweenService:Create(Intro, TweenInfo.new(1), {TextTransparency = 1, TextSize = 120}):Play()
    task.wait(1); Intro:Destroy(); ShowKeySystem()
end

-- [ SISTEMA DE LLAVES ]
function ShowKeySystem()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 300, 0, 180); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", KeyFrame)
    Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(0, 255, 100)
    
    local Label = Instance.new("TextLabel", KeyFrame)
    Label.Size = UDim2.new(1, 0, 0, 40); Label.Text = "Enter license"; Label.TextColor3 = Color3.new(1,1,1); Label.BackgroundTransparency = 1; Label.Font = "GothamBold"
    
    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0.8, 0, 0, 35); Input.Position = UDim2.new(0.1, 0, 0.35, 0); Input.PlaceholderText = "Key here..."; Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Input.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Input)
    
    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0.8, 0, 0, 35); Verify.Position = UDim2.new(0.1, 0, 0.7, 0); Verify.Text = "Verify"; Verify.BackgroundColor3 = Color3.fromRGB(0, 255, 100); Instance.new("UICorner", Verify)
    
    Verify.MouseButton1Click:Connect(function()
        local found = false
        for _, k in pairs(CH_DATA.Keys) do if Input.Text == k then found = true end end
        
        if found then
            Verify.Text = "Verifying key..."; task.wait(5)
            KeyFrame:Destroy(); ShowMain()
        else
            Verify.Text = "Invalid Key"; task.wait(1.5); Verify.Text = "Verify"
        end
    end)
end

-- [ PANEL PRINCIPAL ]
function ShowMain()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 450, 0, 300); Main.Position = UDim2.new(0.5, -225, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", Main)
    local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 255, 100); Stroke.Thickness = 2
    MakeDraggable(Main)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 120, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sidebar)
    
    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -40); TabContainer.Position = UDim2.new(0, 0, 0, 10); TabContainer.BackgroundTransparency = 1
    local L = Instance.new("UIListLayout", TabContainer); L.Padding = UDim.new(0, 5); L.HorizontalAlignment = "Center"

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -135, 1, -40); PageContainer.Position = UDim2.new(0, 125, 0, 10); PageContainer.BackgroundTransparency = 1

    local Pages = {}
    local function CreateTab(name)
        local B = Instance.new("TextButton", TabContainer); B.Size = UDim2.new(0.9, 0, 0, 35); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(25, 25, 25); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        local P = Instance.new("ScrollingFrame", PageContainer); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 2
        Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
        
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end
            P.Visible = true
        end)
        Pages[name] = P
        return P
    end

    local MainP = CreateTab("MAIN")
    local EspP = CreateTab("ESP")
    local CombatP = CreateTab("COMBAT")

    -- COMPONENTES
    local function AddToggle(parent, text, var)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 40); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", F)
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(0.7, 0, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.Text = text; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
        local T = Instance.new("TextButton", F); T.Size = UDim2.new(0, 40, 0, 20); T.Position = UDim2.new(1, -50, 0.5, -10); T.Text = ""; T.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", T).CornerRadius = UDim.new(1,0)
        T.MouseButton1Click:Connect(function()
            CH_DATA.Toggles[var] = not CH_DATA.Toggles[var]
            T.BackgroundColor3 = CH_DATA.Toggles[var] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(40, 40, 40)
        end)
    end

    local function AddColorBar(parent, text, role)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 60); F.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", F)
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 25); L.Text = text; L.TextColor3 = Color3.new(0.7,0.7,0.7); L.BackgroundTransparency = 1; L.Font = "Gotham"
        local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.9, 0, 0, 25); B.Position = UDim2.new(0.05, 0, 0.5, 0); B.BackgroundColor3 = CH_DATA.Colors[role]; B.Text = "Siguiente Color"; B.TextColor3 = Color3.new(0,0,0); Instance.new("UICorner", B)
        local index = 1
        B.MouseButton1Click:Connect(function()
            index = (index % #CH_DATA.ColorOptions) + 1
            local cName = CH_DATA.ColorOptions[index]
            CH_DATA.Colors[role] = CH_DATA.ColorMap[cName]
            B.BackgroundColor3 = CH_DATA.Colors[role]; B.Text = cName
        end)
    end

    -- CONTENIDO
    AddToggle(MainP, "Noclip", "Noclip")
    AddToggle(MainP, "Infinity Jump", "InfJump")
    AddToggle(MainP, "Anti AFK", "AntiAFK")
    local TikTok = Instance.new("TextLabel", MainP); TikTok.Size = UDim2.new(1, 0, 0, 30); TikTok.Text = "SÍGUEME EN TIKTOK @sasware32"; TikTok.TextColor3 = Color3.new(0.5,0.5,0.5); TikTok.BackgroundTransparency = 1; TikTok.TextSize = 12

    AddToggle(EspP, "ESP Murderer", "ESP_M")
    AddColorBar(EspP, "Color ESP Asesino", "Murderer")
    AddToggle(EspP, "ESP Sheriff", "ESP_S")
    AddColorBar(EspP, "Color ESP Sheriff", "Sheriff")
    AddToggle(EspP, "ESP Innocent", "ESP_I")

    AddToggle(CombatP, "Aimbot Legit", "AimbotLegit")
    AddToggle(CombatP, "Aimbot Murder", "AimbotMurder")
    AddToggle(CombatP, "Silent Aim", "SilentAim")
    AddToggle(CombatP, "Kill Aura", "KillAura")
    
    local TPBtn = Instance.new("TextButton", CombatP); TPBtn.Size = UDim2.new(1, 0, 0, 40); TPBtn.Text = "TP SHERIFF"; TPBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255); TPBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", TPBtn)
    TPBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and (p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")) then
                lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            end
        end
    end)

    -- CERRAR Y BOTÓN FLOTANTE
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0, 5)
    CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,0,0); CloseBtn.TextSize = 25; CloseBtn.BackgroundTransparency = 1
    
    local Floating = Instance.new("TextButton", ScreenGui)
    Floating.Size = UDim2.new(0, 70, 0, 70); Floating.Position = UDim2.new(0.1, 0, 0.1, 0)
    Floating.BackgroundColor3 = Color3.new(0,0,0); Floating.Text = "CH-HUB"; Floating.TextColor3 = Color3.fromRGB(0,255,100); Floating.Visible = false
    Instance.new("UICorner", Floating).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Floating).Color = Color3.fromRGB(0,255,100)
    MakeDraggable(Floating)

    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; Floating.Visible = true end)
    Floating.MouseButton1Click:Connect(function() Main.Visible = true; Floating.Visible = false end)

    Pages["MAIN"].Visible = true
end

-- [ LÓGICA DE JUEGO ]
local function GetRole(p)
    if p.Character and p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character and p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

RunService.RenderStepped:Connect(function()
    if not lp.Character then return end

    -- Noclip
    if CH_DATA.Toggles.Noclip then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- ESP & Silent Aim Hitbox
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p)
            local char = p.Character
            
            -- ESP
            local hl = char:FindFirstChild("ChrisESP")
            local active = (role == "Murderer" and CH_DATA.Toggles.ESP_M) or (role == "Sheriff" and CH_DATA.Toggles.ESP_S) or (role == "Innocent" and CH_DATA.Toggles.ESP_I)
            
            if active then
                if not hl then hl = Instance.new("Highlight", char); hl.Name = "ChrisESP" end
                hl.FillColor = CH_DATA.Colors[role]
            elseif hl then hl:Destroy() end

            -- Silent Aim Hitbox (30x30x30)
            if CH_DATA.Toggles.SilentAim then
                char.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                char.HumanoidRootPart.Transparency = 0.8
            else
                char.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                char.HumanoidRootPart.Transparency = 1
            end
        end
    end

    -- Kill Aura
    if CH_DATA.Toggles.KillAura and GetRole(lp) == "Murderer" and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 40 then
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
                end
            end
        end
    end

    -- Aimbots
    local aimTarget = nil
    if CH_DATA.Toggles.AimbotLegit or CH_DATA.Toggles.AimbotMurder then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local role = GetRole(p)
                if CH_DATA.Toggles.AimbotMurder and role ~= "Murderer" then continue end
                
                local pos, vis = camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    if CH_DATA.Toggles.AimbotLegit then
                        local ray = Ray.new(camera.CFrame.Position, (p.Character.Head.Position - camera.CFrame.Position).unit * 500)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character})
                        if hit and hit:IsDescendantOf(p.Character) then aimTarget = p.Character.Head end
                    else
                        aimTarget = p.Character.Head
                    end
                end
            end
        end
    end
    if aimTarget then camera.CFrame = CFrame.new(camera.CFrame.Position, aimTarget.Position) end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if CH_DATA.Toggles.InfJump and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

-- Anti AFK
lp.Idled:Connect(function() if CH_DATA.Toggles.AntiAFK then game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end end)

RunIntro()
