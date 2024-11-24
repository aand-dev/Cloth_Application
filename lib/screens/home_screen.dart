import 'package:flutter/material.dart';
import 'package:stock_application/screens/inventory_screen.dart';
import 'home_content_screen.dart'; // Importa el contenido principal del Home
import 'settings_screen.dart'; // Pantalla de Configuración

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Índice del BottomNavigationBar

  // Lista de pantallas para navegar
  final List<Widget> _screens = [
    HomeContentScreen(), // Contenido principal del Home
    InventoryScreen(), // Pantalla de Inventario
    Text('2'), // Pantalla de Ventas
    Text('3'), // Pantalla de Clientes
    SettingsScreen(), // Pantalla de Configuración
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Actualiza el índice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Cambia la pantalla según el índice
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Ventas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        selectedItemColor: Color(0xFF265DD4),
        unselectedItemColor: Color(0xFF7E8A8C),
      ),
    );
  }
}
