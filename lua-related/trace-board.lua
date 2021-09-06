--[[

    Tracing Board
        - New improved UI
        - Better buttons
        - Changed placement

    Remade this old script from about a year ago, the UI looks like dogshit probably would have been better if I had a library although realistically don't care too much.
    Anyways the script is fairly straight forward heres all the instructions basically
        1. Make sure you own discord, create a private server for yourself and create a new channel and just call it "drawings", or you could use general (this is just better than spamming your friend)
        2. Next find an image online, and just paste it into the server.
        3. Copy the link of the image and paste it into the URL of the script.
        4. Click set and teleport, and you should see your image and you can now trace over it.

    What does what
        - URL > This is for the image link, this only works with discord urls cause it displays width and height so this is really easy since everyone basically uses discord.
        - Set > This sets the options, (URL, Opacity)
        - Teleport > This teleports the image under you wherever you're standing, careful with this.
        - Opacity > Changes opacity of the image.
        - Visibility > Toggles visibility. 
        - Scale > Changes the scale of the overall image.
]]


local user_input_service = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local toggle = false
local toggle_key = Enum.KeyCode.F3

-- The UI

local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Image = Instance.new("ImageLabel")
local Opacity = Instance.new("TextBox")
local Set = Instance.new("TextButton")
local Visibility = Instance.new("TextButton")
local Teleport = Instance.new("TextButton")
local ImageSize = Instance.new("TextLabel")
local URL = Instance.new("TextBox")
local ChangeScale = Instance.new("TextBox")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = ScreenGui
Main.AnchorPoint = Vector2.new(0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, 0.0500000007, 0)
Main.Size = UDim2.new(0, 200, 0, 150)

Image.Name = "Image"
Image.Parent = Main
Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Image.BorderSizePixel = 0
Image.Position = UDim2.new(0, 0, 0.166666672, 0)
Image.Size = UDim2.new(0, 100, 0, 100)
Image.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

Opacity.Name = "Opacity"
Opacity.Parent = Main
Opacity.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Opacity.BorderSizePixel = 0
Opacity.Position = UDim2.new(0.50000006, 0, 0.166666672, 0)
Opacity.Size = UDim2.new(0, 50, 0, 50)
Opacity.Font = Enum.Font.SourceSans
Opacity.PlaceholderColor3 = Color3.fromRGB(128, 128, 128)
Opacity.PlaceholderText = "[Opacity]"
Opacity.Text = "0.5"
Opacity.TextColor3 = Color3.fromRGB(0, 0, 0)
Opacity.TextSize = 14.000

Set.Name = "Set"
Set.Parent = Main
Set.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Set.BorderSizePixel = 0
Set.Position = UDim2.new(0.50000006, 0, 0.497333348, 0)
Set.Size = UDim2.new(0, 50, 0, 50)
Set.Font = Enum.Font.SourceSans
Set.Text = "[Set]"
Set.TextColor3 = Color3.fromRGB(0, 0, 0)
Set.TextSize = 14.000

Visibility.Name = "Visibility"
Visibility.Parent = Main
Visibility.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Visibility.BorderSizePixel = 0
Visibility.Position = UDim2.new(0.75000006, 0, 0.164000005, 0)
Visibility.Size = UDim2.new(0, 50, 0, 50)
Visibility.Font = Enum.Font.SourceSans
Visibility.Text = "[Visibility]"
Visibility.TextColor3 = Color3.fromRGB(0, 0, 0)
Visibility.TextSize = 14.000

Teleport.Name = "Teleport"
Teleport.Parent = Main
Teleport.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Teleport.BorderSizePixel = 0
Teleport.Position = UDim2.new(0.75000006, 0, 0.497333348, 0)
Teleport.Size = UDim2.new(0, 50, 0, 50)
Teleport.Font = Enum.Font.SourceSans
Teleport.Text = "[Teleport]"
Teleport.TextColor3 = Color3.fromRGB(0, 0, 0)
Teleport.TextSize = 14.000

ImageSize.Name = "ImageSize"
ImageSize.Parent = Main
ImageSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageSize.BorderSizePixel = 0
ImageSize.Size = UDim2.new(0, 150, 0, 24)
ImageSize.Font = Enum.Font.SourceSans
ImageSize.Text = "Width=0, Height=0"
ImageSize.TextColor3 = Color3.fromRGB(0, 0, 0)
ImageSize.TextSize = 14.000
ImageSize.TextWrapped = true

URL.Name = "URL"
URL.Parent = Main
URL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
URL.BorderSizePixel = 0
URL.Position = UDim2.new(0, 0, 0.833333433, 0)
URL.Size = UDim2.new(0, 200, 0, 25)
URL.Font = Enum.Font.SourceSans
URL.PlaceholderText = "[URL}"
URL.Text = ""
URL.TextColor3 = Color3.fromRGB(0, 0, 0)
URL.TextSize = 14.000
URL.TextTruncate = "AtEnd"

ChangeScale.Name = "ChangeScale"
ChangeScale.Parent = Main
ChangeScale.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ChangeScale.BorderSizePixel = 0
ChangeScale.Position = UDim2.new(0.75, 0, 0, 0)
ChangeScale.Size = UDim2.new(0, 50, 0, 24)
ChangeScale.Font = Enum.Font.SourceSans
ChangeScale.PlaceholderColor3 = Color3.fromRGB(128, 128, 128)
ChangeScale.PlaceholderText = "[Scale]"
ChangeScale.Text = "1"
ChangeScale.TextColor3 = Color3.fromRGB(0, 0, 0)
ChangeScale.TextSize = 14.000

-- Functions and stuff
user_input_service.InputBegan:connect(function(inp, proc)

    if not proc and inp.KeyCode == toggle_key then 

        if not toggle then
            toggle = true
            ScreenGui.Enabled = false 
        else
            toggle = false
            ScreenGui.Enabled = true 
        end

    end

end)

function file_create(url)
	local random_value = tostring(string.gsub(tostring(tick()),"%p",""))..".png"

	writefile(random_value, game:HttpGet(url))

	spawn(function()
		wait(3)
		delfile(random_value)
	end)

	return getsynasset(random_value)
end


-- Works obviously on discord only url's, decided to go with it cause this isn't really hard to do.
function fetch_size(url)
    local data = {}
    
        data.Width = url:match("width=(%d+)")
        data.Height = url:match("height=(%d+)")
        
    return data
end

function create()
	
	local part        = Instance.new("Part")
	part.Anchored     = true
	part.Position     = player.Character.HumanoidRootPart.Position + Vector3.new(0, -3.1, 0)
	part.Size     	  = Vector3.new(10, 0.1, 10)
	part.Transparency = 1
	part.Parent       = workspace
	
	local surface_gui       = Instance.new("SurfaceGui")
	surface_gui.AlwaysOnTop = true
	surface_gui.Face        = "Top"
	surface_gui.Parent      = part

	local image                  = Instance.new("ImageLabel")
	image.BackgroundTransparency = 1
	image.BorderSizePixel        = 0
	image.Size                   = UDim2.new(1, 0, 1, 0)
	image.Image                  = ""               
	image.ImageTransparency      = 0.3
	image.Parent                 = surface_gui
	
	return part
end

local canvas  = create()
local visible = true

Set.MouseButton1Click:Connect(function()

    local new_image = file_create(URL.Text)
    local size_data = fetch_size(URL.Text)

    ImageSize.Text = "Width="..tostring(size_data.Width * ChangeScale.Text)..",".." Height="..tostring(size_data.Height * ChangeScale.Text)

    canvas.Size = Vector3.new(size_data.Height * ChangeScale.Text, 0.1, size_data.Width * ChangeScale.Text)
    canvas.SurfaceGui.ImageLabel.Image = new_image

    Image.Image = new_image 

end)

Teleport.MouseButton1Click:Connect(function()
	canvas.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -3.1, 0)
end)

Visibility.MouseButton1Click:Connect(function()
	if visible then
		visible = false
		canvas.Parent = nil
	else
		visible = true
		canvas.Parent = workspace
	end
end)
