#!/usr/bin/env python3
import spotipy
from sys import argv, exit
from spotipy.oauth2 import SpotifyOAuth
from dotenv import load_dotenv
from pathlib import Path

if len(argv) < 3: exit(1)

load_dotenv("spoti.env")
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope="playlist-read-private user-read-playback-state user-modify-playback-state"))

action, id = argv[1], argv[2]

match action:
    case "track": sp.add_to_queue(sp.track(id)["uri"])
    case "album":  
        results = sp.album_tracks(id)
        for track in results["items"]:
          sp.add_to_queue(track["uri"])
