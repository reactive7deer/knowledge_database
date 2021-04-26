### Firewall

---

Для более детального управление Брандмауэром можно так же использовать командлет **Set-NetFirewallProfile**.

Использование опций **-DefaultInboundAction** и **-DefaultOutoundAction** изменить состояние для входящих/исходящих соединений в одной из состояний: **Allow** (разрешено), **Block** (блокируется), **Not Configured** (не настроено).

```Powershell
Set-NetFirewallProfile -Profile Domain -DefaultInboundAction Allow -DefaultOutboundAction Allow
```

В таком виде у Доменного профиля файервола, будут разрешены все входящие и исходящие соедининения.



Проверить текущую конфигурацию сетевых профилей можно с помощью командлета **Get-NetFirewallProfile**. Пример его вывода:

```
[SRV2.SPB.wse]: PS C:\Users\Administrator.SPB\Documents> Get-NetFirewallProfile


Name                            : Domain
Enabled                         : True
DefaultInboundAction            : Allow
DefaultOutboundAction           : Allow
AllowInboundRules               : NotConfigured
AllowLocalFirewallRules         : NotConfigured
AllowLocalIPsecRules            : NotConfigured
AllowUserApps                   : NotConfigured
AllowUserPorts                  : NotConfigured
AllowUnicastResponseToMulticast : NotConfigured
NotifyOnListen                  : False
EnableStealthModeForIPsec       : NotConfigured
LogFileName                     : %systemroot%\system32\LogFiles\Firewall\pfirewall.log
LogMaxSizeKilobytes             : 4096
LogAllowed                      : False
LogBlocked                      : False
LogIgnored                      : NotConfigured
DisabledInterfaceAliases        : {NotConfigured}

Name                            : Private
Enabled                         : True
DefaultInboundAction            : NotConfigured
DefaultOutboundAction           : NotConfigured
AllowInboundRules               : NotConfigured
AllowLocalFirewallRules         : NotConfigured
AllowLocalIPsecRules            : NotConfigured
AllowUserApps                   : NotConfigured
AllowUserPorts                  : NotConfigured
AllowUnicastResponseToMulticast : NotConfigured
NotifyOnListen                  : False
EnableStealthModeForIPsec       : NotConfigured
LogFileName                     : %systemroot%\system32\LogFiles\Firewall\pfirewall.log
LogMaxSizeKilobytes             : 4096
LogAllowed                      : False
LogBlocked                      : False
LogIgnored                      : NotConfigured
DisabledInterfaceAliases        : {NotConfigured}

Name                            : Public
Enabled                         : True
DefaultInboundAction            : NotConfigured
DefaultOutboundAction           : NotConfigured
AllowInboundRules               : NotConfigured
AllowLocalFirewallRules         : NotConfigured
AllowLocalIPsecRules            : NotConfigured
AllowUserApps                   : NotConfigured
AllowUserPorts                  : NotConfigured
AllowUnicastResponseToMulticast : NotConfigured
NotifyOnListen                  : False
EnableStealthModeForIPsec       : NotConfigured
LogFileName                     : %systemroot%\system32\LogFiles\Firewall\pfirewall.log
LogMaxSizeKilobytes             : 4096
LogAllowed                      : False
LogBlocked                      : False
LogIgnored                      : NotConfigured
DisabledInterfaceAliases        : {NotConfigured}
```



https://docs.microsoft.com/en-us/powershell/module/netsecurity/set-netfirewallprofile