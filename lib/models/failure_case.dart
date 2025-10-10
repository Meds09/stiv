class FailureCase {
final String id;
final String categoria;
final String titulo;
final String? descripcion;
final List<String> causas;
final List<String> pruebas;
final String? solucion;
final String prioridad;
final List<String> etiquetas;
const FailureCase({
required this.id,
required this.categoria,
required this.titulo,
this.descripcion,
this.causas = const [],
this.pruebas = const [],
this.solucion,
this.prioridad = 'Media',
this.etiquetas = const [],
});
}