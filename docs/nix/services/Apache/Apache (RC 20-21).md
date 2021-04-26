### Apache

---



#### Установка

* CentOS

  `dnf install httpd` + `php`

* Debian

  `...`



#### Файлы

* `/etc/httpd/conf/httpd.conf` - конфигурация сервера







#### Конфигурация





#### Этапы настройки

1. Изменили порт для прослушивания и адрес расположения файлов сайта

   * `Listen 80` > `Listen 8088`

   * `DocumentRoot "/var/www/html"` > `DocumentRoot "/var/www/html/out"`

2. Создали новую директорию

   ```
   mkdir /var/www/html/out
   cd /var/www/html/out
   ```

3. Создали два файла согласно задания с расширениями .html и .php

   `touch index.html`

   ```
   Hello, www.skill39.wsr is here!
   ```

   `touch date.php`

   ```php
   <?php
   date_default_timezone_set ('UTC');
   echo (date("Y-m-d H:i:s"));
   ?>
   ```

4. **Firewalld** либо отлючить, либо внести исключающее правило

   `firewall-cmd --permanent --zone=public --addforward=port=80:proto=tcp:toport=80:toaddr=192.168.20.10  `

5. Включили автозапуск и запустили службу

   ```
   systemctl enable httpd
   systemctl start httpd
   ```

   

