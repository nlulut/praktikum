/// Model data untuk merepresentasikan Profil Mahasiswa.
class Student {
  final String name;
  final String nim;
  final String programStudi;
  final String email;

  /// Konstruktor utama model [Student].
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Mengambil inisial maksimal 2 huruf dari nama mahasiswa untuk foto profil.
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Membuat salinan objek [Student] dengan pembaruan field tertentu.
  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }
}