# BGP (Border Gateway Protocol)

---
## Пример

```
router bgp 65010
 bgp log-neighbor-changes
 network 3.3.3.3 mask 255.255.255.255
 network 22.84.4.0 mask 255.255.255.252
 network 100.45.5.0 mask 255.255.255.252
 neighbor 22.84.4.1 remote-as 65002
 neighbor 22.84.4.1 prefix-list PRL-ISP-in in
 neighbor 100.45.5.1 remote-as 65001
 neighbor 100.45.5.1 prefix-list PRL-ISP-in in
```



## Этапы настройки

1. Создать процесс **BGP** с номером соответсвующим номеру **АС** (Автономной системы)
   * На **ASA** требуется перейти в подрежим командой `address-family ipv4`
2. Перечислить подключенные подсети (**directly connect**)
3. Указать соседей (устройства) (**адрес и принадлежность к АС**)
   * **iBGP** (interior BGP) - устройства в одной АС. 
     * Указывается **такой же номер АС**, тем самым система определяет его как **iBGP**
   * **eBGP** (exterior BGP) - соседи из других АС
4. Указать описания для соседей
5. Активировать семество адресов (`heighbor x.x.x.x activate`)



* **Ограничение по префиксам**

  ```bash
  # Создать prefix-list
  (config) ip prefix-list NAME deny x.x.x.x/32    #Запрещает конкретный префикс
  		 ip prefix-list NAME permit 0.0.0.0/0 le 32	   #Разрешает остальные префиксы
  
  (config) router bgp 65000
            neigh x.x.x.x prefix-list NAME in #Установить prefix-list на получение
  ```

  

#### Проверка

`show ip bgp`

`show ip bgp summary`

`show ip route bgp`