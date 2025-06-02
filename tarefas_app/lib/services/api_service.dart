import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tarefa.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.105:8000/api';

  Future<List<Tarefa>> getTarefas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tarefas'),
      headers: {'Accept': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Tarefa.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load: ${response.statusCode}');
    }
  }

  Future<Tarefa> createTarefa(String titulo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tarefas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'titulo': titulo, 'concluida': false}),
    );
    
    if (response.statusCode == 201) {
      return Tarefa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create: ${response.statusCode}');
    }
  }

  Future<void> deleteTarefa(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tarefas/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete: ${response.statusCode}');
    }
  }

  Future<Tarefa> updateTarefa(Tarefa tarefa) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tarefas/${tarefa.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tarefa.toJson()),
    );
    
    if (response.statusCode == 200) {
      return Tarefa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update: ${response.statusCode}');
    }
  }
}