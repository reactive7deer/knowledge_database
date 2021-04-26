### OSPF (Open Shortest Path First)

---
#### Пример

```
router ospf 1
 passive-interface default
 no passive-interface FastEthernet0/1.10
 no passive-interface Tunnel1
 network 10.0.100.0 0.0.0.255 area 51
 network 172.16.1.0 0.0.0.255 area 0
 network 172.16.3.0 0.0.0.255 area 0
 network 172.16.20.0 0.0.0.255 area 51
```



#### Этапы настройки

1. Создать процесс **OSPF** с номером предложенным в задании (номера так же могут быть использованны случайным образом)
2. Перечислить примыкающие подсети (**directly connect**) с указанием зоны (**area**) 
   * ~~**Используется обратная маска!**~~ Но и прямая сойдет
3. Перечилить имена интерфейсов, на которых будет заблокирована рассылка
   * `passive interface default` - блокирует все интерфейсы. Разблокировать интерфейс можно командой `no passive interface <...>`
   * `passive interface <...>` - блокирует конкретный интерфейс



#### Проверка

`show ip ospf`

`show ip bgp neighbor`

