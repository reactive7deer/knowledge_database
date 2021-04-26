### SSH (проверка)

---

* **OUT-CLI**

  * Директория .ssh в домашней папке

    ```bash
    [root@OUT-CLI ~]# ls -al .ssh/
    total 16
    drwx------. 2 root root   77 Oct 18 21:35 .
    dr-xr-x---. 3 root root  147 Oct 18 19:25 ..
    -rw-r--r--. 1 root root  949 Oct 18 21:29 back_confing
    -rw-------. 1 root root 2602 Oct 18 15:45 id_rsa
    -rw-r--r--. 1 root root  566 Oct 18 15:45 id_rsa.pub
    -rw-r--r--. 1 root root  392 Oct 18 15:55 known_hosts
    ```

  * Подключение к L-FW на пользователя ssh_p

    ```bash
    [root@OUT-CLI ~]# ssh ssh_p@10.10.10.1
    Linux L-FW 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64
    
    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.
    
    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Sun Oct 18 21:17:27 2020 from 20.20.20.5
    ssh_p@L-FW:~$
    ```



* **L-FW**

  * Файл sshd_config

    ```shell
    Port 22
    #AddressFamily any
    ListenAddress 0.0.0.0
    #ListenAddress ::
    
    HostKey /etc/ssh/ssh_host_rsa_key
    #HostKey /etc/ssh/ssh_host_ecdsa_key
    #HostKey /etc/ssh/ssh_host_ed25519_key
    
    # Ciphers and keying
    #RekeyLimit default none
    
    # Logging
    #SyslogFacility AUTH
    #LogLevel INFO
    
    # Authentication:
    
    #LoginGraceTime 2m
    PermitRootLogin yes
    #prohibit-password
    #StrictModes yes
    #MaxAuthTries 6
    #MaxSessions 10
    AllowUsers root ssh_p ssh_c
    
    PubkeyAuthentication yes
    
    # Expect .ssh/authorized_keys2 to be disregarded by default in future.
    AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2
    
    ```

  * Файл **authorized_keys** в домашней директории пользователя ssh_p

    ```
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYKXueKfZ/AiHxLwZq1vcAy6tIQjkuvL+sqy8GCZA5oXAGPdp4Ffh3HWUFAOuW0KMANa8osSonSxWC4QlBl3PSgOnurZuEZMjzlz44sYMoU0ThbCaidAkcZnYPdqIsYD64/qqFHXlz1eA2qWaN1CnmQaazxfuGQKEzaeJOjQhiYNPWcYWG9t4hx3Ua8pddqJmeheeephD/oU+k0QATWxuf5e7I+n3D+kGDjxmjzWp2LkFRwLPiwNp1hv0ICBGRo6hyznzHp8DDVxAmbRu9rNu8tePMZNx2tyygnwxGzuJ2kN1pQo+HebjhfkzVUPCTGLFKvZlCKqm/Vahlt1mYpQLUwCqFYus6rikETnuitUS1HeiW+9OriD9TdkirNAk84wyw5pFvHKj8OhbWQ0XMwwFuYHyzEugIO3hYWFTzZM0/v1d0lb8u3fl/ga3A/crD88dYxfZHF+ltP0N+BxtQzJf05ky6aJh6SoxoeWfeG5TvU2xtNL1dQ2cmju9WcxRynh0= root@OUT-CLI
    ```



* **R-RTR-A**

  * SSH подключение к L-FW к пользователю root

    ```shell
    root@L-RTR-A:~# ssh root@172.16.50.1
    root@172.16.50.1's password:
    Linux L-FW 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64
    
    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.
    
    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Sun Oct 18 19:06:35 2020 from 20.20.20.5
    root@L-FW:~#
    ```

  * SSH подключение к L-FW к пользователю ssh_p

    ```shell
    root@L-RTR-A:~# ssh ssh_p@172.16.50.1
    ssh_p@172.16.50.1's password:
    Linux L-FW 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64
    
    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.
    
    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Sun Oct 18 21:30:16 2020 from 20.20.20.5
    ssh_p@L-FW:~$
    ```

  * SSH подключение к L-FW к пользователю ssh_c

    ```shell
    root@L-RTR-A:~# ssh ssh_c@172.16.50.1
    ssh_c@172.16.50.1's password:
    Linux L-FW 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64
    
    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Sun Oct 18 19:02:12 2020 from 20.20.20.5
    ssh_c@L-FW:~$
    ```

    

