/// Model data untuk merepresentasikan Catatan Kuliah.
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  /// Konstruktor utama model [Note].
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  /// Mengubah metadata [Note] (tanpa [content]) menjadi Map JSON untuk SharedPreferences.
  Map<String, dynamic> toMetadataJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Membuat objek [Note] dari Map JSON metadata yang digabungkan dengan [content] dari SecureStorage.
  factory Note.fromMetadataJson(Map<String, dynamic> json, String content) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: content,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}