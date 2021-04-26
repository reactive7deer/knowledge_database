# AAA (Radius)

---

```
aaa group server radius RAD_AUTH
 server-private 192.168.10.100 auth-port 1812 acct-port 1813 key cisco
!
aaa authentication login method_man group RAD_AUTH local
aaa authorization exec method_man group RAD_AUTH local 

line vty 0 15
 password 7 0822455D0A16
 authorization exec method_man
 login authentication method_man
 transport input all
```

1. Создаем группу серверов и добавляем туда `server-private` (адрес, порты, ключ)
2. Объявляем параметры ААА для нового метода с использованием группы Radius серверов
3. Назначаем новый метод на необходимые линии (изначально они используют `default`)