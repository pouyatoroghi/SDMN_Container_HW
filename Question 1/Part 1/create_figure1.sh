#!/bin/bash

# Function to create a network namespace and bring up the loopback interface
create_namespace() {
    sudo ip netns add $1
    sudo ip netns exec $1 ip link set lo up
}

# Function to create a veth pair and assign one end to a specified namespace
create_veth_pair() {
    sudo ip link add $1 type veth peer name $2
    sudo ip link set $1 netns $3
    sudo ip link set $2 up
}

# Function to create a bridge and bring it up
create_bridge() {
    sudo ip link add name $1 type bridge
    sudo ip link set $1 up
}

# Function to assign an IP address to a specified interface in a namespace
assign_ip() {
    sudo ip netns exec $1 ip addr add $2 dev $3
    sudo ip netns exec $1 ip link set $3 up
}

# Function to set the default route in a namespace
set_default_route() {
    sudo ip netns exec $1 ip route add default via $2
}

# Create network namespaces
create_namespace ns1
create_namespace ns2
create_namespace ns3
create_namespace ns4
create_namespace router

# Create veth pairs and assign one end to each namespace
create_veth_pair veth1 veth1-br ns1
create_veth_pair veth2 veth2-br ns2
create_veth_pair veth3 veth3-br ns3
create_veth_pair veth4 veth4-br ns4
create_veth_pair veth-router1 veth-router1-br router
create_veth_pair veth-router2 veth-router2-br router

# Create bridges
create_bridge br1
create_bridge br2

# Connect the other end of veth pairs to the bridges
sudo ip link set veth1-br master br1
sudo ip link set veth2-br master br1
sudo ip link set veth-router1-br master br1
sudo ip link set veth3-br master br2
sudo ip link set veth4-br master br2
sudo ip link set veth-router2-br master br2

# Assign IP addresses to interfaces in the namespaces
assign_ip ns1 172.0.0.2/24 veth1
assign_ip ns2 172.0.0.3/24 veth2
assign_ip ns3 10.10.0.2/24 veth3
assign_ip ns4 10.10.0.3/24 veth4
assign_ip router 172.0.0.1/24 veth-router1
assign_ip router 10.10.0.1/24 veth-router2

# Set default routes in each namespace to point to the router
set_default_route ns1 172.0.0.1
set_default_route ns2 172.0.0.1
set_default_route ns3 10.10.0.1
set_default_route ns4 10.10.0.1

# Enable IP forwarding in the router namespace to allow packet forwarding between interfaces
sudo ip netns exec router sysctl -w net.ipv4.ip_forward=1

# Set up NAT (Network Address Translation) on the router namespace for both networks
sudo ip netns exec router iptables -t nat -A POSTROUTING -o veth-router2 -j MASQUERADE
sudo ip netns exec router iptables -t nat -A POSTROUTING -o veth-router1 -j MASQUERADE

echo "Figure 1 creation complete."

