import 'package:dio/dio.dart';

Future<void> updateUserLanguage(String language) async {
  await Dio().post(
    'https://test666.skaidev.com/api/langues',
    data: {'language': language},
  );
}
