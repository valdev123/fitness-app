import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
// Importe ton modèle qu'on vient de créer
import '../../features/training/data/models/workout_model.dart';

// Ce provider permettra d'accéder à la BDD depuis n'importe où dans l'appli
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar doit être initialisé dans le main.dart');
});

class AppDatabase {
  static Future<Isar> init() async {
    // 1. On récupère le dossier sécurisé de l'application sur le téléphone
    final dir = await getApplicationDocumentsDirectory();

    // 2. On ouvre la base de données avec nos schémas
    final isar = await Isar.open(
      [WorkoutModelSchema], // Ce Schema sera généré à l'étape suivante
      directory: dir.path,
    );

    return isar;
  }
}
