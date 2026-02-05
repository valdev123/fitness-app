import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../core/database/app_database.dart';
import '../models/program_model.dart';
import '../models/exercise_model.dart';

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return ProgramRepository(isar);
});

final programsStreamProvider = StreamProvider<List<Program>>((ref) {
  final repo = ref.watch(programRepositoryProvider);
  return repo.watchAllPrograms();
});

class ProgramRepository {
  final Isar isar;

  ProgramRepository(this.isar);

  // Créer un programme et y attacher des exercices
  Future<void> createProgram(String name, int colorValue, List<Exercise> selectedExercises) async {
    final program = Program()
      ..name = name
      ..color = colorValue;

    await isar.writeTxn(() async {
      // On sauvegarde le programme "vide" pour avoir un ID
      await isar.programs.put(program);

      // On ajoute les liens vers les exercices sélectionnés
      program.exercises.addAll(selectedExercises);

      // On sauvegarde la relation (le lien)
      await program.exercises.save();
    });
  }

  // Lire les programmes en temps réel
  Stream<List<Program>> watchAllPrograms() {
    return isar.programs.where().watch(fireImmediately: true);
  }

  // Supprimer un programme
  Future<void> deleteProgram(int id) async {
    await isar.writeTxn(() async {
      await isar.programs.delete(id);
    });
  }
}