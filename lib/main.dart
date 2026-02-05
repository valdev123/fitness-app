import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';

Future<void> main() async {
  // 1. On s'assure que le moteur Flutter est prêt
  WidgetsFlutterBinding.ensureInitialized();

  // 2. On initialise la base de données locale (Isar)
  // C'est ici qu'on charge les données sur le S25 avant de lancer l'interface
  final isar = await AppDatabase.init();

  // 3. On lance l'application
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
      title: 'Fitness App S25',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Juste un écran vide pour l'instant pour valider que ça marche
      home: const Scaffold(
        body: Center(
          child: Text(
            'Setup Terminé ! 🚀',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}