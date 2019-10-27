# Kazauwa_infra

## Table of contents

1. [Bastion](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/bastion.md)
2. [Cloud VM](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/cloud_vm.md)

## Packer
В этом задании был создан образ с запечённым приложением reddit, который готов к разворачиванию в GCP

### Как создать образ
В папке `packer` находится файл `ubuntu16.json`. Это и есть шаблон для packer, с помощью которого создаётся образ. Для сборки требуется указать некоторые переменные, которые можно положить в `variables.json`:

* project_id - id проекта в GCP
* source_image_family - базовый образ
* ssh_username - имя пользователя, который используется для доступа по ssh
* machine_type - тип инстанса
* disk_size - размер жёсткого диска
* disk_type - тип жёсткого диска: обычный или ssd
* network - имя VPC сети
* tags - теги правил файервола

Для сборки используется следующая команда:
```
packer build -var-file variables.json ./ubuntu16.json
```

## CI config

```
bastion_IP = 35.207.103.97
someinternalhost_IP = 10.156.0.3
testapp_IP = 34.89.113.181
testapp_port = 9292
```
