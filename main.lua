-- CHRISSHUB MM2 V2.2 - MÓVIL COMPLETO (MAIN/ESP/COMBAT + FOV + TRACES)
-- Menú futurista dividido en tabs | FOV visible ajustable | Traces que se borran | TP Sheriff

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

local player = Players.LocalPlayer

-- KEYS
local validKeys = {"123456", "654321", "112233", "445566", "121212", "343434", "135790", "246801", "987654", "019283"}

-- ESTADOS
local toggles = {
    Noclip = false,
    Speed = false,
    InfJump = false,
    AntiAFK = false,
    ESP = false,
    Aimbot = false,
    KillAura = false,
    TPSheriff = false
}

local espColors = {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 100, 255),
    Innocent = Color3.fromRGB(0, 255, 0)
}

local colorCycle = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(128,0,128),
    Color3.fromRGB(255,192,203), Color3.fromRGB(139,69,19), Color3.fromRGB(0,0,0),
    Color3.fromRGB(255,255,255), Color3.fromRGB(128,128,128), Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,0,255), Color3.fromRGB(64,224,208), Color3.fromRGB(255,215,0)
}

local espHighlights = {}
local traces = {}
local lastAFKJump = 0
local circleButton = nil
local menuFrame = nil
local keyFrame = nil

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(0, 255, 120)
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Visible = false
fovCircle.Radius = 150

-- =============================================
-- INTRO + KEY SYSTEM
-- =============================================
local function showIntro()
    local gui = Instance.new("ScreenGui", CoreGui)
    local logo = Instance.new("TextLabel", gui)
    logo.Size = UDim2.new(0.8,0,0.2,0)
    logo.Position = UDim2.new(0.1,0,0.4,0)
    logo.Text = "CHRISSHUB V1"
    logo.TextColor3 = Color3.fromRGB(0,255,120)
    logo.BackgroundTransparency = 1
    logo.Font = Enum.Font.Code
    logo.TextSize = 70
    logo.TextStrokeTransparency = 0.5

    task.wait(4)
    TweenService:Create(logo, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1.2)
    gui:Destroy()
    showKeySystem()
end

local function showKeySystem()
    keyFrame = Instance.new("Frame", CoreGui)
    keyFrame.Size = UDim2.new(0,280,0,160)
    keyFrame.Position = UDim2.new(0.5,-140,0.5,-80)
    keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,12)

    local title = Instance.new("TextLabel", keyFrame)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "Enter License"
    title.TextColor3 = Color3.fromRGB(0,255,120)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22

    local input = Instance.new("TextBox", keyFrame)
    input.Size = UDim2.new(0.8,0,0,45)
    input.Position = UDim2.new(0.1,0,0.35,0)
    input.BackgroundColor3 = Color3.fromRGB(25,25,25)
    input.TextColor3 = Color3.new(1,1,1)
    input.PlaceholderText = "Enter License..."
    Instance.new("UICorner", input)

    local btn = Instance.new("TextButton", keyFrame)
    btn.Size = UDim2.new(0.8,0,0,45)
    btn.Position = UDim2.new(0.1,0,0.65,0)
    btn.BackgroundColor3 = Color3.fromRGB(0,200,100)
    btn.Text = "VERIFY"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if table.find(validKeys, input.Text) then
            input.Text = "Verifying key..."
            task.wait(5)
            keyFrame:Destroy()
            showMainMenu()
        else
            input.Text = ""
            input.PlaceholderText = "Invalid key"
            task.wait(2)
            input.PlaceholderText = "Enter License..."
        end
    end)
end

-- =============================================
-- MENÚ PRINCIPAL (MAIN / ESP / COMBAT)
-- =============================================
local function showMainMenu()
    menuFrame = Instance.new("Frame", CoreGui)
    menuFrame.Size = UDim2.new(0, 320, 0, 400)
    menuFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
    menuFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    menuFrame.BorderSizePixel = 0
    menuFrame.Active = true
    menuFrame.Draggable = true
    Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)

    -- X grande
    local closeBtn = Instance.new("TextButton", menuFrame)
    closeBtn.Size = UDim2.new(0, 45, 0, 45)
    closeBtn.Position = UDim2.new(1, -50, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 28
    Instance.new("UICorner", closeBtn)
    closeBtn.MouseButton1Click:Connect(function()
        menuFrame.Visible = false
        showHubCircle()
    end)

    -- Título
    local title = Instance.new("TextLabel", menuFrame)
    title.Size = UDim2.new(1,0,0,50)
    title.Text = "CHRISSHUB V1"
    title.TextColor3 = Color3.fromRGB(0,255,120)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24

    -- TikTok en MAIN
    local tiktok = Instance.new("TextLabel", menuFrame)
    tiktok.Size = UDim2.new(1,0,0,30)
    tiktok.Position = UDim2.new(0,0,0,50)
    tiktok.Text = "SÍGUEME EN TIKTOK @sasware32"
    tiktok.TextColor3 = Color3.fromRGB(0,255,120)
    tiktok.BackgroundTransparency = 1
    tiktok.Font = Enum.Font.Gotham
    tiktok.TextSize = 14

    -- Scroll
    local scroll = Instance.new("ScrollingFrame", menuFrame)
    scroll.Size = UDim2.new(1,-20,1,-100)
    scroll.Position = UDim2.new(0,10,0,80)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0,255,120)

    local function createToggle(name, posY)
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1,0,0,45)
        btn.Position = UDim2.new(0,0,0,posY)
        btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
        btn.Text = name .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(200,200,200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            toggles[name] = not toggles[name]
            btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
            btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0,120,60) or Color3.fromRGB(25,25,25)
        end)
    end

    -- MAIN
    createToggle("Noclip", 0)
    createToggle("Speed", 55)
    createToggle("InfJump", 110)
    createToggle("AntiAFK", 165)

    -- ESP
    local espTitle = Instance.new("TextLabel", scroll)
    espTitle.Size = UDim2.new(1,0,0,30)
    espTitle.Position = UDim2.new(0,0,0,230)
    espTitle.Text = "ESP"
    espTitle.TextColor3 = Color3.fromRGB(0,255,120)
    espTitle.BackgroundTransparency = 1
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 18

    createToggle("ESP", 260)

    -- COMBAT
    local combatTitle = Instance.new("TextLabel", scroll)
    combatTitle.Size = UDim2.new(1,0,0,30)
    combatTitle.Position = UDim2.new(0,0,0,310)
    combatTitle.Text = "COMBAT"
    combatTitle.TextColor3 = Color3.fromRGB(0,255,120)
    combatTitle.BackgroundTransparency = 1
    combatTitle.Font = Enum.Font.GothamBold
    combatTitle.TextSize = 18

    createToggle("Aimbot", 340)
    createToggle("KillAura", 395)
    createToggle("TPSheriff", 450)

    -- Círculo al cerrar
    local function showHubCircle()
        if circleButton then return end
        circleButton = Instance.new("TextButton", CoreGui)
        circleButton.Size = UDim2.new(0,70,0,70)
        circleButton.Position = UDim2.new(0.5,-35,0,20)
        circleButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
        circleButton.Text = "CH-HUB"
        circleButton.TextColor3 = Color3.fromRGB(0,255,120)
        circleButton.Font = Enum.Font.GothamBlack
        circleButton.TextSize = 18
        Instance.new("UICorner", circleButton).CornerRadius = UDim.new(1,0)
        circleButton.MouseButton1Click:Connect(function()
            menuFrame.Visible = true
            circleButton:Destroy()
            circleButton = nil
        end)
    end

    print("[CHRISSHUB V2.2] Menú cargado.")
end

-- Iniciar
showIntro()
