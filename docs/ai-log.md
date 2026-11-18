# Log bantuan AI - Tugas 7

Tanggal: 18 November 2026 (Asia/Jakarta). Tool: OpenAI Codex.

## Prompt pengguna

1. Pengguna memberikan PDF tugas dan meminta:
   > kerjakan tugasini, jika tugasnya cukup kompleks pecah menjadi beberapa commit
2. Codex meminta NPM, nama lengkap, dan kelas PBP. Pengguna menjawab:
   > npm 2506585800
   > muhammad rifky padjri
   > kelas B

## Strategi dan cakupan bantuan

- Membaca spesifikasi dan memeriksa implementasi Tutorial 08.
- Meminta identitas yang belum tersedia, lalu mengganti data contoh.
- Menambahkan warna pada model tombol serta layout adaptif yang dapat digulir.
- Memperbarui judul aplikasi dan tes semua tombol serta layar kecil.
- Menyusun enam jawaban reflektif dengan rujukan dokumentasi resmi Flutter.
- Menjalankan formatter, analyzer, dan tes serta memisahkan commit aplikasi dan dokumentasi.

## Validasi dan keterbatasan

`flutter analyze`: No issues found. `flutter test`: 2 tes lulus.
Tes memeriksa identitas, warna unik, SnackBar ketiga tombol, serta layar
320 x 568 dengan teks diperbesar dua kali.

Pemilik memberikan proyek awal, spesifikasi, dan identitas. Kode serta draf
dokumentasi sesi ini dibantu AI. Belum ada tinjauan atau perbaikan kode manual
oleh pemilik yang dapat diklaim. Tes tidak membuktikan seluruh perangkat nyata
sudah diperiksa. AI tidak memverifikasi status Tutorial 08 di SCELE dan tidak
menjamin penerimaan tugas setelah tenggat. Pemilik perlu memahami jawaban serta
memeriksa hasil sebelum pengumpulan.
