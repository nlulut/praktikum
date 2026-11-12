/// Kelas utilitas untuk validasi dan sanitasi input pengguna.
class Validators {
  /// Memvalidasi judul catatan (minimal 3 karakter, maksimal 50 karakter).
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul catatan tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Judul catatan minimal 3 karakter';
    }
    if (trimmed.length > 50) {
      return 'Judul catatan maksimal 50 karakter';
    }
    return null;
  }

  /// Memvalidasi isi catatan (minimal 10 karakter, maksimal 1000 karakter).
  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Isi catatan tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (trimmed.length < 10) {
      return 'Isi catatan minimal 10 karakter';
    }
    if (trimmed.length > 1000) {
      return 'Isi catatan maksimal 1000 karakter';
    }
    return null;
  }

  /// Membersihkan karakter berbahaya (<, >, ", ') dari string input.
  static String sanitize(String input) {
    return input.replaceAll(RegExp(r'[<>"\x27]'), '').trim();
  }
}