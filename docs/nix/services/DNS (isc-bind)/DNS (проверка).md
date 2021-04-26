### По заданию

1. Процесс конфигурирования

   По шагам из инструкции выше



2. Конфигурационные файлы

   * **Debian**

     * **/etc/bind/named.conf.options** (комментарии удалены)

       ```
       options {
               directory "/var/cache/bind";
       
               forwarders {
               10.10.10.10;
               };
               // dnssec-validation auto;
               allow-query { any; };
               listen-on-v6 { any; };
       };
       ```

     * **/etc/bind/named.conf.default-zones**

       ```
       zone "skill39.wsr" {
               type master;
               file "/opt/dns/skill39.wsr.db";
               allow-transfer {192.168.20.10; };
       };
       
       zone "20.16.172.in-addr.arpa" {
               type master;
               file "/opt/dns/20.16.172.in-addr.arpa.db";
               allow-transfer {192.168.20.10; };
       };
       
       zone "100.16.172.in-addr.arpa" {
               type master;
               file "/opt/dns/100.16.172.in-addr.arpa.db";
               allow-transfer {192.168.20.10; };
       };
       
       zone "200.16.172.in-addr.arpa" {
               type master;
               file "/opt/dns/200.16.172.in-addr.arpa.db";
               allow-transfer {192.168.20.10; };
       };
       
       zone "20.168.192.in-addr.arpa" {
               type master;
               file "/opt/dns/20.168.192.in-addr.arpa.db";
               allow-transfer {192.168.20.10; };
       };
       ```

     * Файл прямой зоны **skill39.wsr** (**/opt/dns/**)

       ```
       ;
       ; BIND data file for local loopback interface
       ;
       $TTL    604800
       @       IN      SOA     ns01.skill39.wsr. root.skill39.wsr. (
                                    10         ; Serial
                                604800         ; Refresh
                                 86400         ; Retry
                               2419200         ; Expire
                                604800 )       ; Negative Cache TTL
       ;
       @       IN      NS      ns01.skill39.wsr.
       @       IN      NS      ns02.skill39.wsr.
       l-srv   IN      A       172.16.20.10
       ns01    IN      A       172.16.20.10
       ns02    IN      A       192.168.20.10
       server  IN      CNAME   l-srv
       l-fw    IN      A       172.16.20.1
       l-fw    IN      A       172.16.50.1
       l-fw    IN      A       172.16.55.1
       r-fw    IN      A       192.168.20.1
       www     IN      CNAME   r-fw
       r-srv   IN      A       192.168.20.10
       l-cli-a IN      A       172.16.100.65
       l-cli-b IN      A       172.16.200.61
       ```

     * Файл обратной зоны **20.16.172.in-addr.arpa** (**/opt/dns**)

       ```shell
       ;
       ; BIND reverse data file for local loopback interface
       ;
       $TTL    604800
       @       IN      SOA     ns01.skill39.wsr. root.skill39.wsr. (
                                     5         ; Serial
                                604800         ; Refresh
                                 86400         ; Retry
                               2419200         ; Expire
                                604800 )       ; Negative Cache TTL
       ;
       @       IN      NS      ns01.skill39.wsr.
       @       IN      NS      ns02.skill39.wsr.
       10      IN      PTR     ns01.skill39.wsr.
       10      IN      PTR     l-srv.skill39.wsr.
       1       IN      PTR     l-fw.skill39.wsr.
       ```

       

   * **CentOS**

     * **/etc/named.conf** (комментарии сокращены)

       ```
       //
       // named.conf
       //
       options {
               listen-on port 53 { any; };
               listen-on-v6 port 53 { ::1; };
               directory       "/var/named";
               dump-file       "/var/named/data/cache_dump.db";
               statistics-file "/var/named/data/named_stats.txt";
               memstatistics-file "/var/named/data/named_mem_stats.txt";
               secroots-file   "/var/named/data/named.secroots";
               recursing-file  "/var/named/data/named.recursing";
       
               allow-notify {172.16.20.10; };
               allow-query     { any; };
       
               recursion yes;
       
               // dnssec-enable yes;
               // dnssec-validation yes;
       
               managed-keys-directory "/var/named/dynamic";
       
               pid-file "/run/named/named.pid";
               session-keyfile "/run/named/session.key";
       
               /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
               include "/etc/crypto-policies/back-ends/bind.config";
       };
       
       logging {
               channel default_debug {
                       file "data/named.run";
                       severity dynamic;
               };
       };
       
       zone "." IN {
               type hint;
               file "named.ca";
       };
       
       include "/etc/named.rfc1912.zones";
       include "/etc/named.root.key";
       ```

     * **/etc/named.rfc1912.zones** (комментарии сокращены)

       ```
       // named.rfc1912.zones:
       //
       // Provided by Red Hat caching-nameserver package
       //
       // ISC BIND named zone configuration for zones recommended by
       // RFC 1912 section 4.1 : localhost TLDs and address zones
       // and https://tools.ietf.org/html/rfc6303
       // (c)2007 R W Franks
       //
       // See /usr/share/doc/bind*/sample/ for example named configuration files.
       //
       // Note: empty-zones-enable yes; option is default.
       // If private ranges should be forwarded, add
       // disable-empty-zone "."; into options
       //
       
       zone "skill39.wsr" IN {
               type slave;
               file "/var/named/slaves/slave.skill39.wsr.db";
               masters {172.16.20.10; };
               allow-transfer {"none"; };
               allow-notify {172.16.20.10; };
               masterfile-format text;
       };
       
       zone "20.16.172.in-addr.arpa" IN {
               type slave;
               file "/var/named/slaves/slave.20.16.172.in-addr.arpa.db";
               masters {172.16.20.10; };
               allow-transfer {"none"; };
               allow-notify {172.16.20.10; };
               masterfile-format text;
       };
       
       zone "100.16.172.in-addr.arpa" IN {
               type slave;
               file "/var/named/slaves/slave.100.16.172.in-addr.arpa.db";
               masters {172.16.20.10; };
               allow-transfer {"none"; };
               allow-notify {172.16.20.10; };
               masterfile-format text;
       };
       
       zone "200.16.172.in-addr.arpa" IN {
               type slave;
               file "/var/named/slaves/slave.200.16.172.in-addr.arpa.db";
               masters {172.16.20.10; };
               allow-transfer {"none"; };
               allow-notify {172.16.20.10; };
               masterfile-format text;
       };
       
       zone "20.168.192.in-addr.arpa" IN {
               type slave;
               file "/var/named/slaves/slave.20.168.192.in-addr.arpa.db";
               masters {172.16.20.10; };
               allow-transfer {"none"; };
               allow-notify {172.16.20.10; };
               masterfile-format text;
       };
       ```

     * **/var/named/slaves/slave.skill39.wsr.db** (прямая зона полученная с мастер сервера)

       ```
       $ORIGIN .
       $TTL 604800     ; 1 week
       skill39.wsr             IN SOA  ns01.skill39.wsr. root.skill39.wsr. (
                                       10         ; serial
                                       604800     ; refresh (1 week)
                                       86400      ; retry (1 day)
                                       2419200    ; expire (4 weeks)
                                       604800     ; minimum (1 week)
                                       )
                               NS      ns01.skill39.wsr.
                               NS      ns02.skill39.wsr.
       $ORIGIN skill39.wsr.
       l-cli-a                 A       172.16.100.65
       l-cli-b                 A       172.16.200.61
       l-fw                    A       172.16.20.1
                               A       172.16.50.1
                               A       172.16.55.1
       l-srv                   A       172.16.20.10
       ns01                    A       172.16.20.10
       ns02                    A       192.168.20.10
       r-fw                    A       192.168.20.1
       r-srv                   A       192.168.20.10
       server                  CNAME   l-srv
       www                     CNAME   r-fw
       ```

     * **/var/named/slaves/slave.20.16.172.in-addr.arpa.db** (обратная зона полученная с мастер сервера)

       ```
       $ORIGIN .
       $TTL 604800     ; 1 week
       20.16.172.in-addr.arpa  IN SOA  ns01.skill39.wsr. root.skill39.wsr. (
                                       5          ; serial
                                       604800     ; refresh (1 week)
                                       86400      ; retry (1 day)
                                       2419200    ; expire (4 weeks)
                                       604800     ; minimum (1 week)
                                       )
                               NS      ns01.skill39.wsr.
                               NS      ns02.skill39.wsr.
       $ORIGIN 20.16.172.in-addr.arpa.
       1                       PTR     l-fw.skill39.wsr.
       10                      PTR     ns01.skill39.wsr.
                               PTR     l-srv.skill39.wsr.
       ```

   

3. Проверка

   * nslookup

     * L-RTR-A

       ```
       root@L-RTR-A:~# nslookup l-srv
         Server:         172.16.20.10
         Address:        172.16.20.10#53
       
         Name:   l-srv.skill39.wsr
         Address: 172.16.20.10
       
       
       root@L-RTR-A:~# nslookup 172.16.20.10
         10.20.16.172.in-addr.arpa       name = ns01.skill39.wsr.
         10.20.16.172.in-addr.arpa       name = l-srv.skill39.wsr.
       ```
     
       ```
       root@L-RTR-A:~# nslookup r-srv
         Server:         172.16.20.10
         Address:        172.16.20.10#53
       
         Name:   r-srv.skill39.wsr
         Address: 192.168.20.10
       
       
       root@L-RTR-A:~# nslookup 192.168.20.10
         10.20.168.192.in-addr.arpa      name = r-srv.skill39.wsr.
         10.20.168.192.in-addr.arpa      name = ns02.skill39.wsr.
       ```

       

     * R-RTR
     
       ```
       [root@R-RTR ~]# nslookup r-srv
         Server:         192.168.20.10
         Address:        192.168.20.10#53
       
         Name:   r-srv.skill39.wsr
         Address: 192.168.20.10
       
       
       [root@R-RTR ~]# nslookup 192.168.20.10
         10.20.168.192.in-addr.arpa      name = ns02.skill39.wsr.
         10.20.168.192.in-addr.arpa      name = r-srv.skill39.wsr.
       ```
       
       ```
       [root@R-RTR ~]# nslookup l-srv
         Server:         192.168.20.10
         Address:        192.168.20.10#53
       
         Name:   l-srv.skill39.wsr
         Address: 172.16.20.10
       
       
       [root@R-RTR ~]# nslookup 172.16.20.10
         10.20.16.172.in-addr.arpa       name = l-srv.skill39.wsr.
         10.20.16.172.in-addr.arpa       name = ns01.skill39.wsr.
       ```
       
       

