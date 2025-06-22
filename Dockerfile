# Usa una imagen base que ya tiene Nginx y PHP-FPM configurados
FROM tiangolo/nginx-php-fpm:latest

# Establece el directorio de trabajo predeterminado en /var/www/html
WORKDIR /var/www/html

# Copia los archivos de tu aplicación al directorio de trabajo
COPY . /var/www/html

# Elimina la carpeta vendor si existe (Composer la reinstalará)
RUN rm -rf vendor

# Instala las dependencias de Composer (Composer ya viene instalado en esta imagen)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Opcional: Instala extensiones PHP adicionales si las necesitas y no están en la imagen base
# Consulta la documentación de tiangolo/nginx-php-fpm para ver qué extensiones incluye.
# Ejemplo (descomenta y ajusta si necesario):
# RUN docker-php-ext-install pdo_pgsql bcmath pcntl

# Configura los permisos para el directorio de almacenamiento y la caché de Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} + \
    && find /var/www/html -type f -exec chmod 644 {} +

# Las imágenes de tiangolo/nginx-php-fpm exponen el puerto 80 por defecto
EXPOSE 80

# Comandos de inicio:
# Ejecuta migraciones, limpia cachés de Laravel, y luego la aplicación se ejecutará automáticamente
# ya que la imagen base de tiangolo/nginx-php-fpm tiene su propio CMD/ENTRYPOINT.
# Si Render necesita un CMD explícito, este es el que usarías para Laravel:
CMD sh -c "php artisan migrate --force && \
           php artisan config:cache && \
           php artisan route:cache && \
           php artisan view:cache && \
           php artisan event:cache && \
           php artisan optimize:clear"
# No necesitas iniciar supervisord o nginx/php-fpm aquí, la imagen base se encarga.
