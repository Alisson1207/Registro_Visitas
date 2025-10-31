import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/visit_model.dart';
import 'package:provider/provider.dart';
import '../providers/visits_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisitCard extends StatelessWidget {
  final VisitModel visit;
  final bool isSupervisor;

  const VisitCard({
    super.key,
    required this.visit,
    required this.isSupervisor,
  });

  void _openMaps() async {
    try {
      final url =
          'https://www.google.com/maps/search/?api=1&query=${visit.latitude},${visit.longitude}';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Fluttertoast.showToast(
          msg: 'No se pudo abrir Maps',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al abrir Maps: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  @override
 @override
Widget build(BuildContext context) {
  final theme = Theme.of(context); 

  return Card(
    color: theme.brightness == Brightness.dark
        ? Colors.grey[850] 
        : Colors.white,   
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código: ${visit.code}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium!.color, 
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fecha: ${visit.date.toLocal().toString().split(".")[0]}',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ubicación: (${visit.latitude.toStringAsFixed(5)}, ${visit.longitude.toStringAsFixed(5)})',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.map, color: Colors.blue),
                onPressed: _openMaps,
              ),
              if (isSupervisor)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar registro'),
                        content: const Text(
                            '¿Seguro que deseas eliminar este registro?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      try {
                        await context.read<VisitsProvider>().deleteVisit(visit.id!);
                        Fluttertoast.showToast(
                          msg: 'Registro eliminado',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: 'Error al eliminar: $e',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                        );
                      }
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
}