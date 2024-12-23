import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/consignas_controller.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class DetalleConsignasClientes extends StatefulWidget {
  const DetalleConsignasClientes({super.key});

  @override
  State<DetalleConsignasClientes> createState() =>
      _DetalleConsignasClientesState();
}

class _DetalleConsignasClientesState extends State<DetalleConsignasClientes> {
  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final ctrlTheme = context.read<ThemeApp>();

    final consignaController =
        Provider.of<ConsignasController>(context).getConsigna;
    List listaDeFechas = [];

    for (var item in consignaController!['conFechasConsignaConsultaDB']) {
      listaDeFechas.add(item['desde']);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ctrlTheme.primaryColor,
                ctrlTheme.secondaryColor,
              ],
            ),
          ),
        ),
        title: const Text(
          'Detalle de Consigna',
          // style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Container(
        color: Colors.white,
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),
        padding: EdgeInsets.only(
          left: size.iScreen(1.0),
          right: size.iScreen(1.0),
        ),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //***********************************************/
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                //*****************************************/
                Row(
                  children: [
                    Container(
                      child: Text('Asunto: ',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    Expanded(
                      child: Container(
                        width: size.wScreen(100.0),
                        // color: Colors.red,
                        padding: const EdgeInsets.only(),
                        child: Text(
                          '${consignaController!['conAsunto']}',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.4),
                            fontWeight: FontWeight.normal,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //***********************************************/
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                //*****************************************/
                Row(
                  children: [
                    Container(
                      child: Text('Detalle: ',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    Expanded(
                      child: Container(
                        width: size.wScreen(100.0),
                        // color: Colors.red,
                        padding: const EdgeInsets.only(),
                        child: Text(
                          '${consignaController!['conDetalle']}',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.4),
                            fontWeight: FontWeight.normal,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //***********************************************/
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                //*****************************************/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text('Prioridad: ',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: Text(
                            '${consignaController!['conPrioridad']}',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.4),
                              fontWeight: FontWeight.normal,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text('Estado: ',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: Text(
                            '${consignaController!['conEstado']}',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.4),
                              fontWeight: FontWeight.normal,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //***********************************************/
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                //*****************************************/
                Row(
                  children: [
                    Container(
                      child: Text('Cliente: ',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    Expanded(
                      child: Container(
                        width: size.wScreen(100.0),
                        // color: Colors.red,
                        padding: const EdgeInsets.only(),
                        child: Text(
                          '${consignaController!['conNombreCliente']}',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.4),
                            fontWeight: FontWeight.normal,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //***********************************************/
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                //*****************************************/
                Column(
                  children: [
                    SizedBox(
                      width: size.wScreen(100.0),
                      child: Text('Fecha a realizarse: ',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    SizedBox(
                        width: size.wScreen(100.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: listaDeFechas
                              .map(
                                (e) => Container(
                                  margin: EdgeInsets.all(size.iScreen(0.6)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.all(size.iScreen(0.5)),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade500,
                                          // color: Color(0xff2BADEC),
                                        ),
                                        width: size.iScreen(12.0),
                                        child: Text(
                                          e.toString().substring(0, 10),
                                          style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.8),
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                                ),
                              )
                              .toList(),
                        )),
                  ],
                ),
                //==========================================//

                //==========================================//
                consignaController!['conAsignacion']!.isNotEmpty
                    ? _ListaGuardias(size: size, consigna: consignaController)
                    : Container(),
                //*****************************************/

                consignaController!['conFotosCliente']!.isNotEmpty
                    ? _CamaraOption(
                        size: size, consignaFotos: consignaController)
                    : Container(),
// //*****************************************/
              ],
            )),
      ),
    );
  }
}

class _ListaGuardias extends StatelessWidget {
  final dynamic consigna;
  const _ListaGuardias({
    required this.size,
    required this.consigna,
  });

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    List listaDeGuardias = [];
    for (var item in consigna!['conAsignacion']) {
      listaDeGuardias.add(item);
    }

    return Column(
      children: [
        Container(
          width: size.wScreen(100.0),
          margin: EdgeInsets.symmetric(
            vertical: size.iScreen(1.0),
            horizontal: size.iScreen(0.0),
          ),
          child: Text('Guardias:  ${listaDeGuardias.length}',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        Wrap(
          children: listaDeGuardias
              .map((e) => Card(
                    color: Colors.grey.shade300,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.iScreen(1.0),
                                vertical: size.iScreen(1.0)),
                            child: Text(
                              e['nombres'],
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.7),
                                  // color: Colors.black54,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _CamaraOption extends StatelessWidget {
  final dynamic consignaFotos;
  const _CamaraOption({
    required this.size,
    required this.consignaFotos,
  });

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    List listaDeFotos = [];
    for (var item in consignaFotos!['conFotosCliente']) {
      listaDeFotos.add(item['url']);
    }
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.wScreen(100.0),
            margin: EdgeInsets.symmetric(
              vertical: size.iScreen(1.0),
              horizontal: size.iScreen(0.0),
            ),
            child: Text('Fotografías: ${listaDeFotos.length}',
                style: GoogleFonts.lexendDeca(
                    fontWeight: FontWeight.normal, color: Colors.grey)),
          ),
          Wrap(
            children: listaDeFotos
                .map((e) => Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.iScreen(1.0),
                          vertical: size.iScreen(1.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: size.iScreen(0.0),
                            horizontal: size.iScreen(0.0),
                          ),
                          child: FadeInImage(
                            placeholder:
                                const AssetImage('assets/imgs/loader.gif'),
                            image: NetworkImage(
                              e,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}

Widget? getImage(String? picture) {
  if (picture == null) {
    return Image.asset('assets/imgs/no-image.png', fit: BoxFit.cover);
  }
  if (picture.startsWith('http')) {
    return const FadeInImage(
      placeholder: AssetImage('assets/imgs/loader.gif'),
      image: NetworkImage('url'),
    );
  }

  return Image.file(
    File(picture),
    fit: BoxFit.cover,
  );
}
