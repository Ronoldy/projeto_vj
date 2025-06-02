import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/api_service.dart';
import 'add_tarefa_page.dart';
import 'edit_tarefa_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  List<Tarefa> _tarefas = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _loadTasks() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tasks = await _api.getTarefas();
      if (!mounted) return;
      setState(() => _tarefas = tasks);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleTask(Tarefa task) async {
    try {
      await _api.updateTarefa(task.copyWith(concluida: !task.concluida));
      await _loadTasks();
    } catch (e) {
      _showError('Falha ao atualizar: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  AddTarefaPage()),
          );
          await _loadTasks();
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _buildError();
    if (_tarefas.isEmpty) return _buildEmpty();
    return _buildTaskList();
  }

  Widget _buildError() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_error!),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loadTasks,
          child: const Text('Tentar novamente'),
        ),
      ],
    ),
  );

  Widget _buildEmpty() => const Center(
    child: Text('Nenhuma tarefa encontrada'),
  );

  Widget _buildTaskList() => ListView.builder(
    itemCount: _tarefas.length,
    itemBuilder: (ctx, index) {
      final task = _tarefas[index];
      return CheckboxListTile(
        title: Text(task.titulo),
        value: task.concluida,
        onChanged: (_) => _toggleTask(task),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editTask(task),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(task.id),
            ),
          ],
        ),
      );
    },
  );

  Future<void> _editTask(Tarefa task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditTarefaPage(tarefa: task),
      ),
    );
    await _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    try {
      await _api.deleteTarefa(id);
      await _loadTasks();
      _showError('Tarefa removida');
    } catch (e) {
      _showError('Falha ao remover: $e');
    }
  }
}