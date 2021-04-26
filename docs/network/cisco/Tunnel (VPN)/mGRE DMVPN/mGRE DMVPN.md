### mGRE DMVPN

---

* **Dynamic Multipoint VPN** (*DMVPN*) — виртуальная частная сеть с возможностью динамического создания туннелей между узлами.

* В топологии звезда (hub-n-spoke) использование GRE-туннелей точка-точка приведёт к большому количеству настроек, так как IP-адреса всех spoke-маршрутизаторов должны быть известны и настроены на центральном маршрутизаторе (hub).

  Альтернативой GRE-туннелей точка-точка является **multipoint GRE** (mGRE) туннель, который позволяет терминировать на себе несколько GRE-туннелей. mGRE-туннель позволяет одному GRE-интерфейсу поддерживать несколько IPsec-туннелей и упрощает количество и сложность настроек, по сравнению с GRE-туннелями точка-точка.

  Кроме того, mGRE-интерфейс позволяет использовать динамически назначенные IP-адреса на spoke-маршрутизаторах.

* **Next Hop Resolution Protocol (NHRP)** — клиент-серверный протокол преобразования адресов, позволяющий всем хостам, которые находятся в **NBMA** (Non Broadcast Multiple Access)-сети, динамически выучить **NBMA-адреса** (физические адреса) друг друга обращаясь к **next-hop-серверу** (NHS). После этого хосты могут обмениваться информацией друг с другом напрямую.



#### Конфигурация

1. Проверить связность узлов по внешним адресам

2. Настройка **mGRE**

   * Создание туннельного интерфейса

   * Задание IP-адреса на интерфейсе (сеть внутри туннеля)

   * Необходимо изменить значение **MTU** на интерфейсе (**GRE** занимает место своими заголовками)

   * Указать интерфейс-источник для туннеля

     В качестве **адреса отправителя** в пакете выходящем из **mGRE-интерфейса** будет использоваться **IP-адрес интерфейса-родителя**, а **адрес получателя** будет **выучен динамически** с помощью протокола **NHRP**.

   * Включение **mGRE-туннеля**

   ```c
   interface Tunnel1
    ip address 172.16.1.1 255.255.255.0
    ipv6 address 2001:1::1/64
    ipv6 enable
    ip mtu 1416
    tunnel source Loopback0
    tunnel mode gre multipoint
   ```

3. Настройка **NHRP**

   * **hub-маршрутизатор**

     * Включение **NHRP** на интерфейсе (2,4)

     * Hub-маршрутизатор будет автоматически добавлять соответствия между адресами spoke-маршрутизаторов (3,5)

     * *(Опционально)* Настройка аутентификации (`ip nhrp authentication nhrppass`)

       ```c
       interface Tunnel1
         ip nhrp network-id 10
         ip nhrp map multicast dynamic
           ipv6 nhrp network-id 10
           ipv6 nhrp map multicast dynamic
       ```

   * **spoke-маршрутизатор**

     * Включение **NHRP** на интерфейсе (`network-id` - разные интерфейсы могут участвовать в разных NHRP сессиях; это просто разграничитель того, что сессия NHRP на одном интерфейсе не та что на другом) (2,6)

     * Адрес **туннельного интерфейса hub-маршрутизатора** указывается как **next-hop-сервер** (nhs) (3,7)

     * Статическое соответствие между **адресом mGRE-туннеля** и **физическим адресом hub-маршрутизатора** (первый адрес — адрес туннельного интерфейса, второй — адрес внешнего физического интерфейса) (4,8)

     * **Адрес внешнего физического интерфейса hub-маршрутизатора** указывается как получатель multicast-пакетов от локального маршрутизатора (5,9)

     * *(Опционально)* Настройка аутентификации (`ip nhrp authentication nhrppass`)

       ```c
       interface Tunnel1
         ip nhrp network-id 10
         ip nhrp nhs 172.16.1.1
         ip nhrp map 172.16.1.1 1.1.1.1
         ip nhrp map multicast 1.1.1.1
           ipv6 nhrp network-id 10
           ipv6 nhrp nhs 2001:1::1
           ipv6 nhrp map 2001:1::1/64 1.1.1.1
           ipv6 nhrp map multicast 1.1.1.1
       ```

       

#### Пример

* **HQ1 (hub)**

```c
interface Tunnel1
 ip address 172.16.1.1 255.255.255.0
 ipv6 address 2001:1::1/64
 ipv6 enable
 ipv6 eigrp 6000
 tunnel source Loopback0
 tunnel mode gre multipoint
 ip mtu 1416
   ip nhrp network-id 10
   ip nhrp map multicast dynamic
     ipv6 nhrp network-id 10
     ipv6 nhrp map multicast dynamic
```

* **BR1 (spoke)**

```c
interface Tunnel1
 ip address 172.16.1.2 255.255.255.0
 ipv6 address 2001:1::2/64
 ipv6 enable
 ipv6 eigrp 6000
 tunnel source Loopback0
 tunnel mode gre multipoint
 ip mtu 1416
   ip nhrp network-id 10
   ip nhrp map multicast 1.1.1.1
   ip nhrp map 172.16.1.1 1.1.1.1
   ip nhrp nhs 172.16.1.1
     ipv6 nhrp network-id 10
     ipv6 nhrp map multicast 1.1.1.1
     ipv6 nhrp map 2001:1::1/64 1.1.1.1
     ipv6 nhrp nhs 2001:1::1
```



#### Команды

* `sh ip nhrp nhs`
* `sh ip nhrp brief`
* `sh ip nhrp `
* `sh ip nhrp multicast`





#### Источники

* http://xgu.ru/wiki/%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_DMVPN_%D0%BD%D0%B0_%D0%BC%D0%B0%D1%80%D1%88%D1%80%D1%83%D1%82%D0%B8%D0%B7%D0%B0%D1%82%D0%BE%D1%80%D0%B0%D1%85_Cisco