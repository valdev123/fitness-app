import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/program_repository.dart';
import 'program_create_screen.dart';

class ProgramListScreen extends ConsumerWidget {
  const ProgramListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Mes Programmes")),
      body: programsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Erreur: $err")),
        data: (programs) {
          if (programs.isEmpty) {
            return const Center(child: Text("Aucun programme. Crées-en un !"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final prog = programs[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(prog.color),
                    child: Text(prog.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(prog.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18 )),
                  subtitle: Text("${prog.exercises.length} exercices"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      ref.read(programRepositoryProvider).deleteProgram(prog.id);
                    },
                  ),
                  onTap: () {
                    // TODO: Plus tard, ici on lancera la séance !
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lancement de ${prog.name}... bientôt !")));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProgramCreateScreen()),
          );
        },
      ),
    );
  }
}