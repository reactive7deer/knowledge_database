### Firewall

---

При помощи все тех же командлетов PowerShell, можено редактировать редактировать правила Брандмауэра, как одиночные, так и целые группы.

Для этого будет использоваться командлет **Set-NetFirewallRule**.

При помощи опции **-DisplayName "..."** мы можем задать имя *конкретного правила*, а **-DisplayGroup "..."** - для целой *группы правил*.

Следующей следуют использовать опцию **-Enabled** которая может принимать значение **True** и **False**, для включения и отключения правила/группы правил.



* Включение правил удаленного управления Firewall:

```powershell
Set-NetFirewallRule -DisplayGroup "Windows Defender Firewall REmote Management" -Enabled True
```



#### Как можно посмотреть доступные правила?

Чтобы вывести имеющиеся правила, стоит использовать командлет **Get-NetFirewallRule**.

Например:

* ```powershell
  Get-NetFirewallProfile -Name Public | Get-NetFirewallRule
  ```

  В этом примере извлекаются все правила брандмауэра, относящиеся к общедоступному профилю.

  

* ```
  Get-NetFirewallRule -DisplayGroup "*Remote*"
  ```

  Выводит все правила удовлетворяющие данной конструкции: *в названии группы правил должно присутствовать слово Remote*



Источники:
https://docs.microsoft.com/en-us/powershell/module/netsecurity/set-netfirewallrule