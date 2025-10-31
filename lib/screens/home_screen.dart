import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'scan_screen.dart';
import 'visits_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final String technician;

  const HomeScreen({
    super.key,
    required this.role,
    required this.technician,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    try {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..forward();
      _fadeAnimation =
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
      _slideAnimation =
          Tween(begin: const Offset(0, 0.2), end: Offset.zero)
              .animate(_fadeAnimation);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al iniciar animación: $e',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  Widget _buildAnimatedCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: () {
            try {
              onTap();
            } catch (e) {
              Fluttertoast.showToast(
                msg: 'Error al abrir $title: $e',
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF7F9FC);
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    ErrorWidget.builder = (FlutterErrorDetails details) {
      Fluttertoast.showToast(
        msg: 'Error en HomeScreen: ${details.exception}',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
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
                '¡Ups! Algo salió mal en HomeScreen.',
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
      backgroundColor: bgColor,
      body: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 2),
          color: isDark ? Colors.black : Colors.white,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: 'Error al regresar: $e',
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Bienvenido, ${widget.role}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildAnimatedCard(
                title: 'Escanear Visita',
                icon: Icons.qr_code_scanner,
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScanScreen(
                        role: widget.role,
                        technician: widget.technician,
                      ),
                    ),
                  );
                },
              ),
              _buildAnimatedCard(
                title: 'Ver Visitas',
                icon: Icons.list_alt,
                color: Colors.deepPurpleAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VisitsListScreen(
                        role: widget.role,
                        technician: widget.technician,
                      ),
                    ),
                  );
                },
              ),
              _buildAnimatedCard(
                title: 'Estadísticas',
                icon: Icons.bar_chart_rounded,
                color: Colors.tealAccent.shade700,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Módulo en desarrollo...'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
