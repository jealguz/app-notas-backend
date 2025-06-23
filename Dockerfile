# Usa una imagen base oficial de PHP con Nginx (basada en Debian Bookworm)
FROM php:8.2-fpm-bookworm

# Establecer el directorio de trabajo desde el principio
WORKDIR /var/www/html

# Añadir /usr/local/sbin al PATH para que el sistema encuentre ejecutables como php-fpm si están allí
ENV PATH="/usr/local/sbin:${PATH}"

# Instalar dependencias del sistema operativo y extensiones PHP necesarias para Laravel (usando apt-get)
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    build-essential \
    autoconf \
    libzip-dev \
    libsqlite3-dev \
    libonig-dev \
    libpq-dev \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP usando docker-php-ext-install
# Mantenemos esto comentado por ahora, para aislar el problema.
# RUN docker-php-ext-install pdo_mysql \
#     pdo_pgsql \
#     zip \
#     exif \
#     pcntl \
#     bcmath \
#     && docker-php-ext-configure gd --with-freetype --with-jpeg \
#     && docker-php-ext-install -j$(nproc) gd

# INSTALAR COMPOSER GLOBALMENTE EN LA IMAGEN
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar los archivos de la aplicación ANTES de composer install
COPY . .

# Eliminar la carpeta vendor si existe
RUN rm -rf vendor

# --- INICIO DE SECCIÓN TEMPORAL PARA DEPURACIÓN ---
# ¡¡IMPORTANTE!! ESTO DEBE SER REVERTIDO EN PRODUCCIÓN
# Crea un .env con APP_DEBUG=true y LOG_CHANNEL=stderr
RUN echo "APP_NAME=Laravel\nAPP_ENV=local\nAPP_DEBUG=true\nLOG_CHANNEL=stderr" > .env && \
    chmod 664 .env # Asegurar permisos de lectura para el usuario www-data
# Eliminado temporalmente 'php artisan key:generate' para depurar
# Esto causará una advertencia de Laravel sobre la APP_KEY, pero permitirá que APP_DEBUG funcione.
# --- FIN DE SECCIÓN TEMPORAL PARA DEPURACIÓN ---

# Comandos de construcción (Instalación de Composer)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Crear carpetas para logs y supervisor y establecer permisos
RUN mkdir -p /var/log/nginx \
    /var/log/supervisor \
    /run/nginx \
    /var/www/html/storage/logs \
    /etc/php/8.2/fpm/pool.d \
    /var/lib/nginx/body \
    && chown -R www-data:www-data /var/log/nginx \
    && chmod -R 755 /var/log/nginx \
    && chown -R www-data:www-data /var/lib/nginx \
    && chmod -R 755 /var/lib/nginx

# Crear una configuración mínima para PHP-FPM para asegurar que escucha en el puerto 9000
# Nota: La ruta de los pools de FPM cambia en Debian
# Eliminado 'error_log' para evitar error de permisos y confiando en el log a stderr por defecto
RUN echo "[global]\n[www]\nlisten = 127.0.0.1:9000\nuser = www-data\ngroup = www-data\npm = dynamic\npm.max_children = 5\npm.start_servers = 2\npm.min_spare_servers = 1\npm.max_spare_servers = 3\nclear_env = no\ncatch_workers_output = yes" > /etc/php/8.2/fpm/pool.d/zz-docker.conf

# Configurar Supervisor (copiar el archivo de configuración)
COPY .docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configurar Nginx para Laravel
COPY .docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Configurar PHP FPM (mantenemos esto comentado por ahora)
# COPY .docker/php/www.conf /etc/php/8.2/fpm/pool.d/www.conf
# COPY .docker/php/php.ini /etc/php/8.2/fpm/conf.d/custom.ini

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

# Script de inicio (volver a Supervisor)
CMD sh -c "/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"

# Comenta la línea temporal de depuración de Nginx
# CMD ["nginx", "-g", "daemon off;"]

# Comenta temporalmente las líneas de artisan migrate y cache:
# CMD sh -c "php artisan migrate --force && \
#     php artisan config:cache && \
#     php artisan route:cache && \
#     php artisan view:cache && \
#     php artisan event:cache && \
#     php artisan optimize:clear && \
#     /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"

# Salud
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:10000/ || exit 1
