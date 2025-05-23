import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<String> estadosDisponibles = [
  'Autorizado',
  'No Autorizado',
  'No Responde' // Corregí el error tipográfico aquí: "Respode" a "Responde"
];

// Creamos un Provider que expone esta lista
final estadosDisponiblesProvider = Provider<List<String>>((ref) {
  return estadosDisponibles;
});
