-- This plugin turns the parts that you selected into windows!
--Script / plugin by Minedani129

local toolbar = plugin:CreateToolbar("Window Maker")

local button = toolbar:CreateButton("Create Window", "Create a window with selected basePart", "rbxassetid://4458901886")

local function glassMaker(partPosition, partSizeX, partSizeY, partSizeZ, partOrientation)
	local glass = Instance.new("Part", workspace)
	glass.Transparency = 0.5
	glass.Position = partPosition
	glass.Material = Enum.Material.Glass
	glass.Anchored = true
	glass.Orientation = partOrientation
	print("Placing window at "..tostring(glass.Position))
	if partSizeX > partSizeZ then
		glass.Size = Vector3.new(partSizeX, partSizeY, 1)
	elseif partSizeX < partSizeZ then
		glass.Size = Vector3.new(1, partSizeY, partSizeZ)
	else
		glass.Size = Vector3.new(partSizeX, partSizeY, partSizeZ)
	end
end

local function onWindow()
	if #game.Selection:Get() == 0 then
		warn("Window Maker Critical Error: You did not select any objects.")
		return
	end
	for _, object in pairs(game.Selection:Get()) do
		if object:IsA("BasePart") then
			local touchingParts = object:GetTouchingParts()
			local glassReference = object:Clone()
			glassReference.Position = object.Position
			glassReference.Size = object.Size
			
			if object.ClassName == "NegateOperation" then
				warn("Window Maker Critical Error: Part is already negated. Please un-negate any selected parts.")
				return
			end
			if #touchingParts == 0 then
				warn("Windows Maker Critical Error: Negated part is not touching any other part. Please reposition parts into other parts.")
				return
			end

			table.insert(touchingParts, plugin:Negate({object})[1])
			plugin:Union(touchingParts)
			glassMaker(glassReference.Position, glassReference.Size.X, glassReference.Size.Y, glassReference.Size.Z, glassReference.Orientation)
			
		else
			warn("Window Maker Warning:"..object.Name.. " is not a BasePart. Skipping object.")
		end
	end
end

button.Click:Connect(onWindow)