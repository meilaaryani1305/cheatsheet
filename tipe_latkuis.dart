1. Struktur Folder Standar
lib/
├── main.dart
├── models/
│   └── data.dart        # class model + data dummy
└── views/
    ├── login.dart
    ├── home.dart
    └── detail.dart

Aturan import (WAJIB DIINGAT):

File di folder yang sama → langsung nama file: import 'home.dart';
File di folder lain sejajar (misal dari views/ ke models/) → pakai ../: import '../models/data.dart';
Jangan campur package:nama_project/... dengan path relatif 'file.dart' untuk file yang sama — pilih salah satu, sebaiknya relatif saja karena lebih aman dari salah nama package.
2. main.dart — Titik Awal Aplikasi
dart
import 'package:flutter/material.dart';
import 'views/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

Poin penting:

home: menentukan halaman pertama yang muncul.
debugShowCheckedModeBanner: false menghilangkan pita "DEBUG" pojok kanan atas.
3. models/data.dart — Model & Data Dummy
dart
class User {
  final String username;
  final String password;
  User({required this.username, required this.password});
}

// Username = NIM, Password = Nama Prodi
final User user1 = User(
  username: "NIM_KAMU",
  password: "Nama Prodi Kamu",
);

class Animal {
  final String name;
  final String type;
  final double weight;
  final List<String> habitat;
  final double height;
  final List<String> activities;
  final String image;

  Animal({
    required this.name,
    required this.type,
    required this.weight,
    required this.habitat,
    required this.height,
    required this.activities,
    required this.image,
  });
}

final List<Animal> dummyAnimals = [
  Animal(
    name: "Bengal Tiger",
    type: "Mammal",
    weight: 220.5,
    habitat: ["Forest", "Grassland"],
    height: 110,
    activities: ["Hunting", "Roaming"],
    image: "https://...jpg",
  ),
  // ...tambah data lain
];

Poin penting:

Kalau field bisa lebih dari satu (misalnya habitat, activities) → pakai List<String>.
required di constructor artinya field itu wajib diisi saat membuat object.
4. Halaman Login — Pola Wajib
dart
import 'package:flutter/material.dart';
import '../models/data.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username == user1.username && password == user1.password) {
      // BERHASIL -> push replacement ke Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // GAGAL -> snackbar merah
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Login gagal! Username atau password salah."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Login", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextField(controller: usernameController, decoration: const InputDecoration(hintText: "Username")),
                TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(hintText: "Password")),
                ElevatedButton(onPressed: login, child: const Text("Login")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Poin penting yang sering ditanya/dinilai:

Ketentuan	Kode kuncinya
Login berhasil → pindah halaman, tidak bisa back ke login	Navigator.pushReplacement(...)
Login biasa (bisa back)	Navigator.push(...)
Snackbar merah saat gagal	SnackBar(backgroundColor: Colors.red, content: Text(...))
obscureText: true	menyembunyikan teks password (jadi titik-titik)
5. Halaman Home — List/Grid Data
Versi GridView (kotak-kotak, seperti contoh soal)
dart
import 'package:flutter/material.dart';
import '../models/data.dart';
import 'detail.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animals List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // jumlah kolom
        ),
        itemCount: dummyAnimals.length,
        itemBuilder: (context, index) {
          final animal = dummyAnimals[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage(animal: animal)),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Image.network(animal.image, fit: BoxFit.cover),
                  Text(animal.name),
                  Text(animal.type),
                  Wrap(children: animal.habitat.map((h) => Chip(label: Text(h))).toList()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
Versi ListView (menurun ke bawah)
dart
body: ListView.builder(
  itemCount: dummyAnimals.length,
  itemBuilder: (context, index) {
    final animal = dummyAnimals[index];
    return ListTile(
      leading: Image.network(animal.image, width: 50, height: 50),
      title: Text(animal.name),
      subtitle: Text("${animal.type} - ${animal.habitat.join(', ')}"),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(animal: animal)),
        );
      },
    );
  },
)

Poin penting:

Widget	Kegunaan
ListView.builder	daftar menurun (1 kolom), efisien untuk data banyak
GridView.builder	daftar kotak-kotak (multi kolom)
itemCount	jumlah total item dari data
itemBuilder	fungsi yang membangun tampilan tiap item berdasarkan index
GestureDetector / InkWell	bikin widget bisa diklik (dipakai untuk Card)
ListTile	widget siap pakai: leading (kiri), title, subtitle, trailing (kanan)
6. Halaman Detail — Terima Data & Tombol Kembali
dart
import 'package:flutter/material.dart';
import '../models/data.dart';

class DetailPage extends StatelessWidget {
  final Animal animal; // data yang dikirim dari Home

  const DetailPage({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // KEMBALI ke Home
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(animal.image),
            Text("Type: ${animal.type}"),
            Text("Height: ${animal.height} cm"),
            Text("Weight: ${animal.weight} kg"),
            Text("Habitat: ${animal.habitat.join(', ')}"),
            Wrap(children: animal.activities.map((a) => Chip(label: Text(a))).toList()),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Kembali"),
            ),
          ],
        ),
      ),
    );
  }
}

Poin penting:

Kode	Fungsi
required this.animal di constructor	cara terima data kiriman dari halaman lain
Navigator.pop(context)	kembali ke halaman sebelumnya (Home)
SingleChildScrollView	supaya konten bisa di-scroll kalau kepanjangan
List.join(', ')	ubah List<String> jadi satu String dipisah koma
7. Perbedaan Navigasi (SERING KELUAR DI KUIS)
Method	Efek	Kapan dipakai
Navigator.push()	Buka halaman baru, halaman lama masih ada di "tumpukan" (bisa back)	Home → Detail
Navigator.pop()	Kembali ke halaman sebelumnya	Detail → Home (tombol back)
Navigator.pushReplacement()	Buka halaman baru, halaman lama dihapus dari tumpukan (tidak bisa back)	Login → Home (setelah berhasil)
Navigator.pushAndRemoveUntil()	Buka halaman baru, hapus semua halaman di tumpukan sebelumnya	Logout, kembali paksa ke Login
8. Cara Kirim & Terima Data Antar Halaman

Kirim (dari Home ke Detail):

dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailPage(animal: animal)),
);

Terima (di Detail):

dart
class DetailPage extends StatelessWidget {
  final Animal animal;
  const DetailPage({super.key, required this.animal});
  // animal bisa dipakai di seluruh class ini
}
9. Checklist Sebelum Kumpul
 Login pakai NIM (username) dan Nama Prodi (password) — cek ejaan & spasi persis
 Login berhasil → pushReplacement ke Home
 Login gagal → snackbar merah
 Home pakai ListView.builder atau GridView.builder
 Home tampilkan: foto, nama, tipe, habitat
 Klik item di Home → pindah ke Detail (bawa data lewat constructor)
 Detail tampilkan semua data (termasuk field yang tidak muncul di Home)
 Ada tombol/ikon untuk kembali ke Home di halaman Detail
 Struktur folder rapi (models/, views/)
 Semua import sudah benar (tidak ada folder yang salah/typo)
 Jalankan flutter run dan pastikan tidak ada error merah di terminal sebelum submit
 Screenshot hasil aplikasi + link GitHub → gabungkan jadi PDF (LATKUIS_NIM.pdf)
10. Error yang Paling Sering Terjadi
Pesan Error	Penyebab	Solusi
Error when reading 'lib/xxx.dart': system cannot find the path	Import salah folder/nama file	Cek dir isi folder, samakan nama file dengan import
Not a constant expression	Biasanya efek lanjutan dari error import di atas	Perbaiki dulu error import-nya
The method 'X' isn't defined	Nama class/variabel di import beda dengan yang dipakai	Cek nama class persis sama (huruf besar/kecil ikut dihitung)
Snackbar merah terus padahal yakin benar	Ada spasi tersembunyi, huruf besar/kecil beda	Gunakan .trim(), cek validUsername/validPassword persis
Tampilan tidak berubah setelah edit	Belum di-save, atau cuma hot reload padahal butuh restart	Ctrl+S dulu, lalu tekan R (huruf besar) di terminal untuk hot restart