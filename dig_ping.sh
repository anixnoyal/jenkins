#!/bin/bash

# Define the URLs to check
urls=("example.com" "another-example.com")

# Define the packet size for latency measurement
packet_size=1400

# Define the number of ping attempts
ping_count=5

# Loop through each URL
for url in "${urls[@]}"; do
    echo "Checking URL: $url"

    # DNS lookup
    echo "Running dig for $url"
    dig "$url"

    # Tracepath
    echo "Running tracepath for $url"
    tracepath "$url"

    # Latency measurement with high packet size
    echo "Measuring latency for $url with packet size $packet_size"
    ping -c "$ping_count" -s "$packet_size" "$url"

    echo "---------------------------------------------"
done
