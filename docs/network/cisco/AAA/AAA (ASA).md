# AAA (ASA)

---

Локальная база - учетные данные созданные на устройстве

## Authentication

`aaa authentication telnet console LOCAL` - аутентификация при входе через **Telnet** будет осуществляться при помощи локальной базы
`aaa authentication ssh console LOCAL` - аутентификация при входе через **SSH** будет осуществляться при помощи локальной базы
`aaa authentication enable console LOCAL` - аутентификация при входе в **enable-режим** будет осуществляться при помощи локальной базы

## Authorization

`aaa authorization exec LOCAL` - после аутентификации, будут выдаваться права согласно локальной базе