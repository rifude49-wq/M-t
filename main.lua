-- ===== CLEAN =====
if game.CoreGui:FindFirstChild("RifuHub") then
    game.CoreGui.RifuHub:Destroy()
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "RifuHub"

-- ===== PILL =====
local pill = Instance.new("TextButton", gui)
pill.Size = UDim2.new(0,60,0,160)
pill.Position = UDim2.new(1,-70,0.12,0)
pill.Text = "Rifu"
pill.BackgroundColor3 = Color3.fromRGB(30,30,30)
pill.TextColor3 = Color3.fromRGB(255,255,255)
pill.TextStrokeTransparency = 0
pill.Font = Enum.Font.GothamBold
pill.TextScaled = true
Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

-- ===== FRAME =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,0,0,0)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- ===== ANIMATION =====
local open = false
pill.MouseButton1Click:Connect(function()
    open = not open
    if open then
        frame.Visible = true
        for i=1,15 do
            frame.Size = frame.Size:Lerp(UDim2.new(0,260,0,380),0.25)
            task.wait()
        end
    else
        for i=1,15 do
            frame.Size = frame.Size:Lerp(UDim2.new(0,0,0,0),0.25)
            task.wait()
        end
        frame.Visible = false
    end
end)

-- ===== PLAYER =====
local player = game.Players.LocalPlayer
local function getHRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function teleTo(part)
    local hrp = getHRP()
    if hrp and part then
        hrp.CFrame = part.CFrame + Vector3.new(0,5,0)
    end
end

-- ===== TELE =====
local function teleClair()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name == "Clair" then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then teleTo(p) break end
        end
    end
end

local function teleOrbital()
    for _,v in pairs(workspace:GetDescendants()) do
        if string.find(string.lower(v.Name),"orbital") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then teleTo(p) break end
        end
    end
end

-- ===== TOGGLES =====
local toggles = {
    animals=false,
    metal=false,
    solar=false,
    ice=false,
    gold=false,
    stone=false
}

-- ===== CLEAR =====
local function clearTypeESP(typeName)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:GetAttribute("ESP_TYPE")==typeName then
            if v:FindFirstChild("ESP") then v.ESP:Destroy() end
            if v:FindFirstChild("BillboardGui") then v.BillboardGui:Destroy() end
        end
    end
end

-- ===== ESP FUNCTIONS =====
local function makeESP(v, textName, color, typeName)
    if not v:IsA("Model") then return end
    if v:FindFirstChild("ESP") then return end

    local part = v:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end

    local h = Instance.new("Highlight", v)
    h.Name = "ESP"
    h.FillColor = color
    h.FillTransparency = 0.3

    v:SetAttribute("ESP_TYPE", typeName)

    local bill = Instance.new("BillboardGui", v)
    bill.Size = UDim2.new(0,120,0,40)
    bill.AlwaysOnTop = true
    bill.Adornee = part

    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = textName
    txt.TextColor3 = color
    txt.TextStrokeTransparency = 0
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
end

local function animalsESP(v)
    if v:IsDescendantOf(workspace:FindFirstChild("animals") or workspace) then
        makeESP(v,"ANIMAL",Color3.fromRGB(0,255,0),"animals")
    end
end

local function metalESP(v)
    if string.find(string.lower(v.Name),"metal") then
        makeESP(v,"METAL",Color3.fromRGB(255,255,255),"metal")
    end
end

local function solarESP(v)
    if string.find(string.lower(v.Name),"solar") then
        makeESP(v,"SOLAR",Color3.fromRGB(0,170,255),"solar")
    end
end

local function iceESP(v)
    if string.find(string.lower(v.Name),"ice") then
        makeESP(v,"ICE",Color3.fromRGB(0,255,255),"ice")
    end
end

local function goldESP(v)
    if string.find(string.lower(v.Name),"gold") then
        makeESP(v,"GOLD",Color3.fromRGB(255,215,0),"gold")
    end
end

local function stoneESP(v)
    if string.find(string.lower(v.Name),"stone") then
        makeESP(v,"STONE",Color3.fromRGB(170,170,170),"stone")
    end
end

-- ===== SCAN =====
local function scan()
    for _,v in pairs(workspace:GetDescendants()) do
        if toggles.animals then animalsESP(v) end
        if toggles.metal then metalESP(v) end
        if toggles.solar then solarESP(v) end
        if toggles.ice then iceESP(v) end
        if toggles.gold then goldESP(v) end
        if toggles.stone then stoneESP(v) end
    end
end

workspace.DescendantAdded:Connect(function(v)
    if toggles.animals then animalsESP(v) end
    if toggles.metal then metalESP(v) end
    if toggles.solar then solarESP(v) end
    if toggles.ice then iceESP(v) end
    if toggles.gold then goldESP(v) end
    if toggles.stone then stoneESP(v) end
end)

-- ===== BUTTON =====
local function btn(name,pos,mode,func)
    local b=Instance.new("TextButton",frame)
    b.Size=UDim2.new(1,0,0,40)
    b.Position=UDim2.new(0,0,0,pos)
    b.BackgroundColor3=Color3.fromRGB(50,50,50)
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.TextStrokeTransparency=0
    b.TextScaled=true
    b.Font=Enum.Font.GothamBold

    if mode=="toggle" then
        b.Text=name.." [OFF]"
        b.MouseButton1Click:Connect(function()
            local s=func()
            b.Text=name.." ["..(s and "ON" or "OFF").."]"
        end)
    else
        b.Text=name.." | CLICK"
        b.MouseButton1Click:Connect(func)
    end
end

-- ===== BUTTONS =====
btn("Clair",20,"click",teleClair)
btn("Orbital",70,"click",teleOrbital)

btn("Animals",120,"toggle",function()
    toggles.animals=not toggles.animals
    if toggles.animals then scan() else clearTypeESP("animals") end
    return toggles.animals
end)

btn("Metal",160,"toggle",function()
    toggles.metal=not toggles.metal
    if toggles.metal then scan() else clearTypeESP("metal") end
    return toggles.metal
end)

btn("Solar",200,"toggle",function()
    toggles.solar=not toggles.solar
    if toggles.solar then scan() else clearTypeESP("solar") end
    return toggles.solar
end)

btn("Ice",240,"toggle",function()
    toggles.ice=not toggles.ice
    if toggles.ice then scan() else clearTypeESP("ice") end
    return toggles.ice
end)

btn("Gold",280,"toggle",function()
    toggles.gold=not toggles.gold
    if toggles.gold then scan() else clearTypeESP("gold") end
    return toggles.gold
end)

btn("Stone",320,"toggle",function()
    toggles.stone=not toggles.stone
    if toggles.stone then scan() else clearTypeESP("stone") end
    return toggles.stone
end)
