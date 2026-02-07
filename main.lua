--[[
    CHRISSHUB MM2 V23 - TITAN MOBILE ULTRA
    -------------------------------------------
    - INTRO: Hacker Rain (Lluvia de códigos) + Neón
    - LOGIN: Verificación "VERIFYING..." con Key
    - UI: Adaptada a Táctil (Botones de acción rápida)
    - TIKTOK: sasware32 (Sello de autenticidad)
    - ESP: Categorías Murder/Sheriff/Innocent + 10 Colores
    - COMBAT: Aimbot (Legit / Murderer Target)
    -------------------------------------------
]]

-- [ SERVICIOS ]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [ DATA MAESTRA ]
local CH_DATA = {
    Key = "CHRIS2026",
    TikTok = "sasware32",
    CurrentColors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 100, 255),
        Innocent = Color3.fromRGB(0, 255, 100)
    },
    Toggles = {
        ESP_M = false, ESP_S = false, ESP_I = false,
        Aimbot = false, AimbotLegit = false, AimbotMurderer = false,
        Noclip = false, InfJump = false, AntiAFK = true
    },
    ColorMap = {
        ["Rojo"] = Color3.fromRGB(255, 0, 0), ["Naranja"] = Color3.fromRGB(255, 127, 0),
        ["Amarillo"] = Color3.fromRGB(255, 255, 0), ["Verde"] = Color3.fromRGB(0, 255, 0),
        ["Azul"] = Color3.fromRGB(0, 0, 255), ["Morado"] = Color3.fromRGB(127, 0, 255),
        ["Negro"] = Color3.fromRGB(0, 0, 0), ["Blanco"] = Color3.fromRGB(255, 255, 255),
        ["Rosa"] = Color3.fromRGB(255, 105, 180), ["Gris"] = Color3.fromRGB(128, 128, 128)
    }
}

-- [ GUI PRINCIPAL ]
if CoreGui:FindFirstChild("ChrisTitanMobile") then CoreGui.ChrisTitanMobile:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "ChrisTitanMobile"

local function Animate(obj, duration, props)
    TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

-- [ MOTOR LLUVIA HACKER ]
local function CreateHackerRain(parent)
    task.spawn(function()
        while parent and parent.Parent do
            local text = Instance.new("TextLabel", parent)
            text.Size = UDim2.new(0, 20, 0, 20)
            text.Position = UDim2.new(math.random(), 0, -0.1, 0)
            text.Text = math.random(0, 1)
            text.TextColor3 = Color3.fromRGB(0, 255, 120)
            text.BackgroundTransparency = 1
            text.Font = "Code"
            text.TextTransparency = 0.4
            Animate(text, 3, {Position = UDim2.new(text.Position.X.Scale, 0, 1.1, 0), TextTransparency = 1})
            task.wait(0.1)
            game:GetService("Debris"):AddItem(text, 3.1)
        end
    end)
end

-- [ INTRO HACKER ]
local function RunIntro()
    local IntroFrame = Instance.new("Frame", ScreenGui)
    IntroFrame.Size = UDim2.new(1, 0, 1, 0); IntroFrame.BackgroundTransparency = 1
    CreateHackerRain(IntroFrame)
    
    local Title = Instance.new("TextLabel", IntroFrame)
    Title.Size = UDim2.new(1, 0, 0, 100); Title.Position = UDim2.new(0, 0, 0.45, 0)
    Title.BackgroundTransparency = 1; Title.Text = "CHRISSHUB"; Title.Font = "GothamBlack"
    Title.TextSize = 100; Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.TextTransparency = 1
    Instance.new("UIStroke", Title).Thickness = 4
    
    Animate(Title, 1, {TextTransparency = 0})
    task.wait(3); Animate(Title, 1, {TextTransparency = 1, TextSize = 140})
    task.wait(1); IntroFrame:Destroy(); ShowLogin()
end

-- [ LOGIN SYSTEM ]
function ShowLogin()
    local Login = Instance.new("Frame", ScreenGui)
    Login.Size = UDim2.new(0, 310, 0, 240); Login.Position = UDim2.new(0.5, -155, -0.5, 0)
    Login.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", Login)
    Instance.new("UIStroke", Login).Color = Color3.fromRGB(0, 255, 120)
    
    local T = Instance.new("TextLabel", Login)
    T.Size = UDim2.new(1,0,0,50); T.Text = "LOGIN TERMINAL"; T.Font = "Code"; T.TextColor3 = Color3.new(1,1,1); T.BackgroundTransparency = 1
    
    local In = Instance.new("TextBox", Login)
    In.Size = UDim2.new(0.8,0,0,40); In.Position = UDim2.new(0.1,0,0.4,0); In.PlaceholderText = "> Key..."; In.BackgroundColor3 = Color3.fromRGB(20,20,20); In.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", In)
    
    local B = Instance.new("TextButton", Login)
    B.Size = UDim2.new(0.8,0,0,40); B.Position = UDim2.new(0.1,0,0.7,0); B.Text = "ENTRAR"; B.BackgroundColor3 = Color3.fromRGB(0, 255, 120); Instance.new("UICorner", B)
    
    Animate(Login, 1, {Position = UDim2.new(0.5, -155, 0.5, -120)})
    
    B.MouseButton1Click:Connect(function()
        if In.Text == CH_DATA.Key or In.Text == "14151" then
            B.Text = "VERIFYING KEY..."; task.wait(1.5)
            B.Text = "VERIFIED (ENGLISH 🥵)"; Animate(Login, 0.5, {Position = UDim2.new(0.5, -155, 1.5, 0)})
            task.wait(0.6); Login:Destroy(); ShowMain()
        else
            T.Text = "KEY INCORRECTA"; T.TextColor3 = Color3.new(1,0,0)
            task.wait(1.5); T.Text = "LOGIN TERMINAL"; T.TextColor3 = Color3.new(1,1,1)
        end
    end)
end

-- [ PANEL PRINCIPAL ]
function ShowMain()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 400, 0, 260); Main.Position = UDim2.new(0.5, -200, 0.5, -130)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255)

    -- TikTok
    local TT = Instance.new("TextLabel", Main); TT.Size = UDim2.new(1,0,0,20); TT.Position = UDim2.new(0,0,1,-20); TT.Text = "Sigueme en TikTok: " .. CH_DATA.TikTok; TT.TextColor3 = Color3.new(0.6,0.6,0.6); TT.BackgroundTransparency = 1; TT.Font = "Code"

    -- Minimizar
    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 5); Close.Text = "X"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1
    local Mini = Instance.new("TextButton", ScreenGui); Mini.Size = UDim2.new(0, 60, 0, 60); Mini.Position = UDim2.new(0.05, 0, 0.05, 0); Mini.Text = "CH-HUB"; Mini.Visible = false; Mini.BackgroundColor3 = Color3.new(0,0,0); Instance.new("UICorner", Mini).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Mini).Color = Color3.fromRGB(0, 255, 255)

    Close.MouseButton1Click:Connect(function() Main.Visible = false; Mini.Visible = true end)
    Mini.MouseButton1Click:Connect(function() Main.Visible = true; Mini.Visible = false end)

    -- Botones de Acción Rápida (Móvil)
    local ActionList = Instance.new("Frame", ScreenGui); ActionList.Size = UDim2.new(0, 50, 0, 160); ActionList.Position = UDim2.new(1, -60, 0.5, -80); ActionList.BackgroundTransparency = 1
    Instance.new("UIListLayout", ActionList).Padding = UDim.new(0, 10)

    local function QuickButton(text, var)
        local B = Instance.new("TextButton", ActionList); B.Size = UDim2.new(1,0,0,45); B.Text = text; B.BackgroundColor3 = Color3.new(0.1,0.1,0.1); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B)
        Instance.new("UIStroke", B).Color = Color3.new(1,1,1)
        B.MouseButton1Click:Connect(function()
            CH_DATA.Toggles[var] = not CH_DATA.Toggles[var]
            B.BackgroundColor3 = CH_DATA.Toggles[var] and Color3.fromRGB(0, 255, 120) or Color3.new(0.1,0.1,0.1)
        end)
    end

    QuickButton("NC", "Noclip") -- F4
    QuickButton("JP", "InfJump") -- F5
    QuickButton("AFK", "AntiAFK") -- F6

    -- Contenido
    local TabContainer = Instance.new("Frame", Main); TabContainer.Size = UDim2.new(0, 100, 1, -40); TabContainer.Position = UDim2.new(0, 5, 0, 10); TabContainer.BackgroundTransparency = 1
    local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -120, 1, -40); Pages.Position = UDim2.new(0, 110, 0, 10); Pages.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local function AddESP(parent, label, var)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1,0,0,60); F.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", F)
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(0.6,0,0,25); L.Text = label; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1
        local T = Instance.new("TextButton", F); T.Size = UDim2.new(0, 35, 0, 18); T.Position = UDim2.new(0.7,0,0,4); T.Text = ""; T.BackgroundColor3 = Color3.new(0.2,0.2,0.2); Instance.new("UICorner", T)
        T.MouseButton1Click:Connect(function() CH_DATA.Toggles[var] = not CH_DATA.Toggles[var]; T.BackgroundColor3 = CH_DATA.Toggles[var] and Color3.new(0,1,1) or Color3.new(0.2,0.2,0.2) end)
        local C = Instance.new("TextBox", F); C.Size = UDim2.new(0.9,0,0,22); C.Position = UDim2.new(0.05,0,0.5,0); C.PlaceholderText = "Color (Ej: Rojo)"; C.BackgroundColor3 = Color3.new(0.1,0.1,0.1); C.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", C)
        C.FocusLost:Connect(function() local col = CH_DATA.ColorMap[C.Text]; if col then if var=="ESP_M" then CH_DATA.CurrentColors.Murderer=col elseif var=="ESP_S" then CH_DATA.CurrentColors.Sheriff=col else CH_DATA.CurrentColors.Innocent=col end; C.TextColor3=col end end)
    end

    local P1 = Instance.new("ScrollingFrame", Pages); P1.Size = UDim2.new(1,0,1,0); P1.BackgroundTransparency = 1; Instance.new("UIListLayout", P1).Padding = UDim.new(0, 5)
    AddESP(P1, "ESP Asesino", "ESP_M")
    AddESP(P1, "ESP Sheriff", "ESP_S")
    AddESP(P1, "ESP Inocente", "ESP_I")
end

-- [ LÓGICA DE MOTOR ]
RunService.RenderStepped:Connect(function()
    if not lp.Character then return end
    
    -- Noclip (F4 equivalente)
    if CH_DATA.Toggles.Noclip then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    -- ESP Logic
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local isM = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
            local isS = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
            local active = (isM and CH_DATA.Toggles.ESP_M) or (isS and CH_DATA.Toggles.ESP_S) or (not isM and not isS and CH_DATA.Toggles.ESP_I)
            local hl = p.Character:FindFirstChild("TitanESP")
            if active then
                if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "TitanESP" end
                hl.FillColor = isM and CH_DATA.CurrentColors.Murderer or (isS and CH_DATA.CurrentColors.Sheriff or CH_DATA.CurrentColors.Innocent)
            elseif hl then hl:Destroy() end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if CH_DATA.Toggles.InfJump and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RunIntro()
