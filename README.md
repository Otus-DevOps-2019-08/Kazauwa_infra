# Kazauwa_infra

## Table of contents

1. [Bastion](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/bastion.md)
2. [Cloud VM](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/cloud_vm.md)
3. [Packer](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/packer.md)
4. [Terraform](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/terraform.md)

## Ansible

### Как использовать
Для начала, необходимо завести инвентарный файл, в котором будут перечислены хосты, к которым будет подключаться ансибл. Поддерживаются форматы ini, yaml и json, можно использовать любой. Пример такого файла можно найти в `ansible/inventory` и `ansible/inventory.yaml`. Теперь, можно выполнять команды на указанных хостах. Пример:
```
ansible <название хоста или группы> -m command -a uptime
```
Данная команда выполнит команду `uptime` на указанном хосте

### Плейбуки
Выполнять по одной команде за раз неудобно (да и непрактично), поэтому их принято объединять в плейбуки. Плейбук содержит последовательный набор команд, описанный в формате `yml`. Такой подход позволяет описывать свою инфраструктуру как код. Пример содержимого плейбука:
```
---
- name: Clone
  hosts: app
  tasks:
    - name: Clone repo
      git:
        repo: https://github.com/express42/reddit.git
        dest: /home/appuser/reddit

    - name: Install app dependencies
      command: bundle install
```

### Идемпотнентность
Ансибл позволяет выполнять одни и те же команды многократно, не меняя результат первоначального применения. Например, если требуется склонировать репозиторий из гита. Если репозиторий по указаному пути есть, то ансибл будет клонировать его повторно. Это свойство позволяет не изменять лишний раз систему, если её текущее состояние соответствует желаемому конечному результату.

## CI config

```
bastion_IP = 35.207.103.97
someinternalhost_IP = 10.156.0.3
testapp_IP = 34.89.113.181
testapp_port = 9292
```
