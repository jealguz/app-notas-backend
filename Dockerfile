# Usa una imagen base oficial de PHP con Nginx (basada en Debian Bookworm)
FROM php:8.2-fpm-bookworm
# CAMBIO AQUÍ: Usamos la etiqueta 'bookworm'

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

# Comandos de construcción (Instalación de Composer)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Crear carpetas para logs y supervisor y establecer permisos
RUN mkdir -p /var/log/nginx \
    /var/log/supervisor \
    /run/nginx \
    /var/www/html/storage/logs \
    /etc/php/8.2/fpm/pool.d \
    && chown -R www-data:www-data /var/log/nginx \
    && chmod -R 755 /var/log/nginx

# Crear una configuración mínima para PHP-FPM para asegurar que escucha en el puerto 9000
# Nota: La ruta de los pools de FPM cambia en Debian
RUN echo "[global]\nerror_log = /proc/self/fd/2\n[www]\nlisten = 127.0.0.1:9000\nuser = www-data\ngroup = www-data\npm = dynamic\npm.max_children = 5\npm.start_servers = 2\npm.min_spare_servers = 1\npm.max_spare_servers = 3\nclear_env = no" > /etc/php/8.2/fpm/pool.d/www.conf
