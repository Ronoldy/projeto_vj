

import '../models/tarefa.dart';

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