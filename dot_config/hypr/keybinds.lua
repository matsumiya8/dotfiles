local mm = "SUPER+"
local function noct(key, msg)
	hl.bind(key, hl.dsp.exec_cmd("noctalia msg " .. msg))
end

-- move/resize
hl.bind(mm .. "mouse:272", hl.dsp.window.drag(),   {mouse = true})
hl.bind(mm .. "mouse:273", hl.dsp.window.resize(), {mouse = true})

-- workspace/monitor navigation
hl.bind(mm .. "Tab", hl.dsp.focus({monitor = "+1"}))
hl.bind(mm .. "SHIFT+Tab", hl.dsp.window.move({monitor = "+1"}))

local workspace_keys = { "insert", "a", "s", "d", "f", "z", "x", "c", "v" }
for i = 1, 9 do
	hl.bind(mm .. workspace_keys[i], hl.dsp.focus({workspace = i}))
	hl.bind(mm .. "SHIFT+" .. workspace_keys[i], hl.dsp.window.move({workspace = i}))
end

-- multimedia
noct(mm .. "F4", "media next-player")
for _, key in ipairs({mm .. "F5", "XF86AudioPlay", "XF86AudioPause"}) do noct(key, "media toggle") end
for _, key in ipairs({mm .. "F6", "XF86AudioStop"}) do noct(key, "media stop") end
for _, key in ipairs({mm .. "F7", "XF86AudioPrev"}) do noct(key, "media previous") end
for _, key in ipairs({mm .. "F8", "XF86AudioNext"}) do noct(key, "media next") end
hl.bind(mm .. "F9", hl.dsp.exec_cmd("~/.config/scripts/rmpc_dynamic.sh"))
hl.bind(mm .. "F10", hl.dsp.exec_cmd("~/.config/scripts/rmpc_dynamic.sh artist"))
hl.bind(mm .. "F11", hl.dsp.exec_cmd("~/.config/scripts/rmpc_dynamic.sh album"))
hl.bind(mm .. "F12", hl.dsp.exec_cmd("kitty --class rmpc_search -o font_size=22 ~/.config/scripts/rmpc_dynamic.sh input",{float=true,pin=true,stay_focused=true,size={500,50}}))
noct(mm .. "F13", "volume-up 5")
noct(mm .. "F14", "volume-down 5")

-- other noctalia commands, screenshots and recording
noct(mm .. "SUPER_L", "panel-toggle launcher")
noct(mm .. "Y", "panel-toggle clipboard")
noct(mm .. "G", "panel-toggle noctalia/timer:panel")
noct(mm .. "N", "panel-toggle noctalia/notes:panel")
noct("XF86AudioRaiseVolume", "panel-toggle session")
noct("ALT+1", "screenshot-region")
noct("ALT+2", "screenshot-fullscreen")
hl.bind("ALT+3", function() hl.dispatch(hl.dsp.exec_cmd("~/.config/scripts/capture.sh " .. hl.get_active_monitor().name))end)

-- layout shenanigans
for _, key in ipairs({mm .. "grave", mm .. "dead_grave"}) do hl.bind(key, hl.dsp.group.toggle()) end
hl.bind(mm .. "mouse_down", hl.dsp.group.next())
hl.bind(mm .. "mouse_up", hl.dsp.group.prev())
hl.bind(mm .. "1", hl.dsp.layout("togglesplit"))
hl.bind(mm .. "2", hl.dsp.window.fullscreen())
hl.bind(mm .. "3", hl.dsp.window.float())

-- movement
for _, key in ipairs({"left", "up", "down", "right"}) do
	hl.bind(mm .. key, hl.dsp.focus({direction = key}))
	hl.bind(mm .. "SHIFT+" .. key, hl.dsp.window.move({direction = key}))
end

-- general binds
hl.bind("CTRL+SHIFT+Escape", hl.dsp.exec_cmd("missioncenter", {size={1020,900}, pin=true, float=true}))
hl.bind(mm .. "dead_acute", function() hl.dispatch(hl.dsp.exec_cmd("wl-copy " .. hl.get_active_window().class))end)
hl.bind(mm .. "Space", hl.dsp.exec_cmd("kitty nnn -T t -n /"))
hl.bind(mm .. "Q", hl.dsp.window.close())
hl.bind(mm .. "W", hl.dsp.exec_cmd("kitty"))
hl.bind(mm .. "E", hl.dsp.exec_cmd("pcmanfm-qt"))
hl.bind(mm .. "R", function() hl.dispatch(hl.dsp.exec_cmd(string.format("~/.config/scripts/link_wallpaper.sh %s %s", hl.get_active_monitor().name, hl.get_active_workspace().id)))end)
hl.bind(mm .. "T", hl.dsp.exec_cmd("tutanota-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox %U"))
hl.bind(mm .. "U", hl.dsp.exec_cmd("~/Tools/upscaler/.venv/bin/python ~/Tools/upscaler/.venv/bin/upscale -m 8x32 -f --target-delay 0 --focus-poll-interval 0.2", {float=true,fullscreen=true}))
hl.bind(mm .. "P", hl.dsp.exec_cmd("~/.config/scripts/sunshine.sh"))
hl.bind(mm .. "B", hl.dsp.exec_cmd("zen-browser"))

-- config shortcuts
hl.bind(mm .. "comma", hl.dsp.exec_cmd('kitty micro ~/.config/hypr/hyprland.lua'))
hl.bind(mm .. "period", hl.dsp.exec_cmd("kitty micro ~/.config/hypr/keybinds.lua"))
hl.bind(mm .. "slash", hl.dsp.exec_cmd("kitty micro ~/.config/hypr/windowrules.lua"))
