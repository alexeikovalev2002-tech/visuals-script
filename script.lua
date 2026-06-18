-- ============================================
-- Ключевая система + Визуальные эффекты
-- Ключ: visuals
-- ============================================

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старые GUI, чтобы не было конфликтов
for _, v in pairs(playerGui:GetChildren()) do
    if v.Name == "KeySystem" or v.Name == "TopDisplay" then
        v:Destroy()
    end
end

-- Функция применения эффектов (потемнение, FOV, пластик, отключение тумана)
local function applyEffects()
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = 105 end
    local l = game.Lighting
    l.Brightness = 0.35
    l.OutdoorAmbient = Color3.new(0.2, 0.2, 0.2)
    l.Ambient = Color3.new(0.24, 0.24, 0.24)
    l.FogEnd = 100000
    l.FogStart = 0
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and not (player.Character and o:IsDescendantOf(player.Character)) then
            pcall(function() o.Material = Enum.Material.Plastic end)
        end
    end
end

-- ===== ОКНО ВВОДА КЛЮЧА =====
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeySystem"
keyGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = keyGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Введите ключ"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 35)
textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.Text = ""
textBox.PlaceholderText = "Ключ"
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 18
textBox.Parent = mainFrame

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(0.8, 0, 0, 20)
errorLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.new(1, 0, 0)
errorLabel.TextSize = 14
errorLabel.Font = Enum.Font.Gotham
errorLabel.Parent = mainFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.8, 0, 0, 35)
submitBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
submitBtn.Text = "Войти"
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.TextSize = 18
submitBtn.Font = Enum.Font.Gotham
submitBtn.Parent = mainFrame

submitBtn.MouseButton1Click:Connect(function()
    if textBox.Text == "visuals" then
        keyGui:Destroy() -- окно ввода закрывается
        applyEffects()

        -- ===== ВЕРХНИЙ GUI: 🔥 и радужные ♡ =====
        local topGui = Instance.new("ScreenGui")
        topGui.Name = "TopDisplay"
        topGui.Parent = playerGui
        topGui.ResetOnSpawn = false

        local topFrame = Instance.new("Frame")
        topFrame.Size = UDim2.new(0, 0, 0, 0)
        topFrame.Position = UDim2.new(0.5, 0, 0, 20)
        topFrame.BackgroundTransparency = 1
        topFrame.Parent = topGui

        local fireLabel = Instance.new("TextLabel")
        fireLabel.Size = UDim2.new(0, 40, 0, 40)
        fireLabel.Position = UDim2.new(0.5, -20, 0, 0)
        fireLabel.BackgroundTransparency = 1
        fireLabel.Text = "🔥"
        fireLabel.TextSize = 40
        fireLabel.TextColor3 = Color3.new(1, 1, 1)
        fireLabel.Font = Enum.Font.GothamBold
        fireLabel.Parent = topFrame

        local leftHeart = Instance.new("TextLabel")
        leftHeart.Size = UDim2.new(0, 30, 0, 30)
        leftHeart.Position = UDim2.new(0.5, -70, 0, 5)
        leftHeart.BackgroundTransparency = 1
        leftHeart.Text = "♡"
        leftHeart.TextSize = 30
        leftHeart.TextColor3 = Color3.new(1, 0, 0)
        leftHeart.Font = Enum.Font.GothamBold
        leftHeart.Parent = topFrame

        local rightHeart = Instance.new("TextLabel")
        rightHeart.Size = UDim2.new(0, 30, 0, 30)
        rightHeart.Position = UDim2.new(0.5, 40, 0, 5)
        rightHeart.BackgroundTransparency = 1
        rightHeart.Text = "♡"
        rightHeart.TextSize = 30
        rightHeart.TextColor3 = Color3.new(1, 0, 0)
        rightHeart.Font = Enum.Font.GothamBold
        rightHeart.Parent = topFrame

        -- Анимация радужных сердец (бесконечный цикл)
        spawn(function()
            while topGui.Parent do
                for hue = 0, 1, 0.01 do
                    local color = Color3.fromHSV(hue, 1, 1)
                    leftHeart.TextColor3 = color
                    rightHeart.TextColor3 = color
                    wait(0.05)
                end
            end
        end)
    else
        errorLabel.Text = "Неверный ключ!"
        wait(2)
        errorLabel.Text = ""
    end
end)

-- Ввод по Enter
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then submitBtn:Click() end
end)
