#!/bin/bash

# Bring down interfaces and delete IP addresses in the namespaces
sudo ip netns exec ns1 ip link set veth1 down 2>/dev/null
sudo ip netns exec ns1 ip addr del 172.0.0.2/24 dev veth1 2>/dev/null

sudo ip netns exec ns2 ip link set veth2 down 2>/dev/null
sudo ip netns exec ns2 ip addr del 172.0.0.3/24 dev veth2 2>/dev/null

sudo ip netns exec ns3 ip link set veth3 down 2>/dev/null
sudo ip netns exec ns3 ip addr del 10.0.0.2/24 dev veth3 2>/dev/null

sudo ip netns exec ns4 ip link set veth4 down 2>/dev/null
sudo ip netns exec ns4 ip addr del 10.0.0.3/24 dev veth4 2>/dev/null

sudo ip netns exec router ip link set veth-router1 down 2>/dev/null
sudo ip netns exec router ip addr del 172.0.0.1/24 dev veth-router1 2>/dev/null
sudo ip netns exec router ip link set veth-router2 down 2>/dev/null
sudo ip netns exec router ip addr del 10.0.0.1/24 dev veth-router2 2>/dev/null

# Remove the veth pairs
sudo ip netns exec ns1 ip link del veth1 2>/dev/null
sudo ip netns exec ns2 ip link del veth2 2>/dev/null
sudo ip netns exec ns3 ip link del veth3 2>/dev/null
sudo ip netns exec ns4 ip link del veth4 2>/dev/null
sudo ip netns exec router ip link del veth-router1 2>/dev/null
sudo ip netns exec router ip link del veth-router2 2>/dev/null

# Bring down and delete veth interfaces in the root namespace
sudo ip link set veth1-br down 2>/dev/null
sudo ip link del veth1-br 2>/dev/null
sudo ip link set veth2-br down 2>/dev/null
sudo ip link del veth2-br 2>/dev/null
sudo ip link set veth-router1-br down 2>/dev/null
sudo ip link del veth-router1-br 2>/dev/null
sudo ip link set veth3-br down 2>/dev/null
sudo ip link del veth3-br 2>/dev/null
sudo ip link set veth4-br down 2>/dev/null
sudo ip link del veth4-br 2>/dev/null
sudo ip link set veth-router2-br down 2>/dev/null
sudo ip link del veth-router2-br 2>/dev/null

# Bring down and delete the bridges
sudo ip link set br1 down 2>/dev/null
sudo ip link del br1 2>/dev/null
sudo ip link set br2 down 2>/dev/null
sudo ip link del br2 2>/dev/null

# Delete the namespaces
sudo ip netns del ns1 2>/dev/null
sudo ip netns del ns2 2>/dev/null
sudo ip netns del ns3 2>/dev/null
sudo ip netns del ns4 2>/dev/null
sudo ip netns del router 2>/dev/null

echo "Cleanup complete."

