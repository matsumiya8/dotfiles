local mm = "SUPER+"

local function noct(key, msg) hl.bind(key, hl.dsp.exec_cmd("noctalia msg " .. msg)) end

local function interact_or_exec(action, class, command, args) 
    local match = hl.get_windows({class = class})
    if #match > 0 then hl.dispatch(action({window = match[1]})) else hl.dispatch(hl.dsp.exec_cmd(command, args)) end
end

local music = {
    rmpc    = {player = "mpd", next = {class = "spotify", cmd = "spotify", player = "spotify"}},
    spotify = {player = "spotify", next = {class = "rmpc", cmd = "kitty --class rmpc ~/.config/scripts/music/rmpc.sh", player = "mpd"}}
}

local function music_workspace()
    local win = hl.get_active_window()
    p = win and music[win.class]
    if p == nil then return end
    interact_or_exec(hl.dsp.focus, p.next.class, p.next.cmd)
    hl.exec_cmd(("playerctl -p %s pause"):format(p.player))
    hl.exec_cmd(("playerctl -p %s play"):format(p.next.player))
end

-- general binds
for _, key in ipairs({"ALT+grave", "ALT+dead_grave"}) do hl.bind(key, hl.dsp.exec_cmd("pkill -x meikipop || ~/Tools/meikipop/bin/meikipop")) end
hl.bind("CTRL+SHIFT+Escape", hl.dsp.exec_cmd("missioncenter", {size = {1020,900}, pin = true, float = true}))
hl.bind(mm .. "Space", function() interact_or_exec(hl.dsp.focus, "ff", "kitty --class ff ~/.local/bin/ff", {fullscreen=true}) end)
hl.bind(mm .. "dead_acute", function() hl.dispatch(hl.dsp.exec_cmd("wl-copy " .. hl.get_active_window().class)) end)
hl.bind(mm .. "Q", hl.dsp.window.close())
hl.bind(mm .. "W", hl.dsp.exec_cmd("kitty"))
hl.bind(mm .. "E", hl.dsp.exec_cmd("pcmanfm-qt"))
hl.bind(mm .. "R", function() hl.dispatch(hl.dsp.exec_cmd(string.format("~/.config/scripts/link_wallpaper.sh %s %s", hl.get_active_monitor().name, hl.get_active_workspace().id))) end)
hl.bind(mm .. "T", hl.dsp.exec_cmd("tutanota-desktop"))
hl.bind(mm .. "U", hl.dsp.exec_cmd("~/.local/bin/upscale -m 8x32 --target-delay 0 --monitor DP-2", {float=true,fullscreen=true}))
hl.bind(mm .. "P", hl.dsp.exec_cmd("~/.config/scripts/sunshine.sh"))
hl.bind(mm .. "B", hl.dsp.exec_cmd("zen-browser"))

-- noctalia commands + screen recording
noct(mm .. "SUPER_L", "panel-toggle launcher")
noct(mm .. "Y", "panel-toggle clipboard")
noct(mm .. "G", "panel-toggle noctalia/timer:panel")
noct(mm .. "N", "panel-toggle noctalia/notes:panel")
noct("XF86AudioRaiseVolume", "panel-toggle session")
noct("ALT+1", "screenshot-region")
noct("ALT+2", "screenshot-fullscreen")
hl.bind("ALT+3", hl.dsp.exec_cmd("~/.config/scripts/capture.sh"))

-- multimedia
noct(mm .. "F4", "media next-player")
for _, key in ipairs({mm .. "F5", "XF86AudioPlay", "XF86AudioPause"}) do noct(key, "media toggle") end
for _, key in ipairs({mm .. "F6", "XF86AudioStop"}) do noct(key, "media stop") end
for _, key in ipairs({mm .. "F7", mm .. "mouse_up", "XF86AudioPrev"}) do noct(key, "media previous") end
for _, key in ipairs({mm .. "F8", mm .. "mouse_down", "XF86AudioNext"}) do noct(key, "media next") end
hl.bind(mm .. "J", hl.dsp.exec_cmd("kitty --class rmpc_search -o font_size=22 ~/.config/scripts/rmpc_dynamic.sh input", {float = true, pin = true, stay_focused = true, size = {500,50}}))
for _, key in ipairs({mm .. "F9", mm .. "mouse:274"}) do hl.bind(key, hl.dsp.exec_cmd("~/.config/scripts/music/dynamic_queue.sh"))end
for _, key in ipairs({mm .. "F10", mm .. "mouse:276"}) do hl.bind(key, hl.dsp.exec_cmd("~/.config/scripts/music/dynamic_queue.sh artist"))end
for _, key in ipairs({mm .. "F11", mm .. "mouse:275"}) do hl.bind(key, hl.dsp.exec_cmd("~/.config/scripts/music/dynamic_queue.sh album"))end
hl.bind(mm .. "F12", hl.dsp.exec_cmd("ID=$(playerctl --player=spotify metadata mpris:trackid); rg -F -q -m1 $'\t'\"${ID##*/}\"$'\t' ~/.cache/indexes/playlist.tsv || python3 /home/pyne/.config/scripts/music/spoti_actions.py favorite ${ID##*/}"))
noct("F13", "volume-up 5")
noct("F14", "volume-down 5")

-- movement/focus + resizing
hl.bind(mm .. "mouse:272", hl.dsp.window.drag(),   {mouse = true})
hl.bind(mm .. "mouse:273", hl.dsp.window.resize(), {mouse = true})
hl.bind(mm .. "Tab", hl.dsp.focus({monitor = "+1"}))
hl.bind(mm .. "SHIFT+Tab", hl.dsp.window.move({monitor = "+1"}))
hl.bind(mm .. "c", function() music_workspace() end)
local workspace_keys = {"insert", "a", "s", "d", "f", "z", "x", "c", "v"}
for i = 1, #workspace_keys do
    hl.bind(mm .. workspace_keys[i], hl.dsp.focus({workspace = i}))
    hl.bind(mm .. "SHIFT+" .. workspace_keys[i], hl.dsp.window.move({workspace = i}))
end


local arrow_keys = {"left", "up", "down", "right"}
for _, key in ipairs(arrow_keys) do
    hl.bind(mm .. key, hl.dsp.focus({direction = key}))
    hl.bind(mm .. "SHIFT+" .. key, hl.dsp.window.move({direction = key}))
end

-- layout shenanigans
hl.bind(mm .. "dead_grave", function() interact_or_exec(hl.dsp.focus, "mp", "kitty --class mp ~/.local/bin/mp", {fullscreen=true}) end)
hl.bind(mm .. "mouse_down", hl.dsp.group.next())
hl.bind(mm .. "mouse_up", hl.dsp.group.prev())
hl.bind(mm .. "1", hl.dsp.layout("togglesplit"))
hl.bind(mm .. "2", hl.dsp.window.fullscreen())
hl.bind(mm .. "3", hl.dsp.window.float())

-- config shortcuts
hl.bind(mm .. "comma", hl.dsp.exec_cmd('kitty fresh ~/.config/hypr/hyprland.lua'))
hl.bind(mm .. "period", hl.dsp.exec_cmd("kitty fresh ~/.config/hypr/keybinds.lua"))
hl.bind(mm .. "slash", hl.dsp.exec_cmd("kitty fresh ~/.config/hypr/windowrules.lua"))
