local CollectionService = game:GetService("CollectionService")
local Camera = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer
local StudioPixelsY = 699

Player.PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeLeft

local function Tagged(String)
	return CollectionService:GetTagged(String)
end

local function GetObjectsByName(Location)
	local Temp = {}
	for i,v in ipairs(Location:GetChildren()) do
		Temp[v.Name] = v
	end
	return Temp
end

local function HandleElement(Constraint)
	if Constraint:IsA("ScrollingFrame") then
		CollectionService:AddTag(Constraint, "ScrollingFrame")
	elseif Constraint:IsA("UIStroke") then
		CollectionService:AddTag(Constraint, "UIStroke")
	end
end

Player.PlayerGui.ChildAdded:Connect(function(Object)
	if GetObjectsByName(game:GetService("StarterGui"))[Object.Name] then

		Object.DescendantAdded:Connect(function(Constraint)
			HandleElement(Constraint)
		end)

		for _, Constraint in pairs(Object:GetDescendants()) do
			HandleElement(Constraint)
		end

	end
end)

CollectionService:GetInstanceAddedSignal("ScrollingFrame"):Connect(function(Object)
	
	local OriginalThickness = Object.ScrollBarThickness
	
	Object.AutomaticCanvasSize = Enum.AutomaticSize.None
	Object.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Object.ScrollBarThickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)
	
	Object:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
		Object.AutomaticCanvasSize = Enum.AutomaticSize.None
		Object.AutomaticCanvasSize = Enum.AutomaticSize.Y 
		Object.ScrollBarThickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)
	end)
	
end)

CollectionService:GetInstanceAddedSignal("UIStroke"):Connect(function(Object)
	local OriginalThickness = Object.Thickness
	Object.Thickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)
	
	Object.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		Object.Thickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)
	end)
	
end)
