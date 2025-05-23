import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nseguridad/features/bitacora/presentation/screens/screens.dart';
import 'package:nseguridad/features/shared/utils/responsive.dart';

class ItemListaBistacora extends StatelessWidget {
  const ItemListaBistacora({
    super.key,
    required this.size,
    required this.visitante,
  });

  final Responsive size;
  final Visitante visitante;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: size.iScreen(0.5), horizontal: size.iScreen(1.0)),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                visitante.nombre,
                style: GoogleFonts.roboto(
                  fontSize: size.iScreen(2.0),
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Cédula:',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.8),
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        ' ${visitante.cedula}',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.iScreen(0.5)),
                  Row(
                    children: [
                      Text(
                        'Placa:',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.8),
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        ' ${visitante.placa}',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.iScreen(0.5)),
              Row(
                children: [
                  Text(
                    'Motivo:',
                    style: GoogleFonts.roboto(
                      fontSize: size.iScreen(1.8),
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ' ${visitante.motivoVisita}',
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(1.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.iScreen(0.5)),
              Row(
                children: [
                  Text(
                    'Ubicación:',
                    style: GoogleFonts.roboto(
                      fontSize: size.iScreen(1.8),
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ' ${visitante.ubicacion}',
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(1.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.iScreen(0.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Fecha Ingreso',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.8),
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        // Formatear la fecha y hora para una mejor lectura
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(visitante.fechaHora),
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Fecha Salida',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.8),
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        // Formatear la fecha y hora para una mejor lectura
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(visitante.fechaHora),
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
