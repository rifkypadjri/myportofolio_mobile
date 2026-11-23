import 'package:material_ui/material_ui.dart';

/// Memformat tanggal menjadi dd/MM/yyyy tanpa bergantung pada paket intl.
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

/// Input tanggal yang membuka [showDatePicker] dan ikut dalam [Form].
///
/// Dibangun di atas [FormField] sehingga mendapat validasi, pesan galat, dan
/// `reset()` dari Form yang sama dengan TextFormField.
class DateFormField extends FormField<DateTime> {
  DateFormField({
    super.key,
    required String label,
    required DateTime firstDate,
    required DateTime lastDate,
    super.validator,
    ValueChanged<DateTime>? onChanged,
  }) : super(
         builder: (field) {
           final value = field.value;
           return InkWell(
             borderRadius: BorderRadius.circular(5),
             onTap: () async {
               final picked = await showDatePicker(
                 context: field.context,
                 initialDate: value ?? DateTime.now(),
                 firstDate: firstDate,
                 lastDate: lastDate,
               );
               if (picked == null) return;
               field.didChange(picked);
               onChanged?.call(picked);
             },
             child: InputDecorator(
               decoration: InputDecoration(
                 labelText: label,
                 errorText: field.errorText,
                 suffixIcon: const Icon(Icons.calendar_today),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(5),
                 ),
               ),
               child: Text(value == null ? 'Pilih tanggal' : formatDate(value)),
             ),
           );
         },
       );
}
