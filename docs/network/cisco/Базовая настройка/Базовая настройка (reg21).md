### Базовая настройка

---

* **HQ1 (BR1)**

  ```
  hostname HQ1
  ip domain-name worldskills.ru
  username wsruser privilege 15 secret network
  enable secret wsr
  service password-encryption
      
  aaa new-model
  aaa authentication login default local
  aaa authorization exec default local
  aaa authorization console
      
  crypto key generate rsa
  1024
  ip ssh version 2
  
  line vty 0 15
    transport input all
    exit
  
  radius-server host 172.16.20.20 auth-port 1812 acct-port 1813 key cisco
  aaa authentication login method_man local group radius
  aaa authorization exec method_man local group radius
  
  line vty 0 15
   authorization exec method_man
   login authentication method_man
   exit
      
  interface fa0/0
    no sh
    exit
  interface fa0/0.1000
  	encapsulation dot1Q 1000
  	ip address 10.0.100.1 255.255.255.0
  exit
  interface fa0/0.1200
  	encapsulation dot1Q 1200
  	ip address 172.16.20.1 255.255.255.0
  exit
  interface fa0/0.1300
  	encapsulation dot1Q 1300
  	ip address 30.78.21.1 255.255.255.0
  	ipv6 address 2001:A:B:DEAD::1/64
  exit
  
  interface FastEthernet0/1
    no sh
    exit
  interface FastEthernet0/1.10
    encapsulation dot1Q 10
    ip address 172.16.3.1 255.255.255.0
    ipv6 address 2001:4::1/64
    exit
  interface FastEthernet0/1.20
    encapsulation dot1Q 20
    ip address 30.78.87.1 255.255.255.248
    ipv6 address 2001:3::1/64
    exit
        
  interface loopback 0
  	ip address 1.1.1.1 255.255.255.255
  	ipv6 address 2001:A:B:1::1/64
  exit
  ```

* **SW1 (SW2, SW3)**

  ```
  hostname SW1
  ip domain-name worldskills.ru
  username wsruser privilege 15 secret network
  enable secret wsr
  service password-encryption
  
  aaa new-model
  aaa authentication login default local
  aaa authorization exec default local
  aaa authorization console
  
  crypto key generate rsa
  1024
  ip ssh version 2
  
  line vty 0 15
  transport input all
  exit
  
  interface vlan 1000
  	ip address 10.0.100.10 255.255.255.0
    no sh
    exit
  
  interface fa0/10
    sw mode trunk
    switchport nonegotiate
    switchport trunk allowed vlan none
    sw tr allowed vlan add 1000,1200,1300,1500,1600
    exit
  
  interface range fa0/3-4
    sw mode dynamic desirable
    sw tr allowed vlan none
    sw tr allowed vlan add 1000,1200,1300,1500,1600
    sw trunk native vlan 1500
    channel-group 2 mode desirable
    exit
    
  interface range fa0/5-6
    sw mode dynamic desirable
    sw tr allowed vlan none
    sw tr allowed vlan add 1000,1200,1300,1500,1600
    sw trunk native vlan 1500
    channel-group 1 mode active
    exit
  ```

* FW1

  ```
  hostname FW1
  domain-name worldskills.ru
  username wsruser password network privilege 15
  enable secret wsr
  
  password encryption aes
  
  aaa authentication enable console LOCAL
  aaa authentication ssh console LOCAL
  aaa authentication telnet console LOCAL
  ???? aaa authorization exec LOCAL
  ```

  

