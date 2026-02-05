import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/program_repository.dart';
import '../../data/models/exercise_model.dart';

class ProgramCreateScreen extends ConsumerStatefulWidget {
  const ProgramCreateScreen({super.key});

  @override
  ConsumerState<ProgramCreateScreen> createState() => _ProgramCreateScreenState();
}

class _ProgramCreateScreenState extends ConsumerState<ProgramCreateScreen> {
  final _nameController = TextEditingController();
  // Liste des exos sélectionnés (on stocke les objets entiers)
  final List<Exercise> _selectedExercises = [];

  // Une couleur par défaut (Bleu)
  int _selectedColor = 0xFF2196F3;

  @override
  Widget build(BuildContext context) {
    final allExercisesAsync = ref.watch(exercisesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Nouveau Programme")),
      body: Column(
        children: [
          // Champ Nom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nom du programme (ex: Push A)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Sélectionne les exercices :", style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          // Liste des exercices à cocher
          Expanded(
            child: allExercisesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Erreur: $err")),
              data: (exercises) {
                if (exercises.isEmpty) return const Center(child: Text("Crée d'abord des exercices !"));

                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exo = exercises[index];
                    final isSelected = _selectedExercises.contains(exo);

                    return CheckboxListTile(
                      title: Text(exo.name),
                      subtitle: Text(exo.bodyPart.name.toUpperCase()),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedExercises.add(exo);
                          } else {
                            _selectedExercises.remove(exo);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Bouton Valider
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProgram,
                child: const Text("Sauvegarder le Programme"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _saveProgram() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Donne un nom au programme !")));
      return;
    }
    if (_selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sélectionne au moins un exercice !")));
      return;
    }

    // Appel au Repository
    ref.read(programRepositoryProvider).createProgram(
      _nameController.text,
      _selectedColor,
      _selectedExercises,
    );

    Navigator.pop(context);
  }
}