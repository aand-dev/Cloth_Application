import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_application/config/app_config.dart';
import 'package:stock_application/services/secure_token_manager.dart';

class AuthService {
  final String _baseUrl = AppConfig.apiBaseUrl;

  // Método para iniciar sesión
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    // Imprime la respuesta del servidor para depuración
    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Analiza la respuesta del servidor
      final responseData = jsonDecode(response.body);

      // Verifica si las claves `accessToken` y `refreshToken` están presentes
      if (responseData.containsKey('accessToken') &&
          responseData.containsKey('refreshToken')) {
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];

        // Guarda los tokens de forma segura
        await SecureTokenManager.saveAccessToken(accessToken);
        await SecureTokenManager.saveRefreshToken(refreshToken);

        return null; // Login exitoso
      } else {
        // Maneja el caso donde faltan las claves
        return {
          'general': [
            'La respuesta del servidor no contiene los tokens necesarios.'
          ]
        };
      }
    } else if (response.statusCode == 400) {
      // Maneja errores de validación
      final errorData = jsonDecode(response.body);
      if (errorData['errors'] != null) {
        return errorData['errors'];
      }
    } else if (response.statusCode == 401) {
      // Maneja error de autenticación
      final errorData = jsonDecode(response.body);
      return {
        'general': [errorData['message'] ?? 'Credenciales incorrectas.']
      };
    }

    // Código no manejado explícitamente
    return {
      'general': ['Ocurrió un error inesperado. Inténtelo de nuevo.']
    };
  }

  // Método para registrar un nuevo usuario
  Future<Map<String, List<String>>?> register(
      String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/Auth/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return null; // Indica un registro exitoso
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      if (errorData['errors'] != null) {
        final Map<String, List<String>> formattedErrors = {};
        errorData['errors'].forEach((key, value) {
          formattedErrors[key] = List<String>.from(value);
        });
        return formattedErrors;
      }
    }

    return {
      'general': ['No se pudo registrar el usuario. Inténtelo de nuevo.']
    }; // Mensaje genérico de error
  }

  // Método para renovar el Access Token
  Future<bool> refreshAccessToken() async {
    final refreshToken = await SecureTokenManager.getRefreshToken();

    if (refreshToken == null) {
      return false; // No hay refresh token disponible
    }

    final url = Uri.parse('$_baseUrl/auth/refresh-token');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newAccessToken = responseData['AccessToken'];
      final newRefreshToken = responseData['RefreshToken'];

      if (newAccessToken != null && newRefreshToken != null) {
        await SecureTokenManager.saveAccessToken(newAccessToken);
        await SecureTokenManager.saveRefreshToken(newRefreshToken);
        return true;
      }
    }

    return false; // No se pudo renovar el token
  }

  // Método para manejar solicitudes protegidas
  Future<http.Response> protectedRequest(String endpoint,
      {String method = 'GET', Map<String, dynamic>? body}) async {
    var accessToken = await SecureTokenManager.getAccessToken();

    // Intenta renovar el token si no está disponible
    if (accessToken == null) {
      final refreshed = await refreshAccessToken();
      if (!refreshed) {
        throw Exception('No se pudo autenticar. Inicie sesión nuevamente.');
      }
      accessToken = await SecureTokenManager.getAccessToken();
    }

    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    if (method == 'POST') {
      return await http.post(url, headers: headers, body: jsonEncode(body));
    } else {
      return await http.get(url, headers: headers);
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    final refreshToken = await SecureTokenManager.getRefreshToken();
    if (refreshToken != null) {
      final url = Uri.parse('$_baseUrl/auth/logout');
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    }

    // Eliminar tokens locales
    await SecureTokenManager.removeAccessToken();
    await SecureTokenManager.removeRefreshToken();
    await SecureTokenManager.removeUserId();
  }
}
