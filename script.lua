local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "MM2 Master Script", HidePremium = false, SaveConfig = true, IntroText = "MM2 Script + ESP"})

local MainTab = Window:MakeTab({Name = "Басты", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddToggle({
    Name = "Шексіз секіру (Infinite Jump)",
    Default = false,
    Callback = function(Value)
        _G.InfJump = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end
})

MainTab:AddButton({
    Name = "Көрінбейтін болу (Invisibility)",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") then
                    v.Transparency = 1
                end
            end
        end
    end
})

local ESPTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483345998", PremiumOnly = false})

ESPTab:AddButton({
    Name = "ESP Қосу (Murderer/Sheriff/Innocent)",
    Callback = function()
        local Players = game:GetService("Players")
        local function ApplyESP(plr)
            if plr ~= Players.LocalPlayer and plr.Character and not plr.Character:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "Highlight"
                Highlight.Parent = plr.Character
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
                
                if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then
                    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then
                    Highlight.FillColor = Color3.fromRGB(0, 0, 255)
                else
                    Highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            ApplyESP(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                ApplyESP(plr)
            end)
        end
    end
})

local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})

CombatTab:AddButton({
    Name = "Aimbot",
    Callback = function()
        local Camera = workspace.CurrentCamera
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local function GetClosestPlayer()
            local Closest = nil
            local MaxDistance = math.huge
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if OnScreen then
                        local MousePos = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                        if Distance < MaxDistance then
                            MaxDistance = Distance
                            Closest = v
                        end
                    end
                end
            end
            return Closest
        end

        game:GetService("RunService").RenderStepped:Connect(function()
            local Target = GetClosestPlayer()
            if Target and Target.Character and Target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
            end
        end)
    end
})

CombatTab:AddButton({
    Name = "Shot Murderer",
    Callback = function()
        local Players = game:GetService("Players")
        for _, v in pairs(Players:GetPlayers()) do
            if v.Backpack:FindFirstChild("Knife") or (v.Character and v.Character:FindFirstChild("Knife")) then
                local Murderer = v.Character
                if Murderer and Murderer:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Murderer.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
})

local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

TeleportTab:AddButton({
    Name = "Teleport to Lobby",
    Callback = function()
        local lobby = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("LobbySpawn")
        if lobby then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = lobby.CFrame * CFrame.new(0, 5, 0)
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(112, 138, -12)
        end
    end
})

TeleportTab:AddButton({
    Name = "Teleport to Map",
    Callback = function()
        local map = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("CoinContainer")
        if map then
            local part = map:FindFirstChildWhichIsA("BasePart", true)
            if part then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 5, 0)
            end
        end
    end
})

OrionLib:Init()

