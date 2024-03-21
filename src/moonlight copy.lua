-- TODO
--[[
	CURRENT:
		- [ ] Make the toggles, not automatically selected
		- [ ] Make the dropdowns select the first index
		- [ ] Make the aimbot hitscan not be a multi-dropdown, and make it so it has the values { "Head", "Torso", "Closest" }
		- [ ] Make ESP toggles

	HIGH PRIORITY:
		- [ ] Make the aim assist, triggerbot and bullet redirection features work

	MEDIUM PRIORITY:
		- [ ] Add a few elements to the rage tab for features (e.g. aimbot, anti-aim, etc.)

	LOW PRIORITY:
		- [ ] Add a few elements to the visuals tab for features (e.g. esp, chams, etc.)
		- [ ] Add a few elements to the misc tab for features (e.g. speed, jump, etc.)
		- [ ] Add a few elements to the settings tab for features (e.g. theme, Watermark, etc.)
--]]
--

if not LPH_OBFUSCATED and getgenv().Moonlight then
	getgenv().Moonlight.Libraries.Utility:Unload()
end

-- Libraries
local Library = loadstring(game:HttpGet("https://e-z.tools/p/raw/6j3xg81igs", true))()
--

-- Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
--

-- Variables
local LoadTimeTick = os.clock()
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local MouseLocation = UserInputService:GetMouseLocation()
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
local mathmax = math.max
local mathmin = math.min
local mathcos = math.cos
local mathabs = math.abs
local mathrad = math.rad
local mathsin = math.sin
local Env = getgenv()
--

-- Table
local Modules = {
	Stored = {}
}

local Utility = {
	Drawings = {},
	Objects = {}
}

local Legitbot = {

}

local Visuals = {

}

local ESP = {
	Players = {}
}

local Moonlight = {
	Libraries = {
		Modules = Modules,
		Utility = Utility,
		Legitbot = Legitbot,
		Visuals = Visuals,
		ESP = ESP
	}
}

if not LPH_OBFUSCATED then
	Env.Moonlight = Moonlight
end
--

-- Luraph Functions
LPH_ENCSTR = function(...) return ... end
LPH_ENCNUM = function(...) return ... end
LPH_CRASH = function(...) return ... end
LPH_JIT = function(...) return ... end
LPH_JIT_MAX = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end
--

-- Modules
do
	for _,instance in next, getnilinstances() do
		if not instance:IsA("ModuleScript") then
			continue
		end

		-- okay so if i dont pcall it, it will error
		--local Required = require(instance)
		local Required = nil
		pcall(function()
			Required = require(instance)
		end)

		if not Required then
			continue
		end

		Modules.Stored[instance.Name] = Required
	end

	for _,instance in next, getloadedmodules() do
		if Modules.Stored[instance.Name] then
			continue
		end

		-- okay so if i dont pcall it, it will error
		-- local Required = require(instance)
		local Required = nil
		pcall(function()
			Required = require(instance)
		end)

		if not Required then
			continue
		end

		Modules.Stored[instance.Name] = Required
	end

	function Modules:Get(name: string)
		return Modules.Stored[name] or nil
	end

	-- PF Modules (heat)
	RoundSystemClientInterface = Modules:Get("RoundSystemClientInterface")
	WeaponControllerInterface = Modules:Get("WeaponControllerInterface")
	PlayerDataClientInterface = Modules:Get("PlayerDataClientInterface")
	HudCrosshairsInterface = Modules:Get("HudCrosshairsInterface") 
	LeaderboardInterface = Modules:Get("LeaderboardInterface")
	ReplicationInterface = Modules:Get("ReplicationInterface")
	CharacterInterface = Modules:Get("CharacterInterface")
	ActiveLoadoutUtils = Modules:Get("ActiveLoadoutUtils")
	PlayerStatusEvents = Modules:Get("PlayerStatusEvents")
	ReplicationObject = Modules:Get("ReplicationObject")
	ThirdPersonObject = Modules:Get("ThirdPersonObject")
	ContentDatabase = Modules:Get("ContentDatabase")
	BulletInterface = Modules:Get("BulletInterface")
	CharacterObject = Modules:Get("CharacterObject")
	CameraInterface = Modules:Get("CameraInterface")
	CameraObject = Modules:Get("MainCameraObject")
	PublicSettings = Modules:Get("PublicSettings")
	FirearmObject = Modules:Get("FirearmObject")
	NetworkClient = Modules:Get("NetworkClient")
	BulletObject = Modules:Get("BulletObject")
	MeleeObject = Modules:Get("MeleeObject")
	BulletCheck = Modules:Get("BulletCheck")
	GameClock = Modules:Get("GameClock")
	Physics = Modules:Get("PhysicsLib")
	Sound = Modules:Get("AudioSystem")
	Effects = Modules:Get("Effects")
	--

end --

-- Utility
do
	-- this should be all of them
	Utility.DrawingTypes = {
		"Quad",
		"Square",
		"Circle",
		"Text",
		"Line",
		"Triangle"
	}

	-- Utility Stuff
	function Utility:New(type, props, storage)
		local IsDrawing = table.find(Utility.DrawingTypes, type)

		local NewFunction = IsDrawing and Drawingnew or Instancenew
		
		local Object = NewFunction(type)

		if props then
			for _,v in next, props do
				Object[_] = v
			end
		end

		if IsDrawing then
			Utility.Drawings[#Utility.Drawings + 1] = Object
		else
			Utility.Objects[#Utility.Objects + 1] = Object
		end

		if storage then
			storage[#storage + 1] = Object
		end

		return Object
	end

	function Utility:Unload()
		Library:Unload()

		for _,v in next, Utility.Drawings do
			v:Remove()
		end

		for _,v in next, Utility.Objects do
			v:Destroy()
		end
	end
	--

	-- Game Functions
	function Utility:GetEntry(player)
		return player and ReplicationInterface.getEntry(player) or nil
	end

	function Utility:GetCharacter(player)
        local Entry = Utility:GetEntry(player)

        if Entry then
            return Entry._thirdPersonObject and Entry._thirdPersonObject._characterHash or nil
        end

		return nil
    end

    function Utility:IsAlive(player)
        local Entry = Utility:GetEntry(player)

        if Entry then
            return Entry._alive and Entry:isAlive()
        end

		return false -- ??
    end

	function Utility:GetHealth(player)
        local Entry = Utility:GetEntry(player)

        if Entry then
            return Entry:getHealth()
        end

		return 0 -- ??
    end

	function Utility:GetWeapon(player)
        local Entry = Utility:GetEntry(player)

        if Entry then
            local ThirdPersonObject = Entry._thirdPersonObject
            if ThirdPersonObject then
                return ThirdPersonObject._weaponname or ""
            end
        end

		return "" -- ??
    end

    function Utility:GetPlayerStat(player, stat)
        local Entry = LeaderboardInterface.getEntry(player)

        if not (Entry and stat) then
            return nil
        end

        return Entry:getStat(stat) or nil -- ??
    end

	--
end --

-- Handlers
do
	Library:Connect(UserInputService.InputBegan, LPH_NO_VIRTUALIZE(function(input)
		if input.UserInputType == Library.flags["aim_assist_key"] then
		end
	end))

	Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function()
		MouseLocation = UserInputService:GetMouseLocation()
	end))

	Library:Connect(UserInputService.InputEnded, LPH_NO_VIRTUALIZE(function(input)
		if input.UserInputType == Library.flags["aim_assist_key"] then
		end
	end))
end

-- Legitbot
do
	Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function() -- Aim Assist
		if not Library.flags["aim_assist_enabled"] then
			return
		end

		if Library.open then
			return
		end

		-- if not AimAssistKeyHeld then
		-- 	return
		-- end

		
	end))
end --

-- Visuals
do
	
end --

-- ESP
do
	function ESP:BoxSizing(torso)
		local VTop = torso.Position + (torso.CFrame.UpVector * 1.8) + Camera.CFrame.UpVector
		local VBottom = torso.Position - (torso.CFrame.UpVector * 2.5) - Camera.CFrame.UpVector

		local Top, TopIsRendered = Camera:WorldToViewportPoint(VTop)
		local Bottom, BottomIsRendered = Camera:WorldToViewportPoint(VBottom)

		local Width = mathmax(mathfloor(mathabs(Top.x - Bottom.x)), 3)
		local Height = mathmax(mathfloor(mathmax(mathabs(Bottom.y - Top.y), Width / 2)), 3)
		local BoxSize = Vector2new(mathfloor(mathmax(Height / 1.5, Width)), Height)
		local BoxPosition = Vector2new(mathfloor(Top.x * 0.5 + Bottom.x * 0.5 - BoxSize.x * 0.5), mathfloor(mathmin(Top.y, Bottom.y)))

		return BoxSize, BoxPosition
	end

	function ESP:NewDrawingLayout(player)
		return {
			["BoxOutline"] = Utility:New("Square", {
				Thickness = 3,
				Visible = false,
				Filled = false,
				Transparency = 1
			}),
			["Box"] = Utility:New("Square", {
				Thickness = 1,
				Visible = false,
				Filled = false,
				Transparency = 1
			}),
			["BoxFill"] = Utility:New("Square", {
				Visible = false,
				Filled = true,
				Transparency = 1
			}),
			["Name"] = Utility:New("Text", {
				Center = true,
				Visible = false,
				Text = player.Name,
				Outline = true,
				Transparency = 1
			}),
			["Weapon"] = Utility:New("Text", {
				Center = true,
				Visible = false,
				Outline = true,
				Transparency = 1
			}),
			["Distance"] = Utility:New("Text", {
				Center = true,
				Visible = false,
				Outline = true,
				Transparency = 1
			}),
			["Rank"] = Utility:New("Text", {
				Center = false,
				Visible = false,
				Outline = true,
				Transparency = 1
			}),
			["Team"] = Utility:New("Text", {
				Center = false,
				Visible = false,
				Outline = true,
				Transparency = 1
			}),
		}
	end

	function ESP:GetColor(player)
		-- ill add checks if target n shit

		return nil
	end

	function ESP:NewPlayer(player)
		if ESP.Players[player] then
			return
		end

		local ESP_P = {
			Player = player,
			Drawings = ESP:NewDrawingLayout(player)
		}

		local Drawings = ESP_P.Drawings

		function ESP_P:Unrender()
			for _,v in next, Drawings do
				v.Visible = false
			end
		end

		ESP_P.Loop = Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
			local TeamFlag = "E_"

			local CharacterObject = CharacterInterface.getCharacterObject()

			local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

			if player.Team == LocalPlayer.Team then
				TeamFlag = "T_"
			end

			if not Library.Flags[TeamFlag .. "enabled"] then
				return ESP_P:Unrender()
			end

			if not Utility:IsAlive(player) then
				return ESP_P:Unrender()
			end

			local Character = Utility:GetCharacter(player)
			
			if not Character then
				return ESP_P:Unrender()
			end

			local Torso = Character.Torso

			if not Torso then
				return ESP_P:Unrender()
			end

			local Origin = HumanoidRootPart and HumanoidRootPart.Position or Camera.CFrame.p

			local DistanceFromTorso = (Torso.Position - Origin).Magnitude

			if Library.Flags["esp_limit_distance"] and Library.Flags["esp_limit_distance_amount"] < DistanceFromTorso then
				return ESP_P:Unrender()	
			end

			local Pos, OnScreen = Camera:WorldToViewportPoint(Torso.Position)

			if not OnScreen then
				return ESP_P:Unrender()
			end

			local PlayerRank = Utility:GetPlayerStat(player, "Rank") or 0

			local BottomOffset = Vector2zero
			local RightOffset = Vector2zero

			local BoxSize, BoxPosition = ESP:BoxSizing(Torso)

			local BoxOutline = Drawings["BoxOutline"]
			local Box = Drawings["Box"]

			local OverrideColor = ESP:GetColor(player)

			Box.Visible = Library.Flags[TeamFlag .. "box"]
			BoxOutline.Visible = Library.Flags[TeamFlag .. "box"]
			if Box.Visible and BoxOutline.Visible then
				BoxOutline.Size = BoxSize
				BoxOutline.Position = BoxPosition
				BoxOutline.Color = Library.Flags[TeamFlag .. "box_outline"]

				Box.Size = BoxSize
				Box.Position = BoxPosition
				Box.Color = OverrideColor or Library.Flags[TeamFlag .. "box_color"]
			end

			local BoxFill = Drawings["BoxFill"]

			BoxFill.Visible = Library.Flags[TeamFlag .. "box_fill"]
			if BoxFill.Visible then
				BoxFill.Size = BoxSize - Vector2new(2, 2)
				BoxFill.Position = BoxPosition + Vector2new(1, 1)
				BoxFill.Color = OverrideColor or Library.Flags[TeamFlag .. "box_fill_color"]
				BoxFill.Transparency = Library.Flags[TeamFlag .. "box_fill_a"] / 255
			end

			local Name = Drawings["Name"]

			Name.Visible = Library.Flags[TeamFlag .. "name"]
			if Name.Visible then
				Name.Position = BoxPosition + Vector2new(BoxSize.x / 2, -( Name.TextBounds.y + 3 ))
				Name.Color = OverrideColor or Library.Flags[TeamFlag .. "name_color"]
				Name.Font = Drawing.Fonts[Library.Flags["esp_font"]]
				Name.Size = Library.Flags["esp_font_size"]
			end
			
			local Rank = Drawings["Rank"]

			Rank.Visible = Library.Flags[TeamFlag .. "rank"]
			if Rank.Visible then
				Rank.Position = BoxPosition + Vector2new(BoxSize.x + 3, RightOffset.y - 3)
				Rank.Color = OverrideColor or Library.Flags[TeamFlag .. "rank_color"]
				Rank.Font = Drawing.Fonts[Library.Flags["esp_font"]]
				Rank.Size = Library.Flags["esp_font_size"]
				Rank.Text = "LVL. " .. tostring(PlayerRank)

				RightOffset = Vector2new(RightOffset.x, RightOffset.y + Rank.TextBounds.y + 2)
			end

			
			local Team = Drawings["Team"]

			Team.Visible = Library.Flags[TeamFlag .. "team"]
			if Team.Visible then
				Team.Position = BoxPosition + Vector2new(BoxSize.x + 3, RightOffset.y - 3)
				Team.Color = OverrideColor or Library.Flags[TeamFlag .. "team_color"]
				Team.Font = Drawing.Fonts[Library.Flags["esp_font"]]
				Team.Size = Library.Flags["esp_font_size"]
				Team.Text = player.Team.Name

				RightOffset = Vector2new(RightOffset.x, RightOffset.y + Team.TextBounds.y + 2)
			end
			
            if RightOffset.y - 3 > BoxSize.y then
				BottomOffset = Vector2new(BottomOffset.x, BottomOffset.y + mathclamp(RightOffset.y - BoxSize.y - 6, 0, 5^12))
            end

			local Weapon = Drawings["Weapon"]

			Weapon.Visible = Library.Flags[TeamFlag .. "weapon"]
			if Weapon.Visible then
				Weapon.Position = BoxPosition + Vector2new(BoxSize.x / 2, BoxSize.y + 3 + BottomOffset.y)
				Weapon.Color = OverrideColor or Library.Flags[TeamFlag .. "weapon_color"]
				Weapon.Font = Drawing.Fonts[Library.Flags["esp_font"]]
				Weapon.Size = Library.Flags["esp_font_size"]
				Weapon.Text = Utility:GetWeapon(player)

				BottomOffset = Vector2new(BottomOffset.x, BottomOffset.y + Weapon.TextBounds.y + 2)
			end

			local Distance = Drawings["Distance"]

			Distance.Visible = Library.Flags[TeamFlag .. "distance"]
			if Distance.Visible then
				Distance.Position = BoxPosition + Vector2new(BoxSize.x / 2, BoxSize.y + 3 + BottomOffset.y)
				Distance.Color = OverrideColor or Library.Flags[TeamFlag .. "distance_color"]
				Distance.Font = Drawing.Fonts[Library.Flags["esp_font"]]
				Distance.Size = Library.Flags["esp_font_size"]
				Distance.Text = tostring(mathfloor(DistanceFromTorso)) .. " s"

				BottomOffset = Vector2new(BottomOffset.x, BottomOffset.y + Distance.TextBounds.y + 2)
			end
		end))
	end

	function ESP:RemovePlayer(player)
		if not ESP.Players[player] then
			return
		end

		local ESP_P = ESP.Players[player]

		for _,v in next, ESP_P.Drawings do
			v:Remove()
		end

		ESP_P.Loop:Disconnect()

		ESP.Players[player] = nil
	end
	
	for _,player in next, Players:GetPlayers() do
		ESP:NewPlayer(player)
	end

	Library:Connect(Players.PlayerAdded, LPH_NO_VIRTUALIZE(function(player)
		ESP:NewPlayer(player)
	end))

	Library:Connect(Players.PlayerRemoving, LPH_NO_VIRTUALIZE(function(player)
		ESP:RemovePlayer(player)
	end))
end --

-- Menu Interface
do
	-- Window | Watermark
	local Window = Library:Load({ title = "Moonlight", theme = "Default", folder = "moonlight", game = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, playerlist = true, performancedrag = false, discord = "discord code here" })
	local Watermark = Library:Watermark("Moonlight | dev | v0.0.1a")
	--

	-- Tabs
	local LegitTab = Window:Tab("Legit")
	--local RageTab = Window:Tab("Rage")
	local VisualsTab = Window:Tab("Visuals")
	--local MiscTab = Window:Tab("Misc")
	local SettingsTab = Window:Tab("Settings")
	--

	-- Toggles
	local AimAssist = LegitTab:Section({ name = "Aim Assist", side = "left" })
	AimAssist:Toggle({ name = "Enabled", default = true, flag = "aim_assist_enabled" })
		:Keybind({ name = "Aim Assist", listignored = false, mode = "hold", blacklist = {}, flag = "aim_assist_key" })
	AimAssist:Toggle({ name = "Visible Check", default = true, flag = "aim_assist_visible_check" })
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
		:Set("Mouse")
	AimAssist:Dropdown({ name = "Hitscan", content = { "Head", "Torso", "Closest" }, multi = false, flag = "aim_assist_hitscan" })
		:Set("Head")

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
	
	local ESP_Types = {
		["Enemy"] = {
			["Flag"] = "E_",
			["Side"] = "left"
		},
		["Team"] = {
			["Flag"] = "T_",
			["Side"] = "middle"
		}
	}

	for _,v in next, ESP_Types do
		local ESP = VisualsTab:Section({ name = _, side = v.Side })
		ESP:Toggle({ name = "Enabled", default = false, flag = v.Flag .. "enabled" })
		local BoxESP = ESP:Toggle({ name = "Box", default = false, flag = v.Flag .. "box" })
			BoxESP:Colorpicker({ name = "Box Color", default = Color3fromRGB(255, 0, 0), flag = v.Flag .. "box_color"})
			BoxESP:Colorpicker({ name = "Box Outline Color", default = Color3fromRGB(0, 0, 0), flag = v.Flag .. "box_outline"})
		ESP:Toggle({ name = "Box Fill", default = false, flag = v.Flag .. "box_fill" })
			:Colorpicker({ name = "Box Fill Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "box_fill_color"})
		ESP:Slider({ name = "Box Fill Transparency", default = 0, float = 1, min = 1, max = 255, flag = v.Flag .. "box_fill_a" })
		ESP:Toggle({ name = "Name", default = false, flag = v.Flag .. "name" })
			:Colorpicker({ name = "Name Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "name_color"})
		ESP:Toggle({ name = "Health", default = false, flag = v.Flag .. "health" })
			:Colorpicker({ name = "Health Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "health_color"})
		ESP:Toggle({ name = "Distance", default = false, flag = v.Flag .. "distance" })
			:Colorpicker({ name = "Distance Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "distance_color"})
		ESP:Toggle({ name = "Weapon", default = false, flag = v.Flag .. "weapon" })
			:Colorpicker({ name = "Weapon Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "weapon_color"})
		ESP:Toggle({ name = "Rank", default = false, flag = v.Flag .. "rank" })
			:Colorpicker({ name = "Rank Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "rank_color"})
		ESP:Toggle({ name = "Team", default = false, flag = v.Flag .. "team" })
			:Colorpicker({ name = "Team Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "team_color"})
		ESP:Toggle({ name = "Use Team Color", default = false, flag = v.Flag .. "team_use_color" })
	end

	local ESPSettings = VisualsTab:Section({ name = "ESP Settings", side = "right" })
	ESPSettings:Toggle({ name = "Limit Distance", default = false, flag = "esp_limit_distance" })
	ESPSettings:Slider({ name = "Maximum Distance", default = 300, float = 1, suffix = " studs", min = 1, max = 5000, flag = "esp_limit_distance_amount" })
	ESPSettings:Dropdown({ name = "ESP Font", content = { "Plex", "Monospace", "UI", "System" }, multi = false, flag = "esp_font" })
		:Set("Plex")
	ESPSettings:Slider({ name = "ESP Size", default = 14, float = 1, suffix = " px", min = 1, max = 30, flag = "esp_font_size" })
	--

	-- Settings Tab
	Window:SettingsTab(Watermark)
	--

	-- Player List
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
			return plr.Team, fromRGB(209, 118, 0)
		end,
	}) --

end --

Library:Init()
Library:Notify({ title = "Welcome", message = string.format("Welcome to Moonlight, %s! Version: %s | Loaded modules in (%sms)", LocalPlayer.Name, "v0.0.1a", math.floor((os.clock() - LoadTimeTick) * 1000)), duration = 3 })