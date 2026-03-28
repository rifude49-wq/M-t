-- ===== LOAD SAFE =====
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

local player = game.Players.LocalPlayer

-- ===== RESET =====
pcall(function()
    if player.PlayerGui:FindFirstChild("RifuHUD") then
        player.PlayerGui.RifuHUD:Destroy()
    end
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "RifuHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,300)
frame.Position = UDim2.new(0.5,-130,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)

local function btn(name,callback)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(1,0,0,40)
    b.Text = name.." [OFF]"
    b.TextScaled = true

    b.MouseButton1Click:Connect(function()
        local state = callback()
        if state ~= nil then
            b.Text = name.." ["..(state and "ON" or "OFF").."]"
        end
    end)
end

-- ===== VAR =====
local toggles = {
    gold=false,
    animals=false
}

local MAX_ESP = 40
local espCount = 0

-- ===== ROOT =====
local function root()
    local c = player.Character or player.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end

-- ===== ESP =====
local function addESP(v,color,name)
    if espCount >= MAX_ESP then return end
    if not (v:IsA("Model") or v:IsA("BasePart")) then return end
    if v:FindFirstChild(name) then return end

    local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
    if not part then return end

    local r = root()
    if (r.Position - part.Position).Magnitude > 150 then return end

    local h = Instance.new("Highlight")
    h.Name = name
    h.FillColor = color
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0
    h.Adornee = v
    h.Parent = v

    espCount += 1
end

local function removeESP(name)
    for _,v in pairs(workspace:GetDescendants()) do
        local h = v:FindFirstChild(name)
        if h and h:IsA("Highlight") then
            h:Destroy()
        end
    end
end

-- ===== SYNC ESP COUNT (FIX BUG) =====
task.spawn(function()
    while true do
        task.wait(10)
        local c = 0
        for _,v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("ESP_GOLD") or v:FindFirstChild("ESP_ANIMAL") then
                c += 1
            end
        end
        espCount = c
    end
end)

-- ===== SCAN NHẸ =====
local function scanESP()
    local scanned = 0

    for _,v in pairs(workspace:GetDescendants()) do
        if scanned > 300 then break end
        scanned += 1

        local n = v.Name:lower()

        if toggles.gold and string.find(n,"gold") then
            addESP(v,Color3.fromRGB(255,215,0),"ESP_GOLD")
        end

        if toggles.animals and v:IsA("Model") then
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum and not game.Players:GetPlayerFromCharacter(v) then
                addESP(v,Color3.fromRGB(0,255,0),"ESP_ANIMAL")
            end
        end
    end
end

-- ===== EVENT =====
workspace.DescendantAdded:Connect(function(v)
    task.defer(function()
        local n = v.Name:lower()

        if toggles.gold and string.find(n,"gold") then
            addESP(v,Color3.fromRGB(255,215,0),"ESP_GOLD")
        end

        if toggles.animals and v:IsA("Model") then
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum and not game.Players:GetPlayerFromCharacter(v) then
                addESP(v,Color3.fromRGB(0,255,0),"ESP_ANIMAL")
            end
        end
    end)
end)

-- ===== TELE =====
local function teleTo(name)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and string.find(v.Name:lower(),name) then
            local p = v:FindFirstChild("HumanoidRootPart")
                or v.PrimaryPart
                or v:FindFirstChildWhichIsA("BasePart")

            if p then
                root().CFrame = p.CFrame + Vector3.new(0,5,0)
                break
            end
        end
    end
end

-- ===== BUTTON =====
btn("Gold ESP",function()
    toggles.gold = not toggles.gold
    if toggles.gold then scanESP() else removeESP("ESP_GOLD") end
    return toggles.gold
end)

btn("Animals ESP",function()
    toggles.animals = not toggles.animals
    if toggles.animals then scanESP() else removeESP("ESP_ANIMAL") end
    return toggles.animals
end)

btn("Tele Orbital",function()
    teleTo("orbital")
end)

btn("Tele Clair",function()
    teleTo("clair")
end)scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
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
