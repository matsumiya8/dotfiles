#!/usr/bin/env python3
import spotipy
from sys import argv, exit
from spotipy.oauth2 import SpotifyOAuth
from dotenv import load_dotenv
from pathlib import Path

if len(argv) < 3: 
    exit(1)

load_dotenv("spoti.env")

sp = spotipy.Spotify(
    auth_manager=SpotifyOAuth(scope="playlist-read-private"),
)

playlist_id = "spotify:playlist:0dc7fzzqZlbck2WXf5N5bz"
local_snapshot = argv[2]
server_snapshot = sp.playlist(playlist_id, fields="snapshot_id").get("snapshot_id") 

if local_snapshot == server_snapshot:
    print("Playlist up to date")
    exit(0)

fields = "items(item(name,id,artists(name),album(name,id))),next"

results = sp.playlist_items(
    playlist_id,
    fields=fields,
    limit=100,
    market="BR",
    additional_types=("track",),
)

lines = []

while results:
    for entry in results.get("items", []):
        track = entry.get("item")
        if not track:
            continue

        album_name = track["album"]["name"]
        artists = " / ".join(a["name"] for a in track["artists"])
        track_name = track["name"]

        display = f"{artists} - {track_name} ({album_name})"
        track_id = track["id"]
        album_id = track["album"]["id"]

        lines.append(f"{display}\t{track_id}\t{album_id}\n")

    results = sp.next(results) if results.get("next") else None

spoti_path = argv[1]
with open(f"{spoti_path}/playlist.tsv", "w", encoding="utf-8") as file:
    file.writelines(lines)
    
with open(f"{spoti_path}/snapshot.txt", "w", encoding="utf-8") as file:
    file.writelines(server_snapshot)