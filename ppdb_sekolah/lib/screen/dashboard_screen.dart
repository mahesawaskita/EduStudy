
import 'package:flutter/material.dart';
import 'formulir_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String nama;
  final String token;

  const DashboardScreen({
    super.key,
    required this.nama,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        title: const Text('PPDB SEKOLAH'),
        backgroundColor: const Color(0xFF2463A6),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang, $nama!',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Dashboard Siswa',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              const Text(
                'Menu Utama',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                  children: [
                    menuCard(
                      context,
                      'Formulir Pendaftaran',
                      Icons.assignment,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormulirScreen(
                              token: token,
                            ),
                          ),
                        );
                      },
                    ),

                    menuCard(
                      context,
                      'Status Pendaftaran',
                      Icons.fact_check,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Halaman status belum dibuat.'),
                          ),
                        );
                      },
                    ),

                    menuCard(
                      context,
                      'Pengumuman',
                      Icons.campaign,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Halaman pengumuman belum dibuat.'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard(
    BuildContext context,
    String judul,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF2463A6),
            ),
            const SizedBox(height: 12),
            Text(
              judul,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
