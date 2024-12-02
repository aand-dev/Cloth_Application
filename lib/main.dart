import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_application/config/routes.dart';
import 'package:stock_application/providers/inventory_provider.dart';
import 'package:stock_application/providers/sales_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
      ],
      child: MaterialApp(
          title: 'Stock',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF265DD4)),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRoutes.generateRoute),
    );
  }
}
