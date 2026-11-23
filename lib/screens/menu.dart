import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506585800";
  final String nama = "Muhammad Rifky Padjri";
  final String kelas = "PBP B";

  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Proyek", Icons.folder, const Color(0xFF1565C0)),
    ItemHomepage("Tambah Proyek", Icons.add_circle, const Color(0xFF2E7D32)),
    ItemHomepage("Tambah Pengalaman", Icons.work, const Color(0xFF6A1B9A)),
    ItemHomepage("Logout", Icons.logout, const Color(0xFFC62828)),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      drawer: const LeftDrawer(),
      // AppBar menampilkan bar bagian atas halaman aplikasi.
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Body halaman utama dengan padding di sekelilingnya.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Kartu identitas menyesuaikan lebar layar.
              LayoutBuilder(
                builder: (context, constraints) {
                  final cards = [
                    InfoCard(title: 'NPM', content: npm),
                    InfoCard(title: 'Name', content: nama),
                    InfoCard(title: 'Class', content: kelas),
                  ];
                  // Susun vertikal di ponsel agar nama lengkap tetap terbaca.
                  if (constraints.maxWidth < 600) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: cards,
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cards
                        .map((card) => Expanded(child: card))
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 16.0),

              // Bagian tengah: pesan sambutan dan kisi tombol menu portofolio.
              Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Selamat datang di MyPortfolio Mobile!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),

                    // Kurangi kolom saat layar sempit atau teks diperbesar.
                    LayoutBuilder(
                      builder: (context, constraints) => GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount:
                            constraints.maxWidth <
                                360 *
                                    MediaQuery.textScalerOf(context).scale(14) /
                                    14
                            ? 1
                            : 3,
                        // Tinggi kartu tumbuh bersama skala teks agar label panjang
                        // seperti Tambah Pengalaman tidak overflow.
                        mainAxisExtent:
                            100 +
                            44 *
                                MediaQuery.textScalerOf(context).scale(14) /
                                14,
                        // shrinkWrap agar ukuran kisi menyesuaikan tinggi konten anak.
                        shrinkWrap: true,
                        children: items.map((ItemHomepage item) {
                          return ItemCard(item);
                        }).toList(),
                      ),
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
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
