local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local PlaceId      = game.PlaceId

local CYBERHUB_LOGO_URL = "https://raw.githubusercontent.com/finzbae2123/Assets/refs/heads/main/Logo.png"

local Games = {
    [6911148748] = {
        Name    = "Car Driving Indonesia (Auto Farm)",
        Author  = "CyberHub Team",
        Version = "v0.0.0.3.",
        Url     = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua"
    },
    [110369730911937] = {
        Name    = "Car Driving Indonesia (Auto Farm)",
        Author  = "CyberHub Team",
        Version = "v0.0.0.3.",
        Url     = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua"
    },

    [14005966837] = {
        Name    = "Car Driving Indonesia (Minigame)",
        Author  = "CyberHub Team",
        Version = "v1.0",
        Url     = "https://luaegis.net/scripts/v4/loaders/f144231e-ba21-4667-9dfc-5f1826f6c83c.lua"
    },
    [132986577553100] = {
        Name    = "Car Driving Indonesia Race Nostalgia",
        Author  = "CyberHub Team",
        Version = "v1.0",
        Url     = "https://luaegis.net/scripts/v4/loaders/12ead4c7-c929-48e1-874d-91718eb30741.lua"
    },
}

local function createLiquidGlassNotification(titleText, gameName, authorText, versionText, statusType)
    local screenGui = CoreGui:FindFirstChild("CyberHubLoaderGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CyberHubLoaderGui"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() screenGui.Parent = CoreGui end)
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "LiquidGlassNotif"
    notifFrame.Size = UDim2.new(0, 340, 0, 85)
    -- AnchorPoint 0.5, 0 bikin dia presisi di tengah atas
    notifFrame.AnchorPoint = Vector2.new(0.5, 0)
    -- Posisi awal ngumpet di atas layar
    notifFrame.Position = UDim2.new(0.5, 0, 0, -150)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    notifFrame.BackgroundTransparency = 0.25
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 16)
    uiCorner.Parent = notifFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStroke.Thickness = 1.5
    uiStroke.Transparency = 0.2
    uiStroke.Color = Color3.fromRGB(0, 230, 255)
    uiStroke.Parent = notifFrame

    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 230, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 50, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 230, 255))
    })
    strokeGradient.Rotation = 45
    strokeGradient.Parent = uiStroke

    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 52, 0, 52)
    iconFrame.Position = UDim2.new(0, 14, 0.5, -26)
    iconFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    iconFrame.BackgroundTransparency = 0.4
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = notifFrame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 12)
    iconCorner.Parent = iconFrame

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0, 38, 0, 38)
    iconImg.Position = UDim2.new(0.5, -19, 0.5, -19)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = "rbxassetid://10734932975"
    iconImg.Parent = iconFrame

    task.spawn(function()
        pcall(function()
            if writefile and getcustomasset then
                if not isfile or not isfile("CyberHubLogo.png") then
                    local content = game:HttpGet(CYBERHUB_LOGO_URL)
                    if content and #content > 0 then
                        writefile("CyberHubLogo.png", content)
                    end
                end
                local asset = getcustomasset("CyberHubLogo.png")
                if asset and asset ~= "" then
                    iconImg.Image = asset
                end
            end
        end)
    end)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, 240, 0, 20)
    titleLbl.Position = UDim2.new(0, 78, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = titleText:upper()
    titleLbl.TextColor3 = Color3.fromRGB(0, 230, 255)
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notifFrame

    local gameLbl = Instance.new("TextLabel")
    gameLbl.Size = UDim2.new(0, 240, 0, 20)
    gameLbl.Position = UDim2.new(0, 78, 0, 32)
    gameLbl.BackgroundTransparency = 1
    gameLbl.Font = Enum.Font.GothamMedium
    gameLbl.Text = gameName
    gameLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    gameLbl.TextSize = 14
    gameLbl.TextXAlignment = Enum.TextXAlignment.Left
    gameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    gameLbl.Parent = notifFrame

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(0, 240, 0, 18)
    subLbl.Position = UDim2.new(0, 78, 0, 54)
    subLbl.BackgroundTransparency = 1
    subLbl.Font = Enum.Font.Gotham
    subLbl.Text = "By " .. authorText .. " • " .. versionText
    subLbl.TextColor3 = Color3.fromRGB(160, 175, 205)
    subLbl.TextSize = 11
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.Parent = notifFrame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(1, -28, 0, 3)
    accentBar.Position = UDim2.new(0, 14, 1, -8)
    accentBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notifFrame

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accentBar

    -- Target masuk: Drop down jadi 40 pixel dari atas layar (Tengah)
    local targetPos = UDim2.new(0.5, 0, 0, 40)
    local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = targetPos })
    tweenIn:Play()

    local progressTween = TweenService:Create(accentBar, TweenInfo.new(4.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 3) })
    progressTween:Play()

    task.delay(4.5, function()
        -- Target keluar: Naik lagi ke atas hilang dari layar
        local dismissPos = UDim2.new(0.5, 0, 0, -150)
        local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = dismissPos })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notifFrame:Destroy()
        end)
    end)
end

local config = Games[PlaceId]

if config then
    createLiquidGlassNotification("CyberHub Loader", config.Name, config.Author, config.Version, "success")
    print("Detected PlaceId: " .. tostring(PlaceId) .. " -> Loading " .. config.Name)

    task.wait(1.0)

    local success, err = pcall(function()
        loadstring(game:HttpGet(config.Url))()
    end)

    if not success then
        warn("CyberHub Loader Error Gagal memuat script: " .. tostring(err))
        createLiquidGlassNotification("Loader Error", "Failed to load script", config.Author, "Error", "error")
    end
else
    warn("CyberHub Loader PlaceID (" .. tostring(PlaceId) .. ") tidak terdaftar dalam database Games!")
    createLiquidGlassNotification("CyberHub Loader", "Game Not Supported!", "CyberHub Team", "PlaceID: " .. tostring(PlaceId), "error")
end