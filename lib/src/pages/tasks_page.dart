import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/app_provider.dart';
import 'detail_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _selectedStatus = 'semua';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = null;
  }

  List<DateTime> getDaysRange() {
    final now = DateTime.now();
    return List.generate(7, (index) => now.add(Duration(days: index - 3)));
  }

  List<TaskModel> _applyFilters(List<TaskModel> tasks) {
    return tasks
        .where((task) {
          final taskDate = DateTime.tryParse(task.endDate);
          if (taskDate == null) return false;

          final sameDay =
              _selectedDate == null
                  ? true
                  : taskDate.year == _selectedDate!.year &&
                      taskDate.month == _selectedDate!.month &&
                      taskDate.day == _selectedDate!.day;

          final matchesStatus =
              _selectedStatus == 'semua' ||
              (_selectedStatus == 'berlangsung' && !task.isCompleted) ||
              (_selectedStatus == 'selesai' && task.isCompleted);

          return sameDay && matchesStatus;
        })
        .toList()
        .reversed
        .toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset("assets/images/empty.png", width: 200),
          const SizedBox(height: 20),
          const Text(
            "Belum ada tugas yang ditampilkan.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Coba ubah filter atau tambah tugas dulu.",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final filteredTasks = _applyFilters(appProvider.tasks);
        final dateButtons = getDaysRange();

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text('Tugas'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔹 Tanggal Selector
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dateButtons.length,
                    itemBuilder: (context, index) {
                      final date = dateButtons[index];
                      final isSelected =
                          _selectedDate != null &&
                          date.day == _selectedDate!.day &&
                          date.month == _selectedDate!.month;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedDate != null &&
                                date.day == _selectedDate!.day &&
                                date.month == _selectedDate!.month &&
                                date.year == _selectedDate!.year) {
                              // Jika tanggal yang sedang dipilih diklik lagi → batalkan filter
                              _selectedDate = null;
                            } else {
                              _selectedDate = date;
                            }
                          });
                        },
                        child: Container(
                          width: 70,
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient:
                                isSelected
                                    ? LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                    : null,
                            color: isSelected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat(
                                  'MMM',
                                  'id_ID',
                                ).format(date).capitalize(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'EEE',
                                  'id_ID',
                                ).format(date).capitalize(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔹 Filter Status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        ['semua', 'berlangsung', 'selesai'].map((status) {
                          final isSelected = _selectedStatus == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedStatus = status;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient:
                                      isSelected
                                          ? LinearGradient(
                                            colors: [
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ],
                                          )
                                          : null,
                                  color:
                                      isSelected ? null : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Text(
                                  status.capitalize(),
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 8),

                // 🔹 Task List
                Expanded(
                  child:
                      filteredTasks.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              final endDate = DateTime.tryParse(task.endDate);
                              final dateStr =
                                  endDate != null
                                      ? DateFormat('dd/MM/yyyy').format(endDate)
                                      : '-';
                              final remaining =
                                  endDate?.difference(DateTime.now()).inDays;

                              final isKuliah = task.category == 'Tugas Kuliah';
                              final statusColor =
                                  task.isCompleted
                                      ? Colors.green
                                      : Colors.orange;
                              final statusLabel =
                                  task.isCompleted ? 'Selesai' : 'Berlangsung';

                              return Slidable(
                                key: Key(task.id.toString()),
                                startActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.25,
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        appProvider.toggleTugas(task);
                                      },
                                      backgroundColor:
                                          task.isCompleted
                                              ? Colors.orange
                                              : Colors.green,
                                      foregroundColor: Colors.white,
                                      icon:
                                          task.isCompleted
                                              ? Icons.close
                                              : Icons.check,
                                      label:
                                          task.isCompleted
                                              ? 'Batal'
                                              : 'Selesai',
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.25,
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        appProvider.hapusTugas(task);
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Hapus',
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => DetailTaskPage(
                                              index: index.toString(),
                                              task: task,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              task.category,
                                              style: TextStyle(
                                                color:
                                                    isKuliah
                                                        ? Colors.deepPurple[300]
                                                        : Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              isKuliah
                                                  ? Icons.school
                                                  : Icons.person,
                                              color:
                                                  isKuliah
                                                      ? Colors.deepPurple[300]
                                                      : Colors.blueAccent,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 4),
                                        Text(
                                          task.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),

                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.watch_later_outlined,
                                              size: 16,
                                              color: Colors.purple,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '$dateStr'
                                              '${remaining != null && remaining >= 0 ? " (Tersisa $remaining hari)" : ""}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: statusColor.withAlpha(
                                                  77,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                statusLabel,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
