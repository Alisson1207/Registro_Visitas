import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visits_provider.dart';
import '../widgets/visit_card.dart';
import '../theme/app_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisitsListScreen extends StatefulWidget {
  final String role;
  final String technician;

  const VisitsListScreen({
    super.key,
    required this.role,
    required this.technician,
  });

  @override
  State<VisitsListScreen> createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final visitsProvider = context.watch<VisitsProvider>();
    List visits = [];

    try {
      visits = visitsProvider.visitsByRole(widget.role, widget.technician);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al obtener registros: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }

    final isSupervisor = widget.role == 'supervisor';

    List filtered = [];
    try {
      filtered = visits.where((v) {
        final query = _searchQuery.toLowerCase();
        return v.code.toLowerCase().contains(query);
      }).toList();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al filtrar registros: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Visitas'),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(
                color: theme.textTheme.bodyMedium!.color,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar por código...',
                hintStyle: TextStyle(
                  color: theme.textTheme.bodyMedium!.color?.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.iconTheme.color,
                ),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No hay visitas registradas',
                      style: TextStyle(color: theme.textTheme.bodyMedium!.color),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final visit = filtered[index];
                      return VisitCard(
                        visit: visit,
                        isSupervisor: isSupervisor,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
