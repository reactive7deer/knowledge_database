### Генерация новых пользователей AD с помощью PowerShell-скрипта



Для запуска командлета ***New-ADUser*** необходимо предварительно импортировать модуль Active Directory для PowerShell. 

* Делается это командой **Import-Module ActiveDirectory**, можно просто вставить эту строку в скрипт*.* 
* Исключение составляет случай, когда вы запускаете скрипт из специальной оснастки «Модуль Active Directory для Windows PowerShell».



```powershell
# Переменные
$org="OU=IT,DC=kazan,DC=wsr"
$group="IT"
$domain="@kazan.wsr"
$homedir="\\srv1\shares\IT\"
$count=1..30

# Цикл с использованием командлета на создание пользователей
foreach ($i in $count) 
{ New-AdUser `
    -Name $group"_"$i `
    -AccountPassword (ConvertTo-SecureString $i"_"$group -AsPlainText -force) `
    -Path $org `
    -Enabled 1 `
    -UserPrincipalName $group"_"$i$domain `
    -HomeDirectory $homedir$group"_"$i `
    -HomeDrive U: `
    -passThru`
}
```

,где - 

* **`Name $group"_"$i `**- имя учетной записи (используется в формате **domainName\ Name**)
* **`AccountPassword (ConvertTo-SecureString $i"_"$group -AsPlainText -force)`** -  создание пароля для учетной записи
* **`Enabled 1`** - активация учетной записи
* **`Path $org`** - указывает путь для создания пользователя (в нашем случае исходя из значения переменной $org это будет **подразделение IT в домене kazan.wsr**)
* **`UserPrincipalName $group"_"$i$domain`** - имя для логина в формате ***name@domainName***
* **`HomeDirectory $homedir$group"_"$i`** - адрес домашней папки
* **`HomeDrive U:`** - буква тома, для подключения домашней папки
