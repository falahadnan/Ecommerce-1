import 'package:shop/services/api_client.dart';

Future<void> updateUserLanguage(String language) async {
  final response = await ApiClient.get(
    '/user/update-language',
    body: {'language': language},
  );

  if (response.statusCode != 200) {
    throw Exception('Échec de la mise à jour de la langue');
  }
}
