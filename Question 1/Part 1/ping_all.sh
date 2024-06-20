#!/bin/bash

# ANSI color escape codes for styling text in the terminal
RED='\033[0;31m'    # Red color
GREEN='\033[0;32m'  # Green color
YELLOW='\033[1;33m' # Yellow color
BOLD='\033[1m'      # Bold text
RESET='\033[0m'     # Reset text attributes to default

# Function to print colored and bold text
print_color() {
    local color="$1"    # The color code to use
    local message="$2"  # The message to print
    echo -e "${BOLD}${color}${message}${RESET}"
}

# Retrieve the list of network namespaces and store in a variable
namespaces=$(sudo ip netns list | awk '{print $1}')

# Function to run pings in both directions between two nodes
run_bidirectional_pings() {
    node1=$1    # First node
    node2=$2    # Second node

    # Ping from node1 to node2
    print_color $YELLOW "Pinging $node1 to $node2..."
    sudo ./ping_nodes.sh $node1 $node2

    # Separator for clarity
    print_color $RED "--------------------------------"

    # Ping from node2 to node1
    print_color $YELLOW "Pinging $node2 to $node1..."
    sudo ./ping_nodes.sh $node2 $node1
}

# Split the list of namespaces into an array
IFS=$'\n' read -r -d '' -a namespaces_array <<< "$namespaces"

# Loop through each pair of namespaces to run bidirectional pings
for (( i=0; i<${#namespaces_array[@]}-1; i++ )); do
    for (( j=i+1; j<${#namespaces_array[@]}; j++ )); do
        ns1=${namespaces_array[$i]}    # First namespace in the pair
        ns2=${namespaces_array[$j]}    # Second namespace in the pair

        # Print a message indicating which namespaces are being pinged
        print_color $GREEN "Pinging between $ns1 and $ns2..."

        # Run the bidirectional pings between the pair of namespaces
        run_bidirectional_pings $ns1 $ns2

        # Separator for clarity between different pairs of namespaces
        print_color $RED "----------------------------------------------------------------"
    done
done

