local autoexec = {
	"noctalia --daemon",
	"fcitx5 -d",
	"wl-clip-persist --clipboard regular",
	"~/.config/scripts/hypr_wallpaper.sh",
	"xrandr --output DP-2 --primary",
	"easyeffects -w --service-mode",
	"xremap --watch=config,device --mouse ~/.config/xremap/config.yml",
	"sleep 6; corectrl",
}

local env_vars = {
	["MESA_SHADER_CACHE_MAX_SIZE"] = "5G",
	["PROTON_USE_NTSYNC"] = "1",
	["SDL_VIDEODRIVER"] = "wayland",
	["EDITOR"] = "micro",
	["TERMINAL"] = "kitty",
	["MPD_HOST"] = os.getenv("XDG_RUNTIME_DIR") .. "/mpd.socket",
	["MANGOHUD"] = "1",
	["MANGOHUD_CONFIG"] = "fps_limit=237, no_display",
	["XDG_CURRENT_DESKTOP"] = "Hyprland",
	["XDG_SESSION_TYPE"] = "wayland",
	["QT_QPA_PLATFORM"] = "wayland",
	["QT_QPA_PLATFORMTHEME"] = "qt6ct",
	["XCURSOR_THEME"] = "phinger-cursors-dark",
	["QS_ICON_THEME"] = "Papirus-Light",
	["HYPRCURSOR_SIZE"] = "16",
	["XCURSOR_SIZE"] = "16",
}

for key, value in pairs(env_vars) do
	hl.env(key, value)
end

hl.on("hyprland.start", function()
	for _, cmd in ipairs(autoexec) do
		hl.exec_cmd(cmd)
	end
end)

-- mouse config
for _, mouse_name in ipairs({"xremap-1", "realtek-mchose-m7-pro"}) do
	hl.device({
		name = mouse_name,
		scroll_method = "on_button_down",
		scroll_button = 276,
		accel_profile = "flat",
		scroll_button_lock = false,
		sensitivity = -0.5,
		scroll_factor = 1.4,
	})
end

-- variables
hl.config({
	cursor = {
		inactive_timeout = 10,
	},
	decoration = {
		rounding = 11,
		blur = {
			enabled = false,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	ecosystem = {
		no_donation_nag = true,
	},
	general = {
		gaps_in = 3.5,
		gaps_out = 7,
		border_size = 3,
		col = {
			active_border = 0xafb4befe,
			inactive_border = 0x595959aa,
		},
		layout = "dwindle",
	},
	group = {
		col = {
			border_active = 0xafb4befe,
			border_inactive = 0x595959aa,
		},
		groupbar = {
			enabled = true,
			font_family = "IBM Plex Sans JP",
			font_size = 18,
			gradients = true,
			height = 22,
			priority = 3,
			render_titles = true,
			scrolling = true,
			col = {
				active = 0xafb4befe,
				inactive = 0xaf313244,
			},
		},
	},
	input = {
		kb_layout = "custom",
		kb_options = "fkeys:basic_13-24",
		follow_mouse = 1,
		sensitivity = 0,
		repeat_delay = 350,
		repeat_rate = 50,
	},
	misc = {
		enable_anr_dialog = false,
		middle_click_paste = false,
		disable_hyprland_logo = true,
		focus_on_activate = true,
	},
	render = {
		direct_scanout = 2,
	},
	xwayland = {
		force_zero_scaling = true,
	}
})

-- displays
hl.monitor({ output = "DP-2", mode = "1920x1080@239.760", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@120.003", position = "1920x-293", scale = 1, transform = 3 })
hl.monitor({ output = "SUNSHINE", mode = "800x600@90", scale = 1, position = "3000x0" })

-- workspaces
hl.workspace_rule({ workspace = "1", monitor = "DP-2"})
hl.workspace_rule({ workspace = "2", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", on_created_empty = "zen-browser" })
hl.workspace_rule({ workspace = "4", monitor = "DP-2", on_created_empty = "kitty" })
hl.workspace_rule({ workspace = "5", monitor = "DP-2" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1", on_created_empty = "vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", on_created_empty = "$HOME/.cargo/bin/rmpcd & kitty --class rmpc ~/.config/scripts/run_rmpc.sh" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", on_created_empty = "DISPLAY= spotify --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime" })

-- curves and animations
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- per workspace wallpapers
local wallpapers = {}
for i = 1, 9 do
    local wspace = (i <= 5) and "DP-2" or "HDMI-A-1"
    wallpapers[i] = wspace .. " ~/.cache/wallpapers/" .. i
end
hl.on("workspace.active", function(ws) hl.exec_cmd("noctalia msg wallpaper-set " .. wallpapers[ws.id])end)

-- keybinds and window rules
require("keybinds")
require("windowrules")
