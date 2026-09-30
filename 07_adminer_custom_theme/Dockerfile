# кастомная сборка adminer с предустановленной темной темой оформления
# задание 10: смена скинчика на основе официального репозитория vrana/adminer

FROM adminer:4.8.1

# метаданные
LABEL maintainer="Egor Radin <glutinosa@users.noreply.github.com>"
LABEL description="Adminer 4.8.1 с предустановленной темой оформления rmsoft_blue-dark"

# копируем выбранный css-файл темы в стандартный путь стилей adminer
COPY themes/adminer.css /var/www/html/adminer.css

# переключаемся на непривилегированного пользователя adminer
USER adminer

EXPOSE 8080
