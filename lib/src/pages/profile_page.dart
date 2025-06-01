import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart'; // Pastikan path ini sesuai dengan struktur proyek Anda

// Asumsikan ini adalah struktur dasar dari ProfilePage Anda
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tambahkan elemen UI lain di sini jika ada

            // Tombol Reset Semua Tugas
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) { // Menggunakan dialogContext untuk dialog
                    return AlertDialog(
                      title: const Text("Konfirmasi Reset"),
                      content: const Text("Apakah Anda yakin ingin menghapus semua tugas? Tindakan ini tidak dapat dibatalkan."),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Batal"),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Tutup dialog
                          },
                        ),
                        TextButton(
                          child: const Text("Hapus Semua"),
                          onPressed: () async {
                            Navigator.of(dialogContext).pop(); // Tutup dialog konfirmasi
                            final appProvider = Provider.of<AppProvider>(context, listen: false); // Menggunakan context dari widget Tree
                            await appProvider.resetProgress(); // Memanggil fungsi reset database
                            if (context.mounted) { // Memastikan widget masih terpasang sebelum menampilkan SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Semua tugas berhasil dihapus!')),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna tombol merah untuk menandakan tindakan destruktif
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Reset Semua Tugas",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}