-- ===== RESET =====
pcall(function()
    game.CoreGui:FindFirstChild("RifuHUD"):Destroy()
end)

-- ===== VAR =====
local player = game.Players.LocalPlayer
local toggles = {
    solar=false, metal=false, gold=false,
    stone=false, ice=false, autoheal=false
}

-- ===== GUI =====
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name="RifuHUD"

local pill = Instance.new("TextButton", gui)
pill.Size = UDim2.new(0,30,0,80)
pill.Position = UDim2.new(1,-40,0.3,0)
pill.BackgroundColor3 = Color3.fromRGB(0,0,0)
pill.Text=""
Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,420)
frame.Position = UDim2.new(0.5,-150,0.5,-210)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible=false

pill.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BackgroundTransparency=1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

-- ===== ESP CORE =====
local function addESP(v,color,name)
    if v:FindFirstChild(name) then return end
    local h = Instance.new("Highlight")
    h.Name = name
    h.FillColor = color
    h.Adornee = v
    h.Parent = v
end

local function removeESP(name)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:FindFirstChild(name) then
            v[name]:Destroy()
        end
    end
end

local function scan()
    for _,v in pairs(workspace:GetDescendants()) do
        local n = string.lower(v.Name)

        if toggles.solar and n=="solar_panel" then
            addESP(v,Color3.fromRGB(255,255,0),"ESP_SOLAR")
        end
        if toggles.metal and n=="metal_node" then
            addESP(v,Color3.fromRGB(180,180,255),"ESP_METAL")
        end
        if toggles.gold and n=="gold_node" then
            addESP(v,Color3.fromRGB(255,215,0),"ESP_GOLD")
        end
        if toggles.stone and n=="stone_node" then
            addESP(v,Color3.fromRGB(150,150,150),"ESP_STONE")
        end
        if toggles.ice and string.find(n,"ice") then
            addESP(v,Color3.fromRGB(0,255,255),"ESP_ICE")
        end
    end
end

workspace.DescendantAdded:Connect(function(v)
    task.defer(scan)
end)

-- ===== AUTO FIX (QUAN TRỌNG) =====
task.spawn(function()
    while task.wait(2) do
        scan()
    end
end)

-- ===== BUTTON =====
local function btn(name,mode,callback)
    local b = Instance.new("TextButton",scroll)
    b.Size = UDim2.new(1,-5,0,40)
    b.TextScaled = true
    
    if mode=="toggle" then
        b.Text = name.." [OFF]"
    else
        b.Text = name.." [Click here]"
    end
    
    b.MouseButton1Click:Connect(function()
        if mode=="toggle" then
            local state = callback()
            b.Text = name.." ["..(state and "ON" or "OFF").."]"
        else
            callback()
        end
    end)
end

-- ===== AUTO HEAL =====
local remote = game.ReplicatedStorage:FindFirstChild("remotes")
remote = remote and remote:FindFirstChild("heal")

task.spawn(function()
    local last=0
    while task.wait(0.1) do
        if not toggles.autoheal or not remote then continue end
        
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if last==0 then last=hum.Health end
            if hum.Health<last then
                pcall(function()
                    remote:FireServer(player.Character,1)
                end)
            end
            last=hum.Health
        end
    end
end)

-- ===== TELE =====
local function root()
    local c = player.Character or player.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end

local function teleClair()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name=="Clair" and v:FindFirstChild("HumanoidRootPart") then
            root().CFrame=v.HumanoidRootPart.CFrame
            break
        end
    end
end

-- ===== BUTTONS =====
btn("Solar ESP","toggle",function()
    toggles.solar=not toggles.solar
    if not toggles.solar then removeESP("ESP_SOLAR") end
    return toggles.solar
end)

btn("Metal ESP","toggle",function()
    toggles.metal=not toggles.metal
    if not toggles.metal then removeESP("ESP_METAL") end
    return toggles.metal
end)

btn("Gold ESP","toggle",function()
    toggles.gold=not toggles.gold
    if not toggles.gold then removeESP("ESP_GOLD") end
    return toggles.gold
end)

btn("Stone ESP","toggle",function()
    toggles.stone=not toggles.stone
    if not toggles.stone then removeESP("ESP_STONE") end
    return toggles.stone
end)

btn("Ice ESP","toggle",function()
    toggles.ice=not toggles.ice
    if not toggles.ice then removeESP("ESP_ICE") end
    return toggles.ice
end)

btn("Auto Heal","toggle",function()
    toggles.autoheal=not toggles.autoheal
    return toggles.autoheal
end)

btn("Tele Clair","click",teleClair)
