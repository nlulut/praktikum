import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/validators.dart';

/// Layar form untuk menambahkan catatan kuliah baru dengan validasi dan sanitasi.
class NoteFormScreen extends StatefulWidget {
  /// Konstruktor [NoteFormScreen].
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final cleanTitle = Validators.sanitize(_titleController.text);
      final cleanContent = Validators.sanitize(_contentController.text);

      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: cleanTitle,
        content: cleanContent,
        createdAt: DateTime.now(),
      );

      Navigator.pop(context, newNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan Kuliah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Catatan',
                  hintText: 'Contoh: Pertemuan 6 - Keamanan Mobile',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  hintText: 'Tuliskan ringkasan materi kuliah di sini...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: Validators.validateContent,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Catatan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}