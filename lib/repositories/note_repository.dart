import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository untuk mengelola penyimpanan catatan lokal (SharedPreferences + SecureStorage)
/// serta pengambilan referensi data dari API publik.
class NoteRepository {
  static const String _metadataKey = 'notes_metadata';
  final SecureStorageService _secureStorage;

  /// Konstruktor [NoteRepository].
  NoteRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  /// Mengambil seluruh daftar catatan dengan menggabungkan metadata di SharedPreferences
  /// dan isi catatan terenkripsi di SecureStorage.
  Future<List<Note>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_metadataKey) ?? [];
    final List<Note> notes = [];

    for (final item in rawList) {
      final Map<String, dynamic> jsonMap = jsonDecode(item);
      final String id = jsonMap['id'] as String;
      final String content = await _secureStorage.getContent(id) ?? '';
      notes.add(Note.fromMetadataJson(jsonMap, content));
    }

    debugPrint('[NoteRepository] Berhasil memuat ${notes.length} catatan.');
    return notes;
  }

  /// Menyimpan catatan baru: metadata ke SharedPreferences dan isi ke SecureStorage.
  Future<void> addNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_metadataKey) ?? [];

    // Simpan isi catatan terenkripsi terlebih dahulu
    await _secureStorage.saveContent(note.id, note.content);

    // Simpan metadata JSON ke SharedPreferences
    rawList.add(jsonEncode(note.toMetadataJson()));
    await prefs.setStringList(_metadataKey, rawList);

    // Logging aman: hanya mencatat ID, tidak mencetak isi catatan
    debugPrint('[NoteRepository] Catatan ditambahkan (ID: ${note.id}).');
  }

  /// Menghapus catatan dari SharedPreferences maupun SecureStorage berdasarkan [noteId].
  Future<void> deleteNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_metadataKey) ?? [];

    rawList.removeWhere((item) {
      final Map<String, dynamic> jsonMap = jsonDecode(item);
      return jsonMap['id'] == noteId;
    });

    await prefs.setStringList(_metadataKey, rawList);
    await _secureStorage.deleteContent(noteId);

    debugPrint('[NoteRepository] Catatan dihapus (ID: $noteId).');
  }

  /// Mengambil daftar referensi topik/postingan dari API publik menggunakan HTTP GET.
  Future<List<Map<String, dynamic>>> fetchPublicPosts() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/posts?_limit=5');
    try {
      debugPrint('[HTTP] Mengambil data dari endpoint publik...');
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'X-Api-Key': AppConfig.apiKey,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('[HTTP] Berhasil memuat ${data.length} item referensi.');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw HttpException('Gagal memuat data (Status: ${response.statusCode})');
      }
    } on HttpException {
      // Pesan sudah aman (hanya status code), teruskan apa adanya.
      rethrow;
    } on SocketException {
      debugPrint('[HTTP Error] Tidak ada koneksi internet.');
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      debugPrint('[HTTP Error] Permintaan timeout.');
      throw Exception('Koneksi timeout. Server terlalu lama merespons.');
    } on FormatException {
      debugPrint('[HTTP Error] Format data tidak valid.');
      throw Exception('Format data tidak valid.');
    } catch (e) {
      // Detail teknis hanya ke log debug, tidak ke pesan untuk pengguna.
      debugPrint('[HTTP Error] ${e.runtimeType}');
      throw Exception('Gagal mengambil data referensi. Silakan coba lagi.');
    }
  }
}