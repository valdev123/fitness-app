import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/models/exercise_model.dart';

class ExerciseLibraryScreen extends ConsumerWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute le stream
    final exercisesAsync = ref.watch(exercisesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Exercices'),
      ),
      body: exercisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (exercises) {
          if (exercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Aucun exercice.\nCrée ton premier g mouvement !", textAlign: TextAlign.center),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: exercises.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final exo = exercises[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(exo.name[0].toUpperCase()),
                ),
                title: Text(exo.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(exo.bodyPart.name.toUpperCase()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // Suppression avec confirmation
                    ref.read(exerciseRepositoryProvider).deleteExercise(exo.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        label: const Text('Nouvel Exercice'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // La fenêtre pour ajouter un exo
  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    // Valeur par défaut du dropdown
    BodyPart selectedPart = BodyPart.pecs;

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder permet de mettre à jour le Dropdown DANS la dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Créer un exercice'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom (ex: Développé Couché)',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<BodyPart>(
                    value: selectedPart,
                    decoration: const InputDecoration(labelText: 'Muscle ciblé'),
                    items: BodyPart.values.map((part) {
                      return DropdownMenuItem(
                        value: part,
                        child: Text(part.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => selectedPart = val!);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      ref.read(exerciseRepositoryProvider).createExercise(
                        nameController.text,
                        selectedPart,
                        null,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Créer'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}