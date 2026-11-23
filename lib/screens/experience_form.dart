import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Formulir untuk menambahkan satu entri bagian Pengalaman pada portofolio.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  static const _defaultType = 'Full-time';
  static const _types = [
    _defaultType,
    'Part-time',
    'Internship',
    'Freelance',
    'Volunteer',
  ];
  static const _maxTitleLength = 60;
  static const _maxDescriptionLength = 300;

  final _formKey = GlobalKey<FormState>();
  final _positionController = TextEditingController();
  final _organizationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _type = _defaultType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _positionController.dispose();
    _organizationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  /// Menolak nilai kosong, hanya spasi, atau melebihi [maxLength] karakter.
  FormFieldValidator<String> _requiredText(String label, int maxLength) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return '$label tidak boleh kosong!';
      if (text.length > maxLength) {
        return '$label maksimal $maxLength karakter!';
      }
      return null;
    };
  }

  String? _validateStartDate(DateTime? value) =>
      value == null ? 'Tanggal mulai harus dipilih!' : null;

  String? _validateEndDate(DateTime? value) {
    if (value == null) return 'Tanggal selesai harus dipilih!';
    final start = _startDate;
    if (start != null && value.isBefore(start)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // Belum ada penyimpanan data; isian hanya diringkas dalam dialog.
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pengalaman berhasil disimpan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Posisi: ${_positionController.text.trim()}'),
              Text('Organisasi: ${_organizationController.text.trim()}'),
              Text('Tipe: $_type'),
              Text('Mulai: ${formatDate(_startDate!)}'),
              Text('Selesai: ${formatDate(_endDate!)}'),
              Text('Deskripsi: ${_descriptionController.text.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    // reset() mengosongkan semua field; variabel tanggal ikut dibersihkan.
    _formKey.currentState!.reset();
    setState(() {
      _type = _defaultType;
      _startDate = null;
      _endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDate = DateTime(1990);
    final lastDate = DateTime(now.year + 10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Experience Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          // Scroll view menjaga semua field dan tombol terjangkau di layar
          // sempit atau saat papan ketik tampil.
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _positionController,
                    decoration: _decoration(
                      'Posisi',
                      hint: 'Contoh: Backend Developer',
                    ),
                    validator: _requiredText('Posisi', _maxTitleLength),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _organizationController,
                    decoration: _decoration(
                      'Perusahaan / Organisasi',
                      hint: 'Contoh: Fasilkom UI',
                    ),
                    validator: _requiredText(
                      'Perusahaan / Organisasi',
                      _maxTitleLength,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField<String>(
                    decoration: _decoration('Tipe Pengalaman'),
                    initialValue: _defaultType,
                    isExpanded: true,
                    items: _types
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) _type = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DateFormField(
                    label: 'Tanggal Mulai',
                    firstDate: firstDate,
                    lastDate: lastDate,
                    validator: _validateStartDate,
                    onChanged: (date) => _startDate = date,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DateFormField(
                    label: 'Tanggal Selesai',
                    firstDate: firstDate,
                    lastDate: lastDate,
                    validator: _validateEndDate,
                    onChanged: (date) => _endDate = date,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: _decoration(
                      'Deskripsi Pengalaman',
                      hint: 'Maksimal $_maxDescriptionLength karakter',
                    ),
                    validator: _requiredText(
                      'Deskripsi',
                      _maxDescriptionLength,
                    ),
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
                      child: const Text('Simpan'),
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
