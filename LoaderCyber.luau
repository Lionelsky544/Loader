if getgenv and getgenv().CYBER_LOADER_RUNNING then
    warn("CyberHub Loader is already running!")
    return
end
if getgenv then getgenv().CYBER_LOADER_RUNNING = true end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer
local PlaceId = game.PlaceId

local function getSafeGuiContainer()
    local container = nil
    pcall(function()
        if gethui then
            container = gethui()
        elseif CoreGui then
            container = CoreGui
        end
    end)
    if not container then
        container = LocalPlayer:WaitForChild("PlayerGui")
    end
    return container
end

local ParentContainer = getSafeGuiContainer()

pcall(function()
    local old = ParentContainer:FindFirstChild("CyberHubLoaderContainer")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHubLoaderContainer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = ParentContainer end)

local CYBER_LOGO_URL = "https://raw.githubusercontent.com/finzbae2123/Assets/refs/heads/main/Logo.png"

local GamesDatabase = {
    [6911148748] = {
        Name = "Car Driving Indonesia",
        Scripts = {
            { Title = "Car Driving Indonesia", Desc = "Joiner To Jawa TImur", Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" },
----        { Title = "Code 2: CDID Auto Farm Edition", Desc = "Automated Money & Delivery Engine", Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" }
        }
    },
    [110369730911937] = {
        Name = "Car Driving Indonesia Auto Farm",
        Scripts = {
            { Title = "Car Driving Indonesia Auto Farm", Desc = "Only Work In Jawa TImur", Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" },
--          { Title = "Code 2: RideGO Ojek Automation", Desc = "Ojek Online Auto Passenger Delivery", Url = "https://raw.githubusercontent.com/Lionelsky544/AssetsFinal/refs/heads/main/Logo.png" }
        }
    },
    [131378148336503] = {
        Name = "Drag Drive Simulator",
        Scripts = {
            { Title = "Code 1: Cyber Hub RideGO Ojek", Desc = "Auto Team, Spawn Mio & RideGO Engine", Url = "https://raw.githubusercontent.com/Lionelsky544/AssetsFinal/refs/heads/main/Logo.png" },
            { Title = "Code 2: Drag Race Automation", Desc = "Auto Drag Race & Speed Tuning Hub", Url = "https://raw.githubusercontent.com/Lionelsky544/AssetsFinal/refs/heads/main/Logo.png" }
        }
    },
    [14005966837] = {
        Name = "Car Driving Indonesia Minigame",
        Scripts = {
            { Title = "Minigame", Desc = "Auto Complete Minigames", Url = "https://luaegis.net/scripts/v4/loaders/f144231e-ba21-4667-9dfc-5f1826f6c83c.lua" }
        }
    },
    [132986577553100] = {
        Name = "Car Driving Indonesia Quest V5",
        Scripts = {
            { Title = "Car Driving Indonesia Race Nostalgia", Desc = "Script For Nostalgic Racing", Url = "https://luaegis.net/scripts/v4/loaders/f144231e-ba21-4667-9dfc-5f1826f6c83c.lua" },
            { Title = "Car Driving Indonesia Convoi Nostalgia", Desc = "Script For Nostalgic Convoi", Url = "https://luaegis.net/scripts/v4/loaders/082cea76-91d9-464c-8519-23813a08c2a3.lua" },
        }
    }
}

local function createLiquidGlassFrame(parent, targetSize, targetPos)
    targetPos = targetPos or UDim2.new(0.5, 0, 0.5, 0)
    local frame = nil
    local isCanvasGroup = false
    pcall(function()
        frame = Instance.new("CanvasGroup")
        isCanvasGroup = true
    end)
    if not frame then
        frame = Instance.new("Frame")
    end

    frame.Size = UDim2.new(0, targetSize.X.Offset * 0.75, 0, targetSize.Y.Offset * 0.75)
    frame.Position = UDim2.new(0.5, 0, 0.46, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    if isCanvasGroup then
        frame.GroupTransparency = 1
    end
    frame.Parent = parent

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

    local stroke = Instance.new("UIStroke", frame)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.8
    stroke.Transparency = 0.15
    stroke.Color = Color3.fromRGB(0, 230, 255)

    local gradient = Instance.new("UIGradient", stroke)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 230, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 50, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 230, 255))
    })
    gradient.Rotation = 45

    task.spawn(function()
        local rot = 45
        while frame and frame.Parent do
            rot = (rot + 2) % 360
            gradient.Rotation = rot
            task.wait(0.03)
        end
    end)

    return frame, targetSize, isCanvasGroup
end

local function animateInModal(frame, targetSize, isCanvasGroup)
    frame.Size = UDim2.new(0, targetSize.X.Offset * 0.8, 0, targetSize.Y.Offset * 0.8)
    frame.Position = UDim2.new(0.5, 0, 0.45, 0)
    if isCanvasGroup then frame.GroupTransparency = 1 end

    local tweenProps = {
        Size = targetSize,
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }
    if isCanvasGroup then tweenProps.GroupTransparency = 0 end
    
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(frame, tweenInfo, tweenProps):Play()
end

local function animateOutModal(frame, targetSize, isCanvasGroup, callback)
    local shrinkSize = UDim2.new(0, targetSize.X.Offset * 0.8, 0, targetSize.Y.Offset * 0.8)
    local tweenProps = {
        Size = shrinkSize,
        Position = UDim2.new(0.5, 0, 0.54, 0)
    }
    if isCanvasGroup then tweenProps.GroupTransparency = 1 end
    
    local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    local tween = TweenService:Create(frame, tweenInfo, tweenProps)
    tween:Play()
    tween.Completed:Connect(function()
        if callback then callback() end
        frame:Destroy()
    end)
end

local function safeFetchScript(url, maxRetries)
    maxRetries = maxRetries or 3
    for attempt = 1, maxRetries do
        local ok, content = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and content and #content > 0 then
            return content
        end
        task.wait(1)
    end
    return nil
end

local function showLiquidGlassNotif(titleText, mainDesc, subDesc, duration)
    duration = duration or 4.5
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "LiquidGlassWelcomeNotif"
    notifFrame.Size = UDim2.new(0, 350, 0, 85)
    notifFrame.AnchorPoint = Vector2.new(0.5, 0)
    notifFrame.Position = UDim2.new(0.5, 0, 0, -150)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    notifFrame.BackgroundTransparency = 0.2
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = ScreenGui

    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.5
    stroke.Transparency = 0.15
    stroke.Color = Color3.fromRGB(0, 230, 255)

    local gradient = Instance.new("UIGradient", stroke)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 230, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 50, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 230, 255))
    })
    gradient.Rotation = 45

    task.spawn(function()
        local r = 45
        while notifFrame and notifFrame.Parent do
            r = (r + 2) % 360
            gradient.Rotation = r
            task.wait(0.03)
        end
    end)

    local iconFrame = Instance.new("Frame", notifFrame)
    iconFrame.Size = UDim2.new(0, 52, 0, 52)
    iconFrame.Position = UDim2.new(0, 14, 0.5, -26)
    iconFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    iconFrame.BackgroundTransparency = 0.3
    iconFrame.BorderSizePixel = 0
    Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 12)

    local iconImg = Instance.new("ImageLabel", iconFrame)
    iconImg.Size = UDim2.new(0, 38, 0, 38)
    iconImg.Position = UDim2.new(0.5, -19, 0.5, -19)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = "rbxassetid://10734932975"

    task.spawn(function()
        pcall(function()
            if writefile and getcustomasset then
                if not isfile("CyberHubLogo.png") then
                    local content = game:HttpGet(CYBER_LOGO_URL)
                    if content then writefile("CyberHubLogo.png", content) end
                end
                iconImg.Image = getcustomasset("CyberHubLogo.png") or iconImg.Image
            end
        end)
    end)

    local function createLbl(yPos, font, txt, color, sz)
        local lbl = Instance.new("TextLabel", notifFrame)
        lbl.Size = UDim2.new(0, 250, 0, 20)
        lbl.Position = UDim2.new(0, 78, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.Font = font
        lbl.Text = txt
        lbl.TextColor3 = color
        lbl.TextSize = sz
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        return lbl
    end

    createLbl(12, Enum.Font.GothamBold, titleText:upper(), Color3.fromRGB(0, 230, 255), 13)
    createLbl(32, Enum.Font.GothamMedium, mainDesc, Color3.fromRGB(240, 245, 255), 13)
    createLbl(54, Enum.Font.Gotham, subDesc, Color3.fromRGB(160, 175, 205), 11)

    local accentBar = Instance.new("Frame", notifFrame)
    accentBar.Size = UDim2.new(1, -28, 0, 3)
    accentBar.Position = UDim2.new(0, 14, 1, -7)
    accentBar.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
    accentBar.BorderSizePixel = 0
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    TweenService:Create(notifFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, 40) }):Play()
    TweenService:Create(accentBar, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 3) }):Play()

    task.delay(duration, function()
        local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -150) })
        tweenOut:Play()
        tweenOut.Completed:Connect(function() notifFrame:Destroy() end)
    end)
end

local function showLoadingScreen(scriptTitle, scriptUrl)
    local targetSize = UDim2.new(0, 430, 0, 260)
    local loadModal, _, isCanvasGroup = createLiquidGlassFrame(ScreenGui, targetSize)

    local logoFrame = Instance.new("Frame", loadModal)
    logoFrame.Size = UDim2.new(0, 80, 0, 80)
    logoFrame.Position = UDim2.new(0.5, 0, 0, 48)
    logoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    logoFrame.BackgroundTransparency = 1

    local logoImg = Instance.new("ImageLabel", logoFrame)
    logoImg.Size = UDim2.new(1, 0, 1, 0)
    logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = "rbxassetid://10734932975"

    task.spawn(function()
        pcall(function()
            if writefile and getcustomasset then
                if not isfile("CyberHubLogo.png") then
                    local content = game:HttpGet(CYBER_LOGO_URL)
                    if content then writefile("CyberHubLogo.png", content) end
                end
                logoImg.Image = getcustomasset("CyberHubLogo.png") or logoImg.Image
            end
        end)
    end)

    local isFinalizing = false
    task.spawn(function()
        local startTime = tick()
        while loadModal and loadModal.Parent and not isFinalizing do
            local elapsed = tick() - startTime
            local yOffset = math.sin(elapsed * 3.5) * 3
            local scalePulse = 1.0 + (math.sin(elapsed * 2.5) * 0.05)
            
            logoFrame.Position = UDim2.new(0.5, 0, 0, 44 + yOffset)
            logoImg.Size = UDim2.new(scalePulse, 0, scalePulse, 0)
            task.wait(0.02)
        end
    end)

    local titleLbl = Instance.new("TextLabel", loadModal)
    titleLbl.Size = UDim2.new(1, -40, 0, 24)
    titleLbl.Position = UDim2.new(0, 20, 0, 80)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = "CYBER HUB LOADER"
    titleLbl.TextColor3 = Color3.fromRGB(0, 230, 255)
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center

    local subLbl = Instance.new("TextLabel", loadModal)
    subLbl.Size = UDim2.new(1, -40, 0, 20)
    subLbl.Position = UDim2.new(0, 20, 0, 106)
    subLbl.BackgroundTransparency = 1
    subLbl.Font = Enum.Font.GothamMedium
    subLbl.Text = scriptTitle
    subLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    subLbl.TextSize = 13
    subLbl.TextXAlignment = Enum.TextXAlignment.Center

    local statusLbl = Instance.new("TextLabel", loadModal)
    statusLbl.Size = UDim2.new(1, -40, 0, 20)
    statusLbl.Position = UDim2.new(0, 20, 0, 142)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.Text = "Connecting To Server"
    statusLbl.TextColor3 = Color3.fromRGB(170, 185, 215)
    statusLbl.TextSize = 12
    statusLbl.TextXAlignment = Enum.TextXAlignment.Center

    local trackFrame = Instance.new("Frame", loadModal)
    trackFrame.Size = UDim2.new(1, -50, 0, 10)
    trackFrame.Position = UDim2.new(0, 25, 0, 175)
    trackFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    trackFrame.BorderSizePixel = 0
    Instance.new("UICorner", trackFrame).CornerRadius = UDim.new(1, 0)

    local fillFrame = Instance.new("Frame", trackFrame)
    fillFrame.Size = UDim2.new(0, 0, 1, 0)
    fillFrame.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
    fillFrame.BorderSizePixel = 0
    Instance.new("UICorner", fillFrame).CornerRadius = UDim.new(1, 0)

    local fillGradient = Instance.new("UIGradient", fillFrame)
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 195, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(170, 50, 255))
    })

    local percentLbl = Instance.new("TextLabel", loadModal)
    percentLbl.Size = UDim2.new(1, -40, 0, 20)
    percentLbl.Position = UDim2.new(0, 20, 0, 196)
    percentLbl.BackgroundTransparency = 1
    percentLbl.Font = Enum.Font.GothamBold
    percentLbl.Text = "0%"
    percentLbl.TextColor3 = Color3.fromRGB(0, 230, 255)
    percentLbl.TextSize = 13
    percentLbl.TextXAlignment = Enum.TextXAlignment.Center

    animateInModal(loadModal, targetSize, isCanvasGroup)

    task.spawn(function()
        local steps = {
            { Target = 10,  Text = "Connecting To Server" },
            { Target = 20,  Text = "Verifying Key" },
            { Target = 30,  Text = "Verifying Hwid" },
            { Target = 40,  Text = "Verifying Profile" },
            { Target = 50,  Text = "Decrypting" },
            { Target = 60,  Text = "Checking" },
            { Target = 70,  Text = "Bypassing" },
            { Target = 80,  Text = "Loading" },
            { Target = 90,  Text = "Injecting" },
            { Target = 100, Text = "Ready, Loading Ui...." }
        }

        local currentPct = 0
        local payload = nil

        for idx, step in ipairs(steps) do
            statusLbl.Text = step.Text
            TweenService:Create(fillFrame, TweenInfo.new(1.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(step.Target / 100, 0, 1, 0) }):Play()

            if idx == 4 then
                task.spawn(function()
                    payload = safeFetchScript(scriptUrl, 3)
                end)
            end

            for p = currentPct + 1, step.Target do
                percentLbl.Text = p .. "%"
                task.wait(0.11)
            end
            currentPct = step.Target
        end

        if not payload then
            payload = safeFetchScript(scriptUrl, 2)
        end

        if not payload then
            statusLbl.Text = "ERROR: Failed to download script payload!"
            statusLbl.TextColor3 = Color3.fromRGB(255, 70, 70)
            percentLbl.Text = "FAILED"
            percentLbl.TextColor3 = Color3.fromRGB(255, 70, 70)
            task.wait(2.5)
            animateOutModal(loadModal, targetSize, isCanvasGroup, function()
                if getgenv then getgenv().CYBER_LOADER_RUNNING = nil end
            end)
            return
        end

        statusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
        isFinalizing = true
        
        TweenService:Create(titleLbl, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
        TweenService:Create(subLbl, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
        TweenService:Create(statusLbl, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
        TweenService:Create(percentLbl, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
        TweenService:Create(trackFrame, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(fillFrame, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
        
        task.wait(0.35)

        TweenService:Create(logoFrame, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 170, 0, 170),
            Position = UDim2.new(0.5, 0, 0, 100)
        }):Play()
        TweenService:Create(logoImg, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()

        local finalBrandLbl = Instance.new("TextLabel", loadModal)
        finalBrandLbl.Size = UDim2.new(1, -40, 0, 36)
        finalBrandLbl.Position = UDim2.new(0, 20, 0, 202)
        finalBrandLbl.BackgroundTransparency = 1
        finalBrandLbl.Font = Enum.Font.GothamBold
        finalBrandLbl.Text = "CYBER HUB"
        finalBrandLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        finalBrandLbl.TextSize = 26
        finalBrandLbl.TextTransparency = 1
        finalBrandLbl.TextXAlignment = Enum.TextXAlignment.Center

        local textGradient = Instance.new("UIGradient", finalBrandLbl)
        textGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 230, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 50, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 255, 160))
        })
        textGradient.Rotation = 0

        task.spawn(function()
            local rot = 0
            while finalBrandLbl and finalBrandLbl.Parent do
                rot = (rot + 3) % 360
                textGradient.Rotation = rot
                task.wait(0.02)
            end
        end)

        TweenService:Create(finalBrandLbl, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()

        task.wait(1.8)

        animateOutModal(loadModal, targetSize, isCanvasGroup, function()
            if getgenv then getgenv().CYBER_LOADER_RUNNING = nil end
            showLiquidGlassNotif("Cyber Hub", "Welcome " .. tostring(LocalPlayer.Name), "Enjoy To Script", 4.5)
        end)

        local fn, compileErr = loadstring(payload)
        if fn then
            pcall(fn)
        else
            warn("CyberHub Loader Compile Error: " .. tostring(compileErr))
        end
    end)
end

local function showSelectionModal(gameConfig)
    local scriptsList = gameConfig.Scripts
    local totalScripts = #scriptsList

    local itemHeight = 54
    local spacing = 10
    local headerOffset = 105
    local contentHeight = (totalScripts * itemHeight) + ((totalScripts - 1) * spacing)
    local modalHeight = math.min(410, headerOffset + contentHeight + 25)
    local targetSize = UDim2.new(0, 460, 0, modalHeight)

    local selectModal, _, isCanvasGroup = createLiquidGlassFrame(ScreenGui, targetSize)
    
    local bgLogo = Instance.new("ImageLabel", selectModal)
    bgLogo.Size = UDim2.new(0, 180, 0, 180)
    bgLogo.Position = UDim2.new(0.5, -90, 0.5, -90)
    bgLogo.BackgroundTransparency = 1
    bgLogo.ImageTransparency = 0.92
    bgLogo.Image = "rbxassetid://10734932975"
    bgLogo.ZIndex = 1

    task.spawn(function()
        pcall(function()
            if writefile and getcustomasset then
                if not isfile("CyberHubLogo.png") then
                    local content = game:HttpGet(CYBER_LOGO_URL)
                    if content then writefile("CyberHubLogo.png", content) end
                end
                bgLogo.Image = getcustomasset("CyberHubLogo.png") or bgLogo.Image
            end
        end)
    end)

    local titleLbl = Instance.new("TextLabel", selectModal)
    titleLbl.Size = UDim2.new(1, -40, 0, 24)
    titleLbl.Position = UDim2.new(0, 20, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = "CYBER HUB SELECTOR"
    titleLbl.TextColor3 = Color3.fromRGB(0, 230, 255)
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.ZIndex = 2

    local gameLbl = Instance.new("TextLabel", selectModal)
    gameLbl.Size = UDim2.new(1, -40, 0, 20)
    gameLbl.Position = UDim2.new(0, 20, 0, 46)
    gameLbl.BackgroundTransparency = 1
    gameLbl.Font = Enum.Font.GothamMedium
    gameLbl.Text = gameConfig.Name
    gameLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    gameLbl.TextSize = 14
    gameLbl.TextXAlignment = Enum.TextXAlignment.Center
    gameLbl.ZIndex = 2

    local descLbl = Instance.new("TextLabel", selectModal)
    descLbl.Size = UDim2.new(1, -40, 0, 18)
    descLbl.Position = UDim2.new(0, 20, 0, 68)
    descLbl.BackgroundTransparency = 1
    descLbl.Font = Enum.Font.Gotham
    descLbl.Text = string.format("%d codes found for this game. Select option to execute:", totalScripts)
    descLbl.TextColor3 = Color3.fromRGB(160, 175, 205)
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Center
    descLbl.ZIndex = 2

    local scrollFrame = Instance.new("ScrollingFrame", selectModal)
    scrollFrame.Size = UDim2.new(1, -30, 1, -(headerOffset + 15))
    scrollFrame.Position = UDim2.new(0, 15, 0, headerOffset)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 230, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)

    local UIList = Instance.new("UIListLayout", scrollFrame)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, spacing)

    local palette = {
        Color3.fromRGB(0, 230, 255),
        Color3.fromRGB(170, 50, 255),
        Color3.fromRGB(0, 255, 160),
        Color3.fromRGB(255, 170, 0),
        Color3.fromRGB(255, 70, 150)
    }

    for idx, scriptData in ipairs(scriptsList) do
        local btnColor = palette[(idx - 1) % #palette + 1]

        local btn = Instance.new("TextButton", scrollFrame)
        btn.Name = "Option_" .. idx
        btn.Size = UDim2.new(1, -8, 0, itemHeight)
        btn.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.LayoutOrder = idx
        btn.Text = ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Thickness = 1.2
        btnStroke.Transparency = 0.4
        btnStroke.Color = btnColor

        local btnTitle = Instance.new("TextLabel", btn)
        btnTitle.Size = UDim2.new(1, -25, 0, 20)
        btnTitle.Position = UDim2.new(0, 14, 0, 8)
        btnTitle.BackgroundTransparency = 1
        btnTitle.Font = Enum.Font.GothamBold
        btnTitle.Text = scriptData.Title
        btnTitle.TextColor3 = btnColor
        btnTitle.TextSize = 13
        btnTitle.TextXAlignment = Enum.TextXAlignment.Left

        local btnDesc = Instance.new("TextLabel", btn)
        btnDesc.Size = UDim2.new(1, -25, 0, 16)
        btnDesc.Position = UDim2.new(0, 14, 0, 28)
        btnDesc.BackgroundTransparency = 1
        btnDesc.Font = Enum.Font.Gotham
        btnDesc.Text = scriptData.Desc
        btnDesc.TextColor3 = Color3.fromRGB(170, 185, 215)
        btnDesc.TextSize = 11
        btnDesc.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.1 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), { Transparency = 0.0 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.3 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), { Transparency = 0.4 }):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            animateOutModal(selectModal, targetSize, isCanvasGroup, function()
                showLoadingScreen(scriptData.Title, scriptData.Url)
            end)
        end)
    end

    animateInModal(selectModal, targetSize, isCanvasGroup)
end

local gameConfig = GamesDatabase[PlaceId]

if gameConfig then
    if #gameConfig.Scripts > 1 then
        showSelectionModal(gameConfig)
    else
        local singleScript = gameConfig.Scripts[1]
        showLoadingScreen(singleScript.Title, singleScript.Url)
    end
else
    local unsuppModal = createLiquidGlassFrame(ScreenGui, UDim2.new(0, 380, 0, 160), UDim2.new(0.5, 0, 0.5, 0))

    local tLbl = Instance.new("TextLabel", unsuppModal)
    tLbl.Size = UDim2.new(1, -40, 0, 25)
    tLbl.Position = UDim2.new(0, 20, 0, 20)
    tLbl.BackgroundTransparency = 1
    tLbl.Font = Enum.Font.GothamBold
    tLbl.Text = "GAME NOT SUPPORTED"
    tLbl.TextColor3 = Color3.fromRGB(255, 70, 70)
    tLbl.TextSize = 15
    tLbl.TextXAlignment = Enum.TextXAlignment.Center

    local dLbl = Instance.new("TextLabel", unsuppModal)
    dLbl.Size = UDim2.new(1, -40, 0, 40)
    dLbl.Position = UDim2.new(0, 20, 0, 50)
    dLbl.BackgroundTransparency = 1
    dLbl.Font = Enum.Font.Gotham
    dLbl.Text = "Place ID (" .. tostring(PlaceId) .. ") is not in CyberHub database."
    dLbl.TextColor3 = Color3.fromRGB(200, 210, 230)
    dLbl.TextSize = 12
    dLbl.TextWrapped = true
    dLbl.TextXAlignment = Enum.TextXAlignment.Center

    local copyBtn = Instance.new("TextButton", unsuppModal)
    copyBtn.Size = UDim2.new(0, 180, 0, 36)
    copyBtn.Position = UDim2.new(0.5, -90, 1, -50)
    copyBtn.BackgroundColor3 = Color3.fromRGB(35, 42, 60)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.Text = "Copy Place ID"
    copyBtn.TextColor3 = Color3.fromRGB(0, 230, 255)
    copyBtn.TextSize = 12
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 10)

    copyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(tostring(PlaceId))
                copyBtn.Text = "Copied to Clipboard!"
                copyBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            end
        end)
    end)

    task.delay(6, function()
        pcall(function() unsuppModal:Destroy() end)
        if getgenv then getgenv().CYBER_LOADER_RUNNING = nil end
    end)
end
