<<<<<<< HEAD
<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

You may also try the [Laravel Bootcamp](https://bootcamp.laravel.com), where you will be guided through building a modern Laravel application from scratch.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the [Laravel Partners program](https://partners.laravel.com).

### Premium Partners

- **[Vehikl](https://vehikl.com)**
- **[Tighten Co.](https://tighten.co)**
- **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
- **[64 Robots](https://64robots.com)**
- **[Curotec](https://www.curotec.com/services/technologies/laravel)**
- **[DevSquad](https://devsquad.com/hire-laravel-developers)**
- **[Redberry](https://redberry.international/laravel-development)**
- **[Active Logic](https://activelogic.com)**

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
=======
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
* GitHub: [https://github.com/jealguz](https://github.com/jealguz)

---

## 📜 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
>>>>>>> 3c7e2b6d94209857744db301d459ba01ce8b03cc
