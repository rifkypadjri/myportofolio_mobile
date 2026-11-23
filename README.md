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
- **Tutorial 09:** drawer Home/Add Project, form proyek dengan validasi,
  dialog ringkasan, reset input, navigasi push/pushReplacement, migrasi
  `material_ui`, dan pemisahan folder screens/widgets.
  Lihat [catatan Tutorial 09](docs/tutorial-09.md).

Tiga kartu profil menampilkan NPM, nama lengkap, dan kelas. Tombol **Lihat Proyek**,
**Tambah Proyek**, dan **Logout** berwarna biru, hijau, dan merah. Setiap tombol
menampilkan `Kamu telah menekan tombol [Nama Tombol]!`. Tombol Tambah Proyek
juga membuka form proyek. Penyimpanan proyek dan autentikasi belum dibuat.
Kartu profil disusun vertikal pada layar sempit agar nama lengkap tetap terbaca.

| Berkas | Tanggung jawab |
| --- | --- |
| `lib/main.dart` | Entry point, MaterialApp, dan tema |
| `lib/screens/menu.dart` | MyHomePage dan InfoCard |
| `lib/screens/project_form.dart` | Form proyek, validasi, dialog, dan reset input |
| `lib/widgets/project_card.dart` | ItemHomepage dan ItemCard dengan navigasi |
| `lib/widgets/left_drawer.dart` | Drawer navigasi Home dan Add Project |
| `test/widget_test.dart` | Identitas, warna unik, ketiga SnackBar, dan layar kecil dengan teks besar |
| `test/project_form_test.dart` | Navigasi drawer, validasi, dialog data, reset, dan form layar kecil |
| `docs/ai-log.md` | Prompt dan cakupan bantuan AI |

Validasi sesi Tugas 7: `flutter analyze` menghasilkan **No issues found**;
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

### Tugas 8

1. **Navigator.push(), pushReplacement(), dan pop()**

   `Navigator.push()` menambahkan route baru di atas stack tanpa membuang route
   sebelumnya, sehingga halaman lama tetap hidup di bawahnya dan tombol kembali
   muncul. `Navigator.pushReplacement()` mengganti route teratas dengan route
   baru; route lama dibuang, jadi tidak ada tombol kembali ke halaman itu.
   `Navigator.pop()` mengeluarkan route teratas dan kembali ke route di bawahnya
   (juga dipakai untuk menutup dialog dan drawer).

   Formulir dari kartu aksi **Tambah Pengalaman** dibuka dengan `Navigator.push()`
   (`lib/widgets/project_card.dart`), sehingga tombol kembali bawaan perangkat
   mengembalikan pengguna ke halaman utama. Opsi **Home** di drawer
   (`lib/widgets/left_drawer.dart`) lebih dulu memanggil `pop()` untuk menutup
   drawer, lalu `pushReplacement()` ke `MyHomePage`. Halaman formulir diganti
   halaman utama sehingga stack tidak menumpuk (formulir -> menu -> formulir ...).

2. **Scaffold, AppBar, dan Drawer untuk konsistensi**

   `Scaffold` menjadi kerangka tetap tiap halaman: slot `appBar`, `drawer`, dan
   `body`. Halaman utama, formulir proyek, dan formulir pengalaman semuanya
   memakai susunan ini, dan memakai widget `LeftDrawer` yang sama, sehingga
   navigasi selalu ada di tempat yang sama dan hanya isi `body` yang berbeda.
   Satu perubahan di `LeftDrawer` (misalnya opsi Add Experience) langsung
   muncul di semua halaman.

   Contoh warna tema: `Theme.of(context).colorScheme.primary` (indigo dari
   `ColorScheme.fromSeed` di `main.dart`) dipakai sebagai warna `AppBar` di
   halaman utama, formulir proyek, dan formulir pengalaman, juga sebagai latar
   `DrawerHeader` dan tombol Simpan. Karena diambil dari tema, mengganti seed
   color sekali mengubah semua halaman.

3. **Tata letak formulir**

   Formulir disusun sebagai `Column` berisi field yang dibungkus `Padding`,
   di dalam `SingleChildScrollView`, `Form`, dan `SafeArea`. Satu kolom vertikal
   cocok untuk layar ponsel dan membuat urutan pengisian jelas. `Padding`
   (dan `SizedBox`) memberi jarak antarfield agar tidak berdempetan dan mudah
   disentuh. `SingleChildScrollView` penting ketika ruang terbatas: tanpa itu
   `Column` yang lebih tinggi dari layar, terlebih saat papan ketik muncul,
   akan overflow dan tombol Simpan tak terjangkau. Dengan scroll, semua field
   dan tombol tetap bisa dicapai (`keyboardDismissBehavior` juga menutup papan
   ketik saat digulir). `SafeArea` menghindarkan isi dari notch dan bilah sistem.

4. **GlobalKey<FormState>, validator, dan validate()**

   `GlobalKey<FormState>` adalah pegangan ke `FormState` milik widget `Form`,
   sehingga tombol Simpan, yang berada di luar field, dapat mengakses form.
   `validator` pada tiap `TextFormField`/`FormField` adalah fungsi yang
   menerima nilai dan mengembalikan pesan galat (string) bila tidak valid atau
   `null` bila valid. Saat Simpan ditekan, `_formKey.currentState!.validate()`
   menjalankan semua validator, menampilkan pesan galat pada field yang
   bermasalah, dan mengembalikan `false` jika ada yang gagal; dialog hanya
   dibuka ketika hasilnya `true`. `reset()` dipakai untuk mengosongkan form
   setelah dialog ditutup.

   Contoh nilai yang ditolak: Posisi berisi `"    "` (hanya spasi) ditolak
   dengan pesan "Posisi tidak boleh kosong!" karena validator memakai `trim()`.
   Contoh lain: Tanggal Selesai 2 sebelum Tanggal Mulai 5 ditolak. Memilih
   jenis input atau papan ketik saja tidak cukup karena itu hanya mengatur
   tampilan dan kemudahan mengetik, bukan aturan data: pengguna tetap bisa
   mengosongkan field, mengetik spasi, menempel teks yang terlalu panjang, atau
   memilih tanggal akhir yang lebih awal dari tanggal mulai. Aturan semacam itu
   hanya bisa ditegakkan oleh validator.

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

### Penggunaan AI pada Tugas 8


**Tools:** Claude Code (model Claude Sonnet 5.5) di ekstensi VS Code.

**Bagian yang dibantu AI:**
- Membaca PDF dan kode yang ada, lalu merancang formulir Pengalaman
  (`lib/screens/experience_form.dart`) dan widget input tanggal
  (`lib/widgets/date_form_field.dart`).
- Menambahkan kartu aksi, opsi drawer, dan penyesuaian tinggi kartu.
- Menulis tes (`test/experience_form_test.dart` dan pembaruan
  `test/widget_test.dart`), menjalankan `flutter analyze` dan `flutter test`.
- Memecah pekerjaan menjadi commit kecil, melakukan push, dan menyusun draf
  jawaban refleksi pada bagian Tugas 8.

**Keterbatasan dan koreksi:**
- Setelah kartu keempat ditambahkan, tes menunjukkan layout overflow pada layar
  kecil dengan teks diperbesar; AI memperbaikinya dengan membuat tinggi kartu
  mengikuti skala teks.
- Tes otomatis tidak menggantikan uji di perangkat nyata atau Chrome; AI tidak
  menjalankan aplikasi secara visual. Tes tanggal bergantung pada bulan
  berjalan.
- Keterbatasan fungsi: galat tanggal selesai tidak diperbarui otomatis ketika
  tanggal mulai diubah, baru dihitung ulang saat Simpan ditekan. Data juga
  belum disimpan, hanya ditampilkan di dialog.
- Jawaban refleksi dibuat AI berdasarkan kode proyek; pemilik perlu memahami
  dan memverifikasinya.