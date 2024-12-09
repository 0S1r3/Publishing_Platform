# Используем официальный PHP образ с поддержкой FPM (обновляем до версии 8.2)
FROM php:8.2-fpm

# Устанавливаем системные зависимости и PHP-расширения
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo pdo_pgsql zip fileinfo

# Устанавливаем Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Копируем файлы проекта
COPY . .

# Устанавливаем зависимости через Composer
RUN composer install --no-dev --optimize-autoloader

# Устанавливаем права доступа для storage и bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Открываем порт для работы
EXPOSE 9000

CMD ["php-fpm"]
