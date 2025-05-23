import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nseguridad/features/bitacora/presentation/screens/bitacora_creen.dart';
import 'package:nseguridad/features/bitacora/presentation/widgets/item_lista_bitacora.dart';
import 'package:nseguridad/features/shared/provider/provider_initial.dart';
import 'package:nseguridad/features/shared/utils/responsive.dart';
import 'package:nseguridad/features/shared/widgets/customs_appbar.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:provider/provider.dart' as prov;

import '../../../shared/widgets/info_usuario.dart';

class BitacorasScreens extends StatefulWidget {
  const BitacorasScreens({Key? key}) : super(key: key);

  @override
  State<BitacorasScreens> createState() => _BitacorasScreensState();
}

class _BitacorasScreensState extends State<BitacorasScreens> {
  final List<Visitante> _bitacora = [];

  @override
  void initState() {
    super.initState();
    _generateDummyData(); // Generar los 10 elementos al iniciar la pantalla
  }

  void _generateDummyData() {
    for (int i = 1; i <= 10; i++) {
      _bitacora.add(
        Visitante(
          cedula: '123456789$i',
          nombre: 'Visitante Nombre $i',
          fechaHora:
              DateTime.now().subtract(Duration(hours: i)), // Fechas diferentes
          placa: 'ABC-${1000 + i}',
          fotoUrl:
              'https://picsum.photos/id/${100 + i}/200/200', // Fotos aleatorias
          motivoVisita: 'Consulta $i',
          ubicacion: 'Oficina PISO ${i % 3 + 1}',
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ctrlTheme = prov.Provider.of<ThemeApp>(context);
    Responsive size = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: const CustomAppbar(),
          title: Text(
            'Bitácora de Visitas',
          )),
      body: BitacorasView(
        bitacora: _bitacora,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ctrlTheme.primaryColor,
        onPressed: () {
          //======================================//
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const BitacoraScreen()));
          //======================================//
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BitacorasView extends ConsumerWidget {
  final List<Visitante> bitacora; // Lista para el primer tab

  const BitacorasView({
    super.key,
    required this.bitacora,
    // Asegúrate de pasar esta lista
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Responsive size = Responsive.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          children: [
            const InfoUsuario(),
            TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              tabs: const [
                Tab(
                  text: 'INGRESO',
                ),
                Tab(text: 'SALIDA'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  bitacora.isEmpty
                      ? const Center(
                          child:
                              Text('No hay registros en la bitácora INGRESO.'))
                      : ListView.builder(
                          padding: EdgeInsets.all(size.iScreen(1.0)),
                          itemCount: bitacora.length,
                          itemBuilder: (context, index) {
                            final visitante = bitacora[index];
                            return ItemListaBistacora(
                                size: size, visitante: visitante);
                          },
                        ),
                  bitacora.isEmpty
                      ? const Center(
                          child:
                              Text('No hay registros en la bitácora SALIDA.'))
                      : ListView.builder(
                          padding: EdgeInsets.all(size.iScreen(1.0)),
                          itemCount: bitacora.length,
                          itemBuilder: (context, index) {
                            final visitante = bitacora[index];
                            return ItemListaBistacora(
                                size: size, visitante: visitante);
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==========================================//
class Visitante {
  final String cedula;
  final String nombre;
  final DateTime fechaHora;
  final String placa;
  final String fotoUrl; // O tipo File/XFile si manejas el archivo directamente
  final String motivoVisita;
  final String ubicacion;

  Visitante({
    required this.cedula,
    required this.nombre,
    required this.fechaHora,
    required this.placa,
    required this.fotoUrl,
    required this.motivoVisita,
    required this.ubicacion,
  });

  // Método para convertir una instancia de Visitante a un Map
  Map<String, dynamic> toJson() {
    return {
      'Cedula': cedula,
      'nombre': nombre,
      'fechahora': fechaHora.toIso8601String(), // Formato ISO 8601 para fechas
      'placa': placa,
      'foto': fotoUrl,
      'motivovicita': motivoVisita,
      'ubicacion': ubicacion,
    };
  }

  // Método estático para crear una instancia de Visitante desde un Map
  factory Visitante.fromJson(Map<String, dynamic> json) {
    return Visitante(
      cedula: json['Cedula'],
      nombre: json['nombre'],
      fechaHora: DateTime.parse(json['fechahora']),
      placa: json['placa'],
      fotoUrl: json['foto'],
      motivoVisita: json['motivovicita'],
      ubicacion: json['ubicacion'],
    );
  }
}
//==========================================//