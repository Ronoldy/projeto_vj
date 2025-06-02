<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});


Route::get('/test-db', function() {
    try {
        \DB::connection()->getPdo();
        return "Conexão com o banco de dados funcionando!";
    } catch (\Exception $e) {
        return "Erro na conexão: " . $e->getMessage();
    }
});