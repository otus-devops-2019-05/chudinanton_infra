# chudinanton_infra
Репозиторий перенесен из другой группы.

## ДЗ№11
## В процессе сделано:
 - Установка Vagrant и Virtualbox.
 - Создан Vagrantfile где описано окружение для тестирование. 
 - Доработаны роли под возможность локального тестирования.
 - Использовал "deploy_user" => "vagrant". vagrant destroy -f && vagrant up отрабатывает корректно. Сервис доступен.
 - Дополнительное задание №1. Переданы переменные для nginx роли. Сервис доступен по 80-му порту.
<pre>
        "nginx_sites" => {
          "default" => [
             "listen 80", 
             "server_name 'reddit'", 
             "location / { proxy_pass http://127.0.0.1:9292; }"
             ]
        }
</pre>
 - Установлено виртуальное окружение:
 <pre>
pip3 install virtualenv
mkdir ~/python-virtualenv && cd ~/python-virtualenv

Создаем виртуальное окружение в папке ~/python-virtualenv
virtualenv venv

Применяем виртуальное окружение
source мenv/bin/activate

Ставим в виртуальное окружение то что нам нужно:
pip install -r ~/chudinanton_infra/ansible/requirements.txt
</pre>
 - Проверена роль DB с помощью Molecule и Testinfra.
<pre>
В директории роли db:
molecule init scenario --scenario-name default -r db -d vagrant

Тесты лежат в виде Python файла здесь:
~/chudinanton_infra/ansible/roles/db/molecule/default/tests/test_default.py

Создание ВМ в молекуле:
molecule create

Список созданных инстансов:
molecule list 

Войти по ssh например для траблшутинга
molecule login -h instance

В prepare.yml в молекуле нужно добавить вниз (иначе монга не будет ставиться):

- name: Run the equivalent of "apt-get update" as a separate step
  apt:
    update_cache: yes

В db/molecule/default/playbook.yml можно например задать переменные

Применим playbook.yml, в котором вызывается наша роль к созданному хосту:
molecule converge

Прогнать тесты:
molecule verify

Прибить виртуалку:
molecule destroy
</pre>

 - Написан тест для проверки того на чем слушает монга. 

Документация к тесту socket_listening:
https://testinfra.readthedocs.io/en/latest/modules.html#socket

Полезные ссылки:
https://habr.com/ru/post/437216/

 - Создано два образа с использованием ролей и тегов. Для app - ruby, для db - install.
<pre>
Чтобы пакер увидел роли нужно прописать env и можно задавать теги используемые в ролях в json пакера:
"extra_arguments": ["--tags","ruby"],
"ansible_env_vars": ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"]

На всякий случай развернул stage окружение из этих образов и применил 
ansible-playbook playbooks/site.yml --ask-vault-pass
</pre>
 - Дополнительное задание 2: Создан новый репозиторий для db роли. Роль подключена к обоим окружениям через requirements.yml и скачана в основной репозиторий. Теперь можно версионировать роль.
<pre>
 - src: https://github.com/chudinanton/mongo-db.git
   version: v.1.4
   name: db

Ставим роль как и nginx:

ansible-galaxy install -r environments/stage/requirements.yml
</pre>

 - Доп. задание 2: настроена интеграция с TravisCI. Он в свою очередь подключатся к GCP создает машину, выполняет тесты, удаляет машину.

Проверить можно здесь:

https://travis-ci.com/chudinanton/mongo-db/builds/109492230

Репозиторий лежит здесь:

https://github.com/chudinanton/mongo-db

 - Доп. задание 2: настроено оповещение в слак из нового репозитория с ролью.



## ДЗ№10
## В процессе сделано:
 - Плейбуки перенесены в роли.
 - Создано два окружения.
 - Сделана уборка в папке ansible.
 - Добавлена коммьюнити роль nginx.
 - Описано открытие 80-го порта для reddit-app в terraform.
 - Созданы пользователи на инстансах с использованием Ansible Vault и ключем шифрования который хранится вне репозитория
<pre>
Путь к ключу: ~/.ansible/vault.key
Шифруем файл:
ansible-vault encrypt environments/stage/credentials.yml

Расшифровываем файл:
ansible-vault decrypt <file>

Редактируем зашифрованный файл:
ansible-vault edit <file>

Запуск плейбука с использованием Vault файла:
ansible-playbook playbooks/site.yml --ask-vault-pass

Документация:
https://docs.ansible.com/ansible/latest/modules/user_module.html

https://docs.ansible.com/ansible/devel/user_guide/vault.html
</pre>

### Дополнительное задание:
- В обоих окружениях настроены динамические инвентори, внутренний ip монги не требуется вбивать руками.



## ДЗ№9
## В процессе сделано:
 - Основное задание: Один playbook,один сценарий; Настройка инстанса приложения; Деплой; Один плейбук,несколько сценариев; 
<pre>
Основная проблема: 
с ростом числа управляемых сервисов,будет расти количество различных сценариев и,как результат, увеличится объем плейбука. Это приведет к тому, что в плейбуке,будет сложно разобраться. <b>Поэтому логично раделять большой проект на несколько плейбуков.</b>
</pre>
 - Основное задание: Несколько плейбуков.
- Задание cо ⭐: Использовал штатный плагиг <b>gcp_compute</b> для динамиского инвентори.

### Полезные ссылки для настройки динамического инвентори:
https://medium.com/@Temikus/ansible-gcp-dynamic-inventory-2-0-7f3531b28434

https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#gce-dynamic-inventory

https://github.com/ansible/ansible/issues/44404

- Провижининг в Packer.
<pre>
Запуск Packer из корня репозитория:
packer validate  -var-file packer/variables.json packer/db.json
packer validate  -var-file packer/variables.json packer/app.json
packer build  -var-file packer/variables.json packer/db.json
packer build  -var-file packer/variables.json packer/app.json
</pre>

### Все модули (удобно побирать по нужную систему):
https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html


## ДЗ№8
## В процессе сделано:
 - Настроен Ansible: добавлен inventory, ansible.cfg, inventory.yml.
 - Проестирована работа playbook -  clone.yml
 - После удаления приложения через "ansible app -m command -a 'rm -rf~/reddit'" выполнение playbook'a приводит к скачиванию приложения, о чем свидетельствует статистика:

<pre>
 PLAY RECAP *******************************************************************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0
</pre>    
 - Создан статический inventory.json, прописан в ansible.cfg и протестировано выполнение команды "ansible all -mping"


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
