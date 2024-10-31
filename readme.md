# Что делает приложение
Синхронизирует содержимое директории `static_site` в вашем облачном хранилище, например google drive с protected разделом нашего приложения.

## Как работает
Поднимается контейнер nginx с одним настроеным сайтом. На сайте есть public часть и раздел protected, by default protected раздел защищён [Authelia](https://www.authelia.com/). Далее запускается контейнер с [rclone](https://rclone.org), его можно настроить на работу с любым облачным провайдером: onedrive, yandex disk, google drive и т.д.

## Как запустить:
1. указать адрес вашего инстанса Authelia `static_site\nginx.conf`:
```bash
location = /authelia-verify {
            internal;
            proxy_pass http://<authelia>/api/verify;
            proxy_set_header X-Original-URI $request_uri;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
        }
```
Можно указать FQDN имя или IP адрес локального инстанса, например: `192.168.122.5:9092`

2. Получить секреты для выбранного провайдера, например для google drive

## Инструкция, как создать секреты google drive для rclone.conf
https://rclone.org/drive/#making-your-own-client-id

3. Настраиваем доступ пользователю или группе пользователей до protected раздела в Authelia:
```bash
access_control:
  default_policy: deny
  rules:
    - domain: "static.iamninja.ru"
      policy: two_factor
      resources:
        - "^/protected/.*$"
    - domain:
        - "auth.iamninja.ru"
        - "static.iamninja.ru"
      policy: bypass
      resources:
        - "^/.*$"
```
Запрещающее правило должно быть сверху.

4. Создём директорию static_site у себя в облаке, у нас google drive

5. Создать директорию rclone, если нет: `mkdir -p /config/rclone`

6. Обновить полученный по инструкции файл для rclone (заполнить значения или заменить своим): `/config/rclone.conf`

7. Запускаем приложение:
```bash
docker compose up -d
```

Теперь всё что попадёт в google drive в директорию static_site будет синкаться с protected разделом нашего сайта. Поддерживается создание вложенных директорий с различным содержимым, в каждой директории будет сгенерирова index.html с подлинкованным содержимым директории.