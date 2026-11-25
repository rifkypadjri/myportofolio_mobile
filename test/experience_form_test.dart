import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

Future<void> enterField(WidgetTester tester, String label, String value) async {
  final field = find.widgetWithText(TextFormField, label).first;
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

/// Membuka date picker untuk [label], memilih [day] pada bulan yang tampil.
Future<void> pickDate(WidgetTester tester, String label, int day) async {
  final field = find.text(label);
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text('$day').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> save(WidgetTester tester) async {
  tester.testTextInput.hide();
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Simpan'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Simpan'));
  await tester.pumpAndSettle();
}

Future<void> fillValidForm(WidgetTester tester) async {
  await enterField(tester, 'Posisi', ' Backend Developer ');
  await enterField(tester, 'Perusahaan / Organisasi', 'Fasilkom UI');
  await pickDate(tester, 'Tanggal Mulai', 5);
  await pickDate(tester, 'Tanggal Selesai', 20);
  await enterField(tester, 'Deskripsi Pengalaman', 'Membangun REST API');
}

void main() {
  WidgetController.hitTestWarningShouldBeFatal = true;

  testWidgets('Experience form opens from the home action card and pops back', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.ensureVisible(find.text('Tambah Pengalaman'));
    await tester.tap(find.text('Tambah Pengalaman'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Experience form opens from drawer and Home returns to menu', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);

    // Drawer yang sama tersedia di halaman formulir.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ExperienceFormPage), findsNothing);
  });

  testWidgets('Empty and whitespace-only input shows errors, no dialog', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWithProviders(const ExperienceFormPage()));
    await save(tester);
    expect(find.text('Posisi tidak boleh kosong!'), findsOneWidget);
    expect(
      find.text('Perusahaan / Organisasi tidak boleh kosong!'),
      findsOneWidget,
    );
    expect(find.text('Tanggal mulai harus dipilih!'), findsOneWidget);
    expect(find.text('Tanggal selesai harus dipilih!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await enterField(tester, 'Posisi', '    ');
    await save(tester);
    expect(find.text('Posisi tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Too long text is rejected', (tester) async {
    await tester.pumpWidget(wrapWithProviders(const ExperienceFormPage()));
    await enterField(tester, 'Posisi', 'A' * 61);
    await enterField(tester, 'Deskripsi Pengalaman', 'B' * 301);
    await save(tester);
    expect(find.text('Posisi maksimal 60 karakter!'), findsOneWidget);
    expect(find.text('Deskripsi maksimal 300 karakter!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('End date before start date is rejected', (tester) async {
    await tester.pumpWidget(wrapWithProviders(const ExperienceFormPage()));
    await fillValidForm(tester);
    // Mulai tanggal 5; pilih selesai tanggal 2 pada bulan yang sama.
    await pickDate(tester, 'Tanggal Selesai', 2);
    await save(tester);
    expect(
      find.text('Tanggal selesai tidak boleh sebelum tanggal mulai!'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Valid input shows summary dialog; Tutup closes and resets', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWithProviders(const ExperienceFormPage()));
    await fillValidForm(tester);
    await save(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    for (final text in [
      'Posisi: Backend Developer',
      'Organisasi: Fasilkom UI',
      'Tipe: Full-time',
      'Deskripsi: Membangun REST API',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    expect(find.textContaining('Mulai: 05/'), findsOneWidget);
    expect(find.textContaining('Selesai: 20/'), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    expect(find.text('Pilih tanggal'), findsNWidgets(2));
    for (final input in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(input.controller.text, isEmpty);
    }
  });

  testWidgets('Small screen keeps Simpan reachable with keyboard inset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(wrapWithProviders(const ExperienceFormPage()));
    await save(tester);
    expect(find.text('Posisi tidak boleh kosong!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
