if getgenv and getgenv().CYBER_LOADER_RUNNING then
    warn("[Cyber Hub] Loader is already active in this session!")
    return
end
if getgenv then getgenv().CYBER_LOADER_RUNNING = true end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
local PlaceId = game.PlaceId

local CYBER_LOGO_URL = "https://raw.githubusercontent.com/finzbae2123/Assets/refs/heads/main/Logo.png"
local FALLBACK_ASSET_ID = "rbxassetid://10734932975"

local function getSafeGuiContainer()
    local container = nil
    pcall(function()
        if type(gethui) == "function" then
            container = gethui()
        elseif CoreGui then
            container = CoreGui
        end
    end)
    if not container then
        container = LocalPlayer:WaitForChild("PlayerGui", 5) or LocalPlayer.PlayerGui
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
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = ParentContainer end)

local GamesDatabase = {
    -- ============================================================
    -- 🚗 CAR DRIVING INDONESIA (CDID) UNIVERSE
    -- ============================================================
    [6911148748] = {
        Name = "Car Driving Indonesia",
        Scripts = {
            { 
                Title = "Auto Farm — Jawa Timur", 
                Desc = "Auto teleport & instant joiner to East Java", 
                Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" 
            },
            { 
                Title = "Quest Kemerdekaan — Bandung", 
                Desc = "Auto teleport & instant joiner to Bandung", 
                Url = "https://luaegis.net/scripts/v4/loaders/d0fbc6dc-49d7-433a-809b-86dd97ceae9c.lua" 
            },
            { 
                Title = "MyBCA Bank Courier — Jakarta", 
                Desc = "Auto ATM delivery, minigame solve & salary farm", 
                Url = "https://luaegis.net/scripts/v4/loaders/f4cc71e9-5ca1-4fff-89ef-c91019541832.lua" 
            }
        }
    },
    [110369730911937] = {
        Name = "CDID — Jawa Timur Places",
        Scripts = {
            { 
                Title = "Auto Farm", 
                Desc = "Money farm, job loops & vehicle tuning (Only in Jatim)", 
                Url = "https://luaegis.net/scripts/v4/loaders/fce37d22-de15-4881-817b-213efcf6bf20.lua" 
            }
        }
    },
    [132986577553100] = {
        Name = "CDID — v5 Places",
        Scripts = {
            { 
                Title = "CDID Race Nostalgia", 
                Desc = "Automated checkpoint runner for Nostalgic Racing", 
                Url = "https://luaegis.net/scripts/v4/loaders/12ead4c7-c929-48e1-874d-91718eb30741.lua" 
            },
            { 
                Title = "CDID Convoi Nostalgia", 
                Desc = "Automated route follower for Nostalgic Convoi", 
                Url = "https://luaegis.net/scripts/v4/loaders/082cea76-91d9-464c-8519-23813a08c2a3.lua" 
            }
        }
    },
    [14005966837] = {
        Name = "CDID — Jakarta Places",
        Scripts = {
            { 
                Title = "Minigame", 
                Desc = "Auto-solve skillchecks, QTEs & instant win", 
                Url = "https://luaegis.net/scripts/v4/loaders/f144231e-ba21-4667-9dfc-5f1826f6c83c.lua" 
            },
            {
                Title = "MyBCA Bank Quest", 
                Desc = "Auto ATM delivery, minigame solve & salary farm", 
                Url = "https://luaegis.net/scripts/v4/loaders/f4cc71e9-5ca1-4fff-89ef-c91019541832.lua" 
            }
        }
    },
    [79488788685813] = {
        Name = "CDID — Bandung Places",
        Scripts = {
            { 
                Title = "Cdid Quest Kemerdekaan", 
                Desc = "Auto Quest Kemerdekaan, instant skillcheck & QTE solver", 
                Url = "https://luaegis.net/scripts/v4/loaders/d0fbc6dc-49d7-433a-809b-86dd97ceae9c.lua" 
            }
        }
    },

    -- ============================================================
    -- 🏎️ DRAG & RACING GAMES
    -- ============================================================
    [131378148336503] = {
        Name = "Drag Drive Simulator",
        Scripts = {
            { 
                Title = "Auto Farm & Race Suite", 
                Desc = "Development build — High risk execution mode", 
                Url = "" 
            },
            { 
                Title = "Perfect Gear Shift & Auto Launch", 
                Desc = "0ms gear shifting assist with anti-spin traction", 
                Url = "" 
            }
        }
    },
    [3351674303] = {
        Name = "Driving Empire",
        Scripts = {
            { 
                Title = "Auto Farm Highway Race", 
                Desc = "Fast cash race looper with auto retry & safe anti-ban", 
                Url = "" 
            },
            { 
                Title = "Vehicle Physics & Fly Boost", 
                Desc = "Instant acceleration, handling tweak and velocity boost", 
                Url = "" 
            }
        }
    },

    -- ============================================================
    -- ⚔️ POPULAR ANIME & RPG GAMES
    -- ============================================================
    [2753915549] = {
        Name = "Blox Fruits (Sea 1 / First Sea)",
        Scripts = {
            { 
                Title = "Auto Farm Level & Mastery", 
                Desc = "Fast mob killer, auto quest and fruit sniper", 
                Url = "" 
            },
            { 
                Title = "Chest Teleport & ESP", 
                Desc = "Instant money chest pickup and fruit locator", 
                Url = "" 
            }
        }
    },
    [4442272183] = {
        Name = "Blox Fruits (Sea 2 / Second Sea)",
        Scripts = {
            { 
                Title = "Auto Raid & Factory Farm", 
                Desc = "Automated chip buyer, raid soloist and factory breaker", 
                Url = "" 
            },
            { 
                Title = "Auto Farm Level & Bosses", 
                Desc = "Auto quest, mob stacking and mastery leveling", 
                Url = "" 
            }
        }
    },
    [7449423635] = {
        Name = "Blox Fruits (Sea 3 / Third Sea)",
        Scripts = {
            { 
                Title = "Auto Mirage Island & Soul Guitar", 
                Desc = "Mirage tracker, gear finder and puzzle solver", 
                Url = "" 
            },
            { 
                Title = "Sea Beast & Pirate Raid Hunt", 
                Desc = "Boat auto driver with fast aimlock cannon & aura attack", 
                Url = "" 
            }
        }
    },
    [8737899170] = {
        Name = "Pet Simulator 99",
        Scripts = {
            { 
                Title = "Auto Area & Diamond Farm", 
                Desc = "Fast breakable aura, auto coin/gem pickup & zone unlocker", 
                Url = "" 
            },
            { 
                Title = "Auto Egg Hatch & Best Pet Equip", 
                Desc = "Unlimited fast hatch, fuse & mastery booster", 
                Url = "" 
            }
        }
    },
    [155615604] = {
        Name = "Prison Life",
        Scripts = {
            { 
                Title = "Universal God Mode & Kill All", 
                Desc = "Gun modding, instant respawn, loop kill criminals/cops", 
                Url = "" 
            },
            { 
                Title = "Auto Escape & Nexus Guns", 
                Desc = "Instant yard bypass and weapon dispenser teleport", 
                Url = "" 
            }
        }
    },
    [4924922222] = {
        Name = "Brookhaven RP",
        Scripts = {
            { 
                Title = "Troll Hub & Unlock All Vehicles", 
                Desc = "House controls, speed slider, bypass premium car passes", 
                Url = "" 
            }
        }
    },

    -- ============================================================
    -- 🌐 UNIVERSAL / FALLBACK HUB
    -- ============================================================
    [0] = {
        Name = "Universal Sandbox / Baseplate",
        Scripts = {
            { 
                Title = "Cyber Hub Universal Tools", 
                Desc = "Universal Fly, ESP, Noclip, Speed, and Infinite Jump", 
                Url = "" 
            }
        }
    }
}

local function applyCyberLogo(imageLabel)
    if not imageLabel then return end
    imageLabel.Image = FALLBACK_ASSET_ID

    task.spawn(function()
        pcall(function()
            if writefile and isfile and readfile and getcustomasset then
                if not isfile("CyberHubLogo.png") then
                    local content = game:HttpGet(CYBER_LOGO_URL)
                    if content and #content > 0 then
                        writefile("CyberHubLogo.png", content)
                    end
                end
                if isfile("CyberHubLogo.png") then
                    imageLabel.Image = getcustomasset("CyberHubLogo.png")
                end
            end
        end)
    end)
end

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
    frame.BackgroundTransparency = 0.20
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
    applyCyberLogo(logoImg)

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
            { Target = 30,  Text = "Verifying HWID" },
            { Target = 40,  Text = "Verifying Profile" },
            { Target = 50,  Text = "Decrypting Payload" },
            { Target = 60,  Text = "Checking Environment" },
            { Target = 70,  Text = "Bypassing Security" },
            { Target = 80,  Text = "Loading Modules" },
            { Target = 90,  Text = "Injecting Interface" },
            { Target = 100, Text = "Ready, Loading UI..." }
        }

        local currentPct = 0
        local payload = nil

        for idx, step in ipairs(steps) do
            statusLbl.Text = step.Text
            TweenService:Create(fillFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(step.Target / 100, 0, 1, 0) }):Play()

            if idx == 4 then
                task.spawn(function()
                    payload = safeFetchScript(scriptUrl, 3)
                end)
            end

            for p = currentPct + 1, step.Target do
                percentLbl.Text = p .. "%"
                task.wait(0.08)
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
        end)

        local fn, compileErr = loadstring(payload)
        if fn then
            pcall(fn)
        else
            warn("[Cyber Hub] Loader Compile Error: " .. tostring(compileErr))
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
    bgLogo.ZIndex = 1
    applyCyberLogo(bgLogo)

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
    descLbl.Text = string.format("%d options available for this game. Select to execute:", totalScripts)
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
        btn.BackgroundTransparency = 0.30
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.LayoutOrder = idx
        btn.Text = ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Thickness = 1.2
        btnStroke.Transparency = 0.40
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
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.10 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), { Transparency = 0.00 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.30 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), { Transparency = 0.40 }):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            animateOutModal(selectModal, targetSize, isCanvasGroup, function()
                showLoadingScreen(scriptData.Title, scriptData.Url)
            end)
        end)
    end

    animateInModal(selectModal, targetSize, isCanvasGroup)
end

local function showUnsupportedModal()
    local unsuppModal, targetSize, isCanvasGroup = createLiquidGlassFrame(ScreenGui, UDim2.new(0, 380, 0, 160))

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
    dLbl.Text = "Place ID (" .. tostring(PlaceId) .. ") is currently not supported in the Cyber Hub database."
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

    animateInModal(unsuppModal, targetSize, isCanvasGroup)

    task.delay(6, function()
        animateOutModal(unsuppModal, targetSize, isCanvasGroup, function()
            if getgenv then getgenv().CYBER_LOADER_RUNNING = nil end
        end)
    end)
end

local gameConfig = GamesDatabase[PlaceId] or GamesDatabase[0]

if gameConfig then
    if #gameConfig.Scripts > 1 then
        showSelectionModal(gameConfig)
    else
        local singleScript = gameConfig.Scripts[1]
        showLoadingScreen(singleScript.Title, singleScript.Url)
    end
else
    showUnsupportedModal()
end