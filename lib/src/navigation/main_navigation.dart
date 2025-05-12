import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/home_page.dart';
import '../pages/tasks_page.dart';
import '../pages/focus_page.dart';
import '../pages/profile_page.dart';
import '../providers/app_provider.dart';
import '../pages/add_task_page.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  final List<Widget> _pages = const [
    HomePage(),
    TasksPage(),
    FocusPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: _pages[appProvider.currentIndex],
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20), // Geser tombol ke atas
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary,],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddTaskPage(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appProvider.currentIndex,
        onTap: (index) => appProvider.setPage(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Colors.grey[500], // Warna ikon yang tidak dipilih tetap abu-abu
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        items: [
          BottomNavigationBarItem(
            icon: _buildIconWithCondition(
              Icons.home,
              0,
              appProvider.currentIndex,
            ),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithCondition(
              Icons.calendar_today,
              1,
              appProvider.currentIndex,
            ),
            label: "Tugas",
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithCondition(
              Icons.watch_later,
              2,
              appProvider.currentIndex,
            ),
            label: "Fokus",
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithCondition(
              Icons.person,
              3,
              appProvider.currentIndex,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /// 🔹 Fungsi untuk Membuat Ikon dengan Gradasi
  Widget _buildGradientIcon(IconData icon, double size) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 30, 58, 158),
            Color.fromARGB(255, 160, 82, 228),
          ], // Gradasi biru dongker ke ungu
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Icon(icon, size: size, color: Colors.white), // Warna default putih
    );
  }

  Widget _buildIconWithCondition(IconData icon, int index, int currentIndex) {
    return currentIndex == index
        ? _buildGradientIcon(icon, 28) // Jika aktif, gunakan gradasi
        : Icon(
          icon,
          size: 28,
          color: Colors.grey[500],
        ); // Jika tidak aktif, tetap abu-abu
  }
}
