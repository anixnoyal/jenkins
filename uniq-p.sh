#!/bin/bash

# List of plugin directories
PLUGIN_DIRS="/mnt/server1/plugins /mnt/server2/plugins /mnt/server3/plugins"
DEST="/tmp/jenkins-plugins"

mkdir -p "$DEST"

for dir in $PLUGIN_DIRS; do
  for plugin in "$dir"/*.hpi "$dir"/*.jpi; do
    [ -e "$plugin" ] || continue  # skip if glob doesn't match
    base=$(basename "$plugin")
    dest_path="$DEST/$base"
    if [ ! -f "$dest_path" ]; then
      cp "$plugin" "$dest_path"
    fi
  done
done
