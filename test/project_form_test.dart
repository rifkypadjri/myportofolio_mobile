import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Future<void> enterField(WidgetTester tester, String label, String value) async {
  // Nama Proyek memiliki label dan hint yang sama; keduanya menunjuk field ini.
  final field = find.widgetWithText(TextFormField, label).first;
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> save(WidgetTester tester) async {
  tester.testTextInput.hide();
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Save'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  WidgetController.hitTestWarningShouldBeFatal = true;
  testWidgets('Drawer replaces routes and closes on both pages', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Required fields reject empty and whitespace-only input', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await enterField(tester, 'Nama Proyek', '   ');
    await enterField(tester, 'Deskripsi Proyek', '   ');
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Dialog shows every input and OK resets fields and category', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await enterField(tester, 'Nama Proyek', ' Portfolio Mobile ');
    await enterField(tester, 'Deskripsi Proyek', 'Aplikasi portofolio pribadi');
    final dropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Data Science').last);
    await tester.pumpAndSettle();
    await enterField(tester, 'Teknologi yang Digunakan', 'Flutter, Django');
    await enterField(tester, 'Tautan Proyek', 'https://example.com/portfolio');
    await save(tester);

    for (final text in [
      'Proyek berhasil ditambahkan!',
      'Nama Proyek: Portfolio Mobile',
      'Deskripsi: Aplikasi portofolio pribadi',
      'Kategori: Data Science',
      'Teknologi: Flutter, Django',
      'Tautan: https://example.com/portfolio',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    for (final input in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(input.controller.text, isEmpty);
    }
    expect(find.text('Web Development'), findsOneWidget);

    // Submit ulang tanpa field opsional memastikan data lama benar-benar dibuang.
    await enterField(tester, 'Nama Proyek', 'Proyek kedua');
    await enterField(tester, 'Deskripsi Proyek', 'Deskripsi kedua');
    await save(tester);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Small-screen form and long dialog can scroll', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await enterField(tester, 'Nama Proyek', 'Proyek layar kecil');
    await enterField(tester, 'Deskripsi Proyek', 'Deskripsi panjang. ' * 80);
    await save(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
