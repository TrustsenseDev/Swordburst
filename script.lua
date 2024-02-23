
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

local Settings = {
    selectedNPC = "Razor Boar",
    selectedQuest = "1",
    autofarm = false,
    autoquest = false,
}

local toolkit = {} do
    function toolkit.goto(position)
        local newPosition = CFrame.new(position.X, position.Y - 5, position.Z)

        if not localRoot then return end
        localRoot.CFrame = newPosition
    end

    function toolkit.takeQuest(questNum)
        gameDataCollected.questEvent:FireServer(typeof(questNum) == "string" and questNum or tostring(questNum))
    end

    function toolkit.getMobsNames()
        local mobs = {}

        for _, potentialMob in pairs(gameDataCollected.MobsFolder:GetChildren()) do
            if not table.find(mobs, potentialMob.Name) then
                table.insert(mobs, potentialMob.Name)
            end
        end

        return mobs
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

    function toolkit.attack(mobs)
        ReplicatedStorage.Systems.Combat.PlayerAttack:FireServer({mobs})
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

        while Settings.autofarm do
            toolkit.attack(target)
            task.wait(0.5)
        end
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

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local Window = Material.Load({
	Title = "ChibuHub",
	Style = 1,
	SizeX = 300,
	SizeY = 350,
	Theme = "Dark"
})

local Main = Window.New({
	Title = "1"
})
do
    Main.Toggle({
        Text = "Autofarm",
        Callback = function(Value)
            Settings.autofarm = Value

            while Settings.autofarm do
                toolkit.autoFarm(Settings.selectedNPC)
                task.wait(0)
            end
        end,
        Enabled = false
    })

    Main.Dropdown({
        Text = "Mobs",
        Callback = function(Value)
            Settings.selectedNPC = Value
        end,
        Options = toolkit.getMobsNames()
    })
end
