import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nseguridad/features/shared/helpers/relevo.dart';

class PrendasNotifier extends StateNotifier<List<Prenda>> {
  PrendasNotifier()
      : super([
          Prenda(
            id: '1',
            descripcion: 'Radio Motorola DP4800',
            cantidad: 1,
            estado: 'Bueno',
            observacion:
                'Batería con 90% de carga. Gasdahksdjhakjsd  askhdjahd akjhds a sd ahksd ahsdjk',
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
        ]);

  void updatePrendaEstado(String prendaId, String nuevoEstado) {
    state = [
      for (final prenda in state)
        if (prenda.id == prendaId)
          // Usamos copyWith para crear una nueva instancia de Prenda con el estado modificado
          prenda.copyWith(estado: nuevoEstado)
        else
          prenda,
    ];
  }

  void updatePrendaObservacion(String prendaId, String? nuevaObservacion) {
    state = [
      for (final prenda in state)
        if (prenda.id == prendaId)
          // Usamos copyWith para crear una nueva instancia con la observación modificada
          prenda.copyWith(observacion: nuevaObservacion)
        else
          prenda,
    ];
  }
}

final prendasProvider = StateNotifierProvider<PrendasNotifier, List<Prenda>>(
    (ref) => PrendasNotifier());

final List<String> estadosDisponibles = ['Bueno', 'Regular', 'Malo'];
