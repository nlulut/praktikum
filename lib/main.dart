import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

/// Fungsi utama titik masuk (entry point) aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

/// Widget root aplikasi Profil Mahasiswa dengan Catatan Kuliah.
class MyApp extends StatelessWidget {
  /// Konstruktor [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderWrapper(
      child: MaterialApp(
        title: 'Profil Mahasiswa & Catatan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: false,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}