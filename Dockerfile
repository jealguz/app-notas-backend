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
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/nginx/nginx.conf # Elimina el nginx.conf por defecto para usar el nuestro

# Instalar extensiones PHP usando docker-php-ext-install
# Mantendremos esto comentado por ahora, para no añadir complejidad extra si no es la causa del problema.
# ¡AHORA SÍ LAS DESCOMENTAMOS Y LAS INSTALAMOS!
RUN docker-php-ext-install pdo_pgsql \
    zip \
    exif \
    pcntl \
    bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# INSTALAR COMPOSER GLOBALMENTE EN LA IMAGEN
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar los archivos de la aplicación
# Esto debe hacerse ANTES de cualquier comando de composer o artisan que necesite los archivos del proyecto.
COPY . .

# Eliminar la carpeta vendor si existe ANTES de la instalación de Composer.
# Esto asegura una instalación limpia de las dependencias.
RUN rm -rf vendor

# --- REMOVIDA SECCIÓN TEMPORAL PARA DEPURACIÓN DE .ENV ---
# La línea "RUN echo 'APP_NAME=Laravel...' > .env" ha sido eliminada.
# Render maneja las variables de entorno de forma segura, y la APP_KEY se generará.
# --- FIN DE SECCIÓN REMOVIDA ---

# Comandos de construcción de Laravel (Instalación de Composer y optimizaciones)
# Estos comandos son cruciales para que Laravel funcione correctamente.
RUN composer install --no-dev --optimize-autoloader --no-scripts
# RUN php artisan key:generate --force # Genera la APP_KEY, ¡esencial para Laravel!
RUN php artisan config:cache          # Optimiza la configuración de Laravel
RUN php artisan route:cache           # Optimiza las rutas de Laravel
RUN php artisan view:cache            # Optimiza las vistas de Laravel
RUN php artisan event:cache           # Opcional: Optimiza los eventos de Laravel

# Crear carpetas necesarias para logs y procesos, y establecer permisos
RUN mkdir -p /var/log/nginx \
    /var/log/supervisor \
    /run/nginx \
    /var/www/html/storage/logs \
    /etc/php/8.2/fpm/pool.d \
    /var/lib/nginx/body \
    /var/run/nginx \ # Nueva carpeta para el PID de Nginx \
    && chown -R www-data:www-data /var/log/nginx \
    && chmod -R 755 /var/log/nginx \
    && chown -R www-data:www-data /var/lib/nginx \
    && chmod -R 755 /var/lib/nginx \
    && chown -R www-data:www-data /var/run/nginx \
    && chmod -R 755 /var/run/nginx

# Crear una configuración mínima para PHP-FPM, redirigiendo el error_log a un archivo específico
RUN echo "[global]\nerror_log = /var/log/supervisor/php-fpm_error.log\nlog_limit = 8192\n[www]\nlisten = 127.0.0.1:9000\nuser = www-data\ngroup = www-data\npm = dynamic\npm.max_children = 5\npm.start_servers = 2\npm.min_spare_servers = 1\npm.max_spare_servers = 3\nclear_env = no\ncatch_workers_output = yes" > /etc/php/8.2/fpm/pool.d/zz-docker.conf

# Configurar Supervisor (copiar el archivo de configuración)
COPY .docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configurar Nginx para Laravel
COPY .docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY .docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Configurar PHP FPM (mantenemos esto comentado por ahora)
# COPY .docker/php/www.conf /etc/php/8.2/fpm/pool.d/www.conf
# COPY .docker/php/php.ini /etc/php/8.2/fpm/conf.d/custom.ini

# Permisos para la carpeta storage de Laravel y cache
# Es importante que esto se ejecute DESPUÉS de que los comandos 'php artisan' hayan creado los archivos de caché.
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} + \
    && find /var/www/html -type f -exec chmod 644 {} +

# Verificar la configuración de PHP-FPM y PHP para depuración (opcional, puedes removerlas una vez funcione)
RUN /usr/local/sbin/php-fpm -t # Prueba la configuración de FPM
RUN php -i | grep "error_log" # Verifica que error_log esté configurado correctamente
RUN php -i | grep "display_errors" # Verifica que display_errors esté On
RUN php -i | grep "display_startup_errors" # Verifica que display_startup_errors esté On
RUN php -i | grep "error_reporting" # Verifica que error_reporting esté configurado correctamente

# Exponer el puerto que Nginx está escuchando
EXPOSE 10000

# Script de inicio final (ejecuta migraciones y luego Supervisor)
# Hemos "descomentado" esta línea y eliminado las líneas temporales.
CMD sh -c "php artisan migrate --force && \
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"

# Salud
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:10000/ || exit 1
