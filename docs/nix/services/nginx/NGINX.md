### NGINX

---

#### Установка

* CentOS

  `dnf install nginx`

* Debian

  `...`



#### Файлы

* `/etc/nginx` - основная директория
* `/etc/nginx/nginx.conf` - основной конфиг + конфиг сайта по умолчанию
* `/etc/nginx/conf.d` - директория с подключаемыми конфигами для новых серверов или прокси





#### Этапы конфигурации

1. В файле /etc/nginx/nginx.conf закоментировали область `server {  }` и проверили наличие строчки `include /etc/nginx/conf.d/*.conf;`

2. Создали новый конфигурационный файл (`*.conf`) в `/etc/nginx/conf.d` со следующим содержанием

   ```
   server {
   	listen 80;
   	location / {
   		proxy_pass http://192.168.20.10:8088;
   	}
   }
   ```

   , где - 

   * `listen 80` - номер порта на котором будет ожидать запрос прокси сервер
   * `proxy_pass http://192.168.20.10:8088;` - внутренний адес веб-сервера с кастомным портом

3. Включили автозапуск и запустили службу

   ```
   systemctl enable nginx
   systemctl start nginx
   ```

   

