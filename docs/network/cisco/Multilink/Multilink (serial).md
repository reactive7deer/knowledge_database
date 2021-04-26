### Multilink (serial)

---

1. Виртуальный интерфейс (**Multilink**)

   * Создать отдельный интерфейс **Multilink <№>**
     ```
     int multilink 1
     ```
     
   * Адрес может быть установлен вручную (**ip address x.x.x.x y.y.y.y**) или получен с противоположной стороны (**ip address negotiated**)
   
     ```
     ip address negotiated
     ```
     
   * Указать адрес противоположной стороны
   
     ```
     peer default ip address <...>
     ```

   * Включение поддержки **multilink** и создание группы для интерфейсов
   
     ```
     ppp multilink
     ppp multilink group 1
     ```
     
   * Включить интерфейс
   
     ```
     no sh
     ```

2. Физический интерфейс (**Serial**)

   ```
   (conf)# int se0/0/0
   ```

   * Удалить адрес

     ```
     (conf-if)# no ip add
     ```

   * Включение поддержки **multilink** и указание принадлежность к определенной группе

     ```
     ppp mult
     ppp mult group 1
     ```

   * Включить интерфейс

     ```
     no sh
     ```



#### Проверка

`BR1# show ip int brief`



#### Пример

```
int multilink 1
  ip address negotiated 
  peer default ip address 100.45.5.1
  ppp multilink
  ppp multilink group 1
  no sh

int serial 0/0
  no ip address
  ppp mult
  ppp mult gr 1
  no sh
```

