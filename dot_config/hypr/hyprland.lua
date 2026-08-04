local autoexec = {
	"noctalia --daemon",
	"fcitx5 -d",
	"wl-clip-persist --clipboard regular",
	"easyeffects -w --service-mode",
	"xremap --watch=config,device --mouse ~/.config/xremap/config.yml",
	"sleep 6; corectrl",
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

-- displays
hl.monitor({output = "DP-2", mode = "1920x1080@239.760", position = "0x0"})
hl.monitor({output = "HDMI-A-1", mode = "1920x1080@120.003", position = "1920x-385", transform = 3})
hl.monitor({output = "SUNSHINE", mode = "800x600@90", position = "3000x0"})

-- workspaces
hl.workspace_rule({workspace = "1", monitor = "DP-2"})
hl.workspace_rule({workspace = "2", monitor = "DP-2", default = true})
hl.workspace_rule({workspace = "3", monitor = "DP-2", on_created_empty = "zen-browser"})
hl.workspace_rule({workspace = "4", monitor = "DP-2", on_created_empty = "kitty"})
hl.workspace_rule({workspace = "5", monitor = "DP-2"})
hl.workspace_rule({workspace = "6", monitor = "HDMI-A-1", default = true})
hl.workspace_rule({workspace = "7", monitor = "HDMI-A-1"})
hl.workspace_rule({workspace = "8", monitor = "HDMI-A-1", on_created_empty = "kitty --class rmpc ~/.config/scripts/run_rmpc.sh"})
hl.workspace_rule({workspace = "9", monitor = "HDMI-A-1", on_created_empty = "spotify"})

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
})

-- per workspace wallpapers
local wallpapers = {}
for i = 1, 9 do
    local wspace = (i <= 5) and "DP-2" or "HDMI-A-1"
    wallpapers[i] = wspace .. " ~/.cache/wallpapers/" .. i
end
hl.on("workspace.active", function(ws) hl.exec_cmd("noctalia msg wallpaper-set " .. wallpapers[ws.id])end)

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

require("animations")
require("keybinds")
require("windowrules")
