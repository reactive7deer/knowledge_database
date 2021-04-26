### CentOS-Media 

---

**CentOS-Media** - заранее подготовленный .repo файл, для установки пакетов имеющихся на установочном диске.

**Расположение** - `/etc/yum.repos.d/`

#### Использование

1. Подключить установочный диск к системе (**например**, sr0)

   ```bash
   [root@centos-vm ~]# lsblk
   NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   sda           8:0    0   20G  0 disk
   ├─sda1        8:1    0    1G  0 part /boot
   └─sda2        8:2    0   19G  0 part
     ├─cl-root 253:0    0   17G  0 lvm  /
     └─cl-swap 253:1    0    2G  0 lvm  [SWAP]
   sr0          11:0    1  7.7G  0 rom  
   ```

2. Смонтировать диск в одну из предложенных в файле директорий (/**media/CentOS**, **/media/cdrom**, **/media/cdrecoder**)

   `mount /dev/sr0 /media/CentOS`

3. Отключить (переместить) все остальные файлы **.repo** либо воспользоваться опциями **dnf**

   `dnf --disablerepo=\* --enablerepo=c8-media-* [command]`

   - **При обновлении кэша пакетов** (`dnf --disablerepo=\* --enablerepo=c8-media-* makecache`) поиск можно осуществлять **без отключения** остальных репозиториев



---



**Ответ**: нет, надо редактировать файл репы.

**Шаг 1**: Создаем точку монтирование и монтируем DVD
`mkdir /mnt/rhel-dvd && mount /dev/cdrom /mnt/rhel-dvd`

**Шаг 2**: Создаем конфигурационный файл ‘rhel-dvd.repo’
`touch /etc/yum.repos.d/rhel-dvd.repo`

**Шаг 3**: Добавляем следующие строки в ‘rhel-dvd.repo’
```javascript
[rhel-dvd]
name=Red Hat Enterprise Linux DVD
baseurl=file:///mnt/rhel-dvd/
enabled=1
gpgcheck=0
```

**Шаг 4**: Чистим кэш
`yum clean all`