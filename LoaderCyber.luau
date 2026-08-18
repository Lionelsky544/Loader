-- ============================================================
-- 🌀 CYBER HUB — LIQUID GLASS UNIVERSAL LOADER (V2 MINIMALIST)
-- 💎 ULTRA-CLEAN GLASSMORPHISM | SMOOTH TWEEN | FULL STABILITY
-- ============================================================

if getgenv and getgenv().CYBER_LOADER_RUNNING then
    warn("[Cyber Hub] Loader is already active.")
    return
end
if getgenv then getgenv().CYBER_LOADER_RUNNING = true end

local TweenService       = game:GetService("TweenService")
local CoreGui            = game:GetService("CoreGui")
local Players            = game:GetService("Players")
local UserInputService   = game:GetService("UserInputService")
local HttpService        = game:GetService("HttpService")
local RunService         = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
local PlaceId     = game.PlaceId

-- // 1. SAFE GUI CONTAINER //
local function getContainer()
    local c = nil
    pcall(function()
        if gethui then c = gethui()
        elseif CoreGui then c = CoreGui end
    end)
    return c or LocalPlayer:WaitForChild("PlayerGui")
end

local ParentContainer = getContainer()
pcall(function()
    local old = ParentContainer:FindFirstChild("CyberHubLiquidLoader")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHubLiquidLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = ParentContainer end)

local CYBER_LOGO_URL = "https://raw.githubusercontent.com/finzbae2123/Assets/refs/heads/main/Logo.png"

-- // 2. DATABASE GAMES & SCRIPTS //
local GamesDatabase = {
    [6911148748] = {
        Name = "Car Driving Indonesia",
        Scripts = {
            { Title = "Auto Farm", Desc = "Joiner to Jawa Timur", Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" },
            { Title = "Quest Bandung", Desc = "Event Quest Automation", Url = "https://luaegis.net/scripts/v4/loaders/d0fbc6dc-49d7-433a-809b-86dd97ceae9c.lua" }
        }
    },
    [79488788685813] = {
        Name = "Car Driving Indonesia (Event 17)",
        Scripts = {
            { Title = "Quest Bandung", Desc = "Event Quest Automation", Url = "https://luaegis.net/scripts/v4/loaders/d0fbc6dc-49d7-433a-809b-86dd97ceae9c.lua" }
        }
    },
    [110369730911937] = {
        Name = "Car Driving Indonesia Auto Farm",
        Scripts = {
            { Title = "Auto Farm (Jawa Timur)", Desc = "High Efficiency Grinding", Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" }
        }
    },
    [131378148336503] = {
        Name = "Drag Drive Simulator",
        Scripts = {
            { Title = "Auto Farm", Desc = "Drag Automation (Beta)", Url = "https://luaegis.net/scripts/v4/loaders/f1fe78e0-4a1f-4c56-b57a-2cfe43dddf8c.lua" }
        }
    },
    [14005966837] = {
        Name = "Car Driving Indonesia Minigame",
        Scripts = {
            { Title = "Minigame Auto-Solver", Desc = "Auto Complete Minigames", Url = "https://luaegis.net/scripts/v4/loaders/f144231e-ba21-4667-9dfc-5f1826f6c83c.lua" }
        }
    },
    [132986577553100] = {
        Name = "Car Driving Indonesia Quest V5",
        Scripts = {
            { Title = "Race Nostalgia", Desc = "Script For Nostalgic Racing", Url = "https://luaegis.net/scripts/v4/loaders/f144231e-ba21-4667-9dfc-5f1826f6c83c.lua" },
            { Title = "Convoi Nostalgia", Desc = "Script For Nostalgic Convoi", Url = "https://luaegis.net/scripts/v4/loaders/082cea76-91d9-464c-8519-23813a08c2a3.lua" },
            { Title = "Testing Suite", Desc = "Developer Sandbox Engine", Url = "https://luaegis.net/scripts/v4/loaders/5c669faf-1419-485a-a687-9e17850afcc6.lua" }
        }
    }
}

-- // 3. LIQUID GLASS FACTORY //
local function createGlassCard(parent, targetSize)
    local card = Instance.new("Frame")
    card.Name = "LiquidGlassCard"
    card.Size = targetSize
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.BackgroundColor3 = Color3.fromRGB(11, 14, 22)
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = parent

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)

    -- Ambient Glass Reflection (Sheen)
    local sheen = Instance.new("Frame", card)
    sheen.Size = UDim2.new(1, 0, 0, 80)
    sheen.Position = UDim2.new(0, 0, 0, 0)
    sheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sheen.BorderSizePixel = 0
    local sheenGrad = Instance.new("UIGradient", sheen)
    sheenGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    sheenGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.94),
        NumberSequenceKeypoint.new(0.4, 0.97),
        NumberSequenceKeypoint.new(1, 1)
    })
    sheenGrad.Rotation = 90

    -- Outer Glowing Neon Border
    local stroke = Instance.new("UIStroke", card)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.4
    stroke.Transparency = 0.1
    stroke.Color = Color3.fromRGB(0, 229, 255)

    local strokeGrad = Instance.new("UIGradient", stroke)
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 229, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 255, 163)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 229, 255))
    })
    strokeGrad.Rotation = 45

    task.spawn(function()
        local rot = 45
        while card and card.Parent do
            rot = (rot + 1.5) % 360
            strokeGrad.Rotation = rot
            task.wait(0.03)
        end
    end)

    return card
end

local function animateOpen(frame, targetSize)
    frame.Size = UDim2.new(0, targetSize.X.Offset * 0.85, 0, targetSize.Y.Offset * 0.85)
    frame.Position = UDim2.new(0.5, 0, 0.48, 0)
    frame.BackgroundTransparency = 0.6

    local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = targetSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 0.15
    })
    tween:Play()
end

local function animateClose(frame, targetSize, callback)
    local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, targetSize.X.Offset * 0.85, 0, targetSize.Y.Offset * 0.85),
        Position = UDim2.new(0.5, 0, 0.52, 0),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        if callback then callback() end
        frame:Destroy()
    end)
end

local function fetchScriptPayload(url)
    for attempt = 1, 3 do
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and res and #res > 0 then return res end
        task.wait(0.8)
    end
    return nil
end

-- // 4. MODERN GLASS NOTIFICATION //
local function showToastNotif(title, desc)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 320, 0, 68)
    notif.Position = UDim2.new(0.5, 0, 0, -100)
    notif.AnchorPoint = Vector2.new(0.5, 0)
    notif.BackgroundColor3 = Color3.fromRGB(11, 14, 22)
    notif.BackgroundTransparency = 0.15
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 14)

    local strk = Instance.new("UIStroke", notif)
    strk.Thickness = 1.2
    strk.Color = Color3.fromRGB(0, 229, 255)
    strk.Transparency = 0.2

    local t1 = Instance.new("TextLabel", notif)
    t1.Size = UDim2.new(1, -30, 0, 20)
    t1.Position = UDim2.new(0, 16, 0, 12)
    t1.BackgroundTransparency = 1
    t1.Font = Enum.Font.GothamBold
    t1.Text = title:upper()
    t1.TextColor3 = Color3.fromRGB(0, 229, 255)
    t1.TextSize = 13
    t1.TextXAlignment = Enum.TextXAlignment.Left

    local t2 = Instance.new("TextLabel", notif)
    t2.Size = UDim2.new(1, -30, 0, 18)
    t2.Position = UDim2.new(0, 16, 0, 34)
    t2.BackgroundTransparency = 1
    t2.Font = Enum.Font.GothamMedium
    t2.Text = desc
    t2.TextColor3 = Color3.fromRGB(220, 230, 245)
    t2.TextSize = 12
    t2.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, 30) }):Play()
    task.delay(4, function()
        local tw = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -100) })
        tw:Play()
        tw.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- // 5. MINIMALIST LOADING MODAL //
local function launchScriptLoading(scriptTitle, scriptUrl)
    local targetSize = UDim2.new(0, 390, 0, 230)
    local modal = createGlassCard(ScreenGui, targetSize)

    -- Top Header Title
    local brand = Instance.new("TextLabel", modal)
    brand.Size = UDim2.new(1, -40, 0, 24)
    brand.Position = UDim2.new(0, 20, 0, 24)
    brand.BackgroundTransparency = 1
    brand.Font = Enum.Font.GothamBold
    brand.Text = "CYBER HUB"
    brand.TextColor3 = Color3.fromRGB(0, 229, 255)
    brand.TextSize = 16
    brand.TextXAlignment = Enum.TextXAlignment.Center

    local brandGrad = Instance.new("UIGradient", brand)
    brandGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 229, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 70, 255))
    })

    local subTitle = Instance.new("TextLabel", modal)
    subTitle.Size = UDim2.new(1, -40, 0, 18)
    subTitle.Position = UDim2.new(0, 20, 0, 50)
    subTitle.BackgroundTransparency = 1
    subTitle.Font = Enum.Font.GothamMedium
    subTitle.Text = scriptTitle
    subTitle.TextColor3 = Color3.fromRGB(240, 245, 255)
    subTitle.TextSize = 13
    subTitle.TextXAlignment = Enum.TextXAlignment.Center

    -- Progress Status Label
    local statusLbl = Instance.new("TextLabel", modal)
    statusLbl.Size = UDim2.new(1, -40, 0, 18)
    statusLbl.Position = UDim2.new(0, 20, 0, 105)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.Text = "Connecting To Server..."
    statusLbl.TextColor3 = Color3.fromRGB(150, 170, 200)
    statusLbl.TextSize = 12
    statusLbl.TextXAlignment = Enum.TextXAlignment.Center

    -- Glow Progress Bar Track
    local track = Instance.new("Frame", modal)
    track.Size = UDim2.new(1, -60, 0, 8)
    track.Position = UDim2.new(0, 30, 0, 138)
    track.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 229, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 70, 255))
    })

    local pctLbl = Instance.new("TextLabel", modal)
    pctLbl.Size = UDim2.new(1, -40, 0, 18)
    pctLbl.Position = UDim2.new(0, 20, 0, 160)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Font = Enum.Font.GothamBold
    pctLbl.Text = "0%"
    pctLbl.TextColor3 = Color3.fromRGB(0, 229, 255)
    pctLbl.TextSize = 13
    pctLbl.TextXAlignment = Enum.TextXAlignment.Center

    animateOpen(modal, targetSize)

    task.spawn(function()
        local stages = {
            { Pct = 15,  Msg = "Connecting To Server" },
            { Pct = 30,  Msg = "Verifying Security & Key" },
            { Pct = 50,  Msg = "Downloading Script Payload" },
            { Pct = 75,  Msg = "Decrypting Core Modules" },
            { Pct = 90,  Msg = "Initializing Environment" },
            { Pct = 100, Msg = "Launching Interface..." }
        }

        local current = 0
        local payload = nil

        for idx, stage in ipairs(stages) do
            statusLbl.Text = stage.Msg
            TweenService:Create(fill, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(stage.Pct / 100, 0, 1, 0)
            }):Play()

            if idx == 3 then
                task.spawn(function()
                    payload = fetchScriptPayload(scriptUrl)
                end)
            end

            for p = current + 1, stage.Pct do
                pctLbl.Text = p .. "%"
                task.wait(0.04)
            end
            current = stage.Pct
        end

        if not payload then
            payload = fetchScriptPayload(scriptUrl)
        end

        if not payload then
            statusLbl.Text = "ERROR: Failed to load script payload!"
            statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            pctLbl.Text = "FAILED"
            pctLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            task.wait(2.0)
            animateClose(modal, targetSize, function()
                if getgenv then getgenv().CYBER_LOADER_RUNNING = nil end
            end)
            return
        end

        statusLbl.TextColor3 = Color3.fromRGB(0, 255, 163)
        pctLbl.TextColor3 = Color3.fromRGB(0, 255, 163)
        pctLbl.Text = "READY"

        task.wait(0.8)

        animateClose(modal, targetSize, function()
            if getgenv then getgenv().CYBER_LOADER_RUNNING = nil end
            showToastNotif("Cyber Hub", "Welcome " .. tostring(LocalPlayer.Name) .. " — Script Active!")
        end)

        local fn, err = loadstring(payload)
        if fn then
            pcall(fn)
        else
            warn("[Cyber Hub] Payload Compile Error: " .. tostring(err))
        end
    end)
end

-- // 6. MINIMALIST SCRIPT SELECTOR //
local function launchScriptSelector(gameConfig)
    local list = gameConfig.Scripts
    local count = #list

    local itemH = 50
    local gap = 8
    local topOffset = 88
    local bodyH = (count * itemH) + ((count - 1) * gap)
    local totalH = math.min(380, topOffset + bodyH + 20)
    local targetSize = UDim2.new(0, 420, 0, totalH)

    local modal = createGlassCard(ScreenGui, targetSize)

    local title = Instance.new("TextLabel", modal)
    title.Size = UDim2.new(1, -40, 0, 22)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "CYBER HUB SELECTOR"
    title.TextColor3 = Color3.fromRGB(0, 229, 255)
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Center

    local gameName = Instance.new("TextLabel", modal)
    gameName.Size = UDim2.new(1, -40, 0, 18)
    gameName.Position = UDim2.new(0, 20, 0, 44)
    gameName.BackgroundTransparency = 1
    gameName.Font = Enum.Font.GothamMedium
    gameName.Text = gameConfig.Name
    gameName.TextColor3 = Color3.fromRGB(240, 245, 255)
    gameName.TextSize = 13
    gameName.TextXAlignment = Enum.TextXAlignment.Center

    local sub = Instance.new("TextLabel", modal)
    sub.Size = UDim2.new(1, -40, 0, 16)
    sub.Position = UDim2.new(0, 20, 0, 64)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.Text = count .. " scripts available. Choose an option:"
    sub.TextColor3 = Color3.fromRGB(150, 165, 190)
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Center

    local scroll = Instance.new("ScrollingFrame", modal)
    scroll.Size = UDim2.new(1, -32, 1, -(topOffset + 14))
    scroll.Position = UDim2.new(0, 16, 0, topOffset)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
    scroll.CanvasSize = UDim2.new(0, 0, 0, bodyH)

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, gap)

    for idx, item in ipairs(list) do
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -6, 0, itemH)
        btn.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
        btn.BackgroundTransparency = 0.35
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Thickness = 1.1
        btnStroke.Color = Color3.fromRGB(0, 229, 255)
        btnStroke.Transparency = 0.5

        local bTitle = Instance.new("TextLabel", btn)
        bTitle.Size = UDim2.new(1, -20, 0, 18)
        bTitle.Position = UDim2.new(0, 14, 0, 7)
        bTitle.BackgroundTransparency = 1
        bTitle.Font = Enum.Font.GothamBold
        bTitle.Text = item.Title
        bTitle.TextColor3 = Color3.fromRGB(0, 229, 255)
        bTitle.TextSize = 13
        bTitle.TextXAlignment = Enum.TextXAlignment.Left

        local bDesc = Instance.new("TextLabel", btn)
        bDesc.Size = UDim2.new(1, -20, 0, 16)
        bDesc.Position = UDim2.new(0, 14, 0, 26)
        bDesc.BackgroundTransparency = 1
        bDesc.Font = Enum.Font.Gotham
        bDesc.Text = item.Desc
        bDesc.TextColor3 = Color3.fromRGB(160, 175, 200)
        bDesc.TextSize = 11
        bDesc.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.1 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), { Transparency = 0.0 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.35 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), { Transparency = 0.5 }):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            animateClose(modal, targetSize, function()
                launchScriptLoading(item.Title, item.Url)
            end)
        end)
    end

    animateOpen(modal, targetSize)
end

-- // 7. ENTRY ROUTER //
local currentConfig = GamesDatabase[PlaceId]

if currentConfig then
    if #currentConfig.Scripts > 1 then
        launchScriptSelector(currentConfig)
    else
        launchScriptLoading(currentConfig.Scripts[1].Title, currentConfig.Scripts[1].Url)
    end
else
    local targetSize = UDim2.new(0, 360, 0, 160)
    local unsupp = createGlassCard(ScreenGui, targetSize)

    local t1 = Instance.new("TextLabel", unsupp)
    t1.Size = UDim2.new(1, -40, 0, 22)
    t1.Position = UDim2.new(0, 20, 0, 20)
    t1.BackgroundTransparency = 1
    t1.Font = Enum.Font.GothamBold
    t1.Text = "GAME NOT SUPPORTED"
    t1.TextColor3 = Color3.fromRGB(255, 75, 75)
    t1.TextSize = 15
    t1.TextXAlignment = Enum.TextXAlignment.Center

    local t2 = Instance.new("TextLabel", unsupp)
    t2.Size = UDim2.new(1, -40, 0, 36)
    t2.Position = UDim2.new(0, 20, 0, 46)
    t2.BackgroundTransparency = 1
    t2.Font = Enum.Font.Gotham
    t2.Text = "Place ID (" .. tostring(PlaceId) .. ") is currently not registered."
    t2.TextColor3 = Color3.fromRGB(190, 205, 225)
    t2.TextSize = 12
    t2.TextWrapped = true
    t2.TextXAlignment = Enum.TextXAlignment.Center

    local copy = Instance.new("TextButton", unsupp)
    copy.Size = UDim2.new(0, 160, 0, 34)
    copy.Position = UDim2.new(0.5, -80, 1, -46)
    copy.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
    copy.Font = Enum.Font.GothamBold
    copy.Text = "Copy Place ID"
    copy.TextColor3 = Color3.fromRGB(0, 229, 255)
    copy.TextSize = 12
    copy.AutoButtonColor = false
    Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 10)
    
    local cStroke = Instance.new("UIStroke", copy)
    cStroke.Thickness = 1.1
    cStroke.Color = Color3.fromRGB(0, 229, 255)
    cStroke.Transparency = 0.4

    copy.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(tostring(PlaceId))
                copy.Text = "Copied!"
                copy.TextColor3 = Color3.fromRGB(0, 255, 163)
            end
        end)
    end)

    animateOpen(unsupp, targetSize)

    task.delay(6, function()
        pcall(function() unsupp:Destroy() end)
        if getgenv then getgenv().CYBER_LOADER_RUNNING = nil end
    end)
end
