import 'package:isar/isar.dart';

part 'exercise_model.g.dart';

enum BodyPart {
  pecs,
  dos,
  jambes,
  epaules,
  bras,
  abdos,
  cardio,
  autre
}

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value) // Indexé
  late String name;

  @Enumerated(EnumType.name)
  late BodyPart bodyPart;

  String? instructions; // Description technique

  Exercise();

  Exercise.create({
    required this.name,
    required this.bodyPart,
    this.instructions,
  });
}