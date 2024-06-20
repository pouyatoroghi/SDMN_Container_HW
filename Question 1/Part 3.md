# Routing Packets Between Subnets Using the Root Namespace as an Intermediary Router

To route packets between the two subnets (172.0.0.0/24 and 10.10.0.0/24) without a direct connection between the bridges, you can use the root namespace as an intermediary router. This involves setting up a veth pair to bridge the networks and configuring routing rules to ensure proper packet forwarding. Below is a step-by-step guide on how to achieve this:

## Step-by-Step Solution

### 1. Create and Configure veth Pairs

In the root namespace, create a virtual Ethernet (veth) pair to connect br1 and br2.
```bash
sudo ip link add veth-br1 type veth peer name veth-br2
sudo ip link set veth-br1 up
sudo ip link set veth-br2 up
```
Connect one end of the veth pair to br1 and the other end to br2.
```bash
sudo ip link set veth-br1 master br1
sudo ip link set veth-br2 master br2
```
This setup creates a virtual link between br1 and br2, enabling packet forwarding between them through the root namespace.

### 2. Enable IP Forwarding in the Root Namespace

Enable IP forwarding to allow the root namespace to route packets between the two interfaces (veth-br1 and veth-br2).
```bash
sudo sysctl -w net.ipv4.ip_forward=1
```
This command ensures that the kernel forwards packets between network interfaces.

### 3. Assign IP Addresses

Assign IP addresses to the veth interfaces within the respective subnets to establish them as gateways.
```bash
sudo ip addr add 172.0.0.1/24 dev veth-br1
sudo ip addr add 10.0.0.1/24 dev veth-br2
```
These IP addresses serve as the default gateways for the respective subnets, allowing nodes in each subnet to route traffic through the root namespace.

### 4. Add Routing Rules in the Network Namespaces

Configure the namespaces to use the root namespace as their gateway for reaching the other subnet.

In ns1 and ns2: Add a route to reach the 10.0.0.0/24 subnet via the gateway 172.0.0.1.
```bash
sudo ip netns exec ns1 ip route add 10.10.0.0/24 via 172.0.0.1
sudo ip netns exec ns2 ip route add 10.10.0.0/24 via 172.0.0.1
```
In ns3 and ns4: Add a route to reach the 172.0.0.0/24 subnet via the gateway 10.10.0.1.
```bash
sudo ip netns exec ns3 ip route add 172.0.0.0/24 via 10.10.0.1
sudo ip netns exec ns4 ip route add 172.0.0.0/24 via 10.10.0.1
```
These routes ensure that traffic destined for the other subnet is sent to the root namespace, which then forwards it appropriately.

## Detailed Explanation

# Virtual Ethernet (veth) Pair

A veth pair creates a virtual link between two network namespaces or network interfaces. Packets sent to one end of the veth pair appear on the other end.

In this setup, veth-br1 and veth-br2 act as the connecting links between br1 and br2.

# IP Forwarding

Enabling IP forwarding in the root namespace allows it to act as a router. When IP forwarding is enabled, the kernel forwards packets between network interfaces.

This is essential for the root namespace to route traffic between the two subnets.

# IP Address Assignment

Assigning IP addresses to veth-br1 and veth-br2 establishes them as the default gateways for their respective subnets.

These IP addresses are used in the routing rules of the namespaces to direct traffic through the root namespace.

# Routing Rules

Adding routes in the namespaces ensures that any traffic destined for the other subnet is sent to the respective gateway (veth interface in the root namespace).

For example, traffic from ns1 or ns2 destined for the 10.10.0.0/24 subnet is sent to 172.0.0.1, the IP address of veth-br1. The root namespace then forwards it to veth-br2, which is connected to br2 and hence to ns3 or ns4.

Similarly, traffic from ns3 or ns4 destined for the 172.0.0.0/24 subnet is sent to 10.10.0.1, the IP address of veth-br2. The root namespace forwards it to veth-br1, which is connected to br1 and hence to ns1 or ns2.

## Summary

By creating a veth pair and connecting it to the bridges in the root namespace, enabling IP forwarding, assigning appropriate IP addresses, and configuring routing rules, you can effectively route packets between the isolated subnets without a direct connection between br1 and br2. This setup leverages the root namespace as an intermediary router, ensuring seamless communication between the subnets.

