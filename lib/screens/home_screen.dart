import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../repositories/note_repository.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';

/// Layar utama aplikasi yang menampilkan profil singkat, daftar catatan kuliah,
/// dan daftar referensi dari API publik.
class HomeScreen extends StatefulWidget {
  /// Konstruktor [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteRepository _apiRepository = NoteRepository();
  late Future<List<Map<String, dynamic>>> _publicPostsFuture;

  @override
  void initState() {
    super.initState();
    _publicPostsFuture = _apiRepository.fetchPublicPosts();
  }

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final provider = AppProvider.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Yakin ingin menghapus catatan "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteNote(note.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil dihapus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final student = provider.student;
    final notes = provider.notes;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catatan Kuliah'),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, size: 28),
              tooltip: 'Profil Mahasiswa',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                      student: student,
                      onUpdateStudent: provider.updateStudent,
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.note), text: 'Catatan Saya'),
              Tab(icon: Icon(Icons.cloud_download), text: 'Referensi API'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Banner Profil Singkat di bagian atas
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepPurple.shade100),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      student.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'NIM: ${student.nim} • ${student.programStudi}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Isi Tab
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Daftar Catatan Lokal
                  provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : notes.isEmpty
                          ? const EmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                final note = notes[index];
                                return NoteCard(
                                  note: note,
                                  onDelete: () => _confirmDelete(context, note),
                                );
                              },
                            ),

                  // Tab 2: Data HTTP GET dari API Publik
                  FutureBuilder<List>(
                    future: _publicPostsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 48),
                                const SizedBox(height: 8),
                                Text(
                                  '${snapshot.error}',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _publicPostsFuture =
                                          _apiRepository.fetchPublicPosts();
                                    });
                                  },
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final posts = snapshot.data ?? [];
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                child: Text(
                                  '${post['id']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                post['title'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                post['body'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Tambah Catatan',
          onPressed: () async {
            final Note? newNote = await Navigator.push<Note>(
              context,
              MaterialPageRoute(builder: (_) => const NoteFormScreen()),
            );
            if (newNote != null) {
              await provider.addNote(newNote);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan tersimpan secara terenkripsi!'),
                  ),
                );
              }
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}