# PPPoE



## Сервер

```
# Правила для AAA
aaa authen ppp def local
aaa autho network def local

# Создание пользователя для аутентификации клиента
username sfpppoe pass sfpppass

#Пул адресов для клиентов. Выдаваться будет один адрес
ip local pool [имя_пула] 5.231.17.66 

#Конфигурация виртуального интерфейса
int virtual-template 1
	ip unnumbered Fa0/1		#Виртуальный берет адрес физического
	ip virtual-reassembly
	peer default ip address pool [имя_пула]
	ppp authen pap		# С chap были проблемы

#Включение поддержки PPPoE
bba-group pppoe global
	vitual-template 1
	#Ниже опционально
	session max limit 10
	sessions per-mac limit 1
	sessions auto cleanup

# Включаем PPPoE онцентратор на интерфейсе
int fa0/1
	pppoe enable group global

```



## Клиент

```
# Убираем адрес с физического интерфейса
int fa0/1
	no ip add
	
# Создаем виртуальный интерфейс dialer
int dialer 1
	ip add negotiated
	ip mtu 1492
	ip virtual-reassembly
	encapsulation ppp
	ip tcp adjust-mss 1432 (Не мое: очень полезная строка в тех случаях, если пакеты большие 1492 отбразываются)
 	dialer pool 1
	(этой строкой мы задаём номер pool для использования на физическом интерфейсе)
	no cdp enable
	ppp pap hostname [логин]
	ppp pap password [пароль]
	
# Теперь связываем dialer и физический интерфейс
int fa0/1
	pppoe-client dial-pool-number 1
```





## Проверка, траблшут

`show pppoe session`

```
terminal monitor
debug pppoe errors
```







## Источники

http://itmemos.blogspot.com/2008/12/pppoe-cisco.html

http://itmemos.blogspot.com/2008/10/pppoe-cisco.html