import 'package:isar/isar.dart';

// Cette ligne est CRUCIALE. C'est elle qui permet à Isar de générer le code SQL/NoSQL pour toi.
// Ça va être souligné en rouge au début, c'est NORMAL.
part 'workout_model.g.dart';

@collection
class WorkoutModel {
  // L'ID est géré automatiquement (auto-incrément)
  Id id = Isar.autoIncrement;

  // Le nom de l'exo (ex: "Développé Couché")
  late String name;

  // Le poids en kg
  double weight = 0.0;

  // Le nombre de répétitions
  int reps = 0;

  // La date de la séance (indexée pour faire des recherches rapides par date)
  @Index()
  late DateTime date;

  // Constructeur simple
  WorkoutModel({
    required this.name,
    required this.weight,
    required this.reps,
    required this.date,
  });
}
