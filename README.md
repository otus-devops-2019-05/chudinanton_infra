# chudinanton_infra

Подключение к someinternalhost одной командой:
ssh -t -i ~/.ssh/id_rsa -A chudinanton@35.246.131.118 ssh 10.156.0.4

Вариант решения для подключения из консоли припомощи команды вида "ssh someinternalhost"
из локальной консоли рабочегоустройства, чтобы подключение выполнялось по алиасу someinternalhost.


Вариант A:
Внести в ~/.ssh/config следующие настройки:


<pre>
Host bastion
  Hostname 35.246.131.118
  User chudinanton
  Port 22
  IdentityFile /Users/admin/.ssh/id_rsa

Host someinternalhost
  Hostname 35.246.131.118
  User chudinanton
  Port 22
  RequestTTY force
  RemoteCommand ssh 10.156.0.4
  IdentityFile /Users/admin/.ssh/id_rsa
  ForwardAgent yes
</pre>

После этого можно подключаться к bastion и someinternalhost через команду ssh someinternalhost

Вариант B:

Внести в ~/.ssh/config следующие настройки:

<pre>
Host bastion
  Hostname 35.246.131.118
  User chudinanton
  IdentityFile /Users/admin/.ssh/id_rsa

Host someinternalhost 10.156.0.4
  Hostname 10.156.0.4
  User chudinanton
  ProxyCommand ssh -W %h:%p bastion
  IdentityFile /Users/admin/.ssh/id_rsa
</pre>


После этого можно подключаться к bastion и someinternalhost через команду ssh someinternalhost


bastion_IP = 35.246.131.118

someinternalhost_IP = 10.156.0.4

