# випкс: лабораторная работа №8

репозиторий с решением лабораторной работы №8 по дисциплине **«внедрение и поддержка компьютерных систем» (випкс)**.  
тема: **«обеспечение межконтейнерного взаимодействия средствами docker compose»**.

в репозитории реализованы законченные, изолированные и максимально избыточные конфигурации docker compose со строгим разделением прав, неизменяемыми версиями базовых образов и сетевой изоляцией баз данных по принципу наименьших привилегий (least privilege).

все внешние порты сервисов вынесены в уникальный диапазон **`44xx`**, что гарантирует отсутствие коллизий и конфликтов портов при развертывании на многопользовательских учебных серверах.

каждый логический блок в compose-файлах и dockerfile подробно прокомментирован на русском языке с маленькой буквы в разговорном техническом стиле.

---

## сводная таблица проектов и портов

| каталог | сервис / стек | образ (pinned tag) | сеть / изоляция | внешний порт | описание |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [`00_env_setup/`](00_env_setup) | docker cli & env | — | хост | — | настройка buildkit, имени проекта и проброс `$USER`, `$UID`, `$GID` |
| [`01_game_2048/`](01_game_2048) | игра 2048 (web) | `ruttituttii/2048:1.0.0` | `vipkc_game_net` | **`4448:80`** | кастомный минимальный unprivileged nginx (alpine) с исходниками из личного реестра |
| [`02_gitea_mysql/`](02_gitea_mysql) | gitea + mysql | `gitea/gitea:1.22.6`<br>`mysql:8.4.4` | `gitea_frontend`<br>`gitea_backend` (`internal`) | **`4430:3000`**<br>`4422:22` (ssh) | двухзвенная архитектура git-хостинга; mysql изолирован от внешнего мира |
| [`03_flame_dashboard/`](03_flame_dashboard) | flame dashboard | `pawelmalak/flame:2.3.1` | `vipkc_flame_net` | **`4455:5005`** | панель мониторинга с безопасным пробросом `/var/run/docker.sock:ro` |
| [`04_filebrowser/`](04_filebrowser) | filebrowser | `filebrowser/filebrowser:v2.63.23` | `vipkc_filebrowser_net` | **`4444:80`** | файловый веб-хостинг, запущенный от id пользователя хоста без root-прав |
| [`05_phpmyadmin_mysql/`](05_phpmyadmin_mysql) | phpmyadmin + mysql | `phpmyadmin:5.2.2-apache`<br>`mysql:8.4.4` | `pma_public_net`<br>`pma_db_internal` (`internal`) | **`4481:80`** | сетевая изоляция: субд не публикует порт 3306 на хост, доступна только для pma |
| [`06_phppgadmin_postgres/`](06_phppgadmin_postgres) | phppgadmin + postgres | `dockage/phppgadmin:latest`<br>`postgres:13.18-alpine` | `pg_public_net`<br>`pg_db_internal` (`internal`) | **`4482:80`** | решение проблем совместимости postgresql: md5 пароли и обход `extra_login_security` |
| [`07_adminer_custom_theme/`](07_adminer_custom_theme) | adminer + mariadb | `adminer:4.8.1`<br>`mariadb:11.4.5` | `adminer_public_net`<br>`adminer_db_internal` (`internal`) | **`4483:8080`** | кастомизация скинчика через volume mount и dockerfile (темная тема rmsoft_blue-dark) |

---

## структура репозитория

```
VIPKC/
├── .gitignore                          # исключение секретов, постоянных данных томов и кэшей
├── README.md                           # сводная документация по всей лабораторной работе
│
├── 00_env_setup/                       # задания 1, 2: переменные окружения docker и хоста
│   ├── setup_env.sh                    # скрипт настройки buildkit и экспорта uid/gid
│   ├── .env.example                    # шаблон переменных
│   └── README.md
│
├── 01_game_2048/                       # задание 3: игра 2048 из собственного реестра
│   ├── Dockerfile                      # многоступенчатый минимальный nginx-alpine
│   ├── .dockerignore                   # оптимизация контекста сборки
│   ├── nginx.conf                      # конфигурация с заголовками безопасности и /healthz
│   ├── docker-compose.yml              # запуск на порту 4448 с healthcheck и лимитами
│   ├── src/                            # исходный код игры (RuttiTuttii/2048)
│   └── README.md
│
├── 02_gitea_mysql/                     # задание 4: gitea + mysql в одной связке
│   ├── docker-compose.yml              # двухуровневая сеть, строгий healthcheck
│   ├── .env.example                    # безопасные учетные данные
│   └── README.md
│
├── 03_flame_dashboard/                 # задание 5: flame dashboard
│   ├── docker-compose.yml              # ro-сокет docker, защита паролем
│   ├── .env.example
│   └── README.md
│
├── 04_filebrowser/                     # задание 6: filebrowser
│   ├── docker-compose.yml              # уникальный порт 4444, user: ${UID}:${GID}
│   ├── settings.json                   # параметры сервера
│   ├── srv/                            # рабочая директория файлов пользователя
│   ├── .env.example
│   └── README.md
│
├── 05_phpmyadmin_mysql/                # задание 7: phpmyadmin + mysql
│   ├── docker-compose.yml              # internal: true для бд, двухзвенная топология
│   ├── .env.example
│   └── README.md
│
├── 06_phppgadmin_postgres/             # задание 8: phppgadmin + postgres
│   ├── docker-compose.yml              # фикс md5 аутентификации и extra_login_security
│   ├── .env.example
│   └── README.md
│
├── 07_adminer_custom_theme/            # задания 9, 10: adminer + скинчик + mariadb
│   ├── Dockerfile                      # вариант запекания темы в кастомный образ
│   ├── docker-compose.yml              # volume mount темы rmsoft_blue-dark и изоляция бд
│   ├── themes/                         # файлы тем из репозитория vrana/adminer
│   │   ├── adminer.css                 # активная темная тема rmsoft_blue-dark
│   │   └── pappu687.css                # альтернативная flat-тема
│   ├── .env.example
│   └── README.md
│
└── Отчеты/                             # оформление результатов по стандартам СПбКТ СПбГУТ
    └── 08_ЛР8_Отчет.md                 # полный академический отчет с выводами и ответами
```

---

## архитектурные принципы и безопасность

1. **сетевая сегментация (least privilege):**  
   все субд (`mysql`, `postgres`, `mariadb`) подключены только к внутренним сетям с директивой `internal: true`. внешние порты баз данных (3306, 5432) намеренно **не публикуются** на хосте. взаимодействие между веб-интерфейсом и СУБД происходит исключительно по внутреннему dns-имени сервиса через приватный мост.
2. **детерминизм и неизменяемость тегов:**  
   в проекте полностью исключено использование плавающего тега `:latest`. все образы зафиксированы на проверенных lts/alpine версиях (`mysql:8.4.4`, `nginx:1.27.4-alpine3.21-slim`, `postgres:13.18-alpine`, `mariadb:11.4.5`).
3. **контроль работоспособности (healthcheck):**  
   веб-сервисы (`gitea`, `phpmyadmin`, `adminer`) используют механизм `depends_on` с флагом `condition: service_healthy`. запуск веб-клиентов происходит только после того, как база данных пройдет ping и подтвердит готовность обслуживать запросы.
4. **запуск от непривилегированных пользователей:**  
   в `04_filebrowser` и `01_game_2048` сервисы запускаются от непривилегированного пользователя (`${UID}:${GID}`), исключая запись файлов под `root` на хосте.
5. **уникальные порты `44xx`:**  
   исключают конфликты на учебных серверах, где стандартные порты (8080, 3000, 80) постоянно заняты другими процессами.

---

## быстрый запуск любого проекта

1. перейдите в нужную папку, например:
   ```bash
   cd 01_game_2048
   ```
2. запустите стек в фоновом режиме:
   ```bash
   docker compose up -d
   ```
3. проверьте состояние контейнеров:
   ```bash
   docker compose ps
   ```
4. проверьте доступность веб-сервиса через curl или браузер:
   ```bash
   curl -I http://localhost:4448
   ```
5. для остановки и очистки ресурсов:
   ```bash
   docker compose down
   ```
