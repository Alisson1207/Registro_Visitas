import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/visits_provider.dart';
import '../theme/app_theme.dart';
import '../data/models/visit_model.dart';

class ScanScreen extends StatefulWidget {
  final String role;
  final String technician;

  const ScanScreen({
    super.key,
    required this.role,
    required this.technician,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  bool _scanned = false;
  String? _statusMessage;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    try {
      _controller =
          AnimationController(vsync: this, duration: const Duration(seconds: 1))
            ..repeat(reverse: true);
      _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error inicializando animación: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _requestPermissions() async {
    try {
      final cameraStatus = await Permission.camera.status;
      final locationStatus = await Permission.locationWhenInUse.status;

      if (!cameraStatus.isGranted) {
        final res = await Permission.camera.request();
        if (!res.isGranted) {
          Fluttertoast.showToast(msg: 'Permiso de cámara denegado');
          if (!mounted) return false;
          setState(() => _statusMessage = 'Permiso de cámara denegado.');
          return false;
        }
      }

      if (!locationStatus.isGranted) {
        final res = await Permission.locationWhenInUse.request();
        if (!res.isGranted) {
          Fluttertoast.showToast(msg: 'Permiso de ubicación denegado');
          if (!mounted) return false;
          setState(() => _statusMessage = 'Permiso de ubicación denegado.');
          return false;
        }
      }
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al solicitar permisos: $e');
      return false;
    }
  }

  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: 'Servicio de ubicación desactivado');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: 'Permiso de ubicación denegado');
        return null;
      }

      return await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high));
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al obtener ubicación: $e');
      return null;
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_scanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    _scanned = true;
    final code = barcodes.first.rawValue ?? 'UNKNOWN';
    if (mounted) setState(() => _statusMessage = 'Escaneado: $code');

    try {
      final ok = await _requestPermissions();
      if (!ok) return;

      final pos = await _determinePosition();
      final visit = VisitModel(
        code: code,
        role: widget.role,
        latitude: pos?.latitude ?? 0,
        longitude: pos?.longitude ?? 0,
        date: DateTime.now(),
      );

      await context.read<VisitsProvider>().addVisit(visit);
      if (mounted) setState(() => _statusMessage = 'Registro guardado');
      Fluttertoast.showToast(msg: 'Registro guardado correctamente');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al registrar visita: $e');
    }

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _requestPermissions(),
      builder: (context, snapshot) {
        final granted = snapshot.data ?? false;

        return Scaffold(
          backgroundColor: AppTheme.secondaryColor.withOpacity(0.05),
          appBar: AppBar(
            title: const Text('Escanear código'),
            backgroundColor: AppTheme.primaryColor,
            centerTitle: true,
          ),
          body: granted
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(onDetect: _onDetect),
                    ScaleTransition(
                      scale: _animation,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.accentColor, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    _statusMessage ?? 'Permisos necesarios',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
        );
      },
    );
  }
}
