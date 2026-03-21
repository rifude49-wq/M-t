-- ====== TOGGLES ======
local toggles = {
    solar = false,
    lizard = false,
    clair = false,
    orbital = false,
    metal = false
}

-- ====== CLEAR ESP ======
local function clearESP()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:FindFirstChild("ESP") then v.ESP:Destroy() end
        if v:FindFirstChild("NameESP") then v.NameESP:Destroy() end
        if v:FindFirstChild("ESP_DONE") then v.ESP_DONE:Destroy() end
    end
end

-- ====== GUI ======
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,280)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- ===== AVATAR =====
local avatar = Instance.new("ImageLabel", frame)
avatar.Size = UDim2.new(0,40,0,40)
avatar.Position = UDim2.new(0,5,0,5)
avatar.BackgroundTransparency = 1
avatar.Image = "https://yt3.googleusercontent.com/Z7UmfvXSUUf21znB8j4Po-xNdjjjLr5SdmGCubDFp7ljWWVzeWYQ0uKZj9Ja6BTbJ7kB03F-uQ=s160-c-k-c0x00ffffff-no-rj"

local corner = Instance.new("UICorner", avatar)
corner.CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke", avatar)
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Thickness = 2

-- ===== DRAG =====
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ===== OPEN GUI BUTTON =====
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,100,0,40)
openBtn.Position = UDim2.new(0,10,0,10)
openBtn.Text = "Mở GUI"

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ===== CLOSE =====
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"

close.MouseButton1Click:Connect(function()
    clearESP()
    gui:Destroy()
end)

-- ===== MINIMIZE =====
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-60,0,0)
minimize.Text = "-"

local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    for _,v in pairs(frame:GetChildren()) do
        if v:IsA("TextButton") and v ~= minimize and v ~= close then
            v.Visible = not minimized
        end
    end
    
    frame.Size = minimized and UDim2.new(0,230,0,30) or UDim2.new(0,230,0,280)
end)

-- ===== BUTTON CREATOR =====
local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Position = UDim2.new(0,0,0,posY)
    btn.Text = text.." [OFF]"

    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = text.." ["..(state and "ON" or "OFF").."]"
    end)
end

-- ===== ESP =====
local function solarESP(v)
    if v.Name == "solar_panel" and not v:FindFirstChild("NameESP") then
        local part = v:FindFirstChildWhichIsA("BasePart")
        if part then
            local bill = Instance.new("BillboardGui", v)
            bill.Name = "NameESP"
            bill.Size = UDim2.new(0,100,0,40)
            bill.AlwaysOnTop = true
            bill.Adornee = part
            
            local t = Instance.new("TextLabel", bill)
            t.Size = UDim2.new(1,0,1,0)
            t.BackgroundTransparency = 1
            t.Text = "Solar Panel"
        end
    end
end

local function lizardESP(v)
    if v.Name == "lizard" and not v:FindFirstChild("ESP") then
        local h = Instance.new("Highlight", v)
        h.Name = "ESP"
        h.FillColor = Color3.fromRGB(0,255,0)
    end
end

local function clairESP(v)
    if v.Name == "Clair" and not v:FindFirstChild("NameESP") then
        local part = v:FindFirstChildWhichIsA("BasePart")
        if part then
            local bill = Instance.new("BillboardGui", v)
            bill.Name = "NameESP"
            bill.Size = UDim2.new(0,100,0,40)
            bill.AlwaysOnTop = true
            bill.Adornee = part
            
            local t = Instance.new("TextLabel", bill)
            t.Size = UDim2.new(1,0,1,0)
            t.BackgroundTransparency = 1
            t.Text = "Clair"
        end
    end
end

local function orbitalESP(v)
    if string.find(string.lower(v.Name),"orbital") and not v:FindFirstChild("ESP_DONE") then
        Instance.new("BoolValue", v).Name = "ESP_DONE"
        Instance.new("Highlight", v)
    end
end

local function metalESP(v)
    if v.Name == "metal_node" and not v:FindFirstChild("ESP_DONE") then
        Instance.new("BoolValue", v).Name = "ESP_DONE"
        Instance.new("Highlight", v)
    end
end

-- ===== LOOP =====
workspace.DescendantAdded:Connect(function(v)
    if toggles.solar then solarESP(v) end
    if toggles.lizard then lizardESP(v) end
    if toggles.clair then clairESP(v) end
    if toggles.orbital then orbitalESP(v) end
    if toggles.metal then metalESP(v) end
end)

-- ===== BUTTONS =====
createButton("Solar", 50, function()
    toggles.solar = not toggles.solar return toggles.solar end)

createButton("Lizard", 90, function()
    toggles.lizard = not toggles.lizard return toggles.lizard end)

createButton("Clair", 130, function()
    toggles.clair = not toggles.clair return toggles.clair end)

createButton("Orbital", 170, function()
    toggles.orbital = not toggles.orbital return toggles.orbital end)

createButton("Metal", 210, function()
    toggles.metal = not toggles.metal return toggles.metal end)
