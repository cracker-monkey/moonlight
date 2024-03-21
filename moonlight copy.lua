--#region TODO
--[[
    HIGH PRIORITY:
        - [ ] Make the aim assist, triggerbot and bullet redirection features work

    MEDIUM PRIORITY:
        - [ ] Add a few elements to the rage tab for features (e.g. aimbot, anti-aim, etc.)

    LOW PRIORITY:
        - [ ] Add a few elements to the visuals tab for features (e.g. esp, chams, etc.)
        - [ ] Add a few elements to the misc tab for features (e.g. speed, jump, etc.)
        - [ ] Add a few elements to the settings tab for features (e.g. theme, Watermark, etc.)
--]]
--#endregion

--#region Libraries, Services, Variables & Functions
--// Libraries
local Library = loadstring(game:HttpGet("https://e-z.tools/p/raw/6j3xg81igs", true))()

--// Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// Variables
local LoadTimeTick = os.clock()
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local MouseLocation = UserInputService:GetMouseLocation()
--
local debuggetupvalue = debug.getupvalue
local Color3fromRGB = Color3.fromRGB
local Color3fromHSV = Color3.fromHSV
local Color3fromHex = Color3.fromHex
local coroutinewrap = coroutine.wrap
local Base64Decode = base64decode
local tableremove = table.remove
local tableinsert = table.insert
local tablefind = table.find
local tablesort = table.sort
local Instancenew = Instance.new
local Vector2zero = Vector2.zero
local Vector3zero = Vector3.zero
local tableclone = table.clone
local tableclear = table.clear
local Vector2new = Vector2.new
local Vector3new = Vector3.new
local Drawingnew = Drawing.new
local CFramenew = CFrame.new
local mathclamp = math.clamp
local mathfloor = math.floor
local Color3new = Color3.new
local taskspawn = task.spawn
local taskwait = task.wait
local UDim2new = UDim2.new
local mathcos = math.cos
local mathabs = math.abs
local mathrad = math.rad
local mathsin = math.sin

--// Functions
LPH_ENCSTR = function(...) return ... end
LPH_ENCNUM = function(...) return ... end
LPH_CRASH = function(...) return ... end
LPH_JIT = function(...) return ... end
LPH_JIT_MAX = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end
--#endregion

--#region Menu Interface
--// Window & Watermark
local Window = Library:Load({ title = "Moonlight", theme = "Default", folder = "moonlight", game = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, playerlist = true, performancedrag = false, discord = "discord code here" })
local Watermark = Library:Watermark("Moonlight | dev | v0.0.1a")

--// Tabs
local LegitTab = Window:Tab("Legit")
--[[ local RageTab = Window:Tab("Rage")
local VisualsTab = Window:Tab("Visuals")
local MiscTab = Window:Tab("Misc") ]]
local SettingsTab = Window:Tab("Settings")

--// Sections & its toggles, keybinds, sliders, etc.
local AimAssist = LegitTab:Section({ name = "Aim Assist", side = "left" })
AimAssist:Toggle({ name = "Enabled", default = true, flag = "aim_assist_enabled" }):Keybind({ name = "Aim Assist", listignored = false, mode = "hold", blacklist = {}, flag = "aim_assist_key" })
AimAssist:Toggle({ name = "Visible Check", default = true, flag = "aim_assist_visible_check" })
AimAssist:Toggle({ name = "Invisible Check", default = true, flag = "aim_assist_invisible_check" })
AimAssist:Toggle({ name = "Forcefield Check", default = true, flag = "aim_assist_forcefield_check" })
AimAssist:Toggle({ name = "Team Check", default = true, flag = "aim_assist_team_check" })
AimAssist:Separator()
AimAssist:Slider({ name = "Field of View", default = 70, float = 1, suffix = "°", min = 1, max = 180, flag = "aim_assist_fov" })
AimAssist:Slider({ name = "Deadzone", default = 5, float = 1, suffix = "°", min = 1, max = 50, flag = "aim_assist_deadzone" })
AimAssist:Slider({ name = "Maximum Distance", default = 300, float = 1, suffix = " studs", min = 1, max = 10000, flag = "aim_assist_max_distance" })
AimAssist:Slider({ name = "Horizontal Smoothing", default = 20, float = 1, suffix = "%", min = 0, max = 50, flag = "aim_assist_smoothness_horizontal" })
AimAssist:Slider({ name = "Vertical Smoothing", default = 20, float = 1, suffix = "%", min = 0, max = 50, flag = "aim_assist_smoothness_vertical" })
AimAssist:Separator()
AimAssist:Dropdown({ name = "Target Selection", content = { "Mouse", "Health", "Distance" }, multi = false, flag = "aim_assist_target_selection" })
AimAssist:Dropdown({ name = "Hitscan", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "aim_assist_hitscan" })
AimAssist:Dropdown({ name = "Hitscan Priority", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = false, flag = "aim_assist_hitscan_priority" })

--[[ local BulletRedirection = LegitTab:Section({ name = "Bullet Redirection", side = "middle" })
BulletRedirection:Toggle({ name = "Enabled", default = true, flag = "bullet_redirection_enabled" })
BulletRedirection:Toggle({ name = "Visible Check", default = true, flag = "bullet_redirection_visible_check" })
-- BulletRedirection:Toggle({ name = "Team Check", default = true, flag = "bullet_redirection_team_check" })
BulletRedirection:Separator()
BulletRedirection:Slider({ name = "Field of View", default = 70, float = 1, suffix = "°", min = 0, max = 180, flag = "bullet_redirection_fov" })
BulletRedirection:Slider({ name = "Deadzone", default = 5, float = 1, suffix = "°", min = 0, max = 50, flag = "bullet_redirection_deadzone" })
BulletRedirection:Separator()
BulletRedirection:Dropdown({ name = "Hitscan", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "bullet_redirection_hitscan" })
BulletRedirection:Dropdown({ name = "Hitscan Priority", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = false, flag = "bullet_redirection_hitscan_priority" })

local TriggerbotSection = LegitTab:Section({ name = "Triggerbot", side = "right" })
TriggerbotSection:Toggle({ name = "Enabled", default = true, flag = "triggerbot_enabled" })
TriggerbotSection:Toggle({ name = "Visible Check", default = true, flag = "triggerbot_visible_check" })
-- TriggerbotSection:Toggle({ name = "Team Check", default = true, flag = "triggerbot_team_check" })
TriggerbotSection:Separator()
TriggerbotSection:Slider({ name = "Delay", default = 120, float = 1, suffix = "ms", min = 0, max = 1000, flag = "triggerbot_delay" })
TriggerbotSection:Dropdown({ name = "Hitscan", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "triggerbot_hitscan" }) ]]

Window:SettingsTab(Watermark)

Library.Playerlist:button({
	name = "Prioritize",
	callback = function(list, plr)
		if not list:IsTagged(plr, "Prioritized") then
			list:Tag({ player = plr, text = "Prioritized", color = fromRGB(255, 0, 0) })
		else
			list:RemoveTag(plr, "Prioritized")
		end
	end,
})

Library.Playerlist:button({
	name = "Ignore",
	callback = function(list, plr)
		if not Library.Playerlist:IsTagged(plr, "Ignored") then
			Library.Playerlist:Tag({ player = plr, text = "Ignored", Color = fromRGB(120, 120, 120) })
		else
			Library.Playerlist:RemoveTag(plr, "Ignored")
		end
	end,
})

Library.Playerlist:Label({
	name = "Rank: ",
	handler = function(plr)
		return "1e+9"
	end,
})

Library.Playerlist:Label({
	name = "Team: ",
	handler = function(plr)
		return "Ghosts", fromRGB(209, 118, 0)
	end,
})
--#endregion

--#region Features
Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function()
	MouseLocation = UserInputService:GetMouseLocation()
end))

local AimAssistKeyHeld = false
Library:Connect(UserInputService.InputBegan, LPH_NO_VIRTUALIZE(function(input)
	if input.UserInputType == Library.flags["aim_assist_key"] then
		AimAssistKeyHeld = true
		print("Aim Assist Key Held")
	end
end))

Library:Connect(UserInputService.InputEnded, LPH_NO_VIRTUALIZE(function(input)
	if input.UserInputType == Library.flags["aim_assist_key"] then
		AimAssistKeyHeld = false
		print("Aim Assist Key Released")
	end
end))


local AimAssistTarget
Library:Connect(RunService.RenderStepped, LPH_JIT_MAX(function() -- Aim Assist
	if not Library.flags["aim_assist_enabled"] then
		return
	end

	if Library.open then
		return
	end

	if not AimAssistKeyHeld then
		return
	end

	AimAssistTarget = nil
	for _, entry in next, Players:GetPlayers() do
		if entry == LocalPlayer then -- dont target the local player
			continue
		end

		if Library.Playerlist:IsTagged(entry, "Ignored") then -- dont target ignored players
			continue
		end

		if not entry.Character or not entry.Character.PrimaryPart or not entry.Character:FindFirstChildOfClass("Humanoid") then -- dont target players without a character or humanoid
			continue
		end

		if entry.Character:FindFirstChildOfClass("Humanoid").Health < 1 then -- dont target dead players
			continue
		end

		if Library.flags["aim_assist_team_check"] and entry.Team == LocalPlayer.Team then -- dont target teammates
			continue
		end

		local Position, OnScreen = Camera:WorldToViewportPoint(entry.Character.PrimaryPart.Position) -- get the position of the player's primary part on the screen
		local DistanceFromCharacter = (entry.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude -- get the distance from the local player to the target player
		local DistanceFromMouse = (MouseLocation - Vector2.new(Position.X, Position.Y)).Magnitude -- get the distance from the mouse to the target player
		
		if not (Position and OnScreen) then -- dont target players that are not on the screen
			continue
		end
		
		if DistanceFromCharacter > Library.flags["aim_assist_max_distance"] then -- dont target players that are too far away
			continue
		end
		
		if DistanceFromMouse > Library.flags["aim_assist_fov"] then -- dont target players that are outside of the field of view
			continue
		end
		
		if Library.flags["aim_assist_visible_check"] and workspace:Raycast(LocalPlayer.Character.PrimaryPart.Position, entry.Character.PrimaryPart.Position, RaycastParams.new()) then 
			continue
		end

		AimAssistTarget = entry
	end

	if AimAssistTarget then
		print(AimAssistTarget)
		local TargetPosition, IsTargetOnScreen = Camera:WorldToViewportPoint(AimAssistTarget.Character.PrimaryPart.Position)
		if TargetPosition and IsTargetOnScreen then
			mousemoverel(
				(TargetPosition.X - MouseLocation.X) / Library.flags["aim_assist_smoothness_horizontal"],
				(TargetPosition.Y - MouseLocation.Y) / Library.flags["aim_assist_smoothness_vertical"]
			)
		end
	end
end))
--#endregion

Library:Init()
Library:Notify({ title = "Welcome", message = string.format("Welcome to Moonlight, %s! Version: %s | Loaded modules in (%sms)", LocalPlayer.Name, "v0.0.1a", math.floor((os.clock() - LoadTimeTick) * 1000)), duration = 3 })