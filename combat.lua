-- Airdrop pickup script

-- Prevent multi loading
if shared.active then
    return 
end

shared.active = true
warn("Auto Airdrop Pickup Loaded")

local bindable = Instance.new("BindableFunction")
local distance = 30

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

game:GetService("Workspace").Map:GetChildren()[1].ChildAdded:Connect(function(object)
    game:GetService("RunService").Heartbeat:wait() -- Avoid problems, delay with spawning or some shit.
     
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Airdrop Spawned!";
        Text = "Want to teleport towards it?";
        Duration = 10;
        Callback = bindable;
        Button1 = "Yes";
        Button2 = "No";
    })

    if object.Name == "Airdrop" then
        object.ChildRemoved:Connect(function(weld)
            if weld.Name == "TopWeld" then
                
                for _, player in next, game:GetService("Players"):GetChildren() do
                    local check = (object.Crate.Hitbox.Position - player.Character.HumanoidRootPart.Position).magnitude
                    wait(0.05) -- Just to make sure..
                    if check < distance and player.Name ~= game:GetService("Players").LocalPlayer.Name then
                           local found = player.Backpack:FindFirstChild("RPG-7")
                           if found then

                            game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Player obtained crate!";
				Text = player.Name.."("..player.DisplayName..")";
				Icon = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=420&h=420";
				Duration = 100;
				Button1 = "Dismiss";
			     })  

                        end
                    end 

                end

            end
        end)
    end

end)
