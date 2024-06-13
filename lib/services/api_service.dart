import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl = 'https://reqres.in/api';

  Future<List<dynamic>> fetchUsers(int page) async {
    final response =
        await Dio().get('$baseUrl/users', queryParameters: {'page': page});
    return response.data['data'];
  }
}
