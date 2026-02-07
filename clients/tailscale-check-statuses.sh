#!/bin/bash

# Get all container names with tailscale- prefix
containers=$(docker ps --format "{{.Names}}" | grep "^tailscale-")

if [ -z "$containers" ]; then
    echo "No containers found with 'tailscale-' prefix"
    exit 1
fi

# Run tailscale status for each container
for container in $containers; do
    echo "=== $container ==="
    docker exec -it "$container" tailscale status
    echo
done