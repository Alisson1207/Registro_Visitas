import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_screen.dart';

class RoleScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) toggleTheme;

  const RoleScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Fluttertoast.showToast(
        msg: 'Error en RoleScreen: ${details.exception}',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
      return Scaffold(
        backgroundColor: Colors.red[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text(
                '¡Ups! Algo salió mal en RoleScreen.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                details.exception.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    };

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 2,
          ),
          color: isDarkMode ? Colors.black : Colors.white,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(
                    isDarkMode
                        ? Icons.wb_sunny_rounded
                        : Icons.nightlight_round,
                    color: isDarkMode
                        ? Colors.yellow.shade600
                        : Colors.grey.shade800,
                    size: 28,
                  ),
                  onPressed: () => toggleTheme(!isDarkMode),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selecciona tu Rol',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRoleCard(
                            context, 'Técnico', Icons.build_circle_rounded, Colors.blue, 'tecnico'),
                        _buildRoleCard(
                            context, 'Supervisor', Icons.manage_accounts_rounded, Colors.green, 'supervisor'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String title, IconData icon,
      Color color, String role) {
    return GestureDetector(
      onTap: () {
        try {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(role: role, technician: "Técnico A"),
            ),
          );
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Error al seleccionar rol: $e",
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 60),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
