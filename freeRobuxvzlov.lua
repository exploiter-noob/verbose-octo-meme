-- Создание интерфейса
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillButton = Instance.new("TextButton")
local TPButton = Instance.new("TextButton")

-- Настройка контейнера
ScreenGui.Name = "CustomHybridMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Настройка главного окна
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 8)

-- КНОПКА 1: Бесконечное убийство (ON/OFF)
KillButton.Name = "KillButton"
KillButton.Parent = MainFrame
KillButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
KillButton.Position = UDim2.new(0, 10, 0, 10)
KillButton.Size = UDim2.new(0, 160, 0, 40)
KillButton.Font = Enum.Font.SourceSansBold
KillButton.Text = "KILL OTHERS: OFF"
KillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillButton.TextSize = 14

local KillCorner = Instance.new("UICorner", KillButton)
KillCorner.CornerRadius = UDim.new(0, 6)

-- КНОПКА 2: ТП всех в конец (Одиночный клик)
TPButton.Name = "TPButton"
TPButton.Parent = MainFrame
TPButton.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
TPButton.Position = UDim2.new(0, 10, 0, 60)
TPButton.Size = UDim2.new(0, 160, 0, 40)
TPButton.Font = Enum.Font.SourceSansBold
TPButton.Text = "TP OTHERS TO END"
TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TPButton.TextSize = 14

local TPCorner = Instance.new("UICorner", TPButton)
TPCorner.CornerRadius = UDim.new(0, 6)

-- Переменные
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local isKilling = false

-- ЛОГИКА: Бесконечное убийство (Переключатель)
KillButton.MouseButton1Click:Connect(function()
    isKilling = not isKilling
    if isKilling then
        KillButton.Text = "KILL OTHERS: ON"
        KillButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        
        task.spawn(function()
            while isKilling do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        game:GetService("ReplicatedStorage").Events.KillEvent:FireServer(player)
                    end
                end
                task.wait(0.3)
            end
        end)
    else
        KillButton.Text = "KILL OTHERS: OFF"
        KillButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

-- ЛОГИКА: ТП в конец (Одиночный клик)
TPButton.MouseButton1Click:Connect(function()
    -- Анимация вспышки при нажатии для визуального отклика
    local originalColor = TPButton.BackgroundColor3
    TPButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    task.delay(0.1, function() TPButton.BackgroundColor3 = originalColor end)

    -- Само действие перемещения
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            game:GetService("ReplicatedStorage").Events.SkipEndEvent:FireServer(player)
        end
    end
end)

