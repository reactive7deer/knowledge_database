### Samba (SMB)

---

**Samba** — это реализация сетевого протокола **SMB**. Она облегчает организацию общего доступа к файлам и принтерам между системами Linux и Windows и является альтернативой NFS.



#### Установка

* CentOS

  `dnf install samba` + `smb-client`

* Debian

  `...`



#### Файлы

* `/etc/samba` - основная директория
* `/etc/samba/smb.conf` - основной конфигурационный файл





#### Этапы настройки

1. Согласно задания создали директории

   ```bash
   mkdir /opt/Samba/shares /opt/Samba/users
   mkdir /opt/Samba/shares/workfolders
   
   cd /opt/Samba/shares/workfolders
   mkdir Work1 Work2
   
   cd /opt/Samba/users
   mkdir ldapuser1 ldapuser2
   ```

2. Создаем локальных пользователей (альтернатива LDAP)

   ```bash
   useradd -M -s /sbin/nologin ldapuser1
   useradd -M -s /sbin/nologin ldapuser2
   ```

   , где - 

   * `-M` - отказ от создания домашней директории
   * `-s /sbin/nologin` - отказ от возможности авторизоваться данным пользователем

3. Назначили новым пользователям **локальные** пароли, тем самым активирвоали их в системе

   ```bash
   passwd ldapuser1
   passwd ldapuser2
   ```

4. Добавили пользователей в базу данных **Samba** и активировали их *(опционально??)*

   ```bash
   smbpasswd -a ldapuser1
   smbpasswd -a ldapuser2
   
   smbpasswd -e ldapuser1
   smbpasswd -e ldapuser2
   ```

5. Изменили владельцев и уровни доступа для ранее созданных директорий

   ```Bash
   cd /opt/Samba/shares/workfolders
   chown ldapuser1:ldapuser1 Work1
   chmod 2750 Work1
   
   chown ldapuser2:ldapuser2 Work2
   chmod 2750 Work2
   ```

6. Перешли к изменению файла конфигурации. Добавили новые разделы

   ```bash
   [workfolders]
   	comment = workfolders
   	path = /opt/Samba/shares/workfolders
   	valid users = ldapuser1, ldapuser2
   	guest ok = No
   	browseable = Yes
   	read only = No
   	
   [Work1]
   	comment = Work1
   	path = /opt/Samba/shares/workfolders/Work1
   	valid users = ldapuser1
   	guest ok = No
   	browseable = No
   	read only = No
   	
   [Work2]
   	comment = Work2
   	path = /opt/Samba/shares/workfolders/Work2
   	valid users = ldapuser2
   	guest ok = No
   	browseable = No
   	read only = No	
   ```

7. Добавили службу в автозагрузку и запустили ее

   ```bash
   systemctl enable smb
   systemctl start smb
   ```





#### Источники

* https://interface31.ru/tech_it/2019/06/nastroyka-faylovogo-servera-samba-na-platforme-debian-ubuntu.html
* https://1cloud.ru/help/network/nastroika-samba-v-lokalnoj-seti
* https://www.dmosk.ru/instruktions.php?object=samba-centos8
* https://habr.com/ru/post/337556/
* https://linuxrussia.com/samba-access-control.html
* https://wiki.samba.org/index.php/User_Documentation
* https://wiki.archlinux.org/index.php/samba_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
* https://smb-conf.ru/