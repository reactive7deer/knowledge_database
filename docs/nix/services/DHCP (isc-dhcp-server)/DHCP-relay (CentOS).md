### DHCP-relay (CentOS)

**Задача DHCP-relay** - перенаправление DHCP-запросов DHCP-серверу из подсетей (широковещательных доменов) не имеющих своего DHCP-сервера



#### Установка

`dnf install dhcp-relay`



#### Связанные файлы

* `/lib/systemd/system/dhcrelay.service` - базовый файл
* `/etc/systemd/system/dhcrelay.service` - файл в работе



#### Управление



#### Конфигурация

1. Необходимо создать копию файла `dhcrelay.service` в папке `/etc/systemd/system` и открыть его для редактирования

   ```с
   cp /lib/systemd/system/dhcrelay.service /etc/systemd/system/
   nano /etc/systemd/system/dhcrelay.service
   ```

2. Необходимо изменить содержимае файла, указав адрес DHCP-server принимающего запросы

   ```с
   ExecStart=/usr/sbin/dhcrelay -d --no-pid 172.16.50.2
   ```

   Можно также указать интерфейс для работы **dhcrelay** сразу после адреса (но неизвестно, можно ли указывать несколько интерфейсов, так как необходимы минимум 2: прием запросов и ответов)

   ```
   ... 172.16.50.2 -i ens100
   ```

3. После этого необходимо запустить/перезагрузить сервис **dhcrelay** и добавить его в автозагрузку

   ```
   systemctl enable dhcrelay
   systemctl start dhcrelay
   ```

   

#### Источники

* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/dhcp-relay-agent