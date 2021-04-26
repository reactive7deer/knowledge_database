## Подготовка машины

Проверить установлен ли пакет `ssh`, установить если нет, в `/etc/ssh/sshd_config` проверить:

```bash
Port $PORT # Номер порта, на котором слушает OpenSSH сервер
ListenAddress $ADDRESS # Адреса, на которых слушает OpenSSH сервер
			  0.0.0.0 # - на всех IPv4
			  10.10.10.10 # - на определённом 10.10.10.10 IPv4
			  :: # - на всех IPv6
			  2001:a:b:900 # - на определённом 2001:a:b:900 IPv6
PermitRootLogin {yes|no|prohibit-password} # разрешение/запрет входа под рутом
```

Также, чтобы каждый раз при sudo не вводить пароль, нужно сделать следующее:

```bash
sudo echo "ALL ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```

## Шаблон для добавления пользователей

```bash
sudo useradd -m -s /bin/bash -p '$SHA512_PASSW' $USERNAME
sudo mkdir /home/$USERNAME/.ssh
sudo echo '$PUBKEY' > /home/$USERNAME/.ssh/authorized_keys
sudo usermod -aG sudo $USERNAME
```

## Пользователи

### Салаткин Д.

Login: `salatkin_d`

```bash
sudo useradd -m -s /bin/bash -p '$6$mWOcgZjE/pAXcl4p$ibiLAGrU9NwgI/Oc1Zl6ZRGMoP6NrjAZ/5UlpP0banyFy8XP/HT/.cfh6grYzwMsDjWe02z/1xEMdCNkuu0JQ/' salatkin_d
sudo mkdir /home/salatkin_d/.ssh
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjXKxZsJcjuTYRvZ5Colj5RqRIOaC4ZOO7ttY8kyNZCFsexbz/pqxDDW6wKqKHn7jEvlrzJvrTGmWwLwuXF4QHOUJEesTLS7gxfzOgJHU29L2ziSNkO54f21AuSP2efPnBr8zNgk6LcY51aGUAsPqpyrJFQLDGw/IeQOm2nKGZnYPK+HstBmmIBLg5LXaaEws8X53BU5hELCJkACbvHJSejMWMLwqkUcClABQ8x3jYWPlrhZfDSoEplGQxOxsaVAiGAmLAnVhvixV8ngVnlTxO41yMglTc11tPABpj/42hKudU2ByZ6WXVA3QV/Uq9cPJ4MNpef6q65brkY76mHQYLQ== rea7@rea7-office" > /home/salatkin_d/.ssh/authorized_keys
sudo usermod -aG sudo salatkin_d
```

### Барбариго К.

Login: `barbarigo_k`

```bash
sudo useradd -m -s /bin/bash -p '$6$D4a6TUds3GBRxY$FwUgHl0SQiQMyfrNUXXlfdY89x7SIBZHh96mlM/xGDBPwDYWzvA5bUwbKzomJbA/wngZyB0rjk3SnOCNczmCp.' barbarigo_k
sudo mkdir /home/barbarigo_k/.ssh
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvJSaOp5qBNMYyhlz89qqDIwC9JUZtjb8nB2MWN1PDHhpjWIUEAIO9gAH5Fs0McerXyL3umMF3QiRjzkiBrFt6I+X1tz6e5btNiZA8z33MFmciMIgWAOSguDMPji/KxPczuDae4f8KBCLDlb/6IVeAqZhYvNcG4mSscQLn/HaHK5aE5D0ht3PlYrD/xJRPNla5YK4hfCEICZ38I9kfmlzzAA6OYOUwjAq6rB6fGN1IetkmPjxBHoreUs5JPM5A2VZT7r4ZNeF3g3JEezgU829a4lrjrh8ojGXK2RdkrSQrc6ZWEjj6p08z87LPjmVLJHljhhNne58CENLxCVrxPQYDw== rsa-key-20200925" > /home/barbarigo_k/.ssh/authorized_keys
sudo usermod -aG sudo barbarigo_k
```

