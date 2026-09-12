#!/usr/bin/env python3
import spotipy
from sys import argv, exit
from spotipy.oauth2 import SpotifyOAuth
from dotenv import load_dotenv

if len(argv) < 3: exit(1)

load_dotenv("spoti.env")
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope="playlist-read-private user-read-playback-state user-modify-playback-state"))

action, id = argv[1], argv[2]

current_track = sp.track(id)
match action:
    case "artist": id = current_track['artists'][0]['id']
    case "album":  id = current_track['album']['id']
print(id)