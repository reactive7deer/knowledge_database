### Проверка (multilink и HDLC)
---

* `show ip int brief`

     ```
     BR1#show ip int brief
     Interface                  IP-Address      OK? Method Status                Protocol
     FastEthernet0/0            unassigned      YES NVRAM  administratively down down
     Serial0/0                  unassigned      YES manual up                    up
     FastEthernet0/1            unassigned      YES NVRAM  up                    up
     FastEthernet0/1.10         172.16.3.3      YES NVRAM  up                    up
     Serial0/1                  unassigned      YES manual up                    up
     Serial0/2                  22.84.4.2       YES manual up                    up
     Multilink1                 100.45.5.2      YES IPCP   up                    up
     Loopback0                  3.3.3.3         YES NVRAM  up                    up
     ```
* ping ISP1 и ISP2

  ```
  BR1#ping 100.45.5.1
  
  Type escape sequence to abort.
  Sending 5, 100-byte ICMP Echos to 100.45.5.1, timeout is 2 seconds:
  !!!!!
  Success rate is 100 percent (5/5), round-trip min/avg/max = 4/32/148 ms
  
  BR1#ping 22.84.4.1
  
  Type escape sequence to abort.
  Sending 5, 100-byte ICMP Echos to 22.84.4.1, timeout is 2 seconds:
  !!!!!
  Success rate is 100 percent (5/5), round-trip min/avg/max = 1/11/40 ms
  ```

  