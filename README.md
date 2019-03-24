# chudinanton_infra

## ДЗ№4
### Адрес приложения

<pre>
testapp_IP = 35.246.208.130

testapp_port = 9292
</pre>

## Команды gcloud:
### Создание ВМ через startup_script.sh

<pre>

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=./startup_script.sh

</pre>

### Создание ВМ через --metadata startup-script-url

<pre>

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=gs://chudinanton-test/startup_script.sh

</pre>

### Создание правила в firewall через gcloud

<pre>

gcloud compute firewall-rules create default-puma-service \
  --network default \
  --action allow \
  --direction ingress \
  --rules tcp:9292 \
  --source-ranges 0.0.0.0/0 \
  --priority 1000 \
  --target-tags puma-server

</pre>


## ДЗ№3

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

<pre>
bastion_IP = 35.246.131.118

someinternalhost_IP = 10.156.0.4
</pre>
