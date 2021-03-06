## Terraform
В этом задании была описана инфраструктура виртуальной машины для приложения reddit-app при помощи terraform.

### Как использовать
Перейти в директорию `terraform` и выполнить команду `terraform init`. Далее, нужно заполнить необходимые параметры создания машины, создав файл `terraform.tfvars`. Пример такого файла можно увидеть в папке `terraform`. Смысл каждой переменной и её значение по умолчанию можно подсмотреть в файле `variables.tf`. Наконец, можно создавать машину:
```
terraform plan
```
Если всё окей, то:
```
terraform apply
```

### А чо там создалось?
Терраформ записывает все параметры и свойства созданной машины в `terraform.tfstate`. Для удобства, есть команда `terraform show`, которая показывает его содержимое. Однако, дабы не грепать каждый раз нужные значения, их можно определить явно (см. `outputs.tf`). Теперь, команда `terraform show` будет показывать значение этих переменных в конце своего вывода. Можно отфильтровать конкретное значение:
```
terraform show <название переменной>
```

### Балансировка нагрузки
По умолчанию, терраформ создаёт только один инстанс. Это значение изменяется переменной `target_count` в файле `terraform.tfvars`. У гугла нет готовой балансировки нагрузки из коробки, поэтому её придётся сочинять самостоятельно. Пример реализации находится в файле `lb.tf`. Суть довольно простая: создаётся правило редиректа для файервола, healthcheck и пул целевых инстансов. В этот пул пробрасываются создаваемые инстансы и они пингуются при помощи healthcheck'а. Файервол редиректит запросы в тот или иной инстанс, в зависимости от его доступности.

### Окружения
При работе на реальном проекте, наверняка понадобится разная конфигурация одного и того же сервиса в разных окружениях. Чтобы разделить окружения, достаточно просто создать директорию и поместить туда все необходимые терраформу файлы (`main.tf`, `variables.tf` и т.д.). Каждое окружение необходимо инициализировать отдельно при помощи `terraform init`.

### Модули
А чтобы уменьшить копипасту, можно вынести общий код в модули - именованные наборы ресурсов терраформа (см. `terraform/modules`). Чтобы начать использовать модули, достаточно объявить в `main.tf` такой блок:
```
module "название_модуля" {
    # список переменных
    ...
} 
```
После, терраформу нужно скачать подключенные модули (даже если они находятся в соседней директории) с помощью команды `terraform get`.