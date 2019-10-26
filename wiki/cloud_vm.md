# Cloud VM

## Деплой тестового приложения (cloud-testapp)

В этом задании был опробован функционал создания инстансов через cli утилиту gcloud. Startup скрипт для автодеплоя при создании инстанса находится в файле `startup.sh`.

### Создание инстанса через gcloud cli
Пример команды:
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
```

### Использование startup скрипта по url
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://gist.githubusercontent.com/Kazauwa/03313f9ea328bb3d1bc2592c24927d4e/raw/3d38029f12e7fd25908f11a98d30b6142ea5417f/otus_cloud-testapp_startup.sh
```

### Использование startup скрипта из локального файла
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=./startup.sh
```

### Создание правила для файервола
```
gcloud compute firewall-rules create default-puma-server \
  --allow=tcp:9292 \
  --target-tags=puma-server
```
