### OSPF (проверка)

---

* **HQ1**

  ```
  HQ1#show ip ospf neighbor
  
  Neighbor ID     Pri   State           Dead Time   Address         Interface
  3.3.3.3           1   FULL/DROTHER    00:00:38    172.16.3.3      FastEthernet0/1.10
  192.168.254.2     1   FULL/DR         00:00:34    172.16.3.2      FastEthernet0/1.10
  3.3.3.3           0   FULL/  -        00:00:37    172.16.1.2      Tunnel1
  ```

  ```
  HQ1#show ip ospf rib
  
              OSPF Router with ID (1.1.1.1) (Process ID 1)
  
  
                  Base Topology (MTID 0)
  
  OSPF local RIB
  Codes: * - Best, > - Installed in global RIB
  
  *   10.0.100.0/24, Intra, cost 1, area 51, Connected
        via 10.0.100.1, FastEthernet0/0.1000
  *   172.16.1.0/24, Intra, cost 1000, area 0, Connected
        via 172.16.1.1, Tunnel1
  *   172.16.3.0/24, Intra, cost 1, area 0, Connected
        via 172.16.3.1, FastEthernet0/1.10
  *   172.16.20.0/24, Intra, cost 1, area 51, Connected
        via 172.16.20.1, FastEthernet0/0.1200
  ```

  

* **FW1**

  ```
  FW1# show ospf neighbor
  
  
  Neighbor ID     Pri   State           Dead Time   Address         Interface
  1.1.1.1           1   FULL/BDR        0:00:32    172.16.3.1      L2VPN
  3.3.3.3           1   FULL/DROTHER    0:00:31    172.16.3.3      L2VPN
  ```

  ```
  FW1# show ospf rib
  
  
              OSPF Router with ID (192.168.254.2) (Process ID 1)
  OSPF local RIB
  Codes: * - Best, > - Installed in global RIB
  
  *>  10.0.100.0/24, Inter, cost 11, area 0
        via 172.16.3.1, L2VPN
  *>  172.16.1.0/24, Intra, cost 1010, area 0
        via 172.16.3.1, L2VPN
        via 172.16.3.3, L2VPN
  *   172.16.3.0/24, Intra, cost 10, area 0, Connected
        via 172.16.3.2, L2VPN
  *>  172.16.20.0/24, Inter, cost 11, area 0
        via 172.16.3.1, L2VPN
  ```

  

* **BR1**

  ```
  BR1#show ip ospf nei
  
  Neighbor ID     Pri   State           Dead Time   Address         Interface
  1.1.1.1           1   FULL/BDR        00:00:30    172.16.3.1      FastEthernet0/1.10
  192.168.254.2     1   FULL/DR         00:00:33    172.16.3.2      FastEthernet0/1.10
  1.1.1.1           0   FULL/  -        00:00:38    172.16.1.1      Tunnel1
  ```
  
  ```
  R1#show ip ospf rib
  
              OSPF Router with ID (3.3.3.3) (Process ID 1)
  
  
                  Base Topology (MTID 0)
  
  OSPF local RIB
  Codes: * - Best, > - Installed in global RIB
  
  *>  10.0.100.0/24, Inter, cost 2, area 0
        via 172.16.3.1, FastEthernet0/1.10
  *   172.16.1.0/24, Intra, cost 1000, area 0, Connected
        via 172.16.1.2, Tunnel1
  *   172.16.3.0/24, Intra, cost 1, area 0, Connected
        via 172.16.3.3, FastEthernet0/1.10
  *>  172.16.20.0/24, Inter, cost 2, area 0
        via 172.16.3.1, FastEthernet0/1.10
  ```
  
  
  
  ```bash
  #VLAN 1200
  BR1#ping 172.16.20.1
  Type escape sequence to abort.
  Sending 5, 100-byte ICMP Echos to 172.16.20.1, timeout is 2 seconds:
  !!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/2/4 ms
  #VLAN 1000
  BR1#ping 10.0.100.1
  Type escape sequence to abort.
  Sending 5, 100-byte ICMP Echos to 10.0.100.1, timeout is 2 seconds:
  !!!!!
  Success rate is 100 percent (5/5), round-trip min/avg/max = 1/2/4 ms
  ```
  
  