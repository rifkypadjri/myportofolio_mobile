import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Default fake backend: one project, login succeeds for any credentials.
http.Response defaultHandler(http.Request request) {
  final path = request.url.path;
  if (path == '/api/v1/projects/' && request.method == 'GET') {
    return http.Response(
      jsonEncode([
        {
          'id': '6b1f2d4e-0000-4000-8000-000000000001',
          'title': 'Portfolio Web',
          'description': 'Situs portofolio pribadi',
          'thumbnail': null,
          'star_count': 3,
          'is_starred': false,
          'starred_by_names': '',
        },
      ]),
      200,
    );
  }
  if (path == '/api/v1/projects/' && request.method == 'POST') {
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    return http.Response(
      jsonEncode({'id': 'new-id', ...body, 'star_count': 0}),
      201,
    );
  }
  if (path == '/api/v1/auth/token/') {
    return http.Response(jsonEncode({'token': 'abc123'}), 200);
  }
  if (path == '/api/v1/auth/logout/') return http.Response('', 204);
  return http.Response('not found', 404);
}

ApiClient buildTestClient([http.Response Function(http.Request)? handler]) {
  final fn = handler ?? defaultHandler;
  return ApiClient(
    client: MockClient((request) async => fn(request)),
    baseUrl: 'http://test',
  );
}

Widget buildTestApp({ApiClient? apiClient}) =>
    MyApp(apiClient: apiClient ?? buildTestClient());

/// Wraps [home] with the same providers as [MyApp], for isolated screens.
Widget wrapWithProviders(
  Widget home, {
  ApiClient? apiClient,
  AuthState? authState,
  TransitionBuilder? builder,
}) {
  final client = apiClient ?? buildTestClient();
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: client),
      ChangeNotifierProvider<AuthState>.value(
        value: authState ?? AuthState(client),
      ),
    ],
    child: MaterialApp(builder: builder, home: home),
  );
}
