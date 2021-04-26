### HDLC (serial)

---

```bash
int se0/0/0
 # Указать инкапсуляцию HDLC
 encapsulation hdlc
 ip address $ADDR
 no sh
```

#### Проверка

```bash
BR1# show ip int brief

```

#### Пример

```bash
int serial 0/2
 encapsulation hdlc
 ip address 22.84.4.2 255.255.255.252
 no sh
 exit
```