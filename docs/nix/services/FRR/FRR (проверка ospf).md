* **L-FW**

  * Конфиг

    ```
     !
     router ospf
      ospf router-id 3.3.3.100
      passive-interface ens38
      network 10.5.5.0/30 area 0
      network 172.16.20.0/24 area 0
      network 172.16.50.0/30 area 0
      network 172.16.55.0/30 area 0
     !
    ```

  * Маршруты

    ```
    Codes: K - kernel route, C - connected, S - static, R - RIP,
           O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
           T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
           F - PBR,
           > - selected route, * - FIB route
    
    K * 0.0.0.0/0 [0/104] via 192.168.229.2, ens39, 01:24:41
    K>* 0.0.0.0/0 [0/103] via 10.10.10.10, ens38, 02:06:54
    O   10.5.5.0/30 [110/10] is directly connected, tun1, 02:06:54
    C>* 10.5.5.0/30 is directly connected, tun1, 02:06:54
    C>* 10.10.10.0/24 is directly connected, ens38, 02:06:54
    O   172.16.20.0/24 [110/100] is directly connected, ens33, 02:06:54
    C>* 172.16.20.0/24 is directly connected, ens33, 02:06:54
    O   172.16.50.0/30 [110/100] is directly connected, ens36, 02:06:54
    C>* 172.16.50.0/30 is directly connected, ens36, 02:06:54
    O   172.16.55.0/30 [110/100] is directly connected, ens37, 02:06:54
    C>* 172.16.55.0/30 is directly connected, ens37, 02:06:54
    O>* 192.168.10.0/30 [110/110] via 10.5.5.2, tun1, 01:45:13
    O>* 192.168.20.0/24 [110/110] via 10.5.5.2, tun1, 01:45:13
    O>* 192.168.100.0/24 [110/210] via 10.5.5.2, tun1, 01:45:13
    C>* 192.168.229.0/24 is directly connected, ens39, 00:35:37
    ```

  * OSPF соседи

    ```
    Neighbor ID     Pri State           Dead Time Address         Interface            RXmtL RqstL DBsmL
    3.3.3.55          1 Full/DROther      37.004s 10.5.5.2        tun1:10.5.5.1            0     0     0
    ```

  * OSPF полученные маршруты

    ```
    L-FW# show ip ospf route
    ============ OSPF network routing table ============
    N    10.5.5.0/30           [10] area: 0.0.0.0
                               directly attached to tun1
    N    172.16.20.0/24        [100] area: 0.0.0.0
                               directly attached to ens33
    N    172.16.50.0/30        [100] area: 0.0.0.0
                               directly attached to ens36
    N    172.16.55.0/30        [100] area: 0.0.0.0
                               directly attached to ens37
    N    192.168.10.0/30       [110] area: 0.0.0.0
                               via 10.5.5.2, tun1
    N    192.168.20.0/24       [110] area: 0.0.0.0
                               via 10.5.5.2, tun1
    N    192.168.100.0/24      [210] area: 0.0.0.0
                               via 10.5.5.2, tun1
    ```

  

* **R-FW**

  * Конфиг

    ```
    !
    router ospf
     ospf router-id 3.3.3.55
     passive-interface ens33
     passive-interface ens37
     network 10.5.5.0/30 area 0
     network 192.168.10.0/30 area 0
     network 192.168.20.0/24 area 0
    !
    ```
  
  * Маршруты
  
    ```
    R-FW# show ip route
    Codes: K - kernel route, C - connected, S - static, R - RIP,
           O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
           T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
           F - PBR, f - OpenFabric,
           > - selected route, * - FIB route
    
    K>* 0.0.0.0/0 [0/102] via 20.20.20.10, ens37, 02:23:49
    O   10.5.5.0/30 [110/10] is directly connected, tun0, 02:23:49
    C>* 10.5.5.0/30 is directly connected, tun0, 02:23:49
    C>* 20.20.20.0/24 is directly connected, ens37, 02:23:49
    O>* 172.16.20.0/24 [110/110] via 10.5.5.1, tun0, 02:02:29
    O>* 172.16.50.0/30 [110/110] via 10.5.5.1, tun0, 02:02:29
    O>* 172.16.55.0/30 [110/110] via 10.5.5.1, tun0, 02:02:29
    O   192.168.10.0/30 [110/100] is directly connected, ens36, 02:23:00
    C>* 192.168.10.0/30 is directly connected, ens36, 02:23:49
    O   192.168.20.0/24 [110/100] is directly connected, ens33, 02:23:49
    C>* 192.168.20.0/24 is directly connected, ens33, 02:23:49
    O>* 192.168.100.0/24 [110/200] via 192.168.10.2, ens36, 02:22:50
    ```
  
  * OSPF соседи
  
    ```
    Neighbor ID     Pri State           Dead Time Address         Interface            RXmtL RqstL DBsmL
    192.168.10.2      1 Full/DR           30.751s 192.168.10.2    ens36:192.168.10.1       0     0     0
    3.3.3.100         1 Full/DROther      30.816s 10.5.5.1        tun0:10.5.5.2            0     0     0
    ```
  
  * OSPF полученные маршруты
  
    ```
    ============ OSPF network routing table ============
    N    10.5.5.0/30           [10] area: 0.0.0.0
                               directly attached to tun0
    N    172.16.20.0/24        [110] area: 0.0.0.0
                               via 10.5.5.1, tun0
    N    172.16.50.0/30        [110] area: 0.0.0.0
                               via 10.5.5.1, tun0
    N    172.16.55.0/30        [110] area: 0.0.0.0
                               via 10.5.5.1, tun0
    N    192.168.10.0/30       [100] area: 0.0.0.0
                               directly attached to ens36
    N    192.168.20.0/24       [100] area: 0.0.0.0
                               directly attached to ens33
    N    192.168.100.0/24      [200] area: 0.0.0.0
                               via 192.168.10.2, ens36
    ```