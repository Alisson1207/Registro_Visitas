import 'package:flutter_test/flutter_test.dart';
import '../../lib/providers/visits_provider.dart';
import '../../lib/data/models/visit_model.dart';

void main() {
  late VisitsProvider provider;

  setUp(() {
    provider = VisitsProvider(); // solo la lista en memoria
  });

  test('Agregar visita en memoria', () {
    final visit = VisitModel(
      code: 'TEST123',
      role: 'tecnico',
      latitude: 1.0,
      longitude: 2.0,
      date: DateTime.now(),
    );

    provider.visits.add(visit);

    expect(provider.visits.length, 1);
    expect(provider.visits.first.code, 'TEST123');
  });

  test('Filtrar visitas por rol', () {
    provider.visits.addAll([
      VisitModel(code: 'A', role: 'tecnico', latitude: 0, longitude: 0, date: DateTime.now()),
      VisitModel(code: 'B', role: 'supervisor', latitude: 0, longitude: 0, date: DateTime.now()),
    ]);

    final tecnicos = provider.visitsByRole('tecnico', 'Juan');

    expect(tecnicos.length, 1);
    expect(tecnicos.first.role, 'tecnico');
  });
}
