local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local Players      = game:GetService("Players")
local PlaceId      = game.PlaceId

local CYBERHUB_LOGO_URL = "https://raw.githubusercontent.com/finzbae2123/Assets/refs/heads/main/Logo.png"

local Games = {
    [6911148748]        = { Name = LGS_ScriptName, Version = LGS_ScriptVersion, Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" },
    [110369730911937]   = { Name = LGS_ScriptName, Version = LGS_ScriptVersion, Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" },
    [14005966837]       = { Name = LGS_ScriptName, Version = LGS_ScriptVersion, Url = "https://luaegis.net/scripts/v4/loaders/f144231e-ba21-4667-9dfc-5f1826f6c83c.lua" },
    [132986577553100]   = { Name = LGS_ScriptName, Version = LGS_ScriptVersion, Url = "https://luaegis.net/scripts/v4/loaders/12ead4c7-c929-48e1-874d-91718eb30741.lua" }
}

local function createNotification(title, desc, subDesc, duration)
    local screenGui = CoreGui:FindFirstChild("CyberHubLoaderGui") or Instance.new("ScreenGui")
    screenGui.Name = "CyberHubLoaderGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Safe mounting: prioritize gethui(), fallback to CoreGui, fallback to PlayerGui
    local targetGui = (gethui and gethui()) or CoreGui
    local success = pcall(function() screenGui.Parent = targetGui end)
    if not success or not screenGui.Parent then
        pcall(function() screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end)
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "LiquidGlassNotif"
    notifFrame.Size = UDim2.new(0, 340, 0, 85)
    notifFrame.AnchorPoint = Vector2.new(0.5, 0)
    notifFrame.Position = UDim2.new(0.5, 0, 0, -150)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    notifFrame.BackgroundTransparency = 0.25
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = screenGui

    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Color = Color3.fromRGB(0, 230, 255)

    local gradient = Instance.new("UIGradient", stroke)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 230, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 50, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 230, 255))
    })
    gradient.Rotation = 45

    local iconFrame = Instance.new("Frame", notifFrame)
    iconFrame.Size = UDim2.new(0, 52, 0, 52)
    iconFrame.Position = UDim2.new(0, 14, 0.5, -26)
    iconFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    iconFrame.BackgroundTransparency = 0.4
    iconFrame.BorderSizePixel = 0
    Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 12)

    local iconImg = Instance.new("ImageLabel", iconFrame)
    iconImg.Size = UDim2.new(0, 38, 0, 38)
    iconImg.Position = UDim2.new(0.5, -19, 0.5, -19)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = "rbxassetid://10734932975"

    task.spawn(function()
        pcall(function()
            -- Secured API checks
            if writefile and getcustomasset and isfile then
                if not isfile("CyberHubLogo.png") then
                    local content = game:HttpGet(CYBERHUB_LOGO_URL)
                    if content and content ~= "" then 
                        writefile("CyberHubLogo.png", content) 
                    end
                end
                iconImg.Image = getcustomasset("CyberHubLogo.png") or iconImg.Image
            end
        end)
    end)

    local function createText(yPos, font, text, color, size)
        local lbl = Instance.new("TextLabel", notifFrame)
        lbl.Size = UDim2.new(0, 240, 0, 20)
        lbl.Position = UDim2.new(0, 78, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.Font = font
        lbl.Text = text
        lbl.TextColor3 = color
        lbl.TextSize = size
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        return lbl
    end

    createText(12, Enum.Font.GothamBold,   title:upper(), Color3.fromRGB(0, 230, 255),  13)
    createText(32, Enum.Font.GothamMedium, desc,          Color3.fromRGB(240, 245, 255),14)
    createText(54, Enum.Font.Gotham,       subDesc,       Color3.fromRGB(160, 175, 205),11)

    local accentBar = Instance.new("Frame", notifFrame)
    accentBar.Size = UDim2.new(1, -28, 0, 3)
    accentBar.Position = UDim2.new(0, 14, 1, -8)
    accentBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
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

local config = Games[PlaceId]

if config then
    local safeName = config.Name or "Enter Key"
    local safeVersion = config.Version or "Enter Key Pls"
    
    createNotification("CyberHub Loader", tostring(safeName), "By CyberHub Team • " .. tostring(safeVersion), 4.5)
    task.wait(0.5)

    -- Decoupled fetch, compile, and execute for exact error handling
    local scriptData = nil
    local httpSuccess, httpErr = pcall(function()
        scriptData = game:HttpGet(config.Url)
    end)

    if not httpSuccess or not scriptData then
        warn("CyberHub Network Error: " .. tostring(httpErr))
        createNotification("Network Error", "Failed to fetch script", "Check connection/URL", 5.0)
        return
    end

    local loadedFunc, compileErr = loadstring(scriptData)
    if not loadedFunc then
        warn("CyberHub Compile Error: " .. tostring(compileErr))
        createNotification("Compile Error", "Script syntax invalid", "Server returned bad data", 5.0)
        return
    end

    local execSuccess, execErr = pcall(loadedFunc)
    if not execSuccess then
        warn("CyberHub Execution Error: " .. tostring(execErr))
        createNotification("Execution Error", "Script crashed on launch", "Check console", 5.0)
    end
else
    warn("CyberHub Loader: Unregistered PlaceID -> " .. tostring(PlaceId))
    createNotification("Game Not Supported!", "Place ID is not in database", "PlaceID: " .. tostring(PlaceId), 5.0)
end
