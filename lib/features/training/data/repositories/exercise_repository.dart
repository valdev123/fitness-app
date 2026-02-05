import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../core/database/app_database.dart';
import '../models/exercise_model.dart';

// Le Provider pour accéder au Repo depuis l'UI
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return ExerciseRepository(isar);
});

// Le Provider pour écouter la liste des exercices en temps réel
final exercisesStreamProvider = StreamProvider<List<Exercise>>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.watchAllExercises();
});

class ExerciseRepository {
  final Isar isar;

  ExerciseRepository(this.isar);

  // Créer un exercice
  Future<void> createExercise(String name, BodyPart bodyPart, String? instructions) async {
    final exercise = Exercise.create(
      name: name,
      bodyPart: bodyPart,
      instructions: instructions,
    );

    await isar.writeTxn(() async {
      await isar.exercises.put(exercise);
    });
  }

  // Écouter tous les exercices
  Stream<List<Exercise>> watchAllExercises() {
    return isar.exercises
        .where()
        .sortByName()
        .watch(fireImmediately: true);
  }

  // Supprimer
  Future<void> deleteExercise(int id) async {
    await isar.writeTxn(() async {
      await isar.exercises.delete(id);
    });
  }
}