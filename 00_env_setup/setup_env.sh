#!/usr/bin/env bash
# скрипт настройки пользовательских переменных окружения для docker и docker compose
# лабораторная работа №8: обеспечение межконтейнерного взаимодействия

set -euo pipefail

echo "=== [1/2] настройка системных переменных для docker и compose ==="
# включаем buildkit для быстрой параллельной сборки и кэширования слоев
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# базовый префикс для изоляции проектов compose
export COMPOSE_PROJECT_NAME="vipkc_lab8"

# путь к конфигурации docker клиента
export DOCKER_CONFIG="${HOME}/.docker"

echo "docker_buildkit=${DOCKER_BUILDKIT}"
echo "compose_docker_cli_build=${COMPOSE_DOCKER_CLI_BUILD}"
echo "compose_project_name=${COMPOSE_PROJECT_NAME}"

echo ""
echo "=== [2/2] экспорт переменных текущего пользователя для контейнеров ==="
# текущий пользователь хоста и его идентификаторы (для не-root запуска контейнеров)
export APP_USER="${USER:-eegor}"
export APP_UID="$(id -u)"
export APP_GID="$(id -g)"
export APP_HOME="${HOME:-/home/eegor}"
export APP_TIMEZONE="Europe/Moscow"

echo "app_user=${APP_USER}"
echo "app_uid=${APP_UID}"
echo "app_gid=${APP_GID}"
echo "app_timezone=${APP_TIMEZONE}"

# генерируем локальный .env файл для автоматического подхвата compose
cat <<EOF > "$(dirname "$0")/.env"
# автоматически сгенерировано скриптом setup_env.sh
USER=${APP_USER}
UID=${APP_UID}
GID=${APP_GID}
TIMEZONE=${APP_TIMEZONE}
COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME}
EOF

echo ""
echo "конфигурация успешно сохранена в $(dirname "$0")/.env"
