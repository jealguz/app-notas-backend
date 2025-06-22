# Usa una imagen base oficial de PHP con Nginx (ej. de Laravel Sail o FPM)
FROM php:8.2-fpm-alpine

# Establecer el directorio de trabajo desde el principio
WORKDIR /var/www/html

# Añadir /usr/local/sbin al PATH para que el sistema encuentre ejecutables como php-fpm si están allí
ENV PATH="/usr/local/sbin:${PATH}"

# Instalar dependencias del sistema operativo y extensiones PHP necesarias para Laravel
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
    zip \
    unzip \
    libpng-dev \
    jpeg-dev \
    freetype-dev \
    && rm -rf /var/cache/apk/*

# Instalar extensiones PHP usando docker-php-ext-install
RUN docker-php-ext-install pdo_mysql \
    pdo_pgsql \
    zip \
    exif \
    pcntl \
    bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# INSTALAR COMPOSER GLOBALMENTE EN LA IMAGEN
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar los archivos de la aplicación ANTES de composer install
COPY . .

# Eliminar la carpeta vendor si existe
RUN rm -rf vendor

# Comandos de construcción (Instalación de Composer)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Crear carpetas para logs y supervisor y establecer permisos
RUN mkdir -p /var/log/nginx \
             /var/log/supervisor \
             /run/nginx \
             /var/www/html/storage/logs \
             /etc/php8/php-fpm.d \
    && chown -R www-data:www-data /var/log/nginx \
    && chmod -R 755 /var/log/nginx

# Crear una configuración mínima para PHP-FPM para asegurar que escucha en el puerto 9000
RUN echo "[global]\nerror_log = /proc/self/fd/2\n[www]\nlisten = 127.0.0.1:9000\nuser = www-data\ngroup = www-data\npm = dynamic\npm.max_children = 5\npm.start_servers = 2\npm.min_spare_servers = 1\npm.max_spare_servers = 3\nclear_env = no\ncatch_workers_output = yes" > /etc/php8/php-fpm.d/zz-docker.conf

# Configurar Supervisor (copiar el archivo de configuración)
COPY .docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configurar Nginx para Laravel
COPY .docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Configurar PHP FPM (temporalmente comentado para depuración de FPM)
# COPY .docker/php/www.conf /etc/php8/php-fpm.d/www.conf
COPY .docker/php/php.ini /etc/php8/conf.d/custom.ini

# Permisos para la carpeta storage de Laravel y cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} + \
    && find /var/www/html -type f -exec chmod 644 {} +


    # Verificar la configuración de PHP-FPM y PHP para depuración
RUN /usr/local/sbin/php-fpm -t # Prueba la configuración de FPM
RUN php -i | grep "error_log" # Verifica que error_log esté configurado correctamente
RUN php -i | grep "display_errors" # Verifica que display_errors esté On
RUN php -i | grep "display_startup_errors" # Verifica que display_startup_errors esté On
RUN php -i | grep "error_reporting" # Verifica que error_reporting esté configurado correctamente

# Exponer el puerto que Nginx está escuchando
EXPOSE 10000



# Script de inicio
CMD sh -c "php artisan migrate --force && \
           php artisan config:cache && \
           php artisan route:cache && \
           php artisan view:cache && \
           php artisan event:cache && \
           php artisan optimize:clear && \
           /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"

# Salud
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:10000/ || exit 1
