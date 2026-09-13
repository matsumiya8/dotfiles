#!/usr/bin/env python3
import sys
from spoti_helper import write_to_disc, format_track, get_server_snapshot, sp, playlist_uri

if len(sys.argv) == 2 and sys.argv[1] == get_server_snapshot(): sys.exit(0)

fields = "items(item(name,id,artists(name),album(name,id))),next"
results = sp.playlist_items(playlist_uri, fields=fields, limit=100, market="BR", additional_types=("track",))
lines = []

while results:
    for entry in results.get("items", []):
        track = entry.get("item")
        if not track: continue
        lines.append(format_track(track))

    results = sp.next(results) if results.get("next") else None

write_to_disc(lines, "w")