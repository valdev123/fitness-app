import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Imports de TES modèles
import '../../features/training/data/models/exercise_model.dart';
import '../../features/training/data/models/program_model.dart';
import '../../features/training/data/models/workout_session_model.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar doit être initialisé dans le main.dart');
});

class AppDatabase {
  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();

    return await Isar.open(
      [
        ExerciseSchema,
        ProgramSchema,
        WorkoutSessionSchema,
      ],
      directory: dir.path,
    );
  }
}