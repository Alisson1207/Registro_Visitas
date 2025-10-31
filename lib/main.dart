import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'screens/role_screen.dart';
import 'providers/visits_provider.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bool inTest = false;
  assert(inTest = true);

  if (!inTest) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      Fluttertoast.showToast(
        msg: 'Error de Flutter: ${details.exception}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    };
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => VisitsProvider()..init(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) => setState(() => isDarkMode = value);

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error en la interfaz:\n${details.exception}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visitas Técnicos',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: RoleScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
    );
  }
}
