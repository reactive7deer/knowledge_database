### DHCP (Cisco)

---

#### Этапы конфигурации

1. Создать **пул для подсети** с необходимыми параметрами

   ```
   ip dhcp pool NAME                             
    network 192.168.20.0 255.255.255.0
    default-router 192.168.20.1
    domain-name test.kv.ua   #Опционально
    dns-server 192.168.20.101   #Опционально
    option 42 ip 172.16.20.20   #Опционально (NTP-server)
   ```

2. Создать **пул для хоста** чтобы назначить статический адрес

   ```
   ip dhcp pool PC1
    host 30.78.21.10 255.255.255.0   #Назначаемый адрес
    client-identifier 0100.5056.90a1.bb   # 01/00 + MAC-address
    client-name PC1
    option 42 ip 172.16.20.20
    default-router 30.78.21.1
   ```

3. Исключить уже занятые адреса

   ```
   ip dhcp excluded-address 30.78.21.1
   ```

   

#### Пример

```
ip dhcp excluded-address 30.78.21.1

ip dhcp pool OFFICE
 network 30.78.21.0 255.255.255.0
 default-router 30.78.21.1
 option 42 ip 172.16.20.20
 
ip dhcp pool PC1
 host 30.78.21.10 255.255.255.0
 client-identifier 0100.5056.90a1.bb
 client-name PC1
 option 42 ip 172.16.20.20
 default-router 30.78.21.1
```



#### Команды

* `show ip dhcp ...`
* `clear ip dhcp binding *`