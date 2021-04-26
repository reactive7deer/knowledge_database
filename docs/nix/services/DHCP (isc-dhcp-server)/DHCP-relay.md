### DHCP-relay

**Задача DHCP-relay** - перенаправление DHCP-запросов DHCP-серверу из подсетей (широковещательных доменов) не имеющих своего DHCP-сервера



#### Установка

`apt install isc-dhcp-relay`



#### Связанные файлы

* **/etc/default/isc-dhcp-relay** - файл конфигурации.



#### Управление

`dhcrelay -4 10.0.0.1`

, где:	`-4` - использование IPv4

​			`10.0.0.1` - адрес DHCP-сервера для обращения





#### Пример:

```
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="172.16.50.2"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="ens33 ens36"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""
```
