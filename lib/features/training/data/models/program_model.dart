import 'package:isar/isar.dart';
import 'exercise_model.dart';

part 'program_model.g.dart';

@collection
class Program {
  Id id = Isar.autoIncrement;

  late String name; // ex: "Push Day"

  // Le lien vers les exercices (Relation 1 vers N)
  final exercises = IsarLinks<Exercise>();

  // Couleur pour l'affichage dans le calendrier
  int color = 0xFF2196F3;

  Program();
}