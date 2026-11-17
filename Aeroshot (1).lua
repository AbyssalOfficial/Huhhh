--open source for u to skid cuz TS is legacy not brand new UI
-- enjoy retards :)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local Library = {}

local Window = {}
Window.__index = Window
local Category = {}
Category.__index = Category
local Tab = {}
Tab.__index = Tab
local Page = {}
Page.__index = Page
local Section = {}
Section.__index = Section

local Theme = {
	Background = Color3.fromRGB(11, 9, 20),
	Panel = Color3.fromRGB(27, 24, 43),
	Item = Color3.fromRGB(44, 41, 66),
	Select = Color3.fromRGB(62, 56, 108),
	Accent = Color3.fromRGB(150, 92, 255),
	Cyan = Color3.fromRGB(108, 204, 255),
	Text = Color3.fromRGB(242, 242, 250),
	SubText = Color3.fromRGB(144, 141, 168),
	White = Color3.fromRGB(255, 255, 255),
	Danger = Color3.fromRGB(226, 72, 96),
}

local function create(class, props, children)
	local inst = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then
			parent = v
		else
			inst[k] = v
		end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function tween(obj, props, time, style, dir)
	local t = TweenService:Create(
		obj,
		TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

local function corner(radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function stroke(color, transparency, thickness)
	return create("UIStroke", {
		Color = color,
		Transparency = transparency,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function padding(l, t, r, b)
	return create("UIPadding", {
		PaddingLeft = UDim.new(0, l),
		PaddingTop = UDim.new(0, t),
		PaddingRight = UDim.new(0, r),
		PaddingBottom = UDim.new(0, b),
	})
end

local function guiParent()
	local ok, ui = pcall(function()
		return gethui()
	end)
	if ok and ui then
		return ui
	end
	local canCore = pcall(function()
		local probe = Instance.new("ScreenGui")
		probe.Parent = game:GetService("CoreGui")
		probe:Destroy()
	end)
	if canCore then
		return game:GetService("CoreGui")
	end
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function normField(field)
	field = string.lower(tostring(field))
	if field == "text" or field == "description" or field == "desc" or field == "content" then
		return "desc"
	end
	return field
end

local function makeEdit(apply)
	return function(_, field, ...)
		if select("#", ...) == 0 then
			return function(value)
				apply(normField(field), value)
			end
		end
		apply(normField(field), ...)
	end
end

local function spin(gradient, seconds)
	local t = TweenService:Create(
		gradient,
		TweenInfo.new(seconds or 5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
		{ Rotation = gradient.Rotation + 360 }
	)
	t:Play()
	return t
end

local function makeLogo(parent, size, position, anchor)
	local holder = create("Frame", {
		Name = "Logo",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size, size),
		Position = position,
		AnchorPoint = anchor or Vector2.new(0, 0),
		Parent = parent,
	})
	local a = create("TextLabel", {
		Text = "A",
		Font = Enum.Font.GothamBlack,
		TextSize = math.floor(size * 1.0),
		TextColor3 = Theme.White,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(-0.04, -0.06),
		Size = UDim2.fromScale(0.82, 0.9),
		Parent = holder,
	}, {
		create("UIStroke", {
			Color = Theme.Accent,
			Thickness = math.max(1, size / 18),
			Transparency = 0.45,
		}),
	})
	local ag = create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 150, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(108, 204, 255)),
		}),
		Rotation = 45,
		Parent = a,
	})
	local s = create("TextLabel", {
		Text = "S",
		Font = Enum.Font.GothamBlack,
		TextSize = math.floor(size * 0.5),
		TextColor3 = Theme.White,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.58, 0.46),
		Size = UDim2.fromScale(0.42, 0.5),
		Parent = holder,
	}, {
		create("UIStroke", {
			Color = Theme.Cyan,
			Thickness = math.max(1, size / 24),
			Transparency = 0.55,
		}),
	})
	local sg = create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 204, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 92, 255)),
		}),
		Rotation = 90,
		Parent = s,
	})
	spin(ag, 6)
	spin(sg, 4)
	return holder
end

local function makeSwitch(parent, default, onChange)
	local state = default and true or false
	local track = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(30, 16),
		BackgroundColor3 = state and Theme.Accent or Theme.Item,
		Parent = parent,
	}, { corner(8), stroke(Theme.White, 0.88) })
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = Theme.White,
		Parent = track,
	}, { corner(6) })
	local sw = {}
	function sw.Set(v, silent)
		v = v and true or false
		local changed = v ~= state
		state = v
		tween(track, { BackgroundColor3 = state and Theme.Accent or Theme.Item }, 0.3)
		tween(
			knob,
			{ Position = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) },
			0.35,
			Enum.EasingStyle.Back
		)
		if changed and not silent and onChange then
			onChange(state)
		end
	end
	function sw.Get()
		return state
	end
	return sw
end

function Window:_connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(self.Connections, c)
	return c
end

function Window:_drag(handle, target)
	local dragging = false
	local dragStart
	local startPos
	self:_connect(handle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
		end
	end)
	self:_connect(UserInputService.InputChanged, function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local d = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + d.X,
				startPos.Y.Scale,
				startPos.Y.Offset + d.Y
			)
		end
	end)
	self:_connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function Window:_topbar(show)
	pcall(function()
		StarterGui:SetCore("TopbarEnabled", show)
	end)
end

function Window:_animIn()
	self.Main.Visible = true
	self.Backdrop.Visible = true
	self.SnowHolder.Visible = true
	self.SnowOn = true
	tween(self.Main, { GroupTransparency = 0 }, 0.4)
	tween(self.Scale, { Scale = self.Base }, 0.5, Enum.EasingStyle.Back)
	tween(self.Backdrop, { BackgroundTransparency = 0.42 }, 0.5)
	tween(self.Blur, { Size = 18 }, 0.5)
	self:_topbar(false)
end

function Window:_animOut()
	self.SnowOn = false
	tween(self.Main, { GroupTransparency = 1 }, 0.3)
	tween(self.Scale, { Scale = self.Base * 0.9 }, 0.3)
	tween(self.Backdrop, { BackgroundTransparency = 1 }, 0.4)
	tween(self.Blur, { Size = 0 }, 0.4)
	self:_topbar(true)
end

function Library:CreateWindow(opts)
	opts = opts or {}
	local self = setmetatable({}, Window)
	self.Connections = {}
	self.Categories = {}
	self.Tabs = {}
	self.Minimized = false
	self.SnowOn = false
	self.Title = opts.Title or "Aeroshot"

	local W = opts.Width or 540
	local H = opts.Height or 330
	local SB = 140
	local HEADER = 54
	local TOP = 44

	local vp = Vector2.new(1280, 720)
	local cam = workspace.CurrentCamera
	if cam then
		vp = cam.ViewportSize
	end
	local base = math.clamp(math.min((vp.X - 20) / W, (vp.Y - 20) / H), 0.5, 1)
	self.Base = base

	local gui = create("ScreenGui", {
		Name = opts.Name or "Aeroshot",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		DisplayOrder = 100,
	})
	gui.Parent = guiParent()
	self.Gui = gui

	self.Blur = create("BlurEffect", { Name = "AeroshotBlur", Size = 0, Parent = Lighting })

	self.Backdrop = create("Frame", {
		Name = "Backdrop",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(4, 3, 10),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = false,
		ZIndex = 1,
		Parent = gui,
	})
	self.SnowHolder = create("Frame", {
		Name = "Snow",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = self.Backdrop,
	})

	local flakes = {}
	for _ = 1, 45 do
		local size = math.random(2, 5)
		local f = create("Frame", {
			Size = UDim2.fromOffset(size, size),
			BackgroundColor3 = Theme.White,
			BackgroundTransparency = math.random(25, 75) / 100,
			BorderSizePixel = 0,
			Parent = self.SnowHolder,
		}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
		table.insert(flakes, {
			f = f,
			x = math.random(),
			y = math.random(),
			speed = 0.04 + math.random() * 0.08,
			sway = 0.01 + math.random() * 0.02,
			phase = math.random() * 6.28,
			freq = 0.8 + math.random(),
		})
	end
	local clock = 0
	self:_connect(RunService.Heartbeat, function(dt)
		if not self.SnowOn then
			return
		end
		clock = clock + dt
		for _, fl in ipairs(flakes) do
			fl.y = fl.y + fl.speed * dt
			if fl.y > 1.03 then
				fl.y = -0.03
				fl.x = math.random()
			end
			fl.f.Position = UDim2.fromScale(fl.x + math.sin(clock * fl.freq + fl.phase) * fl.sway, fl.y)
		end
	end)

	local main = create("CanvasGroup", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(W, H),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		ZIndex = 2,
		Parent = gui,
	})
	corner(16).Parent = main
	self.Scale = create("UIScale", { Scale = base * 0.9, Parent = main })
	create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 21, 68)),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(14, 11, 26)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 9, 18)),
		}),
		Rotation = 125,
		Parent = main,
	})
	local mainStroke = stroke(Theme.White, 0, 1.2)
	mainStroke.Parent = main
	create("UIGradient", {
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 92, 255)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(0.5, 0.9),
			NumberSequenceKeypoint.new(1, 0.65),
		}),
		Rotation = 125,
		Parent = mainStroke,
	})
	self.Main = main

	local shine = create("Frame", {
		Name = "Glass",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Theme.White,
		BorderSizePixel = 0,
		Active = false,
		Parent = main,
	})
	create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.92),
			NumberSequenceKeypoint.new(0.45, 0.975),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Rotation = 125,
		Parent = shine,
	})

	local sidebar = create("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, SB, 1, 0),
		BackgroundTransparency = 1,
		Parent = main,
	})
	create("Frame", {
		Name = "Divider",
		Position = UDim2.new(0, SB, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = Theme.White,
		BackgroundTransparency = 0.92,
		BorderSizePixel = 0,
		Parent = main,
	})

	makeLogo(sidebar, 28, UDim2.fromOffset(12, 13))
	create("TextLabel", {
		Name = "Title",
		Text = self.Title,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(48, 0),
		Size = UDim2.new(1, -52, 0, HEADER),
		Parent = sidebar,
	})

	self.List = create("ScrollingFrame", {
		Name = "Categories",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, HEADER),
		Size = UDim2.new(1, 0, 1, -(HEADER + 52)),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = sidebar,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
		padding(8, 2, 8, 6),
	})

	local footer = create("Frame", {
		Name = "User",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 8, 1, -8),
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = 0.45,
		Parent = sidebar,
	}, { corner(10), stroke(Theme.White, 0.92) })
	self.Avatar = create("ImageLabel", {
		BackgroundColor3 = Theme.Item,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 7, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		Parent = footer,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	self.UserName = create("TextLabel", {
		Text = "Player",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(38, 5),
		Size = UDim2.new(1, -44, 0, 14),
		Parent = footer,
	})
	self.UserSub = create("TextLabel", {
		Text = "user",
		Font = Enum.Font.Gotham,
		TextSize = 9,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(38, 19),
		Size = UDim2.new(1, -44, 0, 12),
		Parent = footer,
	})
	local lp = Players.LocalPlayer
	if lp then
		self.UserName.Text = lp.DisplayName
		self.UserSub.Text = lp.Name
		task.spawn(function()
			local ok, img = pcall(function()
				return Players:GetUserThumbnailAsync(
					lp.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size48x48
				)
			end)
			if ok and self.Avatar and self.Avatar.Parent then
				self.Avatar.Image = img
			end
		end)
	end

	local right = create("Frame", {
		Name = "Right",
		Position = UDim2.new(0, SB + 1, 0, 0),
		Size = UDim2.new(1, -(SB + 1), 1, 0),
		BackgroundTransparency = 1,
		Parent = main,
	})
	local topbar = create("Frame", {
		Name = "Topbar",
		Size = UDim2.new(1, 0, 0, TOP),
		BackgroundTransparency = 1,
		Parent = right,
	})
	self.Pills = create("Frame", {
		Name = "Pills",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, 22),
		Size = UDim2.new(1, -96, 0, 26),
		BackgroundTransparency = 1,
		Parent = topbar,
	})

	local function controlButton(xOffset)
		return create("TextButton", {
			Size = UDim2.fromOffset(22, 22),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, xOffset, 0, 22),
			BackgroundColor3 = Theme.Item,
			BackgroundTransparency = 0.5,
			AutoButtonColor = false,
			Text = "",
			Parent = topbar,
		}, { corner(7), stroke(Theme.White, 0.9) })
	end

	local minimize = controlButton(-36)
	create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(9, 2),
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		Parent = minimize,
	}, { corner(1) })

	local close = controlButton(-8)
	for _, rot in ipairs({ 45, -45 }) do
		create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(11, 2),
			Rotation = rot,
			BackgroundColor3 = Theme.Text,
			BorderSizePixel = 0,
			Parent = close,
		}, { corner(1) })
	end

	minimize.MouseEnter:Connect(function()
		tween(minimize, { BackgroundTransparency = 0.2 }, 0.2)
	end)
	minimize.MouseLeave:Connect(function()
		tween(minimize, { BackgroundTransparency = 0.5 }, 0.2)
	end)
	close.MouseEnter:Connect(function()
		tween(close, { BackgroundColor3 = Theme.Danger, BackgroundTransparency = 0.1 }, 0.2)
	end)
	close.MouseLeave:Connect(function()
		tween(close, { BackgroundColor3 = Theme.Item, BackgroundTransparency = 0.5 }, 0.2)
	end)
	minimize.MouseButton1Click:Connect(function()
		self:SetMinimized(true)
	end)
	close.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	self.Content = create("Frame", {
		Name = "Content",
		Position = UDim2.new(0, 0, 0, TOP),
		Size = UDim2.new(1, 0, 1, -TOP),
		BackgroundTransparency = 1,
		Parent = right,
	})

	local ball = create("TextButton", {
		Name = "Ball",
		Text = "",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(60, 60),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0.08,
		Visible = false,
		ZIndex = 5,
		Parent = gui,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	local ballStroke = stroke(Theme.White, 0, 1.6)
	ballStroke.Parent = ball
	local ballGrad = create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Accent),
			ColorSequenceKeypoint.new(0.5, Theme.Cyan),
			ColorSequenceKeypoint.new(1, Theme.Accent),
		}),
		Parent = ballStroke,
	})
	spin(ballGrad, 4)
	makeLogo(ball, 28, UDim2.fromScale(0.5, 0.5), Vector2.new(0.5, 0.5))
	self.Ball = ball

	local bdrag = false
	local bstart
	local bpos
	local moved = 0
	self:_connect(ball.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			bdrag = true
			moved = 0
			bstart = input.Position
			bpos = ball.Position
		end
	end)
	self:_connect(UserInputService.InputChanged, function(input)
		if
			bdrag
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local d = input.Position - bstart
			moved = math.max(moved, d.Magnitude)
			ball.Position = UDim2.new(bpos.X.Scale, bpos.X.Offset + d.X, bpos.Y.Scale, bpos.Y.Offset + d.Y)
		end
	end)
	self:_connect(UserInputService.InputEnded, function(input)
		if
			bdrag
			and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		then
			bdrag = false
			if moved < 6 then
				self:SetMinimized(false)
			end
		end
	end)

	self:_drag(topbar, main)
	self:_drag(sidebar, main)

	local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	self:_connect(UserInputService.InputBegan, function(input, processed)
		if not processed and input.KeyCode == toggleKey then
			self:SetMinimized(not self.Minimized)
		end
	end)

	self:_animIn()
	return self
end

function Window:SetMinimized(state)
	if state == self.Minimized then
		return
	end
	self.Minimized = state
	if state then
		if not self.BallPlaced then
			local p = self.Main.AbsolutePosition
			self.Ball.Position = UDim2.fromOffset(p.X + 34, p.Y + 34)
			self.BallPlaced = true
		end
		self:_animOut()
		task.delay(0.32, function()
			if self.Minimized then
				self.Main.Visible = false
				self.Backdrop.Visible = false
				self.SnowHolder.Visible = false
			end
		end)
		self.Ball.Visible = true
		self.Ball.Size = UDim2.fromOffset(0, 0)
		tween(self.Ball, { Size = UDim2.fromOffset(50, 50) }, 0.45, Enum.EasingStyle.Back)
	else
		local t = tween(self.Ball, { Size = UDim2.fromOffset(0, 0) }, 0.25)
		t.Completed:Connect(function()
			if not self.Minimized then
				self.Ball.Visible = false
			end
		end)
		self:_animIn()
	end
end

function Window:SetUser(name, sub, image)
	if name then
		self.UserName.Text = name
	end
	if sub then
		self.UserSub.Text = sub
	end
	if image then
		self.Avatar.Image = image
	end
end

function Window:Destroy()
	self.SnowOn = false
	self:_topbar(true)
	tween(self.Main, { GroupTransparency = 1 }, 0.3)
	tween(self.Scale, { Scale = self.Base * 0.9 }, 0.3)
	tween(self.Backdrop, { BackgroundTransparency = 1 }, 0.3)
	tween(self.Blur, { Size = 0 }, 0.3)
	task.delay(0.35, function()
		for _, c in ipairs(self.Connections) do
			c:Disconnect()
		end
		if self.Blur then
			self.Blur:Destroy()
		end
		self.Gui:Destroy()
	end)
end

function Window:SelectTab(tab)
	local prev = self.ActiveTab
	self.ActiveTab = tab
	for _, cat in ipairs(self.Categories) do
		if cat ~= tab.Category then
			tween(cat.Selector, { BackgroundTransparency = 1 }, 0.25)
		end
	end
	if prev and prev ~= tab then
		prev:_refresh()
		prev:_style()
	end
	tab:_refresh()
	tab:_style()
end

function Window:AddCategory(name, opts)
	opts = opts or {}
	local cat = setmetatable({ Window = self, Name = name, Tabs = {}, Open = false }, Category)

	local frame = create("Frame", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = 0.6,
		LayoutOrder = #self.Categories + 1,
		Parent = self.List,
	}, {
		corner(10),
		stroke(Theme.White, 0.92),
		create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
	})

	local header = create("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = 1,
		Parent = frame,
	})
	cat.HeaderIcon = Library._icon(header, opts.Icon, 10)
	create("TextLabel", {
		Text = name,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(30, 0),
		Size = UDim2.new(1, -52, 1, 0),
		Parent = header,
	})
	local arrow = create("TextLabel", {
		Text = ">",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = Theme.SubText,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		Parent = header,
	})

	local holder = create("Frame", {
		Name = "Holder",
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = 2,
		Parent = frame,
	})
	cat.Selector = create("Frame", {
		Name = "Selector",
		Position = UDim2.new(0, 6, 0, 0),
		Size = UDim2.new(1, -12, 0, 26),
		BackgroundColor3 = Theme.Select,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = holder,
	}, { corner(8) })
	local inner = create("Frame", {
		Name = "Inner",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 2,
		Parent = holder,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }),
		padding(6, 0, 6, 6),
	})

	cat.Frame = frame
	cat.Holder = holder
	cat.Inner = inner
	cat.Arrow = arrow

	inner:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if cat.Open then
			holder.Size = UDim2.new(1, 0, 0, inner.AbsoluteSize.Y / math.max(0.01, self.Scale.Scale))
		end
	end)

	header.MouseButton1Click:Connect(function()
		cat:SetOpen(not cat.Open)
	end)

	table.insert(self.Categories, cat)
	if opts.Open then
		cat:SetOpen(true, true)
	end
	return cat
end

function Library._icon(parent, image, x)
	if image and image ~= "" then
		return create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = image,
			ImageColor3 = Theme.SubText,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, x, 0.5, 0),
			Size = UDim2.fromOffset(13, 13),
			Parent = parent,
		})
	end
	return create("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, x + 1, 0.5, 0),
		Size = UDim2.fromOffset(10, 10),
		Parent = parent,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }), stroke(Theme.SubText, 0.15, 1.5) })
end

function Category:_height()
	return self.Inner.AbsoluteSize.Y / math.max(0.01, self.Window.Scale.Scale)
end

function Category:SetOpen(state, instant)
	self.Open = state
	local h = state and self:_height() or 0
	if instant then
		self.Holder.Size = UDim2.new(1, 0, 0, h)
		self.Arrow.Rotation = state and 90 or 0
		self.Frame.BackgroundTransparency = state and 0.4 or 0.6
	else
		tween(self.Holder, { Size = UDim2.new(1, 0, 0, h) }, 0.4)
		tween(self.Arrow, { Rotation = state and 90 or 0 }, 0.3)
		tween(self.Frame, { BackgroundTransparency = state and 0.4 or 0.6 }, 0.3)
	end
end

function Category:AddTab(name, opts)
	opts = opts or {}
	local win = self.Window
	local tab = setmetatable({ Window = win, Category = self, Name = name, Pages = {}, Index = #self.Tabs + 1 }, Tab)

	local button = create("TextButton", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = tab.Index,
		Parent = self.Inner,
	}, { corner(8) })
	Library._icon(button, opts.Icon, 8)
	local label = create("TextLabel", {
		Text = name,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(28, 0),
		Size = UDim2.new(1, -46, 1, 0),
		Parent = button,
	})
	local dot = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(5, 5),
		BackgroundColor3 = Theme.White,
		BackgroundTransparency = 1,
		Parent = button,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

	tab.Button = button
	tab.Label = label
	tab.Dot = dot
	tab.PillBar = create("Frame", {
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = win.Pills,
	}, {
		create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})

	button.MouseButton1Click:Connect(function()
		win:SelectTab(tab)
	end)
	button.MouseEnter:Connect(function()
		if win.ActiveTab ~= tab then
			tween(label, { TextColor3 = Theme.Text }, 0.2)
		end
	end)
	button.MouseLeave:Connect(function()
		if win.ActiveTab ~= tab then
			tween(label, { TextColor3 = Theme.SubText }, 0.2)
		end
	end)

	table.insert(self.Tabs, tab)
	table.insert(win.Tabs, tab)

	if not win.ActiveTab then
		win.ActiveTab = tab
		self:SetOpen(true, true)
		tab:_style()
		tab:_refresh()
	end
	return tab
end

function Tab:_style()
	local active = self.Window.ActiveTab == self
	tween(self.Label, { TextColor3 = active and Theme.Text or Theme.SubText }, 0.25)
	tween(self.Dot, { BackgroundTransparency = active and 0 or 1 }, 0.25)
	if active then
		local sel = self.Category.Selector
		local target = UDim2.new(0, 6, 0, (self.Index - 1) * 28)
		if sel.BackgroundTransparency >= 0.99 then
			sel.Position = target
		end
		tween(sel, { Position = target, BackgroundTransparency = 0.25 }, 0.45)
	end
end

function Tab:_refresh()
	local active = self.Window.ActiveTab == self
	self.PillBar.Visible = active
	for _, p in ipairs(self.Pages) do
		local on = active and self.ActivePage == p
		if on and not p.Shown then
			p.Shown = true
			p.Container.Position = UDim2.new(0, 0, 0, 10)
			p.Container.GroupTransparency = 1
			p.Container.Visible = true
			tween(p.Container, { Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0 }, 0.45)
		elseif not on and p.Shown then
			p.Shown = false
			p.Container.Visible = false
			p.Container.GroupTransparency = 1
		end
		tween(p.Button, { BackgroundTransparency = on and 0.4 or 1 }, 0.25)
		tween(p.Button, { TextColor3 = on and Theme.Text or Theme.SubText }, 0.25)
	end
end

function Tab:AddPage(name)
	local win = self.Window
	local page = setmetatable({ Tab = self, Name = name, Sections = {}, Order = 0, Shown = false }, Page)

	page.Button = create("TextButton", {
		Name = name,
		Text = name,
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextColor3 = Theme.SubText,
		Size = UDim2.new(0, 0, 0, 22),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		LayoutOrder = #self.Pages + 1,
		Parent = self.PillBar,
	}, { corner(11), padding(12, 0, 12, 0), stroke(Theme.White, 0.9) })

	page.Container = create("CanvasGroup", {
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Visible = false,
		Parent = win.Content,
	})

	local function column(left)
		return create("ScrollingFrame", {
			Name = left and "Left" or "Right",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = left and UDim2.new(0, 10, 0, 0) or UDim2.new(0.5, 5, 0, 0),
			Size = UDim2.new(0.5, -15, 1, -10),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 2,
			ScrollBarImageTransparency = 1,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Parent = page.Container,
		}, {
			create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }),
			padding(1, 2, 1, 8),
		})
	end

	page.Left = column(true)
	page.Right = column(false)

	page.Button.MouseButton1Click:Connect(function()
		self.ActivePage = page
		self:_refresh()
	end)

	table.insert(self.Pages, page)
	if not self.ActivePage then
		self.ActivePage = page
	end
	self:_refresh()
	return page
end

function Page:AddSection(opts)
	if type(opts) == "string" then
		opts = { Title = opts }
	end
	opts = opts or {}
	local column = (opts.Side == "Right") and self.Right or self.Left
	self.Order = self.Order + 1

	local section = setmetatable({ Page = self, Window = self.Tab.Window, Order = 0 }, Section)

	local frame = create("Frame", {
		Name = opts.Title or "Section",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = 0.5,
		LayoutOrder = self.Order,
		Parent = column,
	}, {
		corner(10),
		stroke(Theme.White, 0.9),
		padding(10, 10, 10, 10),
		create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
	})
	section.Frame = frame

	local header = create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, opts.Description and 28 or 16),
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		Parent = frame,
	})
	create("TextLabel", {
		Text = opts.Title or "Section",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -44, 0, 15),
		Parent = header,
	})
	if opts.Description then
		create("TextLabel", {
			Text = opts.Description,
			Font = Enum.Font.Gotham,
			TextSize = 9,
			TextColor3 = Theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 15),
			Size = UDim2.new(1, -44, 0, 12),
			Parent = header,
		})
	end
	if opts.Toggle then
		local callback = opts.Callback or function(v)
			print(v)
		end
		section.Switch = makeSwitch(header, opts.Default, callback)
		local hit = create("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(36, 22),
			Parent = header,
		})
		hit.MouseButton1Click:Connect(function()
			section.Switch.Set(not section.Switch.Get())
		end)
	end

	table.insert(self.Sections, section)
	return section
end

function Section:_next()
	self.Order = self.Order + 1
	return self.Order
end

function Section:AddToggle(opts)
	opts = opts or {}
	local callback = opts.Callback or function(v)
		print(v)
	end
	local row = create("TextButton", {
		Name = opts.Name or "Toggle",
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	})
	local label = create("TextLabel", {
		Text = opts.Name or "Toggle",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = opts.Default and Theme.Text or Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -44, 1, 0),
		Parent = row,
	})
	local sw = makeSwitch(row, opts.Default, function(v)
		tween(label, { TextColor3 = v and Theme.Text or Theme.SubText }, 0.25)
		callback(v)
	end)
	row.MouseButton1Click:Connect(function()
		sw.Set(not sw.Get())
	end)
	local api = {}
	function api:Set(v, silent)
		sw.Set(v, silent)
	end
	function api:Get()
		return sw.Get()
	end
	return api
end

function Section:AddSlider(opts)
	opts = opts or {}
	local min = opts.Min or 0
	local max = opts.Max or 100
	local step = opts.Step or 1
	local suffix = opts.Suffix or ""
	local callback = opts.Callback or function(v)
		print(v)
	end
	local value
	local dragging = false

	local row = create("Frame", {
		Name = opts.Name or "Slider",
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	})
	create("TextLabel", {
		Text = opts.Name or "Slider",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -56, 0, 14),
		Parent = row,
	})
	local valueLabel = create("TextLabel", {
		Text = "",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.fromOffset(56, 14),
		Parent = row,
	})

	local function stepButton(text, xScale, xOffset)
		return create("TextButton", {
			Text = text,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextColor3 = Theme.Text,
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Item,
			BackgroundTransparency = 0.3,
			Position = UDim2.new(xScale, xOffset, 0, 19),
			Size = UDim2.fromOffset(14, 14),
			Parent = row,
		}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	end
	local minus = stepButton("-", 0, 0)
	local plus = stepButton("+", 1, -14)

	local track = create("Frame", {
		Position = UDim2.new(0, 20, 0, 24),
		Size = UDim2.new(1, -40, 0, 4),
		BackgroundColor3 = Theme.Item,
		BorderSizePixel = 0,
		Parent = row,
	}, { corner(2) })
	local fill = create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Parent = track,
	}, { corner(2) })
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(9, 9),
		BackgroundColor3 = Theme.White,
		Parent = fill,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

	local hit = create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 17),
		Size = UDim2.new(1, -40, 0, 16),
		Parent = row,
	})

	local function set(v, silent)
		v = math.clamp(v, min, max)
		v = min + math.floor((v - min) / step + 0.5) * step
		v = math.clamp(v, min, max)
		v = math.floor(v * 1000 + 0.5) / 1000
		local changed = v ~= value
		value = v
		local rel = (max - min) == 0 and 0 or (v - min) / (max - min)
		if dragging then
			fill.Size = UDim2.new(rel, 0, 1, 0)
		else
			tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.25)
		end
		valueLabel.Text = tostring(v) .. suffix
		if changed and not silent then
			callback(v)
		end
	end

	local function fromX(x)
		local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
		set(min + (max - min) * rel)
	end

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			tween(knob, { Size = UDim2.fromOffset(12, 12) }, 0.2)
			fromX(input.Position.X)
		end
	end)
	self.Window:_connect(UserInputService.InputChanged, function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			fromX(input.Position.X)
		end
	end)
	self.Window:_connect(UserInputService.InputEnded, function(input)
		if
			dragging
			and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		then
			dragging = false
			tween(knob, { Size = UDim2.fromOffset(9, 9) }, 0.2)
		end
	end)
	minus.MouseButton1Click:Connect(function()
		set(value - step)
	end)
	plus.MouseButton1Click:Connect(function()
		set(value + step)
	end)

	set(opts.Default or min, true)

	local api = {}
	function api:Set(v, silent)
		set(v, silent)
	end
	function api:Get()
		return value
	end
	return api
end

function Section:AddDropdown(opts)
	opts = opts or {}
	local options = opts.Options or {}
	local current = opts.Default or options[1]
	local callback = opts.Callback or function(v)
		print(v)
	end
	local open = false
	local rebuild

	local container = create("Frame", {
		Name = opts.Name or "Dropdown",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
	})

	local head = create("Frame", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = container,
	})
	create("TextLabel", {
		Text = opts.Name or "Dropdown",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -96, 1, 0),
		Parent = head,
	})
	local btn = create("TextButton", {
		Text = "",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(92, 20),
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 0.35,
		Parent = head,
	}, { corner(6), stroke(Theme.White, 0.9) })
	local valueLabel = create("TextLabel", {
		Text = tostring(current or ""),
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(7, 0),
		Size = UDim2.new(1, -22, 1, 0),
		Parent = btn,
	})
	local arrow = create("TextLabel", {
		Text = ">",
		Font = Enum.Font.GothamBold,
		TextSize = 9,
		TextColor3 = Theme.SubText,
		Rotation = 90,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(10, 10),
		Parent = btn,
	})

	local list = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 0.5,
		ClipsDescendants = true,
		Visible = false,
		LayoutOrder = 2,
		Parent = container,
	}, {
		corner(8),
		padding(4, 4, 4, 4),
		create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }),
	})

	local function setOpen(state)
		open = state
		tween(arrow, { Rotation = state and 270 or 90 }, 0.3)
		if state then
			list.Visible = true
			tween(list, { Size = UDim2.new(1, 0, 0, #options * 26 + 6) }, 0.4)
		else
			local t = tween(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.3)
			t.Completed:Connect(function()
				if not open then
					list.Visible = false
				end
			end)
		end
	end

	local function setValue(v, silent)
		local changed = v ~= current
		current = v
		valueLabel.Text = tostring(v)
		rebuild()
		if changed and not silent then
			callback(v)
		end
	end

	rebuild = function()
		for _, c in ipairs(list:GetChildren()) do
			if c:IsA("TextButton") then
				c:Destroy()
			end
		end
		for i, opt in ipairs(options) do
			local selected = opt == current
			local b = create("TextButton", {
				Text = tostring(opt),
				Font = Enum.Font.GothamMedium,
				TextSize = 10,
				TextColor3 = selected and Theme.Text or Theme.SubText,
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = Theme.Accent,
				BackgroundTransparency = selected and 0.7 or 1,
				AutoButtonColor = false,
				LayoutOrder = i,
				Parent = list,
			}, { corner(6) })
			b.MouseEnter:Connect(function()
				if opt ~= current then
					tween(b, { TextColor3 = Theme.Text }, 0.15)
				end
			end)
			b.MouseLeave:Connect(function()
				if opt ~= current then
					tween(b, { TextColor3 = Theme.SubText }, 0.15)
				end
			end)
			b.MouseButton1Click:Connect(function()
				setValue(opt)
				setOpen(false)
			end)
		end
	end

	btn.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)
	rebuild()

	local api = {}
	function api:Set(v, silent)
		setValue(v, silent)
	end
	function api:Get()
		return current
	end
	function api:Refresh(newOptions)
		options = newOptions or {}
		rebuild()
	end
	return api
end

function Section:AddKeybind(opts)
	opts = opts or {}
	local key = opts.Default
	local callback = opts.Callback or function(k)
		print(k and k.Name or "None")
	end
	local listening = false

	local row = create("Frame", {
		Name = opts.Name or "Keybind",
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	})
	create("TextLabel", {
		Text = opts.Name or "Keybind",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -70, 1, 0),
		Parent = row,
	})
	local btn = create("TextButton", {
		Text = key and key.Name or "None",
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextColor3 = Theme.Text,
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(58, 20),
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 0.35,
		Parent = row,
	}, { corner(6), stroke(Theme.White, 0.9) })

	btn.MouseButton1Click:Connect(function()
		listening = true
		btn.Text = "..."
		tween(btn, { BackgroundColor3 = Theme.Accent }, 0.2)
	end)
	self.Window:_connect(UserInputService.InputBegan, function(input)
		if not listening then
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			listening = false
			if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
				key = nil
			else
				key = input.KeyCode
			end
			btn.Text = key and key.Name or "None"
			tween(btn, { BackgroundColor3 = Theme.Item }, 0.2)
			callback(key)
		end
	end)

	local api = {}
	function api:Set(k, silent)
		key = k
		btn.Text = key and key.Name or "None"
		if not silent then
			callback(key)
		end
	end
	function api:Get()
		return key
	end
	return api
end

function Section:AddButton(opts)
	opts = opts or {}
	local callback = opts.Callback or function()
		print("clicked", opts.Name or "Button")
	end
	local btn = create("TextButton", {
		Name = opts.Name or "Button",
		Text = opts.Name or "Button",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = Theme.Text,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 0.35,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	}, { corner(8), stroke(Theme.White, 0.9) })
	btn.MouseEnter:Connect(function()
		tween(btn, { BackgroundTransparency = 0.1 }, 0.2)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, { BackgroundTransparency = 0.35 }, 0.2)
	end)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

function Section:AddLabel(text)
	local label = create("TextLabel", {
		Text = text or "",
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	})
	local api = {}
	function api:Set(t)
		label.Text = t
	end
	return api
end

function Section:AddParagraph(opts)
	opts = opts or {}
	local frame = create("Frame", {
		Name = opts.Title or "Paragraph",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 0.55,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	}, {
		corner(8),
		stroke(Theme.White, 0.92),
		padding(8, 7, 8, 7),
		create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }),
	})
	local title = create("TextLabel", {
		Text = opts.Title or "",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		Parent = frame,
	})
	local desc = create("TextLabel", {
		Text = opts.Text or opts.Desc or "",
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
		Parent = frame,
	})
	local api = {}
	api.Edit = makeEdit(function(field, value)
		if field == "title" then
			title.Text = tostring(value)
		elseif field == "desc" then
			desc.Text = tostring(value)
		end
	end)
	return api
end

local function makeCell(parent, data, size)
	data = data or {}
	local cell = create("Frame", {
		Size = size,
		BackgroundColor3 = Theme.Item,
		BackgroundTransparency = 0.45,
		Parent = parent,
	}, { corner(8), stroke(Theme.White, 0.9), padding(8, 0, 8, 0) })
	local img = create("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		ScaleType = Enum.ScaleType.Fit,
		Parent = cell,
	})
	local holder = create("Frame", {
		BackgroundTransparency = 1,
		Parent = cell,
	})
	local title = create("TextLabel", {
		Text = data.Title or "",
		Font = Enum.Font.GothamBold,
		TextSize = 9,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 0.5, 1),
		Size = UDim2.new(1, 0, 0, 12),
		Parent = holder,
	})
	local desc = create("TextLabel", {
		Text = data.Desc or data.Text or "",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0.5, 1),
		Size = UDim2.new(1, 0, 0, 16),
		Parent = holder,
	})
	local function layout()
		local has = img.Image ~= ""
		img.Visible = has
		holder.Position = UDim2.new(0, has and 32 or 0, 0, 0)
		holder.Size = UDim2.new(1, has and -32 or 0, 1, 0)
	end
	img.Image = data.Image or ""
	layout()
	local api = {}
	api.Edit = makeEdit(function(field, value)
		if field == "title" then
			title.Text = tostring(value)
		elseif field == "desc" then
			desc.Text = tostring(value)
		elseif field == "image" then
			img.Image = tostring(value or "")
			layout()
		end
	end)
	return api
end

function Section:AddImageGroup(items)
	items = items or {}
	if items.Items then
		items = items.Items
	end
	local container = create("Frame", {
		Name = "ImageGroup",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = self:_next(),
		Parent = self.Frame,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
	})
	local group = { Items = {} }
	local i = 1
	local rowIndex = 0
	while i <= #items do
		local count = math.min(2, #items - i + 1)
		rowIndex = rowIndex + 1
		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 44),
			BackgroundTransparency = 1,
			LayoutOrder = rowIndex,
			Parent = container,
		}, {
			create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})
		for _ = 1, count do
			local size = count == 1 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, -3, 1, 0)
			table.insert(group.Items, makeCell(row, items[i], size))
			i = i + 1
		end
	end
	function group:Get(index)
		return self.Items[index]
	end
	function group:Edit(index, field, ...)
		local cell = self.Items[index]
		if cell then
			return cell:Edit(field, ...)
		end
	end
	return group
end

return Library
