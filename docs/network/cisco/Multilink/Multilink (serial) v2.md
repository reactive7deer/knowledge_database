### Multilink (serial)

---

1. Виртуальный интерфейс (**Multilink**)

    ```bash
   # Создать отдельный интерфейс Multilink <№>
   int multilink 1
    # Получить адрес автоматически (также может быть установлен вручную)
    ip address negotiated
    # Указать адрес противоположной стороны
    peer default ip address $PEERADDR
    # Включение поддержки multilink и создание группы для интерфейсов
    ppp multilink
    ppp multilink group 1
    no sh
   ```

2. Физический интерфейс (**Serial**)

   ```bash
   int se0/0/0
    # Удалить адрес (поскольку он будет установлен на multilink)
    no ip address
    # Включение поддержки multilink и определенную группу
    ppp multilink
    ppp multilink group 1
    no sh
   ```
   
### Проверка

```bash
BR1# show ip int brief
???
```


#### Пример

```bash
int multilink 1
 ip address negotiated 
 peer default ip address 100.45.5.1
 ppp multilink
 ppp multilink group 1
 no sh

int serial 0/0
 no ip address
 enc ppp
 ppp mult
 ppp mult gr 1
 no sh
 exit
```