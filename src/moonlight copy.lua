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
local MarketPlaceService = game:GetService("MarketplaceService")
--

-- Variables
local LoadTimeTick = os.clock()
local Camera = Workspace.CurrentCamera
local ScreenSize = Camera.ViewportSize
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
local mathatan2 = math.atan2
local Env = getgenv()
local Ignores = { workspace.Players, workspace.Ignore, Camera }

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist
RayParams.FilterDescendantsInstances = Ignores

local BarrelPosition = nil

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
	Aimbot = {
		KeybindStatus = false,
		Position = Vector2zero,
		Targets = {},
		Target = nil,
		Circles = {}
	},
	SilentAim = {
		KeybindStatus = false,
		Position = Vector2zero,
		Targets = {},
		Target = nil,
		Circles = {}
	}
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
	function Utility:RotateVector2(vector, angle)
        local x = vector.x
        local y = vector.y
        local cosTheta = mathcos(angle)
        local sinTheta = mathsin(angle)
        local newX = x * cosTheta - y * sinTheta
        local newY = x * sinTheta + y * cosTheta
        return Vector2new(newX, newY)
    end
	function Utility:Lerp(start, endpos, status)
        return start + (endpos - start) * status
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
	function Utility:GetLocalWeapon()
		local WeaponController = WeaponControllerInterface:getController()

		return WeaponController and WeaponController._activeWeaponRegistry[WeaponController._activeWeaponIndex] or nil, WeaponController
	end

	--
end --

-- Handlers
do
	Library:Connect(UserInputService.InputBegan, LPH_NO_VIRTUALIZE(function(input)
		if input.UserInputType == Library.flags["aim_assist_key"] or input.KeyCode == Library.flags["aim_assist_key"] then
			Legitbot.Aimbot.KeybindStatus = true
		end
	end))

	Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function()
		MouseLocation = UserInputService:GetMouseLocation()
	end))

	Library:Connect(UserInputService.InputEnded, LPH_NO_VIRTUALIZE(function(input)
		if input.UserInputType == Library.flags["aim_assist_key"] or input.KeyCode == Library.flags["aim_assist_key"] then
			Legitbot.Aimbot.KeybindStatus = false
		end
	end))

	Library:Connect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
		ScreenSize = Camera.ViewportSize
		BarrelPosition = nil

		local Weapon, WeaponController = Utility:GetLocalWeapon()

		local BarrelPart = Weapon and Weapon._barrelPart or nil
		local BarrelPos = BarrelPart and BarrelPart.Position or Vector3zero
		
		if WeaponController and WeaponController._activeWeaponIndex <= 2 then
            local BarrelLook = BarrelPart and BarrelPart.Parent.Trigger.CFrame.LookVector * 200
            local Ray = workspace:Raycast(BarrelPos, BarrelLook, RayParams)
            local Position = Camera:WorldToViewportPoint(Ray and Ray.Position or (BarrelPos + BarrelLook))
            BarrelPosition = Vector2.new(Position.x, Position.y)
		end
	end))
end

-- Legitbot
do
	-- Aimbot
	local Aimbot = Legitbot.Aimbot

	Aimbot.Circles = {
		Fov = Utility:New("Circle", {
			Visible = false,
			Transparency = 1,
		}),
		Deadzone = Utility:New("Circle", {
			Visible = false,
			Transparency = 1,
		}),
	}

	Library:Connect(RunService.Heartbeat, LPH_JIT_MAX(function() -- Aim Assist
		local Weapon, WeaponController = Utility:GetLocalWeapon()

		Aimbot.Targets = {}
		Aimbot.Target = nil

		local CharacterObject = CharacterInterface.getCharacterObject()

		local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

		local Origin = HumanoidRootPart and HumanoidRootPart.Position or Camera.CFrame.p

		local ScopeValueSpring = 1 - mathclamp(CharacterObject and CharacterObject:getSpring("zoommodspring").p or 1, 0, 1)

		Aimbot.Position = Library.Flags["aim_assist_hitscan_pos"] == "Barrel" 
			and BarrelPosition 
			and Vector2new(
				Utility:Lerp(ScreenSize.x / 2, BarrelPosition.x, ScopeValueSpring),
				Utility:Lerp(ScreenSize.y / 2, BarrelPosition.y, ScopeValueSpring)
			)
			or ScreenSize / 2

		if not (Library.flags["aim_assist_enabled"] and Aimbot.KeybindStatus) then
			return
		end

		if Library.open then
			return
		end

		for _,v in next, Players:GetPlayers() do
			if v == LocalPlayer then
				continue
			end

			if v.Team == LocalPlayer.Team then
				continue
			end

			if not Utility:IsAlive(v) then
				continue
			end

			local Character = Utility:GetCharacter(v)
			local Torso = Character and Character.Torso or nil
			local Head = Character and Character.Head or nil
			
			if not (Character and Torso and Head) then
				continue
			end

			local Pos, OnScreen = Camera:WorldToViewportPoint(Torso.Position)

			if not (Pos and OnScreen) then
				continue
			end
			
			local ScreenPos = Vector2new(Pos.x, Pos.y)
			local DistanceFromTorso = (Torso.Position - Origin).Magnitude

			if Library.Flags["aim_assist_limit"] and Library.Flags["aim_assist_max_distance"] < DistanceFromTorso then
				continue
			end

			local Direction = (Head.Position - Origin)
			if Library.flags["aim_assist_visible_check"] and workspace:Raycast(Origin, Direction, RayParams) then
				continue
			end

			local AimbotMagnitude = (ScreenPos - Aimbot.Position).Magnitude

			if Library.Flags["aim_assist_fov"] < AimbotMagnitude then
				continue
			end
			
			if Library.Flags["aim_assist_deadzone"] > 0 and Library.Flags["aim_assist_deadzone"] > AimbotMagnitude then
				continue
			end

			local Hitbox = nil

			if Library.Flags["aim_assist_hitscan"] == "Head" then
				Hitbox = Head
			elseif Library.Flags["aim_assist_hitscan"] == "Torso" then
				Hitbox = Torso
			else
				local HeadPos = Camera:WorldToViewportPoint(Head.Position)

				local ScreenHeadPos = Vector2new(HeadPos.x, HeadPos.y)

				local HeadPosMagnitude = (ScreenHeadPos - Aimbot.Position).Magnitude
				
				Hitbox = HeadPosMagnitude > AimbotMagnitude and Head or Torso
			end
			
			local ScreenMagnitude = (ScreenPos - (ScreenSize / 2)).Magnitude

			local Health = Utility:GetHealth(v)

			tableinsert(Aimbot.Targets, {
				["Player"] = v,
				["Health"] = Health,
				["Magnitude"] = ScreenMagnitude,
				["Distance"] = DistanceFromTorso,
				["Hitbox"] = Hitbox
			})
		end
		
		-- "Screen", "Health", "Distance"
		if Library.flags["aim_assist_target_selection"] == "Screen" then
			tablesort(Aimbot.Targets, function(index1, index2)
                return index1.Magnitude < index2.Magnitude
			end)
  		elseif Library.flags["aim_assist_target_selection"] == "Health" then
			tablesort(Aimbot.Targets, function(index1, index2)
				return index1.Health < index2.Health
			end)
		elseif Library.flags["aim_assist_target_selection"] == "Distance" then
			tablesort(Aimbot.Targets, function(index1, index2)
				return index1.Distance < index2.Distance
			end)
		end

		if #Aimbot.Targets > 0 then
			local Target = Aimbot.Targets[1]
			local Hitbox = Target.Hitbox

			Aimbot.Target = Target.Player

			if Hitbox then
				local Pos, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)

				if Pos and OnScreen then
					Pos = Pos + (Library.Flags["aim_assist_pred"] and Hitbox.Velocity or Vector3zero)

					local ScreenPos = Vector2new(Pos.x, Pos.y)

					local SmoothX = Library.Flags["aim_assist_smoothness_horizontal"] + 1
					local SmoothY = Library.Flags["aim_assist_smoothness_horizontal"] + 1

					mousemoverel(( ScreenPos.x - MouseLocation.x ) / SmoothX, ( ScreenPos.y - MouseLocation.y ) / SmoothX)
				end
			end
		end
	end))
	--

	-- Silent Aim

	--

	-- FOV Circles
	Library:Connect(RunService.Heartbeat, LPH_JIT_MAX(function() -- Aim Assist

		local Fov = Aimbot.Circles.Fov
		local Deadzone = Aimbot.Circles.Deadzone

		Fov.Visible = Library.Flags["aim_fov"] or false

		if Fov.Visible then
			Fov.Position = Aimbot.Position
			Fov.Radius = Library.Flags["aim_assist_fov"]
			Fov.Color = Library.Flags["aim_fov_color"]
			Fov.Thickness = Library.Flags["aim_fov_thick"]
			Fov.NumSides = Library.Flags["aim_fov_sides"]
		end
		
		Deadzone.Visible = Library.Flags["aim_dead"] or false

		if Deadzone.Visible then
			Deadzone.Position = Aimbot.Position
			Deadzone.Radius = Library.Flags["aim_assist_deadzone"]
			Deadzone.Color = Library.Flags["aim_dead_color"]
			Deadzone.Thickness = Library.Flags["aim_dead_thick"]
			Deadzone.NumSides = Library.Flags["aim_dead_sides"]
		end
	end))
	--

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
			["HealthBarOutline"] = Utility:New("Square", {
				Visible = false,
				Filled = true,
				Transparency = 1
			}),
			["HealthBar"] = Utility:New("Square", {
				Visible = false,
				Filled = true,
				Transparency = 1
			}),
			["HealthNumber"] = Utility:New("Text", {
				Visible = false,
				Outline = true,
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
				Visible = false,
				Outline = true,
				Transparency = 1
			}),
			["Team"] = Utility:New("Text", {
				Visible = false,
				Outline = true,
				Transparency = 1
			}),
			["Arrow"] = Utility:New("Triangle", {
				Visible = false,
				Filled = true,
				Transparency = 1
			}),
		}
	end

	function ESP:GetColor(player)
		-- ill add checks if target n shit

		return Library.Flags["esp_highlight_target"] and Legitbot.Aimbot.Target == player and Library.Flags["esp_highlight_target_color"] or Library.Flags["esp_highlight_friend"] and Library.Playerlist:IsTagged(player, "Friended") and Library.Flags["esp_highlight_friend_color"] or Library.Flags["esp_highlight_priority"] and Library.Playerlist:IsTagged(player, "Prioritized") and Library.Flags["esp_highlight_priority_color"] or nil
	end

	function ESP:NewPlayer(player)
		if ESP.Players[player] then
			return
		end

		local ESP_P = {
			Player = player,
			Drawings = ESP:NewDrawingLayout(player),
			Unrendered = false
		}

		local Drawings = ESP_P.Drawings

		function ESP_P:Unrender()
			for _,v in next, Drawings do
				v.Visible = false
			end
		end

		ESP_P.Loop = Library:Connect(RunService.Heartbeat, LPH_JIT_MAX(function()
			local TeamFlag = "E_"
			
			local CharacterObject = CharacterInterface.getCharacterObject()

			local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

			if player.Team == LocalPlayer.Team then
				TeamFlag = "T_"
			end

			if not Library.Flags[TeamFlag .. "enabled"]	 then
				return ESP_P:Unrender()
			end

			if Utility:IsAlive(player) then
				ESP_P.Alive = true
				ESP_P.Unrendered = false
			else
				if not ESP_P.Unrendered then
					ESP_P.Unrendered = true
					return ESP_P:Unrender()
				end
			end

			local Character = Utility:GetCharacter(player)

			if Character then
				local Torso = Character.Torso

				if Torso then
					local Origin = HumanoidRootPart and HumanoidRootPart.Position or Camera.CFrame.p

					local DistanceFromTorso = (Torso.Position - Origin).Magnitude

					if Library.Flags["esp_limit_distance"] and Library.Flags["esp_limit_distance_amount"] < DistanceFromTorso then
						return ESP_P:Unrender()	
					end

					local Pos, OnScreen = Camera:WorldToViewportPoint(Torso.Position)

					local Arrow = Drawings["Arrow"]

					if not OnScreen then
						ESP_P:Unrender()

						if Library.Flags[TeamFlag .. "oof"] then
							local PosT = Camera.CFrame:PointToObjectSpace(Torso.Position)
							local Angle = mathatan2(PosT.Z, PosT.X)
							local Direction = Vector2new(mathcos(Angle), mathsin(Angle))
							local Pos = (Direction * Library.Flags[TeamFlag .. "oof_distance"]) + (ScreenSize / 2)

							Pos = Vector2new(mathclamp(Pos.X, 0, ScreenSize.X), mathclamp(Pos.Y, 0, ScreenSize.Y))

							local Size = Library.Flags[TeamFlag .. "oof_size"]

							Arrow.Visible = true
							Arrow.Color = Library.Flags[TeamFlag .. "oof_color"]
							Arrow.PointA = Pos + Vector2new(1, 1)
							Arrow.PointB = Pos - Utility:RotateVector2(Direction, mathrad(35)) * Size
							Arrow.PointC = Pos - Utility:RotateVector2(Direction, -mathrad(35)) * Size
						else
							Arrow.Visible = false
						end

						return 
					end

					if Arrow.Visible then
						Arrow.Visible = false
					end

					local PlayerRank = Utility:GetPlayerStat(player, "Rank") or 0

					local BottomOffset = Vector2zero
					local RightOffset = Vector2zero

					local BoxSize, BoxPosition = ESP:BoxSizing(Torso)

					local OverrideColor = ESP:GetColor(player)

					local Health = Utility:GetHealth(player)
					local HealthScale = Health / 100

					-- Box ESP
					local BoxOutline = Drawings["BoxOutline"]
					local Box = Drawings["Box"]

					BoxOutline.Visible = Library.Flags[TeamFlag .. "box"]
					Box.Visible = Library.Flags[TeamFlag .. "box"]
					if Box.Visible and BoxOutline.Visible then
						BoxOutline.Size = BoxSize
						BoxOutline.Position = BoxPosition
						BoxOutline.Color = Library.Flags[TeamFlag .. "box_outline"]

						Box.Size = BoxSize
						Box.Position = BoxPosition
						Box.Color = OverrideColor or Library.Flags[TeamFlag .. "box_color"]
					end
					--

					-- Health Bar ESP
					local HealthBarOutline = Drawings["HealthBarOutline"]
					local HealthBar = Drawings["HealthBar"]

					HealthBarOutline.Visible = Library.Flags[TeamFlag .. "health"]
					HealthBar.Visible = Library.Flags[TeamFlag .. "health"]

					if HealthBar.Visible and HealthBarOutline.Visible then
						HealthBarOutline.Size = Vector2new(4, BoxSize.y + 2)
						HealthBarOutline.Position = Vector2new(BoxPosition.x - 6, BoxPosition.y - 1)
						HealthBarOutline.Color = Library.Flags[TeamFlag .. "health_outline"]

						local HealthSizeY = BoxSize.y * HealthScale

						HealthBar.Size = Vector2new(2, -HealthSizeY)
						HealthBar.Position = Vector2new(BoxPosition.x - 5, BoxPosition.y + BoxSize.y)
						HealthBar.Color = OverrideColor or Library.Flags[TeamFlag .. "health_color"]
					end
					--

					-- Name ESP
					local HealthNumber = Drawings["HealthNumber"]

					HealthNumber.Visible = Library.Flags[TeamFlag .. "health_number"] and Library.Flags["max_hp_vis_cap"] >= Health
					if HealthNumber.Visible then
						local HealthNumberPosition = Vector2new(BoxPosition.x - 8 - HealthNumber.TextBounds.x, 0)

						local HealthSizeY = BoxSize.y * HealthScale

						if Library.Flags[TeamFlag .. "health_number_follow"] and HealthBar.Visible then
							HealthNumberPosition = Vector2new(HealthNumberPosition.x, (BoxPosition.y + BoxSize.y) - HealthSizeY - (HealthNumber.TextBounds.y / 2))
						else
							HealthNumberPosition = Vector2new(HealthNumberPosition.x, BoxPosition.y - 2)
						end
						

						HealthNumber.Position = HealthNumberPosition
						HealthNumber.Color = OverrideColor or Library.Flags[TeamFlag .. "health_number_color"]
						HealthNumber.Font = Drawing.Fonts[Library.Flags["esp_font"]]
						HealthNumber.Size = Library.Flags["esp_font_size"]
						HealthNumber.Text = tostring(mathfloor(Health))
					end
					--

					-- Box Fill ESP
					local BoxFill = Drawings["BoxFill"]

					BoxFill.Visible = Library.Flags[TeamFlag .. "box_fill"]
					if BoxFill.Visible then
						BoxFill.Size = BoxSize - Vector2new(2, 2)
						BoxFill.Position = BoxPosition + Vector2new(1, 1)
						BoxFill.Color = OverrideColor or Library.Flags[TeamFlag .. "box_fill_color"]
						BoxFill.Transparency = Library.Flags[TeamFlag .. "box_fill_a"] / 255
					end
					--

					-- Name ESP
					local Name = Drawings["Name"]

					Name.Visible = Library.Flags[TeamFlag .. "name"]
					if Name.Visible then
						Name.Position = BoxPosition + Vector2new(BoxSize.x / 2, -( Name.TextBounds.y + 3 ))
						Name.Color = OverrideColor or Library.Flags[TeamFlag .. "name_color"]
						Name.Font = Drawing.Fonts[Library.Flags["esp_font"]]
						Name.Size = Library.Flags["esp_font_size"]
					end
					--
					
					-- Rank ESP
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
					--
					
					-- Team ESP
					local Team = Drawings["Team"]

					Team.Visible = Library.Flags[TeamFlag .. "team"]
					if Team.Visible then
						Team.Position = BoxPosition + Vector2new(BoxSize.x + 3, RightOffset.y - 3)
						Team.Color = OverrideColor or Library.Flags[TeamFlag .. "team_use_color"] and player.Team.TeamColor.Color or Library.Flags[TeamFlag .. "team_color"]
						Team.Font = Drawing.Fonts[Library.Flags["esp_font"]]
						Team.Size = Library.Flags["esp_font_size"]
						Team.Text = player.Team.Name

						RightOffset = Vector2new(RightOffset.x, RightOffset.y + Team.TextBounds.y + 2)
					end
					--
					
					if RightOffset.y - 3 > BoxSize.y then
						BottomOffset = Vector2new(BottomOffset.x, BottomOffset.y + mathclamp(RightOffset.y - BoxSize.y - 6, 0, 5^12))
					end

					-- Weapon ESP
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
					--

					-- Distance ESP
					local Distance = Drawings["Distance"]

					Distance.Visible = Library.Flags[TeamFlag .. "distance"]
					if Distance.Visible then
						Distance.Position = BoxPosition + Vector2new(BoxSize.x / 2, BoxSize.y + 3 + BottomOffset.y)
						Distance.Color = OverrideColor or Library.Flags[TeamFlag .. "distance_color"]
						Distance.Font = Drawing.Fonts[Library.Flags["esp_font"]]
						Distance.Size = Library.Flags["esp_font_size"]
						Distance.Text = tostring(mathfloor(DistanceFromTorso)) .. " studs"

						BottomOffset = Vector2new(BottomOffset.x, BottomOffset.y + Distance.TextBounds.y + 2)
					end
					--
				end
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
	local Window = Library:Load({ title = "Moonlight ", fontsize = 14, theme = "Default", folder = "moonlight", game = MarketPlaceService:GetProductInfo(game.PlaceId).Name, playerlist = true, performancedrag = true, discord = "https://discord.gg/jYrvZb4A35" })
	local Watermark = Library:Watermark("Moonlight | dev | v0.0.1a")
	--

	-- Tabs
	local LegitTab = Window:Tab("  Legit")
	--local RageTab = Window:Tab("Rage")
	local PlayersTab = Window:Tab("Players")
	local VisualsTab = Window:Tab("Visuals")
	--local MiscTab = Window:Tab("Misc")
	--

	-- Toggles
	local AimAssist = LegitTab:Section({ name = "Aim Assist", side = "left" })
	AimAssist:Toggle({ name = "Enabled", flag = "aim_assist_enabled" })
		:Keybind({ name = "Aim Assist", listignored = false, mode = "hold", blacklist = {}, flag = "aim_assist_key" })
	AimAssist:Toggle({ name = "Visible Check", flag = "aim_assist_visible_check" })
	AimAssist:Toggle({ name = "Predict Velocity", flag = "aim_assist_pred" })
	AimAssist:Slider({ name = "Field of View", default = 70, float = 1, suffix = "°", min = 1, max = 360, flag = "aim_assist_fov" })
	AimAssist:Slider({ name = "Deadzone", default = 5, float = 1, suffix = "°", min = 0, max = 50, flag = "aim_assist_deadzone" })
	AimAssist:Toggle({ name = "Limit Distance", flag = "aim_assist_limit" })
	AimAssist:Slider({ name = "Maximum Distance", default = 300, float = 1, suffix = " studs", min = 0, max = 5000, flag = "aim_assist_max_distance" })
	AimAssist:Slider({ name = "Horizontal Smoothing", default = 20, float = 1, suffix = "%", min = 1, max = 100, flag = "aim_assist_smoothness_horizontal" })
	AimAssist:Slider({ name = "Vertical Smoothing", default = 20, float = 1, suffix = "%", min = 1, max = 100, flag = "aim_assist_smoothness_vertical" })
	AimAssist:Dropdown({ name = "Target Selection", content = { "Screen", "Health", "Distance" }, multi = false, flag = "aim_assist_target_selection" })
		:Set("Screen")
	AimAssist:Dropdown({ name = "Hitscan", content = { "Head", "Torso", "Closest" }, multi = false, flag = "aim_assist_hitscan" })
		:Set("Head")
	AimAssist:Dropdown({ name = "Hitscan Position", content = { "Screen", "Barrel" }, multi = false, flag = "aim_assist_hitscan_pos" })
		:Set("Screen")

	--[[ local BulletRedirection = LegitTab:Section({ name = "Bullet Redirection", side = "middle" })
	BulletRedirection:Toggle({ name = "Enabled", flag = "bullet_redirection_enabled" })
	BulletRedirection:Toggle({ name = "Visible Check", flag = "bullet_redirection_visible_check" })
	-- BulletRedirection:Toggle({ name = "Team Check", flag = "bullet_redirection_team_check" })
	BulletRedirection:Separator()
	BulletRedirection:Slider({ name = "Field of View", default = 70, float = 1, suffix = "°", min = 0, max = 180, flag = "bullet_redirection_fov" })
	BulletRedirection:Slider({ name = "Deadzone", default = 5, float = 1, suffix = "°", min = 0, max = 50, flag = "bullet_redirection_deadzone" })
	BulletRedirection:Separator()
	BulletRedirection:Dropdown({ name = "Hitscan", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "bullet_redirection_hitscan" })
	BulletRedirection:Dropdown({ name = "Hitscan Priority", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = false, flag = "bullet_redirection_hitscan_priority" })

	local TriggerbotSection = LegitTab:Section({ name = "Triggerbot", side = "right" })
	TriggerbotSection:Toggle({ name = "Enabled", flag = "triggerbot_enabled" })
	TriggerbotSection:Toggle({ name = "Visible Check", flag = "triggerbot_visible_check" })
	-- TriggerbotSection:Toggle({ name = "Team Check", flag = "triggerbot_team_check" })
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
		local ESP = PlayersTab:Section({ name = _, side = v.Side })
		ESP:Toggle({ name = "Enabled", default = false, flag = v.Flag .. "enabled" })
		local BoxESP = ESP:Toggle({ name = "Box", default = false, flag = v.Flag .. "box" })
			BoxESP:Colorpicker({ name = "Box Color", default = Color3fromRGB(255, 0, 0), flag = v.Flag .. "box_color"})
			BoxESP:Colorpicker({ name = "Box Outline Color", default = Color3fromRGB(0, 0, 0), flag = v.Flag .. "box_outline"})
		ESP:Toggle({ name = "Box Fill", default = false, flag = v.Flag .. "box_fill" })
			:Colorpicker({ name = "Box Fill Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "box_fill_color"})
		ESP:Slider({ name = "Box Fill Transparency", default = 0, float = 1, min = 1, max = 255, flag = v.Flag .. "box_fill_a" })
		ESP:Toggle({ name = "Name", default = false, flag = v.Flag .. "name" })
			:Colorpicker({ name = "Name Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "name_color"})
		local HealthBar = ESP:Toggle({ name = "Health Bar", default = false, flag = v.Flag .. "health" })
			HealthBar:Colorpicker({ name = "Health Bar Color", default = Color3fromRGB(0, 255, 0), flag = v.Flag .. "health_color"})
			HealthBar:Colorpicker({ name = "Health Bar Outline Color", default = Color3fromRGB(0, 0, 0), flag = v.Flag .. "health_outline"})
		ESP:Toggle({ name = "Health Number", default = false, flag = v.Flag .. "health_number" })
			:Colorpicker({ name = "Health Number Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "health_number_color"})
		ESP:Toggle({ name = "Follow Health Bar", default = false, flag = v.Flag .. "health_number_follow" })
		ESP:Toggle({ name = "Distance", default = false, flag = v.Flag .. "distance" })
			:Colorpicker({ name = "Distance Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "distance_color"})
		ESP:Toggle({ name = "Weapon", default = false, flag = v.Flag .. "weapon" })
			:Colorpicker({ name = "Weapon Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "weapon_color"})
		ESP:Toggle({ name = "Rank", default = false, flag = v.Flag .. "rank" })
			:Colorpicker({ name = "Rank Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "rank_color"})
		ESP:Toggle({ name = "Team", default = false, flag = v.Flag .. "team" })
			:Colorpicker({ name = "Team Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "team_color"})
		ESP:Toggle({ name = "Use Team Color", default = false, flag = v.Flag .. "team_use_color" })
		ESP:Toggle({ name = "Out of View", default = false, flag = v.Flag .. "oof" })
			:Colorpicker({ name = "Out of View Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "oof_color"})
		ESP:Slider({ name = "Out of View Size", default = 13, float = 1, suffix = " px", min = 1, max = 30, flag = v.Flag .. "oof_size" })
		ESP:Slider({ name = "Out of View Distance", default = 250, float = 1, suffix = " px", min = 1, max = 1920, flag = v.Flag .. "oof_distance" })
		local Chams = ESP:Toggle({ name = "Chams", default = false, flag = v.Flag .. "chams" })
			Chams:Colorpicker({ name = "Chams Color", default = Color3fromRGB(0, 187, 255), flag = v.Flag .. "chams_color"})
			Chams:Colorpicker({ name = "Chams Outline Color", default = Color3fromRGB(0, 145, 255), flag = v.Flag .. "chams_outline"})
		ESP:Slider({ name = "Chams Transparency", default = 200, float = 1, min = 1, max = 255, flag = v.Flag .. "chams_a" })
		ESP:Slider({ name = "Chams Outline Transparency", default = 255, float = 1, min = 1, max = 255, flag = v.Flag .. "chams_outline_a" })
	end

	local ESPSettings = PlayersTab:Section({ name = "ESP Settings", side = "right" })
	ESPSettings:Toggle({ name = "Limit Distance", default = false, flag = "esp_limit_distance" })
	ESPSettings:Slider({ name = "Maximum Distance", default = 300, float = 1, suffix = " studs", min = 1, max = 5000, flag = "esp_limit_distance_amount" })
	ESPSettings:Dropdown({ name = "ESP Font", content = { "Plex", "Monospace", "UI", "System" }, multi = false, flag = "esp_font" })
		:Set("Plex")
	ESPSettings:Slider({ name = "ESP Size", default = 14, float = 1, suffix = " px", min = 1, max = 30, flag = "esp_font_size" })
	ESPSettings:Slider({ name = "Max HP Visibility Cap", default = 90, float = 1, suffix = " hp", min = 1, max = 100, flag = "max_hp_vis_cap" })
	ESPSettings:Toggle({ name = "Highlight Target", default = false, flag = "esp_highlight_target" })
		:Colorpicker({ name = "Highlight Target Color", default = Color3fromRGB(255, 0, 0), flag = "esp_highlight_target_color"})
	ESPSettings:Toggle({ name = "Highlight Friend", default = false, flag = "esp_highlight_friend" })
		:Colorpicker({ name = "Highlight Friend Color", default = Color3fromRGB(0, 166, 255), flag = "esp_highlight_friend_color"})
	ESPSettings:Toggle({ name = "Highlight Priority", default = false, flag = "esp_highlight_priority" })
		:Colorpicker({ name = "Highlight Priority Color", default = Color3fromRGB(0, 255, 157), flag = "esp_highlight_priority_color"})
	
	local Interface = VisualsTab:Section({ name = "Interface", side = "Left" })
	Interface:Toggle({ name = "Aimbot FOV", default = false, flag = "aim_fov" })
		:Colorpicker({ name = "Aimbot FOV Color", default = Color3fromRGB(255, 255, 255), flag = "aim_fov_color"})
	Interface:Slider({ name = "Thickness", default = 1, float = 1, suffix = " px", min = 1, max = 30, flag = "aim_fov_thick" })
	Interface:Slider({ name = "Num Sides", default = 30, float = 1, suffix = " sides", min = 1, max = 100, flag = "aim_fov_sides" })
	Interface:Toggle({ name = "Aimbot Deadzone", default = false, flag = "aim_dead" })
		:Colorpicker({ name = "Aimbot Deadzone Color", default = Color3fromRGB(255, 255, 255), flag = "aim_dead_color"})
	Interface:Slider({ name = "Thickness", default = 1, float = 1, suffix = " px", min = 1, max = 30, flag = "aim_dead_thick" })
	Interface:Slider({ name = "Num Sides", default = 30, float = 1, suffix = " sides", min = 1, max = 100, flag = "aim_dead_sides" })
	--

	-- Settings Tab
	Window:SettingsTab(Watermark)
	--

	-- Player List
	Library.Playerlist:button({
		name = "Prioritize",
		callback = function(list, plr)
			if not list:IsTagged(plr, "Prioritized") then
				list:Tag({ player = plr, text = "Prioritized", color = Color3fromRGB(255, 0, 0) })
			else
				list:RemoveTag(plr, "Prioritized")
			end
		end,
	})

	Library.Playerlist:button({
		name = "Friend",
		callback = function(list, plr)
			if not Library.Playerlist:IsTagged(plr, "Friended") then
				Library.Playerlist:Tag({ player = plr, text = "Friended", Color = Color3fromRGB(120, 120, 120) })
			else
				Library.Playerlist:RemoveTag(plr, "Friended")
			end
		end,
	})

	Library.Playerlist:Label({
		name = "Rank: ",
		handler = function(plr)
			return Utility:GetPlayerStat(plr, "Rank")
		end,
	})

	Library.Playerlist:Label({
		name = "Team: ",
		handler = function(plr)
			return plr.Team and plr.Team.Name or "None", plr.Team and plr.Team.TeamColor.Color or Color3fromRGB(209, 118, 0)
		end,
	}) --

end --

Library:Init()
Library:Notify({ title = "Welcome", message = string.format("Welcome to Moonlight, %s! Version: %s | Loaded modules in (%sms)", LocalPlayer.Name, "v0.0.1a", math.floor((os.clock() - LoadTimeTick) * 1000)), duration = 3 })