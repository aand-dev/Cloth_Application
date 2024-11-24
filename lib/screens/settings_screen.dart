import 'package:flutter/material.dart';
import 'package:stock_application/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sección de Configuración
          ListTile(
            leading: const Icon(Icons.subscriptions),
            title: const Text('Suscripción'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Implementar funcionalidad
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Editar', style: TextStyle(color: Colors.grey)),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap: () {
              // Implementar funcionalidad
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Configurar', style: TextStyle(color: Colors.grey)),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap: () {
              // Implementar funcionalidad
            },
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: const Text('Soporte'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Acceder', style: TextStyle(color: Colors.grey)),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            onTap: () {
              // Implementar funcionalidad
            },
          ),
          const Divider(),
          // Sección General
          ListTile(
            leading: const Icon(Icons.format_paint),
            title: const Text('Tema'),
            onTap: () {
              // Implementar funcionalidad
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacidad'),
            onTap: () {
              // Implementar funcionalidad
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            onTap: () {
              // Implementar funcionalidad
            },
          ),
          const Divider(),
          Spacer(),
          // Versión de la aplicación
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Versión de la aplicación: 1.0.0',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 8),

          // Botón de Cerrar Sesión
          ElevatedButton(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.red),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Cerrar Sesión',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
