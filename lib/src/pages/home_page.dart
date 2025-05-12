import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'tasks_page.dart';
import 'detail_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppProvider>(context, listen: false).loadTasksFromDB();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text("Beranda", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/default_profile.png"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressCard(appProvider),
          _buildCategorySection(appProvider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Terbaru",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TasksPage()),
                    );
                  },
                  child: const Text(
                    "Lihat selengkapnya...",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                appProvider.tasks.isEmpty
                    ? _buildEmptyState()
                    : _buildTaskList(appProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ini Seluruh Progresmu.\nTetap Semangat!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TasksPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Lihat Tugas"),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: appProvider.totalProgress / 100,
                  strokeWidth: 7,
                  backgroundColor: Colors.white.withAlpha(40),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              Text(
                "${appProvider.totalProgress.toInt()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(AppProvider appProvider) {
    final kuliahTasks =
        appProvider.tasks
            .where((task) => task.category == "Tugas Kuliah")
            .toList();
    final pribadiTasks =
        appProvider.tasks
            .where((task) => task.category == "Tugas Pribadi")
            .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildCategoryCard(
              "Tugas Kuliah",
              "Universitas Negeri Surabaya",
              Icons.school,
              Color.fromARGB(255, 222, 203, 255),
              kuliahTasks.length,
              kuliahTasks.where((t) => t.isCompleted).length,
              true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCategoryCard(
              "Tugas Pribadi",
              "Proyek pribadi",
              Icons.person,
              Color.fromARGB(255, 195, 208, 255),
              pribadiTasks.length,
              pribadiTasks.where((t) => t.isCompleted).length,
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    IconData icon,
    Color backgroundColor,
    int totalTasks,
    int completedTasks,
    bool isKuliah,
  ) {
    double progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    Color progressColor =
        isKuliah
            ? Color.fromARGB(255, 158, 109, 247)
            : Color.fromARGB(255, 106, 138, 255);
    Color iconColor = progressColor;

    return Container(
      padding: const EdgeInsets.all(14),
      height: 120,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(icon, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black12,
            color: progressColor,
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset("assets/images/empty.png", width: 200),
          const SizedBox(height: 20),
          const Text(
            "Awas Deadline! Urus Dulu Tuh",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Tekan + untuk tambah tugas",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(AppProvider appProvider) {
    final recentTasks = appProvider.tasks.reversed.take(5).toList();

    return ListView.builder(
      itemCount: recentTasks.length,
      itemBuilder: (context, index) {
        final task = recentTasks[index];
        final endDate = DateTime.tryParse(task.endDate);
        final dateStr =
            endDate != null ? DateFormat('dd/MM/yyyy').format(endDate) : '-';
        final remaining = endDate?.difference(DateTime.now()).inDays;

        final isKuliah = task.category == 'Tugas Kuliah';
        final statusColor = task.isCompleted ? Colors.green : Colors.orange;
        final statusLabel = task.isCompleted ? 'Selesai' : 'Berlangsung';

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
                    task.isCompleted ? Colors.orange : Colors.green,
                foregroundColor: Colors.white,
                icon: task.isCompleted ? Icons.close : Icons.check,
                label: task.isCompleted ? 'Batal' : 'Selesai',
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
                MaterialPageRoute(builder: (_) => DetailTaskPage(index: index.toString(), task: task)),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.category,
                        style: TextStyle(
                          color:
                              isKuliah ? Colors.deepPurple[300] : Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isKuliah ? Icons.school : Icons.person,
                        color: isKuliah ? Colors.deepPurple[300] : Colors.blueAccent,
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
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(77),
                          borderRadius: BorderRadius.circular(12),
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
    );
  }
}
