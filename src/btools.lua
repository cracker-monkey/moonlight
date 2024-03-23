if getgenv().RenderLoop then
    getgenv().RenderLoop:Disconnect()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local BuildingAreas = workspace["Private Building Areas"]


local TickCheck = tick()
getgenv().RenderLoop = RunService.RenderStepped:Connect(function()
    local Character = LocalPlayer.Character

    local Build = BuildingAreas:FindFirstChild(LocalPlayer.Name .. "BuildArea")

    if tick() - TickCheck > 0.1 then
        if Character and Build then
            local BTools = Character:FindFirstChild("Building Tools")

            if BTools then
                local SyncAPI = BTools.SyncAPI

                local Size = Vector3.new(Build.Size.x, 100, Build.Size.z)

                local Position = Build.Position

                local MinPosition = Position - (Size / 2)

                local MaxPosition = Position + (Size / 2)

                local RandomPosition = Vector3.new(
                    math.random(MinPosition.x, MaxPosition.x),
                    math.random(2, MaxPosition.y),
                    math.random(MinPosition.z, MaxPosition.z)
                )

                TickCheck = tick()

                SyncAPI:Invoke("CreatePart", "Normal", CFrame.new(RandomPosition), Build.Build)

                warn("???")
            end
        end
    end
end)