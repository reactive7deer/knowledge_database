### SNMP

---

```c
>>  HQ  <<
snmp-server group WSR v3 priv read RO
snmp-server location MSK, Russia
snmp-server contact admin@wsr.ru
snmp-server user snmpuser WSR v3 auth sha snmppass priv aes 128 snmppass

>>  FW1  <<
snmp-server group WSR v3 priv
snmp-server location MSK, Russia
snmp-server contact admin@wsr.ru
snmp-server user snmpuser WSR v3 auth sha snmppass priv aes 128 snmpass
snmp-server host L2VPN 172.16.20.20 ver 3 snmpuser
```



#### Конфигурация

1. Создали группу  (WSR) с указанием версии протокола (на HQ добавили профиль только для чтения)  (2, 8)
2. Указали местоположение (3, 9)
3. Указали контактное лицо (4, 10)
4. Создали пользователя, указали группу к которой он принадлежит и установили методы шифрования данных и пароли (5, 11)
5. На **FW** указали адрес сервера, версию, а также имя пользователя (на HQ с и без этой опции была проблема со считыванием MIB-атрибутов)(12)



#### Команды

* `show snmp ...` (2811)
* `show snmp-server ...` (Cisco ASA)



#### Источники

* https://ru.wikipedia.org/wiki/Management_Information_Base
* https://bestmonitoringtools.com/configure-snmpv3-on-cisco-router-switch-asa-nexus-a-step-by-step-guide/#ASA_firewall