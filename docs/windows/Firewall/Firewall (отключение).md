### Firewall

---

Для отключения или включения профилей Брандмауэра используется Powershell командлет - **Set-NetFirewallProfile**

* Используя данный командлет с опцией **-Enable**, которая может принимать два значения - **True** и **False**.

```powershell
Set-NetFirewallProfile -Enabled False
```

* Использование опции **-Profile** *[Domain, Public, Private]* можно отключить конкретный один или несколько профилей сразу.

```
Set-NetFirewallProfile -Profile Domain,Public -Enabled False
```



https://docs.microsoft.com/en-us/powershell/module/netsecurity/set-netfirewallprofile