### HDLC (serial)

---

1.  Физический интерфейс (**Serial**)

```
(conf)# int se0/0/0
```

* Указать инкапсуляцию **HDLC**

  ```
  BR1(config-if)#encapsulation hdlc
  ```

* Указать адрес 

  ```
  BR1(config-if)#ip address 
  ```

* Включить интерфейс

  ```
  no sh
  ```



#### Проверка

`BR1# show ip int brief`



#### Пример

```
BR1(config)#int serial 0/2
BR1(config-if)#encapsulation hdlc
BR1(config-if)#ip address 22.84.4.2 255.255.255.252
BR1(config-if)#no sh
BR1(config-if)#exit
```