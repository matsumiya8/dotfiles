hl.window_rule({
  name = "games-and-floating-apps",
  float = true,
  center = true,
  workspace = 1,
  match = {
    class = "^(spacecadetpinball|xqueens|flycast|Light.vn|Godot|xsystem35|com.libretro.RetroArch|pcsx2-qt|gamescope|steam_proton|steam_app.*|.*\\.exe)$",
  },
})

hl.window_rule({
  name = "transparency",
  opacity = 0.95,
  match = {
    class = "^(dev.noctalia.Noctalia|transmission-qt|org.pulseaudio.pavucontrol|spotify|org.quickshell|lxqt-archiver|protonvpn-app|Bitwarden|gnome-system-monitor|pcmanfm-qt|DesktopEditors|vesktop|arqiver|org.nicotine_plus.Nicotine|tutanota-desktop|com.github.wwmm.easyeffects)$",
  },
})

-- windows that shouldn't be resized
local fixed_res = {
    [{1024,768}] = {"少女猟奇譚 獣の告白"},
}

for res, titles in pairs(fixed_res) do
    hl.window_rule({
        min_size = res,
        max_size = res,
        match = {
            title = "^(" .. table.concat(titles, "|") .. ")$"
        }
    })
end

-- workspace rules
hl.window_rule({workspace=3, match={class="^(zen)$"}})
hl.window_rule({workspace=5, match={title="^(Steam|Sign in to Steam)$", class="^(steam)$"}})
hl.window_rule({workspace=7, opacity=0.93, match={class="^(steam)", title="^(Friends List.*)$"}})
hl.window_rule({workspace=7, match={class="^(vesktop)$"}})
hl.window_rule({workspace=9, match={class="^(spotify)$"}})
