# API RESTful de Notas con Laravel

![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Composer](https://img.shields.io/badge/Composer-885630?style=for-the-badge&logo=composer&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

Este repositorio contiene la API RESTful (Backend) para una aplicación de gestión de notas, desarrollada con el framework Laravel. Esta API permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre las notas.

---

## 🚀 Funcionalidades

* **Listar Notas:** Obtiene todas las notas existentes.
* **Crear Nota:** Permite añadir una nueva nota a la base de datos.
* **Ver Nota Específica:** Recupera los detalles de una nota mediante su ID.
* **Actualizar Nota:** Modifica una nota existente (título, contenido, estado de completado).
* **Eliminar Nota:** Borra una nota de la base de datos.

---

## 🛠️ Tecnologías Utilizadas

* **Backend:**
    * [**Laravel**](https://laravel.com/): Framework PHP para el desarrollo de aplicaciones web.
    * **PHP:** Lenguaje de programación.
    * **Composer:** Administrador de dependencias de PHP.
* **Base de Datos:**
    * **MySQL:** Sistema de gestión de bases de datos relacionales.
* **Control de Versiones:**
    * **Git:** Sistema de control de versiones distribuido.
    * **GitHub:** Plataforma para alojamiento de repositorios Git.

---

## ⚙️ Configuración y Ejecución Local

Sigue estos pasos para poner en marcha la API en tu entorno local.

### Prerrequisitos

Asegúrate de tener instalado lo siguiente:

* **PHP** (versión 8.1 o superior, preferiblemente la que se ajuste a tu versión de Laravel).
* **Composer**
* **Node.js y npm** (aunque no es estrictamente necesario para la API, es útil para el desarrollo Laravel en general).
* **MySQL** (o cualquier otro sistema de base de datos compatible).
* **Git**

### Pasos de Instalación

1.  **Clonar el Repositorio:**
    ```bash
    git clone [https://github.com/](https://github.com/)[TU_USUARIO_GITHUB]/api-notas-backend.git
    cd api-notas-backend
    ```

2.  **Instalar Dependencias de Composer:**
    ```bash
    composer install
    ```

3.  **Configurar el Archivo `.env`:**
    * Copia el archivo de ejemplo `.env.example` a `.env`:
        ```bash
        cp .env.example .env
        ```
    * Abre el archivo `.env` y configura tus credenciales de base de datos:
        ```dotenv
        DB_CONNECTION=mysql
        DB_HOST=127.0.0.1
        DB_PORT=3306
        DB_DATABASE=laravelapi_notas_db  # Asegúrate de que este sea el nombre de tu BD
        DB_USERNAME=root                 # Tu usuario de MySQL
        DB_PASSWORD=                     # Tu contraseña de MySQL (vacía si no tienes)
        ```
    * También puedes ajustar `APP_DEBUG=true` para ver errores detallados durante el desarrollo.

4.  **Generar la Clave de la Aplicación:**
    ```bash
    php artisan key:generate
    ```

5.  **Configurar la Base de Datos y Ejecutar Migraciones:**
    * Asegúrate de que tu servidor MySQL esté en funcionamiento.
    * Crea una base de datos llamada `laravelapi_notas_db` (o el nombre que configuraste en `.env`) en tu sistema de gestión de bases de datos (ej. phpMyAdmin).
    * Ejecuta las migraciones para crear las tablas necesarias:
        ```bash
        php artisan migrate
        ```

6.  **Iniciar el Servidor de Desarrollo:**
    ```bash
    php artisan serve
    ```
    La API estará disponible en `http://127.0.0.1:8000`.

---

## 💡 Uso de la API (Endpoints)

Puedes usar herramientas como [Postman](https://www.postman.com/downloads/) o [Insomnia](https://insomnia.rest/download) para probar los endpoints.

La URL base para todos los endpoints es `http://127.0.0.1:8000/api`.

| Método HTTP | Endpoint       | Descripción                | Cuerpo de la Petición (JSON) Ejemplo | Respuesta (JSON) Ejemplo             |
| :---------- | :------------- | :------------------------- | :---------------------------------- | :----------------------------------- |
| `GET`       | `/notes`       | Obtener todas las notas    | `N/A`                               | `[{"id": 1, "title": "...", ...}]` |
| `POST`      | `/notes`       | Crear una nueva nota       | `{ "title": "Comprar pan", "content": "...", "completed": false }` | `{"id": 2, "title": "...", ...}`    |
| `GET`       | `/notes/{id}`  | Obtener una nota por ID    | `N/A`                               | `{"id": 1, "title": "...", ...}`    |
| `PUT/PATCH` | `/notes/{id}`  | Actualizar una nota        | `{ "content": "...", "completed": true }` | `{"id": 1, "title": "...", ...}`    |
| `DELETE`    | `/notes/{id}`  | Eliminar una nota          | `N/A`                               | (No Content - 204)                   |

---

## 🤝 Contribución

Las contribuciones son bienvenidas. Si encuentras algún error o tienes sugerencias, por favor abre un 'issue' o envía un 'pull request'.

---

## 👤 Autor

**Jeison Guzmán Londoño**
* LinkedIn: [https://www.linkedin.com/in/jeison-guzman-ba8491315/](https://www.linkedin.com/in/jeison-guzman-ba8491315/)
* GitHub: [https://github.com/jealguz(https://github.com/jealguz)

---

## 📜 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.# app-notas-backend
