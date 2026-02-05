import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'features/training/presentation/screens/exercise_library_screen.dart';

Future<void> main() async {
  // On s'assure que le moteur Flutter est prêt
  WidgetsFlutterBinding.ensureInitialized();

  // On initialise la base de données locale (Isar)
  final isar = await AppDatabase.init();

  // On lance l'application
  runApp(
    // ProviderScope est indispensable pour Riverpod
    ProviderScope(
      overrides: [
        // On injecte la base de données initialisée dans toute l'appli
        isarProvider.overrideWithValue(isar),
      ],
      child: const MyFitnessApp(),
    ),
  );
}

class MyFitnessApp extends StatelessWidget {
  const MyFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ExerciseLibraryScreen(),
    );
  }
}