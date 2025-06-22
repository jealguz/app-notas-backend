# Usa una imagen base oficial de PHP con Nginx (ej. de Laravel Sail o FPM)
# php:8.2-fpm-alpine es una buena elección para Alpine Linux
FROM php:8.2-fpm-alpine

# Establecer el directorio de trabajo desde el principio
WORKDIR /var/www/html

# Instalar dependencias del sistema operativo y extensiones PHP necesarias para Laravel
# Alpine es una distribución ligera, por eso usamos 'apk'
# Instalar build-base, autoconf, git, zip, unzip, supervisor, nginx
# Y luego las dependencias para las extensiones PHP
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
    # Limpia el cache de apk inmediatamente después de la instalación
    && rm -rf /var/cache/apk/*

# Instalar extensiones PHP usando docker-php-ext-install
# Siempre después de instalar sus dependencias de sistema (ej. libzip-dev para zip)
RUN docker-php-ext-install pdo_mysql \
    pdo_pgsql \
    zip \
    exif \
    pcntl \
    bcmath \
    # Configurar y luego instalar GD con sus flags
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# INSTALAR COMPOSER GLOBALMENTE EN LA IMAGEN - ¡AHORA SÍ EN EL LUGAR CORRECTO!
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar los archivos de la aplicación ANTES de composer install
# Esto asegura que Composer tenga acceso a composer.json
COPY . .

# Eliminar la carpeta vendor si existe (Composer la reinstalará si es necesario)
RUN rm -rf vendor

# Comandos de construcción (Instalación de Composer)
# Ahora sí, Composer debería estar disponible
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Crear carpetas para logs y supervisor (Si no existen ya)
# Asegúrate de que Supervisor y Nginx puedan escribir en ellas.
RUN mkdir -p /var/log/nginx \
             /var/log/supervisor \
             /run/nginx \
             /var/www/html/storage/logs

# Configurar Supervisor (copiar el archivo de configuración)
COPY .docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configurar Nginx para Laravel
COPY .docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Configurar PHP FPM (si tienes estos archivos)
COPY .docker/php/www.conf /etc/php8/php-fpm.d/www.conf
COPY .docker/php/php.ini /etc/php8/conf.d/custom.ini

# Permisos para la carpeta storage de Laravel y cache
# Es crucial que www-data (el usuario que ejecuta PHP-FPM y Nginx) pueda escribir aquí
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    # Añadido: asegurar que www-data tiene acceso de lectura/ejecución a toda la app
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} + \
    && find /var/www/html -type f -exec chmod 644 {} +

# Exponer el puerto que Nginx está escuchando (8000 en tu default.conf)
EXPOSE 8000

# Script de inicio (CMD)
# Ejecutar migraciones primero (siempre antes de la aplicación),
# luego comandos de caché de Laravel, y finalmente iniciar los servicios con supervisord.
CMD sh -c "php artisan migrate --force && \
           php artisan config:cache && \
           php artisan route:cache && \
           php artisan view:cache && \
           php artisan event:cache && \
           php artisan optimize:clear && \
           /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"

# Salud
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:8000/ || exit 1
# Nota: La URL para el HEALTHCHECK debe coincidir con el puerto que Nginx escucha.
