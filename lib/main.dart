import 'package:aduduh_app/src/pages/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import './src/navigation/main_navigation.dart';
import './src/providers/app_provider.dart';
import './src/pages/home_page.dart';
import './src/pages/profile_page.dart';
// import './src/pages/detail_task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); // Inisialisasi format lokal
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adu-Duh Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4BD8),
          primary: const Color.fromARGB(255, 30, 58, 158),
          secondary: const Color.fromARGB(255, 160, 82, 228),
          tertiary: const Color.fromARGB(255, 245, 237, 255),
          surface: const Color(0xFFF5F5F5),
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 215, 215, 215),
        useMaterial3: true,
      ),

      routes: {
        '/': (context) => const MainNavigation(),
        '/home': (context) => const HomePage(),
        '/task': (context) => const TasksPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
