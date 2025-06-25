<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\NoteController; // Asegúrate de importar tu controlador de API

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Opcional: Ruta para obtener la información del usuario autenticado vía API.
// MANTENEMOS ESTA RUTA PROTEGIDA, ya que es para obtener el usuario AUTENTICADO.
// Simplemente no la usaremos si no hay login.
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Rutas de la API de notas ahora son PÚBLICAS (sin el middleware 'auth:sanctum').
// Esto significa que cualquier persona puede crear, leer, actualizar y eliminar notas.
// Esto es para propósitos de depuración y prueba de funcionalidad sin login.
Route::apiResource('notes', NoteController::class);
