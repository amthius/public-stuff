-- Better ESP using Highlight
-- Still lazy to add features.
if game.CoreGui:FindFirstChild("ESPContainer") then return end

local Players = game:GetService("Players")
local Settings = {

}

local Container = Instance.new("Folder")
Container.Name = "ESPContainer"
Container.Parent = game.CoreGui

local function CreateHightlight(Object)
    local Highlight = (Container:FindFirstChild(Object.Name) or Instance.new("Highlight")) 
    Highlight.Name = Object.Name
    Highlight.Adornee = Object
    Highlight.Parent = Container 
end

local function PlayerSetup(Player) 

    if not Player then
        return
    end

    if Player.Character then
        CreateHightlight(Player.Character)
    end

    Player.CharacterAdded:Connect(function(Character)
        CreateHightlight(Character)
    end)

end

Players.PlayerAdded:Connect(function(Player)
    PlayerSetup(Player)
end)

Players.PlayerRemoving:Connect(function(Player)
    Container:FindFirstChild(Player.Name):Remove()
end)

for _, Player in pairs(Players:GetChildren()) do
    if Player ~= Players.LocalPlayer then
        PlayerSetup(Player)
    end
end
