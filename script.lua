
local questNumber = "1" -- there are up to 25 quests
local selectedNPC = "Razor Boar" -- name of npc

if not game:IsLoaded() then
    game.Loaded:Wait()
end

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
        local newPosition = Vector3.new(position.X, position.Y - 5, position.Z)
        localRoot.Position = newPosition
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

        toolkit.goto(targetRoot.Position)
    end
end

_G.run = true

while _G.run do
    toolkit.autoFarm(selectedNPC)
    task.wait(0.1)
end

local charAddedConn = localChar.CharacterAdded:Connect(function(char)
    localChar = char
    localHum = localChar:WaitForChild("Humanoid")
    localRoot = localChar:WaitForChild("HumanoidRootPart")
end)

connections:add(charAddedConn)
