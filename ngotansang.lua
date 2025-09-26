
local SanguiList1 = {}
SanguiList1.__index = SanguiList1

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI khởi tạo
function SanguiList1:CreateWindow(titleText)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SanguiList1"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    gui.ResetOnSpawn = false

    -- Logo toggle
    local logo = Instance.new("ImageButton")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(0, 10, 0, 10)
    logo.Image = "rbxassetid://3926305904" -- icon default
    logo.BackgroundTransparency = 1
    logo.Parent = gui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    mainFrame.Visible = true
    mainFrame.Parent = gui

    -- TopBar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    topBar.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Text = titleText or "SanguiList1"
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 5, 0, 0)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = topBar

    -- Nút điều khiển
    local function createBtn(txt, posX)
        local btn = Instance.new("TextButton")
        btn.Text = txt
        btn.Size = UDim2.new(0, 30, 1, 0)
        btn.Position = UDim2.new(1, posX, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Parent = topBar
        return btn
    end

    local closeBtn = createBtn("×", -30)
    local maximizeBtn = createBtn("÷", -60)
    local minimizeBtn = createBtn("-", -90)

    -- Tab list
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(0, 120, 1, -30)
    tabList.Position = UDim2.new(0, 0, 0, 30)
    tabList.CanvasSize = UDim2.new(0, 0, 2, 0)
    tabList.ScrollBarThickness = 4
    tabList.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    tabList.Parent = mainFrame

    -- Content Frame
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -120, 1, -30)
    content.Position = UDim2.new(0, 120, 0, 30)
    content.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    content.Parent = mainFrame

    -- Chức năng logo toggle
    logo.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    -- Nút X = xóa
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Nút - = ẩn menu
    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    -- Nút ÷ = phóng to/thu nhỏ
    local maximized = false
    maximizeBtn.MouseButton1Click:Connect(function()
        maximized = not maximized
        if maximized then
            mainFrame.Size = UDim2.new(0, 700, 0, 500)
        else
            mainFrame.Size = UDim2.new(0, 500, 0, 350)
        end
    end)

    -- API quản lý tab
    local WindowAPI = {}
    WindowAPI.Content = content
    WindowAPI.TabList = tabList

    function WindowAPI:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Text = name
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 14
        tabBtn.Parent = tabList

        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.Visible = false
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 6
        tabFrame.Parent = content

        local elementY = 10
        local function newElement(obj)
            obj.Position = UDim2.new(0, 10, 0, elementY)
            obj.Parent = tabFrame
            elementY = elementY + obj.Size.Y.Offset + 10
            tabFrame.CanvasSize = UDim2.new(0, 0, 0, elementY)
        end

        local TabAPI = {}

        function TabAPI:Show()
            for _, frame in pairs(content:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            tabFrame.Visible = true
        end

        function TabAPI:CreateLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Text = text
            lbl.Size = UDim2.new(0, 250, 0, 25)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            newElement(lbl)
        end

        function TabAPI:CreateButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Text = text
            btn.Size = UDim2.new(0, 250, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            newElement(btn)
            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function TabAPI:CreateToggle(text, default, callback)
            local state = default or false
            local btn = Instance.new("TextButton")
            btn.Text = text .. ": " .. tostring(state)
            btn.Size = UDim2.new(0, 250, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            newElement(btn)

            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = text .. ": " .. tostring(state)
                pcall(callback, state)
            end)
        end

        function TabAPI:CreateSlider(text, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 250, 0, 40)
            frame.BackgroundColor3 = Color3.fromRGB(80,80,80)
            newElement(frame)

            local lbl = Instance.new("TextLabel", frame)
            lbl.Text = text .. ": " .. tostring(default)
            lbl.Size = UDim2.new(1, 0, 0.5, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14

            local slider = Instance.new("TextButton", frame)
            slider.Size = UDim2.new(1, -20, 0, 15)
            slider.Position = UDim2.new(0, 10, 1, -20)
            slider.BackgroundColor3 = Color3.fromRGB(120,120,120)
            slider.Text = ""

            local val = default or min
            lbl.Text = text .. ": " .. val

            slider.MouseButton1Down:Connect(function()
                local moveConn
                moveConn = UIS.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        val = math.floor(min + (max - min) * rel)
                        lbl.Text = text .. ": " .. val
                        pcall(callback, val)
                    end
                end)
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if moveConn then moveConn:Disconnect() end
                    end
                end)
            end)
        end

        function TabAPI:CreateDropdown(text, options, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 250, 0, 30)
            frame.BackgroundColor3 = Color3.fromRGB(80,80,80)
            newElement(frame)

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Text = text .. " ▼"
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14

            local listFrame = Instance.new("Frame", frame)
            listFrame.Size = UDim2.new(1, 0, 0, #options * 25)
            listFrame.Position = UDim2.new(0, 0, 1, 0)
            listFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
            listFrame.Visible = false

            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Text = opt
                optBtn.Size = UDim2.new(1, 0, 0, 25)
                optBtn.Position = UDim2.new(0, 0, 0, (i-1)*25)
                optBtn.TextColor3 = Color3.fromRGB(255,255,255)
                optBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
                optBtn.Parent = listFrame
                optBtn.MouseButton1Click:Connect(function()
                    btn.Text = text .. ": " .. opt
                    listFrame.Visible = false
                    pcall(callback, opt)
                end)
            end

            btn.MouseButton1Click:Connect(function()
                listFrame.Visible = not listFrame.Visible
            end)
        end

        function TabAPI:CreateInput(text, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 250, 0, 30)
            frame.BackgroundColor3 = Color3.fromRGB(80,80,80)
            newElement(frame)

            local box = Instance.new("TextBox", frame)
            box.Size = UDim2.new(1, -10, 1, 0)
            box.Position = UDim2.new(0, 5, 0, 0)
            box.PlaceholderText = text
            box.Text = ""
            box.TextColor3 = Color3.fromRGB(255,255,255)
            box.BackgroundColor3 = Color3.fromRGB(100,100,100)
            box.Font = Enum.Font.Gotham
            box.TextSize = 14

            box.FocusLost:Connect(function(enter)
                if enter then
                    pcall(callback, box.Text)
                end
            end)
        end

        function TabAPI:CreateKeybind(text, defaultKey, callback)
            local btn = Instance.new("TextButton")
            btn.Text = text .. ": " .. (defaultKey and defaultKey.Name or "None")
            btn.Size = UDim2.new(0, 250, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            newElement(btn)

            local key = defaultKey
            btn.MouseButton1Click:Connect(function()
                btn.Text = text .. ": ..."
                local conn
                conn = UIS.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        btn.Text = text .. ": " .. key.Name
                        pcall(callback, key)
                        conn:Disconnect()
                    end
                end)
            end)

            UIS.InputBegan:Connect(function(input, processed)
                if not processed and key and input.KeyCode == key then
                    pcall(callback, key)
                end
            end)
        end

        tabBtn.MouseButton1Click:Connect(function()
            TabAPI:Show()
        end)

        return TabAPI
    end

    return WindowAPI
end

return SanguiList1
