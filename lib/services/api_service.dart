import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://fakestoreapi.com';

  // Método GET para obtener datos de la API
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));

    return _processResponse(response);
  }

  // Método POST para enviar datos a la API
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  // Método PUT para actualizar datos en la API
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  // Método DELETE para eliminar datos en la API
  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));

    return _processResponse(response);
  }

  // Procesa la respuesta y maneja errores comunes
  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la API: ${response.statusCode}');
    }
  }
}
