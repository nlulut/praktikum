import 'package:flutter/material.dart';
import '../models/student.dart';

/// Widget modular untuk menampilkan kartu profil mahasiswa.
class ProfileCard extends StatelessWidget {
  final Student student;
  final VoidCallback onEditPressed;

  /// Konstruktor [ProfileCard].
  const ProfileCard({
    super.key,
    required this.student,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              student.initials,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            student.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'NIM: ${student.nim}',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const Divider(height: 28),
          _buildInfoRow(Icons.school, 'Program Studi', student.programStudi),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email, 'Email', student.email),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEditPressed,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color.fromARGB(255, 67, 0, 83)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}