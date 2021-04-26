### DHCP snooping

---

#### Пример

```
ip dhcp snooping
ip dhcp snooping vlan 100
ip dhcp snooping database flash:/имя_файла
interface GigabitEthernet 1/0/1
	ip dhcp snooping trust
```



#### Конфигурация

1. Включаем глобально **DHCP snoopig** на коммутаторе

2. Затем включаем DHCP snooping **в нужном VLAN**

3. При необходимости, можно указать путь размещения базы назначений адресов

4. Указываем доверенные порты, для этого переходим к конфигурации нужных нам портов и объявляем их доверенными

   **Следует учесть, такой момент,** если у вас в качестве UpLink выступает Etherchannel нужно сделать доверенным **не только сам интерфейс Port-channel**, но и **физические интерфейсы**, которые являются его членами.





#### Команды

* `show ip dhcp snooping` - состояние DHCP snooping





#### Источники

* http://prosto-seti.blogspot.com/2016/07/dhcp-snooping.html?m=1