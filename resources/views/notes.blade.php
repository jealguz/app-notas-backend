<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Notas - Currículum</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .note-card {
            background-color: #ffffff;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 1rem;
            padding: 1.5rem;
            position: relative;
        }
        .note-card.completed {
            background-color: #e9ecef;
            text-decoration: line-through;
            color: #6c757d;
        }
        .note-card .actions {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .note-card .actions button {
            margin-left: 5px;
        }
        #notes-container {
            max-height: 60vh; /* Altura máxima para el scroll */
            overflow-y: auto; /* Habilita el scroll vertical */
            padding-right: 15px; /* Espacio para la barra de scroll */
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4 text-center">Mis Notas para el Currículum</h1>

        <div class="d-flex justify-content-end mb-3">
            <form method="POST" action="{{ route('logout') }}">
                @csrf
                <button type="submit" class="btn btn-warning btn-sm">Cerrar Sesión</button>
            </form>
        </div>
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title" id="form-title">Crear Nueva Nota</h5>
                <form id="note-form">
                    <input type="hidden" id="note-id">
                    <div class="mb-3">
                        <label for="title" class="form-label">Título</label>
                        <input type="text" class="form-control" id="title" required maxlength="255">
                    </div>
                    <div class="mb-3">
                        <label for="content" class="form-label">Contenido</label>
                        <textarea class="form-control" id="content" rows="3"></textarea>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="completed">
                        <label class="form-check-label" for="completed">
                            Completada
                        </label>
                    </div>
                    <button type="submit" class="btn btn-primary" id="submit-button">Guardar Nota</button>
                    <button type="button" class="btn btn-secondary d-none" id="cancel-edit-button">Cancelar Edición</button>
                </form>
            </div>
        </div>

        <h2 class="mb-3 text-center">Notas Existentes</h2>
        <div id="notes-container" class="row row-cols-1 row-cols-md-2 g-4">
            <p id="loading-notes" class="text-center">Cargando notas...</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const API_URL = '/api/notes'; // Ruta base de tu API de notas en Render
        const notesContainer = document.getElementById('notes-container');
        const noteForm = document.getElementById('note-form');
        const noteIdInput = document.getElementById('note-id');
        const titleInput = document.getElementById('title');
        const contentInput = document.getElementById('content');
        const completedInput = document.getElementById('completed');
        const submitButton = document.getElementById('submit-button');
        const formTitle = document.getElementById('form-title');
        const cancelEditButton = document.getElementById('cancel-edit-button');
        const loadingNotes = document.getElementById('loading-notes');

        // Función para obtener el token CSRF
        function getCsrfToken() {
            return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        }

       <!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Notas - Currículum</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .note-card {
            background-color: #ffffff;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 1rem;
            padding: 1.5rem;
            position: relative;
        }
        .note-card.completed {
            background-color: #e9ecef;
            text-decoration: line-through;
            color: #6c757d;
        }
        .note-card .actions {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .note-card .actions button {
            margin-left: 5px;
        }
        #notes-container {
            max-height: 60vh; /* Altura máxima para el scroll */
            overflow-y: auto; /* Habilita el scroll vertical */
            padding-right: 15px; /* Espacio para la barra de scroll */
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4 text-center">Mis Notas para el Currículum</h1>

        <div class="d-flex justify-content-end mb-3">
            <form method="POST" action="{{ route('logout') }}">
                @csrf
                <button type="submit" class="btn btn-warning btn-sm">Cerrar Sesión</button>
            </form>
        </div>
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title" id="form-title">Crear Nueva Nota</h5>
                <form id="note-form">
                    <input type="hidden" id="note-id">
                    <div class="mb-3">
                        <label for="title" class="form-label">Título</label>
                        <input type="text" class="form-control" id="title" required maxlength="255">
                    </div>
                    <div class="mb-3">
                        <label for="content" class="form-label">Contenido</label>
                        <textarea class="form-control" id="content" rows="3"></textarea>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="completed">
                        <label class="form-check-label" for="completed">
                            Completada
                        </label>
                    </div>
                    <button type="submit" class="btn btn-primary" id="submit-button">Guardar Nota</button>
                    <button type="button" class="btn btn-secondary d-none" id="cancel-edit-button">Cancelar Edición</button>
                </form>
            </div>
        </div>

        <h2 class="mb-3 text-center">Notas Existentes</h2>
        <div id="notes-container" class="row row-cols-1 row-cols-md-2 g-4">
            <p id="loading-notes" class="text-center">Cargando notas...</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const API_URL = '/api/notes'; // Ruta base de tu API de notas en Render
        const notesContainer = document.getElementById('notes-container');
        const noteForm = document.getElementById('note-form');
        const noteIdInput = document.getElementById('note-id');
        const titleInput = document.getElementById('title');
        const contentInput = document.getElementById('content');
        const completedInput = document.getElementById('completed');
        const submitButton = document.getElementById('submit-button');
        const formTitle = document.getElementById('form-title');
        const cancelEditButton = document.getElementById('cancel-edit-button');
        const loadingNotes = document.getElementById('loading-notes');

        // Función para obtener el token CSRF
        function getCsrfToken() {
            return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        }

        // Función para cargar las notas
        async function fetchNotes() {
            console.log('fetchNotes() function started'); // LOG 1
            loadingNotes.style.display = 'block'; // Mostrar mensaje de carga
            notesContainer.innerHTML = ''; // Limpiar contenedor
            try {
                console.log('Attempting to fetch from:', API_URL); // LOG 2
                const response = await fetch(API_URL, {
                    credentials: 'include' // Incluir cookies con la petición
                });
                console.log('Fetch response received:', response); // LOG 3
                if (!response.ok) {
                    // Si la respuesta no es OK
        // Función para enviar el formulario (crear o actualizar)
        noteForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const id = noteIdInput.value;
            const method = id ? 'PUT' : 'POST';
            const url = id ? `${API_URL}/${id}` : API_URL;

            const noteData = {
                title: titleInput.value,
                content: contentInput.value,
                completed: completedInput.checked
            };

            try {
                const response = await fetch(url, {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'X-CSRF-TOKEN': getCsrfToken()
                    },
                    body: JSON.stringify(noteData),
                    credentials: 'include' // <--- CAMBIO AÑADIDO: Incluir cookies con la petición
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    console.error('Error de API:', errorData);
                    alert(`Error al guardar la nota: ${errorData.message || response.statusText}`);
                    return;
                }

                await fetchNotes(); // Volver a cargar las notas
                resetForm(); // Limpiar formulario
            } catch (error) {
                console.error('Error al enviar la nota:', error);
                alert('Error de red o servidor al guardar la nota.');
            }
        });

        // Función para editar una nota
        async function editNote(id) {
            try {
                const response = await fetch(`${API_URL}/${
