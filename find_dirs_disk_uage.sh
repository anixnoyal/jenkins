find /var/lib/jenkins/ -type d -exec du -sh {} + 2>/dev/null | sort -hr | head -n 20
