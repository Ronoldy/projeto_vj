class Tarefa {
  final int id;
  final String titulo;
  final bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.concluida,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      concluida: json['concluida'] == true || json['concluida'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'concluida': concluida ? 1 : 0, // Converte para inteiro (0/1)
  };
}