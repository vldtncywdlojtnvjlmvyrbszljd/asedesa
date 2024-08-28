--[[spawn(function()
    while wait() do
        for i,v in pairs(game.Players.LocalPlayer:GetChildren()) do
            if v.Name == "DataLoaded" or v.Name == "DataPreloaded" then
                v:Destroy()
            end
        end
    end
end)

spawn(function() 
    repeat
        task.wait()
    until game:IsLoaded()
    repeat
        task.wait()
    until game.Players
    repeat
        task.wait()
    until game.Players.LocalPlayer and game.Players.LocalPlayer.Team ~= nil 
    wait(1.5)
    require(game.ReplicatedStorage.Notification).new("<Color=Red>BRUTALITY HUB V4<Color=/>"):Display()
    wait(.5)
    require(game.ReplicatedStorage.Notification).new("<Color=Yellow>THANKS FOR USE<Color=/>"):Display()
    wait(.24)
    require(game.ReplicatedStorage.Notification).new("<Color=Yellow>PLEASE SUBSCRIBE MY YOUTUBE CHANNEL<Color=/>"):Display()
    wait(.29)
    --require(game.ReplicatedStorage.Notification).new("<Color=Yellow>HAPPY AND FUN USE MY SCRIPT<Color=/>"):Display()
    require(game.ReplicatedStorage.Notification).new("<Color=Yellow>You Executor : <Color=/> ".. identifyexecutor()):Display()
    wait(.36)
end)]]
local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/lobox920/Notification-Library/Main/Library.lua"))()

NotificationLibrary:SendNotification("Warning", "Script Loading ...", 10)
NotificationLibrary:SendNotification("Warning", "YouTube: Medusa Script Roblox", 10)
NotificationLibrary:SendNotification("Warning", "Executor: ".. identifyexecutor(), 10)
NotificationLibrary:SendNotification("Warning", "Hello: ".. game.Players.LocalPlayer.Name, 15)
loadstring(game:HttpGet("https://raw.githubusercontent.com/vldtncywdlojtnvjlmvyrbszljd/asedesa/main/GameList.lua", true))()
for PlaceID, Execute in pairs(Games) do
    if PlaceID == game.PlaceId then
        loadstring(game:HttpGet(Execute))()
    end
end
