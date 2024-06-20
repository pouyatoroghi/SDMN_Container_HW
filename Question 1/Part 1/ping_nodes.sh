#!/bin/bash

# Check if the script is run with exactly two arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_node> <destination_node>"
    exit 1
fi

# Assign the arguments to variables for better readability
source_node=$1
destination_node=$2

# Function to start ping from source node to destination node
start_ping() {
    source_node=$1
    destination_node=$2
    echo "Pinging $destination_node from $source_node..."

    # Check if the source_node network namespace exists
    if ! sudo ip netns exec $source_node ip link show >/dev/null 2>&1; then
        echo "Error: Network namespace '$source_node' not found."
        exit 1
    fi

    # Determine the IP address of the destination_node
    if [[ "$destination_node" == "router" ]]; then
        # If the destination is the router, get the IP address of its interface
        dest_ip=$(sudo ip netns exec $destination_node ip addr show dev veth-router1 | awk '/inet / {print $2}' | cut -d'/' -f1)
    else
        # Otherwise, get the default gateway IP address of the destination_node
        dest_ip=$(sudo ip netns exec $destination_node ip route show default | awk '/default via/ {print $3}')
    fi

    # Check if the IP address was successfully retrieved
    if [ -z "$dest_ip" ]; then
        echo "Error: Failed to retrieve IP address of $destination_node"
        exit 1
    fi

    # Execute the ping command from the source_node to the destination IP
    sudo ip netns exec $source_node ping $dest_ip -c 5
}

# Start pinging from source_node to destination_node
start_ping $source_node $destination_node

