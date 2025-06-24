<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProfileController; // Importa el controlador de perfil de Breeze

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

// La ruta raíz '/' ahora requiere autenticación y verifica el email.
// Redirige al login si no estás autenticado, o a la vista 'notes' si sí lo estás.
// ¡CAMBIO AQUÍ! Se elimina el nombre de la ruta, ya que entra en conflicto con 'notes.index' de la API.
Route::get('/', function () {
    return view('notes'); // Esta es tu vista de notas (resources/views/notes.blade.php)
})->middleware(['auth', 'verified']); // Ya NO tiene ->name('notes.index')

// Las rutas de autenticación de Laravel Breeze son importadas automáticamente desde auth.php
require __DIR__.'/auth.php';

// Opcional: Rutas para la gestión del perfil del usuario (vienen con Laravel Breeze).
// Solo accesibles si el usuario está autenticado.
Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});
