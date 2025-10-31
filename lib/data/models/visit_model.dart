class VisitModel {
  final int? id;
  final String code;
  final String role;
  final double latitude;
  final double longitude;
  final DateTime date;

  VisitModel({
    this.id,
    required this.code,
    required this.role,
    required this.latitude,
    required this.longitude,
    required this.date,
  }) {
    if (code.isEmpty) throw Exception('El código no puede estar vacío');
    if (role.isEmpty) throw Exception('El rol no puede estar vacío');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'role': role,
      'latitude': latitude,
      'longitude': longitude,
      'date': date.toIso8601String(),
    };
  }

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    try {
      return VisitModel(
        id: map['id'] as int?,
        code: map['code'] as String? ?? '',
        role: map['role'] as String? ?? '',
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error parsing VisitModel: $e');
    }
  }
}
