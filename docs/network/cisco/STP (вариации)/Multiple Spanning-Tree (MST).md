### Multiple Spanning-Tree (MST)

---

* SW1

  * Конфиг

    ```
    spanning-tree mode mst
    spanning-tree mst configuration
      name WSR39
      instance 1 vlan 1000, 1200, 1300
      instance 2 vlan 1500, 1600
      exit
    spanning-tree mst 1 root primary
    ```

  * Проверка

    ```
    SW1#show spanning-tree mst
    
    ##### MST0    vlans mapped:   1-999,1001-1199,1201-1299,1301-1499,1501-1599
                                   1601-4094
    Bridge        address 0c3d.c029.5400  priority      32768 (32768 sysid 0)
    Root          this switch for the CIST
    Operational   hello time 2 , forward delay 15, max age 20, txholdcount 6
    Configured    hello time 2 , forward delay 15, max age 20, max hops    20
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi0/2            Desg FWD 20000     128.3    P2p
    Gi0/3            Desg FWD 20000     128.4    P2p
    Gi1/2            Desg FWD 20000     128.7    P2p
    Gi1/3            Desg FWD 20000     128.8    P2p
    Gi2/0            Desg FWD 20000     128.9    P2p
    Gi2/1            Desg FWD 20000     128.10   P2p
    Gi2/2            Desg FWD 20000     128.11   P2p
    Gi2/3            Desg FWD 20000     128.12   P2p
    Gi3/0            Desg FWD 20000     128.13   P2p
    Gi3/1            Desg FWD 20000     128.14   P2p
    Gi3/2            Desg FWD 20000     128.15   P2p
    Gi3/3            Desg FWD 20000     128.16   P2p
    Po1              Desg FWD 10000     128.65   P2p
    Po2              Desg FWD 10000     128.66   P2p
    
    
    ##### MST1    vlans mapped:   1000,1200,1300
    Bridge        address 0c3d.c029.5400  priority      24577 (24576 sysid 1)
    Root          this switch for MST1
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi2/0            Desg FWD 20000     128.9    P2p
    Po1              Desg FWD 10000     128.65   P2p
    Po2              Desg FWD 10000     128.66   P2p
    
    
    ##### MST2    vlans mapped:   1500,1600
    Bridge        address 0c3d.c029.5400  priority      32770 (32768 sysid 2)
    Root          address 0c3d.c0a9.7500  priority      24578 (24576 sysid 2)
                  port    Po2             cost          10000     rem hops 19
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi2/0            Desg FWD 20000     128.9    P2p
    Po1              Desg FWD 10000     128.65   P2p
    Po2              Root FWD 10000     128.66   P2p
    
    ```



* SW2

  * Конфиг

    ```
    spanning-tree mode mst
    spanning-tree mst configuration
      name WSR39
      instance 1 vlan 1000, 1200, 1300
      instance 2 vlan 1500, 1600
      exit
    spanning-tree mst 2 root primary
    ```

  * Проверка

    ```
    SW2#show spanning-tree mst
    
    ##### MST0    vlans mapped:   1-999,1001-1199,1201-1299,1301-1499,1501-1599
                                   1601-4094
    Bridge        address 0c3d.c0a9.7500  priority      32768 (32768 sysid 0)
    Root          address 0c3d.c029.5400  priority      32768 (32768 sysid 0)
                  port    Po2             path cost     0
    Regional Root address 0c3d.c029.5400  priority      32768 (32768 sysid 0)
                                          internal cost 10000     rem hops 19
    Operational   hello time 2 , forward delay 15, max age 20, txholdcount 6
    Configured    hello time 2 , forward delay 15, max age 20, max hops    20
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi0/2            Desg FWD 20000     128.3    P2p
    Gi0/3            Desg FWD 20000     128.4    P2p
    Gi1/0            Desg FWD 20000     128.5    P2p
    Gi1/1            Desg FWD 20000     128.6    P2p
    Gi1/2            Desg FWD 20000     128.7    P2p
    Gi1/3            Desg FWD 20000     128.8    P2p
    Gi2/0            Desg FWD 20000     128.9    P2p
    Gi2/1            Desg FWD 20000     128.10   P2p
    Gi2/2            Desg FWD 20000     128.11   P2p
    Gi2/3            Desg FWD 20000     128.12   P2p
    Gi3/0            Desg FWD 20000     128.13   P2p
    Gi3/1            Desg FWD 20000     128.14   P2p
    Gi3/2            Desg FWD 20000     128.15   P2p
    Gi3/3            Desg FWD 20000     128.16   P2p
    Po2              Root FWD 10000     128.66   P2p
    
    
    ##### MST1    vlans mapped:   1000,1200,1300
    Bridge        address 0c3d.c0a9.7500  priority      32769 (32768 sysid 1)
    Root          address 0c3d.c029.5400  priority      24577 (24576 sysid 1)
                  port    Po2             cost          10000     rem hops 19
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi0/2            Desg FWD 20000     128.3    P2p
    Gi2/0            Desg FWD 20000     128.9    P2p
    Po2              Root FWD 10000     128.66   P2p
    
    
    ##### MST2    vlans mapped:   1500,1600
    Bridge        address 0c3d.c0a9.7500  priority      24578 (24576 sysid 2)
    Root          this switch for MST2
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi0/2            Desg FWD 20000     128.3    P2p
    Po2              Desg FWD 10000     128.66   P2p
    ```

    



* SW3

  * Конфиг

    ```
    spanning-tree mode mst
    spanning-tree mst configuration
      name WSR39
      instance 1 vlan 1000, 1200, 1300
      instance 2 vlan 1500, 1600
      exit
    ```

  * Проверка

    ```
    SW3#show span mst
    
    ##### MST0    vlans mapped:   1-999,1001-1199,1201-1299,1301-1499,1501-1599
                                   1601-4094
    Bridge        address 0c3d.c0c5.1500  priority      32768 (32768 sysid 0)
    Root          address 0c3d.c029.5400  priority      32768 (32768 sysid 0)
                  port    Po1             path cost     0
    Regional Root address 0c3d.c029.5400  priority      32768 (32768 sysid 0)
                                          internal cost 10000     rem hops 19
    Operational   hello time 2 , forward delay 15, max age 20, txholdcount 6
    Configured    hello time 2 , forward delay 15, max age 20, max hops    20
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi0/0            Desg FWD 20000     128.1    P2p
    Gi0/1            Desg FWD 20000     128.2    P2p
    Gi0/2            Altn BLK 20000     128.3    P2p
    Gi0/3            Desg FWD 20000     128.4    P2p
    Gi1/2            Desg FWD 20000     128.7    P2p
    Gi1/3            Desg FWD 20000     128.8    P2p
    Gi2/0            Desg FWD 20000     128.9    P2p
    Gi2/1            Desg FWD 20000     128.10   P2p
    Gi2/2            Desg FWD 20000     128.11   P2p
    Gi2/3            Desg FWD 20000     128.12   P2p
    Gi3/0            Desg FWD 20000     128.13   P2p
    Gi3/1            Desg FWD 20000     128.14   P2p
    Gi3/2            Desg FWD 20000     128.15   P2p
    Gi3/3            Desg FWD 20000     128.16   P2p
    Po1              Root FWD 10000     128.65   P2p
    
    
    ##### MST1    vlans mapped:   1000,1200,1300
    Bridge        address 0c3d.c0c5.1500  priority      32769 (32768 sysid 1)
    Root          address 0c3d.c029.5400  priority      24577 (24576 sysid 1)
                  port    Po1             cost          10000     rem hops 19
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi0/2            Altn BLK 20000     128.3    P2p
    Gi2/0            Desg FWD 20000     128.9    P2p
    Po1              Root FWD 10000     128.65   P2p
    
    
    ##### MST2    vlans mapped:   1500,1600
    Bridge        address 0c3d.c0c5.1500  priority      32770 (32768 sysid 2)
    Root          address 0c3d.c0a9.7500  priority      24578 (24576 sysid 2)
                  port    Gi0/2           cost          20000     rem hops 19
    
    Interface        Role Sts Cost      Prio.Nbr Type
    ---------------- ---- --- --------- -------- --------------------------------
    Gi0/2            Root FWD 20000     128.3    P2p
    Po1              Altn BLK 10000     128.65   P2p
    ```

    

