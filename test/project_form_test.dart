import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

import 'helpers.dart';

Future<void> enterField(WidgetTester tester, String label, String value) async {
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

http.Response failPost(http.Request request, int status) {
  if (request.method == 'POST' && request.url.path == '/api/v1/projects/') {
    return http.Response('error', status);
  }
  return defaultHandler(request);
}

void main() {
  WidgetController.hitTestWarningShouldBeFatal = true;

  testWidgets('Drawer protects Add Project and redirects to login', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    await enterField(tester, 'Username', 'owner');
    await enterField(tester, 'Password', 'pw');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Login'), findsNothing);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Login validates fields and shows status on failure', (
    tester,
  ) async {
    final client = buildTestClient((request) => http.Response('bad', 400));
    await tester.pumpWidget(
      wrapWithProviders(const LoginScreen(), apiClient: client),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Username cannot be empty!'), findsOneWidget);
    expect(find.text('Password cannot be empty!'), findsOneWidget);

    await enterField(tester, 'Username', 'owner');
    await enterField(tester, 'Password', 'wrong');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Login gagal (400)'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Required fields reject empty input and invalid URL', (
    tester,
  ) async {
    final auth = AuthState(buildTestClient());
    await auth.login('owner', 'pw');
    await tester.pumpWidget(
      wrapWithProviders(const ProjectFormPage(), authState: auth),
    );
    await save(tester);
    expect(find.text('Title tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Description tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await enterField(tester, 'Title', 'Proyek');
    await enterField(tester, 'Description', 'Deskripsi');
    await enterField(tester, 'Thumbnail URL (Optional)', 'bukan url');
    await save(tester);
    expect(find.textContaining('Format URL tidak valid'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Submit posts with token and shows confirmation dialog', (
    tester,
  ) async {
    http.Request? posted;
    final client = buildTestClient((request) {
      if (request.method == 'POST' && request.url.path == '/api/v1/projects/') {
        posted = request;
      }
      return defaultHandler(request);
    });
    final auth = AuthState(client);
    await auth.login('owner', 'pw');
    await tester.pumpWidget(
      wrapWithProviders(
        const ProjectFormPage(),
        apiClient: client,
        authState: auth,
      ),
    );
    await enterField(tester, 'Title', ' Portfolio Mobile ');
    await enterField(tester, 'Description', 'Aplikasi portofolio');
    await save(tester);

    expect(posted!.headers['Authorization'], 'Token abc123');
    final body = jsonDecode(posted!.body) as Map<String, dynamic>;
    expect(body['title'], 'Portfolio Mobile');
    expect(body.containsKey('id'), isFalse);
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul: Portfolio Mobile'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    for (final input in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(input.controller.text, isEmpty);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('401 logs out and asks to login again', (tester) async {
    final client = buildTestClient((request) => failPost(request, 401));
    final auth = AuthState(client);
    await auth.login('owner', 'pw');
    await tester.pumpWidget(
      wrapWithProviders(
        const ProjectFormPage(),
        apiClient: client,
        authState: auth,
      ),
    );
    await enterField(tester, 'Title', 'Proyek');
    await enterField(tester, 'Description', 'Deskripsi');
    await save(tester);

    expect(auth.isLoggedIn, isFalse);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Other API errors show a SnackBar', (tester) async {
    final client = buildTestClient((request) => failPost(request, 500));
    final auth = AuthState(client);
    await auth.login('owner', 'pw');
    await tester.pumpWidget(
      wrapWithProviders(
        const ProjectFormPage(),
        apiClient: client,
        authState: auth,
      ),
    );
    await enterField(tester, 'Title', 'Proyek');
    await enterField(tester, 'Description', 'Deskripsi');
    await save(tester);
    expect(find.textContaining('Gagal menyimpan proyek (500)'), findsOneWidget);
    expect(auth.isLoggedIn, isTrue);
  });
}
