local autoexec = {
	"noctalia --daemon",
	"fcitx5 -d",
	"wl-clip-persist --clipboard regular",
	"easyeffects -w --service-mode",
	"xremap --watch=config,device --mouse ~/.config/xremap/config.yml",
	"corectrl",
}

local env_vars = {
	["MESA_SHADER_CACHE_MAX_SIZE"] = "5G",
	["MPD_HOST"] = os.getenv("XDG_RUNTIME_DIR") .. "/mpd.socket",
	["XDG_CURRENT_DESKTOP"] = "Hyprland",
    ["SDL_VIDEODRIVER"] = "wayland",
	["XDG_SESSION_TYPE"] = "wayland",
	["QT_QPA_PLATFORM"] = "wayland;xcb",
	["QT_QPA_PLATFORMTHEME"] = "qt6ct",
	["XCURSOR_THEME"] = "phinger-cursors-dark",
	["QS_ICON_THEME"] = "Papirus-Light",
	["HYPRCURSOR_SIZE"] = "16",
	["XCURSOR_SIZE"] = "16",
}

for key, value in pairs(env_vars) do hl.env(key, value) end
hl.on("hyprland.start", function() for _, cmd in ipairs(autoexec) do hl.exec_cmd(cmd) end end)

-- variables
local active_color, inactive_color = 0xafb4befe, 0x595959aa
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
			active_border = active_color,
			inactive_border = inactive_color,
		},
		layout = "dwindle",
	},
	group = {
		col = {
			border_active = active_color,
			border_inactive = inactive_color,
		},
		groupbar = {
			font_family = "IBM Plex Sans JP",
			font_size = 18,
			gradients = true,
			height = 22,
			col = {
				active = active_color,
				inactive = inactive_color,
			},
		},
	},
	input = {
		kb_layout = "custom",
		kb_options = "fkeys:basic_13-24",
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
})

-- displays
local main, secondary = "DP-2", "HDMI-A-1"
hl.monitor({output = main, mode = "1920x1080@239.760", position = "0x0"})
hl.monitor({output = secondary, mode = "1920x1080@120.003", position = "1920x-385", transform = 3})
hl.monitor({output = "SUNSHINE", mode = "800x600@90", position = "3000x0"})

-- workspaces and per-workspace wallpapers
local wallpapers = {}
local exec_on = {[3] = "zen-browser", [4] = "kitty", [8] = "kitty --class rmpc ~/.config/scripts/run_rmpc.sh", [9] = "spotify"}
for i = 1, 9 do
    local is_default = (i == 2 or i == 6)
    local output_name = (i <= 5) and main or secondary
    hl.workspace_rule({workspace = i, monitor = output_name, default = is_default, on_created_empty = exec_on[i]})
    wallpapers[i] = output_name .. " ~/.cache/wallpapers/" .. i
end
hl.on("workspace.active", function(ws) hl.exec_cmd("noctalia msg wallpaper-set " .. wallpapers[ws.id]) end)

-- mouse config
for _, mouse_name in ipairs({"xremap-1", "realtek-mchose-m7-pro"}) do
	hl.device({
		name = mouse_name,
        accel_profile = "flat",
		scroll_method = "on_button_down",
		scroll_button = 276,
		scroll_factor = 1.4,
		sensitivity = -0.5,
	})
end

require("animations")
require("keybinds")
require("windowrules")
