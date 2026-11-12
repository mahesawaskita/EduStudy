
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormulirScreen extends StatefulWidget {
  final String token;

  const FormulirScreen({
    super.key,
    required this.token,
  });

  @override
  State<FormulirScreen> createState() => _FormulirScreenState();
}

class _FormulirScreenState extends State<FormulirScreen> {
  final nisnController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final alamatController = TextEditingController();
  final sekolahController = TextEditingController();

  DateTime? tanggalLahir;
  String? jenisKelamin;
  bool isLoading = false;

  Future<void> pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (tanggal != null) {
      setState(() {
        tanggalLahir = tanggal;
      });
    }
  }

  Future<void> kirimPendaftaran() async {
    if (nisnController.text.isEmpty ||
        tempatLahirController.text.isEmpty ||
        tanggalLahir == null ||
        jenisKelamin == null ||
        alamatController.text.isEmpty ||
        sekolahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data wajib diisi.')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final tanggal = 
          '${tanggalLahir!.year}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}';

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/pendaftaran'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'nisn': nisnController.text,
          'tempat_lahir': tempatLahirController.text,
          'tanggal_lahir': tanggal,
          'jenis_kelamin': jenisKelamin,
          'alamat': alamatController.text,
          'asal_sekolah': sekolahController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Pendaftaran gagal.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat terhubung ke server.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    nisnController.dispose();
    tempatLahirController.dispose();
    alamatController.dispose();
    sekolahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('Formulir Pendaftaran'),
        backgroundColor: const Color(0xFF2463A6),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Data Calon Siswa',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                buatField('NISN', nisnController),
                buatField('Tempat Lahir', tempatLahirController),

                const SizedBox(height: 15),
                const Text('Tanggal Lahir'),
                const SizedBox(height: 8),

                OutlinedButton(
                  onPressed: pilihTanggal,
                  child: Text(
                    tanggalLahir == null
                        ? 'Pilih Tanggal Lahir'
                        : '${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}',
                  ),
                ),

                const SizedBox(height: 15),
                const Text('Jenis Kelamin'),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: jenisKelamin,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pilih jenis kelamin',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      jenisKelamin = value;
                    });
                  },
                ),

                buatField('Alamat', alamatController, maxLines: 3),
                buatField('Asal Sekolah', sekolahController),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: isLoading ? null : kirimPendaftaran,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2463A6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('KIRIM PENDAFTARAN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buatField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
