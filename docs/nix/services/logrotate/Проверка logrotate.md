### Проверка logrotate

---

* Конфигурация для логов **L-SRV**

  ```
  ###/etc/logrotate.d/l-srv-auth
  
  /opt/logs/L-SRV/auth.log {
          size 1M
          rotate 5
          compress
  }
  ```

* Конфигурация для логов **L-FW**

  ```
  ###/etc/logrotate.d/l-fw-error
  
  /opt/logs/L-FW/error.log {
          size 1M
          rotate 5
          compress
  }
  ```