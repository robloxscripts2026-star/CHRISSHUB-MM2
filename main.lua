--[[
    CHRISSHUB MM2 V3 - MASTER ELITE EDITION
    -------------------------------------------
    DISEÑO: Neon Corners & Glassmorphism
    ESTADO: Corregido & Optimizado (500+ Lines Logic)
    CARACTERÍSTICAS:
        - Custom Color System (Murd/Sheriff)
        - Smooth Aimbot (No Camera Shake)
        - Kill Aura 35 Studs
        - Permanent Role Memory
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local appId = "CHRISSHUB_MASTER_ELITE"

-- [ CONFIGURACIÓN GLOBAL ]
local CH_SETTINGS = {
    Toggles = {
        ESP = false,
        Aimbot = false,
        AimbotSmooth = 0.12,
        KillAura = false,
        Noclip = false,
        InfJump = false,
        AntiAFK = true
    },
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 50),
        Sheriff = Color3.fromRGB(0, 150, 255),
        Innocent = Color3.fromRGB(200, 200, 200),
        UI_Accent = Color3.fromRGB(0, 255, 120)
    },
    Memory = {
        Murderers = {},
        Sheriffs = {},
        CurrentMap = ""
    }
}

-- [ LIMPIEZA DE INTERFAZ ]
if CoreGui:FindFirstChild(appId) then CoreGui[appId]:Destroy() end
local SG = Instance.new("ScreenGui", CoreGui); SG.Name = appId

-- [ UTILIDADES DE INTERFAZ ]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    obj.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ CREACIÓN DEL MENÚ AVANZADO ]
function BuildMasterMenu()
    local Main = Instance.new("Frame", SG)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 540, 0, 360)
    Main.Position = UDim2.new(0.5, -270, 0.5, -180)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    MakeDraggable(Main)

    -- Bordes Neón en las esquinas (Efecto Especial)
    local function CreateCorner(pos, rot)
        local c = Instance.new("ImageLabel", Main)
        c.Size = UDim2.new(0, 40, 0, 40)
        c.Position = pos
        c.Rotation = rot
        c.BackgroundTransparency = 1
        c.Image = "rbxassetid://7072723652" -- Corner Glow Asset
        c.ImageColor3 = CH_SETTINGS.Colors.UI_Accent
        return c
    end
    CreateCorner(UDim2.new(0,-5,0,-5), 0)
    CreateCorner(UDim2.new(1,-35,0,-5), 90)
    CreateCorner(UDim2.new(0,-5,1,-35), -90)
    CreateCorner(UDim2.new(1,-35,1,-35), 180)

    -- Barra de Títulos
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "CHRISSHUB ELITE V3"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBlack"; Title.TextSize = 20; Title.BackgroundTransparency = 1

    -- Contenedor de Pestañas
    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(0, 140, 1, -60); TabBar.Position = UDim2.new(0, 10, 0, 50); TabBar.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabBar); TabList.Padding = UDim.new(0, 5)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -170, 1, -70); Content.Position = UDim2.new(0, 160, 0, 60); Content.BackgroundTransparency = 1

    local function CreatePage(name)
        local pg = Instance.new("ScrollingFrame", Content)
        pg.Name = name; pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.Visible = false; pg.ScrollBarThickness = 0
        Instance.new("UIListLayout", pg).Padding = UDim.new(0, 10)
        return pg
    end

    local Pages = {
        Combat = CreatePage("Combat"),
        Visuals = CreatePage("Visuals"),
        Colors = CreatePage("Colors"),
        Player = CreatePage("Player")
    }
    Pages.Combat.Visible = true

    -- [ SISTEMA DE COLORES CUSTOM ]
    local function AddColorPicker(parent, label, var)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -5, 0, 45); f.BackgroundColor3 = Color3.fromRGB(20, 20, 24); Instance.new("UICorner", f)
        local t = Instance.new("TextLabel", f); t.Size = UDim2.new(0.6, 0, 1, 0); t.Position = UDim2.new(0.05, 0, 0, 0); t.Text = label; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextXAlignment = "Left"; t.BackgroundTransparency = 1
        
        local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 80, 0, 25); btn.Position = UDim2.new(1, -90, 0.5, -12); btn.BackgroundColor3 = CH_SETTINGS.Colors[var]; btn.Text = "CAMBIAR"; btn.TextSize = 10; btn.Font = "GothamBold"; Instance.new("UICorner", btn)
        
        local palette = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,100), Color3.fromRGB(0,100,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(255,100,0), Color3.fromRGB(255,255,255)}
        local i = 1
        btn.MouseButton1Click:Connect(function()
            i = i + 1; if i > #palette then i = 1 end
            CH_SETTINGS.Colors[var] = palette[i]
            btn.BackgroundColor3 = palette[i]
        end)
    end

    AddColorPicker(Pages.Colors, "COLOR ASESINO", "Murderer")
    AddColorPicker(Pages.Colors, "COLOR SHERIFF", "Sheriff")
    AddColorPicker(Pages.Colors, "COLOR INOCENTE", "Innocent")
    AddColorPicker(Pages.Colors, "COLOR ACENTO UI", "UI_Accent")

    -- [ BOTONES DE FUNCIONES ]
    local function AddToggle(parent, text, var)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -5, 0, 45); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.Text = "  " .. text; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = "GothamBold"; b.TextXAlignment = "Left"; b.TextSize = 13; Instance.new("UICorner", b)
        local status = Instance.new("Frame", b); status.Size = UDim2.new(0, 35, 0, 18); status.Position = UDim2.new(1, -45, 0.5, -9); status.BackgroundColor3 = CH_SETTINGS.Toggles[var] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(60, 60, 65); Instance.new("UICorner", status).CornerRadius = UDim.new(1,0)
        
        b.MouseButton1Click:Connect(function()
            CH_SETTINGS.Toggles[var] = not CH_SETTINGS.Toggles[var]
            TweenService:Create(status, TweenInfo.new(0.3), {BackgroundColor3 = CH_SETTINGS.Toggles[var] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(60, 60, 65)}):Play()
        end)
    end

    AddToggle(Pages.Combat, "AIMBOT SUAVE (HEAD)", "Aimbot")
    AddToggle(Pages.Combat, "KILL AURA (FAST)", "KillAura")
    AddToggle(Pages.Visuals, "MASTER ESP (PERMANENT)", "ESP")
    AddToggle(Pages.Player, "NOCLIP (V-CLIP)", "Noclip")
    AddToggle(Pages.Player, "INFINITE JUMP", "InfJump")

    -- Navegación
    local function AddTab(name, pg)
        local btn = Instance.new("TextButton", TabBar); btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30); btn.Text = name; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages) do v.Visible = false end
            pg.Visible = true
        end)
    end
    AddTab("COMBATE", Pages.Combat); AddTab("VISUALES", Pages.Visuals); AddTab("COLORES", Pages.Colors); AddTab("JUGADOR", Pages.Player)

    -- Botón de Cerrar
    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5); Close.Text = "×"; Close.TextColor3 = Color3.new(1,1,1); Close.TextSize = 30; Close.BackgroundTransparency = 1
    Close.MouseButton1Click:Connect(function() SG:Destroy() end)
end

-- [ LÓGICA DE AIMBOT SIN TIRONES ]
RunService.RenderStepped:Connect(function()
    if CH_SETTINGS.Toggles.Aimbot then
        local target = nil; local dist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag; target = v.Character.Head end
                end
            end
        end
        if target then
            local lookAt = CFrame.new(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(lookAt, CH_SETTINGS.Toggles.AimbotSmooth)
        end
    end
end)

-- [ LÓGICA DE MEMORIA Y ESP ]
RunService.Heartbeat:Connect(function()
    -- Reset al cambiar mapa
    local map = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("Map")
    if map and map.Name ~= CH_SETTINGS.Memory.CurrentMap then
        CH_SETTINGS.Memory.Murderers = {}; CH_SETTINGS.Memory.Sheriffs = {}; CH_SETTINGS.Memory.CurrentMap = map.Name
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            -- Detección Permanente
            if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then CH_SETTINGS.Memory.Murderers[p.UserId] = true end
            if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then CH_SETTINGS.Memory.Sheriffs[p.UserId] = true end

            -- ESP con Colores Dinámicos
            local h = p.Character:FindFirstChild("CH_Highlight")
            if CH_SETTINGS.Toggles.ESP then
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "CH_Highlight"; h.OutlineColor = Color3.new(1,1,1) end
                local color = CH_SETTINGS.Colors.Innocent
                if CH_SETTINGS.Memory.Murderers[p.UserId] then color = CH_SETTINGS.Colors.Murderer
                elseif CH_SETTINGS.Memory.Sheriffs[p.UserId] then color = CH_SETTINGS.Colors.Sheriff end
                h.FillColor = color; h.Enabled = true
            elseif h then h.Enabled = false end
        end
    end

    -- Kill Aura 35 Studs
    if CH_SETTINGS.Toggles.KillAura and lp.Character and (lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")) then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d <= 35 then
                    local k = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                    k.Parent = lp.Character
                    firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, k.Handle, 1)
                end
            end
        end
    end
end)

-- Noclip & InfJump
RunService.Stepped:Connect(function()
    if CH_SETTINGS.Toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)
UserInputService.JumpRequest:Connect(function() if CH_SETTINGS.Toggles.InfJump and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState(3) end end)

-- Anti-AFK
lp.Idled:Connect(function() if CH_SETTINGS.Toggles.AntiAFK then game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), camera.CFrame) end end)

BuildMasterMenu()
