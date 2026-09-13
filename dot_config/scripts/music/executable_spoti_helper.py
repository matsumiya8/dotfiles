#!/usr/bin/env python3
from pathlib import Path
import spotipy
from spotipy.oauth2 import SpotifyOAuth
from dotenv import load_dotenv

cache_path = str(Path("~/.cache/indexes").expanduser().resolve())
script_path = Path("~/.config/scripts/music").expanduser().resolve()
playlist_uri = "spotify:playlist:0dc7fzzqZlbck2WXf5N5bz"
load_dotenv(script_path / "spoti.env")
red, mint, yellow, white = "\033[35m", "\033[36m", "\033[33m", "\033[0m"

sp = spotipy.Spotify(
    auth_manager=SpotifyOAuth(
        scope="playlist-read-private playlist-modify-private user-read-playback-state user-modify-playback-state",
        cache_path=str(script_path / ".cache"),
    )
)

def server_snapshot():
    return sp.playlist(playlist_uri, fields="snapshot_id").get("snapshot_id")

def playlist_changed():
    local_snapshot=Path('~/.cache/indexes/snapshot.txt').expanduser().read_text()
    return (local_snapshot != server_snapshot())

def format_track(track):
    artists = " / ".join(a["name"] for a in track["artists"])
    album = track["album"]
    display = f"{red}{artists} {white}- {mint}{track['name']} {yellow}({album['name']}){white}"
    return f"{display}\t{track['id']}\t{album['id']}\n"

def write_to_disc(lines, append_or_write):
    with open(f"{cache_path}/playlist.tsv", append_or_write, encoding="utf-8") as file:
        file.writelines(lines)
    
    with open(f"{cache_path}/snapshot.txt", "w", encoding="utf-8") as file: 
        file.writelines(server_snapshot())

