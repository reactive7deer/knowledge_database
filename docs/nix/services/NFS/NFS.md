# NFS





## Сервер

1. Установить необходимые компоненты (`nfs-utils` включаются в себя `nfs-server` и `rpcbind`(не требуется для nfs весрии 4 и выше)) и запустить/добавить в автозагрузку их.

   ```
   dnf install nfs-utils
   
   systemctl start nfs-server rpcbind
   systemctl enable nfs-server rpcbind
   ```

2. Создать директорию которую будет раздавать NFS-сервер и назначить ей права доступа

   ```
   mkdir -p /opt/share
   chmod -R 777 /opt/share
   ```

3. В конфигурационном файле необходимо создать запись о параметрах предоставления доступа к шаре

   ```
   nano /etc/exports
   ~
   /backup/nfs 192.168.1.0/24(rw,sync,no_root_squash,no_all_squash)
   ```

   , где -

   * `/backup/nfs` - путь к директории
   * `192.168.1.0/24` - сеть, пользователям которой будет открыт доступ (без указания маски можно ограничить доступ для конкретного адреса)
   * `(rw,sync,no_root_squash,no_all_squash)` - опции

   Перечень опций:

   - **rw** - разрешить чтение и запись в этой папке;
   - **ro** - разрешить только чтение;
   - **sync** - отвечать на следующие запросы только тогда, когда данные будут сохранены на диск (по умолчанию);
   - **async** - не блокировать подключения пока данные записываются на диск;
   - **secure** - использовать для соединения только порты ниже 1024;
   - **insecure** - использовать любые порты;
   - **nohide** - не скрывать поддиректории при, открытии доступа к нескольким директориям;
   - **root_squash** - подменять запросы от root на анонимные, используется по умолчанию;
   - **no_root_squash** - не подменять запросы от root на анонимные;
   - **all_squash** - превращать все запросы в анонимные;
   - **subtree_check** - проверять не пытается ли пользователь выйти за пределы экспортированной папки;
   - **no_subtree_check** - отключить проверку обращения к экспортированной папке, улучшает производительность, но снижает безопасность, можно использовать когда экспортируется раздел диска;
   - **anonuid** и **anongid** - указывает uid и gid для анонимного пользователя.

4. Необходимо применить новые настройки и перезапустиь сервис

   ````
   exportfs -a
   systemctl restart nfs-server
   ````

   

## Клиент

1. Необходимо установить пакет `nfs-utils`

2. Проверить ручное монтирование удаленной шары

   ```
   mkdir /mnt/share
   mount 10.0.2.5:/opt/share /mnt/share	#10.0.2.5 - адрес NFS-сервера
   ```

3. После чего можно создать .mount файл для автоматического монтирования шары при запуске

   ```
   cd /etc/systemd/system
   nano mnt-share.mount	#В названии заложен путь куда будет происходить монтирование
   
   [Unit]
   Description=Mount NFS share
   
   [Mount]
   What=10.0.2.5:/opt/share
   Where=/mnt/share
   Type=nfs
   Options=defaults
   
   [Install]
   WantedBy=multi-user.target
   ```

4. Добавить данный .mount файл в автозагрузку и перезапустиь машину

   ```
   systemctl enable mnt-share.mount
   reboot
   ```

   







## Источники

https://winitpro.ru/index.php/2020/06/05/ustanovka-nastrojka-nfs-servera-i-klienta-linux/

https://losst.ru/nastrojka-nfs-v-ubuntu-16-04

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04-ru

https://andreyex.ru/operacionnaya-sistema-linux/kak-nastroit-nfs-network-file-system-na-rhel-centos-fedora-i-debian-ubuntu/