import 'package:isar/isar.dart';
import 'program_model.dart';
import 'exercise_model.dart';

part 'workout_session_model.g.dart';

@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  final program = IsarLink<Program>();

  List<WorkoutLog> logs = [];

  // Durée de la séance en minutes
  int? durationInMinutes;

  WorkoutSession();
}

@embedded
class WorkoutLog {
  // On stocke l'ID de l'exercice
  int? exerciseId;

  // Pour l'affichage historique, on garde aussi le nom
  String? exerciseName;

  double weight = 0.0;
  int reps = 0;

  // série d'échauffement
  bool isWarmup = false;
}