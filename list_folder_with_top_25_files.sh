find /path/to/high/utilization/directory -maxdepth 1 -type f -exec du -h {} + | sort -rh | head -n 25
