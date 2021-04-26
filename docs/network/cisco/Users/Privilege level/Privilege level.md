### Privilege level

---

#### Пример

```c
username user1 privilege 5 secret cisco

#Для пользователя обладающего 5 уровнем, в режиме EXEC будет доступна команда перезагрузки
privilege exec level 5 reload
privilege exec level 5 no debug
privilege exec level 5 debug
privilege exec level 5 no
```



#### Конфигурация

1. Создать пользователя и назначить ему необходимый уровень привелегий (1)
2. Настроить доступные в назначенном уровне привелегий команды (2-5)



#### Источники

* http://www.adminia.ru/cisco-privilege-nastroyka-privilegiy-polzovatelya-cisco/