function AddGradientStroke(parent)
    local stroke = Create("UIStroke", {
        Parent = parent,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 0.6,
        Transparency = 0.6,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    Create("UIGradient", {
        Parent = stroke,
        Color = ColorSequence.new(Color3.fromRGB(200, 0, 0), Color3.fromRGB(0, 0, 0)),
        Rotation = 90,
        Transparency = NumberSequence.new(0.6)
    })
    return stroke
end

function Library:CreateWindow(cfg)
local ScreenGui = Create("ScreenGui", {
    Name = "LUNARUI",
    Parent = gethui(),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})
    
    local MaoMain = Create("Frame", {
        Name = "MaoMain", 
        Parent = ScreenGui, 
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
        BackgroundTransparency = 0.1,
        Position = UDim2.new(0.5, -338, 0.5, -197), 
        Size = UDim2.new(0, 640, 0, 370), 
        Active = true,
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MaoMain})
Create("UIGradient", {
    Parent = MaoMain,
    Color = ColorSequence.new(
        Color3.fromRGB(200, 0, 0),
        Color3.fromRGB(10, 10, 10),
        Color3.fromRGB(12, 12, 12),
        Color3.fromRGB(14, 14, 14),
        Color3.fromRGB(0, 0, 0)
    ),
    Rotation = 260,
    Transparency = NumberSequence.new(0.25)
})
MaoMain.ClipsDescendants = false

    -- Drag Handle
    -- [[ FIXED DRAG LOGIC ]]
local DragHandle = Create("Frame", {
    Name = "DragHandle",
    Parent = MaoMain, 
    Size = UDim2.new(1, 0, 0, 50), 
    BackgroundTransparency = 1, 
    ZIndex = 1000 -- Make this very high so nothing overlaps it
})

local dragging, dragInput, dragStart, startPos

function update(input)
    local delta = input.Position - dragStart
    MaoMain.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MaoMain.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DragHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)


    -- Header
    local TopTitle = Create("TextLabel", {Parent = MaoMain, Text = cfg.Title or "Mao Hub", Position = UDim2.new(0, 20, 0, 15), Size = UDim2.new(0, 100, 0, 20), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = 0, BackgroundTransparency = 1, ZIndex = 101})
    local SubTitle = Create("TextLabel", {Parent = MaoMain, Text = cfg.Subtitle or "Elite Build v8.0", Position = UDim2.new(0, 20, 0, 32), Size = UDim2.new(0, 100, 0, 20), TextColor3 = Color3.fromRGB(100, 100, 100), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = 0, BackgroundTransparency = 1, ZIndex = 101})
    local Close = Create("TextButton", {Parent = MaoMain, Text = "X", Position = UDim2.new(1, -35, 0, 15), Size = UDim2.new(0, 25, 0, 25), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 0, 0), Font = Enum.Font.GothamBold, TextSize = 22, ZIndex = 102})
    Close.MouseButton1Click:Connect(function()
 ScreenGui:Destroy() 
 game:GetService("CoreGui"):WaitForChild("Mao"):Destroy()
end)

    --- ðŸ’Š SIDEBAR
    local SideBar = Create("Frame", {Parent = MaoMain, Size = UDim2.new(0, 45, 0, 180), Position = UDim2.new(0, 15, 0.5, -15), BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(25, 25, 25), ZIndex = 50})
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SideBar})
    local HomeBtn = Create("ImageButton", {Parent = SideBar, Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0.5, -12, 0, 25), BackgroundTransparency = 1, Image = "rbxassetid://13060262529", ZIndex = 51})
    local LibBtn = Create("ImageButton", {Parent = SideBar, Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0.5, -12, 0, 80), BackgroundTransparency = 1, Image = "rbxassetid://121192820778837", ZIndex = 51})
    local SetBtn = Create("ImageButton", {Parent = SideBar, Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0.5, -12, 0, 135), BackgroundTransparency = 1, Image = "rbxassetid://74133076168703", ImageColor3 = Color3.fromRGB(255, 120, 120), ZIndex = 51})
local DiscordBtn = Create("ImageButton", {
    Parent = MaoMain, 
    Size = UDim2.new(0, 35, 0, 35), 
    Position = UDim2.new(0, 21, 0, 60), 
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    Image = "rbxassetid://73132811772878", 
    BackgroundTransparency = 1,
    ZIndex = 51
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = DiscordBtn})

local AudioBtn = Create("ImageButton", {
    Parent = MaoMain, 
    Size = UDim2.new(0, 35, 0, 35), 
    Position = UDim2.new(0, 21, 0, 115), 
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    Image = "rbxassetid://7059338404", 
    BackgroundTransparency = 1,
    ZIndex = 51
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = AudioBtn})

DiscordBtn.MouseButton1Click:Connect(function() 
    setclipboard(discord)
end)

AudioBtn.MouseButton1Click:Connect(function() 
    if game:GetService("CoreGui"):WaitForChild("Mao"):WaitForChild("MaoHub_V3").Visible == true then
    CloseAudio()
    elseif game:GetService("CoreGui"):WaitForChild("Mao"):WaitForChild("MaoHub_V3").Visible == false then
       OpenAudio()
    end
end)




    --- ðŸ“‘ PAGES
    local HomePage = Create("CanvasGroup", {Parent = MaoMain, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = true})
    local LibPage = Create("CanvasGroup", {Parent = MaoMain, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, GroupTransparency = 1})

    -- [INSERT HOME TAB SCRIPT 2 LOGIC HERE - UNTOUCHED]
        -- HOME PAGE CONTENT (SCRIPT 2)
    function CreateGradLine2(text, yPos)
        local l = Create("TextLabel", {Parent = HomePage, Text = text, Size = UDim2.new(0, 300, 0, 35), Position = UDim2.new(0, 85, 0, yPos), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 34, BackgroundTransparency = 1, TextXAlignment = 0})
    end
    function CreateGradLine(text, yPos)
        local l = Create("TextLabel", {Parent = HomePage, Text = text, Size = UDim2.new(0, 300, 0, 35), Position = UDim2.new(0, 85, 0, yPos), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 34, BackgroundTransparency = 1, TextXAlignment = 0})
        Create("UIGradient", {Parent = l, Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(160, 25, 25))})
    end
    --CreateGradLine2("Welcome to", 60)
    --CreateGradLine("Lunar Eclipse.", 93)
    --CreateGradLine("Lunar Eclipse ", 126)
    --Create("TextLabel", {Parent = HomePage, Text = "This UI is inspired by Chakra UI, the website\none not whatever roblox exploit.", Size = UDim2.new(0, 300, 0, 40), Position = UDim2.new(0, 85, 0, 160), TextColor3 = Color3.fromRGB(180, 180, 180), Font = Enum.Font.Gotham, TextSize = 11, BackgroundTransparency = 1, TextXAlignment = 0})
    local Beta = Create("TextLabel", {Parent = HomePage, Text = "This is still in beta test", Size = UDim2.new(0, 150, 0, 18), Position = UDim2.new(0, 85, 0, 200), BackgroundColor3 = Color3.fromRGB(60, 5, 5), TextColor3 = Color3.fromRGB(255, 50, 50), Font = Enum.Font.GothamBold, TextSize = 10, ZIndex = 2})
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Beta})
    
--
-- JIAXI CHUN ICON
    IconFace = Create("ImageLabel", {Parent = HomePage, Size = UDim2.new(0, 500, 0, 500), Position = UDim2.new(1, -680, 0, 0), ZIndex = 0, BackgroundTransparency = 1, Image = "rbxassetid://113704398157686", ImageTransparency = 0.6, ScaleType = Enum.ScaleType.Crop})
    
local RunService = game:GetService("RunService")
local basePos = IconFace.Position
local lastParentPos = IconFace.Parent.AbsolutePosition
local velocity = Vector2.new(0,0)
local stiffness = 2.5
local damping = 0.3

RunService.RenderStepped:Connect(function(dt)
    local parentDelta = IconFace.Parent.AbsolutePosition - lastParentPos
    lastParentPos = IconFace.Parent.AbsolutePosition

    local force = Vector2.new(parentDelta.X, parentDelta.Y) * stiffness
    velocity = (velocity + force) * damping

    IconFace.Position = UDim2.new(
        basePos.X.Scale,
        basePos.X.Offset + velocity.X,
        basePos.Y.Scale,
        basePos.Y.Offset + velocity.Y
    )
end)

IconFace2 = Create("ImageLabel", {Parent = LibPage, Size = UDim2.new(0, 500, 0, 500), Position = UDim2.new(1, -680, 0, 0), ZIndex = 0, BackgroundTransparency = 1, Image = "rbxassetid://113704398157686", ImageTransparency = 0.8, ScaleType = Enum.ScaleType.Crop})
    
local RunService = game:GetService("RunService")
local basePos = IconFace2.Position
local lastParentPos = IconFace2.Parent.AbsolutePosition
local velocity = Vector2.new(0,0)
local stiffness = 2.5
local damping = 0.3

RunService.RenderStepped:Connect(function(dt)
    local parentDelta = IconFace2.Parent.AbsolutePosition - lastParentPos
    lastParentPos = IconFace2.Parent.AbsolutePosition

    local force = Vector2.new(parentDelta.X, parentDelta.Y) * stiffness
    velocity = (velocity + force) * damping

    IconFace2.Position = UDim2.new(
        basePos.X.Scale,
        basePos.X.Offset + velocity.X,
        basePos.Y.Scale,
        basePos.Y.Offset + velocity.Y
    )
end)
--


    function MakeCard(name, pos, size)
    local c = Create("Frame", {Parent = HomePage, Size = size, Position = pos, BackgroundTransparency = 0.4, BackgroundColor3 = Color3.new(1,1,1)})
    local grad = Create("UIGradient", {
        Name = "CardGradient", -- Added name for detection
        Parent = c, 
        Rotation = 90, 
        Color = ColorSequence.new(Color3.fromRGB(45, 5, 5), Color3.fromRGB(10, 10, 10))
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = c})
    return c
end
function MakeCard2(name, pos, size)
    local c = Create("Frame", {
        Parent = HomePage,
        Size = size,
        Position = pos,
        BackgroundTransparency = 0.4,
        BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = c
    })

    return c
end



    local GCard = MakeCard("Greetings", UDim2.new(0, 85, 0, 235), UDim2.new(0, 175, 0, 50))
    local Pfp = Create("ImageLabel", {Parent = GCard, Size = UDim2.new(0, 35, 0, 35), Position = UDim2.new(0, 10, 0.5, -17), Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)}); Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Pfp})
    Create("TextLabel", {Parent = GCard, Text = "Greetings,\n(" .. lp.Name .. ")", Size = UDim2.new(1, -55, 1, 0), Position = UDim2.new(0, 50, 0, 0), BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = 0})
     
     local CRCard = MakeCard("Credits", UDim2.new(0, 450, 0, 175), UDim2.new(0, 175, 0, 55))
    Create("TextLabel", {Parent = CRCard, Text = "Credits", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 5), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, BackgroundTransparency = 1, TextXAlignment = 0})
    Create("TextLabel", {Parent = CRCard, Text = "Owner: Maoxzy\nUI Deisgner: SkyGamer90867", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 22), TextColor3 = Color3.fromRGB(150, 150, 150), Font = Enum.Font.Gotham, TextSize = 10, BackgroundTransparency = 1, TextXAlignment = 0})
    
     local JCard = MakeCard("JOOO", UDim2.new(0, 450, 0, 120), UDim2.new(0, 175, 0, 50))
    Create("TextLabel", {Parent = JCard, Text = ":D", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 5), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, BackgroundTransparency = 1, TextXAlignment = 0})
    Create("TextLabel", {Parent = JCard, Text = "Thank you for using!", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 22), TextColor3 = Color3.fromRGB(150, 150, 150), Font = Enum.Font.Gotham, TextSize = 10, BackgroundTransparency = 1, TextXAlignment = 0})
    
    local Vruh = MakeCard2("hhh", UDim2.new(0, 85, 0, 50), UDim2.new(0, 60, 0, 30))
    Create("TextLabel", {Parent = Vruh, Text = "v1.02", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 5), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, BackgroundTransparency = 1, TextXAlignment = 0})
    
    local Gago = MakeCard2("hHHSSShh", UDim2.new(0, 155, 0, 50), UDim2.new(0, 140, 0, 30))
    Create("TextLabel", {Parent = Gago, Text = "Non-Beta Mode", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 5), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, BackgroundTransparency = 1, TextXAlignment = 0})
    
    local ICard = Create("Frame", {Parent = HomePage, Size = UDim2.new(0, 175, 0, 55), Position = UDim2.new(0, 85, 0, 290), BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(5, 5, 5)}); Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ICard})
    Create("TextLabel", {Parent = ICard, Text = "Information", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 10), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, BackgroundTransparency = 1, TextXAlignment = 0})
    Create("TextLabel", {Parent = ICard, Text = "Place Id: " .. game.PlaceId .. "\nPlayers: " .. #Players:GetPlayers(), Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 22), TextColor3 = Color3.fromRGB(150, 150, 150), Font = Enum.Font.Gotham, TextSize = 10, BackgroundTransparency = 1, TextXAlignment = 0})

    local DCard = MakeCard("Discord", UDim2.new(0, 270, 0, 235), UDim2.new(0, 185, 0, 110))
    Create("TextLabel", {Parent = DCard, Text = "Join Discord", Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 13), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 16, BackgroundTransparency = 1, TextXAlignment = 0})
    Create("TextLabel", {Parent = DCard, Text = "Join our exclusive discord server for help if needed. If bugs occur.", Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 25), TextColor3 = Color3.fromRGB(140, 140, 140), Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true, BackgroundTransparency = 1, TextXAlignment = 0})
    local JBtn = Create("TextButton", {Parent = DCard, Text = "Join", Size = UDim2.new(0, 95, 0, 30), Position = UDim2.new(0, 10, 1, -40), BackgroundColor3 = Color3.fromRGB(255, 60, 60), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 14}); Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = JBtn})
    JBtn.MouseButton1Click:Connect(function() 
    setclipboard(discord)
    end)

    local Insp = MakeCard("Inspired", UDim2.new(0, 465, 0, 235), UDim2.new(0, 160, 0, 110))
    Create("TextLabel", {Parent = Insp, Text = "Inspired", Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 10), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 16, BackgroundTransparency = 1, TextXAlignment = 0})
    Create("TextLabel", {Parent = Insp, Text = "This UI Design is inspired off Chakra UI! The cards beneath are inspired from Sirius and DoMaoMainX!", Size = UDim2.new(1, -20, 0, 50), Position = UDim2.new(0, 10, 0, 20), TextColor3 = Color3.fromRGB(140, 140, 140), Font = Enum.Font.Gotham, TextSize = 9, TextWrapped = true, BackgroundTransparency = 1, TextXAlignment = 0})
    Create("TextLabel", {Parent = Insp, Text = "Inspired from: shlexware & Chakra UI!", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 1, -38), TextColor3 = Color3.fromRGB(220, 0, 0), Font = Enum.Font.GothamBold, TextSize = 10, TextWrapped = true, BackgroundTransparency = 1, TextXAlignment = 0})

    -- LIBRARY PAGE CONTENT (SCRIPT 1 - SHIFTED)
    local TabHolder = Create("ScrollingFrame", {
    Parent = LibPage,
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    Position = UDim2.new(0, 75, 0, 55),
    Size = UDim2.new(0, 500, 0, 30),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.X,
    ScrollBarThickness = 0,
    ScrollingDirection = Enum.ScrollingDirection.X
})

Create("UIListLayout", {
    Parent = TabHolder,
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})
    Create("Frame", {Parent = LibPage, Position = UDim2.new(0, 70, 0, 90), Size = UDim2.new(1, -85, 0, 1), BackgroundColor3 = Color3.fromRGB(200, 0, 0), BorderSizePixel = 0})
    
    local SearchFrame = Create("Frame", {Parent = LibPage, BackgroundTransparency = 1, Position = UDim2.new(0, 75, 0, 100), Size = UDim2.new(1, -95, 0, 30)}); Create("UICorner", {Parent = SearchFrame});
    local SearchInput = Create("TextBox", {Parent = SearchFrame, BackgroundTransparency = 1, Size = UDim2.new(1, -35, 1, 0), Text = "", PlaceholderText = "Search...", TextColor3 = Color3.fromRGB(200, 0, 0), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = 0})
    AddGradientStroke(SearchInput); Create("UIPadding", {Parent = SearchInput, PaddingLeft = UDim.new(0, 10)})
    
    -- Search Bar
    local SearchFrame = Create("Frame", {Parent = LibPage, BackgroundTransparency = 1, Position = UDim2.new(0, 75, 0, 100), Size = UDim2.new(1, -95, 0, 30)})
    local SearchInput = Create("TextBox", {Parent = SearchFrame, BackgroundTransparency = 1, Size = UDim2.new(1, -35, 1, 0), Text = "", PlaceholderText = "Search...", TextColor3 = Color3.fromRGB(200, 0, 0), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = 0})
    AddGradientStroke(SearchInput); Create("UIPadding", {Parent = SearchInput, PaddingLeft = UDim.new(0, 10)}); Create("UICorner", {Parent = SearchInput});
    local SearchBtn = Create("ImageButton", {Parent = SearchFrame, Image = "rbxassetid://118685771787843", Position = UDim2.new(1, -30, 0, 0), Size = UDim2.new(0, 30, 0, 30), BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    Create("UICorner", {Parent = SearchBtn}); AddGradientStroke(SearchBtn)

    local Container = Create("Frame", {Parent = LibPage, BackgroundTransparency = 1, Position = UDim2.new(0, 70, 0, 140), Size = UDim2.new(1, -85, 1, -155)})
    local Tabs, AllElements = {}, {}

    -- Smooth Switching Logic
    function Switch(to)
        local isHome = (to == HomePage)
        HomePage.Visible = true; LibPage.Visible = true
        TweenService:Create(HomePage, TweenInfo.new(0.3), {GroupTransparency = isHome and 0 or 1}):Play()
        TweenService:Create(LibPage, TweenInfo.new(0.3), {GroupTransparency = isHome and 1 or 0}):Play()
        task.delay(0.3, function() HomePage.Visible = isHome; LibPage.Visible = not isHome end)
    end
    HomeBtn.MouseButton1Click:Connect(function() Switch(HomePage) end)
    LibBtn.MouseButton1Click:Connect(function() Switch(LibPage) end)
    SetBtn.MouseButton1Click:Connect(function() print("AI CHATBOT IS ON") end)
    
    function Tabs:CreateTab(tcfg)
local TabBtn = Create("TextButton", {
    Parent = TabHolder, 
    Text = "", 
    BackgroundColor3 = Color3.fromRGB(150, 0, 0), 
    BackgroundTransparency = 1, 
    Size = UDim2.new(0, 110, 0, 30)
})

Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

local TabIcon = Create("ImageLabel", {
    Parent = TabBtn,
    Position = UDim2.new(0, 8, 0.5, -8),
    Size = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    Image = tcfg.Icon or "rbxassetid://0",
    ImageColor3 = Color3.fromRGB(200, 200, 200)
})

Create("TextLabel", {
    Parent = TabBtn, 
    Text = tcfg.Title, 
    TextColor3 = Color3.fromRGB(200, 200, 200), 
    Font = Enum.Font.GothamBold, 
    TextSize = 11, 
    BackgroundTransparency = 1, 
    Size = UDim2.new(1, -30, 1, 0), 
    Position = UDim2.new(0, 30, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left
})

local Page = Create("Frame", {Parent = Container, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false})

local L = Create("ScrollingFrame", {
    Parent = Page,
    Size = UDim2.new(0.49, 0, 1, 0),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 0
})

local R = Create("ScrollingFrame", {
    Parent = Page,
    Position = UDim2.new(0.51, 0, 0, 0),
    Size = UDim2.new(0.49, 0, 1, 0),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 0
})

Create("UIListLayout", {Parent = L, Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center})
Create("UIListLayout", {Parent = R, Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center})

TabBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(TabHolder:GetChildren()) do
        if v:IsA("TextButton") then
            v.BackgroundTransparency = 1
        end
    end
    for _, v in pairs(Container:GetChildren()) do
        if v:IsA("Frame") then
            v.Visible = false
        end
    end
    TabBtn.BackgroundTransparency = 0.6
    Page.Visible = true
end)

    local Sections = {}
    function Sections:CreateSection(scfg)
        local Side = scfg.Alignment == "Right" and R or L
        
        -- Main Section Wrapper
        local SectionWrapper = Create("Frame", {
            Parent = Side,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {Parent = SectionWrapper, Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center})

        local SectFrame = Create("Frame", {Parent = SectionWrapper, Size = UDim2.new(0.95, 0, 0, 45), BackgroundTransparency = 1})
        
        function ThickLine(pos, rot)
            local l = Create("Frame", {Parent = SectFrame, Position = pos, Size = UDim2.new(0.3, 0, 0.3, 2), BackgroundTransparency = 0.5, BorderSizePixel = 0})
            Create("UIGradient", {Rotation = rot, Color = ColorSequence.new(Color3.fromRGB(150,0,0), Color3.fromRGB(12,12,12)), Parent = l})
            Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = l})
        end
        ThickLine(UDim2.new(0,0,0.5,0), 0); ThickLine(UDim2.new(0.7,0,0.5,0), 180)
        Create("TextLabel", {Parent = SectFrame, Text = scfg.Title, Font = Enum.Font.GothamBold, TextColor3 = Color3.new(1,1,1), Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextSize = 13})

        local Elements = {}
        
        function Elements:CreateToggle(tcfg)
    local Tgl = Create("TextButton", {
        Parent = SectionWrapper,
        Size = UDim2.new(0.92, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BackgroundTransparency = 0.6,
        Text = ""
    })
    Create("UICorner", {Parent = Tgl})
    AddGradientStroke(Tgl)

    Create("TextLabel", {
        Parent = Tgl,
        Text = tcfg.Name,
        TextColor3 = Color3.new(0.9,0.9,0.9),
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12
    })

    local Bg = Create("Frame", {
        Parent = Tgl,
        Position = UDim2.new(1, -45, 0.5, -9),
        Size = UDim2.new(0, 34, 0, 18),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    })
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Bg})

    local Dot = Create("Frame", {
        Parent = Bg,
        Position = UDim2.new(0, 2, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Color3.new(1,1,1)
    })
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Dot})

    local State = tcfg.Default or false

    function Sync()
        TweenService:Create(Dot, TweenInfo.new(0.2), {
            Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()

        TweenService:Create(Bg, TweenInfo.new(0.2), {
            BackgroundColor3 = State and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(60, 60, 60)
        }):Play()
    end

    Tgl.MouseButton1Click:Connect(function()
        State = not State
        Sync()
        if tcfg.Callback then
            tcfg.Callback(State)
        end
    end)

    -- Apply default state on load
    Sync()
    if State and tcfg.Callback then
        tcfg.Callback(State)
    end

    return {
        Set = function(val)
            State = val
            Sync()
            if tcfg.Callback then
                tcfg.Callback(State)
            end
        end,
        Get = function()
            return State
        end
    }
end

        function Elements:CreateButton(bcfg)
            local Btn = Create("TextButton", {Parent = SectionWrapper, Size = UDim2.new(0.92, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(18, 18, 18), BackgroundTransparency = 0.6, Text = bcfg.Name, TextColor3 = Color3.new(0.9,0.9,0.9), TextXAlignment = 0, Font = Enum.Font.Gotham, TextSize = 12})
            Create("UICorner", {Parent = Btn}); AddGradientStroke(Btn); Create("UIPadding", {PaddingLeft = UDim.new(0, 12), Parent = Btn})
            Btn.MouseButton1Click:Connect(bcfg.Callback)
        end

        
        function Elements:CreateDropdown(dcfg)
    local Multi = dcfg.Multi or false
    local Selected = {}
    local OptionHeight = 32 
    local MaxHeight = 160

    local Drop = Create("Frame", {
        Parent = SectionWrapper,
        Size = UDim2.new(0.92, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BackgroundTransparency = 0.6,
        ZIndex = 5
    })
    Create("UICorner", {Parent = Drop})
    AddGradientStroke(Drop)

    Create("TextLabel", {
        Parent = Drop,
        Text = dcfg.Name,
        TextColor3 = Color3.new(0.9, 0.9, 0.9),
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12
    })

    local SelBtn = Create("TextButton", {
        Parent = Drop,
        Position = UDim2.new(1, -110, 0.5, -12),
        Size = UDim2.new(0, 100, 0, 24),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        Text = "Select",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        ClipsDescendants = true,
        ZIndex = 6,
        Active = true -- Ensure button is clickable
    })
    Create("UICorner", {Parent = SelBtn, CornerRadius = UDim.new(0, 6)})

    local ListContainer = Create("Frame", {
        Parent = MaoMain, -- Ensure MaoMain is a Top-Level ScreenGui or a high-level container
        Size = UDim2.new(0, 110, 0, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 100,
        Active = true
    })
    Create("UICorner", {Parent = ListContainer})
    AddGradientStroke(ListContainer)

    local List = Create("ScrollingFrame", {
        Parent = ListContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, #dcfg.Options * OptionHeight),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
        ZIndex = 101,
        Active = true
    })
    Create("UIListLayout", {
        Parent = List,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    local function UpdateText()
        if Multi then
            SelBtn.Text = #Selected == 0 and "Select" or table.concat(Selected, ", ")
        else
            SelBtn.Text = Selected[1] or "Select"
        end
    end

    -- Toggle Dropdown
    SelBtn.MouseButton1Click:Connect(function()
        ListContainer.Visible = not ListContainer.Visible
        if ListContainer.Visible then
            -- Refresh position in case the menu moved
            ListContainer.Position = UDim2.new(
                0, (SelBtn.AbsolutePosition.X - MaoMain.AbsolutePosition.X),
                0, (SelBtn.AbsolutePosition.Y - MaoMain.AbsolutePosition.Y) + 28
            )
            local targetHeight = math.min(#dcfg.Options * OptionHeight, MaxHeight)
            ListContainer.Size = UDim2.new(0, 110, 0, targetHeight)
        end
    end)

    for _, opt in pairs(dcfg.Options) do
        local OBtn = Create("TextButton", {
            Parent = List,
            Size = UDim2.new(1, 0, 0, OptionHeight - 2),
            BackgroundTransparency = 1,
            Text = opt,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            Font = Enum.Font.Gotham,
            TextSize = 11,
            ZIndex = 105, -- Higher than container
            Active = true
        })

        OBtn.MouseButton1Click:Connect(function()
            if Multi then
                local found = table.find(Selected, opt)
                if found then 
                    table.remove(Selected, found) 
                else 
                    table.insert(Selected, opt) 
                end
            else
                Selected = {opt}
                ListContainer.Visible = false
            end
            
            UpdateText()
            if dcfg.Callback then 
                dcfg.Callback(Multi and Selected or Selected[1]) 
            end
        end)
    end

    -- Default logic
    if dcfg.Default then
        if Multi then
            local defs = typeof(dcfg.Default) == "table" and dcfg.Default or {dcfg.Default}
            for _, v in pairs(defs) do table.insert(Selected, v) end
        else
            Selected[1] = typeof(dcfg.Default) == "table" and dcfg.Default[1] or dcfg.Default
        end
        UpdateText()
    end

    return {
        Get = function() return Multi and Selected or Selected[1] end,
        Set = function(val)
            Selected = (Multi and typeof(val) == "table") and val or {val}
            UpdateText()
            if dcfg.Callback then dcfg.Callback(Multi and Selected or Selected[1]) end
        end
    }
end


        
        function Elements:CreateInput(icfg)
            local Inf = Create("Frame", {Parent = SectionWrapper, Size = UDim2.new(0.92, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(18, 18, 18), BackgroundTransparency = 0.6})
            Create("UICorner", {Parent = Inf}); AddGradientStroke(Inf)
            Create("TextLabel", {Parent = Inf, Text = icfg.Name, TextColor3 = Color3.new(0.9,0.9,0.9), Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 120, 1, 0), BackgroundTransparency = 1, TextXAlignment = 0, Font = Enum.Font.Gotham, TextSize = 12})
            local Box = Create("TextBox", {Parent = Inf, Position = UDim2.new(1, -110, 0.5, -12), Size = UDim2.new(0, 100, 0, 24), BackgroundColor3 = Color3.fromRGB(45, 45, 45), Text = "", PlaceholderText = "Type...", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 11})
            Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0,6)})
            Box.FocusLost:Connect(function() icfg.Callback(Box.Text) end)
        end

        function Elements:CreateLabel(lcfg)
            local Lab = Create("Frame", {Parent = SectionWrapper, Size = UDim2.new(0.92, 0, 0, 65), BackgroundColor3 = Color3.fromRGB(18, 18, 18), BackgroundTransparency = 0.6})
            Create("UICorner", {Parent = Lab}); AddGradientStroke(Lab)
            Create("TextLabel", {Parent = Lab, Text = lcfg.Name, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.new(1,1,1), Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1,-24, 0, 18), TextXAlignment = 0, BackgroundTransparency = 1})
            Create("TextLabel", {Parent = Lab, Text = lcfg.Desc, TextSize = 11, TextColor3 = Color3.fromRGB(180,180,180), Position = UDim2.new(0, 12, 0, 26), Size = UDim2.new(1,-24, 0, 35), TextXAlignment = 0, TextWrapped = true, BackgroundTransparency = 1, Font = Enum.Font.Gotham})
        end

        return Elements
    end
    return Sections
end

    
    -- Search Logic
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchInput.Text:lower():gsub("%-", " "):gsub("%s+", " ")
        if query == "" or query == " " then
            for _, item in pairs(AllElements) do item.Frame.Visible = true item.Sect.Visible = true end
            return
        end
        for _, item in pairs(AllElements) do
            local itemName = item.Name:gsub("%-", " ")
            local sectName = item.SectName:gsub("%-", " ")
            local match = itemName:find(query) or sectName:find(query)
            item.Frame.Visible = match; item.Sect.Visible = match
            if match then item.Page.Visible = true end
        end
    end)

    return Tabs
end
