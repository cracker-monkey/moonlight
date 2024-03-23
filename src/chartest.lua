local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local BuildingAreas = workspace["Private Building Areas"]


-- local Character = LocalPlayer.Character
-- local Script = Character.Health

-- local info = require(Script)

-- table.foreach(info, print)

local PlayerScripts = LocalPlayer.PlayerScripts

local Script = PlayerScripts.BloodHandler

local ScriptFunc = getscriptclosure(Script)

table.foreach(debug.getupvalues(ScriptFunc), warn)

--table.foreach(Info, print)