--[[
    CHRISSHUB MM2 V3 - THE TITAN UPDATE
    -------------------------------------------
    DEVELOPER: Chris (Elite Edition for Chris)
    ESTILO: Modern Sidebar / Glassmorphism
    DISPOSITIVO: Mobile / Tablet / PC
    TIKTOK: @sasware32
    -------------------------------------------
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local appId = "CHRISSHUB_V3_TITAN"

-- [ BASE DE DATOS Y CONFIG ]
local CH_DATA = {
    Keys = {"482916", "731592", "264831", "917542", "358269", "621973", "845155"},
    TikTok = "sasware32",
    Toggles = {
        ESP = false, Aimbot = false, Legit = false, TargetM = false,
        KillAura = false, Noclip = false, InfJump = false, AntiAFK = true
    },
    ESP_Config = {
        M = {Color = Color3.fromRGB(255, 0, 0), Name = "Rojo"},
        S = {Color = Color3.fromRGB(0, 100, 255), Name = "Azul"},
        I = {Color = Color3.fromRGB(255, 255, 255), Name = "Blanco"}
    },
    ColorLibrary = {
        ["Rojo"] = Color3.fromRGB(255, 0, 0),
        ["Naranja"] = Color3.fromRGB(255, 165, 0),
        ["Amarillo"] = Color3.fromRGB(255, 255, 0),
        ["Verde"] = Color3.fromRGB(0, 255, 100),
        ["Azul"] = Color3.fromRGB(0, 100, 255),
        ["Morado"] = Color3.fromRGB(150, 0, 255),
        ["Negro"] = Color3.fromRGB(0, 0, 0),
        ["Blanco"] = Color3.fromRGB(255, 255, 255),
        ["Rosa"] = Color3.fromRGB(255, 100, 200),
        ["Gris"] = Color3.fromRGB(120, 120, 120)
    },
    ActivePage = "MAIN"
}

-- [ SISTEMA DE UI ]
if CoreGui:FindFirstChild(appId) then CoreGui[appId]:Destroy() end
local SG = Instance.new("ScreenGui", CoreGui); SG.Name = appId

local function Tw(obj, dur, prop, style)
    local t = TweenService:Create(obj, TweenInfo.new(dur, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop)
    t:Play()
    return t
end

local function Ripple(obj)
    task.spawn(function()
        local r = Instance.new("Frame", obj)
        r.BackgroundColor3 = Color3.new(1,1,1); r.BackgroundTransparency = 0.7; r.BorderSizePixel = 0
        r.Size = UDim2.new(0,0,0,0); r.Position = UDim2.new(0.5,0,0.5,0)
        Instance.new("UICorner", r).CornerRadius = UDim.new(1,0)
        Tw(r, 0.4, {Size = UDim2.new(2,0,4,0), Position = UDim2.new(-0.5,0,-1.5,0), BackgroundTransparency = 1})
        Debris:AddItem(r, 0.5)
    end)
end

-- [ INTRO V3 ]
local function StartIntro()
    local F = Instance.new("Frame", SG); F.Size = UDim2.new(1,0,1,0); F.BackgroundTransparency = 1
    
    -- Lluvia Matrix Verde
    task.spawn(function()
        for i = 1, 70 do
            local d = Instance.new("TextLabel", F)
            d.Text = math.random(0,1); d.TextColor3 = Color3.fromRGB(0, 255, 120); d.BackgroundTransparency = 1
            d.Position = UDim2.new(math.random(), 0, -0.1, 0); d.Font = "Code"; d.TextSize = math.random(15,30)
            local dur = math.random(2, 4)
            Tw(d, dur, {Position = UDim2.new(d.Position.X.Scale, 0, 1.1, 0), TextTransparency = 1}, Enum.EasingStyle.Linear)
            Debris:AddItem(d, dur + 0.1); task.wait(0.04)
        end
    end)

    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1,0,0,100); L.Position = UDim2.new(0,0,0.4,0); L.BackgroundTransparency = 1
    L.Text = "CHRISSHUB V3"; L.TextColor3 = Color3.fromRGB(0, 255, 120); L.Font = "GothamBlack"; L.TextSize = 1; L.TextTransparency = 1
    local s = Instance.new("UIStroke", L); s.Thickness = 5; s.Color = Color3.new(1,1,1); s.Transparency = 1

    Tw(L, 1.2, {TextSize = 90, TextTransparency = 0}); Tw(s, 1.2, {Transparency = 0})
    task.wait(2.5)
    Tw(L, 0.8, {TextSize = 200, TextTransparency = 1}); Tw(s, 0.8, {Transparency = 1})
    task.wait(0.8); F:Destroy(); ShowLogin()
end

-- [ LOGIN SYSTEM ]
function ShowLogin()
    local L = Instance.new("Frame", SG); L.Size = UDim2.new(0,340,0,220); L.Position = UDim2.new(0.5,-170,0.5,-110)
    L.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", L); local s = Instance.new("UIStroke", L); s.Color = Color3.fromRGB(0,255,120); s.Thickness = 2
    
    local T = Instance.new("TextLabel", L); T.Size = UDim2.new(1,0,0,50); T.Text = "TITAN SECURITY"; T.TextColor3 = Color3.new(1,1,1); T.Font = "Code"; T.BackgroundTransparency = 1
    local I = Instance.new("TextBox", L); I.Size = UDim2.new(0.85,0,0,45); I.Position = UDim2.new(0.075,0,0.35,0); I.PlaceholderText = "> Ingrese Key V3..."; I.BackgroundColor3 = Color3.new(0,0,0); I.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", I)
    local B = Instance.new("TextButton", L); B.Size = UDim2.new(0.85,0,0,45); B.Position = UDim2.new(0.075,0,0.7,0); B.Text = "VERIFICAR LLAVE"; B.BackgroundColor3 = Color3.fromRGB(0,255,120); B.Font = "GothamBold"; Instance.new("UICorner", B)
    
    B.MouseButton1Click:Connect(function()
        local found = false
        for _,k in pairs(CH_DATA.Keys) do if I.Text == k then found = true break end end
        if found or I.Text == "CHRIS2026" then
            B.Text = "ACCESO CONCEDIDO"; task.wait(0.5); L:Destroy(); BuildMenu()
        else
            B.Text = "LLAVE INVÁLIDA"; B.BackgroundColor3 = Color3.new(1,0,0)
            task.wait(1.5); B.Text = "VERIFICAR LLAVE"; B.BackgroundColor3 = Color3.fromRGB(0,255,120)
        end
    end)
end

-- [ MENÚ TITAN V3 ]
function BuildMenu()
    local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 540, 0, 340); Main.Position = UDim2.new(0.5, -270, 0.5, -170)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", Main)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(0, 255, 120); MainStroke.Thickness = 2

    -- Logo Ninja V3
    local Logo = Instance.new("Frame", Main); Logo.Size = UDim2.new(0, 65, 0, 65); Logo.Position = UDim2.new(0.5, -32.5, 0, -32.5)
    Logo.BackgroundColor3 = Color3.new(0,0,0); Instance.new("UICorner", Logo).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Logo).Color = Color3.fromRGB(180, 0, 255)
    local Icon = Instance.new("ImageLabel", Logo); Icon.Size = UDim2.new(0.8,0,0.8,0); Icon.Position = UDim2.new(0.1,0,0.1,0); Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://6031068833"

    -- Sidebar (Izquierda)
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", Sidebar)
    local TabList = Instance.new("UIListLayout", Sidebar); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = "Center"
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 45)

    -- Scrolling Content
    local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -150, 1, -70); Container.Position = UDim2.new(0, 140, 0, 45)
    Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 0
    local ContentLayout = Instance.new("UIListLayout", Container); ContentLayout.Padding = UDim.new(0, 10)

    -- TikTok Label
    local TT = Instance.new("TextLabel", Main); TT.Size = UDim2.new(0, 200, 0, 20); TT.Position = UDim2.new(0, 140, 1, -25); TT.Text = "TikTok: "..CH_DATA.TikTok; TT.TextColor3 = Color3.fromRGB(150, 150, 150); TT.BackgroundTransparency = 1; TT.TextXAlignment = "Left"; TT.Font = "Code"

    local function ClearPage()
        for _,v in pairs(Container:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end
    end

    local function CreateTab(name, iconId)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 42); b.Text = "  "..name; b.BackgroundColor3 = Color3.new(0,0,0); b.TextColor3 = Color3.new(1,1,1); b.Font = "Code"; b.TextXAlignment = "Left"; Instance.new("UICorner", b)
        local img = Instance.new("ImageLabel", b); img.Size = UDim2.new(0,20,0,20); img.Position = UDim2.new(0.05,0,0.25,0); img.BackgroundTransparency = 1; img.Image = "rbxassetid://"..iconId; b.Text = "      "..name
        
        b.MouseButton1Click:Connect(function()
            Ripple(b); ClearPage(); LoadPage(name)
        end)
    end

    function LoadPage(name)
        if name == "MAIN" then
            local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, -10, 0, 100); f.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", f)
            local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,1,0); l.Text = "CHRISSHUB V3 TITAN\nSTATUS: BYPASS OK\nBIENVENIDO!"; l.TextColor3 = Color3.fromRGB(0,255,120); l.BackgroundTransparency = 1; l.Font = "Code"
        
        elseif name == "ESP" then
            local function ESPSet(title, var)
                local f = Instance.new("Frame", Container); f.Size = UDim2.new(1,-10,0,90); f.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", f)
                local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.5,0,0,30); l.Position = UDim2.new(0.05,0,0,5); l.Text = title; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"; l.Font = "Code"
                
                local toggle = Instance.new("TextButton", f); toggle.Size = UDim2.new(0, 50, 0, 25); toggle.Position = UDim2.new(0.8,0,0.1,0); toggle.Text = ""; toggle.BackgroundColor3 = CH_DATA.Toggles.ESP and Color3.fromRGB(0,255,120) or Color3.new(0.2,0.2,0.2); Instance.new("UICorner", toggle)
                toggle.MouseButton1Click:Connect(function() CH_DATA.Toggles.ESP = not CH_DATA.Toggles.ESP; toggle.BackgroundColor3 = CH_DATA.Toggles.ESP and Color3.fromRGB(0,255,120) or Color3.new(0.2,0.2,0.2) end)
                
                local colorBtn = Instance.new("TextButton", f); colorBtn.Size = UDim2.new(0.9,0,0,30); colorBtn.Position = UDim2.new(0.05,0,0.55,0); colorBtn.Text = "Color Actual: "..CH_DATA.ESP_Config[var].Name; colorBtn.BackgroundColor3 = Color3.new(0,0,0); colorBtn.TextColor3 = CH_DATA.ESP_Config[var].Color; Instance.new("UICorner", colorBtn)
                colorBtn.MouseButton1Click:Connect(function()
                    local options = {}; for k,_ in pairs(CH_DATA.ColorLibrary) do table.insert(options, k) end
                    local current = table.find(options, CH_DATA.ESP_Config[var].Name)
                    local nextIdx = (current % #options) + 1
                    local nextName = options[nextIdx]
                    CH_DATA.ESP_Config[var].Name = nextName
                    CH_DATA.ESP_Config[var].Color = CH_DATA.ColorLibrary[nextName]
                    colorBtn.Text = "Color Actual: "..nextName
                    colorBtn.TextColor3 = CH_DATA.ESP_Config[var].Color
                end)
            end
            ESPSet("ESP MURDERER", "M"); ESPSet("ESP SHERIFF", "S"); ESPSet("ESP INNOCENT", "I")
        
        elseif name == "COMBAT" then
            local function AddToggle(txt, var)
                local b = Instance.new("TextButton", Container); b.Size = UDim2.new(1,-10,0,45); b.Text = txt; b.BackgroundColor3 = CH_DATA.Toggles[var] and Color3.fromRGB(0,255,120) or Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.Font = "Code"
                b.MouseButton1Click:Connect(function() CH_DATA.Toggles[var] = not CH_DATA.Toggles[var]; b.BackgroundColor3 = CH_DATA.Toggles[var] and Color3.fromRGB(0,255,120) or Color3.fromRGB(25,25,25) end)
            end
            AddToggle("AIMBOT MASTER", "Aimbot"); AddToggle("AIMBOT LEGIT", "Legit"); AddToggle("KILL AURA (35 STUDS)", "KillAura")
        end
    end

    CreateTab("MAIN", "6034502925"); CreateTab("ESP", "6034502925"); CreateTab("COMBAT", "6034502925")
    LoadPage("MAIN")

    -- Botones Rápidos y Círculo de Reapertura (Todo Integrado)
    local Open = Instance.new("TextButton", SG); Open.Size = UDim2.new(0,70,0,70); Open.Position = UDim2.new(0.02,0,0.4,0); Open.Text = "CH"; Open.BackgroundColor3 = Color3.new(0,0,0); Open.TextColor3 = Color3.fromRGB(0,255,120); Open.Visible = false; Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0); local s = Instance.new("UIStroke", Open); s.Color = Color3.fromRGB(0,255,120); s.Thickness = 2
    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 20
    
    Close.MouseButton1Click:Connect(function() Main.Visible = false; Open.Visible = true end)
    Open.MouseButton1Click:Connect(function() Main.Visible = true; Open.Visible = false; Ripple(Open) end)

    -- Floating System Buttons (Noclip Pro / InfJump)
    local Floaters = Instance.new("Frame", SG); Floaters.Size = UDim2.new(0,60,0,130); Floaters.Position = UDim2.new(1,-70,0.5,-65); Floaters.BackgroundTransparency = 1
    local function Quick(t, v)
        local b = Instance.new("TextButton", Floaters); b.Size = UDim2.new(1,0,0,55); b.Text = t; b.BackgroundColor3 = Color3.new(0,0,0); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); local s = Instance.new("UIStroke", b); s.Color = Color3.new(1,1,1)
        b.MouseButton1Click:Connect(function() CH_DATA.Toggles[v] = not CH_DATA.Toggles[v]; s.Color = CH_DATA.Toggles[v] and Color3.fromRGB(0,255,120) or Color3.new(1,1,1); b.TextColor3 = CH_DATA.Toggles[v] and Color3.fromRGB(0,255,120) or Color3.new(1,1,1) end)
    end
    Quick("NC", "Noclip"); Quick("JP", "InfJump")
end

-- [ MOTOR LÓGICO V3 ]
RunService.Stepped:Connect(function()
    -- Noclip Pro (Tu código optimizado)
    if CH_DATA.Toggles.Noclip and lp.Character then
        for _,v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    -- ESP TITAN
    if CH_DATA.Toggles.ESP then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
                local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
                local mode = isM and "M" or (isS and "S" or "I")
                local cfg = CH_DATA.ESP_Config[mode]
                
                local h = p.Character:FindFirstChild("TitanHighlight")
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "TitanHighlight"; h.OutlineColor = Color3.new(1,1,1) end
                h.FillColor = cfg.Color; h.FillTransparency = 0.5
            end
        end
    else
        for _,p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("TitanHighlight") then p.Character.TitanHighlight:Destroy() end end
    end
    
    -- Kill Aura 35 Studs
    if CH_DATA.Toggles.KillAura and lp.Character and lp.Character:FindFirstChild("Knife") then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 35 then
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
                end
            end
        end
    end
end)

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if CH_DATA.Toggles.Aimbot then
        local target = nil; local dist = math.huge
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head; local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (head.Position - camera.CFrame.Position).Magnitude
                    if CH_DATA.Toggles.Legit then
                        local ray = Ray.new(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500)
                        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character})
                        if hit and hit:IsDescendantOf(p.Character) and d < dist then target = head; dist = d end
                    elseif d < dist then target = head; dist = d end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end
end)

-- InfJump y Anti-AFK
UserInputService.JumpRequest:Connect(function() if CH_DATA.Toggles.InfJump and lp.Character:FindFirstChildOfClass("Humanoid") then lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3) end end)
lp.Idled:Connect(function() if CH_DATA.Toggles.AntiAFK then game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end end)

-- Soporte Doble Toque para Noclip (Oculto)
local lastTap = 0
UserInputService.TouchTap:Connect(function() if tick() - lastTap < 0.3 then CH_DATA.Toggles.Noclip = not CH_DATA.Toggles.Noclip end; lastTap = tick() end)

StartIntro()
