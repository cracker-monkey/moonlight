if not LPH_OBFUSCATED and getgenv().Moonlight then
	getgenv().Moonlight.Libraries.Utility:Unload()
end

if not game.PlaceId == 292439477 then
	return
end

-- todo
--[[
	optimized a lil bit more,
	bullet tracers (local, enemy, team),
	cursor,
	silent aim fov - done,
	join new game on votekick,
	auto kick,
	gun mods,
	chatspam
]]--

-- Libraries
local Library = loadstring(game:HttpGet("https://e-z.tools/p/raw/6j3xg81igs", true))()
--

-- Services
local NetworkClient = game:GetService("NetworkClient")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketPlaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")
--

-- Variables
local RemoteEvent = ReplicatedStorage.RemoteEvent
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
local mathrandom = math.random
local Env = getgenv()
local Ignores = { workspace.Players, workspace.Ignore, Camera }

local Gravity = Vector3new(0, workspace.Gravity, 0)

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
	Objects = {},
	BindToRenders = {}
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

local Directions = {
    Vector3new(0, -1, 0),
    Vector3new(-1, 0, 0),
    Vector3new(1, 0, 0),
    Vector3new(0, 1, 0),
    Vector3new(0, 0, 1),
    Vector3new(0, 0, -1),
}

local Ragebot = {
	Targets = {},
    LastHit = os.clock()
}

local Visuals = {
	Materials = {
		["ForceField"] = Enum.Material.ForceField,
		["SmoothPlastic"] = Enum.Material.SmoothPlastic,
		["Glass"] = Enum.Material.Glass,
		["Neon"] = Enum.Material.Neon,
		["Plastic"] = Enum.Material.Plastic,
	},
	Textures = {
		["Groove"] = "rbxassetid://10785404176",
		["Cloud"] = "rbxassetid://5176277457",
		["Sky"] = "rbxassetid://1494603972",
		["Smudge"] = "rbxassetid://6096634060",
		["Scrapes"] = "rbxassetid://6248583558",
		["Galaxy"] = "rbxassetid://1120738433",
		["Stars"] = "rbxassetid://598201818",
		["Rainbow"] = "rbxassetid://10037165803",
	},
	BulletTracers = {
		["Drawing"] = "", -- drawing as in Drawing.new("Line")
		["Default"] = "rbxassetid://446111271",
		["Beam"] = "rbxassetid://7151777149",
		["Ion Beam"] = "rbxassetid://2950987173",
		["Missing Texture"] = "rbxassetid://1541381206",
		["Skibidy Toilet"] = "rbxassetid://14488881439"
	},
	Skyboxes = {
		["Purple Nebula"] = {
			["SkyboxBk"] = "rbxassetid://159454299",
			["SkyboxDn"] = "rbxassetid://159454296",
			["SkyboxFt"] = "rbxassetid://159454293",
			["SkyboxLf"] = "rbxassetid://159454286",
			["SkyboxRt"] = "rbxassetid://159454300",
			["SkyboxUp"] = "rbxassetid://159454288"
		},
		["Night Sky"] = {
			["SkyboxBk"] = "rbxassetid://12064107",
			["SkyboxDn"] = "rbxassetid://12064152",
			["SkyboxFt"] = "rbxassetid://12064121",
			["SkyboxLf"] = "rbxassetid://12063984",
			["SkyboxRt"] = "rbxassetid://12064115",
			["SkyboxUp"] = "rbxassetid://12064131"
		},
		["Pink Daylight"] = {
			["SkyboxBk"] = "rbxassetid://271042516",
			["SkyboxDn"] = "rbxassetid://271077243",
			["SkyboxFt"] = "rbxassetid://271042556",
			["SkyboxLf"] = "rbxassetid://271042310",
			["SkyboxRt"] = "rbxassetid://271042467",
			["SkyboxUp"] = "rbxassetid://271077958"
		},
		["Morning Glow"] = {
			["SkyboxBk"] = "rbxassetid://1417494030",
			["SkyboxDn"] = "rbxassetid://1417494146",
			["SkyboxFt"] = "rbxassetid://1417494253",
			["SkyboxLf"] = "rbxassetid://1417494402",
			["SkyboxRt"] = "rbxassetid://1417494499",
			["SkyboxUp"] = "rbxassetid://1417494643"
		},
		["Setting Sun"] = {
			["SkyboxBk"] = "rbxassetid://626460377",
			["SkyboxDn"] = "rbxassetid://626460216",
			["SkyboxFt"] = "rbxassetid://626460513",
			["SkyboxLf"] = "rbxassetid://626473032",
			["SkyboxRt"] = "rbxassetid://626458639",
			["SkyboxUp"] = "rbxassetid://626460625"
		},
		['Cache'] = {
			['SkyboxBk'] = 'rbxassetid://220513302';
			['SkyboxDn'] = 'rbxassetid://213221473';
			['SkyboxFt'] = 'rbxassetid://220513328';
			['SkyboxLf'] = 'rbxassetid://220513318';
			['SkyboxRt'] = 'rbxassetid://220513279';
			['SkyboxUp'] = 'rbxassetid://220513345';
		},
		["Fade Blue"] = {
			["SkyboxBk"] = "rbxassetid://153695414",
			["SkyboxDn"] = "rbxassetid://153695352",
			["SkyboxFt"] = "rbxassetid://153695452",
			["SkyboxLf"] = "rbxassetid://153695320",
			["SkyboxRt"] = "rbxassetid://153695383",
			["SkyboxUp"] = "rbxassetid://153695471"
		},
		["Elegant Morning"] = {
			["SkyboxBk"] = "rbxassetid://153767241",
			["SkyboxDn"] = "rbxassetid://153767216",
			["SkyboxFt"] = "rbxassetid://153767266",
			["SkyboxLf"] = "rbxassetid://153767200",
			["SkyboxRt"] = "rbxassetid://153767231",
			["SkyboxUp"] = "rbxassetid://153767288"
		},
		["Neptune"] = {
			["SkyboxBk"] = "rbxassetid://218955819",
			["SkyboxDn"] = "rbxassetid://218953419",
			["SkyboxFt"] = "rbxassetid://218954524",
			["SkyboxLf"] = "rbxassetid://218958493",
			["SkyboxRt"] = "rbxassetid://218957134",
			["SkyboxUp"] = "rbxassetid://218950090"
		},
		["Redshift"] = {
			["SkyboxBk"] = "rbxassetid://401664839",
			["SkyboxDn"] = "rbxassetid://401664862",
			["SkyboxFt"] = "rbxassetid://401664960",
			["SkyboxLf"] = "rbxassetid://401664881",
			["SkyboxRt"] = "rbxassetid://401664901",
			["SkyboxUp"] = "rbxassetid://401664936"
		},
		["Aesthetic Night"] = {
			["SkyboxBk"] = "rbxassetid://1045964490",
			["SkyboxDn"] = "rbxassetid://1045964368",
			["SkyboxFt"] = "rbxassetid://1045964655",
			["SkyboxLf"] = "rbxassetid://1045964655",
			["SkyboxRt"] = "rbxassetid://1045964655",
			["SkyboxUp"] = "rbxassetid://1045962969"
		}
	},
	CrosshairDrawings = {},
	BulletTracerDrawings = {}
}

local Misc = {
	AutoJumpKey = false,
	VoteKicked = false,
}

local ESP = {
	Players = {}
}

local Network = {
	Connections = {},
	Client = nil,
	ClockDependant = {
		["newbullets"] = 3,
		["equip"] = 2,
		["spotplayers"] = 2,
		["updatesight"] = 3,
		["knifehit"] = 4,
		["newgrenade"] = 3,
		["repupdate"] = 3,
		["bullethit"] = 6,
	},
	Shift = 0
}

local Moonlight = {
	Libraries = {
		Modules = Modules,
		Utility = Utility,
		Legitbot = Legitbot,
		Visuals = Visuals,
		ESP = ESP,
		Network = Network,
		Hook = Hook,
		Library = Library
	}
}

if not LPH_OBFUSCATED then
	Env.Moonlight = Moonlight
end
--

-- Luraph Functions
if not LPH_OBFUSCATED then
	LPH_ENCSTR = function(...) return ... end
	LPH_ENCNUM = function(...) return ... end
	LPH_CRASH = function(...) return ... end
	LPH_JIT = function(...) return ... end
	LPH_JIT_MAX = function(...) return ... end
	LPH_NO_VIRTUALIZE = function(...) return ... end
	LPH_NO_UPVALUES = function(...) return ... end
end
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

	function Modules:Get(name)
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

		for _,v in next, Utility.BindToRenders do
			RunService:UnbindFromRenderStep(v)
		end

		Network:Unload()

		Env.Moonlight = nil
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
	function Utility:BindToRenderStep(name, enum, callback)
        RunService:BindToRenderStep(name, enum, callback)
    
        Utility.BindToRenders[name] = name
	end
	function Utility:UnbindFromRenderStep(name)
		RunService:UnbindFromRenderStep(name)

		Utility.BindToRenders[name] = nil
	end
	function Utility:PlaySound(id, volume, pitch)
		id = tostring(id)
	
		id = id:gsub("rbxassetid://", "")
	
		local Sound = Utility:New("Sound", {
			Parent = Camera,
			Volume = volume / 100,
			Pitch = pitch / 100,
			SoundId = "rbxassetid://" .. tostring(id),
			PlayOnRemove = true
		}):Destroy()
	end
	function Utility:CreateDrawingTracer(Cfg)
		Cfg = {
			Positions = Cfg.Positions or {},
			Time = Cfg.Time or 5,
			Color = Cfg.Color or Color3fromRGB(255, 255, 255),
			Outline = Cfg.Outline or Color3fromRGB(0, 0, 0),
		}
	
		local CharacterObject = CharacterInterface.getCharacterObject()
	
		local HumanoidRootPart = CharacterObject and CharacterObject._rootPart
	
		local Tracer = {
			["Objects"] = {},
			["StartTick"] = os.clock(),
		}
	
		for _,v in next, Cfg.Positions do
			local OutlineObject = Utility:New("Line", {
				Thickness = 3,
				Transparency = 1,
				--ZIndex = 1,
				Color = Color3fromRGB(0, 0, 0)
			})
	
			local Obj = Utility:New("Line", {
				Thickness = 1,
				Transparency = 1,
				--ZIndex = 2,
				Color = Color3fromRGB(255, 255, 255)
			})
	
			Tracer.Objects[_] = {
				["OutlineObject"] = OutlineObject,
				["Object"] = Obj
			}
		end
	
		local Connection = RunService.Heartbeat:Connect(function()
			local ScreenSize = Camera.ViewportSize
	
			local Transparency = 1
			local OutlineTransparency = 1
	
			local Origin = HumanoidRootPart and HumanoidRootPart.Position or Camera.CFrame.p
	
			if os.clock() - Tracer.StartTick > Cfg.Time then
				Tracer:Remove()
				table.remove(Visuals.BulletTracerDrawings, _)
			end
	
			for _,v in next, Cfg.Positions do
				local From = _ == 1 and v or Cfg.Positions[_ - 1] or Vector3zero
				local To = v or Vector3zero
			
				local DistanceFromTracer = ((v or Vector3zero) - Origin).Magnitude
	
				local Trans = Transparency
				local OutlineTrans = OutlineTransparency
	
				local Objects = Tracer.Objects[_]
	
				local OutlineObject = Objects.OutlineObject
				local Object = Objects.Object
	
				local FromScreen, FromOnScreen = Camera:WorldToViewportPoint(From)
				local ToScreen, ToOnScreen = Camera:WorldToViewportPoint(To)
				
				Object.Visible = ToOnScreen and FromOnScreen
				OutlineObject.Visible = ToOnScreen and FromOnScreen
	
				if Object.Visible and OutlineObject.Visible then
					local FromVector2 = Vector2new(FromScreen.x, FromScreen.y)
					local ToVector2 = Vector2new(ToScreen.x, ToScreen.y)
					
					Object.From = FromVector2
					Object.To = ToVector2
					Object.Color = Cfg.Color
		
					OutlineObject.From = FromVector2
					OutlineObject.To = ToVector2
					OutlineObject.Color = Cfg.Outline
				end
			end
		end)
		Tracer.Connection = Connection
	
		function Tracer:Remove()
			for _,v in next, Tracer.Objects do
				v.OutlineObject:Remove()
				v.Object:Remove()
			end
	
			Tracer.Connection:Disconnect()
		end
	
		Visuals.BulletTracerDrawings[#Visuals.BulletTracerDrawings + 1] = Tracer
	end
	--

	-- Game Functions
	function Utility:GetEntry(player)
		return player and ReplicationInterface.getEntry(player) or nil
	end

	function Utility:GetThirdPersonObject(player)
        local Entry = Utility:GetEntry(player)

        if Entry then
            return Entry._thirdPersonObject or nil
        end

		return nil
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
	function Utility:Trajectory(o, a, t, s, e)
        local f = -a
        local ld = t - o
        local a = Vector3zero.Dot(f, f)
        local b = 4 * Vector3zero.Dot(ld, ld)
        local k = (4 * (Vector3zero.Dot(f, ld) + s * s)) / (2 * a)
        local v = (k * k - b / a) ^ 0.5
        local t, t0 = k - v, k + v

        t = t < 0 and t0 or t
        t = t ^ 0.5
        return f * t / 2 + (e or Vector3zero) + ld / t, t
    end
	--
end --

-- Network
do
	if not Network.Client then
		Network.Client = NetworkClient

		if not Network.Client then
			for i = 1, 5 do
				Library:Notify({ title = "Error", message = "!!IMPORTANT!! Failed to fetch network client. Please screenshot your F9 console and send it to cheat-developers.", duration = 20 })
			end
		end
	end

	function Network:Send(command, ...)
		if not Network.Client then
			return
		end

		Network.Client.send(self, command, ...)
	end

	function Network:Connect(func)
		if not Network.Client then
			return
		end

		Network.Connections[#Network.Connections + 1] = func
	end

	local OldNetwork = Network.Client.send

	Network.Client.send = function(self, command, ...)
		local Args = {...}

		for _,v in next, Network.Connections do
			Args = v(command, unpack(Args))
		end

		if not Args then
			return
		end

		return OldNetwork(self, command, unpack(Args))
	end

	function Network:Unload()
		Network.Client.send = OldNetwork
	end
end --

-- Handlers
do
	Library:Connect(UserInputService.InputBegan, LPH_NO_VIRTUALIZE(function(input)
		if input.UserInputType == Library.flags["aim_assist_key"] or input.KeyCode == Library.flags["aim_assist_key"] then
			Legitbot.Aimbot.KeybindStatus = true
		end

		if input.UserInputType == Library.flags["auto_jump_key"] or input.KeyCode == Library.flags["auto_jump_key"] then
			Misc.AutoJumpKey = true
		end
	end))

	Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function()
		MouseLocation = UserInputService:GetMouseLocation()
	end))

	Library:Connect(UserInputService.InputEnded, LPH_NO_VIRTUALIZE(function(input)
		if input.UserInputType == Library.flags["aim_assist_key"] or input.KeyCode == Library.flags["aim_assist_key"] then
			Legitbot.Aimbot.KeybindStatus = false
		end

		if input.UserInputType == Library.flags["auto_jump_key"] or input.KeyCode == Library.flags["auto_jump_key"] then
			Misc.AutoJumpKey = false
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

do	
    function Ragebot:FakeShoot(info)
        local Weapon = info.Weapon

        -- ok i need to figure out how to add fake bullet here

		local CharacterObject = CharacterInterface.getCharacterObject()
        Weapon:impulseSprings(CharacterObject:getSpring("aimspring").p)

        if Weapon:getWeaponStat("type") == "REVOLVER" and not Weapon:getWeaponStat("caselessammo") then
            Sound.play("metalshell", 0.1)
        elseif Weapon:getWeaponStat("type") == "SHOTWeapon" then 
            Sound.play("shotWeaponshell", 0.2)
        elseif Weapon:getWeaponStat("type") == "SNIPER" then
            Weapon:playAnimation("pullbolt", true, true)

            Sound.play("metalshell", 0.15, 0.8)
        end

        if Weapon:getWeaponStat("sniperbass") then
            Sound.play("1PsniperEcho", 1)
            Sound.play("1PsniperBass", 0.75)
        end

        if not Weapon:getWeaponStat("nomuzzleeffects") then
            Effects.muzzleflash(
                Weapon._barrelPart, 
                Weapon:getWeaponStat("hideflash")
            )
        end

        Utility:PlaySound(
            Weapon:getWeaponStat("firesoundid"),
            Weapon:getWeaponStat("firevolume") * 100,
            Weapon:getWeaponStat("firepitch") * 100
        )

        HudCrosshairsInterface.fireHitmarker("Head")
    end

    function Ragebot:Shift(info)
        info = {
            Range = info.Range or 1,
            Position = info.Position or nil,
            Storage = info.Storage or {},
            ReturnFirePos = info.ReturnFirePos or false
        }

        local Position = info.Position
        local Range = info.Range
        local Storage = info.Storage

        if not Storage then
            return
        end

        for _,v in next, Directions do
            local Ray = workspace:Raycast(Position, (v * Range), RayParams)
            local ReturnedPos = Ray and (Ray.Position - v) or Position + (v * Range)

            Storage[#Storage] = info.ReturnFirePos and {
                Position = ReturnedPos
            } or ReturnedPos
        end

        return Storage
    end

    function Ragebot:Shoot(info)
        local Weapon = info.Weapon

        local Firerate = 60 / FirearmObject.getFirerate(Weapon)

        local HitTick = os.clock()
        if HitTick - Ragebot.LastHit <= Firerate then
            return
        end

        Ragebot.LastHit = HitTick

        -- // i was too lazy to make reload thing so i stole it
        local WeaponData = info.WeaponData

        Weapon._magCount -= 1
        if Weapon._magCount < 1 then
            local newCount = WeaponData.magsize + (WeaponData.chamber and 1 or 0) + Weapon._magCount
            if Weapon._spareCount >= newCount then
                Weapon._magCount += newCount
                Weapon._spareCount -= newCount
            else
                Weapon._magCount += Weapon._spareCount
                Weapon._spareCount = 0
            end
            Network:Send("reload")
        end

        local Bullets = {}

        local FireCount = Weapon._fireCount

        for i = 1, WeaponData.pelletcount or 1 do
            FireCount += 1

            Bullets[i] = { info.Trajectory, FireCount }            
        end

        Weapon._fireCount = FireCount

        local Clock = GameClock.getTime()

        --Network.Shift += Firerate

        Network:Send("newbullets", Weapon.uniqueId, {
            camerapos = info.FirePosition,
            firepos = info.FirePosition,
            bullets = Bullets,
        }, Clock)

        for _,v in next, Bullets do
            Network:Send("bullethit", Weapon.uniqueId, info.Player.Player, info.HitPosition, "Head", v[2], Clock)
        end

        Ragebot:FakeShoot(info)
    end

	function Ragebot:ScanPlayer(player, weapon)
		if not player then
			return
		end

		local CharacterObject = CharacterInterface.getCharacterObject()
		local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

		local BarrelPosition = weapon and weapon._barrelPart and weapon._barrelPart.Position or HumanoidRootPart.Position

        local Character = player.Character

		local ThirdPersonObject = player.ThirdPersonObject

		local ReplicationObject = ThirdPersonObject._replicationObject

		local ReceivedPosition = ReplicationObject._receivedPosition or nil

		local WeaponData = weapon._weaponData

		local FirePosition = {
			{Position = BarrelPosition}
		}

        local HitPositions = {
            ReceivedPosition,
            Character.Head.Position,
        }

		if Library.Flags["rage_fire_pos"] then
			FirePosition = Ragebot:Shift({
				Storage = FirePosition,
				Position = HumanoidRootPart.Position,
				Range = Library.Flags["rage_fire_pos_amount"],
				ReturnFirePos = true,
			})
		end

		if Library.Flags["rage_hitbox"] then
			HitPositions = Ragebot:Shift({
				Storage = HitPositions,
				Position = ReceivedPosition or Character.Head.Position,
				Range = Library.Flags["rage_hitbox_amount"]
			})
		end

		for _, FirePosTable in next, FirePosition do
            for _, HitPosition in next, HitPositions do
                local FirePos = FirePosTable and FirePosTable.Position or Vector3zero

                if not (FirePos and HitPosition) then
                    continue
                end

                local Trajectory = Utility:Trajectory(FirePos, -Gravity, HitPosition, WeaponData.bulletspeed)
				
                if BulletCheck(FirePos, HitPosition, Trajectory, -Gravity, WeaponData.penetrationdepth, 1 / 60) then
                    Ragebot:Shoot({
                        Player = player,
                        FirePosition = FirePos,
                        BarrelPosition = BarrelPosition,
                        HitPosition = HitPosition,
                        Trajectory = Trajectory,
                        Weapon = weapon,
                        WeaponData = WeaponData
                    })

                    return
                end
            end
		end

		return
	end

	function Ragebot:GetTargets()
		Ragebot.Targets = {}

		for _,v in next, Players:GetPlayers() do
			if not (Utility:IsAlive(v) and v ~= LocalPlayer and v.Team ~= LocalPlayer.Team) then
				continue
			end

            local Character = Utility:GetCharacter(v)

            local CharacterObject = CharacterInterface.getCharacterObject()
            local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

            local Origin = HumanoidRootPart and HumanoidRootPart.Position or Camera.CFrame.p

            local ThirdPersonObject = Utility:GetThirdPersonObject(v)
            local ReplicationObject = ThirdPersonObject._replicationObject
            local ReceivedPosition = ReplicationObject._receivedPosition or Character.Head.Position

            local DistanceFromPlayer = (ReceivedPosition - Origin).Magnitude

			tableinsert(Ragebot.Targets, {
				Player = v,
				ThirdPersonObject = ThirdPersonObject,
				Health = Utility:GetHealth(v) or 0,
                Distance = DistanceFromPlayer,
				Character = Character
			})
		end

		tablesort(Ragebot.Targets, function(Index1, Index2)
			return Index1.Distance < Index2.Distance
		end)
	end

	function Ragebot.ScanPlayers()
		if not Library.Flags["ragebot"] then
			return
		end

		local Weapon, WeaponController = Utility:GetLocalWeapon()

		if not (Weapon and WeaponController and RoundSystemClientInterface.isRunning() and not RoundSystemClientInterface.isCountingDown()) then
			return
		end

        if not (Weapon._spareCount and Weapon._magCount) then
            return
        end

		if Weapon._spareCount <= 0 and Weapon._magCount <= 0 then
			return
		end

		Ragebot:GetTargets()

		local Target = Ragebot.Targets[1]

		if not Target then
			return
		end

        if Library.Playerlist:IsTagged(Target.Player, "Friended") then
            return
        end

		Ragebot:ScanPlayer(Target, Weapon)
	end

	Library:Connect(RunService.RenderStepped, Ragebot.ScanPlayers)
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

	Library:Connect(RunService.Heartbeat, LPH_JIT_MAX(function()
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
				
				Hitbox = HeadPosMagnitude < AimbotMagnitude and Head or Torso
			end
			
			local HitboxPosition = Hitbox.Position + (Library.Flags["silent_aim_pred"] and Hitbox.Velocity * (LocalPlayer:GetNetworkPing() * 1.15) or Vector3zero)

			local ScreenMagnitude = (ScreenPos - (ScreenSize / 2)).Magnitude

			local Health = Utility:GetHealth(v)

			tableinsert(Aimbot.Targets, {
				["Player"] = v,
				["Health"] = Health,
				["Magnitude"] = ScreenMagnitude,
				["Distance"] = DistanceFromTorso,
				["Hitbox"] = Hitbox,
				["HitboxPosition"] = HitboxPosition
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
			local Hitbox = Target.HitboxPosition

			Aimbot.Target = Target.Player

			if Hitbox then
				local Pos, OnScreen = Camera:WorldToViewportPoint(Hitbox)

				if Pos and OnScreen then
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
	local SilentAim = Legitbot.SilentAim

	SilentAim.Circles = {
		Fov = Utility:New("Circle", {
			Visible = false,
			Transparency = 1,
		}),
		Deadzone = Utility:New("Circle", {
			Visible = false,
			Transparency = 1,
		}),
	}

	Library:Connect(RunService.Heartbeat, LPH_JIT_MAX(function()
		local Weapon, WeaponController = Utility:GetLocalWeapon()

		SilentAim.Targets = {}

		local CharacterObject = CharacterInterface.getCharacterObject()

		local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

		local Origin = HumanoidRootPart and HumanoidRootPart.Position or Camera.CFrame.p

		local ScopeValueSpring = 1 - mathclamp(CharacterObject and CharacterObject:getSpring("zoommodspring").p or 1, 0, 1)

		SilentAim.Position = Library.Flags["silent_aim_hitscan_pos"] == "Barrel" 
			and BarrelPosition 
			and Vector2new(
				Utility:Lerp(ScreenSize.x / 2, BarrelPosition.x, ScopeValueSpring),
				Utility:Lerp(ScreenSize.y / 2, BarrelPosition.y, ScopeValueSpring)
			)
			or ScreenSize / 2

		if Library.flags["silent_aim_enabled"] and not Library.open then
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

				if Library.Flags["silent_aim_limit"] and Library.Flags["silent_aim_max_distance"] < DistanceFromTorso then
					continue
				end

				local Direction = (Head.Position - Origin)
				if Library.flags["silent_aim_visible_check"] and workspace:Raycast(Origin, Direction, RayParams) then
					continue
				end

				local SilentAimMagnitude = (ScreenPos - SilentAim.Position).Magnitude

				if Library.Flags["silent_aim_fov"] < SilentAimMagnitude then
					continue
				end
				
				if Library.Flags["silent_aim_deadzone"] > 0 and Library.Flags["silent_aim_deadzone"] > SilentAimMagnitude then
					continue
				end

				local Hitbox = nil

				if Library.Flags["silent_aim_hitscan"] == "Head" then
					Hitbox = Head
				elseif Library.Flags["silent_aim_hitscan"] == "Torso" then
					Hitbox = Torso
				else
					local HeadPos = Camera:WorldToViewportPoint(Head.Position)

					local ScreenHeadPos = Vector2new(HeadPos.x, HeadPos.y)

					local HeadPosMagnitude = (ScreenHeadPos - SilentAim.Position).Magnitude
					
					Hitbox = HeadPosMagnitude < SilentAimMagnitude and Head or Torso
				end
				
				local ScreenMagnitude = (ScreenPos - (ScreenSize / 2)).Magnitude

				local HitboxPosition = Hitbox.Position + (Library.Flags["silent_aim_pred"] and Hitbox.Velocity * (LocalPlayer:GetNetworkPing() * 1.15) or Vector3zero)

				local Health = Utility:GetHealth(v)

				tableinsert(SilentAim.Targets, {
					["Player"] = v,
					["Health"] = Health,
					["Magnitude"] = ScreenMagnitude,
					["Distance"] = DistanceFromTorso,
					["Hitbox"] = Hitbox,
					["HitboxPosition"] = HitboxPosition,
					["Hitchance"] = mathrandom(1, 100)
				})
			end
		end
		
		-- "Screen", "Health", "Distance"
		if Library.flags["silent_aim_target_selection"] == "Screen" then
			tablesort(SilentAim.Targets, function(index1, index2)
                return index1.Magnitude < index2.Magnitude
			end)
  		elseif Library.flags["silent_aim_target_selection"] == "Health" then
			tablesort(SilentAim.Targets, function(index1, index2)
				return index1.Health < index2.Health
			end)
		elseif Library.flags["silent_aim_target_selection"] == "Distance" then
			tablesort(SilentAim.Targets, function(index1, index2)
				return index1.Distance < index2.Distance
			end)
		end

		SilentAim.Target = #SilentAim.Targets > 0 and SilentAim.Targets[1] or nil
	end))

	local OldBulletObject = BulletObject.new
	BulletObject.new = function(data)
		-- if not (Env.Moonlight and LPH_OBFUSCATED) then
		-- 	BulletObject.new = OldBulletObject
		-- end

		--if Env.Moonlight then
			local Target = Legitbot.SilentAim.Target

			if Target and Library.Flags["silent_aim_hitchance"] >= Target.Hitchance then
				local Weapon, WeaponController = Utility:GetLocalWeapon()

				if Weapon and Weapon._weaponData and Weapon._weaponData.bulletspeed then
					local Trajectory = Utility:Trajectory(data.position, -Gravity, Target.HitboxPosition, Weapon._weaponData.bulletspeed)

					if Trajectory then
						data.velocity = Trajectory
					end
				end
			end
		--end

		return OldBulletObject(data)
	end

	-- FOV Circles
	Library:Connect(RunService.Heartbeat, LPH_JIT_MAX(function() -- Aim Assist
		local AimbotFov = Aimbot.Circles.Fov
		local AimbotDeadzone = Aimbot.Circles.Deadzone

		if AimbotFov.Visible ~= (Library.Flags["aim_fov"] or false) then
			AimbotFov.Visible = Library.Flags["aim_fov"] or false
		end

		if AimbotFov.Visible then
			AimbotFov.Position = Aimbot.Position
			AimbotFov.Radius = Library.Flags["aim_assist_fov"]
			AimbotFov.Color = Library.Flags["aim_fov_color"]
			AimbotFov.Thickness = Library.Flags["aim_fov_thick"]
			AimbotFov.NumSides = Library.Flags["aim_fov_sides"]
		end
		
		if AimbotDeadzone.Visible ~= (Library.Flags["aim_dead"] or false) then
			AimbotDeadzone.Visible = Library.Flags["aim_dead"] or false
		end

		if AimbotDeadzone.Visible then
			AimbotDeadzone.Position = Aimbot.Position
			AimbotDeadzone.Radius = Library.Flags["aim_assist_deadzone"]
			AimbotDeadzone.Color = Library.Flags["aim_dead_color"]
			AimbotDeadzone.Thickness = Library.Flags["aim_dead_thick"]
			AimbotDeadzone.NumSides = Library.Flags["aim_dead_sides"]
		end

		local SilentAimFov = SilentAim.Circles.Fov
		local SilentAimDeadzone = SilentAim.Circles.Deadzone

		if SilentAimFov.Visible ~= (Library.Flags["silent_fov"] or false) then
			SilentAimFov.Visible = Library.Flags["silent_fov"] or false
		end

		if SilentAimFov.Visible then
			SilentAimFov.Position = SilentAim.Position
			SilentAimFov.Radius = Library.Flags["silent_aim_fov"]
			SilentAimFov.Color = Library.Flags["silent_fov_color"]
			SilentAimFov.Thickness = Library.Flags["silent_fov_thick"]
			SilentAimFov.NumSides = Library.Flags["silent_fov_sides"]
		end
		
		if SilentAimDeadzone.Visible ~= (Library.Flags["silent_dead"] or false) then
			SilentAimDeadzone.Visible = Library.Flags["silent_dead"] or false
		end

		if SilentAimDeadzone.Visible then
			SilentAimDeadzone.Position = SilentAim.Position
			SilentAimDeadzone.Radius = Library.Flags["silent_aim_deadzone"]
			SilentAimDeadzone.Color = Library.Flags["silent_dead_color"]
			SilentAimDeadzone.Thickness = Library.Flags["silent_dead_thick"]
			SilentAimDeadzone.NumSides = Library.Flags["silent_dead_sides"]
		end
	end))
	--

end --

-- Visuals
do
	for i = 1, 4 do
		local OutlineObj = Utility:New("Line", {
			Visible = false,
			Transparency = 1
		})
		local Obj = Utility:New("Line", {
			Visible = false,
			Transparency = 1
		})

		Visuals.CrosshairDrawings[i] = {
			Outline = OutlineObj,
			Fill = Obj
		}
	end

	function Visuals:ApplyChams(part, material, color, transparency, decal, reflectance)
		if part:IsA("BasePart") and part.Transparency < 1 then
			local Material = Visuals.Materials[material]
			local Texture = material == "ForceField" and Visuals.Textures[decal] or ""

            if part:FindFirstChildOfClass("SpecialMesh") then
                local Mesh = part:FindFirstChildOfClass("SpecialMesh")
                Mesh.TextureId = Texture
                Mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
            end

            if part:FindFirstChildOfClass("MeshPart") then
                local Mesh = part:FindFirstChildOfClass("MeshPart")
                Mesh.TextureId = Texture
                Mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
            end

			if part.ClassName == "UnionOperation" then
                part.UsePartColor = true
            end
    
            if part:FindFirstChild("SurfaceAppearance") then
                part.SurfaceAppearance:Destroy()
            end

			if part:IsA("MeshPart") then
                part.TextureID = Texture
            end

			part.Color = color
            part.Material = material
            part.Transparency = 1 - (transparency / 255)
			part.Reflectance = reflectance / 50
		end
	end

	function Visuals:RemoveTextures(part)
		for _,instance in next, part:GetChildren() do
            if instance:IsA("Texture") or instance:IsA("Decal") then
                instance:Destroy()
            end
        end
	end

	function Visuals:UpdateWeapon()
        local CameraChildren = Camera:GetChildren()

		if Library.Flags["gun_chams"] then
			for _,part in next, CameraChildren do
				if part.Name:lower():find("main") and #part:GetChildren() > 0 then
					Visuals:RemoveTextures(part)

					for _,childPart in next, part:GetChildren() do
						Visuals:ApplyChams(
							childPart, 
							Library.Flags["gun_chams_material"], 
							Library.Flags["gun_chams_color"], 
							Library.Flags["gun_chams_trans"], 
							Library.Flags["gun_chams_decal"], 
							Library.Flags["gun_chams_reflection"]
						)
					end
				end
			end
		end
    end

	function Visuals:UpdateArms()
        local CameraChildren = Camera:GetChildren()

		if Library.Flags["arm_chams"] then
			for _,part in next, CameraChildren do
				if not part.Name:lower():find("main") and #part:GetChildren() > 0 then
					Visuals:RemoveTextures(part)

					for _,childPart in next, part:GetChildren() do
						if childPart.Name == "Sleeves" then
							childPart:Destroy()
						else
							Visuals:ApplyChams(
								childPart, 
								Library.Flags["arm_chams_material"], 
								Library.Flags["arm_chams_color"], 
								Library.Flags["arm_chams_trans"], 
								Library.Flags["arm_chams_decal"], 
								Library.Flags["arm_chams_reflection"]
							)
						end
					end
				end
			end
		end
	end

	function Visuals:UpdateViewmodel()
		Visuals:UpdateWeapon()

		Visuals:UpdateArms()
	end

	local CrosshairAngle = 0
	local CrosshairPosition = Vector2zero
	function Visuals:UpdateCrosshair()
		if Library.Flags["crosshair"] then
			CrosshairAngle = CrosshairAngle + (Library.Flags["crosshair_spin_speed"] / 30)

			local Weapon, WeaponController = Utility:GetLocalWeapon()
	
			local CharacterObject = CharacterInterface.getCharacterObject()
			
			local ScopeValueSpring = 1 - mathclamp(CharacterObject and CharacterObject:getSpring("zoommodspring").p or 1, 0, 1)

			CrosshairPosition = Library.Flags["crosshair_pos"] == "Barrel" 
				and BarrelPosition 
				and Vector2new(
					Utility:Lerp(ScreenSize.x / 2, BarrelPosition.x, ScopeValueSpring),
					Utility:Lerp(ScreenSize.y / 2, BarrelPosition.y, ScopeValueSpring)
				)
				or ScreenSize / 2

			for _,v in next, Visuals.CrosshairDrawings do
				local Line = v.Fill
				local LineOutline = v.Outline

				if Line then
					local Color = Library.Flags["crosshair_color"]
					local Outline = Library.Flags["crosshair_outline"]
					local Size = Library.Flags["crosshair_size"]
					local Thickness = Library.Flags["crosshair_thick"]
					local Gap = Library.Flags["crosshair_gap"]

					Line.Color = Color
					Line.Thickness = Thickness
					Line.Visible = true

					LineOutline.Color = Outline
					LineOutline.Thickness = Thickness + 2
					LineOutline.Visible = true

					local Angle = _ * (360 / 4)
					local AnglePosition = Library.Flags["crosshair_spin"] and CrosshairAngle + Angle or Angle
                    local SinAngle = math.sin(math.rad(AnglePosition))
                    local CosAngle = math.cos(math.rad(AnglePosition))

					local AddValue = not BarrelPosition and (_ % 4 == 0 or _ == 1) and 1 or 0

					Line.From = CrosshairPosition + Vector2.new((Gap + AddValue) * CosAngle,(Gap + AddValue) * SinAngle)
                    Line.To = CrosshairPosition + Vector2.new(((Gap + AddValue) + Size) * CosAngle, ((Gap + AddValue) + Size) * SinAngle)
    
                    LineOutline.From = CrosshairPosition + Vector2.new(((Gap + AddValue) - 1) * CosAngle, ((Gap + AddValue) - 1) * SinAngle)
                    LineOutline.To = CrosshairPosition + Vector2.new(((Gap + AddValue) + Size + 1) * CosAngle, ((Gap + AddValue) + Size + 1) * SinAngle)
				end
			end
		else
			for _,v in next, Visuals.CrosshairDrawings do
				local Line = v.Fill
				local LineOutline = v.Outline

				Line.Visible = false
				LineOutline.Visible = false
			end
		end
	end

	function Visuals:CreateBulletTracer(origin, endpos, color, time, decal)
		if decal == "Drawing" then
			Utility:CreateDrawingTracer({
				Positions = {
					origin,
					endpos
				},
				Time = time,
				Color = color,
			})

			return
		end

		local Decal = Visuals.BulletTracers[decal] or "rbxassetid://446111271"

		local OriginAttachment = Utility:New("Attachment", {
			Position = origin,
			Parent = workspace.Terrain
		})

		local EndAttachment = Utility:New("Attachment", {
			Position = endpos,
			Parent = workspace.Terrain
		})
		
		local Beam = Utility:New("Beam", {
			Texture = Decal,
			LightEmission = 1,
            LightInfluence = 0,
			TextureSpeed = 10,
            Color = ColorSequence.new(color),
			Width0 = 1.2,
            Width1 = 1.2,
			Attachment0 = OriginAttachment,
			Attachment1 = EndAttachment,
			Enabled = true,
			Parent = workspace
		})

		Debris:AddItem(OriginAttachment, time)
		Debris:AddItem(EndAttachment, time)
		Debris:AddItem(Beam, time)
	end

	Library:Connect(Camera.ChildAdded, function()
		Visuals:UpdateViewmodel()
	end)

	Library:Connect(RunService.Heartbeat, LPH_JIT_MAX(function()
		Visuals:UpdateCrosshair()
		
		local CharacterObject = CharacterInterface.getCharacterObject()

        if Library.Flags["brightness"] and Lighting.Brightness ~= (Library.Flags["brightness"] * 2) / 100 then
            Lighting.Brightness = (Library.Flags["brightness"] * 2) / 100
        end	

		if Library.Flags["ambience"] then
			if Lighting.Ambient ~= Library.Flags["ambience_inside"] then
                Lighting.Ambient = Library.Flags["ambience_inside"]
            end

            if Lighting.OutdoorAmbient ~= Library.Flags["ambience_outside"] then
                Lighting.OutdoorAmbient = Library.Flags["ambience_outside"]
            end
		end

		if Library.Flags["skybox_changer"] and Library.Flags["skybox_changer"] ~= "Off" then
            local Sky = Lighting:FindFirstChildOfClass("Sky")
            if Sky then
                for _,v in next, Visuals.Skyboxes[Library.Flags["skybox_changer"]] do
                    if Sky[_] ~= v then
                        Sky[_] = v
                    end
                end
            else
                Instance.new("Sky", Lighting)
            end
        end
		
		if CharacterInterface.isAlive() then
			if Library.Flags["fov_changer"] then
				if CharacterObject.unaimedfov ~= Library.Flags["fov_changer_amount"] then
					CharacterObject.unaimedfov = Library.Flags["fov_changer_amount"]
				end
			end
		end
	end))

	local SpinX, SpinY, SpinZ = 0, 0, 0
	Utility:BindToRenderStep("Camera Visuals", 1, LPH_NO_VIRTUALIZE(function()
		local CharacterObject = CharacterInterface.getCharacterObject()

		if CharacterInterface.isAlive() then
			local Weapon, WeaponController = Utility:GetLocalWeapon()

			if Weapon and WeaponController then
				local MainOffset = Weapon:getWeaponStat("mainoffset")
				
				local ScopeValueSpring = 1 - mathclamp(CharacterObject and CharacterObject:getSpring("zoommodspring").p or 1, 0, 1)

				if Library.Flags["viewmodel"] then				
					local ViewmodelPosition = MainOffset * CFramenew(
						(Library.Flags["viewmodel_x"] / 2) * ScopeValueSpring,
						(Library.Flags["viewmodel_y"] / 2) * ScopeValueSpring,
						(Library.Flags["viewmodel_z"] / 2) * ScopeValueSpring
					) * CFrame.Angles(
						mathrad(Library.Flags["viewmodel_pitch"] * ScopeValueSpring),
						mathrad(Library.Flags["viewmodel_yaw"] * ScopeValueSpring),
						mathrad(Library.Flags["viewmodel_roll"] * ScopeValueSpring)
					)

					Weapon._mainOffset = ViewmodelPosition
				else
					Weapon._mainOffset = MainOffset
				end

				local Motor = Weapon._mainWeld
				if Motor then
					if Library.Flags["spin"] then
						SpinX += Library.Flags["spin_x"] / 20
						SpinY += Library.Flags["spin_y"] / 20
						SpinZ += Library.Flags["spin_z"] / 20

						local Angle = CFrame.Angles(
							Utility:Lerp(0, Library.Flags["spin_x"] ~= 0 and SpinX or 0, ScopeValueSpring),
							Utility:Lerp(0, Library.Flags["spin_y"] ~= 0 and SpinY or 0, ScopeValueSpring),
							Utility:Lerp(0, Library.Flags["spin_z"] ~= 0 and SpinZ or 0, ScopeValueSpring)
						)

						Motor.C1 = Angle
					else
						if Motor.C1 ~= CFrame.Angles(0, 0, 0) then
							Motor.C1 = CFrame.Angles(0, 0, 0)
						end
					end
				end
			end
		end
	end))

	-- Visuals Hooks

	--Camera Stuff
	local OldCameraSway = CameraObject.setSway
	CameraObject.setSway = LPH_NO_VIRTUALIZE(function(idk, amount)
		-- 							 				   ^ wtf is this argument LOL

		if Library.Flags["remove_sway"] then
			amount = 0
		end

		return OldCameraSway(idk, amount)
	end)

	local OldCameraDelta = CameraObject.getDelta
	CameraObject.getDelta = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["remove_sway"] then
            return CFramenew()
        end

        return OldCameraDelta(...)
    end)

	local OldCameraShake = CameraObject.getShake
	CameraObject.getShake = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["remove_sway"] then
            return CFramenew()
        end

        return OldCameraShake(...)
    end)

	local OldCameraImpulse = CameraObject.applyImpulse
	CameraObject.applyImpulse = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["remove_shake"] then
            return
        end

        return OldCameraImpulse(...)
    end)
	
	--
	

	-- Firearm Stuff
	local OldWeaponAnim = FirearmObject.getAnimLength
	FirearmObject.getAnimLength = LPH_NO_VIRTUALIZE(function(weapon, anim, ...)

        if anim == "onfire" and Library.Flags["firerate"] then
            return 0
        end


        return OldWeaponAnim(weapon, anim, ...)
    end)

	local OldWeaponAim = FirearmObject.getActiveAimStat
    FirearmObject.getActiveAimStat = LPH_NO_VIRTUALIZE(function(weapon, stat, value, ...)     
        if table.find({"firerate", "burstfirerate"}, stat) and Library.Flags["firerate"] then
            local FireRate = OldWeaponAim(weapon, stat, value, ...)

            if type(FireRate) == "table" then
                setreadonly(FireRate, false)

                for _,v in next, FireRate do
                    FireRate[_] = v * (Library.Flags["firerate_amount"] / 100)
                end
            else
                FireRate = FireRate * (Library.Flags["firerate_amount"] / 100)
            end

            return FireRate
        end

        return OldWeaponAim(weapon, stat, value, ...)
    end)

	local OldWeaponStat = FirearmObject.getWeaponStat
	FirearmObject.getWeaponStat = LPH_NO_VIRTUALIZE(function(weapon, stat, ...)
		if (stat == "pullout" or stat == "unequiptime" or stat == "equiptime") and Library.Flags["instant_equip"] then
			return 0
		elseif stat == "animations" then
			local ReturnAnimations = OldWeaponStat(weapon, stat, ...)

			if Library.Flags["instant_reload"] then
				for _,v in next, {"reload", "tacticalreload"} do
					local Anim = ReturnAnimations[v]

					if Anim then
						setreadonly(Anim, false)

						Anim.timescale = 0
						Anim.stdtimescale = 0

						if Anim.resettime then Anim.resettime = 0 end
					end
				end
			end

			return ReturnAnimations
		elseif stat == "firemodes" and Library.Flags["automatic"] then
			return {true, true, true}
		end

		return OldWeaponStat(weapon, stat, ...)
	end)

	local OldGunSway = FirearmObject.gunSway
    FirearmObject.gunSway = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["remove_sway"] then
            return CFramenew()
        end

        return OldGunSway(...)
    end)

	local OldGunWalkSway = FirearmObject.walkSway
    FirearmObject.walkSway = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["remove_bob"] then
            return CFramenew()
        end

        return OldGunWalkSway(...)
    end)

	local OldGunSprings = FirearmObject.impulseSprings
    FirearmObject.impulseSprings = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["recoil"] then
			local Index8 = debug.getconstant(OldGunSprings, 8)

			if type(Index8) == "number" and Index8 ~= Library.Flags["recoil_amount"] / 100 then				
				debug.setconstant(OldGunSprings, 8, Library.Flags["recoil_amount"] / 100)
			end
        end

        return OldGunSprings(...)
    end)
	--

	-- Melee Stuff
	local OldMeleeStat = MeleeObject.getWeaponStat
	MeleeObject.getWeaponStat = LPH_NO_VIRTUALIZE(function(weapon, stat, ...)
		if (stat == "pullout" or stat == "unequiptime" or stat == "equiptime") and Library.Flags["instant_equip"] then
			return 0
		end

		return OldMeleeStat(weapon, stat, ...)
	end)


	local OldMeleeSway = MeleeObject.meleeSway
    MeleeObject.meleeSway = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["remove_sway"] then
            return CFramenew()
        end

        return OldMeleeSway(...)
    end)

	local OldMeleeWalkSway = MeleeObject.walkSway
    MeleeObject.walkSway = LPH_NO_VIRTUALIZE(function(...)
        if Library.Flags["remove_bob"] then
            return CFramenew()
        end

        return OldMeleeWalkSway(...)
    end)
	--
	
end --

-- Misc
do
	Library:Connect(RunService.RenderStepped, LPH_JIT_MAX(function()
		local CharacterObject = CharacterInterface.getCharacterObject() or nil
        local Humanoid = CharacterObject and CharacterObject._humanoid
        local HumanoidRootPart = CharacterObject and CharacterObject._rootPart
		local Looking = Camera.CFrame.lookVector

		if Humanoid and HumanoidRootPart then
            if Library.Flags["auto_jump"] and Misc.AutoJumpKey and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                Humanoid.Jump = true
            end

			local Velocity = Vector3zero

			local CanSpeedHack = 
				Library.Flags["speed_type"] == "In Air" 
					and Humanoid.FloorMaterial ~= Enum.Material.Air 
					and not Humanoid.Jump 
				or
				Library.Flags["speed_type"] == "On Hop"
					and Humanoid.Jump
				or 
				Library.Flags["speed_type"] == "Always"
			
			if Library.Flags["fly"] and CanSpeedHack then
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					Velocity += Looking
				end
	
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					Velocity -= Looking
				end
	
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					Velocity += Vector3new(-Looking.z, 0, Looking.x)
				end
	
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					Velocity += Vector3new(Looking.z, 0, -Looking.x)
				end
	
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					Velocity += Vector3new(0, 1, 0)
				end
	
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					Velocity -= Vector3new(0, 1, 0)
				end

				if Velocity.Magnitude > 0 then
					HumanoidRootPart.Anchored = false
					HumanoidRootPart.Velocity = Velocity.Unit * Library.Flags["fly_speed"]
				else
					HumanoidRootPart.Anchored = true
					HumanoidRootPart.Velocity = Vector3zero
				end
			else
				HumanoidRootPart.Anchored = false
				
				if Library.Flags["speed"] and CanSpeedHack then
					if UserInputService:IsKeyDown(Enum.KeyCode.W) then
						Velocity += Vector3new(Looking.x, 0, Looking.z)
					end
		
					if UserInputService:IsKeyDown(Enum.KeyCode.S) then
						Velocity -= Vector3new(Looking.x, 0, Looking.z)
					end
					
					if UserInputService:IsKeyDown(Enum.KeyCode.D) then
						Velocity += Vector3new(-Looking.z, 0, Looking.x)
					end
		
					if UserInputService:IsKeyDown(Enum.KeyCode.A) then
						Velocity += Vector3new(Looking.z, 0, -Looking.x)
					end

					if Velocity.Magnitude > 0 then
						Velocity = Velocity.Unit * Library.Flags["speed_speed"]

						Velocity = Vector3new(Velocity.x, HumanoidRootPart.Velocity.y, Velocity.z)

						HumanoidRootPart.Velocity = Velocity
					end
				end
			end
		end
	end))

	taskspawn(function()
		while taskwait(1) do
			if Misc.VoteKicked then
				LocalPlayer:Kick("Moonlight - Joining a new server")

				local Servers = HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
			
				while taskwait() do
					for Index = #Servers.data, 1, -1 do
						local Value = Servers.data[Index]

						if Value.playing ~= nil and Value.playing < Value.maxPlayers and Value.playing > 8 and Value.id ~= game.JobId then
							TeleportService:TeleportToPlaceInstance(game.PlaceId, Value.id)
							break
						end
					end     
				end
			end
		end
	end)
end

-- Network Handler
do
	Network:Connect(function(command, ...)
		local Args = {...}

		if command == "newbullets" then
			local Target = Legitbot.SilentAim.Target

			if Target and Library.Flags["silent_aim_hitchance"] >= Target.Hitchance then
				local Weapon, WeaponController = Utility:GetLocalWeapon()

				if Weapon and WeaponController then
					local Trajectory = Utility:Trajectory(Args[2].firepos, -Gravity, Target.HitboxPosition, Weapon._weaponData.bulletspeed)

					for i = 1, #Args[2].bullets do
						Args[2].bullets[i][1] = Trajectory
					end
				end
			end

			if Library.Flags["l_bullet_tracers"] then
				for i = 1, #Args[2].bullets do
					local Bullet = Args[2].bullets[i]
					local Origin = Args[2].firepos
					local End = Origin + (type(Bullet[1]) == "table" and Bullet[1].unit.Unit or Bullet[1].Unit) * 300

					Visuals:CreateBulletTracer(
						Origin,
						End,
						Library.Flags["l_bullet_tracers_color"],
						Library.Flags["l_bullet_tracers_time"],
						Library.Flags["l_bullet_tracers_texture"]
					)
				end
			end
		elseif command == "bullethit" then
			if Library.Flags["hitsound_enabled"] then
				Utility:PlaySound(Library.Flags["hitsound_id"], Library.Flags["hitsound_volume"], Library.Flags["hitsound_pitch"])
			end
		elseif command == "falldamage" and Library.Flags["fall_damage"] then
			return
		elseif command == "debug" then
			if Library.Flags["server_hop"] and Args[#Args]:find("kick") then
				Misc.VoteKicked = true
			end
		elseif command == "repupdate" then
			-- if getgenv().repstop and not Args[4] then
			-- 	return
			-- end

			if Library.Flags["bypass_speed"] then
				Network.Shift += 1 / 30
			end
		end

		local IsDependant = Network.ClockDependant[command]

		if IsDependant and Library.Flags then
			Args[IsDependant] += Network.Shift or 0
		end

		return Args
	end)

	Library:Connect(RemoteEvent.OnClientEvent, function(command, ...)
		local Args = {...}

		if command == "died" then
			if Args[1].attacker == LocalPlayer then
				if Library.Flags["killsound_enabled"] then
					Utility:PlaySound(Library.Flags["killsound_id"], Library.Flags["killsound_volume"], Library.Flags["killsound_pitch"])
				end
			end
		end
	end)
end
--

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

		return Library.Flags["esp_highlight_target"] and (Legitbot.Aimbot.Target == player or Legitbot.SilentAim.Target and Legitbot.SilentAim.Target.Player == player) and Library.Flags["esp_highlight_target_color"] or Library.Flags["esp_highlight_friend"] and Library.Playerlist:IsTagged(player, "Friended") and Library.Flags["esp_highlight_friend_color"] or Library.Flags["esp_highlight_priority"] and Library.Playerlist:IsTagged(player, "Prioritized") and Library.Flags["esp_highlight_priority_color"] or nil
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

		--ESP_P.Loop:Disconnect()

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
	local RageTab = Window:Tab("Rage")
	local PlayersTab = Window:Tab("Players")
	local VisualsTab = Window:Tab("Visuals")
	local MiscTab = Window:Tab("Misc")
	--

	-- Toggles
	local AimAssist = LegitTab:Section({ name = "Aim Assist", side = "left" })
	AimAssist:Toggle({ name = "Aim Assist", flag = "aim_assist_enabled" })
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

	local BulletRedirection = LegitTab:Section({ name = "Bullet Redirection", side = "middle" })
	BulletRedirection:Toggle({ name = "Silent Aim", flag = "silent_aim_enabled" })
		:Keybind({ name = "Silent Aim", listignored = false, mode = "toggle", blacklist = {}, flag = "silent_aim_key" })
	BulletRedirection:Toggle({ name = "Visible Check", flag = "silent_aim_visible_check" })
	BulletRedirection:Toggle({ name = "Predict Velocity", flag = "silent_aim_pred" })
	BulletRedirection:Slider({ name = "Field of View", default = 70, float = 1, suffix = "°", min = 1, max = 360, flag = "silent_aim_fov" })
	BulletRedirection:Slider({ name = "Deadzone", default = 5, float = 1, suffix = "°", min = 0, max = 50, flag = "silent_aim_deadzone" })
	BulletRedirection:Toggle({ name = "Limit Distance", flag = "silent_aim_limit" })
	BulletRedirection:Slider({ name = "Maximum Distance", default = 300, float = 1, suffix = " studs", min = 0, max = 5000, flag = "silent_aim_max_distance" })
	BulletRedirection:Slider({ name = "Hitchance", default = 80, float = 1, suffix = "%", min = 1, max = 100, flag = "silent_aim_hitchance" })
	BulletRedirection:Dropdown({ name = "Target Selection", content = { "Screen", "Health", "Distance" }, multi = false, flag = "silent_aim_target_selection" })
		:Set("Screen")
	BulletRedirection:Dropdown({ name = "Hitscan", content = { "Head", "Torso", "Closest" }, multi = false, flag = "silent_aim_hitscan" })
		:Set("Head")
	BulletRedirection:Dropdown({ name = "Hitscan Position", content = { "Screen", "Barrel" }, multi = false, flag = "silent_aim_hitscan_pos" })
		:Set("Screen")

	-- local TriggerbotSection = LegitTab:Section({ name = "Triggerbot", side = "right" })
	-- TriggerbotSection:Toggle({ name = "Enabled", flag = "triggerbot_enabled" })
	-- TriggerbotSection:Toggle({ name = "Visible Check", flag = "triggerbot_visible_check" })
	-- -- TriggerbotSection:Toggle({ name = "Team Check", flag = "triggerbot_team_check" })
	-- TriggerbotSection:Separator()
	-- TriggerbotSection:Slider({ name = "Delay", default = 120, float = 1, suffix = "ms", min = 0, max = 1000, flag = "triggerbot_delay" })
	-- TriggerbotSection:Dropdown({ name = "Hitscan", content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "triggerbot_hitscan" }) ]]
	
	local Ragebot = RageTab:Section({ name = "Rage Bot", side = "left" })
	Ragebot:Toggle({ name = "Rage Bot", flag = "ragebot" })
		:Keybind({ name = "Rage Bot", listignored = false, mode = "toggle", blacklist = {}, flag = "ragebot_key" })
	Ragebot:Toggle({ name = "Fire Position Scanning", flag = "rage_fire_pos" })
	Ragebot:Slider({ name = "Radius", default = 6, float = 0.1, suffix = " studs", min = 1, max = 12, flag = "rage_fire_pos_amount" })
	Ragebot:Toggle({ name = "Hitbox Shifting", flag = "rage_hitbox" })
	Ragebot:Slider({ name = "Radius", default = 6, float = 0.1, suffix = " studs", min = 1, max = 10, flag = "rage_hitbox_amount" })
	

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
		ESP:Toggle({ name = "Enabled", flag = v.Flag .. "enabled" })
		local BoxESP = ESP:Toggle({ name = "Box", flag = v.Flag .. "box" })
			BoxESP:Colorpicker({ name = "Box Color", default = Color3fromRGB(255, 0, 0), flag = v.Flag .. "box_color"})
			BoxESP:Colorpicker({ name = "Box Outline Color", default = Color3fromRGB(0, 0, 0), flag = v.Flag .. "box_outline"})
		ESP:Toggle({ name = "Box Fill", flag = v.Flag .. "box_fill" })
			:Colorpicker({ name = "Box Fill Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "box_fill_color"})
		ESP:Slider({ name = "Box Fill Transparency", default = 0, float = 1, min = 1, max = 255, flag = v.Flag .. "box_fill_a" })
		ESP:Toggle({ name = "Name", flag = v.Flag .. "name" })
			:Colorpicker({ name = "Name Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "name_color"})
		local HealthBar = ESP:Toggle({ name = "Health Bar", flag = v.Flag .. "health" })
			HealthBar:Colorpicker({ name = "Health Bar Color", default = Color3fromRGB(0, 255, 0), flag = v.Flag .. "health_color"})
			HealthBar:Colorpicker({ name = "Health Bar Outline Color", default = Color3fromRGB(0, 0, 0), flag = v.Flag .. "health_outline"})
		ESP:Toggle({ name = "Health Number", flag = v.Flag .. "health_number" })
			:Colorpicker({ name = "Health Number Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "health_number_color"})
		ESP:Toggle({ name = "Follow Health Bar", flag = v.Flag .. "health_number_follow" })
		ESP:Toggle({ name = "Distance", flag = v.Flag .. "distance" })
			:Colorpicker({ name = "Distance Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "distance_color"})
		ESP:Toggle({ name = "Weapon", flag = v.Flag .. "weapon" })
			:Colorpicker({ name = "Weapon Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "weapon_color"})
		ESP:Toggle({ name = "Rank", flag = v.Flag .. "rank" })
			:Colorpicker({ name = "Rank Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "rank_color"})
		ESP:Toggle({ name = "Team", flag = v.Flag .. "team" })
			:Colorpicker({ name = "Team Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "team_color"})
		ESP:Toggle({ name = "Use Team Color", flag = v.Flag .. "team_use_color" })
		ESP:Toggle({ name = "Out of View", flag = v.Flag .. "oof" })
			:Colorpicker({ name = "Out of View Color", default = Color3fromRGB(255, 255, 255), flag = v.Flag .. "oof_color"})
		ESP:Slider({ name = "Out of View Size", default = 13, float = 1, suffix = " px", min = 1, max = 30, flag = v.Flag .. "oof_size" })
		ESP:Slider({ name = "Out of View Distance", default = 250, float = 1, suffix = " px", min = 1, max = 1920, flag = v.Flag .. "oof_distance" })
		local Chams = ESP:Toggle({ name = "Chams", flag = v.Flag .. "chams" })
			Chams:Colorpicker({ name = "Chams Color", default = Color3fromRGB(0, 187, 255), flag = v.Flag .. "chams_color"})
			Chams:Colorpicker({ name = "Chams Outline Color", default = Color3fromRGB(0, 145, 255), flag = v.Flag .. "chams_outline"})
		ESP:Slider({ name = "Chams Transparency", default = 200, float = 1, min = 1, max = 255, flag = v.Flag .. "chams_a" })
		ESP:Slider({ name = "Chams Outline Transparency", default = 255, float = 1, min = 1, max = 255, flag = v.Flag .. "chams_outline_a" })
	end

	local ESPSettings = PlayersTab:Section({ name = "ESP Settings", side = "right" })
	ESPSettings:Toggle({ name = "Limit Distance", flag = "esp_limit_distance" })
	ESPSettings:Slider({ name = "Maximum Distance", default = 300, float = 1, suffix = " studs", min = 1, max = 5000, flag = "esp_limit_distance_amount" })
	ESPSettings:Dropdown({ name = "ESP Font", content = { "Plex", "Monospace", "UI", "System" }, multi = false, flag = "esp_font" })
		:Set("Plex")
	ESPSettings:Slider({ name = "ESP Size", default = 14, float = 1, suffix = " px", min = 1, max = 30, flag = "esp_font_size" })
	ESPSettings:Slider({ name = "Max HP Visibility Cap", default = 90, float = 1, suffix = " hp", min = 1, max = 100, flag = "max_hp_vis_cap" })
	ESPSettings:Toggle({ name = "Highlight Target", flag = "esp_highlight_target" })
		:Colorpicker({ name = "Highlight Target Color", default = Color3fromRGB(255, 0, 0), flag = "esp_highlight_target_color"})
	ESPSettings:Toggle({ name = "Highlight Friend", flag = "esp_highlight_friend" })
		:Colorpicker({ name = "Highlight Friend Color", default = Color3fromRGB(0, 166, 255), flag = "esp_highlight_friend_color"})
	ESPSettings:Toggle({ name = "Highlight Priority", flag = "esp_highlight_priority" })
		:Colorpicker({ name = "Highlight Priority Color", default = Color3fromRGB(0, 255, 157), flag = "esp_highlight_priority_color"})

	local Interface, Circles = VisualsTab:multiSection({ Side = "Right", Sections = { "Interface", "Circles" } })

	Circles:Toggle({ name = "Aimbot FOV", flag = "aim_fov" })
		:Colorpicker({ name = "Aimbot FOV Color", default = Color3fromRGB(255, 255, 255), flag = "aim_fov_color"})
	Circles:Slider({ name = "Thickness", default = 1, float = 1, suffix = " px", min = 1, max = 30, flag = "aim_fov_thick" })
	Circles:Slider({ name = "Num Sides", default = 30, float = 1, suffix = " sides", min = 1, max = 100, flag = "aim_fov_sides" })
	Circles:Toggle({ name = "Aimbot Deadzone", flag = "aim_dead" })
		:Colorpicker({ name = "Aimbot Deadzone Color", default = Color3fromRGB(255, 255, 255), flag = "aim_dead_color"})
	Circles:Slider({ name = "Thickness", default = 1, float = 1, suffix = " px", min = 1, max = 30, flag = "aim_dead_thick" })
	Circles:Slider({ name = "Num Sides", default = 30, float = 1, suffix = " sides", min = 1, max = 100, flag = "aim_dead_sides" })
	Circles:Toggle({ name = "Silent Aim FOV", flag = "silent_fov" })
		:Colorpicker({ name = "Silent Aim FOV Color", default = Color3fromRGB(255, 255, 255), flag = "silent_fov_color"})
	Circles:Slider({ name = "Thickness", default = 1, float = 1, suffix = " px", min = 1, max = 30, flag = "silent_fov_thick" })
	Circles:Slider({ name = "Num Sides", default = 30, float = 1, suffix = " sides", min = 1, max = 100, flag = "silent_fov_sides" })
	Circles:Toggle({ name = "Silent Aim Deadzone", flag = "silent_dead" })
		:Colorpicker({ name = "Silent Aim Deadzone Color", default = Color3fromRGB(255, 255, 255), flag = "silent_dead_color"})
	Circles:Slider({ name = "Thickness", default = 1, float = 1, suffix = " px", min = 1, max = 30, flag = "silent_dead_thick" })
	Circles:Slider({ name = "Num Sides", default = 30, float = 1, suffix = " sides", min = 1, max = 100, flag = "silent_dead_sides" })
	
	local Crosshair = Interface:Toggle({ name = "Custom Crosshair", flag = "crosshair" })
		Crosshair:Colorpicker({ name = "Crosshair Color", default = Color3fromRGB(255, 255, 255), flag = "crosshair_color"})
		Crosshair:Colorpicker({ name = "Crosshair Outline", default = Color3fromRGB(0, 0, 0), flag = "crosshair_outline"})
	Interface:Dropdown({ name = "Crosshair Position", content = { "Screen", "Barrel" }, multi = false, flag = "crosshair_pos" })
		:Set("Screen")
	Interface:Toggle({ name = "Spin Crosshair", flag = "crosshair_spin" })
	Interface:Slider({ name = "Spin Speed", default = 5, float = 1, min = 1, max = 50, flag = "crosshair_spin_speed" })
	Interface:Slider({ name = "Thickness", default = 1, float = 1, suffix = " px", min = 1, max = 30, flag = "crosshair_thick" })
	Interface:Slider({ name = "Size", default = 5, float = 1, suffix = " px", min = 1, max = 30, flag = "crosshair_size" })
	Interface:Slider({ name = "Gap", default = 5, float = 1, suffix = " px", min = 1, max = 30, flag = "crosshair_gap" })

	local CameraVisuals = VisualsTab:Section({ name = "Local", side = "middle" })
	CameraVisuals:Toggle({ name = "Fov Changer", flag = "fov_changer" })
	CameraVisuals:Slider({ name = "Fov Amount", default = 90, suffix = "°", float = 1, min = 1, max = 120, flag = "fov_changer_amount" })
	CameraVisuals:Toggle({ name = "Remove Viewmodel Bob", flag = "remove_bob", callback = function(v)
		debug.setconstant(CameraObject.step, 22, v and 0 or 0.5)
	end})
	CameraVisuals:Toggle({ name = "Remove Viewmodel Sway", flag = "remove_sway" })
	CameraVisuals:Toggle({ name = "Remove Camera Shake", flag = "remove_shake" })
	CameraVisuals:Toggle({ name = "Viewmodel Changer", flag = "viewmodel" })
	CameraVisuals:Slider({ name = "X Position", default = 0, float = 0.1, suffix = " studs", min = -5, max = 5, flag = "viewmodel_x" })
	CameraVisuals:Slider({ name = "Y Position", default = 0, float = 0.1, suffix = " studs", min = -5, max = 5, flag = "viewmodel_y" })
	CameraVisuals:Slider({ name = "Z Position", default = 0, float = 0.1, suffix = " studs", min = -5, max = 5, flag = "viewmodel_z" })
	CameraVisuals:Slider({ name = "Pitch Position", default = 0, float = 1, suffix = "°", min = -180, max = 180, flag = "viewmodel_pitch" })
	CameraVisuals:Slider({ name = "Yaw Position", default = 0, float = 1, suffix = "°", min = -180, max = 180, flag = "viewmodel_yaw" })
	CameraVisuals:Slider({ name = "Roll Position", default = 0, float = 1, suffix = "°", min = -180, max = 180, flag = "viewmodel_roll" })
	CameraVisuals:Toggle({ name = "Weapon Spin", flag = "spin" })
	CameraVisuals:Slider({ name = "Pitch Position", default = 0, float = 0.1, suffix = "°", min = -5, max = 5, flag = "spin_x" })
	CameraVisuals:Slider({ name = "Yaw Position", default = 0, float = 0.1, suffix = "°", min = -5, max = 5, flag = "spin_y" })
	CameraVisuals:Slider({ name = "Roll Position", default = 0, float = 0.1, suffix = "°", min = -5, max = 5, flag = "spin_z" })

	local Materials = {}

	for _,v in next, Visuals.Materials do
		Materials[#Materials + 1] = _
	end

	local Textures = {"Off"}
	for _,v in next, Visuals.Textures do
		Textures[#Textures + 1] = _
	end


	local Local, World = VisualsTab:multiSection({ Side = "left", Sections = { "Local", "World" } })

	Local:Toggle({ name = "Gun Chams", flag = "gun_chams", callback = function() Visuals:UpdateWeapon() end })
		:Colorpicker({ name = "Gun Chams Color", default = Color3fromRGB(255, 255, 255), flag = "gun_chams_color", callback = function() Visuals:UpdateWeapon() end})
	Local:Dropdown({ name = "Gun Chams Material", content = Materials, multi = false, flag = "gun_chams_material", callback = function() Visuals:UpdateWeapon() end })
		:Set("ForceField")
	Local:Slider({ name = "Reflection", default = 1, float = 1, min = 1, max = 50, flag = "gun_chams_reflection", callback = function() Visuals:UpdateWeapon() end })
	Local:Slider({ name = "Transparency", default = 100, float = 1, min = 1, max = 255, flag = "gun_chams_trans", callback = function() Visuals:UpdateWeapon() end })
	Local:Dropdown({ name = "Texture", content = Textures, multi = false, flag = "gun_chams_decal", callback = function() Visuals:UpdateWeapon() end })
		:Set("Off")

	Local:Toggle({ name = "Arm Chams", flag = "arm_chams", callback = function() Visuals:UpdateArms() end })
		:Colorpicker({ name = "Arm Chams Color", default = Color3fromRGB(255, 255, 255), flag = "arm_chams_color", callback = function() Visuals:UpdateArms() end})
	Local:Dropdown({ name = "Arm Chams Material", content = Materials, multi = false, flag = "arm_chams_material", callback = function() Visuals:UpdateArms() end })
		:Set("ForceField")
	Local:Slider({ name = "Reflection", default = 1, float = 1, min = 1, max = 50, flag = "arm_chams_reflection", callback = function() Visuals:UpdateArms() end })
	Local:Slider({ name = "Transparency", default = 100, float = 1, min = 1, max = 255, flag = "arm_chams_trans", callback = function() Visuals:UpdateArms() end })
	Local:Dropdown({ name = "Texture", content = Textures, multi = false, flag = "arm_chams_decal", callback = function() Visuals:UpdateArms() end })
		:Set("Off")

	World:Toggle({ name = "Set Time", flag = "time_changer" })
	World:Slider({ name = "Time Amount", default = 12, float = 0.1, min = 0, max = 24, flag = "time_changer_amount" })
	local Ambience = World:Toggle({ name = "Ambience", flag = "ambience" })
		Ambience:Colorpicker({ name = "Ambience Inside Color", default = Color3fromRGB(255, 255, 255), flag = "ambience_inside"})
		Ambience:Colorpicker({ name = "Ambience Outside Color", default = Color3fromRGB(255, 255, 255), flag = "ambience_outside"})
	World:Slider({ name = "Brightness", default = 50, float = 1, min = 0, max = 100, flag = "brightness" })
	World:Dropdown({ name = "Technology Type", content = {"Legacy", "Voxel", "Compatibility", "ShadowMap", "Future"}, multi = false, flag = "technology_type", callback = function(v)
		if v then
			sethiddenproperty(Lighting, "Technology", Enum.Technology[v])
		end
	end}):Set("Legacy")
	
	local Skyboxes = { "Off" }
	for _,v in next, Visuals.Skyboxes do
		Skyboxes[#Skyboxes + 1] = _
	end
	
	World:Dropdown({ name = "Skybox Changer", content = Skyboxes, multi = false, flag = "skybox_changer"})
		:Set("Off")

		
	local BulletTracers = {}
	for _,v in next, Visuals.BulletTracers do
		BulletTracers[#BulletTracers + 1] = _
	end

	World:Toggle({ name = "Local Bullet Tracers", flag = "l_bullet_tracers" })
		:Colorpicker({ name = "Local Bullet Tracers Color", default = Color3fromRGB(255, 255, 255), flag = "l_bullet_tracers_color"})
	World:Dropdown({ name = "Texture", content = BulletTracers, multi = false, flag = "l_bullet_tracers_texture" })
		:Set("Default")
	World:Slider({ name = "Time", default = 3, float = 1, min = 1, max = 20, flag = "l_bullet_tracers_time" })

	local Movement = MiscTab:Section({ name = "Movement", side = "left" })
	Movement:Toggle({ name = "Fly", flag = "fly" })
		:Keybind({ name = "Fly", listignored = false, mode = "toggle", blacklist = {}, flag = "fly_key" })
	Movement:Slider({ name = "Fly Speed", default = 50, float = 1, min = 1, max = 100, flag = "fly_speed" })
	Movement:Toggle({ name = "Auto Jump", flag = "auto_jump" })
		:Keybind({ name = "Auto Jump", listignored = false, mode = "hold", blacklist = {}, flag = "auto_jump_key" })
	Movement:Toggle({ name = "Speed", flag = "speed" })
		:Keybind({ name = "Speed", listignored = false, mode = "toggle", blacklist = {}, flag = "speed_key" })
	Movement:Dropdown({ name = "Speed Type", content = {"Always", "In Air", "On Hop"}, multi = false, flag = "speed_type"})
		:Set("Always")
	Movement:Slider({ name = "Speed Factor", default = 50, float = 1, min = 1, max = 300, flag = "speed_speed" })
	Movement:Toggle({ name = "Bypass Fall Damage", flag = "fall_damage" })
	Movement:Toggle({ name = "Bypass Speed Checks", flag = "bypass_speed" })

	local GunMods = MiscTab:Section({ name = "Gun Modifications", side = "middle" })
	GunMods:Toggle({ name = "Change Recoil", flag = "recoil" })
	GunMods:Slider({ name = "Recoil Factor", default = 100, float = 1, min = 0, max = 100, flag = "recoil_amount" })
	GunMods:Toggle({ name = "Change Firerate", flag = "firerate" })
	GunMods:Slider({ name = "Firerate Scale", default = 100, float = 1, min = 100, max = 1000, flag = "firerate_amount" })
	GunMods:Toggle({ name = "Instant Equip", flag = "instant_equip" })
	GunMods:Toggle({ name = "Instant Reload", flag = "instant_reload" })
	GunMods:Toggle({ name = "Set Weapon To Automatic", flag = "automatic" })

	local Extra = MiscTab:Section({ name = "Extra", side = "right" })
	Extra:Toggle({ name = "Hit Sound", flag = "hitsound_enabled" })
	Extra:Slider({ name = "Volume", default = 50, float = 1, min = 0, max = 100, flag = "hitsound_volume" })
	Extra:Slider({ name = "Pitch", default = 100, float = 1, min = 0, max = 200, flag = "hitsound_pitch" })
	Extra:Box({ name = "Hit Sound ID", default = "6229978482", flag = "hitsound_id", clearonfocus = false })
	Extra:Toggle({ name = "Kill Sound", flag = "killsound_enabled" })
	Extra:Slider({ name = "Volume", default = 50, float = 1, min = 0, max = 100, flag = "killsound_volume" })
	Extra:Slider({ name = "Pitch", default = 100, float = 1, min = 0, max = 200, flag = "killsound_pitch" })
	Extra:Box({ name = "Kill Sound ID", default = "5709456554", flag = "killsound_id", clearonfocus = false })
	Extra:Toggle({ name = "Join New Game On Votekick", flag = "server_hop" })

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
