### User views

---

#### Пример

```c
(exec) enable view
(config) parser view sh_view
     secret 5 $1$wt9V$Et.V2SRTW66OqcDxngtS20
     commands exec include all traceroute
     commands exec include all ping
     commands exec include all show ip
     commands exec include show cdp neighbors
     commands exec include show cdp
     commands exec include show
 
#В данном примере, пользователю будут разрешены команды traceroute, ping и show ip со всеми доступными субкомандами, а так же только команды show cdp и show cdp neighbors.
    
username user2 view sh_view secret cisco
```



#### Конфигурация

1. Находясь в **EXEC режиме**, активировать «Root View» командой «**enable view**«. Запросит Enable пароль — его нужно задать ранее, знать и ввести. После чего вы окажитесь в «root view». Проверить можно командой «**show parser view**«, она должна вывести строку: **«Current view is ‘root'»**

2. В режиме глобальной конфигурации создать **view** и перейти в режим конфигурирования **view**, команда: «**parser** **view** *view-name*«

3. В режиме конфигурирования view задать пароль для данного view, команда: «**secret 0** *PasswordView*«

4. В режиме конфигурирования view задать разрешенные команды для данного **view**, команда:

   «**commands** *parser-mode* {**include** | **include-exclusive** | **exclude**} [**all**] [**interface** *interface-name | command*]»

   , где -

   * `parser-mode` — режим, в котором указанные команды вводятся.
     * `include` — добавляет команду *command* или интерфейс *interface-name* для данного view *view-name*
     * `include-exclusive` — добавляет команду *command* или интерфейс *interface-name* для данного view *view-name*,  и исключает её из всех остальных view
     * `exclude` **—** исключает команду *command* или интерфейс *interface-name* из данного view *view-name*
   * `all` — подразумевает все команды для заданного режима *parser-mode*

6. Вернуться в режим **EXEC** (Ctrl + Z)

7. Для того, что бы перейти в созданный view и проверить, какие команды доступны из под него, можно выполнить команду:

   **enable** **view** *view-name*

   * Знак "?" - список доступных команд

   * `exit` - выход из выбранного view

8. Если использовать локальную базу пользователей, то в режиме глобального конфигурирования можно создать пользователя, которому будет сопоставлен какой-либо из созданных **view** либо **superview** (включающий в себя несколько отдельных view).

    **username** *user* **view** *view-name* **secret** **0** *userpassword*



#### Команды

* `show parser view all` - список **view** доступных в системе



#### Источники

* http://www.adminia.ru/cisco-cli-views-role-based-cli-access/

