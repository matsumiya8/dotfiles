#!/usr/bin/env python3
from sys import argv
from spoti_helper import write_to_disc, format_track, sp, playlist_uri

if len(argv) < 3: sys.exit(1)
action, id = argv[1], argv[2]

match action:
    case "favorite": 
        sp.playlist_add_items(playlist_uri, items=[sp.track(id)["uri"]])
        formatted = format_track(sp.track(id))
        if formatted: write_to_disc(formatted, "a")
    case "queue_album":  
        results = sp.album_tracks(id)
        for track in results["items"]:
          sp.add_to_queue(track["uri"])
    case "queue_track": 
        sp.add_to_queue(sp.track(id)["uri"])
    case "print_artist_id":
        print(sp.track(id)['artists'][0]['id'])
    case "print_album_id":
        print(sp.track(id)['album']['id'])