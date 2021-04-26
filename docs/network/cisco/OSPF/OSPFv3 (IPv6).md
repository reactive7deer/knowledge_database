# OSPFv

#### Пример

```
interface tun100
	ipv6 address 2001::11/64
	ipv6 ospf 1 area 0 		# Где ospf 1 - номер процесса, а area 0 - зона
```



#### Этапы настройки

1. На интерфейсах которые должны будут анонсировать свои сети, включается OSPF процесс и определяется зона

2. С целью ограничения установления соседских связей между отдельными маршрутизаторами можно настраивать несколько экземпляров OSPFv3-процесса:

   ```
   (config-if)# ipv6 ospf <process> area <area ID> instance <instance ID>
   ```

   

#### Проверка

`show ipv6 ospf`

`show ipv6 ospf neighbor`





## Источники

http://4isp.blogspot.com/2010/12/ospfv3.html

http://blog.evgenybelkin.ru/2011/07/ospfv3-ipv6.html

http://xgu.ru/wiki/OSPFv3