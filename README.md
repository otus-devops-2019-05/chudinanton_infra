# chudinanton_infra
## ДЗ№7
## В процессе сделано:
 - Создано правило доступа по ssh. Проверена возможность его создания (нужно делать импорт, если правило уже есть)
 - Задан IP для инстанса с приложением в виде внешнего ресурса (ссылка на объявленный ресурс).
 - Создано два новых образа (вынесена бд в отдельный образ). Протестировано создание двух ВМ на основе этих образов.
 - Конфигурация разбита по файлам.
 - Создано три модуля: app, db, vpc. Проведена параметризация. Заданы диапазоны IP.
 - Созданы и протестированы два окружения: Stage & Prod. В каждом окружение выполнено terraform init & apply
 - Создано три бакета: два тестовых и 1 под хранение state файлов.
 - В обоих окружениях созданы backend'ы и протестирована работа согласно ДЗ. State файлы обоих окружений хранятся в бакете в разных папках.
 - Использован provisioner для db модуля который разрешает монге слушать 0.0.0.0.
 - Использован провайдер template для передачи module.db.mongodb_external_ip в переменную окружения DATABASE_URL через генерацию puma.service.


### Ссылки:
 - https://www.terraform.io/docs/providers/template/d/file.html
 - https://habr.com/ru/company/southbridge/blog/255845/
 - https://www.terraform.io/docs/providers/google/r/compute_address.html
 - Видео с курса где Иван рассказывает как прикрутить backend.


## ДЗ№6
## Сделано:
 - Выполнено основное задание. С помощью terraform развернуто приложение с открытие портов и параметризацией.
 - Выполнено дополнительное задание №1 по добавлению пользователей.
Пример:

<pre>
resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "appuser1:${file(var.public_key_path_appuser1)}\nappuser2:${file(var.public_key_path_appuser2)}\nappuser3:${file(var.public_key_path_appuser3)}"
  }
}
</pre>

Нужено учитывать, что если создать пользователя через UI, то они удаляться после применения конфигурации  terraform apply -auto-approve=true

Ссылка на документацию:

https://www.terraform.io/docs/providers/google/r/compute_project_metadata.html

- Создан балансировщик, правило проверки и инстанс пул.
- Добавлена вторая нода, добавлена в балансировщик. Проблема: Излишнее количество кода.
- Добавлена вторая нода через count.  Протестировано развертывание.






## ДЗ№5
## Сделано:
 - Создан образ reddit-base. Протестировано создание ВМ из него и работоспособность приложения reddit-app.
 - Параметризован шаблон ubuntu16.json согласно ДЗ, добавлен файл variables.json.
 - Протестировано создание ВМ из образа reddit-base.
 - Создан параметризованный шаблон immutable.json в котором производится установка ruby, mongodb, установлено приложение, создается unit файл.
 - Создан образ reddit-full из immutable.json. Протестировано создание ВМ и работа приложения.
 - Написан скрипт create-reddit-vm.sh для быстрого деплоя вм через gcloud.

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
