import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'features/training/presentation/screens/exercise_library_screen.dart';
import 'features/training/presentation/screens/program_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await AppDatabase.init();

  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const MyFitnessApp(),
    ),
  );
}

class MyFitnessApp extends StatelessWidget {
  const MyFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

// Nouvel écran principal avec barre de navigation en bas
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // La liste des écrans disponibles
  final List<Widget> _screens = [
    const ProgramListScreen(),      // Onglet 0
    const ExerciseLibraryScreen(),  // Onglet 1
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_view_day),
            label: 'Programmes',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Exercices',
          ),
        ],
      ),
    );
  }
}