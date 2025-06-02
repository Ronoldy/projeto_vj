<?php

namespace App\Http\Controllers;

use App\Models\Tarefa;
use Illuminate\Http\Request;

class TarefaController extends Controller
{
    public function index()
    {
        return response()->json(Tarefa::all()->map(function ($tarefa) {
            return [
                'id' => $tarefa->id,
                'titulo' => $tarefa->titulo,
                'concluida' => (bool)$tarefa->concluida // Convertendo para boolean
            ];
        }));
    }

    public function store(Request $request)
    {
        $request->validate([
            'titulo' => 'required|string|max:255',
            'concluida' => 'sometimes|boolean'
        ]);

        return response()->json(
            Tarefa::create([
                'titulo' => $request->titulo,
                'concluida' => $request->concluida ?? false,
            ]),
            201 // Status code para criação
        );
    }

    public function show(Tarefa $tarefa)
    {
        return response()->json([
            'id' => $tarefa->id,
            'titulo' => $tarefa->titulo,
            'concluida' => (bool)$tarefa->concluida
        ]);
    }

    public function update(Request $request, Tarefa $tarefa)
    {
        $request->validate([
            'titulo' => 'sometimes|string|max:255',
            'concluida' => 'sometimes|boolean'
        ]);

        $tarefa->update($request->only(['titulo', 'concluida']));
        
        return response()->json([
            'id' => $tarefa->id,
            'titulo' => $tarefa->titulo,
            'concluida' => (bool)$tarefa->concluida
        ]);
    }

    public function destroy(Tarefa $tarefa)
    {
        $tarefa->delete();
        return response()->json(null, 204); // Status code para No Content
    }
}