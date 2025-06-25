<?php

use Illuminate\Support\Facades\Route;
// use App\Http\Controllers\ProfileController; // Ya no es necesario si eliminamos las rutas de perfil

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

// La ruta raíz '/' ahora es completamente pública y devuelve la vista de notas.
// Se ha eliminado cualquier middleware de autenticación.
Route::get('/', function () {
    return view('notes'); // Esta es tu vista de notas (resources/views/notes.blade.php)
});

// ELIMINADO: La inclusión de las rutas de autenticación de Laravel Breeze (auth.php).
// require __DIR__.'/auth.php';

// ELIMINADO: El bloque de rutas para la gestión del perfil del usuario,
// ya que requiere autenticación.
// Route::middleware('auth')->group(function () {
//     Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
//     Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
//     Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
// });
