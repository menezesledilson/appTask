import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Altere aqui o IP da sua API:
const String apiBaseUrl = "http://10.3.152.15:8080/tarefas";

void main() {
  runApp(
    const MaterialApp(
      home: TarefaInputScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class TarefaInputScreen extends StatefulWidget {
  const TarefaInputScreen({super.key});

  @override
  State<TarefaInputScreen> createState() => _TarefaInputScreenState();
}

class _TarefaInputScreenState extends State<TarefaInputScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> enviarTarefa() async {
    final String descricao = _controller.text;

    if (descricao.isEmpty) return;

    final response = await http.post(
      Uri.parse(apiBaseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"descricao": descricao}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tarefa enviada!')));
      _controller.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao enviar tarefa')));
    }
  }

  void navegarParaLista() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ListaTarefasScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Tarefa'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'Digite a tarefa'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: enviarTarefa,
              child: const Text('Enviar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: navegarParaLista,
              child: const Text('Ver tarefas salvas'),
            ),
          ],
        ),
      ),
    );
  }
}

class ListaTarefasScreen extends StatelessWidget {
  const ListaTarefasScreen({super.key});

  Future<List<dynamic>> fetchTarefas() async {
    final response = await http.get(Uri.parse(apiBaseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao buscar tarefas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas'), centerTitle: true),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTarefas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar tarefas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada'));
          } else {
            final tarefas = snapshot.data!;
            return ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          tarefa['descricao'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tarefa['data'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tarefa['hora'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
