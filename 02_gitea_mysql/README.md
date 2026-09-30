# хостинг репозиториев gitea + mysql (задание 4)

многоконтейнерный проект для развертывания легковесного git-сервера gitea с выделенной субд mysql 8.4 lts.

## архитектурные решения

• **двухуровневая сеть (two-tier network):**
  - `vipkc_gitea_frontend` (мостовая сеть) — обеспечивает маршрутизацию трафика пользователей к web-интерфейсу (порт 3000) и ssh (порт 2222).
  - `vipkc_gitea_backend` (`internal: true`) — строго изолированная сеть. СУБД MySQL доступна только контейнеру Gitea по имени сервиса `gitea-db:3306`. Никакие порты СУБД не открываются на хост-машине.
• **healthcheck и строгая очередность запуска:** Gitea не стартует, пока MySQL не ответит на `mysqladmin ping`.
• **персистентность данных:** именованные тома `vipkc_gitea_mysql_data` и `vipkc_gitea_app_data`.

## запуск и проверка

```bash
docker compose config
docker compose up -d
docker compose ps
docker network inspect vipkc_gitea_backend
```
