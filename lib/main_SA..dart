import 'package:flutter/material.dart';

void main() {
  runApp(const AgendadorTarefasApp());
}

class AgendadorTarefasApp extends StatelessWidget {
  const AgendadorTarefasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agendador de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: const ListaTarefasPage(),
    );
  }
}

enum Prioridade { baixa, media, alta }

class Tarefa {
  String titulo;
  String categoria;
  Prioridade prioridade;
  bool concluida;

  Tarefa({
    required this.titulo,
    required this.categoria,
    required this.prioridade,
    this.concluida = false,
  });
}

class ListaTarefasPage extends StatefulWidget {
  const ListaTarefasPage({super.key});

  @override
  State<ListaTarefasPage> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  final TextEditingController _controller = TextEditingController();
  
  String _categoriaSelecionada = 'Trabalho';
  Prioridade _prioridadeSelecionada = Prioridade.media;
  String _filtroAtual = 'Todas'; // Todas, Pendentes, Concluídas

  final List<Tarefa> _tarefas = [
    Tarefa(titulo: 'Organizar a área de trabalho do computador', categoria: 'Trabalho', prioridade: Prioridade.alta),
    Tarefa(titulo: 'Buscar a encomenda no correio', categoria: 'Pessoal', prioridade: Prioridade.media),
    Tarefa(titulo: 'Subir as alterações pro repositório (Git)', categoria: 'Estudos', prioridade: Prioridade.baixa, concluida: true),
  ];

  void _adicionarTarefa() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _tarefas.add(Tarefa(
        titulo: _controller.text.trim(),
        categoria: _categoriaSelecionada,
        prioridade: _prioridadeSelecionada,
      ));
    });

    _controller.clear();
  }

  void _removerTarefa(int indexReal) {
    setState(() {
      _tarefas.removeAt(indexReal);
    });
  }

  void _alternarStatus(int indexReal, bool? valor) {
    setState(() {
      _tarefas[indexReal].concluida = valor ?? false;
    });
  }

  Color _obterCorPrioridade(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.alta:
        return Colors.red;
      case Prioridade.media:
        return Colors.orange;
      case Prioridade.baixa:
        return Colors.green;
    }
  }

  String _textoPrioridade(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.alta:
        return 'Alta';
      case Prioridade.media:
        return 'Média';
      case Prioridade.baixa:
        return 'Baixa';
    }
  }

  @override
  Widget build(BuildContext context) {
    
    List<Tarefa> tarefasFiltradas = _tarefas.where((t) {
      if (_filtroAtual == 'Pendentes') return !t.concluida;
      if (_filtroAtual == 'Concluídas') return t.concluida;
      return true;
    }).toList();

    int totalConcluidas = _tarefas.where((t) => t.concluida).length;
    double progresso = _tarefas.isEmpty ? 0 : totalConcluidas / _tarefas.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendador de Tarefas"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: "Nova tarefa...",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.task_alt),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                       
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _categoriaSelecionada,
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            ),
                            items: ['Trabalho', 'Pessoal', 'Estudos']
                                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                .toList(),
                            onChanged: (val) => setState(() => _categoriaSelecionada = val!),
                          ),
                        ),
                        const SizedBox(width: 10),
                   
                   
                        Expanded(
                          child: DropdownButtonFormField<Prioridade>(
                            value: _prioridadeSelecionada,
                            decoration: const InputDecoration(
                              labelText: 'Prioridade',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            ),
                            items: Prioridade.values.map((p) {
                              return DropdownMenuItem(
                                value: p,
                                child: Text(_textoPrioridade(p)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _prioridadeSelecionada = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _adicionarTarefa,
                        icon: const Icon(Icons.add),
                        label: const Text("Adicionar Tarefa", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

           
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Progresso: $totalConcluidas de ${_tarefas.length} concluídas",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("${(progresso * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progresso,
                      backgroundColor: Colors.indigo.shade50,
                      color: Colors.indigo,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

           
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Todas', 'Pendentes', 'Concluídas'].map((filtro) {
                bool selecionado = _filtroAtual == filtro;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(filtro),
                    selected: selecionado,
                    onSelected: (val) => setState(() => _filtroAtual = filtro),
                    selectedColor: Colors.indigo.shade100,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // Lista de Tarefas
            Expanded(
              child: tarefasFiltradas.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhuma tarefa encontrada.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tarefasFiltradas.length,
                      itemBuilder: (context, index) {
                        final tarefa = tarefasFiltradas[index];
                        final indexReal = _tarefas.indexOf(tarefa);

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Checkbox(
                              value: tarefa.concluida,
                              onChanged: (valor) => _alternarStatus(indexReal, valor),
                            ),
                            title: Text(
                              tarefa.titulo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: tarefa.concluida
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: tarefa.concluida ? Colors.grey : Colors.black87,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Chip(
                                  label: Text(tarefa.categoria, style: const TextStyle(fontSize: 10)),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _obterCorPrioridade(tarefa.prioridade).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _textoPrioridade(tarefa.prioridade),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _obterCorPrioridade(tarefa.prioridade),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _removerTarefa(indexReal),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}