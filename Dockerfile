# Usa una imagen base oficial de PHP con Nginx (ej. de Laravel Sail o FPM)
FROM php:8.2-fpm-alpine

# Instalar dependencias del sistema operativo y extensiones PHP necesarias para Laravel
# Alpine es una distribución ligera, por eso usamos 'apk'
RUN apk add --no-cache \
    nginx \
    supervisor \
    build-base \
    autoconf \
    libzip-dev \
    sqlite-dev \
    oniguruma-dev \
    libpq-dev \
    git \
    # Necesario para Composer
    zip \
    unzip \
    # Mantenemos, pero revisamos su posición y si es el nombre correcto
    libpng-dev \
    jpeg-dev \
    freetype-dev \
    # Si usas MySQL, instala esta
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/cache/apk/*
    # Nota: la línea `libpng-dev` estaba en la línea 15 en tu Dockerfile anterior.
    # El error "instrucción desconocida" aquí puede ser un problema de espacio o de caracter invisible
    # o que simplemente ese paquete no se llama así en ese repo de Alpine.
    # Si el error persiste, podríamos probar una base diferente o buscar el nombre exacto del paquete de desarrollo de GD para Alpine 8.2

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar Nginx para Laravel
COPY .docker/nginx/default.conf /etc/nginx/http.d/default.conf

# Configurar PHP FPM
COPY .docker/php/www.conf /etc/php8/php-fpm.d/www.conf
COPY .docker/php/php.ini /etc/php8/conf.d/custom.ini

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Copiar los archivos de la aplicación
COPY . .

# Eliminar la carpeta vendor si existe (Composer la reinstalará)
RUN rm -rf vendor

# Comandos de construcción (Composer Install)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Exponer el puerto
EXPOSE 8000

# Script de inicio
CMD sh -c "php artisan config:cache && php artisan route:cache && php artisan view:cache && php artisan event:cache && php artisan optimize:clear && php artisan migrate --force && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"

# ---- Configuración de Supervisor, Nginx y PHP-FPM ----
# Crear carpetas para logs y supervisor
RUN mkdir -p /var/log/nginx \
           /var/log/supervisor \
           /run/nginx \
           /var/www/html/storage/logs

# Configuración de Supervisor
COPY .docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Permisos para la carpeta storage de Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Puerto de Nginx para salud
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost/ || exit 1
