import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../helpers/db_helper.dart';

class AppProvider extends ChangeNotifier {
  int _currentIndex = 0;
  List<TaskModel> _tasks = [];

  int get currentIndex => _currentIndex;
  List<TaskModel> get tasks => _tasks;

  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  void setPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ✅ Progress total (semua kategori)
  double get totalProgress {
    if (_tasks.isEmpty) return 0.0;
    final completed = _tasks.where((t) => t.isCompleted).length;
    return (completed / _tasks.length) * 100;
  }

  // ✅ Progress per kategori
  double getProgressByCategory(String category) {
    final filtered = _tasks.where((t) => t.category == category).toList();
    if (filtered.isEmpty) return 0.0;
    final completed = filtered.where((t) => t.isCompleted).length;
    return (completed / filtered.length) * 100;
  }

  // ✅ Memuat semua data dari database
  Future<void> loadTasksFromDB() async {
    _tasks = await DBHelper.getTasks();
    notifyListeners();
  }

  // ✅ Tambah tugas
  Future<void> tambahTugas(TaskModel task) async {
    await DBHelper.insertTask(task.toMap());
    _tasks.add(task);
    notifyListeners();
  }

  // ✅ Hapus tugas
  Future<void> hapusTugas(TaskModel task) async {
    if (task.id.isNotEmpty) {
      await DBHelper.deleteTask(task.id);
      _tasks.removeWhere((t) => t.id == task.id);
      notifyListeners();
    }
  }

  // ✅ Toggle status selesai/belum
  Future<void> toggleTugas(TaskModel task) async {
    if (task.id.isNotEmpty) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await DBHelper.updateTask(task.id, updatedTask.toMap());

      // Cari task di list dan update secara lokal
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners(); // Hanya panggil notifyListeners sekali
      }
    }
  }

  // ✅ Update tugas
  Future<void> updateTugas(String id, TaskModel updatedTask) async {
    // Memastikan bahwa task yang diupdate adalah task yang memiliki id yang sesuai
    await DBHelper.updateTask(id, updatedTask.toMap());

    // Mencari index task yang sesuai dalam list dan memperbarui task yang ada
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask; // Update task di list
      notifyListeners(); // Memberi tahu bahwa ada perubahan data
    }
  }

  // ✅ Reset semua data
  Future<void> resetProgress() async {
    await DBHelper.deleteAllTasks();
    _tasks.clear();
    notifyListeners();
  }
}
