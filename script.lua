
local questNumber = "1" -- there are up to 25 quests
local selectedNPC = "Razor Boar" -- name of npc

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local client = Players.LocalPlayer
local localChar = client.Character or client.CharacterAdded:Wait()
local localHum = localChar:FindFirstChildOfClass("Humanoid")
local localRoot = localChar:FindFirstChild("HumanoidRootPart")

local gameDataCollected = {
    questsNPC = workspace.QuestNPCs,
    questEvent = ReplicatedStorage.Systems.Quests.AcceptQuest,
    MobsFolder = workspace.Mobs, -- all have humanoidrootpart
}

--[[
    local ohString1 = "1"

game:GetService("ReplicatedStorage").Systems.Quests.AcceptQuest:FireServer(ohString1)
]]

local connections = {} do
    function connections:add(conn: RBXScriptConnection)
        table.insert(self, conn)
    end
end

local toolkit = {} do
    function toolkit.goto(position)
        local newPosition = CFrame.new(position.X, position.Y - 5, position.Z)

        if not localRoot then return end
    end

    function toolkit.takeQuest(questNum)
        gameDataCollected.questEvent:FireServer(typeof(questNum) == "string" and questNum or tostring(questNum))
    end

    function toolkit.getClosestMob(mobName: string)
        local closestMob = nil
        local closestDistance = math.huge

        for _, potentialMob in pairs(gameDataCollected.MobsFolder:GetChildren()) do
            if potentialMob:IsA("Model") and potentialMob.Name == mobName and potentialMob:FindFirstChild("HumanoidRootPart") then
                local distance = (localRoot.Position - potentialMob.HumanoidRootPart.Position).Magnitude

                if distance < closestDistance then
                    closestMob = potentialMob
                    closestDistance = distance
                end
            end
        end

        return closestMob
    end

    function toolkit.autoFarm(mob: string)
        if not mob then return end
        local target = toolkit.getClosestMob(mob)
        if not target then return end

        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        local function setCollisionGroup(part)
            if part:IsA("BasePart") then
                PhysicsService:SetPartCollisionGroup(part, "NoCharacterCollision")
            end
        end

        for _, part in pairs(localChar:GetDescendants()) do
            setCollisionGroup(part)
        end

        toolkit.goto(targetRoot.Position)
    end
end

local function characterAdded(char)
    localChar = char
    localHum = localChar:WaitForChild("Humanoid")
    localRoot = localChar:WaitForChild("HumanoidRootPart")

    for _, part in pairs(localChar:GetDescendants()) do
        if part:IsA("BasePart") then
            PhysicsService:SetPartCollisionGroup(part, "NoCharacterCollision")
        end
    end
end

local charAddedConn = client.CharacterAdded:Connect(characterAdded)
characterAdded(localChar)

connections:add(charAddedConn)

local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)("Pepsi's UI Library")
local Window = Library:CreateWindow({
    Name = 'Pepsi Library',
    Themeable = {
        Info = 'Discord Server: VzYTJ7Y',
        Credit = true,
    },
    DefaultTheme = shared.themename or '{"__Designer.Colors.main":"4dbed9"}'
})

local GeneralTab = Window:CreateTab({
    Name = 'General'
})

local Section = GeneralTab:CreateSection({
    Name = 'Section Number 1',
    Side = 'Right'
})

local Label = Section:CreateLabel({
    Text = 'Label'
})

local Toggle = Section:AddToggle({
    Name = 'Autofarm',
    Value = true,
    Flag = 'autofarm',
    Locked = true,
    Keybind = {
        Flag = 'keybind',
        Mode = 'Hold',
        Value = Enum.KeyCode.F
    },
    Callback = function( state )
        if ( state ) then
            print('On')
        else
            print('Off')
        end
    end
})
