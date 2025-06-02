import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/api_service.dart';

// Add this extension for copyWith functionality
extension TarefaCopyWith on Tarefa {
  Tarefa copyWith({
    int? id,
    String? titulo,
    bool? concluida,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      concluida: concluida ?? this.concluida,
    );
  }
}

class EditTarefaPage extends StatefulWidget {
  final Tarefa tarefa;
  
  const EditTarefaPage({
    super.key,
    required this.tarefa,
  });

  @override
  State<EditTarefaPage> createState() => _EditTarefaPageState();
}

class _EditTarefaPageState extends State<EditTarefaPage> {
  late final TextEditingController _controller;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _concluida = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.tarefa.titulo);
    _concluida = widget.tarefa.concluida;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _salvarEdicao() async {
    if (_controller.text.isEmpty || !mounted || _isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      await _apiService.updateTarefa(
        widget.tarefa.copyWith(
          titulo: _controller.text,
          concluida: _concluida,
        ),
      );
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao editar tarefa: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _salvarEdicao,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Título da Tarefa',
                border: OutlineInputBorder(),
                hintText: 'Edite o título da tarefa',
              ),
              maxLength: 100,
              textInputAction: TextInputAction.done,
            ),
            SwitchListTile(
              title: const Text('Tarefa Concluída'),
              value: _concluida,
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _concluida = value),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarEdicao,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Salvar Alterações'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}