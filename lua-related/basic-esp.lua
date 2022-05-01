--[[
    BASIC ESP (USES BoxHandleAndornment)

    This was written as just some practice.
    I honestly got bored at 3 AM.

    Future Features:
    - Toggle ESP
        - This is pretty easy to add, just by adding the ESP Instances to a table and setting visibility
    - Data Tags
        - Health displayer
        - Distance displayer

    Will I add these future features? Probably not but you have an idea on how to do so.
--]]

local PlayersService = game:GetService("Players")

--[[
    PlayerSetup: function()
    Arguments: Player <Player> (Instance)
    Description: Apply ESP correctly based off player's current health state. 
--]]

local function PlayerSetup(Player) 
    -- Make sure our LocalPlayer doesn't get ESP.
    if Player == PlayersService.LocalPlayer then return end
    -- Load first time
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
       local ESP = Instance.new("BoxHandleAdornment")
       ESP.AlwaysOnTop = true
       ESP.ZIndex = 1 -- Has to be 1 to be shown above other parts.
       ESP.Color3 = Color3.fromRGB(0, 0, 255)
       ESP.Transparency = 0.5
       ESP.Size = Player.Character.HumanoidRootPart.Size
       ESP.Adornee = Player.Character.HumanoidRootPart
       ESP.Parent = Player.Character.HumanoidRootPart 
    end
    -- Load off event when player respawns.
    Player.CharacterAdded:Connect(function(Character)
        if Character:WaitForChild("HumanoidRootPart") then
           local ESP = Instance.new("BoxHandleAdornment")
           ESP.AlwaysOnTop = true
           ESP.ZIndex = 1 -- Has to be 1 to be shown above other parts.
           ESP.Color3 = Color3.fromRGB(0, 0, 255)
           ESP.Transparency = 0.5
           ESP.Size = Character.HumanoidRootPart.Size
           ESP.Adornee = Character.HumanoidRootPart
           ESP.Parent = Character.HumanoidRootPart
        end
    end)
end

-- Loop through all players and call PlayerSetup on each Player. 
for _, Player in pairs(PlayersService:GetChildren()) do
    PlayerSetup(Player) -- Feed function (Value -> Player)
end
-- Listen to when a player is added to add to our container 
PlayersService.PlayerAdded:Connect(function(Player)
    PlayerSetup(Player) -- Feed function (Value -> Player)
end)
