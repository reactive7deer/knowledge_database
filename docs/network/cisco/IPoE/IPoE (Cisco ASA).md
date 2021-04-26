### IPoE (Cisco ASA)

---

1. Cоздать подходящие **VLAN интерфейсы**

   ```
   interface Vlan111
    description >> ISP1 <<
    nameif ISP1
    security-level 0
    ip address 100.45.10.2 255.255.255.252
   !
   interface Vlan901
    description >> ISP2 <<
    nameif ISP2
    security-level 0
    ip address 22.84.4.6 255.255.255.252
   ```

2. Перевести физические интерфейсы в необходимый режим, указав подходящие **VLAN**

   ```
   interface Ethernet0/0
    description >> ISP1 <<
    switchport access vlan 111   #Не тегерированная
   !
   interface Ethernet0/1
    description >> ISP2 <<
    switchport trunk allowed vlan 901   #Тегерированная
    switchport mode trunk
   ```

   

