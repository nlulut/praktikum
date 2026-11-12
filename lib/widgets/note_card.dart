import 'package:flutter/material.dart';
import '../models/note.dart';

/// Widget modular untuk menampilkan satu item kartu catatan kuliah.
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;

  /// Konstruktor [NoteCard].
  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Hapus catatan',
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              note.content,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.lock_outline, size: 14, color: Colors.green[700]),
                const SizedBox(width: 4),
                Text(
                  'Terenkripsi • ${_formatDate(note.createdAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}