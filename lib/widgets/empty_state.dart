import 'package:flutter/material.dart';

/// Widget modular untuk menampilkan tampilan saat daftar catatan masih kosong.
class EmptyState extends StatelessWidget {
  /// Konstruktor [EmptyState].
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Catatan Kuliah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol + di pojok kanan bawah untuk menambahkan catatan pertama Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}