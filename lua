local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local rightMouseDown = false

local function getClosestTarget()
	local character = LocalPlayer.Character
	if not character then return nil end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local closestTarget = nil
	local closestDistance = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team == LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local dist = (head.Position - hrp.Position).Magnitude
			if dist < closestDistance then
				closestDistance = dist
				closestTarget = head
			end
		end
	end

	for _, npc in pairs(workspace:GetChildren()) do
		if npc:IsA("Model") and npc:FindFirstChild("Head") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
			local npcTeam = nil
			if npc:FindFirstChild("Team") and typeof(npc.Team.Value) == "Instance" then
				npcTeam = npc.Team.Value
			end
			if npc ~= character and npcTeam == LocalPlayer.Team then
				local head = npc.Head
				local dist = (head.Position - hrp.Position).Magnitude
				if dist < closestDistance then
					closestDistance = dist
					closestTarget = head
				end
			end
		end
	end

	return closestTarget
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		rightMouseDown = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		rightMouseDown = false
	end
end)

RunService.RenderStepped:Connect(function()
	if rightMouseDown then
		local targetHead = getClosestTarget()
		if targetHead then
			local cameraCFrame = Camera.CFrame
			local direction = (targetHead.Position - cameraCFrame.Position).Unit
			Camera.CFrame = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + direction)
		end
	end
end)
