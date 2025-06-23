<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    // return view('welcome'); // Comenta o elimina esta línea
    return view('notes'); // Añade esta línea para cargar tu vista 'notes.blade.php'
});

// Asegúrate de que tus rutas de API estén en routes/api.php y no aquí,
// o si las tienes aquí, asegúrate de que no choquen con rutas de vista.
// Ejemplo de una ruta de API si la tenías aquí y la necesitas para el frontend
// Route::get('/api/notes', [App\Http\Controllers\NoteController::class, 'index']);
