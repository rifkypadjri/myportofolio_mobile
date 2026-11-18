import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  static const _defaultCategory = 'Web Development';
  static const _categories = [
    _defaultCategory,
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  String _projectName = '';
  String _description = '';
  String _category = _defaultCategory;
  String _technologies = '';
  String _projectLink = '';

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // Tutorial ini hanya menampilkan input; belum ada penyimpanan ke database.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Proyek: ${_projectName.trim()}'),
              Text('Deskripsi: ${_description.trim()}'),
              Text('Kategori: $_category'),
              Text('Teknologi: ${_technologies.trim()}'),
              Text('Tautan: ${_projectLink.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    // Reset tampilan dan data bersama agar isian lama tidak masuk submit berikutnya.
    _formKey.currentState!.reset();
    setState(() {
      _projectName = '';
      _description = '';
      _category = _defaultCategory;
      _technologies = '';
      _projectLink = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: _decoration('Nama Proyek', hint: 'Nama Proyek'),
                    onChanged: (value) => _projectName = value,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nama proyek tidak boleh kosong!'
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: _decoration('Deskripsi Proyek'),
                    onChanged: (value) => _description = value,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Deskripsi proyek tidak boleh kosong!'
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField<String>(
                    decoration: _decoration('Kategori Proyek'),
                    initialValue: _defaultCategory,
                    isExpanded: true,
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) _category = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: _decoration(
                      'Teknologi yang Digunakan',
                      hint: 'Contoh: Flutter, Django, Figma',
                    ),
                    onChanged: (value) => _technologies = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    keyboardType: TextInputType.url,
                    decoration: _decoration(
                      'Tautan Proyek',
                      hint: 'URL Proyek (opsional)',
                    ),
                    onChanged: (value) => _projectLink = value,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submit,
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
