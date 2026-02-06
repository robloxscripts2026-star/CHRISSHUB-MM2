--[[
    CHRISSHUB MM2 V3 - EDICIÓN ELITE (FIXED ROUNDS)
    Corrección: Limpieza automática de colores al terminar la ronda.
    Key: CHRIS2025
]]

local KEY_SISTEMA = "CHRIS2025"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera
local lp = Players.LocalPlayer

-- Variables de Estado
local toggles = {
    ESP = false,
    Aimbot = false,
    KillAura = false,
    Noclip = false,
    InfJump = false,
    AntiAFK = false
}
local espHighlights = {}
local playerRoles = {} 

-- Crear ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrisHub_Elite_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- ==========================================
-- SISTEMA DE SEGURIDAD (KEY SYSTEM)
-- ==========================================
local LoginFrame = Instance.new("Frame")
LoginFrame.Size = UDim2.new(0, 320, 0, 220)
LoginFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
LoginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
LoginFrame.BorderSizePixel = 0
LoginFrame.Parent = ScreenGui
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 15)
local loginStroke = Instance.new("UIStroke", LoginFrame)
loginStroke.Color = Color3.fromRGB(0, 255, 120)
loginStroke.Thickness = 3

local LoginTitle = Instance.new("TextLabel", LoginFrame)
LoginTitle.Size = UDim2.new(1, 0, 0, 60)
LoginTitle.Text = "CHRISSHUB SECURITY"
LoginTitle.TextColor3 = Color3.new(1, 1, 1)
LoginTitle.Font = Enum.Font.GothamBlack
LoginTitle.TextSize = 20
LoginTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.PlaceholderText = "Ingresa la Key..."
KeyInput.Text = ""
Instance.new("UICorner", KeyInput)

local VerifyBtn = Instance.new("TextButton", LoginFrame)
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
VerifyBtn.Text = "ACCEDER"
VerifyBtn.TextColor3 = Color3.new(0, 0, 0)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 16
Instance.new("UICorner", VerifyBtn)

-- ==========================================
-- MENÚ PRINCIPAL
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 380)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 255, 120)
mainStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 70)
Title.Text = "CHRISSHUB MM2 V3"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -150)
Scroll.Position = UDim2.new(0, 10, 0, 80)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)

local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0.5, -8, 0, 45)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)

local function AddToggle(name)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = name .. ": OFF"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)
    local bStroke = Instance.new("UIStroke", Btn)
    bStroke.Color = Color3.fromRGB(45, 45, 45)
    
    Btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        Btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
        Btn.TextColor3 = toggles[name] and Color3.new(1,1,1) or Color3.fromRGB(200, 200, 200)
        Btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(25, 25, 25)
        bStroke.Color = toggles[name] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(45, 45, 45)
    end)
end

local function toggleList()
    local names = {"ESP", "Aimbot", "KillAura", "Noclip", "InfJump", "AntiAFK"}
    for _, n in pairs(names) do AddToggle(n) end
end
toggleList()

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0.9, 0, 0, 45)
CloseBtn.Position = UDim2.new(0.05, 0, 1, -60)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
CloseBtn.Text = "OCULTAR MENÚ"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn)

-- Función de Arrastre (Drag)
local function MakeDraggable(ui)
    local dragging, dragInput, dragStart, startPos
    ui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    ui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            ui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    local openBtn = Instance.new("TextButton", ScreenGui)
    openBtn.Size = UDim2.new(0, 65, 0, 65)
    openBtn.Position = UDim2.new(0.5, -32, 0, 80)
    openBtn.BackgroundColor3 = Color3.new(0, 0, 0)
    openBtn.Text = "CH"
    openBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
    openBtn.Font = Enum.Font.GothamBlack
    openBtn.TextSize = 22
    openBtn.Active = true
    Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke", openBtn)
    s.Color = Color3.fromRGB(0, 255, 120)
    s.Thickness = 2
    
    MakeDraggable(openBtn)
    
    openBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        openBtn:Destroy()
    end)
end)

-- ==========================================
-- LÓGICA DE FUNCIONES
-- ==========================================
local function getChar() return lp.Character end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function addESP(plr)
    if plr == lp then return end
    local function apply(char)
        if espHighlights[plr] then espHighlights[plr]:Destroy() end
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = toggles.ESP
        hl.Parent = char
        espHighlights[plr] = hl
    end
    if plr.Character then apply(plr.Character) end
    plr.CharacterAdded:Connect(apply)
end

for _, p in pairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)

-- DETECTOR DE FIN DE RONDA (Limpia roles)
local function ResetRoles()
    playerRoles = {}
    print("🧹 Ronda terminada: Roles limpiados.")
end

-- Detectar cuando alguien gana o la partida termina por GUI
Players.LocalPlayer.PlayerGui:WaitForChild("MainGui"):WaitForChild("Game").CashBag.Changed:Connect(function()
    -- En MM2, si el dinero de la bolsa cambia a 0 o el estado cambia, reseteamos
    ResetRoles()
end)

-- Detector de Lobby (Si el jugador aparece en el Lobby, reseteamos)
lp.CharacterAdded:Connect(function()
    ResetRoles()
end)

RunService.Heartbeat:Connect(function()
    local char = getChar()
    if not char or not getRoot() then return end
    
    -- ESP con Memoria Inteligente
    for p, hl in pairs(espHighlights) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            hl.Enabled = toggles.ESP
            if toggles.ESP then
                -- Escaneo constante de inventario y manos
                if not playerRoles[p.Name] then
                    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then
                        playerRoles[p.Name] = "Murderer"
                    elseif p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then
                        playerRoles[p.Name] = "Sheriff"
                    end
                end

                local role = playerRoles[p.Name]
                if role == "Murderer" then
                    hl.FillColor = Color3.new(1, 0, 0)
                    hl.OutlineColor = Color3.new(1, 0, 0)
                elseif role == "Sheriff" then
                    hl.FillColor = Color3.new(0, 0.4, 1)
                    hl.OutlineColor = Color3.new(0, 0.4, 1)
                else
                    hl.FillColor = Color3.new(1, 1, 1)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                end
            end
        end
    end

    -- Kill Aura
    if toggles.KillAura and char:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (getRoot().Position - p.Character.HumanoidRootPart.Position).Magnitude < 16 then
                    char.Knife.Handle.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end

    -- Aimbot
    if toggles.Aimbot and char:FindFirstChild("Gun") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                local _, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, p.Character.Head.Position)
                    break
                end
            end
        end
    end
end)

-- Noclip e Inf Jump
RunService.Stepped:Connect(function()
    if toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(3)
    end
end)

VerifyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY_SISTEMA then
        LoginFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "❌ KEY INCORRECTA"
        task.wait(1.5)
        KeyInput.PlaceholderText = "Ingresa la Key..."
    end
end)
