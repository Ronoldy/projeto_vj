<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tarefa extends Model
{
    use HasFactory;

    protected $fillable = ['titulo', 'concluida'];
    
    protected $casts = [
        'concluida' => 'boolean' // Converte automaticamente para boolean
    ];
    
    protected $hidden = [
        'created_at', 
        'updated_at'
    ];
}