### EIGRP (IPv6)

---

#### Пример

```
ipv6 router eigrp 6000

interface FastEthernet0/0.1300
 ipv6 address 2001:A:B:DEAD::1/64
 ipv6 enable
 ipv6 eigrp 6000
 
interface FastEthernet0/1.10
 ipv6 address 2001:4::1/64
 ipv6 enable
 ipv6 eigrp 6000
 
interface FastEthernet0/1.20
 ipv6 address 2001:3::1/64
 ipv6 enable
 ipv6 eigrp 6000
```



#### Конфигурирование

1. В режиме глобальной конфигурации запускаем **EIGRP** процесс с нужным номером

2. Указываем на каждом интерфейсе `ipv6 eigrp №XXXX`, чтобы добавить в анонс указанную на интерфейсе IPv6 подсеть




#### Особенности

* Если каким-то образом, одна и так же сеть будет приходить на устройство по **eBGP** и по **EIGRP** - место в таблице маршрутизации займет маршрут от **eBGP**

  Для того, чтобы убедиться в корректной работе **EIGRP** - `show ipv6 eigrp topology`



#### Команды

* `show ipv6 eigrp neighbors`
* `show ipv6 route eigrp`
* `show ipv6 eigrp topology` - список получаемых маршрутов





## Источники

https://wiki.merionet.ru/seti/40/ponimanie-eigrp-obzor-bazovaya-konfiguraciya-i-proverka/

http://xgu.ru/wiki/EIGRP#.D0.91.D0.B0.D0.B7.D0.BE.D0.B2.D1.8B.D0.B5_.D0.BD.D0.B0.D1.81.D1.82.D1.80.D0.BE.D0.B9.D0.BA.D0.B8

