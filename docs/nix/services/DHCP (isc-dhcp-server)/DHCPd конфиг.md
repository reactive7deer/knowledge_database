```
option domain-name "skill39.wsr";
option domain-name-servers 172.16.20.10;

default-lease-time 600;
max-lease-time 7200;

ddns-update-style none;
authoritative;


subnet 172.16.100.0 netmask 255.255.255.0 {
  range 172.16.100.65 172.16.100.75;
  option routers 172.16.100.1;
  option broadcast-address 172.16.100.255;
}



subnet 172.16.200.0 netmask 255.255.255.0 {
  range 172.16.200.65 172.16.200.75;
  option routers 172.16.200.1;
  option broadcast-address 172.16.200.255;
}

host L-CLI-B {
    hardware ethernet 00:0c:29:d7:e9:68;
    fixed-address 172.16.200.61;
}



subnet 172.16.50.0 netmask 255.255.255.252 {
}
```

