title: JunOS

# JunOS

## База

!!! note "Заметка"
	При входе на устройство вы можете попасть в консоль FreeBSD. Чтобы перейти в консоль JunOS, введите `cli`

### Переход в режим конфигурирования

Изначально при попадании на устройство Juniper вы оказываетесь в **Operational** режиме. Чтобы начать конфигурировать ваше устройство Juniper, нужно перейти в режим конфигурирования. Делается это вводом команды `configure` в Operational режиме.

При переходе из режима в режим ваше приветствие сменится, благодаря этому вы и можете понимать, в каком режиме находитесь:

```bash
user@host> configure 
Entering configuration mode

[edit]
user@host# 
```

Также возможно выполнение **команд Operational** режима **в режиме Configuration**. Делается это таким образом:

```bash
[edit]
user@host# run operational-mode-command
```

### Полезные комбинации клавиш

| Комбинация                                  | Действие                                                     |
| :------------------------------------------ | :----------------------------------------------------------- |
| Ctrl+b                                      | Move the cursor back one character.                          |
| **Esc+b or Alt+b**                          | **Move the cursor back one word.**                           |
| Ctrl+f                                      | Move the cursor forward one character.                       |
| **Esc+f or Alt+f**                          | **Move the cursor forward one word.**                        |
| **Ctrl+a**                                  | **Move the cursor to the beginning of the command line.**    |
| **Ctrl+e**                                  | **Move the cursor to the end of the command line.**          |
| Ctrl+h, Delete, or Backspace                | Delete the character before the cursor.                      |
| Ctrl+d                                      | Delete the character at the cursor.                          |
| Ctrl+k                                      | Delete the all characters from the cursor to the end of the command line. |
| Ctrl+u or Ctrl+x                            | Delete the all characters from the command line.             |
| **Ctrl+w, Esc+Backspace, or Alt+Backspace** | **Delete the word before the cursor.**                       |
| **Esc+d or Alt+d**                          | **Delete the word after the cursor.**                        |
| Ctrl+y                                      | Insert the most recently deleted text at the cursor.         |
| Ctrl+l                                      | Redraw the current line.                                     |
| Ctrl+p                                      | Scroll backward through the list of recently executed commands. |
| Ctrl+n                                      | Scroll forward through the list of recently executed commands. |
| Ctrl+r                                      | Search the CLI history incrementally in reverse order for lines matching the search string. |
| Esc+/ or Alt+/                              | Search the CLI history for words for which the current word is a prefix. |
| Esc+. or Alt+                               | Scroll backward through the list of recently entered words in a command line. |
| Esc+number sequence or Alt+number sequence  | Specify the number of times to execute a keyboard sequence.  |

### Полезные команды

* `show chassis routing-engine` - выводит информацию и состоянии устройства (температура, загрузка CPU и RAM и т.п.)
* `show system storage` - вывод доступных устройств хранения информации
* `request system reboot` - перезагрузка системы
* `request system power-off` - выключение системы
* `request system zeroize` - полный сброс системы - конфигурация, пользовательские файлы, логи

### Триальная лицензия для vMX

Лицензия на 60 дней для vMX:

```
E435890758 aeaqic aiagij cpabsc idycyi giydco bqgiyd
           sdapoz gvqlkk ovxgs4 dfojcx mylma4 uhfs7p
           etdlfc ex2i5k 4mo4fa ew2xbz ujzbol 4fl44z
           ya3md2 drdgjf preowc 5ubrju kyq
```

Для ввода лицензии надо в Operational режиме ввести команду `request system license add terminal` и вставить в терминал ключ выше

## Интерфейсы

###  Типы интерфейсов

* `ae` - `Aggregated Ethernet`. Виртуальный сагрегированный линк, аналог `Port-channel` у Cisco и `Eth-Trunk` у Huawei.
* `dsc` - `Discard inteface`. Если правильно понимаю, аналог `Null`.
* `et` - `100G Ethernet`.
* `fe` - `100M Ethernet`.
* `fxp` - Management interface.
* `ge` - `1G Ethernet`.
* `gr` - `GRE`. Стандартный GRE туннель.
* `ip` - `IP over IP`. Туннель инкапсуляции IP over IP.
* `lo` - `Loopback`. Стандартный петлевой интерфейс. Может быть только один в системе.
* `ml` - `Multilink`. Агрегированный интерфейс для протоколов FrameRelay и PPP.
* `mt` - `Multicast tunnel`. 
* `se` - `Serial`.
* `umd` - `USB modem`. Интерфейс, который генерируется при подключении совместимого USB модема.
* `irb` - `Integrated routing and bridging`. SVI(RVI), аналог `Vlan` у Cisco и `Vlanif` у Huawei.

### Использование unitов для передачи L2 и L3

Конфигурация ниже предоставляет возможность использовать разные unit у интерфейсов для передачи L2 и L3 трафика:

```bash
[edit interfaces]
ge-0/0/0 {
    flexible-vlan-tagging;
    # Глобальное указание native VID для всего интерфейса
    native-vlan-id 1;
    # Поддержка интерфейсов разных типов Ethernet инкапсуляции
    encapsulation flexible-ethernet-services;
    }
    # Данный юнит использует native VID 1, с него трафик передаётся без тега
    unit 1 {
        encapsulation vlan-bridge;
        family bridge {
            interface-mode trunk;
            vlan-id 1;
        }
    }
    # Данный юнит использует VID 10, с него трафик передаётся c тегом
    unit 10 {
        encapsulation vlan-bridge;
        family bridge {
            interface-mode trunk;
            vlan-id 10;
        }
    }
    # Данный юнит использует VID 777, с него трафик передаётся c тегом
    unit 777 {
        encapsulation vlan-bridge;
        family bridge {
            interface-mode trunk;
            vlan-id-list 777;
        }
    }
}
# IRB интерфейс позволяет вешать на bridge L3 функционал
irb {
    unit 1 {
        family inet {
            address 80.65.16.2/30;
        }
    }
    unit 10 {
        family inet {
            address 192.168.10.1/24;
        }
    }
}

[edit bridge-domains]
VID1 {
    # Указание VID, с которым интерфейсы будут добавляться в этот bridge-domain
    vlan-id 1;
    # Привязка L3 интерфейса к bridge-domain
    routing-interface irb.1;
}
VID10 {
    vlan-id 10;
    routing-interface irb.10;
}
# К L2 bridge-domain не добавляется irb интерфейс
VID777 {
    vlan-id 777;
}
```

В этом случае у нас есть 3 unitа на одном физическом интерфейсе, которые могут быть и L3 интерфейсами, и L2. Отличие L3 от L2 здесь в том, что к L3 bridge-domain создаётся и добавляется специальный irb интерфейс (в терминологии Cisco - `int Vlan`), который и позволяет использовать на unitе L3 функционал

!!! note "Замечание"
	Мною не был обнаружен способ конфигурирования L3 функционала на unitах интерфейса, который сконфигурирован на наличие в нем L2 юнитов. Возможно такой способ существует, просто автор его не нашёл.

## Управление конфигурацией

Конфигурация JunOS разделена на множество контекстов, которые связаны между собой иерархически.

Пример иерархии в этих контекстах:

![junos-hierarchy](../../img/junos-hierarchy.png)

### Перемещение между контекстами

Несколько команд, выполняющиеся из под режима **configure**, позволяющие перемещаться между контекстами:

| Command                  | Description                                                  |
| :----------------------- | :----------------------------------------------------------- |
| `edit {hierarchy-level}` | Редактировать конфигурацию в определённом контексте. Пример: `edit protocols ospf area 0` |
| `up`                     | Перемещает на один уровень выше в иерархии. Пример: работали в `edit protocols ospf area 0`, переместились в `edit protocols ospf` |
| `up <number>`            | Перемещает на <number> уровней выше в иерархии. Пример: работали в `edit protocols isis interface ge-0/0/0.0 family inet`, написали `up 3`, переместились в `edit protocols` |
| `top`                    | Перемещает на самый верх иерархии (`edit`)                   |

Также возможно выполнять команды из любого другого уровня иерархии, не покидая текущий уровень в режиме конфигурации, например:

* Выполнив `top show | compare` из `[edit protocols isis interface ge-0/0/0.0]` будут показаны изменения конфигурации из корня, т.е. всей конфигурации
* Выполнив `top delete chassis auto-image-upgrade` из `[edit system login]` будет удалена нужная часть конфигурации `chassis auto-image-upgrade` не выходя из текущего контекста

### Просмотр конфигурации

Подробная дока от Juniper [здесь](https://www.juniper.net/documentation/en_US/junos/topics/topic-map/junos-configuartion-viewing.html)

Просмотр конфигурации всегда выполняется командой `show`, которую в зависимости от её атрибутов можно использовать по-разному:

* `show configuration` - просмотр конфигурации в Operational режиме

* `show` - просмотр конфигурации в Configuration режиме. Показывает только конфигурацию того уровня иерархии, который в данный момент конфигурируется

* `show | compare`  - просмотр изменений между применённой в данный момент конфигурацией и candidate конфигурацией

* `show | compare rollback 2` - просмотр изменений между rollback конфигурацией и candidate конфигурацией

* `show | compare | display {json|xml}` - просмотр изменений в json/xml формате

* `show | display {json|xml}` - просмотр конфигурации в json/xml формате

* `show | display set` - просмотр конфигурации в виде setов, идущих от корня иерархии

  ```bash
  [edit system syslog]
  root# show | display set    
  set system syslog user * any emergency
  set system syslog file messages any notice
  set system syslog file messages authorization info
  set system syslog file interactive-commands interactive-commands any
  ```

* `show | display set relative` - просмотр конфигурации в виде setов с учётом текущего уровня иерархии

  ```bash
  [edit system syslog]
  root# show | display set relative 
  set user * any emergency
  set file messages any notice
  set file messages authorization info
  set file interactive-commands interactive-commands any
  ```

В зависимости от привилегий вашего пользователя, некоторые части конфигурации могут впринципе не выводиться (заместо них в конфиге будет высвечено сообщение `ACCESS-DENIED`), а также пароли и ключи аутентификации (выведется сообщение `SECRET-DATA`).

### Commit конфигурации

Подробная дока от Juniper [здесь](https://www.juniper.net/documentation/en_US/junos/topics/topic-map/junos-configuration-commit.html)

Commit candidate конфигурации выполняется с помощью команды `commit`, очевидно. Некоторые атрибуты этой команды:

* `commit` - просто commit конфигурации

* `commit and-quit` - commit конфигурации и выход в режим operational

* `commit check` - текущая candidate конфигурация проверяется и при нахождении ошибок выводится сообщение *commit check-out failed*.

* `commit confirmed <timeout>` - commit конфигурации и откат через timeout, если не было получено дополнительное подтверждение commitа. Подтвеждение делается вводом команды `commit` еще раз, пока не истёк timeout

* `commit at <date|time>` - commit конфигурации в определённый момент времени:

  * `hh:mm[:ss]` (часы, минуты и опционально секунды) - commit в определённое время текущего дня. Указанное время должно наступить в будущем, но до 23:59:59 текущего дня.
  * `yyyy-mm-dd hh:mm[:ss]` (год, месяц, дата, часы, минуты и опционально секунды) - commit в определённый день и время. Указанная дата и время должны наступить в будущем.

  !!! warning "Внимание"
  	Не забывайте, что установленное время сравнивается с локальным временем на устройстве, а не с временем на вашей рабочей машине

* `commit comment <comment>` - добавление комментария к commitу для лучшего понимания изменений в этом коммите

#### commit prepare/activate

Также с версии 17.3R1 возможно разделить процесс commitа на две стадии:

1. `commit prepare` - на этой стадии candidate конфиг проверяется и генерируется новая база данных с необходимыми файлами (т.е. этот конфиг "подгружается в систему"). В случае обнаружения ошибок в конфиге, выводится сообщение *commit check-out failed*.
2. `commit activate` - на этой стадии подготовленный на прошлой стадии конфиг активируется.

!!! note "Заметка"
	Существует возможность очистить текущий prepared конфиг - `clear system commit prepared`

#### Очистка candidate конфигурации

Очистку candidate конфигурации можно произвести с помощью команды `rollback 0`. По факту - совершается rollback конфигурации до текущей применённой конфигурации.

### Rollback конфигурации

Rollback (откат) конфигурации выполняется, очевидно, командой `rollback`:

* `rollback <0-49>` - откат до одной из предыдущих конфигураций. Посмотреть изменения при rollbackе можно командой `show | compare rollback <0-49>`

	!!! warning "Обратите внимание"
		Команда `rollback` сама по себе не применяет изменения, она вносит их в candidate конфигурацию. Поэтому, если вам нужно применить изменения, внесённые при rollbackе, вам необходимо дополнительно сделать commit

### Подгрузка конфигурации

Подробная дока от Juniper [здесь](https://www.juniper.net/documentation/en_US/junos/topics/topic-map/junos-config-files-loading.html)

Подргрузка конфигурации выполняется в Configuration режиме командой `load`. Подгрузка выполняется в candidate конфигурацию, т.е. после подгрузки необходимо дополнительно произвести commit этой конфигурации. 

Для каждого способа подгрузки конфигурации есть возможность подгружать из файла, указывая `<filename>` после самой команды, или же вводя конфигурацию в сам терминал, добавив `terminal` после самой команды. В таком случае появится поле ввода конфигурации, из которого можно выйти набрав комбинацию Ctrl+D:

```bash
[edit]
root@RZN-RR-P1# load merge terminal                      
[Type ^D at a new line to end input]
interfaces {
    lo0 {
        unit 0 {
            description "== Lo0.0 ==";
            family inet {
                address 1.1.1.1/32;
            }
        }
        unit 1 {                        
            description "== Lo0.1 ==";
            family inet {
                address 2.2.2.2/32;
            }
        }
    }
}
load complete
```

Также можно использовать параметр `relative`, который позволяет подгружать конфигурацию с учётом текущего уровня иерархии:

```bash
[edit interfaces lo0]
root@RZN-RR-P1# load merge relative terminal   
[Type ^D at a new line to end input]
unit 0 {
    description "== Lo0.0 ==";
    family inet {
        address 1.1.1.1/32;
    }
}
load complete
```

Существует множество способов подгрузки конфигурации:

* `load factory-default` - сбросить конфигурацию до стандартной, является своеобразным soft-reset. Не удаляет никакие локальные данные на устройстве.

* `load merge` - подгружает конфигурацию в дополнение к существующей candidate конфигурации:

  ```bash
  [edit interfaces lo0 unit 1]
  root@RZN-RR-P1# show      
  description "== Lo0.1 ==";
  family inet {
      address 2.2.2.2/32;
  }
  
  [edit interfaces lo0 unit 1]
  root@RZN-RR-P1# load merge relative terminal 
  [Type ^D at a new line to end input]
  family inet {
      address 20.20.20.20/32;
  }
  load complete
  
  [edit interfaces lo0 unit 1]
  root@RZN-RR-P1# show | compare                  
  [edit interfaces lo0 unit 1 family inet]
       address 2.2.2.2/32 { ... }
  +    address 20.20.20.20/32;
  ```

* `load update` - подгружает конфигурацию, заменяя только те части конфигурации, которые изменились:

  ```bash
  [edit interfaces lo0 unit 1]
  root@RZN-RR-P1# show                             
  description "== Lo0.1 ==";
  family inet {
      address 2.2.2.2/32;
  }
  
  [edit interfaces lo0 unit 1]
  root@RZN-RR-P1# load update relative terminal    
  [Type ^D at a new line to end input]
  family inet {
      address 20.20.20.20/32;
  }
  load complete
  
  [edit interfaces lo0 unit 1]
  root@RZN-RR-P1# show | compare 
  [edit interfaces lo0 unit 1]
  - description "== Lo0.1 ==";
  [edit interfaces lo0 unit 1 family inet]
  +    address 20.20.20.20/32;
  -    address 2.2.2.2/32;
  ```

* `load override` - подгружает конфигурацию, полностью заменяя текущую candidate конфигурацию. Поэтому выполняться может только из под корня иерархии

* `load set` - подгружает конфигурацию в виде операторов set, в остальном логика подгрузки аналогична merge

* `load replace` - логика подгрузки конфигурации такая же, как и у `merge`, но `replace` ищет в подгружаемой конфигурации перед контекстами теги `replace:`, и если таковой флаг находится, то конфигурация данного контекста полностью меняется на подгружаемую.

  Например, у нас существует контекст **interfaces**, и нам захотелось полностью сменить конфигурацию интерфейса lo0, в таком случае делаем:

  ```bash
  [edit]
  root@RZN-RR-P1# load replace terminal 
  [Type ^D at a new line to end input]
  interfaces {
      fxp0 {
          unit 0 {
              family inet {
                  dhcp {
                      vendor-id Juniper-vmx-VM60483EFF22;
                  }
              }
          }
      }
      replace:
      lo0 {
          unit 0 {
              description "== New Lo0.0 ==";
              family inet {
                  address 10.0.0.1/32;
              }
              family inet6 {
                  address 2001::1/128;
              }
          }
          unit 10 {                        
              description "== New Lo0.10 ==";
              family inet {
                  address 10.10.10.1/32;
              }
              family inet6 {
                  address 2001::10/128;
              }
          }
      }
  }
  load complete
  ```

  И конфигурация контекста lo0 меняется полностью:

  === "Начальная"
  	```bash
  	root@RZN-RR-P1# run show configuration interfaces lo0 
  	unit 0 {
  	    description "== LOL ==";
  	    family inet {
  	        address 1.1.1.1/32;
  	    }
  	}
  	unit 1 {
  	    description "== KEK ==";
  	    family inet {
  	        address 2.2.2.2/32;
  	    }
  	}
  	```

  === "После replace"
  	```bash
  	[edit interfaces lo0]
  	root@RZN-RR-P1# show    
  	unit 0 {
  	    description "== New Lo0.0 ==";
  	    family inet {
  	        address 10.0.0.1/32;
  	    }
  	    family inet6 {
  	        address 2001::1/128;
  	    }
  	}
  	unit 10 {
  	    description "== New Lo0.10 ==";
  	    family inet {
  	        address 10.10.10.1/32;
  	    }
  	    family inet6 {
  	        address 2001::10/128;
  	    }
  	}
  	```

  === "show | compare"

  	```bash
  	[edit]
  	root@RZN-RR-P1# show | compare    
  	[edit interfaces lo0 unit 0]
  	-    description "== LOL ==";
  	+    description "== New Lo0.0 ==";
  	[edit interfaces lo0 unit 0 family inet]
  	+       address 10.0.0.1/32;
  	-       address 1.1.1.1/32;
  	[edit interfaces lo0 unit 0]
  	+      family inet6 {
  	+          address 2001::1/128;
  	+      }
  	[edit interfaces lo0]
  	-    unit 1 {
  	-        description "== KEK ==";
  	-        family inet {
  	-            address 2.2.2.2/32;
  	-        }
  	-    }
  	+    unit 10 {
  	+        description "== New Lo0.10 ==";
  	+        family inet {
  	+            address 10.10.10.1/32;
  	+        }
  	+        family inet6 {
  	+            address 2001::10/128;      
  	+        }
  	+    }
  	```

* `load patch` - подгружает дифф конфигурации, формируемый командами `show | compare` (по другому - patch file) и применяет все изменения, указанные в диффе. Например, если подгрузить такой патч файл:

  ```bash
  [edit]
  root@RZN-RR-P1# load patch terminal 
  [Type ^D at a new line to end input]
  [edit interfaces lo0]
  -    unit 1 {
  -        description "== Lo0.1 ==";
  -        family inet {
  -            address 2.2.2.2/32;
  -        }
  -    }
  +    unit 2 {
  +        description "== Lo0.2 ==";
  +        family inet {
  +            address 2.2.2.2/32;
  +        }
  +    }
  load complete
  ```

  То при проверке изменений между текущей и candidate конфигурацией мы увидим такие же изменения:

  ```bash
  [edit]
  root@RZN-RR-P1# show | compare         
  [edit interfaces lo0]
  -    unit 1 {
  -        description "== Lo0.1 ==";
  -        family inet {
  -            address 2.2.2.2/32;
  -        }
  -    }
  +    unit 2 {
  +        description "== Lo0.2 ==";
  +        family inet {
  +            address 2.2.2.2/32;
  +        }
  +    }
  ```

  Данный способ подгруза конфигурации очень удобен при подгрузе одинаковой конфигурации на множество устройств, поскольку вам нужно будет лишь подкидывать patch файл, и все изменения будут применятся в соответствии с этим диффом.

### Теги в конфигурации

!!! warning "FIXME"
	Нужно здесь дописать про разные теги, типа replace, inactive и т.п.

## Комментарии

Дока от Juniper [здесь](https://www.juniper.net/documentation/en_US/junos/topics/reference/command-summary/annotate.html)

В JunOS есть возможность добавлять комментарии (аннотации к разным контекстам). Чтобы добавить комментарий, необходимо

```bash
annotate <context> <comment string>
```

Т.е., если находясь в `edit system login` написать `annotate user admin COMMENT`, то конфигурация данного контекста будет выглядеть так:

```bash
login {
    /* COMMENT */
    user admin {
        uid 2000;
        class super-user;
        authentication {
            encrypted-password "$SECRET-DATA"; ## SECRET-DATA
        }
    }
}
```

## Пользователи и AAA

### Добавление пользователей

```bash
root# edit system login user admin    
	
[edit system login user admin]
```

2. Устанавливаем класс пользователя

   ```bash
   root# set class {operator|read-only|super-user|unauthorized}
   Possible completions:
     <class>              Login class
     operator             permissions [ clear network reset trace view ]
     read-only            permissions [ view ]
     super-user           permissions [ all ]
     unauthorized         permissions [ none ]
   ```

3. Устанавливаем пароль на пользователя

   ```bash
   # Если нужно ввести пароль в plain-text
   root# set authentication plain-text-password
   
   # Если вводится уже зашифрованная строка:
   root# set authentication encrypted-password "$6$ENCRYPTED"
   ```

   

```bash
root# edit system login user admin    
[edit system login user admin]


```

## IS-IS

### Конфигурация

Большая дока от Juniper по IS-IS [здесь](https://www.juniper.net/documentation/en_US/junos/information-products/pathway-pages/config-guide-routing/config-guide-routing-is-is.html)

Общая конфигурация протокола, предполагающая использование только level-2 и анонс только loopback-интерфейса:

```bash
[edit]
protocols {
    isis {
        export RP-ISIS-EXPORT;
        level 1 disable;                
        level 2 wide-metrics-only;
        # Включение IS-IS на опредёленном unitе интерфейса
        interface ge-0/0/0.0 {
            hello-padding adaptive;
            point-to-point;
            # Включение IS-IS для AFI IPv4
            family inet {
                bfd-liveness-detection {
                    version automatic;
                    minimum-interval 300;
                    multiplier 5;
                    no-adaptation;
                }
            }
            # Настройка параметров для второго уровня IS-IS
            level 2 {
                metric 10000;
                hello-authentication-key-chain KEY-ISIS;
            }
        }
        # Включение IS-IS на loopback для рассылки маршрутной информации о нём
        interface lo0.0 {
            passive;
        }
    }
}
# Включение AFI ISO на интерфейсах, участвующих в IS-IS
interfaces {
    ge-0/0/0 {
        unit 0 {
           family iso;
        }
    }
    ge-0/0/1 {
        unit 0 {
           family iso;
        }
    }
    ge-0/0/2 {
        unit 0 {
           family iso;
        }
    }
    lo0 {
        unit 0 {
            family iso {
                # Указание NET адреса для устройство (хватает 1 на устройство)
                address 49.0001.0001.0001.0001.00;
            }
        }
    }
}
policy-options {
    policy-statement RP-ISIS-EXPORT {
        # Разрешает анонс только lo0.0
        term router-id {
            from {
                route-filter 109.1.1.1/32 exact;
            }
            then accept;
        }
        # Запрещает всё остальное
        term implicit-deny {
            then reject;
        }
    }
}
security {
    authentication-key-chains {
        # Ключ для аутентификации IS-IS
        key-chain KEY-ISIS {
            key 1 {
                secret /* SECRET DATA */; ## SECRET-DATA
                start-time "2020-1-1.00:00:00 -0700";
                algorithm md5;
                options basic;
            }
        }
    }                                   
}
```

Разберём этот конфиг IS-IS подробнее:

* `export RP-ISIS-EXPORT` - экспортировать в IS-IS только адрес lo0.0
* `level 1 disable` и `level 2 wide-metrics-only` - отключение IS-IS Level1 и указание использования широких метрик (значения до 2^24 - 1) для Level2
* `hello-padding adaptive` - позволяет детектировать разный MTU на разных концах и устанавливать IS-IS сессию
* `point-to-point` - указание что данный линк является p2p, что позволяет быстрее устанавливать соседство. В таком случае IS-IS не выбирает DR (Designated router), не флудит сеть CSNP (которые содержат копию всех LSP).
* `passive` - перевод интерфейса в passive режим, в котором IS-IS включает этот интерфейс в свои анонсы, но не пытается установить соседства черед него
* `minimum-interval 300` и `multiplier 5` - установка минимального интервала сообщений BFD на 300мс, а также кол-ва сообщений, при не получении которых рвётся BFD сессия (т.е. в данном случае она порвётся через 300x5=1500мс)
* `no-adaptation` - не подстраивать параметры BFD при несовпадении их на обоих концах

### Траблшутинг

#### Команды

Список команд, которые могут помочь при траблшутинге IS-IS:

* `show isis interface` - список интерфейсов, участвующих в IS-IS. При этом не важно, установлено ли сейчас на этом интерфейсе соседство, или интерфейс включён в IS-IS только для передачи маршрутной информации о нём
* `show isis adjacency` - список активных в данный момент соседей
* `show isis overview` - основная информации о процессе IS-IS
* `show isis spf brief` - информация о работе алгоритма SPF, в т.ч. список нод и стоимость пути до них
* `show isis route` - маршруты, находящиеся в таблице IS-IS

## BGP

### Конфигурация

Большая дока от Juniper [здесь](https://www.juniper.net/documentation/en_US/junos/topics/topic-map/bgp-overview.html)

```bash
[edit]
# Указание основных параметров этой системы
routing-options {
    # Данные параметры, применяющиеся в BGP, указываются вне контекста самого BGP
    router-id 109.1.1.1;
    autonomous-system 31257;
}
protocols {
    bgp {
        local-address 109.1.1.1;
        export RP-BGP-REDIS;
        # Все пиры в JunOS должны быть отнесены к группе
        group RZN-PE {
            type internal;
            description "== Ryazan PE devices ==";
            # Активация AFI SAFI IPv4 unicast
            family inet {
                unicast;
            }
            cluster 109.1.1.1;
            # Указание самого соседа
            neighbor 109.1.1.2 {
                description "== RZN-PE1 ==";
                peer-as 31257;
            }
        }
    }
}
policy-options {
    # Политика, разрешающая редистрибуцию всех direct и static маршрутов в BGP, кроме Lo0
    policy-statement RP-BGP-REDIS {
        term no-loopback {
            from {
                route-filter 109.1.1.1/32 exact;
            }
            then reject;
        }
        term redistribute {             
            from protocol [ direct static ];
            then accept;
        }
    }
}
```

Некоторые моменты из конфига поподробнее:

* `local-address 109.1.1.1` - указание локального адреса для установления BGP сессий. Без данного пункта устройство будет выбирать адрес "ближайшего" интерфейса к пиру
* `export RP-BGP-REDIS` - экспорт маршрутов в BGP по определённой политике
* `type internal` - данная группа будет включать в себя только iBGP пиры
* `cluster 109.1.1.1` - указание cluster ID для работы механизма route-reflector. Если в группе или у соседа указывается данный параметр, значит все эти соседи автоматически становятся route-reflector клиентами

### Траблшутинг

#### Команды

Список команд, которые могут помочь при траблшутинге BGP:

* `show bgp summary` - краткая информация о BGP соседях
* `show bgp neighbor 109.1.1.1` - более детальная информация о BGP соседе
* `show bgp group` - информация о BGP группах
* `show route receive-protocol bgp 109.1.1.1` - вывод полученных маршрутов от определённого соседа

* `show route advertising-protocol bgp 109.1.1.1` - вывод анонсирующихся маршрутов определённому соседу

## Routing policy

## Segment routing

Подробное Day One пособие от Juniper [здесь](https://www.juniper.net/documentation/en_US/day-one-books/DO_InsideSR.zip) и [здесь](https://www.juniper.net/documentation/en_US/day-one-books/DO_SegmentRouting.pdf), а также видеопособие по конфигурации [здесь](https://www.youtube.com/watch?v=DoBELFc8I7U)

### MPLS-SR + IS-IS

Конфигурация MPLS-SR с IGP в виде IS-IS:

```bash
[edit]
chassis {
    network-services enhanced-ip;
}
interfaces {
    ge-0/0/8 {
        unit 0 {
            # Добавление family mpls для работы mpls на интерфейсе
            family mpls;
        }
    }
    ge-0/0/9 {
        unit 0 {
            family mpls;
        }
    }
}
protocols {                             
    mpls {
        # Добавление интерфейсов для включения mpls на них
        interface ge-0/0/8.0;
        interface ge-0/0/9.0;
    }
    isis {
        # Включение расширения SR для IS-IS
        source-packet-routing {
            srgb start-label 16000 index-range 8000;
            node-segment ipv4-index 3;
        }
    }
}
```

Некоторые моменты из конфига поподробнее:

* `network-services enhanced-ip` в `[edit chassis] ` - обязательно для использования на платформе расширенных возможностей IP ([дока](https://www.juniper.net/documentation/en_US/junos/topics/reference/configuration-statement/network-services-edit-chassis.html))
* `srgb start-label 16000 index-range 8000` в `[edit protocols isis source-packet-routing]` - указание диапазона меток, использующихся для Segment Routing Global Block (блок меток, использующийся для назначения Prefix-SID на устройства). В данном случае началом блока является метка `16000`, а размер блока `8000`. В итоге получается блок `16000 - 23999` ([дока](https://www.juniper.net/documentation/en_US/junos/topics/reference/configuration-statement/srgb-edit-protocols-isis-source-packet-routing.html))
* `node-segment ipv4-index 3` в `[edit protocols isis source-packet-routing]` - указание индекса (из которого генерируется Prefix-SID) этого устройства. Prefix-SID генерируется по принципу `start-label + index`, т.е. в данном случае `Prefix-SID = 16000 + 3 = 16003` ([дока](https://www.juniper.net/documentation/en_US/junos/topics/reference/configuration-statement/srgb-edit-protocols-isis-source-packet-routing.html))

### Траблшутинг

#### Команды

* `show mpls label usage` - выделенные блоки меток под разные цели, в т.ч. SRGB
* `show mpls interface detail` - использующиеся для MPLS интерфейсы
* `show route table mpls.0` - таблица MPLS меток, известных для данного устройства
* `show isis adjacency extensive` - информация о IS-IS соседях вместе с Adj-SIDами
* `show isis database extensive` - расширенная информация о устройствах в IGP домене + информация о SR (TLV, рассылаемые блоки SRGB, Adj-SID и т.п.)
* 

## EVPN

### Словарь

* `EVI` - EPVN Instance - инстанс EVPN, распространённый на все PE устройства, участвующие в этом конкретном VPN (имеется ввиду не каждый VLAN, а конкретный routing-instance со своим RD, в котором может быть несколько VLANов)
* `ESI` - Ethernet Segment Identifier - обязательный атрибут, который идентифицирует EVPN LAG (т.е. multihoming). Автоматически всем устройствам назначается `00:00:00:00:00:00:00:00:00:00`
* `Ethernet segment` в Multihoming - сегмент сети между CE устройством, и двумя PE, к которым подключено это CE

### Способы реализации

#### VLAN Based

Конфигурация EVPN в режиме Vlan Based предполагает наличие отдельного **routing-instance evpn** для каждого Vlan, передаваемого через EVPN. Таким образом каждый bridge-domain изолирован друг от друга, а трафик может передаваться и с тегом, и без.

```bash
[edit]
protocols {
    bgp {
        group RZN-RR {
            # Включение family evpn для передачи нужных AFI SAFI
            family evpn {
                signaling;
            }
        }
    }
}
interfaces {
    ge-0/0/0 {
        flexible-vlan-tagging;
        native-vlan-id 1;
        # Конфигурация ESI для включения multihoming для CE
        esi {
            00:00:10:92:26:25:50:02:00:00;
            all-active;
        }
        encapsulation flexible-ethernet-services;
        # unit, не использующийся в EVPN
        unit 1 {
            encapsulation vlan-bridge;
            family bridge {
                interface-mode trunk;
                vlan-id 1;
            }
        }
        # unit, который будет включён в EVPN
        unit 777 {
            encapsulation vlan-bridge;
            # При vlan aware обязателен именно vlan-id, а не vlan-id-list
            vlan-id 777;
            family bridge;
        }
        # unit, который будет включён в EVPN
        unit 888 {
            encapsulation vlan-bridge;
            # При vlan aware обязателен именно vlan-id, а не vlan-id-list
            vlan-id 888;
            family bridge;
        }
    }
}
# bridge для всего остального, кроме EVPN, конфигурятся в корне конфигурации
bridge-domains {
    CE-NATIVE {
        vlan-id 1;
        routing-interface irb.1;
    }
}
# Политики, навешивающие community на данный EVI
policy-options {
    policy-statement RZN-EVPN-EXPORT {
        term DEFAULT {
            then {
                community + VPN-1;
                accept;
            }
        }
        term REJECT {
            then reject;
        }
    }
    policy-statement RZN-EVPN-IMPORT {
        term DEFAULT-IMPORT {
            from {
                protocol bgp;
                community VPN-1;
            }
            then accept;
        }
        term REJECT {
            then reject;
        }
    }
    community VPN-1 members target:31257:777;
}
# Разные instance для VPNов на данном устройстве
routing-instances {
    RZN-EVPN-777 {
        instance-type evpn;
        vlan-id 777;
        interface ge-0/0/0.777;
        route-distinguisher 109.226.255.5:777;
        vrf-import RZN-EVPN-IMPORT;
        vrf-export RZN-EVPN-EXPORT;
        protocols {
            evpn {
                interface ge-0/0/0.777;
            }
        }
    }
    RZN-EVPN-888 {
        instance-type evpn;
        vlan-id 888;
        interface ge-0/0/0.888;         
        route-distinguisher 109.226.255.5:888;
        vrf-import RZN-EVPN-IMPORT;
        vrf-export RZN-EVPN-EXPORT;
        protocols {
            evpn {
                interface ge-0/0/0.888;
            }
        }
    }
}
```

#### VLAN Aware

Конфигурация EVPN в режиме Vlan Aware предполагает наличие одного **routing-instance virtual-switch**, в который с помощью bridge-domainов заводятся разные Vlanы.

В приведённой ниже конфигурации существует клиент с двумя вланами, которому предоставляется услуга EVPN:

```bash
[edit]
protocols {
    bgp {
        group RZN-RR {
            # Включение family evpn для передачи нужных AFI SAFI
            family evpn {
                signaling;
            }
        }
    }
}
interfaces {
    ge-0/0/0 {
        flexible-vlan-tagging;
        native-vlan-id 1;
        # Конфигурация ESI для включения multihoming для CE
        esi {
            00:00:10:92:26:25:50:02:00:00;
            all-active;
        }
        encapsulation flexible-ethernet-services;
        # unit, не использующийся в EVPN
        unit 1 {
            encapsulation vlan-bridge;
            family bridge {
                interface-mode trunk;
                vlan-id 1;
            }
        }
        # unit, который будет включён в EVPN
        unit 777 {
            encapsulation vlan-bridge;
            family bridge {
                interface-mode trunk;
                # При vlan aware обязателен именно vlan-id-list, а не vlan-id
                vlan-id-list 777;
            }
        }
        # unit, который будет включён в EVPN
        unit 888 {
            encapsulation vlan-bridge;
            # Конфигурация ESI для включения multihoming для CE
            family bridge {
                interface-mode trunk;
                # При vlan aware обязателен именно vlan-id-list, а не vlan-id
                vlan-id-list 888;
            }
        }
    }
}
# bridge для всего остального, кроме EVPN, конфигурятся в корне конфигурации
bridge-domains {
    CE-NATIVE {
        vlan-id 1;
        routing-interface irb.1;
    }
}
# Политики, навешивающие community на данный EVI
policy-options {
    policy-statement RZN-EVPN-EXPORT {
        term DEFAULT {
            then {
                community + VPN-1;
                accept;
            }
        }
        term REJECT {
            then reject;
        }
    }
    policy-statement RZN-EVPN-IMPORT {
        term DEFAULT-IMPORT {
            from {
                protocol bgp;
                community VPN-1;
            }
            then accept;
        }
        term REJECT {
            then reject;
        }
    }
    community VPN-1 members target:31257:777;
}
routing-instances {
    # Instance для VPNов на данном устройстве
    RZN-EVPN {
        instance-type virtual-switch;
        vrf-import RZN-EVPN-IMPORT;
        vrf-export RZN-EVPN-EXPORT;
        interface ge-0/0/0.777;
        interface ge-0/0/0.888;
        route-distinguisher 109.226.255.2:1;
        protocols {
            evpn {
                # Список vlan для этого инстанса
                extended-vlan-list [ 777 888 ];
            }
        }
        # отдельный bridge для vlan 777 и 888
        bridge-domains {
            VLAN-777 {
                vlan-id 777;
            }
            VLAN-888 {
                vlan-id 888;
            }
        }
    }
}
```

Некоторые моменты из конфига поподробнее:

* секция `esi` в `[edit interfaces ge-0/0/0 unit ###]` - обозначение Ethernet Segment Identifier. Обязательно для multihoming, для остальных сценариев опционально, но установка его всё же рекомендуется.

  Удобный принцип формирования ESI - `00:00:RR:RR:RR:RR:RR:RR:VV:VV`, где:

  * RR - router ID конкретного устройства (или же адрес iBGP лупбека)
  * VV - VLAN ID конкретного влана, передающегося в этом unitе

  Например, при router ID `109.226.255.2` и VLAN ID `888` получается ESI `00:10:92:26:25:50:02:00:08:88`

  `all-active` или `single-active` - режим использования линков в Ethernet Segment (балансировка нагрузки между двумя или использование только одного)

* `vrf-import`/`vrf-export` в `[edit routing-instances $NAME]` - политики по импорту и экспорту EVPN маршрутов в данный инстанс

* `interface $NAME` в `[edit routing-instances $NAME]` - юниты интерфейсов, участвующие в данном EVPN инстансе

### L3 функционал

Чтобы обеспечить доступ из vlanа во внешнюю сеть, необходимо добавить L3 функционал в EVPN, а именно:

* Сконфигурировать шлюзы с одинаковой IP-адресацией на всех PE, на которых присутствует данный vlan
* Обеспечить синхронизацию дефолтных шлюзов, т.е. сделать так, чтобы каждый шлюз откликался на IP и MAC адрес любого другого шлюза
* Если необходима маршрутизация между vlanами, то сконфигурировать отделный routing-instance vrf для обмена маршрутной информацией между vlanами

#### Автоматическая синхронизация дефолтных шлюзов

Автоматическая синхронизация дефолтных шлюзов предполагает конфигурирование на всех PE irb интерфейсов с одинаковой IP адресацией на каждом:

```bash
interfaces {
    # Конфигурация каждого irb юнита должна быть одинаковой на всех PE
    irb {
        unit 777 {
            family inet {
                address 10.0.0.254/24;
            }
        }
        unit 888 {
            family inet {
                address 10.0.1.254/24;
            }
        }
        unit 999 {
            family inet {
                address 192.168.0.254/24;
            }
        }
    }
}
```

MAC адреса в данном случае назначаются автоматически, а каждый PE рассылает информацию о MAC+IP своего шлюза. Остальные PE получают эту информацию, и начинают принимать кадры на irb интерфейс сразу на несколько MAC адресов

Например, если у нас есть 3 PE с MACами `50:03:00:0a:98:7a`, `00:00:00:77:77:77` и `10:92:26:25:50:05`, то шлюз каждого из этих PE будет получать на irb кадры на MAC адреса `50:03:00:0a:98:7a`, `00:00:00:77:77:77` и `10:92:26:25:50:05`

#### Ручная синхронизация дефолтных шлюзов

Ручная синхронизация дефолтных шлюзов предполагает ручное конфигурирование на всех PE irb интерфейсов и MAC/IP адресации на них:

```bash
interfaces {
    # Конфигурация каждого irb юнита должна быть одинаковой на всех PE
    irb {
        unit 777 {
            family inet {
                address 10.0.0.254/24;
            }
            # Ручное назначение MAC
            mac 00:00:00:77:77:77
        }
        unit 888 {
            family inet {
                address 10.0.1.254/24;
            }
            # Ручное назначение MAC
            mac 00:00:00:88:88:88
        }
        unit 999 {
            family inet {
                address 192.168.0.254/24;
            }
            # Ручное назначение MAC
            mac 00:00:00:99:99:99
        }
    }
}
```

В таком случае будет меньшая нагрузка на control-plane, поскольку устройствам не придется самостоятельно синхронизировать свои шлюзы, этим занимается администратор, назначая одинаковые MACи на irb всех PE

#### Маршрутизация между VLAN

Чтобы обеспечить маршрутизацию между VLAN, необходимо связать их с помощью VRF

##### Связывание VLAN в один VRF

В таком случае все EVI связываются в одном VRF, в который скидывается маршрутная информация по каждому EVI. Каждый EVI может общаться с каждым, нет возможности разделить возможность общения одного EVI с другим.

Примерная конфигурация с 3 EVI 777, 888, 999:

```bash
routing-instances {
    RZN-EVPN {
        bridge-domains {
            VLAN-777 {
                # Добавление irb к существующему bridge
                routing-interface irb.777;
            }
            VLAN-888 {
                # Добавление irb к существующему bridge
                routing-interface irb.888;
            }
            VLAN-999 {
                # Добавление irb к существующему bridge
                routing-interface irb.999;
            }
        }
    }
    VRF-VPN-1 {
        instance-type vrf;
        interface irb.777;
        interface irb.888;
        interface irb.999;
        # RD - уникальный идентификатор данного VRF по сети. Должен быть одинаковым на всех устройствах с этим VRF
        route-distinguisher 31257:1;
        # RT - route-target, указывающий информацию из каких VRF с каким RT нужно импортировать/экспортировать
        vrf-target {
            import target:31257:1;
            export target:31257:1;
        }
        vrf-table-label;
    }
}
```

##### Разделение EVI на разные VRF

### Multihoming

Подробная дока от Juniper [здесь](https://www.juniper.net/documentation/en_US/junos/topics/concept/evpn-bgp-multihoming-overview.html)

```bash
[edit]
chassis {
    aggregated-devices {
        ethernet {
            # Указание кол-ва агрегируемых интерфейсов на устройстве
            device-count 1;
        }
    }
}
interfaces {
    ge-0/0/2 {
        gigether-options {
            # Включение физического интерфейса в aggregated-ether
            802.3ad ae2;
        }
    }
    ae2 {
        flexible-vlan-tagging;
        encapsulation flexible-ethernet-services;
        aggregated-ether-options {
            lacp {
                # Режим работы LACP
                active;
                # ID устройства в LACP, на обоих устройствах должен быть одинаковый
                system-id 00:01:02:03:04:05;
            }
        }
        unit 777 {
            encapsulation vlan-bridge;
            esi {
                00:00:34:34:34:34:34:34:07:77;
                all-active;
            }
            family bridge {
                interface-mode trunk;
                vlan-id-list 777;
            }
        }
        unit 999 {
            encapsulation vlan-bridge;
            esi {
                00:00:34:34:34:34:34:34:09:99;
                all-active;
            }
            family bridge {
                interface-mode trunk;
                vlan-id-list 999;
            }
        }
    }
    irb {
        unit 999 {
            family inet {
                address 192.168.0.254/24;
            }
            mac 00:00:00:99:99:99
        }
    }
}
routing-instances {
    RZN-EVPN {
        interface ae2.777;
        interface ae2.999;
         protocols {
            evpn {
                extended-vlan-list [ 777 999 ];
            }
        }
        bridge-domains {
            VLAN-999 {
                vlan-id 999;
                routing-interface irb.999;
            }
        }
    }
    VRF-VPN-1 {
        interface irb.999;
    }
}
```



### Траблшутинг

#### Команды

* `show bridge evpn arp-table` - показывает соответствия IP-MAC, изученные локально через ARP или пришедшие через BGP маршрут типа 2 (MAC/IP advertisment)