
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

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local X = Material.Load({
	Title = "ChibuHub",
	Style = 3,
	SizeX = 500,
	SizeY = 350,
	Theme = "Light",
	ColorOverrides = {
		MainFrame = Color3.fromRGB(235,235,235)
	}
})

local Y = X.New({
	Title = "1"
})

local Z = X.New({
	Title = "2"
})

local A = Y.Button({
	Text = "Kill All",
	Callback = function()
		print("hello")
	end,
	Menu = {
		Information = function(self)
			X.Banner({
				Text = "This function can get you banned in up-to-date servers; use at your own risk."
			})
		end
	}
})

local B = Y.Toggle({
	Text = "I'm a switch",
	Callback = function(Value)
		print(Value)
	end,
	Enabled = false
})

local C = Y.Slider({
	Text = "Slip and... you get the idea",
	Callback = function(Value)
		print(Value)
	end,
	Min = 200,
	Max = 400,
	Def = 300
})

local D = Y.Dropdown({
	Text = "Dropping care package",
	Callback = function(Value)
		print(Value)
	end,
	Options = {
		"Floor 1",
		"Floor 2",
		"Floor 3",
		"Floor 4",
		"Floor 5"
	},
	Menu = {
		Information = function(self)
			X.Banner({
				Text = "Test alert!"
			})
		end
	}
})

local E = Y.ChipSet({
	Text = "Chipping away",
	Callback = function(ChipSet)
		table.foreach(ChipSet, function(Option, Value)
			print(Option, Value)
		end)
	end,
	Options = {
		ESP = true,
		TeamCheck = false,
		UselessBool = {
			Enabled = true,
			Menu = {
				Information = function(self)
					X.Banner({
						Text = "This bool has absolutely no purpose whatsoever."
					})
				end
			}
		}
	}
})

local F = Y.DataTable({
	Text = "Chipping away",
	Callback = function(ChipSet)
		table.foreach(ChipSet, function(Option, Value)
			print(Option, Value)
		end)
	end,
	Options = {
		ESP2 = true,
		TeamCheck2 = false,
		UselessBool2 = {
			Enabled = true,
			Menu = {
				Information = function(self)
					X.Banner({
						Text = "This bool ALSO has absolutely no purpose. Sorry."
					})
				end
			}
		}
	}
})

local G = Y.ColorPicker({
	Text = "ESP Colour",
	Default = Color3.fromRGB(0,255,110),
	Callback = function(Value)
		print("RGB:", Value.R * 255, Value.G * 255, Value.B * 255)
	end,
	Menu = {
		Information = function(self)
			X.Banner({
				Text = "This changes the color of your ESP."
			})
		end
	}
})

local H = Y.TextField({
	Text = "Country",
	Callback = function(Value)
		print(Value)
	end,
	Menu = {
		GB = function(self)
			self.SetText("GB")
		end,
		JP = function(self)
			self.SetText("JP")
		end,
		KO = function(self)
			self.SetText("KO")
		end
	}
})
