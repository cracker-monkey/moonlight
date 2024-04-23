local Libraries = Moonlight.Libraries
local Utility = Libraries.Utility
local Modules = Libraries.Modules
local Visuals = Libraries.Visuals
local Network = Libraries.Network
local Library = Libraries.Library
local ESP = Libraries.ESP
local Legitbot = Libraries.Legitbot


local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

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

-- Variables
local LoadTimeTick = os.clock()
local Camera = Workspace.CurrentCamera
local ScreenSize = Camera.ViewportSize
local LocalPlayer = Players.LocalPlayer
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

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist
RayParams.FilterDescendantsInstances = Ignores

local Gravity = Vector3new(0, workspace.Gravity, 0)

if getgenv().rageloop then
    getgenv().rageloop:Disconnect()
end


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
    LastHit = os.clock(),
    Target = nil,
    LastTeleport = os.clock(),
    Teleporting = false,
	Shots = {},
    Index = 0,
}

do	
	function Ragebot:LogShot(player, damage, time, tick)
		Ragebot.Shots[player] = {
			Damage = damage,
			Time = time,
			Tick = tick
		}
	end
	function Ragebot:GetShotInfo(player)
		return Ragebot.Shots[player] or nil
	end
    function Ragebot:ClearShotInfo(player)
        Ragebot.Shots[player] = nil
    end
	function Ragebot:GetDamage(Weapon, Distance, Hitbox)
		local DamageGraphs = Weapon:getWeaponStat("damageGraph") 

		if not DamageGraphs then 
			return 0 
		end
		for currentIndex = 1, #DamageGraphs do
			local dataPoint = DamageGraphs[currentIndex]

			if dataPoint.distance >= Distance then
				local prevIndex = currentIndex - 1
				local prevDataPoint = DamageGraphs[prevIndex]

				if prevDataPoint then
					local distanceRatio = (Distance - prevDataPoint.distance)
						/ (dataPoint.distance - prevDataPoint.distance)
					return (1 - distanceRatio) * prevDataPoint.damage + distanceRatio * dataPoint.damage
				end

				return dataPoint.damage
			end
		end

		local endDamage = DamageGraphs[#DamageGraphs].damage

		if Hitbox == "Head" then
			endDamage = Weapon:getWeaponStat("multhead")
		elseif Hitbox == "Torso" then
			endDamage= Weapon:getWeaponStat("multtorso")
		else
			endDamage *= (Weapon:getWeaponStat("multlimb") or 1)
		end

		return endDamage
	end
    function Ragebot:Teleport(positions, reverse)
        reverse = reverse or false

        Network.Repstop = true

        if type(positions) == "table" then
            for i = 1, #positions do
                i = reverse and #positions - i or i

                local Position = positions[i]

                if not Position then
                    continue
                end

                Network:Send("repupdate", Position, Vector2zero, GameClock.getTime(), true)
            end
        else
            Network:Send("repupdate", positions, Vector2zero, GameClock.getTime(), true)
        end

        --Network.Shift += 1 / (60 - #positions)

        Network.Repstop = false
    end

    function Ragebot:FakeShoot(info, weapon)
        -- ok i need to figure out how to add fake bullet here

		local Object = weapon._characterObject
		if Object.animating then
			weapon._inspecting = false
			weapon:cancelAnimation(weapon._reloadCancelTime)
		end
		
        local CharacterObject = CharacterInterface.getCharacterObject()
        weapon:impulseSprings(CharacterObject:getSpring("aimspring").p)

        if weapon:getWeaponStat("type") == "REVOLVER" and not weapon:getWeaponStat("caselessammo") then
            Sound.play("metalshell", 0.1)
        elseif weapon:getWeaponStat("type") == "SHOTWeapon" then 
            Sound.play("shotWeaponshell", 0.2)
        elseif weapon:getWeaponStat("type") == "SNIPER" then
            weapon:playAnimation("pullbolt", true, true)

            Sound.play("metalshell", 0.15, 0.8)
        end

        if weapon:getWeaponStat("sniperbass") then
            Sound.play("1PsniperEcho", 1)
            Sound.play("1PsniperBass", 0.75)
        end

        if not weapon:getWeaponStat("nomuzzleeffects") then
            Effects.muzzleflash(
                weapon._barrelPart, 
                weapon:getWeaponStat("hideflash")
            )
        end

        Utility:PlaySound(
            weapon:getWeaponStat("firesoundid"),
            weapon:getWeaponStat("firevolume") * 100,
            weapon:getWeaponStat("firepitch") * 100
        )

        HudCrosshairsInterface.fireHitmarker(Library.Flags["ragebot_hitbox"])
    end

    function Ragebot:Shift(info)
        info = {
            Range = info.Range or 1,
            Position = info.Position or nil,
            Storage = info.Storage or {},
            Teleport = info.Teleport or false,
            FirePos = info.FirePos or false,
            Raycast = info.Raycast or false
        }

        local Position = info.Position
        local Range = info.Range
        local Storage = info.Storage

        if not Position then
            return Storage
        end

        for _,v in next, Directions do
            local Ray = info.Raycast and workspace:Raycast(Position, (v * Range), RayParams) or nil
            local ReturnedPos = Ray and (Ray.Position - v) or Position + (v * Range)
            local Teleport = {}

            if info.Teleport and (ReturnedPos - Position).Magnitude > 0 then
                Teleport = {ReturnedPos}
            end

            Storage[#Storage + 1] = info.FirePos and { Position = ReturnedPos, Teleport = Teleport } or ReturnedPos
        end

        return Storage
    end

    -- function Ragebot:ChopUp(p1, p2, p3)
    --     local positions = {}
    --     local direction = (p2 - p1).Unit
    --     local distance = (p2 - p1).Magnitude
    --     local steps = mathfloor(distance / p3)
    --     for i = 1, steps do
    --         local pos = p1 + direction * (i * (p3 or 2))
    --         tableinsert(positions, pos)
    --     end
    --     tableinsert(positions, p2)
    --     return positions
    -- end

    -- function Ragebot:Shift(position, range, firepos, teleport)
    --     firepos = firepos or false
    --     teleport = teleport or false

    --     if not position then
    --         return {}
    --     end

    --     local ShiftedPositions = firepos and {
    --         { Position = position, Teleport = {} }
    --     } or { position }
    --     local Teleport = {}

    --     for _,v in next, Directions do
    --         local Position = position + (v * range)

    --         if teleport and (Position - position).Magnitude >= 40 then
    --             Teleport[#Teleport + 1] = Position --Ragebot:ChopUp(position, Position, 50 / 3)
    --         end

    --         ShiftedPositions[#ShiftedPositions + 1] = firepos and {Position = Position, Teleport = Teleport} or Position
    --     end

    --     return ShiftedPositions
    -- end

    function Ragebot:Shoot(info, weapon)
        local Firerate = 60 / FirearmObject.getFirerate(weapon)

        local HitTick = os.clock()
        if HitTick - Ragebot.LastHit <= Firerate then
            return
        end

        Ragebot.LastHit = HitTick

        local LastRepUpdate = Network.LastRepUpdate

        if info.Teleport then


            if #info.Teleport > 0 then
                Ragebot:Teleport(info.Teleport, false)
            end
        end

        local WeaponData = weapon._weaponData

        if weapon._magCount < 1 then
            local newCount = WeaponData.magsize + (WeaponData.chamber and 1 or 0) + weapon._magCount
            if weapon._spareCount >= newCount then
                weapon._magCount += newCount
                weapon._spareCount -= newCount
            else
                weapon._magCount += weapon._spareCount
                weapon._spareCount = 0
            end
            Network:Send("reload")
        else
            weapon._magCount -= 1
        end

        local Bullets = {}

        local FireCount = weapon._fireCount

        for i = 1, WeaponData.pelletcount or 1 do
            FireCount += 1

            Bullets[i] = { info.Trajectory, FireCount }            
        end

        weapon._fireCount = FireCount

        Network:Send("newbullets", weapon.uniqueId, {
            camerapos = info.FirePosition,
            firepos = info.FirePosition,
            bullets = Bullets,
        }, GameClock.getTime())

		local TimeHit = Physics.timehit(info.FirePosition, info.Trajectory, PublicSettings.bulletAcceleration, info.HitPosition)
        local Damage = Ragebot:GetDamage(weapon, (info.Player.PlayerPosition - Network.LastRepUpdate).Magnitude, Library.Flags["ragebot_hitbox"])
        
        local OldShot = Ragebot:GetShotInfo(info.Player.Player.Name) or {
			Damage = 0
		}

        Ragebot:LogShot(info.Player.Player.Name, OldShot.Damage + Damage, TimeHit, HitTick)

        for _,v in next, Bullets do
            Network:Send("bullethit", weapon.uniqueId, info.Player.Player, info.HitPosition, Library.Flags["ragebot_hitbox"], v[2], GameClock.getTime())
        end

        Ragebot:FakeShoot(info, weapon)

        if info.Teleport then
            if #info.Teleport > 0 then
                Ragebot:Teleport({LastRepUpdate}, false)
            end
        end
    end

    function Ragebot:ScanPlayer(player, weapon, delta)
        if not player then
            return
        end

        local WeaponData = weapon._weaponData

        --print("[", table.find(Ragebot.Targets, player), "]:", "Player:", player.Player.Name)

        local BarrelPosition = weapon and weapon._barrelPart and weapon._barrelPart.Position or player.HumanoidRootPart.Position
        local OriginPosition = Network.LastRepUpdate or BarrelPosition

        local FirePositions = {
			{Position = OriginPosition, Teleport = {}}
		}
        local HitPositions = {player.PlayerPosition}

		if Library.Flags["rage_fire_pos"] then
        	FirePositions = Ragebot:Shift({
                Storage = FirePositions,
                Position = OriginPosition, 
                Range = Library.Flags["rage_fire_pos_amount"], 
                FirePos = true
            })
		end

		if Library.Flags["rage_hitbox"] then
            HitPositions = Ragebot:Shift({
                Storage = HitPositions,
                Position = player.PlayerPosition, 
                Range = Library.Flags["rage_hitbox_amount"], 
            })
		end

        -- if not Network.Repstop then            
        --     FirePositions = Ragebot:Shift({
        --         Storage = FirePositions,
        --         Position = OriginPosition, 
        --         Range = 18, 
        --         FirePos = true,
        --         Teleport = true,
        --         Raycast = true
        --     })        
        -- end

        for _,FirePosition in next, FirePositions do
            for _,HitPosition in next, HitPositions do
                if not (FirePosition and HitPosition) then
                    continue
                end

                local Trajectory = Physics.trajectory(FirePosition.Position, -Gravity, HitPosition, WeaponData.bulletspeed)

                if not Trajectory then
                    continue
                end

                if BulletCheck(FirePosition.Position, HitPosition, Trajectory, -Gravity, WeaponData.penetrationdepth, delta) then                                        
                    Ragebot:Shoot({
                        ["Player"] = player,
                        ["HitPosition"] = HitPosition,
                        ["FirePosition"] = FirePosition.Position,
                        ["Teleport"] = FirePosition.Teleport,
                        ["Trajectory"] = Trajectory,
                    }, weapon)

					return
                end
            end
        end

        return
    end

    function Ragebot:GetTargets()
        Ragebot.Targets = {}

        Ragebot.Target = nil

        local CharacterObject = CharacterInterface.getCharacterObject()
        local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

        for _,v in next, Players:GetPlayers() do
            if not (Utility:IsAlive(v) and v ~= LocalPlayer and v.Team ~= LocalPlayer.Team) then
                continue
            end

			if Library.Flags["ignore_friends"] and Library.Playerlist:IsTagged(v, "Friended") then
				continue
			end

            local Character = Utility:GetCharacter(v)
            local ThirdPersonObject = Utility:GetThirdPersonObject(v)
            local ReplicationObject = ThirdPersonObject._replicationObject

            local ReceivedPosition = ReplicationObject._receivedPosition

            if not ReceivedPosition then
                continue
            end
            
            local PlayerPosition = ReceivedPosition or Character[Library.Flags["ragebot_hitbox"]].Position

            local Origin = HumanoidRootPart.Position

            local Distance = (PlayerPosition - Origin).Magnitude

			local Weapon, WeaponController = Utility:GetLocalWeapon()

            tableinsert(Ragebot.Targets, {
                ["Player"] = v,
                ["Character"] = Character,
                ["ThirdPersonObject"] = ThirdPersonObject,
                ["ReplicationObject"] = ReplicationObject,
                ["PlayerPosition"] = PlayerPosition,
                ["Distance"] = Distance,
                ["HumanoidRootPart"] = HumanoidRootPart
            })
        end

        tablesort(Ragebot.Targets, function(Index1, Index2)
            return Index1.Distance < Index2.Distance
        end)

        Ragebot.Index = 1

        return Ragebot.Targets[1]
    end

    function Ragebot.ScanPlayers(delta)
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

        Ragebot.Index = Ragebot.Index + 1
        local Target = Ragebot.Targets[Ragebot.Index]

        if not Target then
            Target = Ragebot:GetTargets()
            if not Target then
                return
            end
        end

        local Shot = Ragebot:GetShotInfo(Target.Player.Name)
        if Shot then
            local Ping = LocalPlayer:GetNetworkPing() or 0.1
            local Health = Utility:GetHealth(Target.Player)

            local TravelTime = (Ping + Shot.Time) * 2
            local TimeFromShot = os.clock() - Shot.Tick

            if Shot.Tick and Shot.Time and Health <= Shot.Damage and TimeFromShot < TravelTime then
                return
            end
        end

        Ragebot.Target = Target

        Ragebot:ScanPlayer(Target, Weapon, delta)
    end

    PlayerStatusEvents.onPlayerDied:Connect(function(player)
        Ragebot:ClearShotInfo(player.victim.Name)
    end)

    PlayerStatusEvents.onPlayerSpawned:Connect(function(v, spawnpos)
        local CharacterObject = CharacterInterface.getCharacterObject()
        local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

        if not (Utility:IsAlive(v) and v ~= LocalPlayer and v.Team ~= LocalPlayer.Team) then
            return
        end

        if Library.Flags["ignore_friends"] and Library.Playerlist:IsTagged(v, "Friended") then
            return
        end

        local Character = Utility:GetCharacter(v)
        local ThirdPersonObject = Utility:GetThirdPersonObject(v)
        local ReplicationObject = ThirdPersonObject._replicationObject

        local Origin = HumanoidRootPart.Position

        local Distance = (spawnpos - Origin).Magnitude

        local Weapon, WeaponController = Utility:GetLocalWeapon()

        Ragebot.Target = v

        Ragebot.Index = 0
        tableinsert(Ragebot.Targets, 1, {
            ["Player"] = v,
            ["Character"] = Character,
            ["ThirdPersonObject"] = ThirdPersonObject,
            ["ReplicationObject"] = ReplicationObject,
            ["PlayerPosition"] = spawnpos,
            ["Distance"] = Distance,
            ["HumanoidRootPart"] = HumanoidRootPart
        })

        Ragebot.ScanPlayers(1 / 60)
    end)


    getgenv().rageloop = Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function(delta) Ragebot.ScanPlayers(1 / 60) end))
end