--[[

    Airdrop Script V.2
        * Fixed map breaking script
        * Slightly cleaner code.
        * Added settings.

]]--

--[[
    
 ### Main Loadstring ###

-- Settings
shared.distance = 20    -- Distance between player and crate (Most likely useless to change.)
shared.airdrop  = 20    -- Airdrop notification time
shared.player   = 180   -- Player notification time
-- Script
loadstring(game:HttpGet(("https://raw.githubusercontent.com/dann0001/public-stuff/main/lua-related/combat.lua"),true))()

]]--

-- Loader
shared.debug = false 

if shared.active and not shared.debug then
    return
end

shared.active = true

warn("Combat Warriors script loaded. (V.2)")

-- Extra setup stuff 
local bindable = Instance.new("BindableFunction")

function bindable.OnInvoke(answer)
    if answer == "Yes" then
        for _, object in next, game:GetService("Workspace").Map:GetChildren()[1]:GetChildren() do
            if object.Name == "Airdrop" then
                for i = 1, 50 do
                     game:GetService("RunService").Heartbeat:wait()
                     game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = object.Crate.Hitbox.CFrame
                     fireproximityprompt(object.Crate.Hitbox.ProximityPrompt, 10)       
                end
            end
        end
    end
end

workspace.Map.ChildAdded:Connect(function(object)
    object.ChildAdded:Connect(function(airdrop)  
        game:GetService("RunService").Heartbeat:wait()

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Airdrop Spawned!";
            Text = "Want to teleport towards it?";
            Duration = shared.airdrop;
            Callback = bindable;
            Button1 = "Yes";
            Button2 = "No";
        })

        airdrop.ChildRemoved:Connect(function(weld)
            if weld.Name == "TopWeld" then
                
                for _, player in next, game:GetService("Players"):GetChildren() do
                    local check = (airdrop.Crate.Hitbox.Position - player.Character.HumanoidRootPart.Position).magnitude
                    if check < shared.distance then
                        wait()
                        local found = player.Backpack:FindFirstChild("RPG-7")
                        if found then

                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Player obtained crate!";
                            Text = player.Name.."("..player.DisplayName..")";
                            Icon = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=420&h=420";
                            Duration = shared.player;
                            Button1 = "Dismiss";
                        })   

                        end
                    end
                end

            end
        end)

    end)
end)

