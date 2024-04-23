local Libraries = Moonlight.Libraries
local Utility = Libraries.Utility
local Modules = Libraries.Modules
local Visuals = Libraries.Visuals
local Network = Libraries.Network

Visuals.Tracers = {}

CharacterInterface = Modules:Get("CharacterInterface")
GameClock = Modules:Get("GameClock")

local AStar = loadstring(readfile("path.lua"))()

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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

function CreateDrawingTracer(Cfg)
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

        local Circle = Utility:New("Circle", {
            Transparency = 1,
            Filled = true,
            Color = Color3fromRGB(255, 255, 255)
        })

        Tracer.Objects[_] = {
            ["OutlineObject"] = OutlineObject,
            ["Object"] = Obj,
            ["Circle"] = Circle
        }
    end

    local Connection = RunService.Heartbeat:Connect(function()
        local ScreenSize = Camera.ViewportSize

        local Transparency = 1
        local OutlineTransparency = 1

        local Origin = HumanoidRootPart and HumanoidRootPart.Position or Camera.CFrame.p

        if os.clock() - Tracer.StartTick > Cfg.Time then
            Tracer:Remove()
            table.remove(Visuals.Tracers, _)
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
            local Circle = Objects.Circle

            local FromScreen, FromOnScreen = Camera:WorldToViewportPoint(From)
            local ToScreen, ToOnScreen = Camera:WorldToViewportPoint(To)
            
            Object.Visible = ToOnScreen and FromOnScreen
            OutlineObject.Visible = ToOnScreen and FromOnScreen
            Circle.Visible = ToOnScreen and FromOnScreen

            if Object.Visible and OutlineObject.Visible then
                local FromVector2 = Vector2new(FromScreen.x, FromScreen.y)
                local ToVector2 = Vector2new(ToScreen.x, ToScreen.y)
                
                Object.From = FromVector2
                Object.To = ToVector2
                Object.Color = Cfg.Color
    
                OutlineObject.From = FromVector2
                OutlineObject.To = ToVector2
                OutlineObject.Color = Cfg.Outline

                Circle.Position = FromVector2
                Circle.Color = Cfg.Color
                Circle.Radius = 5
            end
        end
    end)
    Tracer.Connection = Connection

    function Tracer:Remove()
        for _,v in next, Tracer.Objects do
            v.OutlineObject:Remove()
            v.Object:Remove()
            v.Circle:Remove()
        end

        Tracer.Connection:Disconnect()
    end

    Visuals.Tracers[#Visuals.Tracers + 1] = Tracer
end

local Target = Players.LocalPlayer

local Character = Utility:GetCharacter(Target)

local CharacterObject = CharacterInterface.getCharacterObject()
local HumanoidRootPart = CharacterObject and CharacterObject._rootPart

local Origin = HumanoidRootPart.Position
local End = Vector3.new(-107, -12, 8)
--Origin + Vector3new(0, 100, 0)
--Character.Torso.Position + Vector3new(0, 20, 0)

local Path = AStar:findpath(Origin, End, 20, 0)

CreateDrawingTracer({
    Time = 20,
    Positions = Path
})

if Path then
    for _,v in next, Path do
        Network.Repstop = false

        Network.Shift += 1 / 15
        Network:Send("repupdate", v, Vector2new(0, 0), GameClock.getTime(), true)

        Network.Repstop = true
    end
end