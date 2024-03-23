local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()

    local Args = {...}

    -- this should work, when the car spawns in and you get in the car.
    if Method == "FireServer" and Args[1] == "newSound" and Args[2] == "Rev" then
        Args[4] = "rbxassetid://6467894576"
        Args[6] = 5^12 -- ??
        Args[5] = 5^12
    end

    if Method == "FireServer" and Args[1] == "updateSound" and Args[2] == "Rev" then
        Args[3] = "rbxassetid://6467894576"
        Args[4] = 5^12
        Args[5] = 5^12 -- ??
    end

    if Method == "FireServer" and Args[1] == "UpdateSmoke" then
        Args[2] = 9999999999999999
        Args[3] = 9999999999999999
    end

    return old(self, table.unpack(Args))
end)


local ohTable1 = {
	[1] = {
		[1] = {
			[1] = game.Players.matuxis12312.Character.Head,
			[2] = game.Players.matuxis12312.Character.Head.Position.x, game.Players.matuxis12312.Character.Head.Position.y, game.Players.matuxis12312.Character.Head.Position.z,
			[3] = 1, 1, 1,
			[4] = Enum.Material.Plastic,
			[5] = game.Players.matuxis12312.Character.Head.Position.x, game.Players.matuxis12312.Character.Head.Position.y, game.Players.matuxis12312.Character.Head.Position.z,
			[6] = game:GetService("Players").LocalPlayer.Character["AK-47"].Flash
		},
	}
}
local ohBoolean2 = false
local ohNil3 = nil
local ohVector34 = Vector3.new(1, 1, 1)
local ohNil5 = nil
local ohNumber6 = 1
local ohNumber7 = 0.092307
local ohNumber8 = 3

game:GetService("Players").LocalPlayer.Character["AK-47"].FireEvent:FireServer(ohTable1, ohBoolean2, ohNil3, ohVector34, ohNil5, ohNumber6, ohNumber7, ohNumber8)