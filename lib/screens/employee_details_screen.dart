import 'package:flutter/material.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Empleado'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Información del Empleado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: employee['name'],
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: '${employee['id']}',
              decoration: const InputDecoration(
                labelText: 'ID de Empleado',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: '555-1234',
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: employee['name'] != null
                  ? '${employee['name'].toLowerCase().replaceAll(' ', '.')}@empresa.com'
                  : 'empleado@empresa.com', // Valor predeterminado
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Ventas',
              decoration: const InputDecoration(
                labelText: 'Departamento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: 'Gerente',
              decoration: const InputDecoration(
                labelText: 'Rol Asignado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Gerente', child: Text('Gerente')),
                DropdownMenuItem(value: 'Empleado', child: Text('Empleado')),
              ],
              onChanged: (value) {
                // Lógica para cambiar el rol
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Permisos de Acceso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: const Text('Acceso a Informes de Ventas'),
              value: true,
              onChanged: (value) {
                // Lógica para cambiar permiso
              },
            ),
            SwitchListTile(
              title: const Text('Gestionar Inventario'),
              value: false,
              onChanged: (value) {
                // Lógica para cambiar permiso
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar cambios
              },
              child: const Text('Guardar cambios'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context, employee['id']); // Devuelve el ID al eliminar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ),
    );
  }
}
