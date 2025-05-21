// --- ¡ASEGÚRATE DE QUE PrendaDataSource ESTÉ AQUÍ! ---
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/features/shared/helpers/relevo.dart';
import 'package:nseguridad/features/shared/provider/prendas_provider.dart';
import 'package:nseguridad/features/shared/utils/responsive.dart';

// class DetallePrendasDTS extends DataTableSource {
//   final Responsive size;

//   final List<Prenda>? prendas;

//   DetallePrendasDTS(this.prendas, this.size);
//   @override
//   DataRow? getRow(int index) {
//     final prenda = prendas![index];
//     return DataRow.byIndex(index: index, cells: [
//       DataCell(Text(
//         '${prenda.descripcion}',
//         style: GoogleFonts.lexendDeca(
//             fontSize: size.iScreen(1.7),
//             color: Colors.black87,
//             fontWeight: FontWeight.normal),
//       )),
//       DataCell(Text(
//         prenda.cantidad.toString(),
//         style: GoogleFonts.lexendDeca(
//             fontSize: size.iScreen(1.7), fontWeight: FontWeight.normal),
//       )),
//       DataCell(Text(
//         '${prenda.estado}',
//         style: GoogleFonts.lexendDeca(
//             fontSize: size.iScreen(1.7),
//             color: Colors.black87,
//             fontWeight: FontWeight.normal),
//       )),
//       DataCell(Text(
//         '${prenda.observacion}',
//         style: GoogleFonts.lexendDeca(
//             fontSize: size.iScreen(1.7),
//             color: Colors.black87,
//             fontWeight: FontWeight.normal),
//       )),
//     ]);
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => prendas!.length;

//   @override
//   int get selectedRowCount => 0;
// }

// Asume que Prenda y Responsive están definidos en algún lugar accesible
// Por ejemplo:
// class Prenda { /* ... */ }
// class Responsive { /* ... */ }

class PrendaDataSource extends DataTableSource {
  // Lista de prendas que mostrará la tabla. ¡Ahora es List<Prenda>!
  final List<Prenda> _prendas;
  // Utilidad para el tamaño de pantalla, necesaria para estilos responsivos.
  final Responsive _size;

  // Callback para cuando se cambia el estado de una prenda (Bueno, Regular, Malo).
  // Es una función que recibe el ID de la prenda y el nuevo estado.
  final void Function(String id, String nuevoEstado) _onEstadoChanged;

  // Callback para cuando se cambia la observación de una prenda.
  // Es una función que recibe el ID de la prenda y la nueva observación (puede ser null).
  final void Function(String id, String? nuevaObservacion)
      _onObservacionChanged;

  // El BuildContext es necesario para mostrar la modal de edición de observación.
  // Lo pasamos desde el widget padre (_MyPageState en este caso).
  final BuildContext _context;

  // Constructor que recibe todos los datos y callbacks necesarios.
  PrendaDataSource(this._prendas, this._size, this._onEstadoChanged,
      this._onObservacionChanged, this._context);

  @override
  // Este método es llamado por DataTable para obtener cada fila de la tabla.
  DataRow? getRow(int index) {
    // Si el índice está fuera del rango de la lista de prendas, devuelve null.
    if (index >= _prendas.length) {
      return null;
    }
    // Obtiene el objeto Prenda correspondiente al índice.
    final prenda = _prendas[index];

    // Construye y devuelve una DataRow.
    return DataRow(
      cells: [
        // --- Primera Celda: Nombre de la Prenda ---
        DataCell(
          Text(
            prenda.descripcion, // Muestra el nombre de la prenda.
            style: GoogleFonts.roboto(
              fontSize: _size.iScreen(1.8),
            ),
          ),
        ),

        // --- Segunda Celda: Estado de la Prenda (con DropdownButton) ---
        DataCell(
          Text(
            prenda.cantidad.toString(), // Muestra el nombre de la prenda.
            style: GoogleFonts.roboto(
              fontSize: _size.iScreen(1.8),
            ),
          ),
        ),

        // --- Tercera Celda: Observación de la Prenda (con texto y botón de edición) ---
        DataCell(
          Row(
            mainAxisSize: MainAxisSize
                .min, // Hace que el Row ocupe solo el espacio necesario.
            children: [
              Expanded(
                // Permite que el texto ocupe la mayor parte del espacio.
                child: Text(
                  // Si hay observación, la muestra; de lo contrario, muestra "Agregar...".
                  prenda.estado != null && prenda.estado.isNotEmpty
                      ? prenda.estado!
                      : 'Agregar...',
                  style: GoogleFonts.roboto(
                    fontSize: _size.iScreen(1.6),
                    // Cambia el color y subraya si es "Agregar..." (como un enlace).
                    color: prenda.estado != null && prenda.estado!.isNotEmpty
                        ? Colors.black
                        : Colors.blueAccent,
                    decoration:
                        prenda.estado != null && prenda.estado!.isNotEmpty
                            ? TextDecoration.none
                            : TextDecoration.underline,
                  ),
                  overflow: TextOverflow
                      .ellipsis, // Trunca el texto si es demasiado largo.
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit, // Ícono de lápiz para editar.
                  size: _size.iScreen(2.0),
                  color: Colors.grey[600],
                ),
                // Callback que se dispara al presionar el botón de editar.
                onPressed: () {
                  // Muestra la modal para editar la observación.
                  _showEstadoSelectionModal(prenda.id, prenda.estado, 'wrwer');
                },
                tooltip:
                    'Editar observación', // Texto que aparece al pasar el ratón.
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize
                .min, // Hace que el Row ocupe solo el espacio necesario.
            children: [
              Expanded(
                // Permite que el texto ocupe la mayor parte del espacio.
                child: Text(
                  // Si hay observación, la muestra; de lo contrario, muestra "Agregar...".
                  prenda.observacion != null && prenda.observacion!.isNotEmpty
                      ? prenda.observacion!
                      : 'Agregar...',
                  style: GoogleFonts.roboto(
                    fontSize: _size.iScreen(1.6),
                    // Cambia el color y subraya si es "Agregar..." (como un enlace).
                    color: prenda.observacion != null &&
                            prenda.observacion!.isNotEmpty
                        ? Colors.black
                        : Colors.blueAccent,
                    decoration: prenda.observacion != null &&
                            prenda.observacion!.isNotEmpty
                        ? TextDecoration.none
                        : TextDecoration.underline,
                  ),
                  overflow: TextOverflow
                      .ellipsis, // Trunca el texto si es demasiado largo.
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit, // Ícono de lápiz para editar.
                  size: _size.iScreen(2.0),
                  color: Colors.grey[600],
                ),
                // Callback que se dispara al presionar el botón de editar.
                onPressed: () {
                  // Muestra la modal para editar la observación.
                  _showObservacionModal(prenda.id, prenda.observacion);
                },
                tooltip:
                    'Editar observación', // Texto que aparece al pasar el ratón.
              ),
            ],
          ),
        ),
      ],
      // Define el color de fondo de la fila (alternando colores para mejor legibilidad).
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (index.isEven) {
            return Colors.grey.shade100; // Gris claro para filas pares.
          }
          return null; // Color por defecto (blanco) para filas impares.
        },
      ),
    );
  }

  // --- FUNCIÓN PARA MOSTRAR LA MODAL DE OBSERVACIÓN ---
  void _showObservacionModal(String prendaId, String? currentObservacion) {
    // Controlador de texto para el TextField de la modal, inicializado con la observación actual.
    TextEditingController controller =
        TextEditingController(text: currentObservacion);

    // Muestra un diálogo flotante (modal).
    showDialog(
      context: _context, // Usa el contexto que fue pasado al DataSource.
      barrierDismissible:
          false, // El usuario debe presionar un botón para cerrar la modal.
      // Builder para construir el contenido de la modal.
      builder: (BuildContext dialogContext) {
        // 'dialogContext' es el contexto específico de esta modal.
        return AlertDialog(
          title: Text(
            'Observación para', // Título de la modal.
            style: GoogleFonts.roboto(
                fontSize: _size.iScreen(2.0), fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller, // Asigna el controlador de texto.
            maxLines: 5, // Permite múltiples líneas de texto.
            minLines: 1, // Mínimo de una línea visible.
            decoration: InputDecoration(
              hintText:
                  'Escribe tu observación aquí...', // Texto de sugerencia.
              border:
                  OutlineInputBorder(), // Borde alrededor del campo de texto.
            ),
          ),
          actions: [
            // Botón "Cancelar" para cerrar la modal sin guardar cambios.
            TextButton(
              onPressed: () {
                Navigator.pop(
                    dialogContext); // Cierra la modal usando su propio contexto.
              },
              child: Text('Cancelar',
                  style: GoogleFonts.roboto(color: Colors.red)),
            ),
            // Botón "Guardar" para aplicar los cambios y cerrar la modal.
            ElevatedButton(
              onPressed: () {
                // Llama al callback proporcionado para actualizar la observación en Riverpod.
                // Si el texto está vacío, guarda null; de lo contrario, guarda el texto.
                _onObservacionChanged(
                    prendaId,
                    controller.text.trim().isEmpty
                        ? null
                        : controller.text.trim());
                Navigator.pop(dialogContext); // Cierra la modal.
              },
              child: Text('Guardar',
                  style: GoogleFonts.roboto(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  // --- FUNCIÓN PARA MOSTRAR LA MODAL DE SELECCIÓN DE ESTADO (¡NUEVA!) ---
  void _showEstadoSelectionModal(
      String prendaId, String currentEstado, String prendaNombre) {
    showDialog<String>(
      // Especifica el tipo de retorno String
      context: _context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text(
            'Selecciona el estado de ${prendaNombre}',
            style: GoogleFonts.roboto(
                fontSize: _size.iScreen(2.0), fontWeight: FontWeight.bold),
          ),
          children: estadosDisponibles.map((String estado) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(
                    dialogContext, estado); // Devuelve el estado seleccionado
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: _size.iScreen(0.5)),
                child: Text(
                  estado,
                  style: GoogleFonts.roboto(
                    fontSize: _size.iScreen(1.9),
                    fontWeight: currentEstado == estado
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: currentEstado == estado ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    ).then((String? selectedEstado) {
      // Este bloque se ejecuta cuando la modal se cierra (el usuario selecciona algo o cancela)
      if (selectedEstado != null && selectedEstado != currentEstado) {
        _onEstadoChanged(prendaId, selectedEstado);
      }
    });
  }

  @override
  // Indica si el número de filas es aproximado. Para una lista, es false.
  bool get isRowCountApproximate => false;

  @override
  // El número total de filas en la tabla.
  int get rowCount => _prendas.length;

  @override
  // El número de filas seleccionadas (en este caso, 0 ya que no hay selección de filas).
  int get selectedRowCount => 0;

  @override
  // Método para notificar al DataTable que los datos subyacentes han cambiado.
  // Esto forzará al DataTable a reconstruir sus filas.
  void notifyListeners() {
    super.notifyListeners();
  }
}
