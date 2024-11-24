import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenManager {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _storage = FlutterSecureStorage();

  // Guardar el token de acceso de forma segura
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Recuperar el token de acceso de forma segura
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Eliminar el token de acceso
  static Future<void> removeAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  // Guardar el refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

// Recuperar el refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

// Eliminar el refresh token
  static Future<void> removeRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // Guardar el ID del usuario de forma segura
  static Future<void> saveUserId(int userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  // Recuperar el ID del usuario de forma segura
  static Future<int?> getUserId() async {
    final userId = await _storage.read(key: _userIdKey);
    return userId != null ? int.tryParse(userId) : null;
  }

  // Eliminar el ID del usuario
  static Future<void> removeUserId() async {
    await _storage.delete(key: _userIdKey);
  }
}
