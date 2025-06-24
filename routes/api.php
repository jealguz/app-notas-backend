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
// Requiere autenticación con 'sanctum'.
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Protege todas las rutas de la API de notas con el middleware 'auth:sanctum'.
// Esto significa que para acceder a cualquier operación CRUD de notas,
// el usuario debe estar autenticado.
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('notes', NoteController::class);
});
