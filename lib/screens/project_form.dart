import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Formulir menambah proyek; field mengikuti `ProjectSerializer` backend.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _thumbnail = '';
  bool _isSubmitting = false;

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  String? _validateUrl(String? value, {required bool required}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return required ? 'URL tidak boleh kosong!' : null;
    final uri = Uri.tryParse(text);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : 'Format URL tidak valid (gunakan http/https).';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final apiClient = context.read<ApiClient>();
    final authState = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isSubmitting = true;
    });
    try {
      if (!await ensureLoggedIn(context)) return;
      if (!mounted) return;

      final newProject = Project(
        title: _title.trim(),
        description: _description.trim(),
        thumbnail: _thumbnail.trim(),
      );

      Project created;
      try {
        created = await apiClient.createProject(
          newProject,
          token: authState.token!,
        );
      } on ApiException catch (error) {
        if (!mounted) return;
        if (error.statusCode == 401) {
          // Token ditolak server: akhiri sesi lalu minta login ulang.
          await authState.logout();
          if (!mounted) return;
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Sesi berakhir (401). Silakan login kembali.'),
            ),
          );
          await ensureLoggedIn(context);
        } else if (error.statusCode == 403) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                'Hanya pemilik portofolio yang dapat menambah proyek (403).',
              ),
            ),
          );
        } else {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan proyek (${error.statusCode}).'),
            ),
          );
        }
        return;
      } catch (_) {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(content: Text('Tidak dapat terhubung ke server.')),
        );
        return;
      }
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Judul: ${created.title}'),
                Text('Deskripsi: ${created.description}'),
                Text('Thumbnail: ${created.thumbnail}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      // Reset tampilan dan data bersama agar isian lama tidak masuk submit berikutnya.
      _formKey.currentState!.reset();
      setState(() {
        _title = '';
        _description = '';
        _thumbnail = '';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
                    decoration: _decoration('Title', hint: 'Title'),
                    onChanged: (value) => _title = value,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Title tidak boleh kosong!'
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: _decoration('Description'),
                    onChanged: (value) => _description = value,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Description tidak boleh kosong!'
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    keyboardType: TextInputType.url,
                    decoration: _decoration(
                      'Thumbnail URL (Optional)',
                      hint: 'https://example.com/image.png',
                    ),
                    onChanged: (value) => _thumbnail = value,
                    validator: (value) => _validateUrl(value, required: false),
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
                      onPressed: _isSubmitting ? null : _submit,
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
