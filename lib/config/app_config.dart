import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Kelas konfigurasi aplikasi yang memuat parameter dari file .env.
class AppConfig {
  /// Mengambil nilai BASE_URL dari file .env.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';

  /// Mengambil nilai API_KEY dari file .env.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}