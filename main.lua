-- [[ ========================================================== ]]
-- [[                   CHRISSHUB V2 - SUPREME FINAL             ]]
-- [[ ========================================================== ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [ DATA CORE ]
local CH_DATA = {
    Toggles = {
        Noclip = false, WalkSpeed = false, InfJump = false,
        KillAura = false, AimbotLegit = false, TPSheriff = false,
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false -- ESP SEPARADO
    }
}

-- [ FUNCIÓN DE ROL ORIGINAL ]
local function GetRole(p)
    if p.Character and p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character and p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- [ MOTOR DE ESP REPARADO ]
local function CreateESP(p)
    local Box = Instance.new("BoxHandleAdornment")
    Box.AlwaysOnTop = true
    Box.ZIndex = 10
    Box.Adornee = nil
    Box.Transparency = 0.5
    Box.Size = Vector3.new(4, 6, 1)
    Box.Parent = CoreGui

    RunService.RenderStepped:Connect(function()
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= lp then
            local role = GetRole(p)
            local visible = false
            
            if role == "Murderer" and CH_DATA.Toggles.ESP_Murd then
                Box.Color3 = Color3.fromRGB(255, 0, 0)
                visible = true
            elseif role == "Sheriff" and CH_DATA.Toggles.ESP_Sheriff then
                Box.Color3 = Color3.fromRGB(0, 0, 255)
                visible = true
            elseif role == "Innocent" and CH_DATA.Toggles.ESP_Inno then
                Box.Color3 = Color3.fromRGB(0, 255, 0)
                visible = true
            end
            
            Box.Visible = visible
            Box.Adornee = visible and p.Character.HumanoidRootPart or nil
        else
            Box.Visible = false
            Box.Adornee = nil
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- [ FUNCIONES DE COMBATE Y MOVIMIENTO ]
RunService.RenderStepped:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    if CH_DATA.Toggles.KillAura and GetRole(lp) == "Murderer" and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 40 then
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
                end
            end
        end
    end

    if CH_DATA.Toggles.AimbotLegit then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local _, vis = camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, p.Character.Head.Position), 0.1)
                    break
                end
            end
        end
    end
    
    if CH_DATA.Toggles.WalkSpeed then lp.Character.Humanoid.WalkSpeed = 50 end
end)

UserInputService.JumpRequest:Connect(function()
    if CH_DATA.Toggles.InfJump and lp.Character then lp.Character.Humanoid:ChangeState(3) end
end)

-- [ INTERFAZ - TU MENÚ INCREÍBLE ]
local function BuildMainUI()
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 420, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 255)
    Instance.new("UICorner", MainFrame)

    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -120, 1, -60); Container.Position = UDim2.new(0, 110, 0, 55); Container.BackgroundTransparency = 1
    
    local TabContainer = Instance.new("Frame", MainFrame)
    TabContainer.Size = UDim2.new(0, 90, 1, -60); TabContainer.Position = UDim2.new(0, 10, 0, 50); TabContainer.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local pages = {}
    local function NewTab(name)
        local p = Instance.new("Frame", Container)
        p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
        Instance.new("UIGridLayout", p).CellSize = UDim2.new(0, 95, 0, 55)
        local b = Instance.new("TextButton", TabContainer)
        b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(pages) do v.Visible = false end
            p.Visible = true
        end)
        pages[name] = p; return p
    end

    local mP = NewTab("MAIN"); mP.Visible = true
    local cP = NewTab("COMBAT")
    local eP = NewTab("ESP")

    local function AddItem(parent, text, tKey)
        local btn = Instance.new("TextButton", parent)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); btn.Text = text; btn.TextColor3 = Color3.new(0.6,0.6,0.6); btn.TextSize = 10
        Instance.new("UICorner", btn); local s = Instance.new("UIStroke", btn); s.Color = Color3.fromRGB(40,40,50)
        btn.MouseButton1Click:Connect(function()
            CH_DATA.Toggles[tKey] = not CH_DATA.Toggles[tKey]
            s.Color = CH_DATA.Toggles[tKey] and Color3.new(0,1,1) or Color3.fromRGB(40,40,50)
            btn.TextColor3 = CH_DATA.Toggles[tKey] and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
        end)
    end

    AddItem(mP, "SPEED", "WalkSpeed"); AddItem(mP, "INF JUMP", "InfJump")
    AddItem(cP, "KILL AURA", "KillAura"); AddItem(cP, "AIMBOT", "AimbotLegit"); AddItem(cP, "TP SHERIFF", "TPSheriff")
    -- EL ESP QUE PEDISTE
    AddItem(eP, "ESP ASESINO", "ESP_Murd")
    AddItem(eP, "ESP SERIFF", "ESP_Sheriff")
    AddItem(eP, "ESP INOCENTE", "ESP_Inno")

    local Circle = Instance.new("TextButton", MainGui)
    Circle.Size = UDim2.new(0, 60, 0, 60); Circle.Position = UDim2.new(0, 20, 0, 20); Circle.Text = "CH-HUB"
    Circle.BackgroundColor3 = Color3.new(0,0,0); Circle.TextColor3 = Color3.new(0,1,1); Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
    Circle.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
end

-- [ FLUJO DE INICIO: INTRO -> KEY ]
local function StartSystem()
    local IntroGui = Instance.new("ScreenGui", CoreGui)
    local T = Instance.new("TextLabel", IntroGui)
    T.Size = UDim2.new(1,0,1,0); T.Text = "CHRISSHUB V2"; T.TextColor3 = Color3.new(0,1,1); T.BackgroundColor3 = Color3.new(0,0,0); T.TextSize = 50
    task.wait(3)
    IntroGui:Destroy()

    -- SISTEMA KEY (Aparece después de la Intro)
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    local F = Instance.new("Frame", KeyGui); F.Size = UDim2.new(0,300,0,200); F.Position = UDim2.new(0.5,-150,0.5,-100); F.BackgroundColor3 = Color3.fromRGB(15,15,20)
    local I = Instance.new("TextBox", F); I.Size = UDim2.new(0.8,0,0,40); I.Position = UDim2.new(0.1,0,0.3,0); I.PlaceholderText = "KEY..."
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.8,0,0,40); B.Position = UDim2.new(0.1,0,0.7,0); B.Text = "VERIFY"; B.BackgroundColor3 = Color3.new(0,0.5,1)
    
    B.MouseButton1Click:Connect(function()
        if I.Text == "CHKEY_8621973540" then -- Ejemplo de una de tus keys
            KeyGui:Destroy()
            BuildMainUI()
        end
    end)
end

StartSystem()
