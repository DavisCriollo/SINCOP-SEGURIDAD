import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/bitacora_controller.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/pages/view_image_generic.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class InfoVisita extends StatelessWidget {
  const InfoVisita({super.key});

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final user = context.read<HomeController>();
    final ctrlBitacora = context.read<BitacoraController>();
    final ctrlTheme = context.read<ThemeApp>();
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
          'Detalle de Visitante',
          // style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: size.iScreen(0.0)),
        padding: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
        width: size.wScreen(100.0),
        height: size.hScreen(100),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            Container(
                width: size.wScreen(100.0),
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${user.getUsuarioInfo!.rucempresa!}  ',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold)),
                    Text('-',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    Text('  ${user.getUsuarioInfo!.usuario!} ',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.iScreen(0.0), vertical: size.iScreen(0)),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.iScreen(1.0), vertical: size.iScreen(0.0)),
                child: Column(
                  children: [
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    SizedBox(
                      width: size.wScreen(100.0),
                      child: Row(
                        children: [
                          Text('Tipo de Ingreso: ',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                          Container(
                            // width: size.wScreen(100.0),
                            child: Text(
                                '${ctrlBitacora.getInfoVisita['bitTipoIngreso']}',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.grey
                                )),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: size.iScreen(0.5),
                    ),

                    SizedBox(
                      width: size.wScreen(100.0),
                      child: Text('Nombre:',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),

                    SizedBox(
                      height: size.iScreen(0.0),
                    ),
                    SizedBox(
                      width: size.wScreen(100.0),
                      child: Text(
                          '${ctrlBitacora.getInfoVisita['bitVisitanteNombres']}',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            fontWeight: FontWeight.normal,
                            // color: Colors.grey
                          )),
                    ),
                    //  Container(
                    //     width: size.wScreen(100.0),
                    //     child: Row(
                    //       children: [
                    //         Text('Sexo: ',
                    //             style: GoogleFonts.lexendDeca(
                    //                 fontSize: size.iScreen(1.8),
                    //                 fontWeight: FontWeight.normal,
                    //                 color: Colors.grey)),
                    //                   Container(
                    //     // width: size.wScreen(100.0),
                    //     child: Text(
                    //         'NOMBRE',
                    //         style: GoogleFonts.lexendDeca(
                    //             fontSize: size.iScreen(1.8),
                    //             fontWeight: FontWeight.normal,
                    //             // color: Colors.grey
                    //             )),
                    //   ),
                    //       ],
                    //     ),
                    //   ),
                    SizedBox(
                      width: size.wScreen(100.0),
                      child: Row(
                        children: [
                          Text('Documento: ',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                          Container(
                            // width: size.wScreen(100.0),
                            child: Text(
                                '${ctrlBitacora.getInfoVisita['bitVisitanteCedula']}',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  fontWeight: FontWeight.normal,
                                  // color: Colors.grey
                                )),
                          ),
                        ],
                      ),
                    ),

                    //***********************************************/
                    // _ctrlBitacora.getInfoVisita['bitFotoCedulaFrontal']!=''
                    //   ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ctrlBitacora.getInfoVisita['bitFotoPersona'] != ''
                            ? GestureDetector(
                                onTap: ctrlBitacora
                                            .getInfoVisita['bitFotoPersona'] !=
                                        ''
                                    ? () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => ImageViewGeneric(
                                                title: 'Foto Visitante',
                                                image:
                                                    '${ctrlBitacora.getInfoVisita['bitFotoPersona']}')));
                                      }
                                    : null,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.grey.shade300,
                                    ),
                                    width: size.iScreen(14.0),
                                    height: size.iScreen(18.0),
                                    child:
                                        //  valueListaVisitas.frontImage == null
                                        //     ? Icon(
                                        //         Icons.add_a_photo_outlined,
                                        //         size: size.iScreen(4.0),
                                        //       )
                                        //     :
                                        ctrlBitacora.getInfoVisita[
                                                    'bitFotoPersona'] !=
                                                ''
                                            ?
                                            // Image.file(File(_ctrlBitacora.getInfoVisita['bitFotoPersona']))
                                            Hero(
                                                tag:
                                                    '${ctrlBitacora.getInfoVisita['bitFotoPersona']}',
                                                child:
                                                    // FadeInImage(
                                                    //   placeholder: const AssetImage(
                                                    //       'assets/imgs/loader.gif'),
                                                    //   image: NetworkImage(
                                                    //     '${_ctrlBitacora.getInfoVisita['bitFotoPersona']}',
                                                    //   ),
                                                    // ),

                                                    FadeInImage(
                                                  placeholder: const AssetImage(
                                                      'assets/imgs/loader.gif'),
                                                  image: NetworkImage(
                                                    ctrlBitacora.getInfoVisita[
                                                            'bitFotoPersona'] ??
                                                        '',
                                                  ),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                        'assets/imgs/no-image.png'); // Imagen por defecto en caso de error
                                                  },
                                                ))
                                            : Image.asset(
                                                'assets/imgs/no-image.png',
                                                fit: BoxFit.cover)),
                              )
                            : Container(),
                        // :Container(),
                        ctrlBitacora.getInfoVisita['bitFotoCedulaFrontal'] != ''
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: ctrlBitacora.getInfoVisita[
                                                'bitFotoCedulaFrontal'] !=
                                            ''
                                        ? () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => ImageViewGeneric(
                                                    title:
                                                        'Foto Cédula - Frontal',
                                                    image:
                                                        '${ctrlBitacora.getInfoVisita['bitFotoCedulaFrontal']}')));
                                          }
                                        : null,
                                    child: Container(
                                        margin:
                                            EdgeInsets.all(size.iScreen(0.5)),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.grey.shade300,
                                        ),
                                        width: size.iScreen(17.0),
                                        height: size.iScreen(10.0),
                                        child:
                                            //  valueListaVisitas.frontImage == null
                                            //     ? Icon(
                                            //         Icons.add_a_photo_outlined,
                                            //         size: size.iScreen(4.0),
                                            //       )
                                            //     :
                                            //  Image.file(File(_ctrlBitacora.getInfoVisita['fotoCedula']['cedulaFront'])),
                                            ctrlBitacora.getInfoVisita[
                                                        'bitFotoCedulaFrontal'] !=
                                                    ''
                                                ? Hero(
                                                    tag:
                                                        '${ctrlBitacora.getInfoVisita['bitFotoCedulaFrontal']}',
                                                    child: FadeInImage(
                                                      placeholder: const AssetImage(
                                                          'assets/imgs/loader.gif'),
                                                      image: NetworkImage(
                                                        ctrlBitacora.getInfoVisita[
                                                                'bitFotoCedulaFrontal'] ??
                                                            '',
                                                      ),
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image.asset(
                                                            'assets/imgs/no-image.png'); // Imagen por defecto en caso de error
                                                      },
                                                    )
                                                    // FadeInImage(
                                                    //     placeholder: const AssetImage(
                                                    //         'assets/imgs/loader.gif'),
                                                    //     image: NetworkImage(
                                                    //       '${_ctrlBitacora.getInfoVisita['bitFotoCedulaFrontal']}',
                                                    //     ),
                                                    //   ),

                                                    )
                                                : Image.asset(
                                                    'assets/imgs/no-image.png',
                                                    fit: BoxFit.cover)),
                                  ),
                                  GestureDetector(
                                    onTap: ctrlBitacora.getInfoVisita[
                                                'bitFotoCedulaReverso'] !=
                                            ''
                                        ? () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => ImageViewGeneric(
                                                    title:
                                                        'Foto Cédula - Posterior',
                                                    image:
                                                        '${ctrlBitacora.getInfoVisita['bitFotoCedulaReverso']}')));
                                          }
                                        : null,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.grey.shade300,
                                        ),
                                        width: size.iScreen(17.0),
                                        height: size.iScreen(10.0),
                                        child:
                                            // valueListaVisitas.backImage == null
                                            //     ? Icon(
                                            //         Icons.add_a_photo_outlined,
                                            //         size: size.iScreen(4.0),
                                            //       )
                                            //     :
                                            ctrlBitacora.getInfoVisita[
                                                        'bitFotoCedulaReverso'] !=
                                                    ''
                                                ? Hero(
                                                    tag:
                                                        '${ctrlBitacora.getInfoVisita['bitFotoCedulaReverso']}',
                                                    child:
                                                        // FadeInImage(
                                                        //     placeholder: const AssetImage(
                                                        //         'assets/imgs/loader.gif'),
                                                        //     image: NetworkImage(
                                                        //       '${_ctrlBitacora.getInfoVisita['bitFotoCedulaReverso']}',
                                                        //     ),
                                                        //   ),
                                                        FadeInImage(
                                                      placeholder: const AssetImage(
                                                          'assets/imgs/loader.gif'),
                                                      image: NetworkImage(
                                                        ctrlBitacora.getInfoVisita[
                                                                'bitFotoCedulaReverso'] ??
                                                            '',
                                                      ),
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image.asset(
                                                            'assets/imgs/no-image.png'); // Imagen por defecto en caso de error
                                                      },
                                                    ))
                                                : Image.asset(
                                                    'assets/imgs/no-image.png',
                                                    fit: BoxFit.cover)
                                        // Image.file(File(_ctrlBitacora.getInfoVisita['fotoCedula']['cedulaBack'])),
                                        ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    // : Container(),

                    ctrlBitacora.getInfoVisita['fotoPasaporte'] != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: ctrlBitacora
                                            .getInfoVisita['fotoVisitante'] !=
                                        ''
                                    ? () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => ImageViewGeneric(
                                                title: 'Foto Visitante',
                                                image:
                                                    '${ctrlBitacora.getInfoVisita['fotoVisitante']}')));
                                      }
                                    : null,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.grey.shade300,
                                    ),
                                    width: size.iScreen(14.0),
                                    height: size.iScreen(18.0),
                                    child:
                                        //  valueListaVisitas.frontImage == null
                                        //     ? Icon(
                                        //         Icons.add_a_photo_outlined,
                                        //         size: size.iScreen(4.0),
                                        //       )
                                        //     :
                                        ctrlBitacora.getInfoVisita[
                                                    'fotoVisitante'] !=
                                                ''
                                            ?
                                            // Image.file(File(_ctrlBitacora.getInfoVisita['fotoVisitante']))
                                            Hero(
                                                tag:
                                                    '${ctrlBitacora.getInfoVisita['fotoVisitante']}',
                                                child:
                                                    // FadeInImage(
                                                    //     placeholder: const AssetImage(
                                                    //         'assets/imgs/loader.gif'),
                                                    //     image: NetworkImage(
                                                    //       '${_ctrlBitacora.getInfoVisita['fotoVisitante']}',
                                                    //     ),
                                                    //   ),
                                                    FadeInImage(
                                                  placeholder: const AssetImage(
                                                      'assets/imgs/loader.gif'),
                                                  image: NetworkImage(
                                                    ctrlBitacora.getInfoVisita[
                                                            'fotoVisitante'] ??
                                                        '',
                                                  ),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                        'assets/imgs/no-image.png'); // Imagen por defecto en caso de error
                                                  },
                                                ))
                                            : Image.asset(
                                                'assets/imgs/no-image.png',
                                                fit: BoxFit.cover)),
                              ),
                              GestureDetector(
                                onTap: ctrlBitacora
                                            .getInfoVisita['fotoPasaporte'] !=
                                        ''
                                    ? () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => ImageViewGeneric(
                                                title: 'Foto Pasaporte',
                                                image:
                                                    '${ctrlBitacora.getInfoVisita['fotoPasaporte']}')));
                                      }
                                    : null,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.grey.shade300,
                                    ),
                                    width: size.iScreen(18.0),
                                    height: size.iScreen(10.0),
                                    child:
                                        //  valueListaVisitas.pasaporteImage == null  && valueListaVisitas.pasaporteImage==''
                                        //     ? Icon(
                                        //         Icons.add_a_photo_outlined,
                                        //         size: size.iScreen(4.0),
                                        //       )
                                        //    :
                                        //  Image.file(File(_ctrlBitacora.getInfoVisita['fotoPasaporte'])),
                                        ctrlBitacora.getInfoVisita[
                                                    'fotoPasaporte'] !=
                                                null
                                            ? Hero(
                                                tag:
                                                    '${ctrlBitacora.getInfoVisita['fotoPasaporte']}',
                                                child:
                                                    // FadeInImage(
                                                    //     placeholder: const AssetImage(
                                                    //         'assets/imgs/loader.gif'),
                                                    //     image: NetworkImage(
                                                    //       '${_ctrlBitacora.getInfoVisita['fotoPasaporte']}',
                                                    //     ),
                                                    //   ),
                                                    FadeInImage(
                                                  placeholder: const AssetImage(
                                                      'assets/imgs/loader.gif'),
                                                  image: NetworkImage(
                                                    ctrlBitacora.getInfoVisita[
                                                            'fotoPasaporte'] ??
                                                        '',
                                                  ),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                        'assets/imgs/no-image.png'); // Imagen por defecto en caso de error
                                                  },
                                                ))
                                            : Image.asset(
                                                'assets/imgs/no-image.png',
                                                fit: BoxFit.cover)),
                              ),
                            ],
                          )
                        : Container(),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    ctrlBitacora.getInfoVisita['bitPlaca'].isNotEmpty
                        ? SizedBox(
                            width: size.wScreen(100.0),
                            child: Row(
                              children: [
                                Text('Vehículo: ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                                Container(
                                  // width: size.wScreen(100.0),
                                  child: Text(
                                      '${ctrlBitacora.getInfoVisita['bitPlaca']}',
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        fontWeight: FontWeight.normal,
                                        // color: Colors.grey
                                      )),
                                ),
                                ctrlBitacora.getInfoVisita['vehiculo'] == 'NO'
                                    ? Container(
                                        // width: size.wScreen(100.0),
                                        margin: EdgeInsets.only(
                                            left: size.iScreen(5.0)),
                                        child: Text(
                                            '${ctrlBitacora.getInfoVisita['vehiculo']}',
                                            style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.8),
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.grey
                                            )),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    ctrlBitacora.getInfoVisita['bitInformacionVehiculo']
                                ['model'] !=
                            ''
                        ? Column(
                            children: [
                              SizedBox(
                                width: size.wScreen(100.0),
                                child: Text('Modelo: ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              SizedBox(
                                height: size.iScreen(0.5),
                              ),
                              SizedBox(
                                width: size.wScreen(100.0),
                                child: Text(
                                    '${ctrlBitacora.getInfoVisita['bitInformacionVehiculo']['model']}',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      fontWeight: FontWeight.normal,
                                      // color: Colors.grey
                                    )),
                              ),
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                            ],
                          )
                        : Container(),

                    //***********************************************/
                    ctrlBitacora.getInfoVisita['bitFotoVehiculo'] != ''
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                  onTap: ctrlBitacora.getInfoVisita[
                                              'bitFotoVehiculo'] !=
                                          ''
                                      ? () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageViewGeneric(
                                                          title: 'Foto Placa',
                                                          image:
                                                              '${ctrlBitacora.getInfoVisita['bitFotoVehiculo']}')));
                                        }
                                      : null,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.grey.shade300,
                                      ),
                                      width: size.iScreen(18.0),
                                      height: size.iScreen(10.0),
                                      child:
                                          //  valueListaVisitas.placaImage == null
                                          //     ? Icon(
                                          //         Icons.add_a_photo_outlined,
                                          //         size: size.iScreen(4.0),
                                          //       )
                                          //     :
                                          // Image.file(File(_ctrlBitacora.getInfoVisita['fotoPlaca'])),
                                          ctrlBitacora.getInfoVisita[
                                                      'bitFotoVehiculo'] !=
                                                  ''
                                              ? Hero(
                                                  tag:
                                                      '${ctrlBitacora.getInfoVisita['bitFotoVehiculo']}',
                                                  child:
                                                      //  FadeInImage(
                                                      //     placeholder: const AssetImage(
                                                      //         'assets/imgs/loader.gif'),
                                                      //     image: NetworkImage(
                                                      //       '${_ctrlBitacora.getInfoVisita['bitFotoVehiculo']}',
                                                      //     ),
                                                      //   ),
                                                      FadeInImage(
                                                    placeholder: const AssetImage(
                                                        'assets/imgs/loader.gif'),
                                                    image: NetworkImage(
                                                      ctrlBitacora.getInfoVisita[
                                                              'bitFotoVehiculo'] ??
                                                          '',
                                                    ),
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                          'assets/imgs/no-image.png'); // Imagen por defecto en caso de error
                                                    },
                                                  ))
                                              : Image.asset(
                                                  'assets/imgs/no-image.png',
                                                  fit: BoxFit.cover))),
                            ],
                          )
                        : Container(),
                    //***********************************************/

                    ctrlBitacora.getInfoVisita['bitInformacionVehiculo']
                                ['dni'] !=
                            ''
                        ? Column(
                            children: [
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //*****************************************/
                              SizedBox(
                                width: size.wScreen(100.0),
                                child: Text('Documento: ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              SizedBox(
                                width: size.wScreen(100.0),
                                child: Text(
                                    '${ctrlBitacora.getInfoVisita['bitInformacionVehiculo']['dni']}',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      fontWeight: FontWeight.normal,
                                      // color: Colors.grey
                                    )),
                              ),
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //***********************************************/
                              //***********************************************/
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //*****************************************/
                              SizedBox(
                                width: size.wScreen(100.0),
                                child: Text('Propietario Vehiculo: ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              SizedBox(
                                width: size.wScreen(100.0),
                                child: Text(
                                    '${ctrlBitacora.getInfoVisita['bitInformacionVehiculo']['fullname']}',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      fontWeight: FontWeight.normal,
                                      // color: Colors.grey
                                    )),
                              ),
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                            ],
                          )
                        : Container(),

                    //***********************************************/

                    SizedBox(
                      height: size.iScreen(0.5),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.iScreen(0.5),
                              vertical: size.iScreen(0.2)),
                          width: size.wScreen(100.0),
                          // height: size.iScreen(0.5),
                          color: Colors.grey.shade100,
                          child: Text(
                            'Se dirije a : ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
                              // width: size.wScreen(100.0),
                              child: Text(
                                'Departamento : ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.8),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // width: size.iScreen(28.0),
                                // color: Colors.red,
                                margin: EdgeInsets.only(
                                    top: size.iScreen(0.5),
                                    bottom: size.iScreen(0.0)),

                                child: Text(
                                  ' ${ctrlBitacora.getInfoVisita['bitNombre_dpt']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
                              // width: size.wScreen(100.0),
                              child: Text(
                                'Número : ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.8),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // width: size.iScreen(28.0),
                                // color: Colors.red,
                                margin: EdgeInsets.only(
                                    top: size.iScreen(0.5),
                                    bottom: size.iScreen(0.0)),

                                child: Text(
                                  ' ${ctrlBitacora.getInfoVisita['bitNumero_dpt']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
                              // width: size.wScreen(100.0),
                              child: Text(
                                'Ubicación : ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.8),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // width: size.iScreen(28.0),
                                // color: Colors.red,
                                margin: EdgeInsets.only(
                                    top: size.iScreen(0.5),
                                    bottom: size.iScreen(0.0)),

                                child: Text(
                                  ' ${ctrlBitacora.getInfoVisita['bitCliUbicacion']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
                              // width: size.wScreen(100.0),
                              child: Text(
                                'Motivo : ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.8),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // width: size.iScreen(28.0),
                                // color: Colors.red,
                                margin: EdgeInsets.only(
                                    top: size.iScreen(0.5),
                                    bottom: size.iScreen(0.0)),

                                child: Text(
                                  ' ${ctrlBitacora.getInfoVisita['bitAsunto']}',
                                  // overflow:
                                  //     TextOverflow
                                  //         .ellipsis,
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.iScreen(1.0),
                        ),
                        SizedBox(
                          height: size.iScreen(0.5),
                        ),
                        Container(
                          width: size.wScreen(100.0),
                          height: size.iScreen(0.5),
                          color: Colors.grey.shade100,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.iScreen(0.5),
                    ),
                    SizedBox(
                      width: size.wScreen(100.0),
                      child: Text('Observación: ',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    SizedBox(
                      height: size.iScreen(0.5),
                    ),
                    SizedBox(
                      width: size.wScreen(100.0),
                      child: Text(
                          '${ctrlBitacora.getInfoVisita['bitObservacion']}',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            fontWeight: FontWeight.normal,
                            // color: Colors.grey
                          )),
                    ),

                    SizedBox(
                      height: size.iScreen(2.0),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
