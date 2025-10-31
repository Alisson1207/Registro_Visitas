# Desarrollo de aplicación móvil de registro de visitas técnicas con QR y geolocalización

Aplicación móvil desarrollada con **Flutter** que permite a técnicos de campo registrar visitas a equipos mediante el escaneo de códigos QR o de barras. Incluye registro de fecha, hora y geolocalización, almacenamiento offline con SQLite, control de roles, búsqueda de visitas y soporte para modo claro/oscuro.  

---

## ⏱ Tiempo Estimado de Desarrollo

Aproximadamente **5 a 6 horas**, realizando el trabajo completo:

## 🛠 Tecnologías utilizadas

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)[![Provider](https://img.shields.io/badge/Provider-blue?style=for-the-badge)](https://pub.dev/packages/provider)[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://pub.dev/packages/sqflite)

## 📖 Manual de instalación

Para instalar correctamente la aplicación y ejecutarla en un entorno de desarrollo local, sigue estos pasos:

1. Clonar el repositorio

```bash
git clone <enlace-del-repositorio>
cd <nombre del archivo>
```

2. Instalación de dependencias

```bash
flutter pub get
```
> [!CAUTION]
> Si aparecen errores al instalar dependencias, verifica que tu Flutter SDK esté actualizado a >=3.9.2 <4.0.0 y que no haya conflictos en pubspec.yaml.

3. Ejecutar aplicación
   
```bash
flutter run
```
> [!NOTE]
> Asegúrate de conceder permisos de cámara y ubicación al iniciar la app, de lo contrario algunas funciones no estarán disponibles.

4. Ejecutar test unitarios
   
```bash
flutter test
```

> [!IMPORTANT]
> Los tests incluyen validaciones de providers y modelos de datos, así como filtrado de visitas y persistencia offline. No cubren UI completa.

## Uso de la aplicación

1. Selecciona tu rol al iniciar (Técnico o Supervisor).
2. Escanea el código QR correspondiente.
3. La app registrará automáticamente fecha, hora y ubicación.
4. Consulta tus visitas en la lista y utiliza la barra de búsqueda si lo deseas.
   
**Los supervisores pueden eliminar registros y ver todas las visitas.**

## Roles

| Rol        | Funcionalidades                                            |
|------------|------------------------------------------------------------|
| Técnico    | Registrar visitas, ver sus propias visitas, búsqueda por código |
| Supervisor | **Ver todas las visitas**, **eliminar registros**, búsqueda por código |

> [!WARNING]
> El rol Supervisor puede eliminar cualquier registro. Usar con precaución.

## Decisiones técnicas y consideraciones

* SQLite: Se utilizó para persistencia local de registros, permitiendo operación offline.
* Roles simulados: Inicio de sesión simulado para Técnico y Supervisor, suficiente para la prueba.
* Escaneo QR/barra: mobile_scanner soporta Android e iOS y códigos QR y barras.
* Geolocalización: geolocator obtiene latitud y longitud validando permisos antes de acceder.
* Modo claro/oscuro: Colores de textos, tarjetas y fondos se adaptan automáticamente.
* Búsqueda: Filtrado de visitas.
* Control de errores: flutter_error_boundary y Fluttertoast para manejo seguro de excepciones y notificaciones.

## Limitaciones

- La información de los equipos es simulada; no se conecta a ningún backend real.  
- Inicio de sesión no autenticado, solo simulado para roles Técnico y Supervisor.  
- Mapas se abren en Google Maps mediante URL externa, no hay integración nativa completa.  
- Tests unitarios se enfocan únicamente en **lógica de providers y modelos de datos**, no incluyen pruebas de interfaz de usuario (UI).  

---

## Tests Unitarios Realizados

Se implementaron pruebas unitarias usando `flutter_test` que validan la funcionalidad de la lógica de negocio:

- Confirmación de que las visitas se agregan correctamente en memoria.  
- Verificación de que el filtrado por rol funciona según lo esperado.  
- Aseguramiento de que los modelos de datos (`VisitModel`) y providers (`VisitsProvider`) mantienen la integridad de la información.  

> [!NOTE]
> Estos tests permiten garantizar que la **lógica de registro y filtrado funciona correctamente en memoria**, antes de integrar con SQLite o la interfaz de usuario.

---






