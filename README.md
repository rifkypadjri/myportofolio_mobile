# MyPortfolio Mobile

Aplikasi portofolio pribadi berbasis Flutter untuk mata kuliah Pemrograman
Berbasis Platform, melanjutkan proyek Tutorial 08.

| Identitas | Data |
| --- | --- |
| Nama | Muhammad Rifky Padjri |
| NPM | 2506585800 |
| Kelas | PBP B |

## Setup

Siapkan Flutter SDK dengan Dart yang memenuhi `^3.13.7` sesuai `pubspec.yaml`,
Git, serta emulator, perangkat fisik, atau browser yang didukung.

```sh
git clone https://github.com/rifkypadjri/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter devices
flutter run
```

Pilih perangkat saat diminta atau gunakan `flutter run -d <device-id>`.
Untuk memeriksa kode dan menjalankan tes:

```sh
flutter analyze
flutter test
```

## Progres mingguan

- **Tutorial 08:** inisialisasi proyek, pemisahan main.dart dan menu.dart,
  MyHomePage stateless, InfoCard, ItemCard, dan SnackBar.
- **Tugas 7:** identitas pribadi; warna unik melalui `ItemHomepage.color`;
  layout adaptif yang dapat digulir; pengujian interaksi dan layar kecil;
  jawaban reflektif dan dokumentasi bantuan AI.

Tiga kartu profil menampilkan NPM, nama lengkap, dan kelas. Tombol **Lihat Proyek**,
**Tambah Proyek**, dan **Logout** berwarna biru, hijau, dan merah. Setiap tombol
menampilkan `Kamu telah menekan tombol [Nama Tombol]!`. Pada tahap ini, aksi
berupa demonstrasi SnackBar; penyimpanan proyek dan autentikasi belum dibuat.
Kartu profil disusun vertikal pada layar sempit agar nama lengkap tetap terbaca.

| Berkas | Tanggung jawab |
| --- | --- |
| `lib/main.dart` | Entry point, MaterialApp, dan tema |
| `lib/menu.dart` | MyHomePage, InfoCard, ItemHomepage, dan ItemCard |
| `test/widget_test.dart` | Identitas, warna unik, ketiga SnackBar, dan layar kecil dengan teks besar |
| `docs/ai-log.md` | Prompt dan cakupan bantuan AI |

Validasi sesi pengerjaan: `flutter analyze` menghasilkan **No issues found**;
`flutter test` meluluskan **2 tes widget**.

### Tugas 7

1. **Widget tree dan hubungan parent-child**

   Widget tree adalah susunan hierarkis widget yang mendeskripsikan antarmuka.
   Parent membungkus atau menyusun child melalui properti `child` atau `children`.
   Contoh proyek ini: `MyApp → MaterialApp → MyHomePage → Scaffold`, dengan body
   `SafeArea → SingleChildScrollView → Column`. Parent memberikan batas ukuran,
   child memilih ukuran sesuai batas itu, lalu parent menempatkannya. Flutter
   membangun ulang bagian yang diperlukan saat konfigurasi berubah. Widget
   merupakan konfigurasi immutable; Element mempertahankan posisi dan siklus
   hidup dalam tree. Referensi: [UI Flutter](https://docs.flutter.dev/ui).

2. **Widget yang digunakan dan fungsinya**

   Berikut seluruh jenis widget yang digunakan langsung dalam kode aplikasi:

   | Widget | Fungsi |
   | --- | --- |
   | `MyApp` | Widget kustom yang menyiapkan MaterialApp |
   | `MaterialApp` | Konfigurasi aplikasi Material, tema, dan halaman awal |
   | `MyHomePage` | Menyusun halaman profil dan menu |
   | `Scaffold` | Kerangka halaman dengan AppBar dan body |
   | `AppBar` | Menampilkan judul di bagian atas |
   | `SafeArea` | Menghindarkan body dari area sistem seperti notch |
   | `SingleChildScrollView` | Membuat halaman dapat digulir |
   | `Column` | Menyusun anak secara vertikal |
   | `Row` | Menyusun kartu profil horizontal pada layar lebar |
   | `LayoutBuilder` | Memilih susunan berdasarkan batas lebar parent |
   | `Expanded` | Membagi lebar Row secara merata |
   | `InfoCard` | Komponen label dan nilai identitas |
   | `Card` | Permukaan kartu informasi |
   | `Padding` | Memberikan ruang di sekeliling isi |
   | `Text` | Menampilkan judul, identitas, label, dan pesan |
   | `SizedBox` | Memberikan jarak tetap antarbagian |
   | `Center` | Memusatkan isi |
   | `GridView` | Menyusun kartu aksi dalam kisi adaptif |
   | `ItemCard` | Komponen tombol dengan ikon dan teks |
   | `Material` | Memberikan warna dan permukaan untuk efek tinta |
   | `InkWell` | Mendeteksi tap dan menampilkan efek tinta |
   | `Container` | Membungkus isi tombol dengan padding |
   | `Icon` | Simbol folder, tambah, dan logout |
   | `SnackBar` | Umpan balik sementara setelah tap |

   `StatelessWidget` adalah kelas dasar widget kustom tersebut. `ItemHomepage`,
   `ThemeData`, `ColorScheme`, `TextStyle`, dan `BuildContext` bukan widget.
   `ScaffoldMessenger.of(context)` mengambil pengelola SnackBar dari ancestor.
   Dalam kode tes, `MediaQuery` juga digunakan untuk memperbesar skala teks.

3. **Fungsi MaterialApp**

   `MaterialApp` menyiapkan aplikasi Material, termasuk tema, navigasi, halaman
   awal, dan dukungan lokalisasi. Pada proyek ini, `title` menentukan judul,
   `theme` mengatur warna, dan `home` menunjuk MyHomePage. Widget ini lazim dipasang
   dekat root agar konfigurasi bersama tersedia bagi halaman di bawahnya. Root
   kustom kita adalah MyApp yang mengembalikan MaterialApp. Referensi:
   [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html).

4. **StatelessWidget dan StatefulWidget**

   `StatelessWidget` tidak mempunyai objek State untuk perubahan lokal. Tampilan
   berasal dari konfigurasi dan data ancestor; widget ini tetap bisa dibangun
   ulang ketika parent atau dependensinya berubah. Gunakan untuk kartu informasi
   dan tampilan dengan data tetap.

   `StatefulWidget` memiliki objek State terpisah yang bertahan selama widget
   terpasang pada posisi yang sesuai. `setState` menandai perubahan dan
   menjadwalkan pembangunan ulang. Gunakan untuk formulir, penghitung, atau status
   pemuatan yang berubah. MyHomePage tetap stateless karena tap hanya meminta
   ScaffoldMessenger menampilkan SnackBar tanpa mengubah data lokal halaman.
   Referensi: [state dan widget Flutter](https://docs.flutter.dev/ui).

5. **BuildContext dan penggunaannya dalam build**

   `BuildContext` adalah handle lokasi widget dalam tree. Parameter `context`
   dalam `build` memungkinkan pencarian data atau layanan ancestor.
   `Theme.of(context)` mengambil tema terdekat dan
   `ScaffoldMessenger.of(context)` mengambil pengelola SnackBar. Lokasi context
   menentukan ancestor yang ditemukan: context parent belum berada di bawah
   widget baru yang dikembalikan metode build itu sendiri. Karena itu context
   harus berasal dari lokasi di bawah penyedia layanan yang dibutuhkan.
   Referensi: [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).

6. **Hot reload, hot restart, dan full restart**

   Hot reload memasukkan perubahan kode ke aplikasi debug dan membangun ulang
   widget sambil mempertahankan state. Cocok untuk perubahan teks, warna, dan
   susunan UI; `main()` serta `initState()` tidak dijalankan ulang.

   Hot restart memulai ulang aplikasi Dart dan menghapus state sehingga
   inisialisasi berjalan kembali. Gunakan jika perubahan pada `main()` atau
   inisialisasi state belum terlihat, atau perubahan struktur tipe tertentu tidak
   didukung hot reload. Full restart menghentikan dan menjalankan aplikasi
   kembali, termasuk membangun ulang bagian native. Perubahan kode
   Kotlin/Java/Swift/Objective-C atau konfigurasi plugin native memerlukannya.
   Referensi: [hot reload Flutter](https://docs.flutter.dev/tools/hot-reload).

## Penggunaan AI

OpenAI Codex membantu membaca spesifikasi, mengubah kode, menulis tes, menyusun
README, dan menjalankan pemeriksaan. Strategi prompt: memberikan PDF dan proyek
awal, meminta implementasi dengan commit bertahap, lalu mengonfirmasi identitas.
Prompt serta cakupan bantuan dicatat pada [log AI](docs/ai-log.md).

AI tidak dapat membuktikan penyelesaian Tutorial 08 di SCELE atau ketepatan
identitas tanpa masukan pemilik. Identitas sudah diberikan pemilik. Tes dan
analyzer memeriksa aspek teknis, tetapi tampilan di perangkat nyata serta
pemahaman jawaban reflektif masih perlu diperiksa pemilik. Tidak ada perbaikan
kode manual oleh pemilik yang diklaim dalam sesi ini.

## Pengumpulan

Setelah commit tersedia di remote, kumpulkan tautan dengan pola
`https://github.com/rifkypadjri/myportofolio_mobile/commit/<hash>`.
Pastikan repositori publik dan Tutorial 08 telah dikumpulkan.
PDF menetapkan tenggat **16 November 2026 pukul 23.59 WIB**; sesi pengerjaan ini
berlangsung pada **18 November 2026**, sehingga sudah melewati tenggat.
Penerimaan terlambat perlu dikonfirmasi kepada pengampu.
