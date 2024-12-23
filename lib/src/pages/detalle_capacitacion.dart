import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/capacitaciones_controller.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/pages/views_pdf.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/utils/theme.dart';
import 'package:provider/provider.dart';

class DetalleDeCapacitacion extends StatelessWidget {
  final Session? usuario;
  const DetalleDeCapacitacion({super.key, this.usuario});

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final controller = context.read<CapacitacionesController>();
    final ctrlTheme = context.read<ThemeApp>();

    // print('USUARIO: ${usuario!.nombre}');
    Map<String, dynamic> infoCapacitado = {};
    if (int.parse(usuario!.id.toString()) !=
        int.parse(
            controller.getDataCapacitacion['capaIdCapacitador'].toString())) {
      //===========================//

      if (usuario!.rol!.contains('GUARDIA')) {
        for (var item in controller.getDataCapacitacion['capaGuardias']) {
          if (usuario!.usuario == item['perDocNumero']) {
            infoCapacitado.addAll(item);
          } else {
            infoCapacitado = {};
          }
        }
      } else if (usuario!.rol!.contains('SUPERVISOR')) {
        for (var item in controller.getDataCapacitacion['capaSupervisores']) {
          if (usuario!.usuario == item['perDocNumero']) {
            infoCapacitado.addAll(item);
          } else {
            infoCapacitado = {};
          }
        }
      } else if (usuario!.rol!.contains('ADMINISTRACION')) {
        for (var item in controller.getDataCapacitacion['capaAdministracion']) {
          if (usuario!.usuario == item['perDocNumero']) {
            infoCapacitado.addAll(item);
          } else {
            infoCapacitado = {};
          }
        }
      }
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
              'Detalle de Capacitación',
              // style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
            padding: EdgeInsets.only(
              top: size.iScreen(0.5),
              left: size.iScreen(0.5),
              right: size.iScreen(0.5),
              bottom: size.iScreen(0.5),
            ),
            width: size.wScreen(100.0),
            height: size.hScreen(100),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.0),
                  ),
                  //***********************************************/
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Título:',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                        Container(
                          child: Text(
                            controller.getDataCapacitacion['capaFecReg']
                                .toString()
                                .replaceAll("T", "  ")
                                .replaceAll(".000Z", " "),
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(0.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      '"${controller.getDataCapacitacion['capaTitulo']}"',
                      textAlign: TextAlign.center,
                      //
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.3),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //***********************************************/
                  Column(
                    children: [
                      SizedBox(
                        width: size.wScreen(100.0),
                        child: Text('Capacitador :',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      SizedBox(
                        // margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                        width: size.wScreen(100.0),
                        child: Text(
                          '${controller.getDataCapacitacion['capaNombreCapacitador']} ',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              // color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      //***********************************************/
                      SizedBox(
                        height: size.iScreen(0.5),
                      ),
                      //*****************************************/
                    ],
                  ),

                  // //***********************************************/
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                        // width: size.wScreen(100.0),
                        child: Text(
                          'Fecha Emisión:  ',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(1.5),
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                        child: Text(
                          controller.getDataCapacitacion['capaFecDesde']
                              .toString()
                              .replaceAll("T", " "),
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.7),
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                        child: Text(
                          'Fecha Finalización: ',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(1.5),
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                        child: Text(
                          controller.getDataCapacitacion['capaFecHasta']
                              .toString()
                              .replaceAll("T", " "),
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.7),
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  //***********************************************/
                  controller.getDataCapacitacion['capaDocumento'] == '' ||
                          controller.getDataCapacitacion['capaDocumento'] ==
                              null ||
                          controller
                              .getDataCapacitacion['capaDocumento'].isEmpty
                      ? Container()
                      : Column(
                          children: [
                            //*****************************************/

                            SizedBox(
                              height: size.iScreen(1.0),
                            ),
                            //*****************************************/
                            Container(
                              color: Colors.grey[100],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Ver Documento ',
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.8),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54)),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewsPDFs(
                                                  infoPdf:
                                                      '${controller.getDataCapacitacion['capaDocumento']}',
                                                  labelPdf: 'archivo.pdf')),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.remove_red_eye_outlined))
                                ],
                              ),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                        child: Text(
                          'Estado: ',
                          style: GoogleFonts.lexendDeca(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                        child: Text(
                          controller.getDataCapacitacion['capaEstado'],
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.7),
                              color: controller
                                          .getDataCapacitacion['capaEstado'] ==
                                      'FINALIZADA'
                                  ? secondaryColor
                                  : controller.getDataCapacitacion[
                                              'capaEstado'] ==
                                          'ACTIVA'
                                      ? tercearyColor
                                      : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //***********************************************/
                  Column(
                    children: [
                      SizedBox(
                        width: size.wScreen(100.0),
                        child: Text('Detalle :',
                            style: GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      SizedBox(
                        width: size.wScreen(100.0),
                        child: Text(
                          controller.getDataCapacitacion['capaDetalles'] ==
                                      '' ||
                                  controller.getDataCapacitacion[
                                          'capaDetalles'] ==
                                      null
                              ? '-- -- -- -- -- -- -- -- -- --   '
                              : '${controller.getDataCapacitacion['capaDetalles']} ',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              // color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      //***********************************************/
                      SizedBox(
                        height: size.iScreen(0.5),
                      ),
                      //*****************************************/
                    ],
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.5),
                  ),
                  //***********************************************/

                  //=============================================//

                  infoCapacitado.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              width: size.wScreen(100.0),
                              child: Row(
                                children: [
                                  Text('${infoCapacitado['perDocNumero']} ',
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.8),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey)),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text('Asistencia: ',
                                          style: GoogleFonts.lexendDeca(
                                              // fontSize: size.iScreen(2.0),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey)),
                                      Text(
                                          infoCapacitado['asistencia']
                                              ? 'SI   '
                                              : 'NO   ',
                                          style: GoogleFonts.lexendDeca(
                                              // fontSize: size.iScreen(2.0),
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  infoCapacitado['asistencia']
                                                      ? secondaryColor
                                                      : Colors.red)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //***********************************************/
                            SizedBox(
                              height: size.iScreen(0.5),
                            ),
                            //*****************************************/
                            SizedBox(
                              // margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                              width: size.wScreen(100.0),
                              child: Text(
                                '${infoCapacitado['perApellidos']} ${infoCapacitado['perNombres']} ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.8),
                                    // color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            infoCapacitado['perFoto'].isNotEmpty ||
                                    infoCapacitado['perFoto'] != ''
                                ? Column(
                                    children: [
                                      //***********************************************/
                                      SizedBox(
                                        height: size.iScreen(0.5),
                                      ),
                                      //*****************************************/
                                      SizedBox(
                                        width: size.wScreen(100.0),
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              'assets/imgs/loader.gif'),
                                          image: NetworkImage(
                                            '${infoCapacitado['perFoto']}}',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),

                            //***********************************************/
                            const Divider(),
                          ],
                        )
                      : Container(),

                  //=============================================//

                  int.parse(usuario!.id.toString()) ==
                          int.parse(controller
                              .getDataCapacitacion['capaIdCapacitador']
                              .toString())
                      ? Column(
                          children: [
                            SizedBox(
                              width: size.wScreen(100.0),
                              child: Text(' Nómina',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    // color: Colors.grey,
                                  )),
                            ),
                            //******************** MUESTRA LISTA DE GUARDIAS ***************************/
                            controller.getDataCapacitacion['capaGuardias']
                                    .isNotEmpty
                                ? Column(
                                    children: [
                                      //***********************************************/
                                      SizedBox(
                                        height: size.iScreen(0.5),
                                      ),
                                      //***********************************************/
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.iScreen(0.5)),
                                        width: size.wScreen(100.0),
                                        color: Colors.grey[300],
                                        child: Text(
                                            ' Guardias: ${controller.getDataCapacitacion['capaGuardias'].length}',
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
                                      Wrap(
                                        children:
                                            (controller.getDataCapacitacion[
                                                    'capaGuardias'] as List)
                                                .map(
                                                  (e) => Column(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            size.wScreen(100.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                '${e['perDocNumero']} ',
                                                                style: GoogleFonts
                                                                    .lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .grey)),
                                                            const Spacer(),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    'Asistencia: ',
                                                                    style: GoogleFonts.lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight: FontWeight.normal,
                                                                        color: Colors.grey)),
                                                                Text(
                                                                    e['asistencia']
                                                                        ? 'SI   '
                                                                        : 'NO   ',
                                                                    style: GoogleFonts.lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight: FontWeight.bold,
                                                                        color: e['asistencia'] ? secondaryColor : Colors.red)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //***********************************************/
                                                      SizedBox(
                                                        height:
                                                            size.iScreen(0.5),
                                                      ),
                                                      //*****************************************/
                                                      SizedBox(
                                                        width:
                                                            size.wScreen(100.0),
                                                        child: Text(
                                                          '${e['perApellidos']} ${e['perNombres']} ',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.8),
                                                                  // color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),

                                                      e['perFoto'].isNotEmpty ||
                                                              e['perFoto'] != ''
                                                          ? Column(
                                                              children: [
                                                                SizedBox(
                                                                  width: size
                                                                      .wScreen(
                                                                          100.0),
                                                                  child:
                                                                      FadeInImage(
                                                                    placeholder:
                                                                        const AssetImage(
                                                                            'assets/imgs/loader.gif'),
                                                                    image:
                                                                        NetworkImage(
                                                                      '${e['perFoto']}}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),

                                                      //***********************************************/
                                                      const Divider(),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                      //*****************************************/
                                    ],
                                  )
                                : Container(),
                            //******************** MUESTRA LISTA DE SUPERVISORES ***************************/
                            controller.getDataCapacitacion['capaSupervisores']
                                    .isNotEmpty
                                ? Column(
                                    children: [
                                      //***********************************************/
                                      SizedBox(
                                        height: size.iScreen(0.0),
                                      ),
                                      //***********************************************/
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.iScreen(0.5)),
                                        width: size.wScreen(100.0),
                                        color: Colors.grey[300],
                                        child: Text(
                                            ' Supervisores: ${controller.getDataCapacitacion['capaSupervisores'].length}',
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
                                      Wrap(
                                        children:
                                            (controller.getDataCapacitacion[
                                                    'capaSupervisores'] as List)
                                                .map(
                                                  (e) => Column(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            size.wScreen(100.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                '${e['perDocNumero']} ',
                                                                style: GoogleFonts
                                                                    .lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .grey)),
                                                            const Spacer(),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    'Asistencia: ',
                                                                    style: GoogleFonts.lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight: FontWeight.normal,
                                                                        color: Colors.grey)),
                                                                Text(
                                                                    e['asistencia']
                                                                        ? 'SI   '
                                                                        : 'NO   ',
                                                                    style: GoogleFonts.lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight: FontWeight.bold,
                                                                        color: e['asistencia'] ? secondaryColor : Colors.red)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //***********************************************/
                                                      SizedBox(
                                                        height:
                                                            size.iScreen(0.5),
                                                      ),
                                                      //*****************************************/
                                                      SizedBox(
                                                        // margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                                                        width:
                                                            size.wScreen(100.0),
                                                        child: Text(
                                                          '${e['perApellidos']} ${e['perNombres']} ',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.8),
                                                                  // color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      e['perFoto'].isNotEmpty ||
                                                              e['perFoto'] != ''
                                                          ? Column(
                                                              children: [
                                                                //***********************************************/
                                                                SizedBox(
                                                                  height: size
                                                                      .iScreen(
                                                                          0.5),
                                                                ),
                                                                //*****************************************/
                                                                SizedBox(
                                                                  width: size
                                                                      .wScreen(
                                                                          100.0),
                                                                  child:
                                                                      FadeInImage(
                                                                    placeholder:
                                                                        const AssetImage(
                                                                            'assets/imgs/loader.gif'),
                                                                    image:
                                                                        NetworkImage(
                                                                      '${e['perFoto']}}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),

                                                      //***********************************************/
                                                      const Divider(),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                      //*****************************************/
                                    ],
                                  )
                                : Container(),
                            //******************** MUESTRA LISTA DE ADMINISTRADORES ***************************/
                            controller.getDataCapacitacion['capaAdministracion']
                                    .isNotEmpty
                                ? Column(
                                    children: [
                                      //***********************************************/
                                      SizedBox(
                                        height: size.iScreen(0.5),
                                      ),
                                      //***********************************************/
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.iScreen(0.5)),
                                        width: size.wScreen(100.0),
                                        // alignment: Alignment.center,
                                        color: Colors.grey[300],
                                        child: Text(
                                            ' Administradores: ${controller.getDataCapacitacion['capaAdministracion'].length}',
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
                                      Wrap(
                                        children:
                                            (controller.getDataCapacitacion[
                                                        'capaAdministracion']
                                                    as List)
                                                .map(
                                                  (e) => Column(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            size.wScreen(100.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                '${e['perDocNumero']} ',
                                                                style: GoogleFonts
                                                                    .lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .grey)),
                                                            const Spacer(),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    'Asistencia: ',
                                                                    style: GoogleFonts.lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight: FontWeight.normal,
                                                                        color: Colors.grey)),
                                                                Text(
                                                                    e['asistencia']
                                                                        ? 'SI   '
                                                                        : 'NO   ',
                                                                    style: GoogleFonts.lexendDeca(
                                                                        // fontSize: size.iScreen(2.0),
                                                                        fontWeight: FontWeight.bold,
                                                                        color: e['asistencia'] ? secondaryColor : Colors.red)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //***********************************************/
                                                      SizedBox(
                                                        height:
                                                            size.iScreen(0.5),
                                                      ),
                                                      //*****************************************/
                                                      SizedBox(
                                                        // margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                                                        width:
                                                            size.wScreen(100.0),
                                                        child: Text(
                                                          '${e['perApellidos']} ${e['perNombres']} ',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.8),
                                                                  // color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      e['perFoto'].isNotEmpty ||
                                                              e['perFoto'] != ''
                                                          ? Column(
                                                              children: [
                                                                //***********************************************/
                                                                SizedBox(
                                                                  height: size
                                                                      .iScreen(
                                                                          0.5),
                                                                ),
                                                                //*****************************************/
                                                                SizedBox(
                                                                  width: size
                                                                      .wScreen(
                                                                          100.0),
                                                                  child:
                                                                      FadeInImage(
                                                                    placeholder:
                                                                        const AssetImage(
                                                                            'assets/imgs/loader.gif'),
                                                                    image:
                                                                        NetworkImage(
                                                                      '${e['perFoto']}}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),

                                                      //***********************************************/
                                                      const Divider(),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                      //*****************************************/
                                    ],
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
