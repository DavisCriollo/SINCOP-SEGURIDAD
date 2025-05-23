import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/features/bitacora/presentation/provider/providers.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart' as prov;

import '../../../shared/widgets/widgets.dart';

class BitacoraScreen extends StatelessWidget {
  const BitacoraScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const CustomAppbar(),
        title: Text('Crear Bitácora'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              size: size.iScreen(
                4,
              ),
              color: Colors.white,
            ),
            onPressed: () {
              // Acción al presionar el botón de guardar
            },
          ),
        ],
      ),
      body: BitacoraView(),
    );
  }
}

class BitacoraView extends ConsumerWidget {
  const BitacoraView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlTheme = Theme.of(context).colorScheme;
    final size = Responsive.of(context);
    final List<String> estados = ref.watch(estadosDisponiblesProvider);
    return Scaffold(
      body: Container(
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),
        margin: EdgeInsets.all(size.iScreen(1.0)),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const InfoUsuario(),
              //*****************************************/
              Column(
                children: [
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Documento:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: size.iScreen(0.1)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ctrlTheme.secondary,
                                  width: size.iScreen(0.1)),
                            ),
                            counterText: "",
                          ),
                          textAlign: TextAlign.start,
                          style: const TextStyle(),
                          textInputAction: TextInputAction.done,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                          ],
                          onChanged: (text) {},
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Campo requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                          color: ctrlTheme.secondary,
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: ctrlTheme.secondary,
                          )),
                    ],
                  ),
                ],
              ),
              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/

              SizedBox(
                width: size.wScreen(100.0),

                // color: Colors.blue,
                child: Text('Foto Documento:',
                    style: GoogleFonts.lexendDeca(
                        // fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
              ),
              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/

              Container(
                width: size.wScreen(90.0),
                height: size.hScreen(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.iScreen(1.0)),
                  color: Colors.grey[200],
                ),
                child: IconButton(
                  onPressed: () {
                    // Lógica para seleccionar una imagen
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: size.iScreen(5.0),
                    color: ctrlTheme.secondary,
                  ),
                ),
              ),
              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/
              Column(
                children: [
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Placa:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: size.iScreen(0.1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ctrlTheme.secondary,
                            width: size.iScreen(0.1)),
                      ),
                      counterText: "",
                    ),
                    textAlign: TextAlign.start,
                    style: const TextStyle(),
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                    ],
                    onChanged: (text) {},
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/

              SizedBox(
                width: size.wScreen(100.0),

                // color: Colors.blue,
                child: Text('Foto Placa:',
                    style: GoogleFonts.lexendDeca(
                        // fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
              ),
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/

              Container(
                width: size.wScreen(90.0),
                height: size.hScreen(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.iScreen(1.0)),
                  color: Colors.grey[200],
                ),
                child: IconButton(
                  onPressed: () {
                    // Lógica para seleccionar una imagen
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: size.iScreen(5.0),
                    color: ctrlTheme.secondary,
                  ),
                ),
              ),
              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/
              Column(
                children: [
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Motivo:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: size.iScreen(0.1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ctrlTheme.secondary,
                            width: size.iScreen(0.1)),
                      ),
                      counterText: "",
                    ),
                    textAlign: TextAlign.start,
                    style: const TextStyle(),
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                    ],
                    onChanged: (text) {},
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/
              Column(
                children: [
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Ubicación :',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: size.iScreen(0.1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ctrlTheme.secondary,
                            width: size.iScreen(0.1)),
                      ),
                      counterText: "",
                    ),
                    textAlign: TextAlign.start,
                    style: const TextStyle(),
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                    ],
                    onChanged: (text) {},
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              //*****************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/

              Column(
                children: [
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Estado de la Visita:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: size.iScreen(0.1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ctrlTheme.secondary,
                            width: size.iScreen(0.1)),
                      ),
                      counterText: "",
                    ),
                    value: estados
                        .first, // Valor inicial, podrías tener una variable para el estado seleccionado
                    items: estados.map((String estado) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        // Aquí manejas el cambio del estado seleccionado
                        print('Estado seleccionado: $newValue');
                        // Por ejemplo, podrías actualizar otro provider con el estado seleccionado
                        // ref.read(selectedEstadoProvider.notifier).state = newValue;
                      }
                    },
                  ),
                ],
              ),
              //*****************************************/

              SizedBox(
                height: size.iScreen(4.0),
              ),
              //*****************************************/
            ],
          ),
        ),
      ),
    );
  }
}
