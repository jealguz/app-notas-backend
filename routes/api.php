<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\NoteController; // Importa tu controlador

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route for authenticated user details (often included for Sanctum)
// You can keep this or remove it if you're not planning authentication yet.
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Ruta de prueba simple
Route::get('/test-api', function () {
    return response()->json(['message' => 'API de prueba funcionando!']);
});

// Rutas para las notas de tu API
Route::apiResource('notes', NoteController::class);
