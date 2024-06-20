# Routing Packets Between Subnets Across Different Servers

When the namespaces are on different servers that can see each other at Layer 2 (Ethernet level), routing packets between the two subnets involves configuring the servers to act as gateways and ensuring that the packets are correctly routed through the switch. Below is a detailed explanation of how to achieve this:

## Network Layout

### Server 1:
- **node1**: 172.0.0.2/24
- **node2**: 172.0.0.3/24
- **br1**: Bridge connecting node1 and node2
- **br1** is connected to a physical or virtual network interface (e.g., eth0)

### Server 2:
- **node3**: 10.10.0.2/24
- **node4**: 10.10.0.3/24
- **br2**: Bridge connecting node3 and node4
- **br2** is connected to a physical or virtual network interface (e.g., eth0)

### Switch:
- Connecting eth0 of Server 1 and eth0 of Server 2, allowing Layer 2 connectivity between the servers.

## Step-by-Step Solution

### Server 1 Configuration

#### Enable IP Forwarding:
Allow the server to forward IP packets between its interfaces.
```bash
sudo sysctl -w net.ipv4.ip_forward=1
```
#### Configure IP Address for br1:
Assign an IP address to br1 to act as the gateway for node1 and node2.

```bash
sudo ip addr add 172.0.0.1/24 dev br1
sudo ip link set br1 up
```
#### Routing Rules on Server 1:
Add a route to direct traffic destined for the 10.10.0.0/24 subnet through eth0.

```bash
sudo ip route add 10.10.0.0/24 via <IP_of_eth0_Server_2>
```
### Server 2 Configuration

#### Enable IP Forwarding:
Allow the server to forward IP packets between its interfaces.

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```
#### Configure IP Address for br2:
Assign an IP address to br2 to act as the gateway for node3 and node4.

```bash
sudo ip addr add 10.10.0.1/24 dev br2
sudo ip link set br2 up
```
#### Routing Rules on Server 2:
Add a route to direct traffic destined for the 172.0.0.0/24 subnet through eth0.

```bash
sudo ip route add 172.0.0.0/24 via <IP_of_eth0_Server_1>
```
### Network Namespaces Configuration

#### Namespaces on Server 1:
In ns1 and ns2, set the default route to use br1 as the gateway.

```bash
sudo ip netns exec ns1 ip route add default via 172.0.0.1
sudo ip netns exec ns2 ip route add default via 172.0.0.1
```
### Namespaces on Server 2:
In ns3 and ns4, set the default route to use br2 as the gateway.

```bash
sudo ip netns exec ns3 ip route add default via 10.10.0.1
sudo ip netns exec ns4 ip route add default via 10.10.0.1
```

## Detailed Explanation
### IP Forwarding
Enabling IP forwarding on both servers allows them to act as routers, forwarding packets between their interfaces. This is crucial for routing traffic between the two subnets.

### Bridge Configuration
Assigning IP addresses to the bridges (br1 on Server 1 and br2 on Server 2) establishes them as gateways for their respective subnets. This configuration enables the nodes to send traffic to the appropriate bridge for inter-subnet communication.

### Routing Rules
Adding routes on both servers ensures that traffic destined for the other subnet is directed to the correct server. For example, traffic from node1 or node2 destined for the 10.10.0.0/24 subnet is sent to eth0 of Server 1, which forwards it to Server 2. Similarly, traffic from node3 or node4 destined for the 172.0.0.0/24 subnet is sent to eth0 of Server 2, which forwards it to Server 1.

### Inter-Subnet Communication
With IP forwarding enabled and appropriate routing rules set up, the servers can forward packets between the subnets. The switch provides the Layer 2 connectivity, allowing the servers to communicate with each other. This setup ensures seamless communication between nodes in different subnets across the two servers.

## Summary
By configuring each server to act as a gateway for its respective subnet, enabling IP forwarding, and setting up appropriate routing rules, we can route packets between isolated subnets on different servers. The switch provides the necessary Layer 2 connectivity, and the servers handle the inter-subnet routing. This approach ensures efficient communication between nodes across the two servers.
