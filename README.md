# Aplicación de Notas Laravel y Vue.js

¡Bienvenido al repositorio de la Aplicación de Notas! Este es un sistema de gestión de notas construido con Laravel (para el backend API y lógica de negocio) y Vue.js (para la interfaz de usuario interactiva del frontend).

## 📝 Descripción del Proyecto

Esta aplicación permite a los usuarios:
* Crear nuevas notas.
* Ver una lista de sus notas.
* Editar notas existentes.
* Eliminar notas.
* autenticación de usuarios.


Está diseñada para ser una plataforma simple y eficiente para organizar tus pensamientos y tareas diarias.

## 🚀 Tecnologías Utilizadas

El proyecto utiliza una pila tecnológica robusta y moderna:

**Backend (Laravel):**
* **PHP 8.2+**: Lenguaje de programación.
* **Laravel Framework 10.x**: Framework PHP para la API RESTful.
* **Base de Datos (Local)**: MySQL
* **Base de Datos (Producción/Render)**: PostgreSQL
* **Laravel Breeze**: Andamiaje de autenticación y gestión de usuarios.

**Frontend (Vue.js con Vite):**
* **Vue.js 3**: Framework JavaScript progresivo para la interfaz de usuario.
* **Vite**: Herramienta de compilación rápida para el frontend.
* **Tailwind CSS**: Framework CSS para un diseño rápido y responsivo.
* **Inertia.js**: Adaptador entre Laravel (backend) y Vue.js (frontend) para construir SPAs con la simplicidad de aplicaciones monolíticas.

**Despliegue y Contenedorización:**
* **Docker**: Para la contenerización de la aplicación (PHP-FPM, Nginx, Supervisor).
* **Render**: Plataforma en la nube para el despliegue continuo.

## ⚙️ Requisitos del Sistema (Desarrollo Local)

Para ejecutar esta aplicación localmente, necesitarás tener instalado:

* **Docker Desktop** (incluye Docker Engine y Docker Compose)
* **Git**
* **Un servidor de base de datos MySQL** (ej. a través de XAMPP, Laragon, o un contenedor Docker de MySQL)
* **Un navegador web moderno**

## 💻 Instalación y Ejecución Local

Sigue estos pasos para configurar y ejecutar el proyecto en tu máquina local:

1.  **Clonar el Repositorio:**
    ```bash
    git clone [https://github.com/jeajguz/app-notas-backend.git](https://github.com/jeajguz/app-notas-backend.git)
    cd app-notas-backend
    ```

2.  **Configuración del Entorno (`.env`):**
    * Crea un archivo `.env` en la raíz del proyecto. Puedes copiar el ejemplo:
        ```bash
        cp .env.example .env
        ```
    * Abre el archivo `.env` y configura las variables de entorno necesarias para **desarrollo local (MySQL)**. Asegúrate de que las líneas de PostgreSQL estén comentadas o eliminadas para tu entorno local.
        ```dotenv
        APP_NAME=Laravel
        APP_ENV=local
        APP_KEY= # Se generará en el siguiente paso
        APP_DEBUG=true # Recomendado para desarrollo local
        APP_URL=http://localhost:10000 # O el puerto que uses localmente

        DB_CONNECTION=mysql
        DB_HOST=127.0.0.1
        DB_PORT=3310 # Asegúrate de que tu MySQL escuche en este puerto
        DB_DATABASE=api_notas_local # <-- ¡Verifica este nombre en tu servidor MySQL!
        DB_USERNAME=root
        DB_PASSWORD=1234 # <-- ¡Asegúrate de que esta sea la contraseña correcta de tu MySQL!
        ```
    * **Asegúrate de que tu servidor MySQL local esté corriendo** y que la base de datos `api_notas_local` exista (o cámbiala a una existente) y que las credenciales sean correctas.

3.  **Generar la Clave de Aplicación (Laravel):**
    * Si aún no tienes la `APP_KEY` en tu `.env`, ejecuta este comando Docker para generarla:
        ```bash
        docker run --rm -v "$(pwd):/app" php:8.2-fpm-bookworm php /app/artisan key:generate
        ```
        *Esto generará la `APP_KEY` en tu archivo `.env`.*

4.  **Construir y Levantar los Contenedores Docker:**
    * Asegúrate de que tu `Dockerfile` esté configurado correctamente con los pasos para Composer y Vite.
    * Si usas Docker Compose para tu base de datos MySQL local (en lugar de XAMPP/localhost), ajusta `DB_HOST` en `.env` al nombre del servicio de MySQL en tu `docker-compose.yml`.
    * Construye las imágenes Docker y levanta los servicios:
        ```bash
        docker compose up --build -d
        # O si usas docker-compose (versiones antiguas)
        # docker-compose up --build -d
        ```

5.  **Ejecutar Migraciones de Base de Datos:**
    ```bash
    docker exec <nombre_del_contenedor_php> php artisan migrate
    # Para encontrar el nombre del contenedor: docker ps
    # Ejemplo: docker exec app-notas-backend-app-1 php artisan migrate
    ```
    *Si tienes seeders, puedes ejecutarlos con `php artisan db:seed`.*

6.  **Acceder a la Aplicación:**
    * La aplicación debería estar accesible en tu navegador en `http://localhost:10000` (o el puerto que hayas configurado en tu `default.conf` de Nginx y que hayas expuesto en tu `Dockerfile`).

## ☁️ Despliegue en Render

Esta aplicación está diseñada para ser desplegada continuamente en Render.com.

**Configuración en Render:**
* **Tipo de Servicio**: Web Service (Docker).
* **Repositorio**: Conecta tu repositorio de GitHub `https://github.com/jeajguz/app-notas-backend.git`.
* **Branch**: `main` (o tu rama principal).
* **Docker Context Directory**: `.` (el punto, si tu Dockerfile está en la raíz).
* **Docker Command**: Vacío (para que use el `CMD` de tu Dockerfile).
* **Puerto**: `10000` (Debe coincidir con el `EXPOSE` de tu Dockerfile y el `listen` de Nginx).
* **Variables de Entorno**: Configura todas las variables de tu `.env` de producción en la sección "Environment" de Render. Para la base de datos de Render (PostgreSQL), usa:
    * `APP_URL`: La URL pública de tu servicio en Render (ej. `https://app-notas-backend-g3kr.onrender.com`).
    * `APP_KEY`: Déjala en blanco para que Render la genere automáticamente o usa una que hayas generado y quieras fijar.
    * `APP_ENV=production`
    * `APP_DEBUG=false`
    * **`DATABASE_URL="postgresql://notas_app_db_user:Rr7kHI23HCNREM5h8DRoubZePBUmwjFZ@dpg-d1as2gp5pdvs73d862pg-a/notas_app_db"`**
        * (Asegúrate de descomentar o incluir esta línea y de que el `DB_CONNECTION` adecuado sea `pgsql` en tu `.env` para producción, si lo envías con esa configuración).
    * `DB_CONNECTION=pgsql` (Si no usas `DATABASE_URL` y configuras las credenciales por separado).

## 🤝 Contribución

Si deseas contribuir a este proyecto, por favor sigue estos pasos:
1.  Haz un "fork" del repositorio.
2.  Crea una nueva rama (`git checkout -b feature/nueva-funcionalidad`).
3.  Realiza tus cambios y commitea (`git commit -am 'Añadir nueva funcionalidad'`).
4.  Sube tu rama (`git push origin feature/nueva-funcionalidad`).
5.  Crea un "Pull Request".

## 📄 Licencia

Este proyecto está bajo la licencia [MIT](https://opensource.org/licenses/MIT).

---
