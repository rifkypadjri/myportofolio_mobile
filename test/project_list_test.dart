import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

import 'helpers.dart';

void main() {
  test('Project JSON maps snake_case, null thumbnail, and omits id', () {
    final project = Project.fromJson({
      'id': 'abc',
      'title': 'T',
      'description': 'D',
      'thumbnail': null,
      'star_count': 2,
    });
    expect(project.id, 'abc');
    expect(project.thumbnail, '');
    expect(project.starCount, 2);
    expect(project.toJson(), {
      'title': 'T',
      'description': 'D',
      'thumbnail': '',
    });
  });

  test('ApiClient throws ApiException on non-2xx responses', () {
    final client = buildTestClient((request) => http.Response('nope', 403));
    expect(
      client.getProjects(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'code', 403)),
    );
  });

  test('AuthState logs out locally even when the server rejects it', () async {
    final auth = AuthState(buildTestClient());
    await auth.login('u', 'p');
    expect(auth.isLoggedIn, isTrue);
    await auth.logout();
    expect(auth.isLoggedIn, isFalse);

    final failing = AuthState(
      buildTestClient(
        (r) => r.url.path.endsWith('token/')
            ? http.Response('{"token":"t"}', 200)
            : http.Response('x', 401),
      ),
    );
    await failing.login('u', 'p');
    await failing.logout();
    expect(failing.isLoggedIn, isFalse);
  });

  testWidgets('List shows projects from the API and opens detail', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWithProviders(const ProjectListScreen()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Portfolio Web'), findsOneWidget);
    expect(find.text('Situs portofolio pribadi'), findsOneWidget);

    await tester.tap(find.text('Portfolio Web'));
    await tester.pumpAndSettle();
    expect(find.text('Project Detail'), findsOneWidget);
    expect(find.text('Situs portofolio pribadi'), findsOneWidget);
    // Thumbnail kosong: tidak ada widget gambar.
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('Errors are handled and Retry reloads into the empty state', (
    tester,
  ) async {
    var fail = true;
    final client = buildTestClient((request) {
      if (fail) return http.Response('err', 500);
      return http.Response('[]', 200);
    });
    await tester.pumpWidget(
      wrapWithProviders(const ProjectListScreen(), apiClient: client),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Failed to load projects'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No projects found.'), findsOneWidget);
  });
}
