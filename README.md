# Aplicación de Notas Pública

¡Bienvenido a la Aplicación de Notas! Este es un proyecto simple desarrollado con Laravel y Bootstrap que permite a los usuarios crear, leer, actualizar y eliminar notas de forma pública, sin necesidad de autenticación.

## Características

* **CRUD Completo:** Permite crear, listar, editar y eliminar notas.
* **Interfaz Sencilla:** Desarrollado con Bootstrap para una experiencia de usuario limpia.
* **API RESTful:** Las operaciones de notas se manejan a través de una API RESTful.
* **Sin Autenticación:** Acceso público a todas las funcionalidades de notas.

## Tecnologías Utilizadas

* **Backend:**
    * Laravel (Framework PHP)
    * PHP
    * PostgreSQL (Base de datos utilizada en producción en Render)
* **Frontend:**
    * HTML, CSS (Bootstrap 5)
    * JavaScript (Vanilla JS para interacciones con la API)
* **Despliegue:**
    * Render (Plataforma de despliegue en la nube)
    * Git / GitHub

## Instalación Local

Sigue estos pasos para configurar el proyecto en tu máquina local.

1.  **Clonar el Repositorio:**
    ```bash
    git clone [https://github.com/jealguz/app-notas-backend]
    cd app-notas-backend
    ```


2.  **Instalar Dependencias de PHP:**
    ```bash
    composer install
    ```

3.  **Instalar Dependencias de JavaScript y Compilar Assets:**
    ```bash
    npm install
    npm run build
    ```

4.  **Configurar el Archivo de Entorno (`.env`):**
    Copia el archivo `.env.example` y renómbralo a `.env`:
    ```bash
    cp .env.example .env
    ```
    Abre el archivo `.env` y configura tus credenciales de base de datos local (MySQL, PostgreSQL, SQLite, etc.). Ejemplo para MySQL:
    ```dotenv
    APP_NAME="Notas App"
    APP_ENV=local
    APP_KEY=base64:TuAppKeyGenerada
    APP_DEBUG=true
    APP_URL=http://localhost

    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=nombre_de_tu_db_local
    DB_USERNAME=tu_usuario_db
    DB_PASSWORD=tu_password_db
    ```
    *(Nota: `APP_KEY` se generará en el siguiente paso).*

5.  **Generar la Clave de Aplicación:**
    ```bash
    php artisan key:generate
    ```

6.  **Ejecutar Migraciones de Base de Datos:**
    Esto creará la tabla `notes` en tu base de datos local.
    ```bash
    php artisan migrate
    ```

7.  **Crear Enlace Simbólico para el Almacenamiento (si es necesario):**
    ```bash
    php artisan storage:link
    ```

8.  **Iniciar el Servidor de Desarrollo:**
    ```bash
    php artisan serve
    ```
    La aplicación estará disponible en `http://127.0.0.1:8000`.

## Despliegue en Render

Esta aplicación está diseñada para ser desplegada en Render. A continuación, se detallan los pasos y la configuración específica:

### 1. Requisitos de Render

* Una cuenta en [Render.com](https://render.com).
* Un repositorio GitHub con el código de la aplicación.
* Una base de datos PostgreSQL en Render.

### 2. Configuración del Servicio Web en Render

Al crear un nuevo **Web Service** en Render, utiliza la siguiente configuración:

* **Name:** `tu-nombre-de-app-en-render` (ej. `mis-notas-publicas`)
* **Region:** La más cercana a tu ubicación o a la de tu base de datos.
* **Branch:** `main` (o `master`).
* **Root Directory:** Vacío (si tu proyecto Laravel está en la raíz del repositorio).
* **Runtime:** `PHP`
* **Build Command:**
    ```bash
    composer install && npm run build
    ```
* **Start Command:**
    ```bash
    php artisan migrate --force && php artisan config:clear && php artisan route:clear && php artisan view:clear && php artisan storage:link && php artisan serve --host=0.0.0.0 --port=$PORT
    ```

### 3. Variables de Entorno en Render

Configura las siguientes variables en la sección "Environment" de tu servicio web en Render:

* `APP_KEY`: El valor generado por `php artisan key:generate --show` (sin el `base64:` si tu terminal lo muestra, solo la cadena en sí).
* `APP_URL`: La URL de tu servicio web de Render (ej. `https://mis-notas-publicas.onrender.com`).
* `APP_ENV`: `production`
* `APP_DEBUG`: `false`
* `DB_CONNECTION`: `pgsql`
* `DATABASE_URL`: La URL de conexión de tu base de datos PostgreSQL en Render.

### Uso de la Aplicación

Una vez desplegada, puedes acceder a la aplicación a través de la URL proporcionada por Render. Podrás crear, editar y eliminar notas directamente desde la interfaz.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un "issue" o envía un "pull request" si encuentras algún error o tienes sugerencias.

---
