### Базовая адресация на машинах



* **Debian**

  Основную настройку сети можно выполнить, редактируя конфигурационный файл **`interfaces`**. Расположение - **`/etc/network/interfaces`**. 

* **CentOS**

  Начиная с **версии 8**, основным методом настройки сети стал **Network-Manager**. Для редактирования настроек сети посредством конфигов, необходимо установить дополнительные пакеты:

  `yum install network-scripts`

  `dnf install network-scripts`



Здесь Вы можете задать:

* IP адрес сетевой карты (или использовать DHCP);
* Настроить маршрутизацию;
* IP masquerading;
* Установить маршрут по умолчанию 
* и другое.



Для того что бы интерфейс автоматически инициализировался при загрузке, не забудьте добавить строчку **'auto'**.

Полный список опций можно найти в **`man interfaces`**.



### Автоматическое конфигурирование интерфейса с использованием DHCP

```shell
    # Интерфейс будет автоматически инициализироваться (auto)
    # allow-hotplug (?)
    
    auto eth0
    allow-hotplug eth0
    iface eth0 inet dhcp
```



### Ручное конфигурирование интерфейса

Если Вы хотите сконфигурировать вручную, можно задать: сеть, широковещательный адрес или шлюз:

* **IPv4** (Debian)

   ```shell
       auto eth0
       iface eth0 inet static
           address 192.168.0.7
           netmask 255.255.255.0
           gateway 192.168.0.254
   ```

* **IPv6 ** (Debian)

   ```shell
       iface eth0 inet6 static
           address 2001:db8::c0ca:1eaf
           netmask 64
           gateway 2001:db8::1ead:ed:beef
           autoconf 0 // disable IPv6 autoconf
   ```

* **Loopback** (second address) (Debian)

  ```
  auto lo lo:1
  iface lo inet loopback
iface lo:1 inet static
  address 1.1.1.1
  netmask 255.255.255.255
  ```
  





* **CentOS**

  Путь -  `/etc/sysconfig/network-scripts/ifcfg-***`, где *** - имя интерфейса
  
  ```
  BOOTPROTO=none // DHCP
  DEFROUTE=yes
  IPADDR=192.168.100.1
  PREFIX=24
  GATEWAY=20.20.20.10
  NAME=enp0s8
  DEVICE=enp0s8
  IPV6INIT=yes
  DHCPV6C=yes // DHCPv6
  IPV6ADDR=3001:2:3::1005/120
  IPV6_DEFAULTGW=3001:2:3::1001
  ```
  
  **Включить IPv6** - добавить в `/etc/sysconfig/network` строку `NETWORKING_IPV6=yes`
  
  
  
* **Loopback** (second address) (CentOS)

  > Необходимо включить и добавить в автозапуск сервис **`network`**, без этого не поднимается дополнительный адрес на loopback интерфейсе

  Путь -  `/etc/sysconfig/network-scripts/ifcfg-lo`. 

  Необходимо создать копию файла с измененным названием: `cp ifcfg-lo ifcfg-lo:1`.
  
  ```
  DEVICE=lo:1
  IPADDR=1.1.1.1
  NETMASK=255.255.255.255
ONBOOT=yes
  ```
  
  **Для применения результата необходимо перезагрузить сеть: **
  
  **`systemctl restart network`**





### nmcli (Network Manager)

**`nmcli`** [*`OPTIONS`*...] **{ `help` | `general` | `networking` | `radio` | `connection` | `device` | `agent` | `monitor` }** [*`COMMAND`*] [*`ARGUMENTS`*...]



```
nmcli --help
```

```
nmcli connection help

nmcli device modify ...
```

```
nmcli device help 

nmcli device modify ens1 ipv4.method manual ipv4.addresses "172.16.0.1/24" ipv4.gateway "172.16.0.254/24"
```





#### Источники

* https://computingforgeeks.com/adding-a-secondary-ip-address-to-rhel-centos-8-network-interface/
* https://ma.ttias.be/how-to-add-secondary-ip-alias-on-network-interface-in-rhel-centos-7/
* http://hudson.su/2010/04/09/add-two-or-more-ips-in-centos/
* http://linux.mixed-spb.ru/network/centos-tcpip.php