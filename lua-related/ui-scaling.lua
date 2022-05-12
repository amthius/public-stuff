--[[

	[UI-Scaling]
	
	Script that scales UI basically (perfectly) across all platforms.
	This script took a while due to the "scaleBetween" function which was written in JS.
	https://stackoverflow.com/a/31687097
	
	Theres only really one variable you should worry about, which is ScaledResolutionCap.
	Cause once the ViewportSize hits the MinResolution value, it will cap the scaling.
	Vise versa for MaxResolution.
	
	Wish ROBLOX handled this for us automatically but, guess we are left to do things on our own.
	
	[ScrollingFrame Issues]
	
	Unfortunately when it comes to ScrollingFrames, it is just as bad if not worse.
	Luckily though UIGridLayout has some unique properties that helps with the issue.
	Since we can get the cell sizes and specific cell numbers of how many rows there are, also padding.
	We can calculate an accurate number for the CanvasSize (Currently only for Y-Axis)
	
	Why not just use AbsoluteContentSize or AutomaticCanvasSize?
	
	Cause they are both equally as terrible, AbsoluteContentSize does do a better job however its still problematic.
	Mostly depending on how you set it up it just doesn't seem very practical, as for AutomaticCanvasSize.
	You might as well pretend that property doesn't exist it is beyond problematic.
	
	[Conclusion]
	
	UI on ROBLOX is just a nightmare to work with, it never really works out too well due to the loopholes you have to jump.
	This script by no means is something I am proud of cause most of this stuff should be automatically handled for us developers.
	Creating these "fixes" is always a huge annoyance and a complete inconvenience. It would at least help if some of the properties,
	were a little more accurate to the numbers they disabled which would help perfect scaling, through their "automatic" nature.
	However for the many years of people complaining with UI, there just isn't really any improvement done to it.
	
]]--


local CollectionService = game:GetService("CollectionService")
local Camera = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer

local MaxResolution = 1080
local MinResolution = 480
local ScaledResolutionCap = 800

local function SetTags()
	for _, Constraint in pairs(Player.PlayerGui:GetDescendants()) do
		if Constraint:IsA("UIScale") then
			CollectionService:AddTag(Constraint, "UISCALETAG")
		elseif Constraint:IsA("UIGridLayout") then
			CollectionService:AddTag(Constraint, "UIGRIDLAYOUT")
		--elseif Constraint:IsA("UIListLayout") then
		--	CollectionService:AddTag(Constraint, "UILISTLAYOUT")
		end
		
	end
end

local function GetTags(String)
	return CollectionService:GetTagged(String)
end

function scaleBetween(unscaledNum, minAllowed, maxAllowed, min, max)
	return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
end

local function ScaleFromResolution(Axis)
	return 1 / scaleBetween(Axis, MaxResolution, ScaledResolutionCap, MaxResolution, MinResolution) * Axis
end

SetTags()
Player.PlayerGui.DescendantAdded:Connect(function()
	SetTags()
end)

local function Update()
	local X, Y = Camera.ViewportSize.X, Camera.ViewportSize.Y

	if Y < X then
		for _, UIScale in pairs(GetTags("UISCALETAG")) do
			UIScale.Scale = ScaleFromResolution(Y)
		end
	else
		for _, UIScale in pairs(GetTags("UISCALETAG")) do
			UIScale.Scale = ScaleFromResolution(X)
		end
	end
	
	for _, Layout in pairs(GetTags("UIGRIDLAYOUT")) do
		if Layout.Parent:IsA("ScrollingFrame") then
			
			-- Counting up is more accurate than what ROBLOX gives you lol.
			local CellSizeY = Layout.AbsoluteCellSize.Y
			local CellCountY = Layout.AbsoluteCellCount.Y
			local CellPaddingY = Layout.CellPadding.Y.Offset
			
			local CellsTotal1 = CellSizeY * CellCountY
			local CellsTotal2 = CellCountY * CellPaddingY
			
			Layout.Parent.CanvasSize = UDim2.new(0, Layout.Parent.Size.X.Offset, 0, CellsTotal1 + CellsTotal2)
		end
	end
	
	--[[
	
	Currently useless, since UIListlayout lacks useful properties for determining scaling.
	
	for _, Layout in pairs(GetTags("UILISTLAYOUT")) do
		if Layout.Parent:IsA("ScrollingFrame") then
			Layout.Parent.CanvasSize = UDim2.new(0, Layout.Parent.Size.X.Offset, 0, Layout.AbsoluteContentSize.Y + 5)
		end
	end
	--]]
end

game:GetService("RunService").Heartbeat:Connect(function()
	Update()
end)
