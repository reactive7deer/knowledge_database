### DHCP

##### Установка

`apt install isc-dhcp-server`

##### Связанные файлы

* **/etc/default/isc-dhcp-server** - файл для указания интерфейсов, на которых DHCP-сервер будет ожидать запросы;
* **/etc/dhcp/dhcpd.conf** - основной файл конфигурации DHCP-сервера для IPv4-адресов (подсети, группы подсетей, одиночные хосты);
* **/usr/share/doc/isc-dhcp-server**/ - хранилище доков по DHCP-серверу (есть бэкап файла конфигурации);
* **/var/lib/dhcp/dhcp.leases** - файл учета выданных адресов.



##### Управление DHCP-сервером

`service isc-dhcp-server status`

`service isc-dhcp-server restart`

##### Конфигурирование

1. **Общие настройки** (заголовок файла, распространяет на все указанные далее подсети, если в них не будет произведено переопределение)

   - Домен (`option domain-names "example.ru";`)

   - Адреса DNS-серверов (`option domain-name-servers 8.8.8.8 1.1.1.1;`)

   - Время аренды адреса:

     (`default-lease-time 600;`  `max-lease-time 7200;`)

2. **Подсети** (указание параметров для конкретной подсети)

   - Адрес обслуживаемой подсети и ее маска (`subnet 1.0.0.0 netmask 255.255.255.0 {    }`):

     - Диапазон выдаваемых адресов (может быть несколько) (`range ... [от] ... [до];`)

     - Домен (`option domain-names "example.ru";`)

     - Адреса DNS-серверов (`option domain-name-servers 8.8.8.8 1.1.1.1;`)

     - Шлюз по умолчанию (`option routers 1.0.0.100;`)

     - Широковещательный адрес (`option broadcast-address 1.0.0.255;`)

     - Время аренды адреса:

       (`default-lease-time 600;`  `max-lease-time 7200;`)

       

     - **Фиксированный адрес** (`host HostName {    }`)

       - MAC-адрес хоста (`hardware ethernet ... ;`)
       - Назначенный адрес (`fixed-address ... ;`)

   

3. **shared-network**

   **Дописывается* *



#### DDNS

1. Включить использование ddns и выбрать режим работы, а также разрешить формирование записей о хостах с фиксированным адресом

   ```
   ddns-updates on;
   ddns-update-style standard;
   update-static-leases on;
   ```

2. Указать названия префиксов для прямой и обратной зоны

   ```
   ddns-domainname "skill39.wsr";
   ddns-rev-domainname "in-addr.arpa";
   ```

3. Создать блоки зон для обновления (с адресом DNS-сервера)

   ```
   zone skill39.wsr. {
   	primary 172.16.20.10;
   }
   zone 16.172.in-addr.arpa. {
   	primary 172.16.20.10;
   }
   ```

4. В блоке подсети, данные которой должны динамически обновляться на DNS-сервере, указать параметр `ddns-updates on;`







#### Источники

* https://linux.die.net/man/5/dhcpd.conf