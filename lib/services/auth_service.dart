import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://ai.aykacare.in/api/v1';

  Future<String?> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/login');

    final request = http.MultipartRequest('POST', uri);
    request.fields['email'] = email;
    request.fields['password'] = password;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    }

    return null;
  }

  Future<String?> register(String name, String email, String password) async {
    final uri = Uri.parse('$baseUrl/register');

    final request = http.MultipartRequest('POST', uri);
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    }

    return null;
  }
}
