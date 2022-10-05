local CollectionService = game:GetService("CollectionService")
local Camera = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer
local StudioPixelsY = 699

Player.PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeLeft

local function GetObjectsByName(Location)
	local Temp = {}
	for _,v in ipairs(Location:GetChildren()) do
		Temp[v.Name] = v
	end
	return Temp
end

local function HandleElement(Constraint)
	if Constraint:IsA("ScrollingFrame") then
		CollectionService:AddTag(Constraint, "ScrollingFrame")
	elseif Constraint:IsA("UIStroke") then
		CollectionService:AddTag(Constraint, "UIStroke")
	elseif Constraint:IsA("UIPadding") then
		CollectionService:AddTag(Constraint, "UIPadding")
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


CollectionService:GetInstanceAddedSignal("UIPadding"):Connect(function(Object)
	local OriginalSizes = {
		PaddingBottom = Object.PaddingBottom,
		PaddingLeft = Object.PaddingLeft,
		PaddingRight = Object.PaddingRight,
		PaddingTop = Object.PaddingTop
	}

	Object.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()

		for Property, Value in pairs(OriginalSizes) do
			Object[Property] = UDim.new(0, Camera.ViewportSize.Y * (Value.Offset / StudioPixelsY)) 
		end

	end)
end)

CollectionService:GetInstanceAddedSignal("ScrollingFrame"):Connect(function(Object) task.wait()
	local UILayout

	for _, Layout in pairs(Object:GetChildren()) do
		if Layout:IsA("UILayout") then
			UILayout = Layout
			break
		end
	end

	local OriginalThickness = Object.ScrollBarThickness

	Object.ScrollBarThickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)
	Object.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y)

	Object:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
		Object.ScrollBarThickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)
		Object.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y)
	end)

end)

CollectionService:GetInstanceAddedSignal("UIStroke"):Connect(function(Object)
	local OriginalThickness = Object.Thickness
	Object.Thickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)

	Object.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		Object.Thickness = Camera.ViewportSize.Y * (OriginalThickness / StudioPixelsY)
	end)

end)
