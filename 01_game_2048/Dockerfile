# этап 1: минимальный базовый образ на базе alpine linux
FROM nginx:1.27.4-alpine3.21-slim

# метаданные образа
LABEL maintainer="Egor Radin <glutinosa@users.noreply.github.com>"
LABEL org.opencontainers.image.title="2048 Game"
LABEL org.opencontainers.image.description="Оптимизированный контейнер для игры 2048 на Nginx Alpine"
LABEL org.opencontainers.image.source="https://github.com/RuttiTuttii/VIPKC"
LABEL org.opencontainers.image.version="1.0.0"

# удаляем стандартную страницу приветствия nginx
RUN rm -rf /usr/share/nginx/html/* /etc/nginx/conf.d/default.conf

# копируем конфигурацию виртуального хоста
COPY nginx.conf /etc/nginx/conf.d/default.conf

# копируем статические исходники игры
COPY src/ /usr/share/nginx/html/

# настраиваем права доступа только для чтения статики
RUN chmod -R 755 /usr/share/nginx/html

# встроенный healthcheck для автоматического контроля состояния контейнера
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q --spider http://127.0.0.1:80/healthz || exit 1

EXPOSE 80

# запуск nginx на переднем плане
CMD ["nginx", "-g", "daemon off;"]
