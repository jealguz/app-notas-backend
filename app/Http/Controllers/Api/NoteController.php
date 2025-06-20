<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Note; // <--- ¡Asegúrate de que esta línea esté aquí!
use Illuminate\Http\Request;
use Illuminate\Http\Response; // <--- ¡Asegúrate de que esta línea también esté aquí!

class NoteController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Obtener todas las notas
        $notes = Note::all();
        return response()->json($notes);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Validar los datos de entrada
        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'nullable|string',
            'completed' => 'boolean' // Campo para la nota completada
        ]);

        // Crear una nueva nota
        $note = Note::create([
            'title' => $request->title,
            'content' => $request->content,
            'completed' => $request->boolean('completed', false) // Por defecto false
        ]);

        return response()->json($note, Response::HTTP_CREATED); // 201 Created
    }

    /**
     * Display the specified resource.
     */
    public function show(Note $note) // Nota: Aquí usamos "Note $note" para inyección de modelo
    {
        // Retornar la nota específica
        return response()->json($note);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Note $note) // Nota: Aquí usamos "Note $note"
    {
        // Validar los datos de entrada
        $request->validate([
            'title' => 'sometimes|required|string|max:255', // 'sometimes' para que no sea obligatorio en la actualización
            'content' => 'nullable|string',
            'completed' => 'boolean'
        ]);

        // Actualizar la nota
        $note->update($request->all());

        return response()->json($note);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Note $note) // Nota: Aquí usamos "Note $note"
    {
        // Eliminar la nota
        $note->delete();

        return response()->json(null, Response::HTTP_NO_CONTENT); // 204 No Content
    }
}
