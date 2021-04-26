### Включение forwarding пакетов в Windows

---

<u>**Ребутоустойчиво**</u>

Данные команды выполняются в PowerShell:

```powershell
netsh
interface ipv4
show inerfaces
```

![image-20200922042202490](C:\Users\Delete\AppData\Roaming\Typora\typora-user-images\image-20200922042202490.png)

После данных комманд будет выведена таблица с перечислением сетевых интерфейсов. Нам необходим первый столбец "Idx".

С его значением используем следующую команду:

```
show interface 6
```

![image-20200922042317110](C:\Users\Delete\AppData\Roaming\Typora\typora-user-images\image-20200922042317110.png)

Следующей командой переводим параметр Forwarding в режим "Enable":

```
set interface 6 forwarding="enable"
```

