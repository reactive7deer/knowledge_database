### L2TP

---

#### Пример

```
aaa authentication ppp default local
aaa authorization network default local

username pc2user pass pc2pass

interface FastEthernet0/0
 ip address 192.168.2.1 255.255.255.0
 no sh

vpdn enable
vpdn-group 1
 accept-dialin
 protocol l2tp
 virtual-template 1
 no l2tp tunnel authentication

ip local pool l2tp 10.8.8.10

interface Virtual-Template1
 ip address 10.8.8.1 255.255.255.0
 peer default ip address pool l2tp
 ppp authentication pap callout
```



#### Конфигурирование

1. Для возможности аутентификации и авторизации абонентов использующих L2TP соединение, необходимо добавить новые правила в **модель ААА** (1-2)
2. Создать пользователя на устройстве для авторизации (4)
3. Затем следует добавить адрес на физический интерфейс (в сторону клиента) и включить его (6-8)
4. После чего необходимо включить **vpdn** и создать новую **vpdn-группу**, с необходимыми параметрами (10-15)
5. Затем создается пул адресов, который будет выдаваться для подключающихся абонентов (17)
6. После чего создается интерфейс **Virtual-Template** и на нем указывается адрес, который будет являться шлюзом в абонентской сети, привязывается пул адресов для сети абонентов и задается параметр ppp аутентификации (19-22)


