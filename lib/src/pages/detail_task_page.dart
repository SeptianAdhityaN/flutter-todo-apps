import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/app_provider.dart';
import 'edit_task_page.dart';

class DetailTaskPage extends StatelessWidget {
  final TaskModel task;
  final String index;

  const DetailTaskPage({super.key, required this.task, required this.index});

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('dd MMMM yyyy').format(date);
  }

  Widget _buildReadOnlyField(String label, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField(String category) {
    Icon icon;
    String label;

    if (category == 'Tugas Kuliah') {
      icon = Icon(Icons.school, color: Colors.deepPurple[300]);
      label = 'Tugas Kuliah';
    } else {
      icon = const Icon(Icons.person, color: Colors.blueAccent);
      label = 'Tugas Pribadi';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _deleteTask(BuildContext context) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.hapusTugas(task);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF3F1F6),
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildCategoryField(task.category),
            _buildReadOnlyField("Judul Tugas", task.title),
            _buildReadOnlyField("Deskripsi", task.description),
            _buildReadOnlyField("Tanggal Mulai", formatDate(task.startDate)),
            _buildReadOnlyField("Deadline", formatDate(task.endDate)),
            const SizedBox(height: 24),

            // Tombol Ubah Tugas (dengan gradient)
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskPage(index: index, task: task),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Ubah Tugas',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Hapus
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: () => _deleteTask(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Hapus Tugas',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}