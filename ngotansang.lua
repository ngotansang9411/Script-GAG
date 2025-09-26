-- SanguiList1 v2 - Modern / sleek UI for Roblox
-- Author: you + ChatGPT
-- Paste into a ModuleScript (e.g., ReplicatedStorage.SanguiList1)

local Sangui = {}
Sangui.__index = Sangui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Utility helpers
local function new(cls, props)
    local obj = Instance.new(cls)
    if props then
        for k,v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

local function tween(instance, props, time, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(time or 0.18, style, dir)
    local t = TweenService:Create(instance, info, props)
    t:Play()
    return t
end

-- Default theme values
local THEME = {
    bgColor = Color3.fromRGB(40,40,40),
    bgTransparency = 0.18,
    panelDark = Color3.fromRGB(30,30,30),
    accent = Color3.fromRGB(100,255,255),
    text = Color3.fromRGB(230,230,230),
    stroke = Color3.fromRGB(200,200,200)
}

-- Create window (main entry)
function Sangui:CreateWindow(titleText)
    assert(LocalPlayer, "LocalPlayer not available. Run on client (LocalScript).")
    -- create gui root
    local gui = new("ScreenGui", {Name = "SanguiList1_v2", ResetOnSpawn = false})
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Logo (round)
    local logoBtn = new("ImageButton", {
        Name = "SanguiLogo",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = THEME.panelDark,
        BackgroundTransparency = 0.2,
        Image = "",
        AutoButtonColor = false,
    })
    logoBtn.Parent = gui
    local logoCorner = new("UICorner", {Parent = logoBtn})
    logoCorner.CornerRadius = UDim.new(1,0)

    local logoStroke = new("UIStroke", {Parent = logoBtn, Color = THEME.stroke, Transparency = 0.7, Thickness = 1})

    -- Main container
    local main = new("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 460, 0, 340),
        Position = UDim2.new(0.5, -230, 0.5, -170),
        BackgroundColor3 = THEME.bgColor,
        BackgroundTransparency = THEME.bgTransparency,
        Active = true,
    })
    main.Parent = gui
    local mainCorner = new("UICorner", {Parent = main, CornerRadius = UDim.new(0,8)})
    local mainStroke = new("UIStroke", {Parent = main, Color = THEME.stroke, Transparency = 0.65, Thickness = 1})

    -- subtle shadow (ImageLabel using 9-slice)
    local shadow = new("ImageLabel", {
        Parent = main,
        Name = "Shadow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice
    })
    shadow.SliceCenter = Rect.new(24,24,276,276)

    -- top bar
    local topBar = new("Frame", {
        Parent = main,
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = THEME.panelDark,
    })
    new("UICorner", {Parent = topBar, CornerRadius = UDim.new(0,8)})
    local title = new("TextLabel", {
        Parent = topBar,
        Name = "Title",
        Text = titleText or "SanguiList1 v2",
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = THEME.text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- top buttons (- ÷ ×)
    local function makeTopBtn(symbol, rightOffset)
        local b = new("TextButton", {
            Parent = topBar,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -rightOffset, 0, 3),
            BackgroundTransparency = 1,
            Text = symbol,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextColor3 = THEME.text,
            AutoButtonColor = false,
        })
        new("UICorner", {Parent = b, CornerRadius = UDim.new(0,6)})
        -- hover effect
        b.MouseEnter:Connect(function()
            tween(b, {TextColor3 = THEME.accent}, 0.12)
        end)
        b.MouseLeave:Connect(function()
            tween(b, {TextColor3 = THEME.text}, 0.12)
        end)
        return b
    end

    local btnClose = makeTopBtn("×", 38)
    local btnMax = makeTopBtn("÷", 74)
    local btnMin = makeTopBtn("-", 110)

    -- left: tab list
    local tabList = new("ScrollingFrame", {
        Parent = main,
        Name = "TabList",
        Size = UDim2.new(0, 120, 1, -36),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
    })
    local tabLayout = new("UIListLayout", {Parent = tabList, Padding = UDim.new(0,8), FillDirection = Enum.FillDirection.Vertical})
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.CanvasSize = UDim2.new(0,0,0,0)

    -- right: content area
    local contentArea = new("Frame", {
        Parent = main,
        Name = "ContentArea",
        Size = UDim2.new(1, -120, 1, -36),
        Position = UDim2.new(0, 120, 0, 36),
        BackgroundTransparency = 1,
    })

    -- convenience UIListLayout for content frames later
    -- Logo toggle behavior
    logoBtn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    -- minimize -> hide (but not destroy)
    btnMin.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 200, 0, 36)}, 0.22)
        tween(contentArea, {Position = UDim2.new(0,120,0,36)}, 0.22)
        -- simply collapse: actually hide content
        for _,v in pairs(contentArea:GetChildren()) do
            if v:IsA("Frame") then v.Visible = false end
        end
    end)

    -- maximize toggle
    local maximized = false
    btnMax.MouseButton1Click:Connect(function()
        maximized = not maximized
        if maximized then
            tween(main, {Size = UDim2.new(0,720,0,520), Position = UDim2.new(0.5, -360, 0.5, -260)}, 0.22)
        else
            tween(main, {Size = UDim2.new(0,460,0,340), Position = UDim2.new(0.5, -230, 0.5, -170)}, 0.22)
        end
    end)

    -- close -> destroy and disconnect binds
    btnClose.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- API objects
    local WindowAPI = {}
    WindowAPI.Tabs = {}
    WindowAPI._gui = gui
    WindowAPI._logo = logoBtn
    WindowAPI._main = main

    function WindowAPI:SetLogo(imageId)
        if type(imageId) == "string" then
            self._logo.Image = imageId
        end
    end

    -- internal helper to update tabList canvas
    local function updateTabCanvas()
        wait() -- allow layout to update
        local total = 0
        for _,v in pairs(tabList:GetChildren()) do
            if v:IsA("TextButton") or v:IsA("Frame") then
                total = total + (v.AbsoluteSize.Y + 8)
            end
        end
        tabList.CanvasSize = UDim2.new(0,0,0, total)
    end

    -- CreateTab returns a Tab API
    function WindowAPI:CreateTab(name)
        -- tab button
        local tb = new("TextButton", {
            Parent = tabList,
            Text = name,
            Size = UDim2.new(1, -12, 0, 34),
            BackgroundColor3 = Color3.fromRGB(48,48,48),
            TextColor3 = THEME.text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            AutoButtonColor = false,
        })
        new("UICorner", {Parent = tb, CornerRadius = UDim.new(0,6)})
        local highlight = new("Frame", {Parent = tb, Name = "Highlight", Size = UDim2.new(0,4,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = THEME.accent, Visible = false})
        new("UICorner", {Parent = highlight, CornerRadius = UDim.new(0,4)})

        -- tab content frame
        local tabFrame = new("ScrollingFrame", {
            Parent = contentArea,
            Name = ("Tab_%s"):format(name),
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            Position = UDim2.new(0,0,0,0),
            ScrollBarThickness = 8,
        })
        local contentLayout = new("UIListLayout", {Parent = tabFrame, Padding = UDim.new(0,8)})
        tabFrame.CanvasSize = UDim2.new(0,0,0,0)
        tabFrame.Visible = false

        -- element placement helper
        local function newElement(inst)
            inst.Parent = tabFrame
            wait() -- let absolute sizes settle
            tabFrame.CanvasSize = UDim2.new(0,0,0, tabFrame.UIListLayout.AbsoluteContentSize.Y + 12)
        end

        -- Tab API
        local TabAPI = {}

        function TabAPI:Show()
            -- hide other frames
            for _,v in pairs(contentArea:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            tabFrame.Visible = true
            -- highlight button
            for _,b in pairs(tabList:GetChildren()) do
                if b:IsA("TextButton") and b:FindFirstChild("Highlight") then
                    b.Highlight.Visible = false
                    b.BackgroundColor3 = Color3.fromRGB(48,48,48)
                end
            end
            tb.Highlight.Visible = true
            tb.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end

        function TabAPI:CreateLabel(text)
            local lbl = new("TextLabel", {
                Size = UDim2.new(0, 520, 0, 26),
                BackgroundTransparency = 1,
                Text = text or "",
                TextColor3 = THEME.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            newElement(lbl)
            return lbl
        end

        function TabAPI:CreateButton(text, callback)
            local btn = new("TextButton", {
                Size = UDim2.new(0, 520, 0, 36),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                AutoButtonColor = false,
                Text = text or "Button",
                TextColor3 = THEME.text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
            })
            new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
            newElement(btn)
            btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(70,70,70)}, 0.12) end)
            btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(60,60,60)}, 0.12) end)
            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            return btn
        end

        function TabAPI:CreateToggle(text, default, callback)
            local state = default and true or false
            local frame = new("Frame", {
                Size = UDim2.new(0, 520, 0, 36),
                BackgroundTransparency = 1,
            })
            local btn = new("TextButton", {
                Parent = frame,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = text .. ": " .. tostring(state),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                TextColor3 = THEME.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                AutoButtonColor = false,
            })
            new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
            local toggleBtn = new("TextButton", {
                Parent = frame,
                Size = UDim2.new(0,44,0,28),
                Position = UDim2.new(1, -50, 0.5, -14),
                BackgroundColor3 = state and THEME.accent or Color3.fromRGB(90,90,90),
                Text = "",
                AutoButtonColor = false
            })
            new("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(0,6)})
            newElement(frame)

            local function setState(v)
                state = v
                btn.Text = text .. ": " .. tostring(state)
                tween(toggleBtn, {BackgroundColor3 = state and THEME.accent or Color3.fromRGB(90,90,90)}, 0.12)
                pcall(callback, state)
            end

            btn.MouseButton1Click:Connect(function() setState(not state) end)
            toggleBtn.MouseButton1Click:Connect(function() setState(not state) end)
            return {Set = setState}
        end

        function TabAPI:CreateSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            local value = default or min
            local frame = new("Frame", {
                Size = UDim2.new(0, 520, 0, 48),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
            })
            new("UICorner", {Parent = frame, CornerRadius = UDim.new(0,6)})
            local lbl = new("TextLabel", {
                Parent = frame,
                Size = UDim2.new(1, -12, 0, 18),
                Position = UDim2.new(0,6,0,4),
                BackgroundTransparency = 1,
                Text = (text or "Slider") .. ": " .. tostring(value),
                TextColor3 = THEME.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local track = new("Frame", {Parent = frame, Size = UDim2.new(1, -20, 0, 12), Position = UDim2.new(0,10,0,26), BackgroundColor3 = Color3.fromRGB(100,100,100)})
            new("UICorner", {Parent = track, CornerRadius = UDim.new(0,6)})
            local knob = new("Frame", {Parent = track, Size = UDim2.new(0, 14, 1, 0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = THEME.accent})
            new("UICorner", {Parent = knob, CornerRadius = UDim.new(0,6)})

            newElement(frame)

            local dragging = false
            local function setByPosition(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel)
                lbl.Text = (text or "Slider") .. ": " .. tostring(value)
                knob.Position = UDim2.new(rel, 0, 0, 0)
                pcall(callback, value)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    setByPosition(input.Position.X)
                end
            end)
            track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    setByPosition(input.Position.X)
                end
            end)
            return {Set = function(v) value = v; pcall(callback, value) end}
        end

        function TabAPI:CreateDropdown(text, options, callback)
            options = options or {}
            local frame = new("Frame", {Size = UDim2.new(0,520,0,36), BackgroundTransparency = 1})
            local mainBtn = new("TextButton", {
                Parent = frame,
                Size = UDim2.new(1,0,1,0),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Text = (text or "Dropdown") .. " ▼",
                TextColor3 = THEME.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                AutoButtonColor = false,
            })
            new("UICorner", {Parent = mainBtn, CornerRadius = UDim.new(0,6)})
            local list = new("Frame", {Parent = frame, Size = UDim2.new(1,0,0, #options * 28), Position = UDim2.new(0,0,1,4), BackgroundColor3 = Color3.fromRGB(45,45,45), Visible = false})
            new("UICorner", {Parent = list, CornerRadius = UDim.new(0,6)})
            newElement(frame)

            for i,opt in ipairs(options) do
                local optBtn = new("TextButton", {
                    Parent = list,
                    Size = UDim2.new(1, -8, 0, 24),
                    Position = UDim2.new(0, 4, 0, (i-1)*28 + 4),
                    BackgroundColor3 = Color3.fromRGB(55,55,55),
                    Text = opt,
                    TextColor3 = THEME.text,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    AutoButtonColor = false,
                })
                new("UICorner", {Parent = optBtn, CornerRadius = UDim.new(0,6)})
                optBtn.MouseButton1Click:Connect(function()
                    mainBtn.Text = (text or "Dropdown") .. ": " .. opt
                    list.Visible = false
                    pcall(callback, opt)
                end)
            end

            mainBtn.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
            end)

            return {
                Set = function(val) mainBtn.Text = (text or "Dropdown") .. ": " .. tostring(val) end
            }
        end

        function TabAPI:CreateInput(placeholder, callback)
            local frame = new("Frame", {Size = UDim2.new(0,520,0,36), BackgroundTransparency = 1})
            local box = new("TextBox", {
                Parent = frame,
                Size = UDim2.new(1,0,1,0),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Text = "",
                PlaceholderText = placeholder or "",
                TextColor3 = THEME.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
            })
            new("UICorner", {Parent = box, CornerRadius = UDim.new(0,6)})
            newElement(frame)
            box.FocusLost:Connect(function(enter)
                if enter then pcall(callback, box.Text) end
            end)
            return {Set = function(v) box.Text = v end}
        end

        function TabAPI:CreateKeybind(text, defaultKey, callback)
            local key = defaultKey
            local frame = new("Frame", {Size = UDim2.new(0,520,0,36), BackgroundTransparency = 1})
            local btn = new("TextButton", {
                Parent = frame,
                Size = UDim2.new(1,0,1,0),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Text = (text or "Keybind") .. ": " .. (key and key.Name or "None"),
                TextColor3 = THEME.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                AutoButtonColor = false,
            })
            new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
            newElement(frame)

            local awaiting = false
            btn.MouseButton1Click:Connect(function()
                btn.Text = (text or "Keybind") .. ": ..."
                awaiting = true
                local conn
                conn = UIS.InputBegan:Connect(function(input, processed)
                    if processed then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        btn.Text = (text or "Keybind") .. ": " .. key.Name
                        awaiting = false
                        pcall(callback, key)
                        conn:Disconnect()
                    end
                end)
            end)

            -- Listen for key
            UIS.InputBegan:Connect(function(input, processed)
                if processed then return end
                if key and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
                    pcall(callback, key)
                end
            end)
            return {
                Set = function(k) key = k; btn.Text = (text or "Keybind") .. ": " .. (k and k.Name or "None") end
            }
        end

        -- connect tab button click
        tb.MouseButton1Click:Connect(function()
            TabAPI:Show()
        end)

        -- register to window
        updateTabCanvas()
        table.insert(WindowAPI.Tabs, TabAPI)
        return TabAPI
    end

    -- return WindowAPI to user
    return WindowAPI
end

return Sangui
