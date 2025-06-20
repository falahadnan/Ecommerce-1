import 'package:dio/dio.dart';

Future<void> updateUserLanguage(String language) async {
  await Dio().post(
    'https://tonapi.com/api/langues',
    data: {'language': language},
  );
}
