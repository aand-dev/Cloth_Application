import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  // Lista de empleados simulada
  List<Map<String, dynamic>> employees = [
    {
      'id': 12345,
      'name': 'María García',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'id': 12346,
      'name': 'Juan Pérez',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'id': 12347,
      'name': 'Ana López',
      'image': 'https://via.placeholder.com/150'
    }
  ];

  // Función para eliminar empleado
  void _deleteEmployee(int employeeId) {
    setState(() {
      employees.removeWhere((employee) => employee['id'] == employeeId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Empleado eliminado.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empleados'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por nombre o ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // Implementar lógica de búsqueda
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: employees.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(employee['image']),
                    ),
                    title: Text(employee['name']),
                    subtitle: Text('ID: ${employee['id']}'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/employee-details',
                        arguments: employee,
                      ).then((result) {
                        if (result != null && result is int) {
                          _deleteEmployee(
                              result); // Actualiza la lista al volver
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para añadir empleado
              },
              icon: const Icon(Icons.add),
              label: const Text('Añadir empleado'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDEEAFF),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
