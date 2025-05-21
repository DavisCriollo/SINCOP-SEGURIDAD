// ignore_for_file: public_member_api_docs, sort_constructors_first
class Relevo {
  String nombre;
  String hora;
  String cliente;
  String puesto;
  List<Prenda> prendas;

  Relevo({
    required this.nombre,
    required this.hora,
    required this.cliente,
    required this.puesto,
    required this.prendas,
  });
}

class Prenda {
  String id;
  String descripcion;
  int cantidad;
  String estado;
  String observacion;

  Prenda({
    required this.id,
    required this.descripcion,
    required this.cantidad,
    required this.estado,
    required this.observacion,
  });
  // --- Método copyWith ---

  Prenda copyWith({
    String? id,
    String? descripcion,
    int? cantidad,
    String? estado,
    String? observacion,
  }) =>
      Prenda(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        cantidad: cantidad ?? this.cantidad,
        estado: estado ?? this.estado,
        observacion: observacion ?? this.observacion,
      );
}

final listaDePrendasDelRelevo = [
  Prenda(
    id: '1',
    descripcion: 'Radio Motorola DP4800',
    cantidad: 1,
    estado: 'Bueno',
    observacion:
        'Batería con 90% de carga.fskjdhf sdhfkjs fhkj  sdfhjsf  sdfhjsdhfw3 ewefrj',
  ),
  Prenda(
    id: '2',
    descripcion: 'Linterna LED',
    cantidad: 1,
    estado: 'Dañado',
    observacion: 'No enciende, requiere cambio de batería.',
  ),
  Prenda(
    id: '3',
    descripcion: 'Linterna LED',
    cantidad: 1,
    estado: 'Dañado',
    observacion: 'No enciende, requiere cambio de batería.',
  ),
  Prenda(
    id: '4',
    descripcion: 'Chaleco reflectivo',
    cantidad: 1,
    estado: 'Regular',
    observacion: 'Ligero desgaste por uso.',
  )
];
