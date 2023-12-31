#!/usr/bin/env bash
# 
# Ensure the needed `plex-stack` networks are available.
# Spencer Butler <dev@tcos.us>

SWARM_MODE=false
DRIVER=bridge
if [ "$1" = --swarm ]
then
    SWARM_MODE=true
    DRIVER=overlay
fi

NETWORKS=(plex_stack_backend plex_stack_proxy)

for NETWORK in "${NETWORKS[@]}"
do
    EXISTS=$(docker network ls -qf name="$NETWORK")
    if [ -z "$EXISTS" ]
    then
        echo "Creating the \"$NETWORK\" network with the \"$DRIVER\" driver."
        docker network create -d "$DRIVER" "$NETWORK"
        echo
    else
        DRIVER=$(docker network ls -f name="$NETWORK" --format "{{.Driver}}")
        echo "The \"$NETWORK\" network is using the \"$DRIVER\" driver, and already exists."
    fi
done