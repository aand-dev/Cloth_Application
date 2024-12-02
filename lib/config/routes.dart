import 'package:flutter/material.dart';
import 'package:stock_application/models/product_model.dart';
import 'package:stock_application/screens/add_product_screen.dart';
import 'package:stock_application/screens/client_details_screen.dart';
import 'package:stock_application/screens/client_screen.dart';
import 'package:stock_application/screens/employee_details_screen.dart';
import 'package:stock_application/screens/employees_screen.dart';
import 'package:stock_application/screens/login_screen.dart';
import 'package:stock_application/screens/product_details_screen.dart';
import 'package:stock_application/screens/proveedor_details_screen.dart';
import 'package:stock_application/screens/proveedores_screen.dart';
import 'package:stock_application/screens/receipt_viewer_screen.dart';
import 'package:stock_application/screens/register_screen.dart';
import 'package:stock_application/screens/home_screen.dart';
import 'package:stock_application/screens/edit_product_screen.dart';
import 'package:stock_application/screens/sale_detail_screen.dart';
import 'package:stock_application/screens/sales_form_screen.dart';
import 'package:stock_application/screens/sales_screen.dart';
import 'package:stock_application/screens/qr_scanner_screen.dart';
import 'package:stock_application/screens/select_product_screen.dart';

class AppRoutes {
  // Rutas principales
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  // Rutas para productos
  static const String productDetails = '/product-details';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';

  // Rutas para ventas
  static const String sales = '/sales';
  static const String salesForm = '/sales/form';
  static const String receiptViewer = '/sales/receipt';
  static const String saleDetails = '/sale-details';
  static const String selectProduct = '/select-product';

  // Rutas para clientes
  static const String clientList = '/clients';
  static const String clientDetails = '/client-details';

  //Rutas para empleados
  static const String employees = '/employees';
  static const String employeeDetails = '/employee-details';

  // Rutas adicionales
  static const String qrScanner = '/qr-scanner';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      // Productos
      case productDetails:
        final arguments = settings.arguments;
        if (arguments is int) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(productId: arguments),
          );
        }
        return _errorRoute('ID de producto no proporcionado o no válido.');
      case addProduct:
        return MaterialPageRoute(builder: (_) => AddProductScreen());
      case editProduct:
        final arguments = settings.arguments;
        if (arguments is Product) {
          return MaterialPageRoute(
            builder: (_) => EditProductScreen(product: arguments),
          );
        }
        return _errorRoute('Producto no proporcionado o no válido.');

      // Ventas
      case sales:
        return MaterialPageRoute(builder: (_) => const SalesScreen());
      case saleDetails:
        final arguments = settings.arguments;
        if (arguments is int) {
          return MaterialPageRoute(
            builder: (_) => SaleDetailScreen(saleId: arguments),
          );
        }
        return _errorRoute('ID de venta no proporcionado o no válido.');
      case salesForm:
        return MaterialPageRoute(builder: (_) => const SalesFormScreen());
      case receiptViewer:
        final arguments = settings.arguments as Map<String, dynamic>?;
        if (arguments != null) {
          return MaterialPageRoute(
            builder: (_) => ReceiptViewerScreen(arguments: arguments),
          );
        }
        return _errorRoute(
            'Argumentos no proporcionados para ReceiptViewerScreen.');
      case selectProduct:
        return MaterialPageRoute(builder: (_) => const SelectProductScreen());

      // Clientes
      case clientList:
        return MaterialPageRoute(builder: (_) => const ClientScreen());
      case clientDetails:
        final arguments = settings.arguments;
        if (arguments is int) {
          return MaterialPageRoute(
            builder: (_) => ClientDetailsScreen(clientId: arguments),
          );
        }
        return _errorRoute('ID de cliente no proporcionado o no válido.');

      //Empleados
      case employees:
        return MaterialPageRoute(builder: (_) => const EmployeesScreen());
      case employeeDetails:
        return MaterialPageRoute(
            builder: (_) => EmployeeDetailsScreen(
                  employee: {},
                ));

      //Proveedores
      case '/proveedor-list':
        return MaterialPageRoute(builder: (_) => const ProveedoresScreen());
      case '/proveedor-details':
        final arguments = settings.arguments;
        if (arguments is int) {
          return MaterialPageRoute(
            builder: (_) => ProveedorDetailsScreen(proveedorId: arguments),
          );
        }
        return _errorRoute('ID de proveedor no proporcionado o no válido.');

      // QR Scanner
      case qrScanner:
        final arguments = settings.arguments as void Function(String)?;
        if (arguments != null) {
          return MaterialPageRoute(
            builder: (_) => QRScannerScreen(onScan: arguments),
          );
        }
        return _errorRoute('Callback no proporcionado para QRScannerScreen.');

      // Ruta por defecto
      default:
        return _errorRoute('No hay una ruta definida para ${settings.name}.');
    }
  }

  /// Pantalla de error para rutas no definidas o problemas con los argumentos
  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
