import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/profile_card.dart';

/// Layar untuk melihat dan mengubah data profil mahasiswa.
class ProfileScreen extends StatefulWidget {
  final Student student;
  final Function(Student) onUpdateStudent;

  /// Konstruktor [ProfileScreen].
  const ProfileScreen({
    super.key,
    required this.student,
    required this.onUpdateStudent,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Student _currentStudent;

  @override
  void initState() {
    super.initState();
    _currentStudent = widget.student;
  }

  void _showEditDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: _currentStudent.name);
    final nimController = TextEditingController(text: _currentStudent.nim);
    final prodiController = TextEditingController(text: _currentStudent.programStudi);
    final emailController = TextEditingController(text: _currentStudent.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil Mahasiswa'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nimController,
                  decoration: const InputDecoration(labelText: 'NIM'),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'NIM wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: prodiController,
                  decoration: const InputDecoration(labelText: 'Program Studi'),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Prodi wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (val) => val == null || !val.contains('@')
                      ? 'Masukkan email yang valid'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final updated = _currentStudent.copyWith(
                  name: nameController.text.trim(),
                  nim: nimController.text.trim(),
                  programStudi: prodiController.text.trim(),
                  email: emailController.text.trim(),
                );
                setState(() => _currentStudent = updated);
                widget.onUpdateStudent(updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil diperbarui')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ProfileCard(
          student: _currentStudent,
          onEditPressed: _showEditDialog,
        ),
      ),
    );
  }
}