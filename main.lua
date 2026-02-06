--[[
    CHRISSHUB MM2 V3 - REVISIÓN TÉCNICA
    Key Oficial: CHRIS2025
    Estado: ¡Corregido y Funcional!
]]

local KEY_SISTEMA = "CHRIS2025"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer

-- Variables de Estado
local toggles = {
    ESP = false,
    Aimbot = false,
    KillAura = false,
    Noclip = false,
    InfJump = false
}
local espHighlights = {}

-- Crear ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChrisHub_Final_Fix"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- ==========================================
-- SISTEMA DE SEGURIDAD (BOTÓN CORREGIDO)
-- ==========================================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 300, 0, 220)
LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
LoginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", LoginFrame)
local loginStroke = Instance.new("UIStroke", LoginFrame)
loginStroke.Color = Color3.fromRGB(0, 255, 120)
loginStroke.Thickness = 2

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.PlaceholderText = "Escribe: CHRIS2025"
KeyInput.Text = ""
Instance.new("UICorner", KeyInput)

local VerifyBtn = Instance.new("TextButton", LoginFrame)
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
VerifyBtn.Text = "ACCEDER"
VerifyBtn.TextColor3 = Color3.new(0, 0, 0)
VerifyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", VerifyBtn)

-- ==========================================
-- MENÚ PRINCIPAL
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 340, 0, 380)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 120)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -100)
Scroll.Position = UDim2.new(0, 10, 0, 80)
Scroll.BackgroundTransparency = 1
local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0.5, -5, 0, 40)

local function AddToggle(name)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = name .. ": OFF"
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        Btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
        Btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(25, 25, 25)
    end)
end

for _, f in pairs({"ESP", "Aimbot", "KillAura", "Noclip", "InfJump"}) do AddToggle(f) end

-- Botón Flotante para abrir/cerrar
local function createOpenBtn()
    local openBtn = Instance.new("TextButton", ScreenGui)
    openBtn.Size = UDim2.new(0, 60, 0, 60)
    openBtn.Position = UDim2.new(0, 20, 0.5, 0)
    openBtn.BackgroundColor3 = Color3.new(0, 0, 0)
    openBtn.Text = "CH"
    openBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
    openBtn.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", openBtn).Color = Color3.fromRGB(0, 255, 120)
    
    openBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end

-- LÓGICA DE VERIFICACIÓN (FIXED)
VerifyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY_SISTEMA then
        LoginFrame:Destroy()
        MainFrame.Visible = true
        createOpenBtn()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "❌ KEY INCORRECTA"
    end
end)

-- LÓGICA ESP
local function applyESP(plr)
    if plr == lp then return end
    local function setup(char)
        if espHighlights[plr] then espHighlights[plr]:Destroy() end
        local hl = Instance.new("Highlight", char)
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espHighlights[plr] = hl
    end
    if plr.Character then setup(plr.Character) end
    plr.CharacterAdded:Connect(setup)
end

for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)

RunService.Heartbeat:Connect(function()
    for p, hl in pairs(espHighlights) do
        if p.Character then
            hl.Enabled = toggles.ESP
            if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then
                hl.FillColor = Color3.new(1, 0, 0)
            elseif p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then
                hl.FillColor = Color3.new(0, 0.5, 1)
            else
                hl.FillColor = Color3.new(1, 1, 1)
            end
        end
    end
end)
