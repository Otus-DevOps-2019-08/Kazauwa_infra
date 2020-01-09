# Kazauwa_infra

## Table of contents

1. [Bastion](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/bastion.md)
2. [Cloud VM](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/cloud_vm.md)
3. [Packer](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/packer.md)
4. [Terraform](https://github.com/Otus-DevOps-2019-08/Kazauwa_infra/tree/master/wiki/terraform.md)

## Ansible

### Как использовать

Для начала, необходимо завести инвентарный файл, в котором будут перечислены хосты, к которым будет подключаться ансибл. Поддерживаются форматы ini, yaml и json, можно использовать любой. Пример такого файла можно найти в `ansible/inventory` и `ansible/inventory.yaml`. Теперь, можно выполнять команды на указанных хостах. Пример:

```bash
$ ansible <название хоста или группы> -m command -a uptime
```

Данная команда выполнит команду `uptime` на указанном хосте

### Плейбуки

Выполнять по одной команде за раз неудобно (да и непрактично), поэтому их принято объединять в плейбуки. Плейбук содержит последовательный набор команд, описанный в формате `yml`. Такой подход позволяет описывать свою инфраструктуру как код. Пример содержимого плейбука:

```yaml
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

Плейбуков может быть несколько, например один плейбук - одна задача (например, установка бэкэнда или его деплой). Это помогает избежать огромных простыней внутри одного файла, который очень сложно поддерживать. Объединить всё вместе можно с помощью ещё одного (ха!) плейбука (например, `site.yml`), который будет содержать в себе только импорты.

### Роли

Роли позволяют сгруппировать в единое целое описание конфигурации отдельных сервисов и компонент системы (таски, хендлеры, файлы, шаблоны, переменные). Чтобы создать шаблон структуры роли, необходимо такую команду:

```bash
$ ansible-galaxy init <название роли>
```

На выходе получается такая структура:

```bash
my_role
├── defaults             # <-- Директория для переменных по умолчанию
│   └── main.yml
├── files                # <-- Файлы, которые используются в тасках
│   └── puma.service
├── handlers             # <-- Таски-ивенты, которые исполняются по триггеру
│   └── main.yml
├── meta                 # <-- Информация о роли, создателе и зависимостях
│   └── main.yml
├── README.md
├── tasks                # <-- Директория для тасков
│   └── main.yml
├── templates            # <-- Директория для шаблонов файлов
│   └── db_config.j2
├── tests                # <-- Тесты
│   ├── inventory
│   └── test.yml
└── vars                 # <-- Директория для переменных, которые не должны
    └── main.yml         #     переопределяться пользователем
```

### Роли коммьюнити

Своими ролями можно делиться с другими пользователями. Для этого существует [Ansible Galaxy](https://galaxy.ansible.com/) - централизованное место, где эти роли хранятся. Для работы с ними используются одноимённая утилита `ansible-galaxy` и файл `requirements.yml`. Пример файла с зависимостями можно посмотреть в `environments/<env_name>/requirements.yml`. Для установки роли, нужно выполнить следующую команду:

```bash
$ ansible-galaxy install -r requirements.yml
```

**Важно!** Установленным ролям не место в репозитории, поэтому лучше сразу же добавлять их в `.gitignore`.

### Локальная разработка

Во разработки часто возникает необходимость проверить написанную конфигурацию. На первый взгляд, делать это не очень удобно: тратить деньги и ресурсы облачного провайдера не хочется, а накатывать роль на локальную машину чревато последствиями. К счастью, выход есть: создание виртуальной машины через Vagrant и последующий провижн написанной роли Ansible. Для этого достаточно описать `Vagrantfile` и указать ansible в роли провиженера. Там же можно указать необходимый плейбук, а так же переопределить переменные, которые используются в тасках.

### Тестирование роли

Используя подход выше, можно организовать полноценное тестирование нашей роли. Для этого используется `Molecule`. Он представляет из себя полноценный фреймворк: объединяет инструменты для создания виртуального окружения, линтинга, тестирования и валидации ролей. Причём эти компоненты можно менять по своему усмотрению. Например, для создания окружения можно использовать `Docker` вместо `Vagrant`. Или `goss` вместо `testinfra` для тестирования.

Установка происходит через pip:

```bash
pip install molecule
```

Для инициализации тестового сценария роли, нужно выполнить такую команду в корневой папки роли:

```bash
$ molecule init scenario -r <название роли> -d <название провайдера окружения>
```

На выходе получится примерно такая файловая структура:

```bash
molecule
└── default
    ├── INSTALL.rst
    ├── molecule.yml              # Основной файл с настройками
    ├── playbook.yml              # Плейбук, из которого будет запускаться таски тестируемоей роли
    ├── prepare.yml               # Таски для подготовки окружения, как правило не меняются
    └── tests                     # Директория с тестами
        └── test_default.py
```

Для запуска тестов, используется следующая команда:

```bash
$ molecule test
```

В ходе выполнения будет создано виртуальное окружение и проведены следующие проверки:

- Линтинг yaml файлов
- Валидация синтаксиса ansible
- Тест на идемпотентность
- Тестирование сайд-эффектов (опционально)
- Юнит-тестирование

### Окружения

Инфраструктура может состоять из разных окружений (например, Staging, Production, QA), которые могут иметь различия в конфигурации. В Ansible нет механизма для работы с окружениями, но это можно сделать самостоятельно. За основу можно взять пример реализации в данном репозитории. Директория environments содержит две дочерних директории: stage и prod. Каждая содержит свой инвентарный файл и набор переменных для каждой роли. По умолчанию в ansible.cfg указан путь до окружения `stage`, применения плейбука выглядит стандартно:

```bash
$ ansible-playbook playbooks/site.yml
```

Для окружения `prod` добавляется одна маленькая деталь:

```bash
$ ansible-playbook -i environments/prod/inventory playbooks/site.yml
```

### Vault

Чувствительные данные не должны попадать в репозиторий, но они часто бывают необходимы в ходе выполнения тасков плейбука. Для этого в Ansible существует механизм Vault - утилита, которая шифрует чувствительные данные и автоматически расшифровывает их во время запуска плейбука. Для шифрования используется мастер-пароль, который нужно передать команде `ansible-playbook` или указать путь до файла в `ansible.cfg`.

**Важно!**
Такой файл лучше хранить out-of-tree, например в `~/.ansible/vault.key`

Зашифровать одну переменную:

```bash
$ ansible-vault encrypt_string <значение переменной> --name <название переменной>
```

Зашифровать-расшифровать файл:

```bash
$ ansible-vault encrypt <путь до файла>
$ ansible-vault decrypt <путь до файла>
```

Отредактировать зашифрованный файл:

```bash
$ ansible-vault edit <путь до файла>
```

### Теги

С помощью тегов можно управлять списком тасок, который будет выполняться. Это полезно, если хочется обновить конфиг базы данных, но не трогать всё остальное. Теги можно определить на уровне конкретных тасок, плейбуков или ролей. Пример выполнения плейбука с тегом:
```
$ ansible-playbook site.yml -t db-tag
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
