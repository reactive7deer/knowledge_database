# HSRP (Hot Standby Router Protocol)

Проприетарный протокол **Cisco**, предназначенный для увеличения доступности маршрутизаторов выполняющих роль [шлюза по умолчанию](http://xgu.ru/wiki/Маршрут_по_умолчанию). Это достигается путём объединения маршрутизаторов в *standby группу* и назначения им общего [IP-адреса](http://xgu.ru/wiki/IP-адрес), который и будет использоваться как шлюз по умолчанию для компьютеров в сети.

**HSRP** (и **VRRP**) позволяют нескольким маршрутизаторам участвовать в сконфигурированной виртуальной группе маршрутизаторов с **общим виртуальным IP-адресом**. Один член группы выбирается **активным маршрутизатором**, в то время как **другие остаются неактивными** до тех пор, **пока не произойдет сбой** с активным маршрутизатором. При этом эти резервные маршрутизаторы обладают ресурсами, которые почти не используются в течение всего времени эксплуатации этой системы.





## Настройка

```
[R1]
interface gi0/0
	standby 10 ip XX.XX.XX.XX
	standby 10 priority XX
	
[R2]
interface gi0/1
	standby 10 ip XX.XX.XX.XX
	standby 10 priority XX
```







## Источники

http://xgu.ru/wiki/HSRP#HSRP_.D0.B2_Cisco

http://xgu.ru/wiki/HSRP_%D0%B2_Cisco#.D0.9D.D0.B0.D1.81.D1.82.D1.80.D0.BE.D0.B9.D0.BA.D0.B0_.D0.BD.D0.B0_.D0.BC.D0.B0.D1.80.D1.88.D1.80.D1.83.D1.82.D0.B8.D0.B7.D0.B0.D1.82.D0.BE.D1.80.D0.B0.D1.85_.D0.B8_.D0.BA.D0.BE.D0.BC.D0.BC.D1.83.D1.82.D0.B0.D1.82.D0.BE.D1.80.D0.B0.D1.85