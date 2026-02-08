-- =============================================
-- CHRISSHUB MM2 - CORE COMBAT & UTILITY MODULE
-- PROJECT: Supernova V5
-- ARCHITECTURE: Modular Class-Based Design
-- COMPATIBILITY: High-End Mobile/PC Devices
-- LAST UPDATED: 08/02/2026
-- =============================================

-- SERVICES INITIALIZATION
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GLOBAL REFERENCES
local camera = Workspace.CurrentCamera
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- =============================================
-- GLOBAL CONFIGURATION DICTIONARIES
-- =============================================
local CONFIG = {
    -- COMBAT SETTINGS
    KILL_AURA_RANGE = 35,
    AIMBOT_FOV = 60,
    LEGIT_AIM_SMOOTHNESS = 0.2, -- 0 = instant, 1 = max smooth
    MURDERER_DETECTION_DELAY = 0.1,

    -- VISUAL SETTINGS
    ESP_COLORS = {
        Murderer = {Fill = Color3.fromRGB(255, 0, 0), Outline = Color3.fromRGB(220, 0, 0)},
        Sheriff = {Fill = Color3.fromRGB(0, 100, 255), Outline = Color3.fromRGB(0, 80, 200)},
        Innocent = {Fill = Color3.fromRGB(255, 255, 255), Outline = Color3.fromRGB(200, 200, 200)},
        Custom1 = {Fill = Color3.fromRGB(0, 255, 0), Outline = Color3.fromRGB(0, 200, 0)},
        Custom2 = {Fill = Color3.fromRGB(255, 255, 0), Outline = Color3.fromRGB(200, 200, 0)},
        Custom3 = {Fill = Color3.fromRGB(255, 0, 255), Outline = Color3.fromRGB(200, 0, 200)},
        Custom4 = {Fill = Color3.fromRGB(0, 255, 255), Outline = Color3.fromRGB(0, 200, 200)},
        Custom5 = {Fill = Color3.fromRGB(150, 0, 255), Outline = Color3.fromRGB(120, 0, 200)},
        Custom6 = {Fill = Color3.fromRGB(255, 150, 0), Outline = Color3.fromRGB(200, 120, 0)},
        Custom7 = {Fill = Color3.fromRGB(100, 255, 0), Outline = Color3.fromRGB(80, 200, 0)},
        Custom8 = {Fill = Color3.fromRGB(0, 150, 255), Outline = Color3.fromRGB(0, 120, 200)},
        Custom9 = {Fill = Color3.fromRGB(255, 0, 150), Outline = Color3.fromRGB(200, 0, 120)},
        Custom10 = {Fill = Color3.fromRGB(150, 150, 150), Outline = Color3.fromRGB(120, 120, 120)},
        Custom11 = {Fill = Color3.fromRGB(255, 200, 200), Outline = Color3.fromRGB(200, 150, 150)},
        Custom12 = {Fill = Color3.fromRGB(200, 255, 200), Outline = Color3.fromRGB(150, 200, 150)},
        Custom13 = {Fill = Color3.fromRGB(200, 200, 255), Outline = Color3.fromRGB(150, 150, 200)},
        Custom14 = {Fill = Color3.fromRGB(255, 255, 150), Outline = Color3.fromRGB(200, 200, 120)},
        Custom15 = {Fill = Color3.fromRGB(150, 255, 255), Outline = Color3.fromRGB(120, 200, 200)}
    },
    ESP_FILL_TRANSPARENCY = 0.55,
    ESP_OUTLINE_TRANSPARENCY = 0,

    -- UTILITY SETTINGS
    ANTI_AFK_INTERVAL = 30,
    NOCLIP_RESPAWN_DELAY = 0.3,
    INFINITE_JUMP_COOLDOWN = 0.2
}

-- =============================================
-- STATE MANAGEMENT SYSTEM
-- =============================================
local State = {
    ESP = {Enabled = false, SelectedColorProfile = "Default"},
    Aimbot = {
        Normal = false,
        Legit = false,
        MurdererOnly = false,
        Target = nil,
        LastTargetSwitch = tick()
    },
    KillAura = false,
    Noclip = false,
    InfiniteJump = false,
    AntiAFK = false,
    LastJump = 0,
    Initialized = false
}

-- =============================================
-- STORAGE CLASSES
-- =============================================
local ESPStorage = {}
local MapDatabase = {
    ["MM2_MainMap"] = {OptimizeESP = true, MaxRenderDistance = 100},
    ["MM2_Canyon"] = {OptimizeESP = true, MaxRenderDistance = 80},
    ["MM2_Industrial"] = {OptimizeESP = false, MaxRenderDistance = 120},
    ["MM2_Mansion"] = {OptimizeESP = true, MaxRenderDistance = 90},
    ["MM2_Station"] = {OptimizeESP = false, MaxRenderDistance = 110}
}

-- =============================================
-- HELPER FUNCTIONS LIBRARY
-- =============================================
local Helpers = {}

-- Calculate distance between two vectors
function Helpers:GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Check line of sight with raycasting
function Helpers:HasLineOfSight(origin, target, ignoreList)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = ignoreList or {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(origin, (target - origin).Unit * CONFIG.KILL_AURA_RANGE * 2, rayParams)
    
    if result and result.Instance then
        return result.Instance:IsDescendantOf(target.Parent)
    end
    return false
end

-- Get current map name
function Helpers:GetCurrentMap()
    for mapName, _ in pairs(MapDatabase) do
        if Workspace:FindFirstChild(mapName) then
            return mapName
        end
    end
    return "Unknown"
end

-- Smooth camera movement for legit aimbot
function Helpers:SmoothCamera(targetPos)
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
    local tweenInfo = TweenInfo.new(CONFIG.LEGIT_AIM_SMOOTHNESS, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
end

-- =============================================
-- CORE MODULE FUNCTIONS
-- =============================================
local Core = {}

-- Initialize character connections
function Core:InitializeCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")

    -- Auto-reactivate noclip on respawn
    humanoid.Died:Connect(function()
        local respawnedChar = player.CharacterAdded:Wait()
        wait(CONFIG.NOCLIP_RESPAWN_DELAY)
        if State.Noclip then
            for _, part in ipairs(respawnedChar:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    State.Initialized = true
    print("[ChrissHub Core] Character system initialized successfully")
end

-- ESP Management System
function Core:ManageESP()
    -- Add ESP to new player
    local function AddPlayerESP(plr)
        if plr == player or ESPStorage[plr.UserId] then return end

        local function UpdateESP(char)
            if not char or not char:FindFirstChild("Humanoid") then return end
            
            -- Clean up old highlight
            if ESPStorage[plr.UserId] then
                ESPStorage[plr.UserId]:Destroy()
                ESPStorage[plr.UserId] = nil
            end

            -- Create new highlight
            local highlight = Instance.new("Highlight")
            highlight.Name = "ChrissHub_ESP"
            highlight.Parent = char
            highlight.FillTransparency = CONFIG.ESP_FILL_TRANSPARENCY
            highlight.OutlineTransparency = CONFIG.ESP_OUTLINE_TRANSPARENCY
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Enabled = State.ESP.Enabled

            ESPStorage[plr.UserId] = highlight
        end

        -- Initialize ESP for existing character
        if plr.Character then
            UpdateESP(plr.Character)
        end

        -- Update on character respawn
        plr.CharacterAdded:Connect(UpdateESP)

        -- Remove ESP when player leaves
        plr.PlayerRemoving:Connect(function()
            if ESPStorage[plr.UserId] then
                ESPStorage[plr.UserId]:Destroy()
                ESPStorage[plr.UserId] = nil
            end
        end)
    end

    -- Update ESP visuals every frame
    RunService.RenderStepped:Connect(function()
        if not State.ESP.Enabled then
            for _, highlight in pairs(ESPStorage) do
                highlight.Enabled = false
            end
            return
        end

        local currentMap = Helpers:GetCurrentMap()
        local mapSettings = MapDatabase[currentMap] or {OptimizeESP = false, MaxRenderDistance = 150}

        for plr, highlight in pairs(ESPStorage) do
            local targetPlr = Players:GetPlayerByUserId(plr)
            if not targetPlr or not targetPlr.Character then
                highlight.Enabled = false
                continue
            end

            local targetChar = targetPlr.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar:FindFirstChild("Humanoid")

            if not targetRoot or not targetHum or targetHum.Health <= 0 then
                highlight.Enabled = false
                continue
            end

            -- Distance optimization based on map
            local distance = Helpers:GetDistance(rootPart.Position, targetRoot.Position)
            if distance > mapSettings.MaxRenderDistance then
                highlight.Enabled = false
                continue
            end

            -- Determine player role
            local role = "Innocent"
            if targetChar:FindFirstChild("Knife") then
                role = "Murderer"
            elseif targetChar:FindFirstChild("Gun") then
                role = "Sheriff"
            end

            -- Apply color profile
            local colorSet = CONFIG.ESP_COLORS[role] or CONFIG.ESP_COLORS.Innocent
            if State.ESP.SelectedColorProfile ~= "Default" then
                colorSet = CONFIG.ESP_COLORS[State.ESP.SelectedColorProfile] or CONFIG.ESP_COLORS.Innocent
            end

            highlight.FillColor = colorSet.Fill
            highlight.OutlineColor = colorSet.Outline
            highlight.Enabled = true
        end
    end)

    -- Initialize ESP for all current players
    for _, plr in pairs(Players:GetPlayers()) do
        AddPlayerESP(plr)
    end

    -- Add ESP for new players
    Players.PlayerAdded:Connect(AddPlayerESP)

    print("[ChrissHub ESP] Visual system initialized successfully")
end

-- Aimbot Core Logic
function Core:ManageAimbot()
    RunService.RenderStepped:Connect(function()
        if not (State.Aimbot.Normal or State.Aimbot.Legit or State.Aimbot.MurdererOnly) then
            State.Aimbot.Target = nil
            return
        end

        local bestTarget = nil
        local minDistance = math.huge
        local camPos = camera.CFrame.Position

        -- Iterate through possible targets
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == player or not plr.Character then continue end

            local targetChar = plr.Character
            local targetHead = targetChar:FindFirstChild("Head")
            local targetHum = targetChar:FindFirstChild("Humanoid")

            if not targetHead or not targetHum or targetHum.Health <= 0 then continue end

            -- Murderer Only filter
            if State.Aimbot.MurdererOnly and not targetChar:FindFirstChild("Knife") then
                continue
            end

            -- Check if target is on screen
            local screenPos, onScreen = camera:WorldToViewportPoint(targetHead.Position)
            if not onScreen then continue end

            -- Calculate distance
            local distance = Helpers:GetDistance(camPos, targetHead.Position)
            if distance > CONFIG.KILL_AURA_RANGE * 2 then continue end

            -- Line of sight check for legit aimbot
            if State.Aimbot.Legit and not Helpers:HasLineOfSight(camPos, targetHead.Position) then
                continue
            end

            -- Select closest target
            if distance < minDistance then
                minDistance = distance
                bestTarget = targetHead
            end
        end

        -- Update target and control camera
        if bestTarget then
            State.Aimbot.Target = bestTarget
            if State.Aimbot.Normal or State.Aimbot.MurdererOnly then
                camera.CFrame = CFrame.new(camPos, bestTarget.Position)
            elseif State.Aimbot.Legit then
                Helpers:SmoothCamera(bestTarget.Position)
            end
        else
            State.Aimbot.Target = nil
        end
    end)

    print("[ChrissHub Aimbot] Combat targeting system initialized successfully")
end

-- Kill Aura Logic
function Core:ManageKillAura()
    RunService.Heartbeat:Connect(function()
        if not State.KillAura or not character:FindFirstChild("Knife") then return end

        local knife = character.Knife
        local knifeHandle = knife:FindFirstChild("Handle")
        if not knifeHandle then return end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr == player or not plr.Character then continue end

            local targetChar = plr.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar:FindFirstChild("Humanoid")

            if not targetRoot or not targetHum or targetHum.Health <= 0 then continue end

            local distance = Helpers:GetDistance(rootPart.Position, targetRoot.Position)
            if distance <= CONFIG.KILL_AURA_RANGE then
                -- Raycast validation before attack
                if Helpers:HasLineOfSight(rootPart.Position, targetRoot.Position) then
                    knifeHandle.CFrame = CFrame.new(targetRoot.Position) * CFrame.Angles(0, math.rad(tick() * 100), 0)
                end
            end
        end
    end)

    print("[ChrissHub KillAura] Melee combat system initialized successfully")
end

-- Utility Systems Management
function Core:ManageUtilities()
    -- Noclip System
    RunService.Stepped:Connect(function()
        if not State.Noclip or not character then return end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    -- Infinite Jump System
    UserInputService.JumpRequest:Connect(function()
        if not State.InfiniteJump or not character then return end
        if tick() - State.LastJump < CONFIG.INFINITE_JUMP_COOLDOWN then return end

        human
            
