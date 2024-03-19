--#region TODO
--[[
    HIGH PRIORITY:
        - [ ] Make the aim assist, triggerbot and bullet redirection features work

    MEDIUM PRIORITY:
        - [ ] Add a few elements to the rage tab for features (e.g. aimbot, anti-aim, etc.)

    LOW PRIORITY:
        - [ ] Add a few elements to the visuals tab for features (e.g. esp, chams, etc.)
        - [ ] Add a few elements to the misc tab for features (e.g. speed, jump, etc.)
        - [ ] Add a few elements to the settings tab for features (e.g. theme, watermark, etc.)

   FINISHED:
        - [ x ] Add a few elements to the legit tab for features (e.g. aim assist, triggerbot, etc.)
--]]
--#endregion

--#region Libraries, Services, Variables & Functions
--// Libraries
local library = loadstring(game:HttpGet("https://e-z.tools/p/raw/6j3xg81igs", true))()

--// Services
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")

--// Variables
local load_time_tick = tick()

--// Functions
local function do_aim_assist()
	if library.flags["aim_assist_enabled"] then
		print("Aim Assist is enabled")
	end
end
local function do_bullet_redirection()
	if library.flags["bullet_redirection_enabled"] then
		print("Bullet Redirection is enabled")
	end
end
local function do_triggerbot()
	if library.flags["triggerbot_enabled"] then
		print("Triggerbot is enabled")
	end
end
--#endregion

--#region Menu Interface
--// Window & Watermark
local window = library:Load({ title = "Moonlight", theme = "Default", folder = "moonlight", game = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, playerlist = true, performancedrag = false, discord = "discord code here" })
local watermark = library:Watermark("Moonlight | dev | v0.0.1a")

--// Tabs
local legit_tab = window:Tab("legit")
local rage_tab = window:Tab("rage")
local visuals_tab = window:Tab("visuals")
local misc_tab = window:Tab("misc")
local settings_tab = window:Tab("settings")

--// Sections & its toggles, keybinds, sliders, etc.
local aim_assist_section = legit_tab:Section({ name = "Aim Assist", side = "left" })
aim_assist_section:Toggle({ name = "Enabled", default = true, ignored = false, flag = "aim_assist_enabled", callback = function() print("Aim Assist: ", library.flags["aim_assist_enabled"]) end }):Keybind({ name = "Aim Assist", ignored = false, listignored = false, mode = "hold", blacklist = {}, flag = "aim_assist_key", callback = function() print("Aim Assist Key: ", library.flags["aim_assist_key"]) end})
aim_assist_section:Toggle({ name = "Visible Check", default = true, ignored = false, flag = "aim_assist_visible_check", callback = function() print("Aim Assist Visible Check: ", library.flags["aim_assist_visible_check"]) end })
aim_assist_section:Toggle({ name = "Team Check", default = true, ignored = false, flag = "aim_assist_team_check", callback = function() print("Aim Assist Team Check: ", library.flags["aim_assist_team_check"]) end })
aim_assist_section:Separator()
aim_assist_section:Slider({ name = "Field of View", default = 70, ignored = false, float = 1, suffix = "°", min = 0, max = 180, flag = "aim_assist_fov", callback = function() print("Aim Assist FOV: ", library.flags["aim_assist_fov"]) end })
aim_assist_section:Slider({ name = "Horizontal Smoothing", default = 20, ignored = false, float = 1, suffix = "%", min = 0, max = 50, flag = "aim_assist_smoothness", callback = function() print("Aim Assist Horizontal Smoothing: ", library.flags["aim_assist_smoothness_horizontal"]) end })
aim_assist_section:Slider({ name = "Vertical Smoothing", default = 20, ignored = false, float = 1, suffix = "%", min = 0, max = 50, flag = "aim_assist_smoothness_vertical", callback = function() print("Aim Assist Vertical Smoothing: ", library.flags["aim_assist_smoothness_vertical"]) end })
aim_assist_section:Separator()
aim_assist_section:Dropdown({ name = "Hitscan", ignored = false, content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "aim_assist_hitscan", callback = function() print("Aim Assist Hitscan: ", library.flags["aim_assist_hitscan"]) end })
aim_assist_section:Dropdown({ name = "Hitscan Priority", ignored = false, content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = false, flag = "aim_assist_hitscan_priority", callback = function() print("Aim Assist Hitscan Priority: ", library.flags["aim_assist_hitscan_priority"]) end })

local bullet_redirection_section = legit_tab:Section({ name = "Bullet Redirection", side = "middle" })
bullet_redirection_section:Toggle({ name = "Enabled", default = true, ignored = false, flag = "bullet_redirection_enabled", callback = function() print("Bullet Redirection: ", library.flags["bullet_redirection_enabled"]) end })
bullet_redirection_section:Toggle({ name = "Visible Check", default = true, ignored = false, flag = "bullet_redirection_visible_check", callback = function() print("Bullet Redirection Visible Check: ", library.flags["bullet_redirection_visible_check"]) end })
bullet_redirection_section:Toggle({ name = "Team Check", default = true, ignored = false, flag = "bullet_redirection_team_check", callback = function() print("Bullet Redirection Team Check: ", library.flags["bullet_redirection_team_check"]) end })
bullet_redirection_section:Separator()
bullet_redirection_section:Slider({ name = "Field of View", default = 70, ignored = false, float = 1, suffix = "°", min = 0, max = 180, flag = "bullet_redirection_fov", callback = function() print("Bullet Redirection FOV: ", library.flags["bullet_redirection_fov"]) end })
bullet_redirection_section:Slider({ name = "Deadzone", default = 5, ignored = false, float = 1, suffix = "%", min = 0, max = 50, flag = "bullet_redirection_deadzone", callback = function() print("Bullet Redirection Deadzone: ", library.flags["bullet_redirection_deadzone"]) end })
bullet_redirection_section:Separator()
bullet_redirection_section:Dropdown({ name = "Hitscan", ignored = false, content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "bullet_redirection_hitscan", callback = function() print("Bullet Redirection Hitscan: ", library.flags["bullet_redirection_hitscan"]) end })
bullet_redirection_section:Dropdown({ name = "Hitscan Priority", ignored = false, content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = false, flag = "bullet_redirection_hitscan_priority", callback = function() print("Bullet Redirection Hitscan Priority: ", library.flags["bullet_redirection_hitscan_priority"]) end })

local triggerbot_section = legit_tab:Section({ name = "Triggerbot", side = "right" })
triggerbot_section:Toggle({ name = "Enabled", default = true, ignored = false, flag = "triggerbot_enabled", callback = function() print("Triggerbot: ", library.flags["triggerbot_enabled"]) end })
triggerbot_section:Toggle({ name = "Visible Check", default = true, ignored = false, flag = "triggerbot_visible_check", callback = function() print("Triggerbot Visible Check: ", library.flags["triggerbot_visible_check"]) end })
triggerbot_section:Toggle({ name = "Team Check", default = true, ignored = false, flag = "triggerbot_team_check", callback = function() print("Triggerbot Team Check: ", library.flags["triggerbot_team_check"]) end })
triggerbot_section:Separator()
triggerbot_section:Slider({ name = "Delay", default = 120, ignored = false, float = 1, suffix = "ms", min = 0, max = 1000, flag = "triggerbot_delay", callback = function() print("Triggerbot Delay: ", library.flags["triggerbot_delay"]) end })
triggerbot_section:Dropdown({ name = "Hitscan", ignored = false, content = { "Head", "Upper Torso", "Lower Torso", "Arms", "Legs" }, multi = true, flag = "triggerbot_hitscan", callback = function() print("Triggerbot Hitscan: ", library.flags["triggerbot_hitscan"]) end })

window:SettingsTab(watermark)

library.Playerlist:button({
	name = "Prioritize",
	callback = function(list, plr)
		if not list:IsTagged(plr, "Prioritized") then
			list:Tag({ player = plr, text = "Prioritized", color = fromRGB(255, 0, 0) })
		else
			list:RemoveTag(plr, "Prioritized")
		end
	end,
})

library.Playerlist:button({
	name = "Ignore",
	callback = function(list, plr)
		if not library.Playerlist:IsTagged(plr, "Ignored") then
			library.Playerlist:Tag({ player = plr, text = "Ignored", Color = fromRGB(120, 120, 120) })
		else
			library.Playerlist:RemoveTag(plr, "Ignored")
		end
	end,
})

library.Playerlist:Label({
	name = "Rank: ",
	handler = function(plr)
		return "1e+9"
	end,
})

library.Playerlist:Label({
	name = "Team: ",
	handler = function(plr)
		return "Ghosts", fromRGB(209, 118, 0)
	end,
})

--#endregion

library:Init()
library:Notify({ title = "Welcome", message = string.format("Welcome to Moonlight, %s! Version: %s | Loaded modules in (%sms)", game.Players.LocalPlayer.Name, "v0.0.1a", math.floor((tick() - load_time_tick) * 1000)), duration = 3 })
