import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/api/authentication_client.dart';
import 'package:nseguridad/src/controllers/actividades_asignadas_controller.dart';
import 'package:nseguridad/src/controllers/ausencias_controller.dart';
import 'package:nseguridad/src/controllers/avisos_controller.dart';
import 'package:nseguridad/src/controllers/bitacora_controller.dart';
import 'package:nseguridad/src/controllers/botonTurno_controller.dart';
import 'package:nseguridad/src/controllers/cambio_puesto_controller.dart';
import 'package:nseguridad/src/controllers/capacitaciones_controller.dart';
import 'package:nseguridad/src/controllers/cierre_bitacora_controller.dart';
import 'package:nseguridad/src/controllers/consignas_controller.dart';
import 'package:nseguridad/src/controllers/encuastas_controller.dart';
import 'package:nseguridad/src/controllers/evaluaciones_controller.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/controllers/multas_controller.dart';
import 'package:nseguridad/src/controllers/residentes_controller.dart';
import 'package:nseguridad/src/models/auth_response.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/pages/acceso_gps_page.dart';
import 'package:nseguridad/src/pages/alerta_page.dart';
import 'package:nseguridad/src/pages/editar_user_pass.dart';
import 'package:nseguridad/src/pages/list_gestion_documental.dart';
import 'package:nseguridad/src/pages/lista_bitacora.dart';
import 'package:nseguridad/src/pages/lista_cambio_puesto.dart';
import 'package:nseguridad/src/pages/lista_capacitaciones.dart';
import 'package:nseguridad/src/pages/lista_cierre_bitacora.dart';
import 'package:nseguridad/src/pages/lista_comunicados_guardias.dart';
import 'package:nseguridad/src/pages/lista_de_actividades.dart';
import 'package:nseguridad/src/pages/lista_encuestas_page.dart';
import 'package:nseguridad/src/pages/lista_evaluaciones_page.dart';
import 'package:nseguridad/src/pages/lista_faltas_injustificadas.dart';
import 'package:nseguridad/src/pages/lista_informes_guardias_page.dart';
import 'package:nseguridad/src/pages/lista_multas_supervisor_page.dart';
import 'package:nseguridad/src/pages/lista_residentes.dart';
import 'package:nseguridad/src/pages/lista_rol_pagos.dart';
import 'package:nseguridad/src/pages/lista_videos_ayuda.dart';
import 'package:nseguridad/src/pages/mis_notificaciones1_push.dart';
import 'package:nseguridad/src/pages/mis_notificaciones2_push.dart';
import 'package:nseguridad/src/pages/views_pdf.dart';
import 'package:nseguridad/src/service/local_notifications.dart';
import 'package:nseguridad/src/service/notification_push.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/urls/urls.dart';
import 'package:nseguridad/src/utils/call_phone.dart';
import 'package:nseguridad/src/utils/dialogs.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/features/shared/utils/responsive.dart' as respRiv;
import 'package:nseguridad/src/utils/sizeApp.dart';
import 'package:nseguridad/src/utils/theme.dart';
import 'package:nseguridad/src/widgets/no_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart' as prov;
import 'package:share_plus/share_plus.dart';

import '../../features/bitacora/presentation/screens/screens.dart';
import '../../features/shared/helpers/relevo.dart';
import '../../features/shared/provider/prendas_provider.dart';
import '../../features/shared/provider/provider_initial.dart';
// import 'package:url_launcher/url_launcher.dart';

class Home extends ConsumerStatefulWidget {
  final String? validaTurno;
  final String? ubicacionGPS;
  final Session? user;
  final List<String?>? tipo;
  final AuthResponse? dataUser;
  const Home(
      {super.key,
      this.validaTurno,
      this.ubicacionGPS,
      this.user,
      this.tipo,
      this.dataUser});

  @override
  ConsumerState<Home> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  final homeControl = HomeController();
  final socketService = SocketService();

  final ctrlTheme = ThemeApp();

  String marcaMovil = '';
  void initData() async {
//=======================================================================================================//

    WidgetsBinding.instance.addObserver(this);

    final serviceSocket =
        prov.Provider.of<SocketService>(context, listen: false);
    final homeController =
        prov.Provider.of<HomeController>(context, listen: false);
    // ===================== VERIFICO DE QUE DISPOSITIVO EL GUARDIA INICIA TURNO  ================//
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      // print('Running on ${webBrowserInfo.userAgent}');
      marcaMovil = '${webBrowserInfo.userAgent}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      marcaMovil = '${iosInfo.utsname.machine}';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      marcaMovil = '${androidInfo.model}';
    } else if (Platform.isWindows) {
// print('Running on ${windowsInfo.toMap().toString()}');  // e.g. "Moto G (4)"
    }

    homeController.setTipoDispositivo(marcaMovil);
// =======================================================================================//
    homeController.buscaNotificacionesMenu(context);
    homeController.buscaNotificacionesPush('');
    homeController.buscaNotificacionesPush2('');

    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      final infoUser = await Auth.instance.getSession();
      if (data['tabla'] == 'notificacionleido') {
        homeController.buscaNotificacionesPush('');
        homeController.buscaNotificacionesPush2('');
        // } else if (data['tabla'] == 'registro' && data['regCodigo'] == int.parse(_infoUser!.id.toString())) {
      } else if (data['tabla'] == 'registro') {
        //================= FINALIZO TURNO DE NUEVA FORMA ===================//
        _showAlertDialog(data);

        //====================================//
      }
    });
    serviceSocket.socket!.on('server:nuevanotificacion', (data) async {
      homeController.buscaNotificacionesPush('');
      homeController.buscaNotificacionesPush2('');
    });

    serviceSocket.socket?.on('server:error', (data) async {
      _showAlertDialog(data);
    });

//================================//
    PushNotificationService.messagesStream.listen((payload) {
//********************TRANSFORMO EL PAYLOAD EN UNA LISTA STRING***********************//
      final datos = payload.toString();
      final datosList = datos.replaceAll("{", "").replaceAll("}", "");
      final listInfo = datosList.split(',');

      //******************* VERIFICAMOS EL TIPO DE NOTIFICACION ************************//
      // print(" PAYLOAD DE NOTIFICACION  ******> : $payload");

//*******************************************//
      if (payload != '{}') {
        final perLugarTrabajo =
            listInfo[0].replaceAll('perLugarTrabajo: ', '').trim();

        final perCiudad = listInfo[1].replaceAll('perCiudad: ', '').trim();
        final notEmpresa = listInfo[2].replaceAll('notEmpresa: ', '').trim();
        final alerAsunto = listInfo[3].replaceAll('alerAsunto: ', '').trim();
        final notNombrePersona =
            listInfo[4].replaceAll('notNombrePersona: ', '').trim();

        double lat = double.parse(listInfo[6].toString().trim());
        double long = double.parse(
            listInfo[5].toString().replaceAll('coordenadas:', '').trim());

        final coordenadasItem = {
          "Longitud": long,
          "latitud": lat,
        };

        homeControl.setLatLong(lat, long);

        // print(
        //     'DESPUES DE LLENAR LA VARIABLE COORDENADAS DE ALERTA : $coordenadasItem');

        final perEmail = listInfo[7].replaceAll("perEmail:", "").trim();
        final List<String> listMail = perEmail.split(",");
        final perCelular = listInfo[8].replaceAll("perCelular:", "").trim();
        final List<String> listCelular = perCelular.split(",");

        final Map<String, dynamic> infoAlert = {};

        infoAlert.addAll({
          "perLugarTrabajo": perLugarTrabajo,
          "perCiudad": perCiudad,
          "notEmpresa": notEmpresa,
          "alerAsunto": alerAsunto,
          "notNombrePersona": notNombrePersona,
          "coordenadas": coordenadasItem,
          "perEmail": listMail,
          "perCelular": listCelular,
        });
        // print('INFO Q SE ENVIA A LA PANTALLA  DE ALERTA : $coordenadasItem');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => AlertaPage(notificacion: infoAlert)),
          ),
        ).then((value) {
          final dataAlerta = homeControl.getInfoNotificacionAlerta;
          homeControl.leerNotificacionPushGeneric(dataAlerta[0]);
          homeControl.buscaNotificacionesPush2('');
        });
      }
//********************************************//
    });

    homeControl.getAllMantenimientos();
    await homeControl.validaInicioDeSesion(context);
    // homeControl.getValidaTurnoServer(context);

    if (homeControl.getInfoMantenimiento.isNotEmpty) {
      _showMaintenanceAlert(context, homeControl.getInfoMantenimiento);
    }

    socketService.socket!.on('server:actualizadoExitoso', (data) async {
      final infoUser = await Auth.instance.getSession();
      if (data['tabla'] == 'notificacionleido') {
        homeControl.buscaNotificacionesPush('');
        homeControl.buscaNotificacionesPush2('');
        // } else if (data['tabla'] == 'registro' && data['regCodigo'] == int.parse(_infoUser!.id.toString())) {
      } else if (data['tabla'] == 'registro') {
        //================= FINALIZO TURNO DE NUEVA FORMA ===================//
        _showAlertDialog(data);

        //====================================//
      }
    });
    socketService.socket!.on('server:nuevanotificacion', (data) async {
      homeControl.buscaNotificacionesPush('');
      homeControl.buscaNotificacionesPush2('');
    });
    // socketService.socket!.on('server:nuevanotificacion', (data) async {
    //   homeController.buscaNotificacionesPush('');
    //   homeController.buscaNotificacionesPush2('');
    // });

    socketService.socket?.on('server:error', (data) async {
      _showAlertDialog(data);
    });
  }

//   @override
//   void dispose() {
//     WidgetsBinding.instance!.removeObserver(this);
//     super.dispose();
//   }

  final String _statusMessage = 'App is active';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);

      initData();
    });
    //   super.initState();
    super.initState();
    // WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // final homeController = Provider.of<HomeController>(context, listen: false);

    if (state == AppLifecycleState.resumed) {
      // await homeControl.validaInicioDeSesion(context);
      // homeControl.getAllMantenimientos();

      // homeControl.getValidaTurnoServer(context);

      homeControl.buscaNotificacionesPush('');
      homeControl.buscaNotificacionesPush2('');

      if (homeControl.getInfoMantenimiento.isNotEmpty) {
        _showMaintenanceAlert(context, homeControl.getInfoMantenimiento);
      }

      homeControl.setIndex(0);
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // print('EL ESTADO ES: $state');
      // homeControl.setGetTestTurno(null);
      // homeControl.setGetTestTurno(null);
    }
  }

  void listenNotifications() => LocalNotificationsService.onNotification.stream
      .listen(selectNotification);

  void selectNotification(String? payload) async {
    if (payload != null && payload.isNotEmpty && payload == 'ALERTA') {}
  }

  void isUpdate() async {
    await Auth.instance.deleteCache(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);
    final ctrlHome = context.read<HomeController>();
    final ctrlTheme = context.read<ThemeApp>();

    ctrlHome.buscaNotificacionesPush('');
    ctrlHome.buscaNotificacionesPush2('');

    final Responsive size = Responsive.of(context);
    return
        // UpgradeAlert(
        //   upgrader: Upgrader(
        //     onUpdate: () {
        //       print('SE REALIZA LA ACCION DE ACTUALIZAR');
        //       isUpdate();
        //       return true;
        //     },
        //     canDismissDialog: true,
        //     durationUntilAlertAgain: Duration(minutes: 1),
        //     showIgnore: false,
        //     showLater: false,
        //     languageCode: 'es',
        //     dialogStyle: Platform.isIOS
        //         ? UpgradeDialogStyle.cupertino
        //         : UpgradeDialogStyle.material,
        //   ),
        //   child:

        //   Scaffold(
        //     // backgroundColor: Colors.white,
        //     appBar: AppBar(
        //       flexibleSpace: Container(
        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             begin: Alignment.topLeft,
        //             end: Alignment.bottomRight,
        //             colors: <Color>[
        //               ctrlTheme.primaryColor,
        //               ctrlTheme.secondaryColor,
        //             ],
        //           ),
        //         ),
        //       ),
        //       // backgroundColor: ctrlTheme.primaryColor,
        //       centerTitle: false,
        //       title: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           //               IconButton(
        //           //               splashRadius: 20.0,
        //           //               onPressed: ()  {
        //           //                 // Navigator.of(context).push(
        //           //                 //                           MaterialPageRoute(
        //           //                 //                               builder: (context) =>
        //           //                 //                                   AcercaDePage(

        //           //                 //                                     )));

        //           //               },
        //           //               icon: Icon(Icons.contact_support_outlined,size: size.iScreen(3.5),)),

        //           // SizedBox(width: size.iScreen(2.0),),

        //           GestureDetector(
        //             onTap: () {
        //               // Navigator.of(context)
        //               //     .push(MaterialPageRoute(builder: (context) => Perfil()));
        //             },
        //             child: Container(
        //               margin: EdgeInsets.only(
        //                   bottom: size.iScreen(4.0),
        //                   top: size.iScreen(4.0),
        //                   right: size.iScreen(2.0)),
        //               width: size.iScreen(5.0),
        //               height: size.iScreen(5.0),
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(
        //                     100.0), // 50.0 es un radio grande para hacer la imagen completamente redonda
        //                 child: CachedNetworkImage(
        //                   imageUrl: '${ctrlHome.getUsuarioInfo!.logo}',
        //                   fit: BoxFit.fill,
        //                   placeholder: (context, url) =>
        //                       const CupertinoActivityIndicator(),
        //                   // Image.asset(
        //                   //     'assets/imgs/loader.gif'),

        //                   errorWidget: (context, url, error) =>
        //                       const Icon(Icons.error),
        //                 ),
        //                 //Image.asset('assets/imgs/no-image.jpg'),
        //               ),
        //             ),
        //           ),
        //           Container(
        //             // width: size.wScreen(55.0),
        //             child: Expanded(
        //               child: Text('${ctrlHome.getUsuarioInfo!.rucempresa}',
        //                   style: GoogleFonts.roboto(
        //                       fontSize: size.iScreen(3.0),
        //                       // color: Colors.black87,
        //                       fontWeight: FontWeight.normal)),
        //             ),
        //           ),
        //         ],
        //       ),
        //       actions: [
        //         // IconButton(
        //         //     splashRadius: 20.0,
        //         //     onPressed: () async {
        //         //       await salirApp();
        //         //     },
        //         //     icon: Icon(Icons.logout)),

        //         (widget.tipo!.contains('GUARDIA') ||
        //                 widget.tipo!.contains('SUPERVISOR') ||
        //                 widget.user!.usuario == 'talentohumano')
        //             ? Consumer<HomeController>(
        //                 builder: (_, valueNot1, __) {
        //                   return Container(
        //                       margin: EdgeInsets.symmetric(
        //                           horizontal: size.iScreen(1.0)),
        //                       // color: Colors.green,
        //                       width: size.iScreen(5.0),
        //                       height: size.iScreen(5.0),
        //                       child: GestureDetector(
        //                         onTap: (valueNot1.getBotonTurno)
        //                             ? () {
        //                                 valueNot1.buscaNotificacionesPush('');
        //                                 Navigator.of(context).push(
        //                                     MaterialPageRoute(
        //                                         builder: (context) =>
        //                                             ListaNotificacionesPush(
        //                                               session: widget.user,
        //                                             )));
        //                               }
        //                             : () {
        //                                 print('SIN TURNO');
        //                               },
        //                         child: Badge(
        //                           position:
        //                               const BadgePosition(top: 5.0, start: -0.0),
        //                           badgeContent: Text(
        //                               (valueNot1.getNumNotificaciones > 9)
        //                                   ? '9+'
        //                                   : (valueNot1.getNumNotificaciones == 0)
        //                                       ? ''
        //                                       : '${valueNot1.getNumNotificaciones}',
        //                               style: GoogleFonts.roboto(
        //                                 // fontSize: size.iScreen(2.5),
        //                                 color: Colors.white,
        //                                 fontWeight: FontWeight.bold,
        //                               )),
        //                           child: Icon(Icons.assignment_outlined),
        //                           badgeColor: (valueNot1.getNumNotificaciones == 0)
        //                               ? Colors.transparent
        //                               :
        //                               // appBarColor,
        //                               Colors.orange,
        //                           elevation:
        //                               (valueNot1.getNumNotificaciones == 0) ? 0 : 5,
        //                         ),
        //                       ));
        //                 },
        //               )
        //             : Container(),

        //         Consumer<HomeController>(
        //           builder: (_, valueNot2, __) {
        //             return Container(
        //                 margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
        //                 // color: Colors.blue,
        //                 width: size.iScreen(5.0),
        //                 height: size.iScreen(5.0),
        //                 child: GestureDetector(
        //                   onTap: (valueNot2.getBotonTurno)
        //                       ? () {
        //                           Provider.of<HomeController>(context,
        //                                   listen: false)
        //                               .buscaNotificacionesPush2('');
        //                           Navigator.of(context)
        //                               .push(MaterialPageRoute(
        //                                   builder: (context) =>
        //                                       // const ListaConsignasGuardiasPage()
        //                                       ListaNotificaciones2Push(
        //                                           user: widget.user)))
        //                               .then((value) =>
        //                                   valueNot2.buscaNotificacionesPush2(''));
        //                         }
        //                       : () {
        //                           print('SIN TURNO');
        //                         },
        //                   child: Badge(
        //                     position: const BadgePosition(top: 5.0, start: 25.0),
        //                     badgeContent: Text(
        //                       (valueNot2.getNumNotificaciones2 > 9)
        //                           ? '9+'
        //                           : (valueNot2.getNumNotificaciones2 == 0)
        //                               ? ''
        //                               : '${valueNot2.getNumNotificaciones2}',
        //                       style: GoogleFonts.roboto(
        //                         // fontSize: size.iScreen(2.5),
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                     child: const Icon(Icons.notifications_active_outlined),
        //                     badgeColor: (valueNot2.getNumNotificaciones2 == 0)
        //                         ? Colors.transparent
        //                         :
        //                         // appBarColor,
        //                         Colors.red.shade900,
        //                     elevation:
        //                         (valueNot2.getNumNotificaciones2 == 0) ? 0 : 5,
        //                   ),
        //                 ));
        //           },
        //         ),
        //       ],
        //     ),
        //   UpgradeAlert(
        // upgrader: Upgrader(
        //   onUpdate: () {
        //     print('SE REALIZA LA ACCION DE ACTUALIZAR');
        //     isUpdate();
        //     return true;
        //   },
        //   canDismissDialog: true,
        //   durationUntilAlertAgain: Duration(minutes: 1),
        //   showIgnore: false,
        //   showLater: false,
        //   languageCode: 'es',
        //   dialogStyle: Platform.isIOS
        //       ? UpgradeDialogStyle.cupertino
        //       : UpgradeDialogStyle.material,
        // ),
        // child:
        Scaffold(
      // backgroundColor: Colors.white,
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
        // backgroundColor: ctrlTheme.primaryColor,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Un-comment and customize if needed
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context)
            //         .push(MaterialPageRoute(builder: (context) => Perfil()));
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(
            //         bottom: size.iScreen(4.0),
            //         top: size.iScreen(4.0),
            //         right: size.iScreen(2.0)),
            //     width: size.iScreen(5.0),
            //     height: size.iScreen(5.0),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(
            //           100.0), // 50.0 es un radio grande para hacer la imagen completamente redonda
            //       child: CachedNetworkImage(
            //         imageUrl: '${ctrlHome.getUsuarioInfo!.logo}',
            //         fit: BoxFit.fill,
            //         placeholder: (context, url) =>
            //             const CupertinoActivityIndicator(),
            //         errorWidget: (context, url, error) =>
            //             const Icon(Icons.error),
            //       ),
            //     ),
            //   ),
            // ),

            GestureDetector(
              onTap: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => Perfil()));
              },
              child: Container(
                margin: EdgeInsets.only(
                    bottom: size.iScreen(4.0),
                    top: size.iScreen(4.0),
                    right: size.iScreen(2.0)),
                width: size.iScreen(5.0),
                height: size.iScreen(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      100.0), // 50.0 es un radio grande para hacer la imagen completamente redonda
                  child: CachedNetworkImage(
                    imageUrl: '${ctrlHome.getUsuarioInfo!.logo}',
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: Text('${ctrlHome.getUsuarioInfo!.rucempresa}',
                    style: GoogleFonts.roboto(
                        fontSize: size.iScreen(3.0),
                        fontWeight: FontWeight.bold)),
              ),
            ),
            // Consumer<BotonTurnoController>(builder: (_, values,__) {
            //   return

            //   Text(values.getTurnoBTN?'SI':'NO',
            //         style: GoogleFonts.roboto(
            //             fontSize: size.iScreen(3.0),
            //             fontWeight: FontWeight.normal));
            // },)
          ],
        ),
        actions: [
          (widget.tipo!.contains('GUARDIA') ||
                  widget.tipo!.contains('SUPERVISOR') ||
                  widget.user!.usuario == 'talentohumano')
              ? prov.Consumer<HomeController>(
                  builder: (_, valueNot1, __) {
                    return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
                        width: size.iScreen(5.0),
                        height: size.iScreen(5.0),
                        child: GestureDetector(
                          onTap: (valueNot1.getBotonTurno)
                              ? () {
                                  valueNot1.buscaNotificacionesPush('');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ListaNotificacionesPush(
                                            session: widget.user,
                                          )));
                                }
                              : () {
                                  // print('SIN TURNO');
                                  NotificatiosnService.showSnackBarDanger(
                                      'No tiene Turno Activo');
                                },
                          child: badges.Badge(
                              position: badges.BadgePosition.custom(
                                  top: -5.0, start: 20.0),
                              badgeContent: Text(
                                  (valueNot1.getNumNotificaciones > 9)
                                      ? '9+'
                                      : (valueNot1.getNumNotificaciones == 0)
                                          ? ''
                                          : '${valueNot1.getNumNotificaciones}',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              badgeStyle: badges.BadgeStyle(
                                badgeColor:
                                    (valueNot1.getNumNotificaciones == 0)
                                        ? Colors.transparent
                                        : Colors.orange,
                                elevation: (valueNot1.getNumNotificaciones == 0)
                                    ? 0
                                    : 5,
                              ),
                              child: Container(
                                  width: size.iScreen(3.0),
                                  child: Image.asset(
                                    'assets/imgs/Recurso.png',
                                    scale: 0.5,
                                  ))
                              //  const Icon(Icons.assignment_outlined),
                              ),
                        ));
                  },
                )
              : Container(),
          prov.Consumer<HomeController>(
            builder: (_, valueNot2, __) {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
                  width: size.iScreen(5.0),
                  height: size.iScreen(5.0),
                  child: GestureDetector(
                    onTap: (valueNot2.getBotonTurno)
                        ? () {
                            prov.Provider.of<HomeController>(context,
                                    listen: false)
                                .buscaNotificacionesPush2('');
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        ListaNotificaciones2Push(
                                            user: widget.user)))
                                .then((value) =>
                                    valueNot2.buscaNotificacionesPush2(''));
                          }
                        : () {
                            // print('SIN TURNO');
                            NotificatiosnService.showSnackBarDanger(
                                'No tiene Turno Activo');
                          },
                    child: badges.Badge(
                      position:
                          badges.BadgePosition.custom(top: 5.0, start: 25.0),
                      badgeContent: Text(
                        (valueNot2.getNumNotificaciones2 > 9)
                            ? '9+'
                            : (valueNot2.getNumNotificaciones2 == 0)
                                ? ''
                                : '${valueNot2.getNumNotificaciones2}',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: (valueNot2.getNumNotificaciones2 == 0)
                            ? Colors.transparent
                            : Colors.orange,
                        elevation:
                            (valueNot2.getNumNotificaciones2 == 0) ? 0 : 5,
                      ),
                      child: Icon(Icons.notifications_active,
                          size: size.iScreen(4.0)),
                    ),
                  ));
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          SizedBox(
            // color: Colors.grey,
            width: size.wScreen(100.0),
            height: size.hScreen(100.0),
            child: SingleChildScrollView(
              child: Center(
                child: _getPage(context, size, ctrlHome, screenSize),
              ),
            ),
          ),
          Positioned(
            bottom: -2.0,
            right: 10.0,
            child: GestureDetector(
              onTap: () {
                // _modalShare(context, size);
              },
              child: Row(
                children: [
                  SizedBox(
                      // color: Colors.red,
                      width: screenSize.width < 600
                          ? size.wScreen(20.0)
                          : size.wScreen(20.0),
                      child: Image.asset(
                        'assets/imgs/Guardias.png',
                      )),
                  Container(
                      padding: EdgeInsets.only(top: size.iScreen(1.5)),
                      child: Icon(
                        Icons.share,
                        size: size.iScreen(3.5),
                      ))
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5.0,
            left: 4.0,
            child: Text(
              'Ver: 1.0.8',
              style: GoogleFonts.roboto(
                fontSize: size.iScreen(1.7),
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      // bottomNavigationBar: Consumer<HomeController>(
      //   builder: (context, provider, child) {
      //     return Theme(
      //       data: Theme.of(context).copyWith(
      //         canvasColor:
      //             Colors.blue, // color de fondo del BottomNavigationBar
      //       ),
      //       child: BottomNavigationBar(
      //         items: <BottomNavigationBarItem>[
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.home_outlined),
      //             label: 'Inicio',
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.format_align_center_outlined),
      //             label: 'Menu',
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.assignment_outlined),
      //             label: 'Comunicados',
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.notifications_active_outlined),
      //             label: 'Notificaciones',
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.contact_support_outlined),
      //             label: 'Contátenos',
      //           ),
      //         ],
      //         currentIndex: provider.selectedIndex,
      //         selectedItemColor: Colors.black,
      //         onTap: (index) => provider.setIndex(index),
      //       ),
      //     );
      //   },
      // ),
      bottomNavigationBar: prov.Consumer<HomeController>(
        builder: (context, provider, child) {
          final themeModel = prov.Provider.of<ThemeApp>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: themeModel
                  .primaryColor, // color de fondo del BottomNavigationBar
            ),
            child: prov.Consumer<HomeController>(
              builder: (context, provider, child) {
                final themeModel = prov.Provider.of<ThemeApp>(context);

                return Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: themeModel
                        .primaryColor, // color de fondo del BottomNavigationBar
                    textTheme: Theme.of(context).textTheme.copyWith(
                          bodySmall: TextStyle(
                            color: themeModel.secondaryColor,
                          ), // color de texto no seleccionado
                        ),
                  ),
                  child: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: 'Inicio',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.format_align_center_outlined),
                        label: 'Menu',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.contact_support_outlined),
                        label: 'Quienes somos',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.video_collection),
                        label: 'Ayuda',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.logout),
                        label: 'Salir',
                      ),
                      // s
                    ],
                    currentIndex: provider.selectedIndex,
                    selectedItemColor: themeModel.secondaryColor,
                    unselectedItemColor:
                        Colors.white, // color de texto no seleccionado
                    onTap: (index) {
                      final ctrlBoton = context.read<BotonTurnoController>();
                      final paramsToLoad =
                          SessionParams(widget.user!, ctrlBoton.getTurnoBTN);
                      ref.read(userProvider.notifier).state = paramsToLoad;
                      provider.setIndex(index);
                      homeControl.validaInicioDeSesion(context);
                      if (widget.tipo!.contains('ADMIN')) {
                        ctrlBoton.setTurnoBTN(true);
                      } else {
                        provider.getValidaTurnoServer(context);
                      }

                      homeControl.getAllMantenimientos();
                      if (index == 3) {
                        provider.buscaBitacorasCierre('', 'false');
                        print('EL INDEX ES : $index');
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
    // );
  }

  Widget _getPage(BuildContext context, Responsive size,
      HomeController ctrlHome, screenSize) {
    final provider = prov.Provider.of<HomeController>(context);
    final ctrlTheme = context.read<ThemeApp>();
    switch (provider.selectedIndex) {
      case 0:
        return _informacionUsuario(
            size, ctrlHome, ctrlTheme, context, screenSize);
      case 1:
        return _menuPrincipal(size, ctrlHome);

      case 2:
        return _quienesSomos(size);
      case 3:
        return _videosAyuda(size);
      case 4:
        return
            // Padding(
            //   padding: EdgeInsets.all(size.iScreen(2.0)),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: <Widget>[
            //       SizedBox(height: size.iScreen(2.0)),
            //       Icon(Icons.exit_to_app,
            //           color: Colors.red, size: size.iScreen(5.0)),
            //       SizedBox(height: size.iScreen(2.0)),
            //       Text(
            //         'Cerrar Sesión',
            //         style: GoogleFonts.roboto(
            //             fontSize: size.iScreen(3.0),
            //             color: Colors.black87,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(height: size.iScreen(2.0)),
            //       Text(
            //         '¿Está seguro de que desea cerrar sesión?',
            //         style: GoogleFonts.roboto(
            //             fontSize: size.iScreen(2.5),
            //             color: Colors.black87,
            //             fontWeight: FontWeight.normal),
            //         textAlign: TextAlign.center,
            //       ),
            //       SizedBox(height: size.iScreen(2.0)),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: <Widget>[
            //           TextButton(
            //               onPressed: () async {
            //                 final _ctrlHome = context.read<HomeController>();

            //                 _ctrlHome.resetNotificaciones();
            //                 _ctrlHome.setGetTestTurno(false);
            //                 _ctrlHome.setBotonTurno(false);
            //                 provider.setIndex(0);
            //                   _ctrlHome.sentTokenDelete();
            //                 await Auth.instance.deleteTurnoSesion();
            //                 await Auth.instance.deleteSesion(context);
            //               },
            //               child: Text(
            //                 'ACEPTAR',
            //                 style: GoogleFonts.roboto(
            //                     fontSize: size.iScreen(1.8),
            //                     color: ctrlTheme.secondaryColor,
            //                     fontWeight: FontWeight.normal),
            //               )),
            //           TextButton(
            //             onPressed: () {
            //               provider.setIndex(0);
            //             },
            //             child: Text(
            //               'CANCELAR',
            //               style: GoogleFonts.roboto(
            //                   fontSize: size.iScreen(1.7),
            //                   color: Colors.red.shade900,
            //                   fontWeight: FontWeight.normal),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // );
            Padding(
          padding: EdgeInsets.all(size.iScreen(2.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: size.iScreen(2.0)),
              Icon(
                Icons.logout, // Cambiado a un icono más adecuado
                color: Colors.red,
                size: size.iScreen(5.0),
              ),
              SizedBox(height: size.iScreen(2.0)),
              Text(
                'Cerrar Sesión',
                style: GoogleFonts.roboto(
                  fontSize: size.iScreen(3.0),
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.iScreen(2.0)),
              Text(
                '¿Está seguro de que desea cerrar sesión?',
                style: GoogleFonts.roboto(
                  fontSize: size.iScreen(2.5),
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.iScreen(2.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          ctrlTheme.secondaryColor, // Color del texto del botón
                    ),
                    onPressed: () async {
                      final ctrlHome0 = context.read<HomeController>();

                      ctrlHome0.resetNotificaciones();
                      ctrlHome0.setGetTestTurno(false);
                      ctrlHome0.setBotonTurno(false);
                      provider.setIndex(0);

                      ctrlHome0.sentTokenDelete();
                      await Auth.instance.deleteTurnoSesion();

                      await Auth.instance.deleteSesion(context);
                    },
                    child: Text(
                      'ACEPTAR',
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(1.8),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade900,
                      side: BorderSide(
                          color: Colors.red.shade900), // Borde del botón
                    ),
                    onPressed: () {
                      provider.setIndex(0);
                    },
                    child: Text(
                      'CANCELAR',
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(1.7),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      default:
        return Container();
    }
  }

  SingleChildScrollView _quienesSomos(Responsive size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(size.iScreen(1.0)),
            // color: Colors.red,
            width: size.wScreen(100),
            height: size.hScreen(15),
            child: SizedBox(
              width: size.wScreen(15),
              height: size.hScreen(15),
              child: Image.asset(
                'assets/imgs/Recurso.png',
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: size.iScreen(2.0), vertical: size.iScreen(0.0)),
            // color: Colors.blue,
            width: size.wScreen(100),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.iScreen(2.0),
                          vertical: size.iScreen(0.0)),
                      child: Text(
                        'Versión. 1.0.8',
                        style: GoogleFonts.roboto(
                            fontSize: size.iScreen(1.6),
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: size.iScreen(1.6)),
                      child: Text(
                        // 'Neitor, está diseñado por "2JL Soluciones Integrales".      \nSomos una empresa dedicada al desarrollo de software utilizando tegnología de banguardia comprometidos con nuestros clientes para darle soluciones a todas sus necesidaddes tecnologicas.',
                        'Sincop es un sistema integral de seguridad que protege a tu empres con tecnología avanzada y expertos dedicados. Además, ofrecemos asesoría y desarrollo de software personalizado, creando soluciones innovadoras y eficientes adaptadas a las necesidades de nuestros clientes.',
                        style: GoogleFonts.roboto(
                            fontSize: size.iScreen(1.8),
                            color: Colors.black45,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: size.iScreen(2.0),
                      right: size.iScreen(2.0),
                      top: size.iScreen(2.0),
                      bottom: size.iScreen(1.0)),
                  child: Text(
                    'Contáctenos:',
                    style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.0),
                        color: Colors.black87,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Soporte 24/7 :  ',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          color: Colors.black87,
                          fontWeight: FontWeight.normal),
                    ),
                    GestureDetector(
                      onLongPress: () => callNumber('+593986811138'),
                      child: Text(
                        '+593986811138',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            color: const Color(0xFF4064AD),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Desarrollo :  ',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          color: Colors.black87,
                          fontWeight: FontWeight.normal),
                    ),
                    GestureDetector(
                      onLongPress: () => callNumber('+593980290473'),
                      child: Text(
                        '+593980290473',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            color: const Color(0xFF4064AD),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.iScreen(1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Text(
                          'soporte@sincop.app',
                          style: GoogleFonts.roboto(
                              fontSize: size.iScreen(2.0),
                              color: const Color(0xFF4064AD),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          urlSendEmail('soporte@sincop.app');
                        },
                      ),
                      GestureDetector(
                        child: Text(
                          'soporte@2jl.ec',
                          style: GoogleFonts.roboto(
                              fontSize: size.iScreen(2.0),
                              color: const Color(0xFF4064AD),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () => urlSendEmail('soporte@2jl.ec'),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.iScreen(2.0),
                          vertical: size.iScreen(1.0)),
                      child: Text(
                        'Visita nuestra web',
                        style: GoogleFonts.roboto(
                            fontSize: size.iScreen(2.0),
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(0.0),
                            vertical: size.iScreen(0.5)),
                        child: Text(
                          'https://sincop.app',
                          style: GoogleFonts.roboto(
                              fontSize: size.iScreen(2.0),
                              color: const Color(0xFF51C1E1),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () => launchUrlsNeitor('https://sincop.app/'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // INSTAGRAM
                    // _ItemsSocials(
                    //   size: size,
                    //   icon: FontAwesomeIcons.instagram,
                    //   color: const Color(0xFFD04768),
                    //   onTap: () => abrirPaginaNeitor(),
                    // ),
                    //FACEBOOK
                    // _ItemsSocials(
                    //     size: size,
                    //     icon: FontAwesomeIcons.facebookF,
                    //     color: const Color(0xFF4064AD),
                    //     onTap: () => null // abrirPaginaNeitor(),
                    //     ),

                    //TWITTER
                    // _ItemsSocials(
                    //   size: size,
                    //   icon: FontAwesomeIcons.twitter,
                    //   color: const Color(0xFF00B1EA),
                    //   onTap: () => abrirPaginaNeitor(),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _videosAyuda(Responsive size) {
    return Container(
      height: MediaQuery.of(context).size.height, // Limita la altura total
      child: prov.Consumer<HomeController>(builder: (_, videoProvider, __) {
        return Column(
          children: [
            // Caja de texto fija
            Padding(
              padding: EdgeInsets.all(size.iScreen(1.0)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar videos',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: size.iScreen(1.5),
                    horizontal: size.iScreen(1.0),
                  ),
                ),
                onChanged: (text) {
                  // Lógica de búsqueda para filtrar los videos
                  videoProvider.search(text);
                },
              ),
            ),
            // Lista desplazable
            Expanded(
              child: videoProvider.allItemsFilters.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(), // Progreso centrado
                    )
                  : ListView.builder(
                      itemCount: videoProvider.allItemsFilters.length,
                      itemBuilder: (context, index) {
                        var item = videoProvider.allItemsFilters[index];
                        var sidInfo = item['sidInfo'];

                        return Card(
                          color: Colors.grey.shade200,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(1.0)),
                            title: Text(
                              sidInfo['name'],
                              style: GoogleFonts.roboto(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(sidInfo['descripcion'] ?? ''),
                            children: [
                              Wrap(
                                children: (item['tutoContenido'] as List)
                                    .map((e) => Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: size.iScreen(0.5),
                                            horizontal: size.iScreen(1.0),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          VideoPlayerScreen(
                                                            infoVideo: e,
                                                          ))));
                                            },
                                            trailing: Icon(Icons.video_file,
                                                color:
                                                    ctrlTheme.secondaryColor),
                                            tileColor: Colors.grey.shade50,
                                            title: Text(
                                              "${e['nombreVideo']}",
                                              style: GoogleFonts.roboto(
                                                fontSize: size.iScreen(2.0),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${e['descVideo']}",
                                              style: GoogleFonts.roboto(
                                                fontSize: size.iScreen(1.8),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Container _menuPrincipal(Responsive size, HomeController ctrlHome) {
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            prov.Consumer<BotonTurnoController>(
              builder: (_, value, __) {
                return
                    //  value.getTurnoBTN?
                    Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //*****************************************/
                    Container(
                        width: size.wScreen(100.0),
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${ctrlHome.getUsuarioInfo!.rucempresa!}  ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.7),
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold)),
                            Text('-',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.7),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                            Text('  ${ctrlHome.getUsuarioInfo!.usuario!} ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.7),
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),

                    //====================EL MENU BOTONERA=======================//
                    gruposItemMenuNovedades(size, 'Novedades'),
                    widget.user!.rol!.contains('SUPERVISOR') ||
                            widget.user!.rol!.contains('GUARDIA') ||
                            widget.user!.rol!.contains('ADMINISTADOR') ||
                            widget.user!.rol!.contains('ADMINISTRACION') ||
                            widget.user!.rol!.contains('ADMIN')
                        ? gruposItemMenuGestionIntegral(
                            size, 'Gestión Integral')
                        : Container(),

                    gruposItemMenuBitacora(size, 'Bitácora'),
                    //===========================================================//
                  ],
                );
                // :Center(child: NoData(label: 'NO TIENE TURNO ACTIVO ESTE MOMENTO...'));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _informacionUsuario(Responsive size, HomeController ctrlHome,
      ThemeApp ctrlTheme, BuildContext context, ScreenSize screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment
          .spaceAround, // Distribuye los contenedores uniformemente

      children: [
        Container(
          // color: Colors.blue,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      // color:Colors.amber,
                      width: size.wScreen(55),
                      height: screenSize.width < 600
                          ? size.hScreen(16)
                          : size.hScreen(25),
                      child: GestureDetector(
                        onTap: () {
                          _modalReportes(context, size, widget.user);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${ctrlHome.getUsuarioInfo!.nombre}',
                              style: GoogleFonts.roboto(
                                  fontSize: size.iScreen(2.2),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: size.iScreen(0.5),
                            ),
                            SizedBox(
                              width: size.wScreen(100.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: SelectableText(
                                        '${ctrlHome.getUsuarioInfo!.usuario}',
                                        style: GoogleFonts.roboto(
                                            fontSize: size.iScreen(2.0),
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.iScreen(2.0),
                                    ),
                                    Icon(
                                      Icons.manage_accounts,
                                      size: size.iScreen(3.0),
                                      color: ctrlTheme.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.iScreen(0.5),
                                  horizontal: size.iScreen(0.5)),
                              // height:size.iScreen(5.0),
                              width: size.wScreen(100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.assignment_ind_outlined,
                                    size: size.iScreen(3.0),
                                  ),
                                  ctrlHome.getUsuarioInfo!.rol!.isNotEmpty
                                      ? Text(
                                          '${ctrlHome.getUsuarioInfo!.areadepartamento}',
                                          style: GoogleFonts.roboto(
                                              fontSize: size.iScreen(1.7),
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.center,
                                        )
                                      //  Wrap(
                                      //     children:
                                      //         ctrlHome.getUsuarioInfo!.rol!
                                      //             .map((e) => Text(
                                      //                  ': ${e} ',
                                      //                   style: GoogleFonts.roboto(
                                      //                       fontSize: size
                                      //                           .iScreen(
                                      //                               1.7),
                                      //                       color: Colors
                                      //                           .black,
                                      //                       fontWeight:
                                      //                           FontWeight
                                      //                               .normal),
                                      //                   textAlign: TextAlign
                                      //                       .justify,
                                      //                 ))
                                      //             .toList(),
                                      //   )
                                      : Text(
                                          ': Sin Perfil',
                                          style: GoogleFonts.roboto(
                                              fontSize: size.iScreen(1.7),
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.justify,
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  // btnAlerta(size),

                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) => Perfil()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(size.iScreen(0.5)),
                      width: size.iScreen(12.0),
                      height: size.iScreen(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            100.0), // 50.0 es un radio grande para hacer la imagen completamente redonda
                        child: ctrlHome.getUsuarioInfo!.foto == null
                            ? Image.asset('assets/imgs/no-image.png')
                            : CachedNetworkImage(
                                imageUrl: '${ctrlHome.getUsuarioInfo!.foto}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                // Image.asset(
                                //     'assets/imgs/loader.gif'),

                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: size.iScreen(8.0),
                                  color: Colors.grey,
                                ),
                                // Image.asset('assets/imgs/no-image.png'),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              //========================  BOTON ALERTA Y  TURNO ===========================//
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    btnAlerta(size),
                    btnTurnoPrincipal(size, ctrlTheme),
                  ],
                ),
              ),
              //=========================================================================//
            ],
          ),
          // Center(
          //   child: Text(
          //     'Contenedor 1',
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ),
        // Container(
        //   color: Colors.grey.shade300,
        //   height: size.iScreen(0.5),
        //   width: size.wScreen(80),
        // ),

        // btnAlerta(size),

        //  Container(
        // color: Colors.grey,
        // height: size.iScreen(0.2),
        // width: size.wScreen(80),
        // ),
        // Container(

        //   color: Colors.grey.shade300,
        //   padding: EdgeInsets.symmetric(
        //       vertical: size.iScreen(0.5),
        //       horizontal: size.iScreen(0.5)),
        //   // height:size.iScreen(0.2),
        //   width: size.wScreen(80),
        //   child: Center(
        //     child: Text(
        //           'Turno',
        //           style: GoogleFonts.roboto(
        //               fontSize: size.iScreen(2.5),
        //               color: Colors.black,
        //               fontWeight: FontWeight.bold),
        //           textAlign: TextAlign.justify,
        //         ),
        //   )
        // ),
        // Container(
        //   color: Colors.grey.shade300,
        //   height: size.iScreen(0.5),
        //   width: size.wScreen(80),
        // ),
        //*****************************//
        //     Expanded(
        //       flex: 3, // Proporción de flexibilidad del segundo contenedor
        //       child:
        //       Container(
        //   //       decoration: BoxDecoration(
        //   //     color: Colors.grey.shade100,
        //   //   borderRadius: BorderRadius.circular(10.0),
        //   // ),
        //   margin: EdgeInsets.only(
        //      top:size.iScreen(1.0),
        //       right: size.iScreen(0.0), left: size.iScreen(0.0)),
        //           alignment: Alignment.center,
        //           // color: Colors.grey.shade200,
        //           child:
        //               //**************** MENU BOTONES ***********//
        //               // menuPrincipalCircular(size, context, ctrlTheme)
        //               //****************  BOTON INICAR TURNO  ***********//

        //               Column(
        //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                 children: [
        //                   // btnTurnoPrincipal(size, ctrlTheme),
        // //***********************************************//
        // infoMantenimiento(size) ,//////   AQUI MOSTRAR BANNER IINIFORMATIVO

        Container(
          margin: EdgeInsets.symmetric(
              vertical: size.iScreen(2.0), horizontal: size.iScreen(2.0)),
          // color: Colors.red,
          width: size.wScreen(100.0),
          height: size.hScreen(40.0),

          alignment: Alignment.center,
          child: Text(
            'Sistema integrado de seguridad,',
            style: GoogleFonts.roboto(
              fontSize: size.iScreen(2.0),
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //                 ],
        //               )),
        //     ),

        //*************************//
      ],
    );
  }

  _callNumber(String numero) async {
    await FlutterPhoneDirectCaller.callNumber(numero);
  }

  Row itemInfoEmpresa(
    Responsive size,
    ThemeApp ctrlTheme,
    IconData icon,
    String label,
    void Function() onTap,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: size.iScreen(4.0),
          color: ctrlTheme.secondaryColor,
        ),
        GestureDetector(
          onLongPress: onTap,
          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: size.iScreen(2.0),
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Container infoMantenimiento(Responsive size) {
    return Container(
      margin: EdgeInsets.only(
        top: size.iScreen(1.0),
        left: size.iScreen(1.0),
        right: size.iScreen(1.0),
        bottom: size.iScreen(2.0),
      ),
      padding: EdgeInsets.all(size.iScreen(1.5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.iScreen(1.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Notificación de Mantenimiento',
                style: GoogleFonts.roboto(
                  fontSize: size.iScreen(1.7),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                radius: size.iScreen(2.1),
                backgroundColor: Colors.yellow[700],
                child: Icon(
                  Icons.build,
                  color: Colors.white,
                  size: size.iScreen(2.8),
                ),
              ),
            ],
          ),
          SizedBox(height: size.iScreen(1.0)),
          SizedBox(
            width: size.wScreen(100.0),
            child: Text(
              'Estimado usuario,',
              style: GoogleFonts.roboto(
                fontSize: size.iScreen(1.7),
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: size.iScreen(1.0)),
          Text(
            'Nuestro sistema estará en mantenimiento el día de mañana a partir de las 18:00 hasta las 00:00. Durante este periodo, es posible que nuestros servicios no estén disponibles. Agradecemos su comprensión y paciencia.',
            style: GoogleFonts.roboto(
              fontSize: size.iScreen(1.7),
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: size.iScreen(1.0)),
          Text(
            'Atentamente,',
            style: GoogleFonts.roboto(
              fontSize: size.iScreen(1.6),
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: size.iScreen(1.0)),
          Text(
            'El equipo de soporte técnico',
            style: GoogleFonts.roboto(
              fontSize: size.iScreen(1.6),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.iScreen(1.0)),
        ],
      ),
    );
  }

  prov.Consumer<HomeController> menuPrincipalCircular(
      Responsive size, BuildContext context, ThemeApp ctrlTheme) {
    return prov.Consumer<HomeController>(
      builder: (_, valueBotones, __) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  // color: Colors.amberAccent,
                  width: size.wScreen(100.0),
                  // height: size.hScreen(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      btnItem(
                          context,
                          size,
                          'Actividades',
                          Icons.streetview_outlined,
                          // Color(0XFF610C9F),
                          ctrlTheme.combinedColors[0],
                          valueBotones,
                          valueBotones.getgetTestTurno == true
                              ? () {
                                  final controller = context
                                      .read<ActividadesAsignadasController>();
                                  controller.setLabelActividad('DEL DIA');
                                  controller.getActividadesAsignadas(
                                      '', 'false');

                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const ListaDeActividades(
                                                  // tipo: widget.tipo,
                                                  // usuario: widget.user,
                                                  )))
                                      .then((value) {
                                    controller.borrarDatos();
                                  });
                                }
                              : () {}),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          btnItem(
                              context,
                              size,
                              'Informes',
                              Icons.analytics_outlined,
                              // Color(0XFF940B92),
                              ctrlTheme.combinedColors[1],
                              valueBotones, () {
                            if (valueBotones.getgetTestTurno == true) {
                              if ((widget.tipo!.contains('GUARDIA') ||
                                  widget.tipo!.contains('SUPERVISOR'))) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ListaInformesGuardiasPage(
                                            usuario: widget.user)));
                              }
                            } else {
                              NotificatiosnService.showSnackBarDanger(
                                  'NO HA INICIADO TURNO');
                            }
                          }),
                          btnTurno(size, Colors.blue, valueBotones),
                          btnItem(
                              context,
                              size,
                              'Consignas',
                              Icons.assignment_turned_in_outlined,
                              // Color(0XFFDA0C81),
                              ctrlTheme.combinedColors[2],
                              valueBotones, () {
                            if (valueBotones.getgetTestTurno == true) {
                              if ((widget.tipo!.contains('GUARDIA') ||
                                  widget.tipo!.contains('SUPERVISOR'))) {
                                prov.Provider.of<ConsignasController>(context,
                                        listen: false)
                                    .getTodasLasConsignasClientes('', 'false');
                                if (widget.tipo!.contains('GUARDIA') ||
                                    widget.tipo!.contains('SUPERVISOR')) {
                                  Navigator.pushNamed(
                                      context, 'listaConsignasGuardias');
                                }
                              } else {}
                            } else {
                              if ((widget.tipo!.contains('CLIENTE'))) {
                                prov.Provider.of<ConsignasController>(context,
                                        listen: false)
                                    .getTodasLasConsignasClientes('', 'false');
                                if (widget.tipo!.contains('CLIENTE')) {
                                  Navigator.pushNamed(
                                      context, 'listaConsignasClientes');
                                }
                              }
                              //  NotificatiosnService.showSnackBarDanger('NO HA INICIADO TURNO');
                            }
                          }),
                        ],
                      ),
                      btnItem(
                          context,
                          size,
                          'Comunicados',
                          Icons.list_alt,
                          // Color(0XFFE95793),
                          ctrlTheme.combinedColors[3],
                          valueBotones, () {
                        if (valueBotones.getgetTestTurno == true) {
                          if ((widget.tipo!.contains('GUARDIA') ||
                              widget.tipo!.contains('SUPERVISOR'))) {
                            prov.Provider.of<AvisosController>(context,
                                    listen: false)
                                .getTodosLosAvisos('', 'false');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ListaComunicadosGuardiasPage()));
                          }
                        } else {
                          if ((widget.tipo!.contains('CLIENTE'))) {
                            prov.Provider.of<ConsignasController>(context,
                                    listen: false)
                                .getTodasLasConsignasClientes('', 'false');
                            Navigator.pushNamed(
                                context, 'listaConsignasClientes');
                          }
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget gruposItemMenuNovedades(
    Responsive size,
    // HomeController ctrlHome,
    String titulo,
  ) {
    return prov.Consumer<HomeController>(
      builder: (_, ctrlHome, __) {
        return ExpansionTile(
          initiallyExpanded: true,
          title: SizedBox(
            width: size.wScreen(100),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: size.iScreen(2.3),
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Column(
              children: [
                // SizedBox(
                //   width: size.wScreen(100),
                //   child: Text(
                //     titulo,
                //     textAlign: TextAlign.center,
                //     style: GoogleFonts.roboto(
                //       fontSize: size.iScreen(2.5),
                //       color: Colors.black87,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: size.iScreen(1),
                ),
                Container(
                  width: size.wScreen(60),
                  height: size.iScreen(0.3),
                  color: Colors.grey.shade300,
                ),
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    //==================================================//
                    prov.Consumer<BotonTurnoController>(builder:
                        (BuildContext context, ctrlHome, Widget? child) {
                      return _itemsMenuLateral(
                        size,
                        'Actividades',
                        Icons.streetview_outlined,
                        ctrlTheme.combinedColors[0],
                        ctrlHome.getTurnoBTN == true
                            ? () async {
                                bool isGpsEnabled = await context
                                    .read<HomeController>()
                                    .checkGpsStatus();
                                if (!isGpsEnabled) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AccesoGPSPage()),
                                  );
                                } else {
                                  final controller = context
                                      .read<ActividadesAsignadasController>();
                                  controller.setLabelActividad('DEL DIA');
                                  controller.getActividadesAsignadas(
                                      '', 'false');

                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const ListaDeActividades(
                                                  // tipo: widget.tipo,
                                                  // usuario: widget.user,
                                                  )))
                                      .then((value) {
                                    controller.borrarDatos();
                                  });
                                }
                              }
                            : () {},
                        'ACTIVIDAD',
                      );
                    }),
                    prov.Consumer<BotonTurnoController>(builder:
                        (BuildContext context, ctrlHome, Widget? child) {
                      return _itemsMenuLateral(
                        size,
                        'Informes',
                        Icons.analytics_outlined,
                        ctrlTheme.combinedColors[1],
                        () async {
                          bool isGpsEnabled = await context
                              .read<HomeController>()
                              .checkGpsStatus();
                          if (!isGpsEnabled) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AccesoGPSPage()),
                            );
                          } else {
                            if (ctrlHome.getTurnoBTN == true) {
                              if ((widget.tipo!.contains('GUARDIA'))) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ListaInformesGuardiasPage(
                                            usuario: widget.user)));
                              }
                            } else {
                              NotificatiosnService.showSnackBarDanger(
                                  'NO HA INICIADO TURNO');
                            }
                            if ((widget.tipo!.contains('SUPERVISOR') ||
                                widget.tipo!.contains('ADMIN'))) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ListaInformesGuardiasPage(
                                          usuario: widget.user)));
                            }
                          }
                        },
                        'INFORME',
                      );
                    }),
                    prov.Consumer<BotonTurnoController>(
                      builder: (BuildContext context, ctrlHome, Widget? child) {
                        return _itemsMenuLateral(
                          size,
                          'Consignas',
                          Icons.assignment_turned_in_outlined,
                          ctrlTheme.combinedColors[2],
                          () async {
                            bool isGpsEnabled = await context
                                .read<HomeController>()
                                .checkGpsStatus();
                            if (!isGpsEnabled) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AccesoGPSPage()),
                              );
                            } else {
                              if (ctrlHome.getTurnoBTN == true) {
                                if ((widget.tipo!.contains('GUARDIA') ||
                                    widget.tipo!.contains('SUPERVISOR') ||
                                    widget.tipo!.contains('ADMIN'))) {
                                  prov.Provider.of<ConsignasController>(context,
                                          listen: false)
                                      .getTodasLasConsignasClientes(
                                          '', 'false');
                                  if (widget.tipo!.contains('GUARDIA') ||
                                      widget.tipo!.contains('SUPERVISOR') ||
                                      widget.tipo!.contains('ADMIN')) {
                                    Navigator.pushNamed(
                                        context, 'listaConsignasGuardias');
                                  }
                                } else {}
                              } else {
                                if ((widget.tipo!.contains('CLIENTE'))) {
                                  prov.Provider.of<ConsignasController>(context,
                                          listen: false)
                                      .getTodasLasConsignasClientes(
                                          '', 'false');
                                  if (widget.tipo!.contains('CLIENTE')) {
                                    Navigator.pushNamed(
                                        context, 'listaConsignasClientes');
                                  }
                                }
                                //  NotificatiosnService.showSnackBarDanger('NO HA INICIADO TURNO');
                              }
                            }
                          },
                          'CONSIGNA',
                        );
                      },
                    ),

                    //==================================================//

                    _itemsMenuLateral(
                      size,
                      'Multas',
                      Icons.fact_check_outlined,
                      ctrlTheme.combinedColors[0],
                      () async {
                        bool isGpsEnabled = await context
                            .read<HomeController>()
                            .checkGpsStatus();
                        if (!isGpsEnabled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccesoGPSPage()),
                          );
                        } else {
                          // if ((widget.tipo!.contains('SUPERVISOR') ||
                          //     widget.tipo!.contains('GUARDIA') ||
                          //     widget.tipo!.contains('ADMINISTRACION'))) {

                          final controller =
                              context.read<AusenciasController>();
                          final controllerMultas =
                              context.read<MultasGuardiasContrtoller>();
                          String persona = '';

                          if (widget.tipo!.contains('GUARDIA')) {
                            persona = "GUARDIAS";

                            controller.setPersona(persona);
                          }
                          // else if( widget.tipo!.contains('SUPERVISOR')){
                          //   _persona="SUPERVISOR";
                          //     _controller.setPersona(_persona);

                          // }

                          else if (widget.tipo!.contains('ADMINISTRACION')) {
                            persona = "ADMINISTRACION";
                            controller.setPersona(persona);
                          }

                          controllerMultas.getTodasLasMultasGuardia(
                              '', 'false');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ListaMultasSupervisor(user: widget.user)));
                          // } else {
                          //   NotificatiosnService.showSnackBarDanger('NO TIENE INFORMACION');
                          // }
                        }
                      },
                      'MULTA',
                    ),

                    //=========================//
                    _itemsMenuLateral(size, 'Faltas', Icons.summarize_outlined,
                        ctrlTheme.combinedColors[3], () async {
                      context
                          .read<MultasGuardiasContrtoller>()
                          .getTodasLasFaltasInjustificadas('');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ListaFaltasInjustificadas(
                                    user: widget.user,
                                  )))
                          // HomePageMultiSelect()
                          );
                    }, 'FALTAS'),

                    widget.user!.rol!.contains('RESIDENTE') ||
                            widget.user!.rol!.contains('GUARDIA')
                        ? Container()
                        : _itemsMenuLateral(
                            size,
                            'Cambio Puesto',
                            Icons.transfer_within_a_station_outlined,
                            ctrlTheme.combinedColors[1],
                            () async {
                              bool isGpsEnabled = await context
                                  .read<HomeController>()
                                  .checkGpsStatus();
                              if (!isGpsEnabled) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AccesoGPSPage()),
                                );
                              } else {
                                if ((widget.tipo!.contains('SUPERVISOR') ||
                                    widget.tipo!.contains('GUARDIA'))) {
                                  prov.Provider.of<CambioDePuestoController>(
                                          context,
                                          listen: false)
                                      .buscaCambioPuesto('', 'false');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ListaCambioPuestoPage(
                                              user: widget.user)));
                                } else {
                                  NotificatiosnService.showSnackBarDanger(
                                      'NO TIENE INFORMACION');
                                }
                              }
                            },
                            'PRUESTO',
                          ),
                    _itemsMenuLateral(
                      size,
                      'Permisos',
                      Icons.pending_actions_outlined,
                      ctrlTheme.combinedColors[2],
                      () async {
                        bool isGpsEnabled = await context
                            .read<HomeController>()
                            .checkGpsStatus();
                        if (!isGpsEnabled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccesoGPSPage()),
                          );
                        } else {
                          final controller =
                              context.read<AusenciasController>();
                          String persona = '';

                          if (widget.tipo!.contains('GUARDIA')) {
                            persona = "GUARDIAS";

                            controller.setPersona(persona);
                          } else if (widget.tipo!.contains('SUPERVISOR')) {
                            persona = "SUPERVISOR";
                            controller.setPersona(persona);
                          } else if (widget.tipo!.contains('ADMINISTRACION')) {
                            persona = "ADMINISTRACION";
                            controller.setPersona(persona);
                          }

                          //************************//

                          final controllerAusencia =
                              prov.Provider.of<AusenciasController>(context,
                                  listen: false);
                          controllerAusencia.buscaAusencias('', 'false');

                          Navigator.pushNamed(context, 'listaAusencias',
                              arguments: widget.user);
                        }
                        //************************//

                        //  final _controllerAusencia= Provider.of<NuevoPermisoController>(context,
                        //           listen: false);
                        //       _controllerAusencia.buscaNuevosPermisos('', 'false');

                        //   Navigator.pushNamed(context, 'nuevosPermisos',
                        //       arguments: widget.user);
                      },
                      'PERMISO',
                    ),
                  ],
                ),
                SizedBox(
                  height: size.iScreen(2.0),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget gruposItemMenuGestionIntegral(
    Responsive size,
    // HomeController ctrlHome,
    String titulo,
  ) {
    return prov.Consumer<BotonTurnoController>(
      builder: (_, ctrlHome, __) {
        return ExpansionTile(
          title: SizedBox(
            width: size.wScreen(100),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: size.iScreen(2.3),
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Column(
              children: [
                // SizedBox(
                //   width: size.wScreen(100),
                //   child: Text(
                //     titulo,
                //     textAlign: TextAlign.center,
                //     style: GoogleFonts.roboto(
                //       fontSize: size.iScreen(2.5),
                //       color: Colors.black87,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: size.iScreen(1),
                ),
                Container(
                  width: size.wScreen(60),
                  height: size.iScreen(0.3),
                  color: Colors.grey.shade300,
                ),
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    //====================COMUNICADOS=======================//
                    widget.tipo!.contains('GUARDIA')
                        ? Container()
                        : _itemsMenuLateral(
                            size,
                            'Comunicados',
                            Icons.list_alt,
                            ctrlTheme.combinedColors[3],
                            () async {
                              bool isGpsEnabled = await context
                                  .read<HomeController>()
                                  .checkGpsStatus();
                              if (!isGpsEnabled) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AccesoGPSPage()),
                                );
                              } else {
                                if (ctrlHome.getTurnoBTN == true) {
                                  if ((widget.tipo!.contains('GUARDIA') ||
                                      widget.tipo!.contains('SUPERVISOR') ||
                                      widget.tipo!.contains('ADMIN'))) {
                                    prov.Provider.of<AvisosController>(context,
                                            listen: false)
                                        .getTodosLosAvisos('', 'false');
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            const ListaComunicadosGuardiasPage()));
                                  }
                                } else {
                                  if ((widget.tipo!.contains('CLIENTE'))) {
                                    prov.Provider.of<ConsignasController>(
                                            context,
                                            listen: false)
                                        .getTodasLasConsignasClientes(
                                            '', 'false');
                                    Navigator.pushNamed(
                                        context, 'listaConsignasClientes');
                                  }
                                }
                              }
                            },
                            'COMUNICADO',
                          ),
                    // _itemsMenuLateral(size, 'Reportes', Icons.feed_outlined, ctrlHome,
                    //     ctrlTheme.combinedColors[0], () {
                    //   _modalReportes(context, size, widget.user);
                    // }),
                    //====================EVALUACIONES=======================//
                    _itemsMenuLateral(
                        size,
                        'Evaluaciones',
                        Icons.summarize_outlined,
                        ctrlTheme.combinedColors[3], () async {
                      bool isGpsEnabled =
                          await context.read<HomeController>().checkGpsStatus();
                      if (!isGpsEnabled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccesoGPSPage()),
                        );
                      } else {
                        if ((widget.tipo!.contains('RESIDENTE') ||
                            widget.tipo!.contains('CLIENTE'))) {
                          NotificatiosnService.showSnackBarDanger(
                              'NO TIENE INFORMACION');
                        } else {
                          context
                              .read<EvaluacionesController>()
                              .buscaEvaluaciones('', 'false');
                          // Navigator.pushNamed(context, 'evaluacion');

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EvaluacionPage(
                                        usuario: widget.user,
                                      )))
                              // HomePageMultiSelect()
                              );
                        }
                      }
                    }, 'EVALUACION'),
                    //====================CAPACITACIONES=======================//
                    _itemsMenuLateral(
                        size,
                        'Capacitaciones',
                        Icons.workspace_premium_outlined,
                        ctrlTheme.combinedColors[0], () async {
                      bool isGpsEnabled =
                          await context.read<HomeController>().checkGpsStatus();
                      if (!isGpsEnabled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccesoGPSPage()),
                        );
                      } else {
                        if ((widget.tipo!.contains('RESIDENTE') ||
                            widget.tipo!.contains('CLIENTE'))) {
                          NotificatiosnService.showSnackBarDanger(
                              'NO TIENE INFORMACION');
                        } else {
                          context
                              .read<CapacitacionesController>()
                              .buscaListaCapacitaciones('');
                          // Navigator.pushNamed(context, 'evaluacion');

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ListaCapacitaciones(
                                        usuario: widget.user,
                                      )))
                              // HomePageMultiSelect()
                              );
                        }
                      }
                      //  users!.rol!.contains('RESIDENTE') ||
                      //             users!.rol!.contains('CLIENTE')
                      //         ? Container()
                      //         : ItemDrower(
                      //             size: size,
                      //             label: 'Capacitaciones',
                      //             icon: Icons.engineering_outlined,
                      //             onTap: () {
                      //               // Navigator.pop(context);
                      //               context
                      //                   .read<CapacitacionesController>()
                      //                   .buscaListaCapacitaciones('');
                      //               // Navigator.pushNamed(context, 'evaluacion');

                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: ((context) =>
                      //                           ListaCapacitaciones(
                      //                             usuario: users,
                      //                           )))
                      //                   // HomePageMultiSelect()
                      //                   );
                      //             },
                      //           ),
                    }, 'CAPACITACION'),
                    //====================RECLAMOS=======================//
                    _itemsMenuLateral(
                      size,
                      'Quejas/Reclamos',
                      Icons.rate_review_outlined,
                      ctrlTheme.combinedColors[1],
                      () async {
                        bool isGpsEnabled = await context
                            .read<HomeController>()
                            .checkGpsStatus();
                        if (!isGpsEnabled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccesoGPSPage()),
                          );
                        } else {
                          final cotrl = context.read<HomeController>();

                          cotrl.buscaGestionDocumental('', 'ENVIADO');
                          // _cotrl.buscaGestionDocumental('','RECIBIDO');
                          // Navigator.pushNamed(context, 'evaluacion');

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ListaGestioDocumental(
                                        user: widget.user,
                                      )))
                              // HomePageMultiSelect()
                              );
                        }
                      },
                      'QUEJA',
                    ),

                    //====================ENCUENSTAS=======================//

                    _itemsMenuLateral(
                      size,
                      'Encuestas',
                      Icons.checklist_rtl_outlined,
                      ctrlTheme.combinedColors[2],
                      () async {
                        bool isGpsEnabled = await context
                            .read<HomeController>()
                            .checkGpsStatus();
                        if (!isGpsEnabled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccesoGPSPage()),
                          );
                        } else {
                          context
                              .read<EncuestasController>()
                              .buscaEncuestas('', 'false');

                          // Navigator.pushNamed(context, 'encuestas');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EncuastasPage(
                                        usuario: widget.user,
                                      )))
                              // HomePageMultiSelect()
                              );
                        }
                      },
                      'ENCUESTA',
                    ),

                    //=============================================//
                  ],
                ),
                SizedBox(
                  height: size.iScreen(2.0),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget gruposItemMenuBitacora(
    Responsive size,
    // HomeController ctrlHome,
    String titulo,
  ) {
    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        return ExpansionTile(
          title: SizedBox(
            width: size.wScreen(100),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: size.iScreen(2.3),
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Column(
              children: [
                SizedBox(
                  height: size.iScreen(1),
                ),
                Container(
                  width: size.wScreen(60),
                  height: size.iScreen(0.3),
                  color: Colors.grey.shade300,
                ),
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  // children: [
                  //       if (widget.user!.rol!.contains('RESIDENTE') && widget.user!.rol!.contains('PROPIETARIO'))
                  //   Text('Usuario es RESIDENTE y PROPIETARIO'),

                  // if (widget.user!.rol!.contains('RESIDENTE') && !widget.user!.rol!.contains('PROPIETARIO'))
                  //   Text('Usuario es RESIDENTE'),

                  // if (widget.user!.rol!.contains('PROPIETARIO') && !widget.user!.rol!.contains('RESIDENTE'))
                  //   Text('Usuario es PROPIETARIO'),

                  // if (!widget.user!.rol!.contains('RESIDENTE') && !widget.user!.rol!.contains('PROPIETARIO'))
                  //   Text('Usuario tiene otro rol'),
                  //       ],
                  children: [
                    //  if (widget.user!.rol!.contains('RESIDENTE') && !widget.user!.rol!.contains('PROPIETARIO'))

                    _itemsMenuLateral(size, 'Residente', Icons.groups,
                        ctrlTheme.combinedColors[0], () async {
                      bool isGpsEnabled =
                          await context.read<HomeController>().checkGpsStatus();
                      if (!isGpsEnabled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccesoGPSPage()),
                        );
                      } else {
                        //   widget.user!.rol!.contains('RESIDENTE')
                        //  ?Container(): ItemsMenuNovedades(
                        //     onTap: () {
                        //

                        final controller = context.read<ResidentesController>();
                        controller.resetValuesResidentes();

                        if (widget.user!.rol!.contains('CLIENTE')) {
                          controller.getTodosLosResidentes('', 'false');
                        } else if (widget.user!.rol!.contains('GUARDIA') ||
                            widget.user!.rol!.contains('SUPERVISOR')) {
                          controller.getTodosLosResidentesGuardia('', 'false');

                          controller.setListFilter(
                              controller.getListaTodosLosResidentes);
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListaResidentes(
                                  user: widget.user,
                                )));
                      }
                    }, 'RESIDENTE'),
                    // if (widget.user!.rol!.contains('RESIDENTE') && widget.user!.rol!.contains('PROPIETARIO'))

                    //===================================BOTON BITACORA==========================================//

                    // _itemsMenuLateral(
                    //   size,
                    //   widget.user!.rol!.contains('RESIDENTE')
                    //       ? 'Solicitud de Ingreso'
                    //       : 'Bitácora',
                    //   Icons.auto_stories_sharp,
                    //   ctrlTheme.combinedColors[1],
                    //   () async {
                    //     bool isGpsEnabled = await context
                    //         .read<HomeController>()
                    //         .checkGpsStatus();
                    //     if (!isGpsEnabled) {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const AccesoGPSPage()),
                    //       );
                    //     } else {
                    //       final ctrl = context.read<BotonTurnoController>();

                    //       if (ctrl.getTurnoBTN == true ||
                    //           !widget.user!.rol!.contains('RESIDENTE')) {
                    //         final controller =
                    //             context.read<BitacoraController>();
                    //         controller.resetValuesBitacora();

                    //         // _controller.getBitacoras('', 'false'); ///*********este es el principal  */
                    //         controller.setBtnSearch(false);

                    //         controller.setingresoSalida(0);
                    //         controller.getAllVisitasBitacoras(
                    //             '', 'false', 'INGRESO');
                    //         controller.onInputFechaInicioChange('');
                    //         controller.onInputFechaFinChange('');

                    //         Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (context) => ListaBitacora(
                    //                   user: widget.user,
                    //                 )));
                    //       } else {
                    //         NotificatiosnService.showSnackBarDanger(
                    //             'DEBE INICIAR TURNO');
                    //       }
                    //     }
                    //   },
                    //   'RESIDENTE',
                    // ),

                    _itemsMenuLateral(
                      size,
                      'Bitácora',
                      Icons.auto_stories_sharp,
                      ctrlTheme.combinedColors[1],
                      () async {
                        bool isGpsEnabled = await context
                            .read<HomeController>()
                            .checkGpsStatus();
                        if (!isGpsEnabled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccesoGPSPage()),
                          );
                        } else {
                          final ctrl = context.read<BotonTurnoController>();

                          if (ctrl.getTurnoBTN == true ||
                              !widget.user!.rol!.contains('RESIDENTE')) {
                            final controller =
                                context.read<BitacoraController>();
                            controller.resetValuesBitacora();
                            controller.setBtnSearch(false);
                            controller.setingresoSalida(0);
                            controller.getAllVisitasBitacoras(
                                '', 'false', 'INGRESO');
                            controller.onInputFechaInicioChange('');
                            controller.onInputFechaFinChange('');

                            //======================================//
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BitacorasScreens()));
                            //======================================//
                          } else {
                            NotificatiosnService.showSnackBarDanger(
                                'DEBE INICIAR TURNO');
                          }
                        }
                      },
                      'RESIDENTE',
                    ),

                    //*************BOTON CIERRE BITACOTA**************//
                    _itemsMenuLateral(
                        size,
                        'Cierre Bitácora',
                        Icons.auto_stories_sharp,
                        ctrlTheme.combinedColors[1], () async {
                      bool isGpsEnabled =
                          await context.read<HomeController>().checkGpsStatus();
                      if (!isGpsEnabled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccesoGPSPage()),
                        );
                      } else {
                        final ctrl = context.read<BotonTurnoController>();

                        if (ctrl.getTurnoBTN == true ||
                            !widget.user!.rol!.contains('RESIDENTE')) {
                          final controller =
                              context.read<CierreBitacoraController>();
                          controller.buscaBitacorasCierre('', 'false');

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ListaCierreBitacora(
                                    user: widget.user,
                                  )));
                        } else {
                          NotificatiosnService.showSnackBarDanger(
                              'DEBE INICIAR TURNO');
                        }
                      }
                    }, 'RESIDENTE'),

                    //****************************//
                  ],
                ),
                SizedBox(
                  height: size.iScreen(2.0),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

// ****************** WIDGET DE BOTONES DELL MENU *************//
  Widget _itemsMenuLateral(Responsive size, String label, IconData icon,
      Color color, final VoidCallback onTap, String tipo) {
    return prov.Consumer<HomeController>(builder: (_, valueBotones, __) {
      final ctrl = context.read<BotonTurnoController>();
      Map<String, dynamic> tipo = {};
      for (var item in valueBotones.getListaNotificacionesMenu) {
// if (item['notTipo']=='ALERTA' && item['cantidad']!='') {
        tipo = {"notTipo": item['notTipo'], "cantidad": item['cantidad']};

// }
// else if (item['notTipo']=='INFORME'){
//  tipo={
// "notTipo":item['notTipo'],
// "cantidad":item['cantidad']
//   };

// }
      }
      // print('IMPRIMO EL TIPO DE ALERTA MENU :$tipo');

      return badges.Badge(
        badgeStyle: badges.BadgeStyle(
          elevation:
              tipo['notTipo'] == tipo ? 3 : 0, //UBICAR CERO  SI NO HAY CANTIDAD
          badgeColor: tipo['notTipo'] == tipo
              ? Colors.red
              : Colors.transparent, //UBICAR TRANSPARENTE SI NO HAY CANTIDAD
        ),
        position: badges.BadgePosition.custom(
          top: 10.0,
          start: 5.0,
        ),
        badgeContent: Text(
            // (valueNot1.getNumNotificaciones > 9)
            //     ?
            tipo['notTipo'] == tipo
                ? tipo['cantidad'] > 9
                    ? '9+'
                    : '${tipo['cantidad']}'
                : '',
            // : (valueNot1.getNumNotificaciones == 0)
            //     ? ''
            //     :
            //     '${valueNot1.getNumNotificaciones}',
            style: GoogleFonts.roboto(
              // fontSize: size.iScreen(2.5),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        child: Container(
          width: size.iScreen(15.0),
          height: size.iScreen(10.0),
          decoration: BoxDecoration(
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5.0,
                  offset: Offset(0.0, 0.75))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.all(size.iScreen(1.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors
                    .grey.shade200, // Aqui se cambia el color de los botones
                borderRadius: BorderRadius.circular(8),
              ),
              child: MaterialButton(
                elevation: 20.0,
                splashColor: color,
                onPressed: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(1.6),
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ctrl.getTurnoBTN == true ||
                            label == 'Multas' ||
                            label == 'Permisos' ||
                            label == 'Quejas/Reclamos' ||
                            label == 'Encuestas'
                        ? Icon(
                            icon,
                            size: size.iScreen(4.0),
                            color: color,
                          )
                        : Icon(
                            Icons.lock_clock_outlined,
                            size: size.iScreen(4.0),
                            color: Colors.grey,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // Widget btnTurnoPrincipal(
  //   Responsive size,
  //   ThemeApp ctrl,
  // ) {
  //   return Consumer<SocketService>(builder: (_, valueEstadoInternet, __) {
  //     return
  //     Consumer<BotonTurnoController>(builder: (_, valueTurno, __) {
  //       return Container(
  //         width: size.iScreen(11.0),
  //         height: size.iScreen(11.0),
  //         decoration: BoxDecoration(
  //           boxShadow: const <BoxShadow>[
  //             BoxShadow(
  //                 color: Colors.black54,
  //                 blurRadius: 2.0,
  //                 offset: Offset(0.0, 0.75))
  //           ],
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(100),
  //           border: Border.all(
  //             color: valueTurno.getTurnoBTN== true
  //                 ? Colors.black //,_color
  //                 : Colors.black, // Color del borde
  //             width: 1.5, // Grosor del borde
  //           ),
  //         ),
  //         margin: EdgeInsets.all(size.iScreen(0.2)),
  //         padding: EdgeInsets.all(size.iScreen(0.2)),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(0),
  //           child: Container(
  //               decoration: BoxDecoration(
  //                   color: valueTurno.getTurnoBTN == true
  //                       ? ctrl.combinedColors[3]
  //                       : Colors.grey, //Aqui se cambia el color de los botones
  //                   borderRadius: BorderRadius.circular(100)),
  //               child: MaterialButton(
  //                   elevation: 20.0,
  //                   splashColor: valueTurno.getTurnoBTN == true
  //                       ? ctrl.combinedColors[2]
  //                       : Color(0xffbd1823),
  //                   onPressed: () {
  //                     if (valueEstadoInternet.serverStatus ==
  //                         ServerStatus.Online) {
  //                       if (valueTurno.getTurnoBTN) {
  //                         _modalFinalizarTurno(size);
  //                       } else {
  //                         _modalInciaTurno(size,);
  //                       }
  //                     } else {}
  //                   },
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       // Image.asset('assets/imgs/$icon',
  //                       //     color: (alerta)?Colors.white:color, width: size.iScreen(8.0)),
  //                       // Icon(Icons.list,size: size.iScreen(4.0),),
  //                       Text(
  //                         valueTurno.getTurnoBTN == true
  //                             ? 'TURNO ACTIVO'
  //                             : 'TURNO INACTIVO',
  //                         textAlign: TextAlign.center,
  //                         style: GoogleFonts.roboto(
  //                             fontSize: size.iScreen(1.4),
  //                             color: valueTurno.getTurnoBTN == true
  //                                 ? Colors.white
  //                                 : Colors.black,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       // Text(
  //                       //   valueTurno.getBtnTurno==true?'ACTIVADO':'DESACTIVADO',
  //                       //   textAlign: TextAlign.center,
  //                       //   style: GoogleFonts.roboto(
  //                       //       fontSize: size.iScreen(1.5),
  //                       //       color: Colors.white,
  //                       //       fontWeight: FontWeight.bold),
  //                       // ),
  //                       valueTurno.getTurnoBTN == true
  //                           ? Icon(
  //                               Icons.gpp_good_outlined,
  //                               color: Colors.white,
  //                               size: size.iScreen(5),
  //                             )
  //                           : Icon(Icons.gpp_bad_outlined,
  //                               color: Colors.white, size: size.iScreen(5))
  //                     ],
  //                   )

  //                   // Consumer<HomeController>(
  //                   //   builder: (_, valueBtnTurno, __) {
  //                   //     return

  //                   //   },
  //                   // )
  //                   )),
  //         ),
  //       );
  //     });
  //   });
  // }
  // Widget btnTurnoPrincipal(
  //   Responsive size,
  //   ThemeApp ctrl,
  // ) {
  //   return Consumer<BotonTurnoController>(builder: (_, valueTurno, __) {
  //     return Container(
  //       width: size.iScreen(11.0),
  //       height: size.iScreen(11.0),
  //       decoration: BoxDecoration(
  //         boxShadow: const <BoxShadow>[
  //           BoxShadow(
  //               color: Colors.black54,
  //               blurRadius: 2.0,
  //               offset: Offset(0.0, 0.75))
  //         ],
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(100),
  //         border: Border.all(
  //           color: valueTurno.getTurnoBTN == true
  //               ? Colors.black //,_color
  //               : Colors.black, // Color del borde
  //           width: 1.5, // Grosor del borde
  //         ),
  //       ),
  //       margin: EdgeInsets.all(size.iScreen(0.2)),
  //       padding: EdgeInsets.all(size.iScreen(0.2)),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(0),
  //         child: Container(
  //             decoration: BoxDecoration(
  //                 color: valueTurno.getTurnoBTN == true
  //                     ? ctrl.combinedColors[3]
  //                     : Colors.grey, //Aqui se cambia el color de los botones
  //                 borderRadius: BorderRadius.circular(100)),
  //             child: MaterialButton(
  //                 elevation: 20.0,
  //                 splashColor: valueTurno.getTurnoBTN == true
  //                     ? ctrl.combinedColors[2]
  //                     : const Color(0xffbd1823),
  //                 onPressed: () {
  //                   if (valueTurno.getTurnoBTN) {
  //                     _modalFinalizarTurno(size);
  //                   } else {
  //                     _modalInciaTurno(
  //                       size,
  //                     );
  //                   }
  //                 },
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     // Image.asset('assets/imgs/$icon',
  //                     //     color: (alerta)?Colors.white:color, width: size.iScreen(8.0)),
  //                     // Icon(Icons.list,size: size.iScreen(4.0),),
  //                     Text(
  //                       valueTurno.getTurnoBTN == true
  //                           ? 'TURNO ACTIVO'
  //                           : 'TURNO INACTIVO',
  //                       textAlign: TextAlign.center,
  //                       style: GoogleFonts.roboto(
  //                           fontSize: size.iScreen(1.4),
  //                           color: valueTurno.getTurnoBTN == true
  //                               ? Colors.white
  //                               : Colors.black,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     // Text(
  //                     //   valueTurno.getBtnTurno==true?'ACTIVADO':'DESACTIVADO',
  //                     //   textAlign: TextAlign.center,
  //                     //   style: GoogleFonts.roboto(
  //                     //       fontSize: size.iScreen(1.5),
  //                     //       color: Colors.white,
  //                     //       fontWeight: FontWeight.bold),
  //                     // ),
  //                     valueTurno.getTurnoBTN == true
  //                         ? Icon(
  //                             Icons.gpp_good_outlined,
  //                             color: Colors.white,
  //                             size: size.iScreen(5),
  //                           )
  //                         : Icon(Icons.gpp_bad_outlined,
  //                             color: Colors.white, size: size.iScreen(5))
  //                   ],
  //                 )

  //                 // Consumer<HomeController>(
  //                 //   builder: (_, valueBtnTurno, __) {
  //                 //     return

  //                 //   },
  //                 // )
  //                 )),
  //       ),
  //     );
  //   });
  // }

  Widget btnTurnoPrincipal(
    Responsive size,
    ThemeApp ctrl,
  ) {
    return prov.Consumer<BotonTurnoController>(
      builder: (_, valueTurno, __) {
        bool isTurnoActivo = valueTurno.getTurnoBTN;

        return Container(
          width: size.iScreen(12.0),
          height: size.iScreen(12.0),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0, // Mayor desenfoque para una sombra suave
                spreadRadius: 1.0, // Expande la sombra alrededor del contorno
                offset: Offset(0.0, 0.0), // Sombra uniforme en todo el contorno
              ),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: valueTurno.getTurnoBTN ? Colors.green : Colors.white,
              width: 2.0,
            ),
          ),
          margin: EdgeInsets.all(size.iScreen(0.5)),
          child: MaterialButton(
            shape: const CircleBorder(),
            elevation: 5.0,
            color: valueTurno.getTurnoBTN ? Colors.green : Colors.grey.shade300,
            splashColor:
                valueTurno.getTurnoBTN ? Colors.lightGreen : Colors.black45,
            onPressed: () {
              if (valueTurno.getTurnoBTN) {
                _modalFinalizarTurno(size);
                //=================================================//
                final SessionParams paramsToLoad =
                    SessionParams(widget.user!, valueTurno.getTurnoBTN);

                _modalRelevo(ref);
                ref.read(userProvider.notifier).state = paramsToLoad;
                //=================================================//
              } else {
                if (widget.user!.rol!.contains('ADMINISTRACION')) {
                  _modalInciaTurno(size);
                } else {
                  // NotificatiosnService.showSnackBarError(
                  //     'No se pudo escanear ');
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  valueTurno.getTurnoBTN
                      ? Icons.check_circle_outline
                      : Icons.remove_circle_outline,
                  color: valueTurno.getTurnoBTN ? Colors.white : Colors.black,
                  size: size.iScreen(4.0),
                ),
                SizedBox(height: size.iScreen(1.0)),
                Text(
                  valueTurno.getTurnoBTN ? 'TURNO ACTIVO' : 'TURNO INACTIVO',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: size.iScreen(1.6),
                    color: valueTurno.getTurnoBTN ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //=========================================================================//

  Widget btnTurno(Responsive size, Color color, HomeController ctrl) {
    return prov.Consumer<SocketService>(builder: (_, valueEstadoInternet, __) {
      return prov.Consumer<HomeController>(builder: (_, valueTurno, __) {
        return Container(
          width: size.iScreen(12.0),
          height: size.iScreen(12.0),
          decoration: BoxDecoration(
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 0.75))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: valueTurno.getgetTestTurno == true
                  ? Colors.black //,_color
                  : Colors.black, // Color del borde
              width: 1.5, // Grosor del borde
            ),
          ),
          margin: EdgeInsets.all(size.iScreen(0.2)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
                decoration: BoxDecoration(
                    color: valueTurno.getgetTestTurno == true
                        ? color
                        : Colors.grey, //Aqui se cambia el color de los botones
                    borderRadius: BorderRadius.circular(100)),
                child: MaterialButton(
                    elevation: 20.0,
                    splashColor: valueTurno.getgetTestTurno == true
                        ? color
                        : const Color(0xffbd1823),
                    onPressed: () {
                      if (valueEstadoInternet.serverStatus ==
                          ServerStatus.Online) {
                        if (valueTurno.getBotonTurno) {
                          _modalFinalizarTurno(size);
                        } else {
                          _modalInciaTurno(
                            size,
                          );
                        }
                      } else {}
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset('assets/imgs/$icon',
                        //     color: (alerta)?Colors.white:color, width: size.iScreen(8.0)),
                        // Icon(Icons.list,size: size.iScreen(4.0),),
                        Text(
                          valueTurno.getBotonTurno == true
                              ? 'TURNO ACTIVO'
                              : 'TURNO INACTIVO',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontSize: size.iScreen(1.6),
                              color: valueTurno.getBotonTurno == true
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   valueTurno.getBtnTurno==true?'ACTIVADO':'DESACTIVADO',
                        //   textAlign: TextAlign.center,
                        //   style: GoogleFonts.roboto(
                        //       fontSize: size.iScreen(1.5),
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        valueTurno.getBotonTurno == true
                            ? Icon(
                                Icons.gpp_good_outlined,
                                size: size.iScreen(7.0),
                              )
                            : Icon(Icons.gpp_bad_outlined,
                                size: size.iScreen(7.0))
                      ],
                    )

                    // Consumer<HomeController>(
                    //   builder: (_, valueBtnTurno, __) {
                    //     return

                    //   },
                    // )
                    )),
          ),
        );
      });
    });
  }

  salirApp() async {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return CupertinoAlertDialog(
            title: const Text("Aviso"),
            content: const Text('Seguro desea salir ?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Aceptar'),
                onPressed: () async {
                  final ctrlHome = context.read<HomeController>();
                  ProgressDialog.show(context);
                  ctrlHome.sentTokenDelete();

                  await Auth.instance.deleteTurnoSesion();
                  await Auth.instance.deleteSesion(context);
                  ctrlHome.resetNotificaciones();
                  ctrlHome.setGetTestTurno(false);
                  ctrlHome.setBotonTurno(false);
                  ProgressDialog.dissmiss(context);
                },
              ),
            ],
          );
        });
  }

  Container btnItem(BuildContext context, size, String label, IconData icon,
      Color color, HomeController ctrl, final VoidCallback onTap) {
    return Container(
      width: size.iScreen(11.0),
      height: size.iScreen(11.0),
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Colors.black54, blurRadius: 5.0, offset: Offset(0.0, 0.75))
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.all(size.iScreen(1.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          decoration: BoxDecoration(
            color: ctrl.getgetTestTurno == true
                ? Colors.grey.shade200
                : Colors
                    .grey.shade300, // Aqui se cambia el color de los botones
            borderRadius: BorderRadius.circular(8),
          ),
          child: MaterialButton(
            elevation: 20.0,
            splashColor: color,
            onPressed: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: size.iScreen(1.6),
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ctrl.getgetTestTurno == true
                    ? Icon(
                        icon,
                        size: size.iScreen(4.0),
                        color: color,
                      )
                    : Icon(
                        Icons.lock_clock_outlined,
                        size: size.iScreen(4.0),
                        color: Colors.grey,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget btnAlerta(Responsive size) {
  //   return
  //   Consumer<HomeController>(builder: (_, value, __) {
  //         return  AvatarGlow(
  //     endRadius: 5.0,
  //         // glowRadiusFactor: 0.2,
  //             glowColor: Colors.red,
  //             // animate: value.alarmActivated== true?false:true,
  //     child: Container(
  //       width: size.iScreen(12.0),
  //       height: size.iScreen(12.0),
  //       decoration: BoxDecoration(boxShadow: const <BoxShadow>[
  //         BoxShadow(
  //             color: Colors.black54, blurRadius: 5.0, offset: Offset(0.0, 0.75))
  //       ], color: Colors.white, borderRadius: BorderRadius.circular(100)),
  //       margin: EdgeInsets.all(size.iScreen(0.5)),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(100),
  //         child: Container(
  //             decoration: BoxDecoration(
  //                 color:
  //                     Color(0xffe93301), //Aqui se cambia el color de los botones
  //                 borderRadius: BorderRadius.circular(8)),
  //             child: MaterialButton(
  //               elevation: 20.0,
  //               splashColor: Color(0xffe93301),
  //               onPressed: () {
  //                 //  Provider.of<HomeController>(context, listen: false).enviaAlerta();
  //               },
  //               child: Icon(
  //                 Icons.campaign_outlined,
  //                 size: size.iScreen(8.5),
  //                 color: Colors.red,
  //               ),
  //             )),
  //       ),
  //     ),
  //   );

  //   },);

  // }
  // Widget btnAlerta(Responsive size) {
  //   return Consumer<HomeController>(
  //     builder: (_, value, __) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: Colors.grey.shade200,

  //           borderRadius: BorderRadius.circular(10.0),
  //           border: Border.all(
  //               color: Colors.grey.shade300,
  //               width: 2.0), // Borde rojo añadido aquí
  //         ),
  //         margin: EdgeInsets.only(
  //             right: size.iScreen(1.0),
  //             left: size.iScreen(1.0),
  //             top: size.iScreen(1.0)),
  //         padding: EdgeInsets.all(size.iScreen(1.0)),
  //         width: size.wScreen(45.0),
  //         alignment: Alignment.center,
  //         child: AvatarGlow(
  //           //TODO: FCODEV PROPIEDAD YA NO EXISTE endRadius: 60,
  //           glowColor: value.alarmActivated == true ? Colors.red : Colors.white,
  //           duration: const Duration(milliseconds: 1000),
  //           child: Row(
  //             children: [
  //               Container(
  //                 width: size.iScreen(11.0),
  //                 height: size.iScreen(11.0),
  //                 decoration: BoxDecoration(
  //                     boxShadow: <BoxShadow>[
  //                       BoxShadow(
  //                           // color: Colors.black54,
  //                           color: value.alarmActivated == true
  //                               ? const Color(0xffe93301)
  //                               : Colors.black54,
  //                           blurRadius: 5.0,
  //                           offset: const Offset(0.0, 0.75))
  //                     ],
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(100)),
  //                 margin: EdgeInsets.all(size.iScreen(0.5)),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(100),
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                           color: value.alarmActivated == true
  //                               ? Colors.white
  //                               : const Color(
  //                                   0xffe93301), //     Color(0xffe93301), //Aqui se cambia el color de los botones
  //                           borderRadius: BorderRadius.circular(8)),
  //                       child: MaterialButton(
  //                         elevation: 20.0,
  //                         splashColor: const Color(0xffe93301),
  //                         onPressed: value.alarmActivated == false
  //                             ? () {
  //                                 // print('se activo la alarma');
  //                                 value.activateAlarm(true);
  //                                 Provider.of<HomeController>(context,
  //                                         listen: false)
  //                                     .enviaAlerta();
  //                               }
  //                             : null,
  //                         child: Icon(
  //                           Icons.campaign_outlined,
  //                           size: size.iScreen(8.5),
  //                           color: value.alarmActivated == true
  //                               ? const Color(0xffe93301)
  //                               : Colors.white,
  //                         ),
  //                       )),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //================================BOTON ALERTA ========================================//
  Widget btnAlerta(Responsive size) {
    return prov.Consumer<HomeController>(
      builder: (_, value, __) {
        return Container(
          // decoration: BoxDecoration(
          //   color: Colors.grey.shade200,
          //   borderRadius: BorderRadius.circular(10.0),
          //   border: Border.all(
          //     color: Colors.grey.shade300,
          //     width: 2.0,
          //   ),
          // ),
          margin: EdgeInsets.only(
            right: size.iScreen(1.0),
            left: size.iScreen(1.0),
            top: size.iScreen(1.0),
          ),
          padding: EdgeInsets.all(size.iScreen(1.0)),
          width: size.wScreen(45.0),
          alignment: Alignment.center,
          child: value.alarmActivated
              ? AvatarGlow(
                  glowColor: Colors.red,
                  duration: const Duration(milliseconds: 1000),
                  child: _buildButtonContent(size, value),
                )
              : _buildButtonContent(size, value),
        );
      },
    );
  }
  //=========================================================================//

  // // Función para construir un contenedor de color
  // Widget buildColorContainer(String label) {
  //   final ctrl = context.read<ThemeApp>();

  //   return Container(
  //     color: ctrl.secondaryColor,
  //     height: 50,
  //     width: 100,
  //     margin: const EdgeInsets.symmetric(vertical: 5),
  //     child: Center(
  //       child: Text(
  //         label,
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildButtonContent(Responsive size, HomeController value) {
    return Row(
      children: [
        Container(
          width: size.iScreen(11.0),
          height: size.iScreen(11.0),
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: value.alarmActivated == true
                    ? const Color(0xffe93301)
                    : Colors.black54,
                blurRadius: 5.0,
                offset: const Offset(0.0, 0.75),
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          margin: EdgeInsets.all(size.iScreen(0.5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              decoration: BoxDecoration(
                color: value.alarmActivated == true
                    ? Colors.white
                    : const Color(0xffe93301),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MaterialButton(
                elevation: 20.0,
                splashColor: const Color(0xffe93301),
                onPressed: value.alarmActivated == false
                    ? () {
                        value.activateAlarm(true);
                        prov.Provider.of<HomeController>(context, listen: false)
                            .enviaAlerta();
                      }
                    : null,
                child: Icon(
                  Icons.campaign_outlined,
                  size: size.iScreen(8.5),
                  color: value.alarmActivated == true
                      ? const Color(0xffe93301)
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Función para construir un contenedor de color
  Widget buildColorContainer(String label) {
    final ctrl = context.read<ThemeApp>();

    return Container(
      color: ctrl.secondaryColor,
      height: 50,
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

// ************* TURNO *************//
  void _modalFinalizarTurno(Responsive size) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          // final homeControllers= Provider.of<HomeController>(context);
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FINALIZAR TURNO',
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.5),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  // IconButton(
                  //     splashRadius: size.iScreen(3.0),
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     icon: Icon(
                  //       Icons.close,
                  //       color: Colors.red,
                  //       size: size.iScreen(3.5),
                  //     )),
                ],
              ),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Escanear QR para finalizar su turno',
                          style: GoogleFonts.roboto(
                              fontSize: size.iScreen(2.0),
                              // color: textPrimaryColor,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
                prov.Consumer<HomeController>(
                  builder: (_, valueScan, __) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ListTile(
                            tileColor: Colors.grey[200],
                            leading: const Icon(Icons.qr_code_2,
                                color: Colors.black),
                            title: Text(
                              "Código QR",
                              style: GoogleFonts.roboto(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.bold,
                                // color: Colors.white,
                              ),
                            ),
                            // trailing: const Icon(Icons.chevron_right_outlined),
                            onTap: () async {
                              //=============================================//

                              try {
                                valueScan.setInfoQRTurno(
                                    await FlutterBarcodeScanner.scanBarcode(
                                        '#34CAF0', '', false, ScanMode.QR));
                                if (!mounted) return;
                                final status =
                                    await Permission.location.request();
                                if (status == PermissionStatus.granted) {
                                  if (valueScan.getInfoQRTurno!.isNotEmpty) {
                                    ProgressDialog.show(context);
                                    await valueScan.getCurrentPosition();
                                    // await valueScan.validaCodigoQRTurno(context);
                                    // await valueScan.finalizarTurno(context);
                                    await valueScan.validaFinTurnoQR(context);
                                    ProgressDialog.dissmiss(context);
                                  } else {
                                    if (!mounted) return;
                                  }
                                }
                                if (status == PermissionStatus.denied ||
                                    status == PermissionStatus.restricted ||
                                    status ==
                                        PermissionStatus.permanentlyDenied ||
                                    status == PermissionStatus.limited) {
                                  openAppSettings();
                                }
                                // ProgressDialog.show(context);
                              } on PlatformException {
                                NotificatiosnService.showSnackBarError(
                                    'No se pudo escanear ');
                              }

                              //=============================================//

                              Navigator.pop(context);

                              //=============================================//
                            },
                          ),
                          SizedBox(
                            height: size.iScreen(2.0),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

//======================== VAALIDA SCANQR =======================//
  void _validaScanQR(Responsive size, HomeController controllerHome) async {
    bool isMounted = false;

    controllerHome.setInfoQRTurno("");
    try {
      controllerHome.setInfoQRTurno(await FlutterBarcodeScanner.scanBarcode(
          '#34CAF0', '', false, ScanMode.QR));
      if (!mounted) return;

      isMounted = true;

      final status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        if (controllerHome.getInfoQRTurno!.isNotEmpty) {
          ProgressDialog.show(context);
          await controllerHome.getCurrentPosition();
          if (isMounted) {
            await controllerHome.validaTurnoQR(context);
            ProgressDialog.dissmiss(context);
          }
        } else {
          if (!mounted) return;
        }
      }
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.restricted ||
          status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.limited) {
        openAppSettings();
      }
    } on PlatformException {
      NotificatiosnService.showSnackBarError('No se pudo escanear ');
    }
  }

  ///====== MUESTRA MODAL TERMINOS Y CONDICIONES =======//
  void _modalTerminosCondiciones(Responsive size) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          final homeControllers = prov.Provider.of<HomeController>(context);
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Términos y Condiciones',
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  IconButton(
                      splashRadius: size.iScreen(3.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: size.iScreen(3.5),
                      )),
                ],
              ),
              actions: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: size.wScreen(100),
                  // color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(2.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Wrap(
                        // direction : Axis.horizontal,
                        runAlignment: WrapAlignment.spaceEvenly,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text(
                              'Debe aceptar términos y condiciones para poder continuar.',
                              style: GoogleFonts.roboto(
                                  fontSize: size.iScreen(2.0),
                                  // color: textPrimaryColor,
                                  fontWeight: FontWeight.normal)),
                          InkWell(
                              onTap: null,
                              child: Text('Ver más...',
                                  style: GoogleFonts.roboto(
                                      fontSize: size.iScreen(2.0),
                                      color: tercearyColor,
                                      fontWeight: FontWeight
                                          .bold)) //abrirPaginaPazViSeg(),
                              ),
                        ],
                      ),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: homeControllers.getTerminosCondiciones,
                      onChanged: (bool? value) {
                        homeControllers.setTerminosCondiciones(value!);
                      },
                    ),
                    Text('Términos y Condiciones ',
                        style: GoogleFonts.roboto(
                            fontSize: size.iScreen(2.0),
                            // color: textPrimaryColor,
                            fontWeight: FontWeight.normal)),
                    //Checkbox
                  ], //<Widget>[]
                ), //Row

                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: size.iScreen(2.5),
                      horizontal: size.iScreen(2.5)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        !homeControllers.getTerminosCondiciones
                            ? Colors.grey
                            : const Color(0XFF3C3C3B),
                      ),
                    ),
                    onPressed: homeControllers.getTerminosCondiciones
                        ? () {
                            _validaScanQR(size, homeControllers);
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text('Aceptar',
                        style: GoogleFonts.roboto(
                            fontSize: size.iScreen(2.3),
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalInciaTurno(
    Responsive size,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          final ctrlHome = context.read<HomeController>();
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('INICIAR TURNO',
                      style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  IconButton(
                      splashRadius: size.iScreen(3.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: size.iScreen(3.5),
                      )),
                ],
              ),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading:
                            const Icon(Icons.qr_code_2, color: Colors.black),
                        title: Text(
                          "Código QR ",
                          style: GoogleFonts.roboto(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () async {
                          // homeController.setOpcionActividad(1);
                          Navigator.pop(context);
                          _modalTerminosCondiciones(
                            size,
                          );
                        },
                      ),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showAlertDialog(dynamic data) {
    if (data['msg'] != '') {
      showDialog(
          context: context,
          builder: (buildcontext) {
            final ctrlHome = context.read<HomeController>();
            ctrlHome.getValidaTurnoServer(context);
            return CupertinoAlertDialog(
              title: const Text("Aviso"),
              content: Text('${data['msg']}'),
            );
          });
    }
  }

//====================================MUESTRA MODAL RELEVO================================================//
//========================================================================================================//

  void _modalRelevo(WidgetRef ref) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        final size = Responsive.of(dialogContext);

        final relevo = Relevo(
          nombre: 'EDUARDO MARCELO MARTINEZ PINARGOTE ',
          hora: '20:00',
          cliente: 'Edificio Central S.A.',
          puesto: 'Garita de Acceso 1',
          prendas: [], // Inicializa con una lista vacía o lo que sea apropiado si currentPrendas se usa después
        );

        return GestureDetector(
          onTap: () =>
              FocusScope.of(dialogContext).unfocus(), // Usa dialogContext
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            insetPadding: EdgeInsets.symmetric(
                horizontal: size.iScreen(0.5), vertical: size.iScreen(0)),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: size.wScreen(99),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.iScreen(2.0),
                          vertical: size.iScreen(1.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ENTREGA DE TURNO',
                              style: GoogleFonts.roboto(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.bold,
                              )),
                          IconButton(
                            splashRadius: size.iScreen(3.0),
                            onPressed: () {
                              Navigator.pop(dialogContext); // Usa dialogContext
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: size.iScreen(3.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- Envuelve la parte dinámica con Consumer ---
                    Consumer(
                      builder: (context, ref, child) {
                        // Ahora, Riverpod observará y reconstruirá esta parte
                        // cada vez que 'prendasProvider' cambie.
                        final currentPrendas = ref.watch(prendasProvider);
                        final updatePrendaEstado = ref
                            .read(prendasProvider.notifier)
                            .updatePrendaEstado;
                        final updatePrendaObservacion = ref
                            .read(prendasProvider.notifier)
                            .updatePrendaObservacion;

                        // Si relevo.prendas siempre debe reflejar currentPrendas, actualízalo aquí.
                        relevo.prendas =
                            currentPrendas; // Asigna la lista de Riverpod

                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(2.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.wScreen(100),
                                      child: Text('Persona relevo: ',
                                          style: GoogleFonts.roboto(
                                            fontSize: size.iScreen(1.9),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          )),
                                    ),
                                    SizedBox(
                                      width: size.wScreen(100),
                                      child: Text(relevo.nombre,
                                          style: GoogleFonts.roboto(
                                            fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.iScreen(1.0)),
                                Row(
                                  children: [
                                    Text('Hora: ',
                                        style: GoogleFonts.roboto(
                                          fontSize: size.iScreen(1.9),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        )),
                                    Text(' ${relevo.hora}',
                                        style: GoogleFonts.roboto(
                                          fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                        )),
                                  ],
                                ),
                                SizedBox(height: size.iScreen(1.0)),
                                Row(
                                  children: [
                                    Text('Cliente: ',
                                        style: GoogleFonts.roboto(
                                          fontSize: size.iScreen(1.9),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        )),
                                    Text(' ${relevo.cliente}',
                                        style: GoogleFonts.roboto(
                                          fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                        )),
                                  ],
                                ),
                                SizedBox(height: size.iScreen(1.0)),
                                Row(
                                  children: [
                                    Text('Puesto: ',
                                        style: GoogleFonts.roboto(
                                          fontSize: size.iScreen(1.9),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        )),
                                    Text(' ${relevo.puesto}',
                                        style: GoogleFonts.roboto(
                                          fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                        )),
                                  ],
                                ),
                                SizedBox(height: size.iScreen(1.0)),
                                Container(
                                  color: Colors.red,
                                  width: size.wScreen(100),
                                  height: size.iScreen(0.01),
                                ),
                                SizedBox(height: size.iScreen(1.0)),
                                Text('Prendas Empresa:',
                                    style: GoogleFonts.roboto(
                                      fontSize: size.iScreen(1.9),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    )),
                                Container(
                                  // decoration: BoxDecoration(
                                  //   border:
                                  //       Border.all(color: Colors.grey.shade300),
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                  height: size.hScreen(
                                      60), // Ajusta esta altura según sea necesario
                                  child: ListView.builder(
                                    itemCount: currentPrendas.length,
                                    itemBuilder:
                                        (BuildContext itemBuilderContext,
                                            int index) {
                                      final prenda = currentPrendas[index];

                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                            vertical: size.iScreen(0.5),
                                            horizontal: size.iScreen(1.0)),
                                        elevation: 5,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(size.iScreen(1.5)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Prenda:', // Asumo 'nombre'
                                                    style: GoogleFonts.roboto(
                                                        fontSize:
                                                            size.iScreen(2.0),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ' ${prenda.descripcion}', // Asumo 'nombre'
                                                    style: GoogleFonts.roboto(
                                                      fontSize:
                                                          size.iScreen(2.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.iScreen(0.5)),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showEstadoSelectionModal(
                                                        prenda.id,
                                                        prenda.estado,
                                                        prenda
                                                            .estado, // Pasa prenda.nombre aquí
                                                        itemBuilderContext, // Usa el contexto del itemBuilder
                                                        size,
                                                        updatePrendaEstado,
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Estado: ',
                                                          style: GoogleFonts
                                                              .roboto(
                                                            fontSize: size
                                                                .iScreen(2.0),
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        Text(
                                                          ' ${prenda.estado}',
                                                          style: GoogleFonts
                                                              .roboto(
                                                            fontSize: size
                                                                .iScreen(2.0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            size: size
                                                                .iScreen(2.5)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.iScreen(0.5)),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Observación :',
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize: size
                                                                        .iScreen(
                                                                            2.0),
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                              size: size
                                                                  .iScreen(2.5),
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                            onPressed: () {
                                                              _showObservacionModal(
                                                                prenda.id,
                                                                prenda
                                                                    .observacion,
                                                                prenda
                                                                    .observacion,
                                                                itemBuilderContext, // Usa el contexto del itemBuilder
                                                                size,
                                                                updatePrendaObservacion,
                                                              );
                                                            },
                                                            tooltip:
                                                                'Editar observación',
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        prenda.observacion !=
                                                                    null &&
                                                                prenda
                                                                    .observacion!
                                                                    .isNotEmpty
                                                            ? '${prenda.observacion!}'
                                                            : 'Agregar...',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize:
                                                              size.iScreen(2.0),
                                                          color: prenda.observacion !=
                                                                      null &&
                                                                  prenda
                                                                      .observacion!
                                                                      .isNotEmpty
                                                              ? Colors.black
                                                              : Colors
                                                                  .blueAccent,
                                                          decoration: prenda
                                                                          .observacion !=
                                                                      null &&
                                                                  prenda
                                                                      .observacion!
                                                                      .isNotEmpty
                                                              ? TextDecoration
                                                                  .none
                                                              : TextDecoration
                                                                  .underline,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: size.iScreen(1.0)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: size.iScreen(2.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// ====================================================================================================== //

// --- FUNCIÓN PARA MOSTRAR LA MODAL DE SELECCIÓN DE ESTADO ---
  void _showEstadoSelectionModal(
      String prendaId,
      String currentEstado,
      String prendaNombre,
      BuildContext context, // Ahora se recibe como parámetro
      Responsive size, // Ahora se recibe como parámetro
      void Function(String id, String nuevoEstado)
          onEstadoChanged // Ahora se recibe como parámetro
      ) {
    showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text(
            'Selecciona el estado',
            style: GoogleFonts.roboto(
                fontSize: size.iScreen(2.0), fontWeight: FontWeight.bold),
          ),
          children: estadosDisponibles.map((String estado) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, estado);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                child: Text(
                  estado,
                  style: GoogleFonts.roboto(
                    fontSize: size.iScreen(1.9),
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
      if (selectedEstado != null && selectedEstado != currentEstado) {
        onEstadoChanged(prendaId, selectedEstado);
      }
    });
  }

// --- FUNCIÓN PARA MOSTRAR LA MODAL DE OBSERVACIÓN ---
  void _showObservacionModal(
      String prendaId,
      String? currentObservacion,
      String prendaNombre,
      BuildContext context,
      Responsive size,
      void Function(String id, String? nuevaObservacion) onObservacionChanged) {
    TextEditingController controller =
        TextEditingController(text: currentObservacion);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Observación',
            style: GoogleFonts.roboto(
                fontSize: size.iScreen(2.0), fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'Escribe tu observación aquí...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancelar',
                  style: GoogleFonts.roboto(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                onObservacionChanged(
                    prendaId,
                    controller.text.trim().isEmpty
                        ? null
                        : controller.text.trim());
                Navigator.pop(dialogContext);
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
//****************MODAL DE MANTENIMIENTO ********************//

// void _showMaintenanceAlert(BuildContext context) {
//   final size=Responsive.of(context);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // title: Text('Notificación de Mantenimiento'),
//           content:  Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [

//         SizedBox(height: size.iScreen(1.0)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               'Notificación de Mantenimiento',
//               style: GoogleFonts.roboto(
//                 fontSize: size.iScreen(1.8),
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//              CircleAvatar(
//           radius: size.iScreen(2.5),
//           backgroundColor: Colors.yellow[700],
//           child: Icon(
//             Icons.build,
//             color: Colors.white,
//             size: size.iScreen(2.8),
//           ),
//         ),
//           ],
//         ),
//         SizedBox(height: size.iScreen(1.0)),
//         Container(
//           width:  size.wScreen(100.0),
//           child: Text(
//             'Estimado usuario,',
//             style: GoogleFonts.roboto(
//               fontSize: size.iScreen(1.8),
//               color: Colors.black,
//               fontWeight: FontWeight.normal,
//             ),
//           ),
//         ),
//         SizedBox(height: size.iScreen(1.0)),
//         Text(
//           'Nuestro sistema estará en mantenimiento el día de mañana a partir de las 18:00 hasta las 00:00. Durante este periodo, es posible que nuestros servicios no estén disponibles. Agradecemos su comprensión y paciencia.',
//           style: GoogleFonts.roboto(
//             fontSize: size.iScreen(1.8),
//             color: Colors.black,
//             fontWeight: FontWeight.normal,
//           ),
//           textAlign: TextAlign.justify,
//         ),
//          SizedBox(height: size.iScreen(1.0)),
//         Text(
//           'Atentamente,',
//           style: GoogleFonts.roboto(
//             fontSize:  size.iScreen(1.6),
//             color: Colors.black,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         Text(
//           'El equipo de soporte técnico',
//           style: GoogleFonts.roboto(
//             fontSize: size.iScreen(1.6),
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     ),
//    actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

  void _showMaintenanceAlert(BuildContext context, Map<String, dynamic> data) {
    final size = Responsive.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 16,
            child: Container(
              padding: EdgeInsets.all(size.iScreen(2.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.iScreen(1.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              'Notificación de ${data['tipo']}',
                              style: GoogleFonts.roboto(
                                fontSize: size.iScreen(1.8),
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          CircleAvatar(
                            radius: size.iScreen(2.5),
                            backgroundColor: Colors.yellow[700],
                            child: Icon(
                              Icons.build,
                              color: Colors.white,
                              size: size.iScreen(2.8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.iScreen(1.0)),
                      SizedBox(
                        width: size.wScreen(100.0),
                        child: Text(
                          'Estimado usuario,',
                          style: GoogleFonts.roboto(
                            fontSize: size.iScreen(1.8),
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: size.iScreen(1.0)),
                      Text(
                        'Nuestro sistema estará en ${data['detalle']}. Durante este periodo, es posible que nuestros servicios no estén disponibles. Agradecemos su comprensión y paciencia.',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.8),
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: size.iScreen(1.0)),
                      Text(
                        'Atentamente,',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.6),
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: size.iScreen(1.8),
                      ),
                      Text(
                        'El equipo de soporte técnico',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.6),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.iScreen(0.5),
                      ),
                      Text(
                        'NeitorSafe',
                        style: GoogleFonts.roboto(
                          fontSize: size.iScreen(1.6),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 24.0),
                  TextButton(
                    child: Text('OK',
                        style: TextStyle(fontSize: size.iScreen(1.8))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }

//**********************//

  Future<void> _modalReportes(
      BuildContext context, Responsive size, Session? user) {
    final themeValue = context.read<ThemeApp>();
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'INFORMACIÓN',
          style: GoogleFonts.roboto(
              fontSize: size.iScreen(2.0),
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                //====================//

                final user0 = context.read<HomeController>();
                Navigator.pop(context);

                user0.onChangeUser('${user0.getUsuarioInfo!.usuario}');

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const UpdatePassUser())));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mi Perfil',
                    style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.2),
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    width: size.iScreen(1.0),
                  ),
                  Icon(
                    Icons.assignment_ind_rounded,
                    color: themeValue.secondaryColor,
                    size: size.iScreen(4.0),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                //====================//

                final user0 = context.read<HomeController>();
                Navigator.pop(context);
                // homeController.buscaRolesPago();
                // user.id

                //====================//
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ViewsPDFs(
                //           infoPdf:
                //               // 'https://backsigeop.neitor.com/api/reportes/informeindividual?infId=${widget.informe['infId']}&rucempresa=${widget.user!.rucempresa}&usuario=${widget.user!.usuario}',
                //               // 'https://backsigeop.neitor.com/api/reportes/rolpagoindividual?rolpId=${rol['rolpId']}&rucempresa=${rol['rolpEmpresa']}',
                //               'https://backsigeop.neitor.com/api/reportes/personaPuestoServicio?perId=${user!.id}&rucempresa=${user.rucempresa}&nombre=${user.nombre}&usuario=${user.usuario}',
                //           labelPdf: 'Horario.pdf')),
                // );

                // _modalSeleccionaMes(
                //   context,
                //   size,
                // );

                user0.seleccionaMeses(context);
                _modalMeses(context, size, user0);

                //         // //====================//
                //  // //====================//
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mi Horario',
                    style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.2),
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    width: size.iScreen(1.0),
                  ),
                  Icon(
                    Icons.pending_actions_outlined,
                    color: Colors.green,
                    size: size.iScreen(4.0),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                //====================//
                final homeController = context.read<HomeController>();
                Navigator.pop(context);
                homeController.buscaRolesPago();
                //  // //====================//

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ListaRolPagos(
                              user: user,
                            )))
                    // HomePageMultiSelect()
                    );
                //  // //====================//
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mis Roles',
                    style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.2),
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    width: size.iScreen(1.0),
                  ),
                  Icon(
                    Icons.summarize_outlined,
                    color: Colors.black,
                    size: size.iScreen(4.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//====== MUESTRA MODAL DE MOTIVO =======//
  void _modalSeleccionaMes(
    BuildContext context,
    size,
  ) {
    final user = context.read<HomeController>();
    final ctrlMulta = context.read<MultasGuardiasContrtoller>();
    final data = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SELECCIONE MES',
                          style: GoogleFonts.roboto(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          )),
                      IconButton(
                          splashRadius: size.iScreen(3.0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: size.iScreen(3.5),
                          )),
                    ],
                  ),
                  SizedBox(
                    width: size.wScreen(100.0),
                    height: size.hScreen(30.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            ctrlMulta.setLabelMes(data[index]);
                            Navigator.pop(context);
                            //====================//
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewsPDFs(
                                      infoPdf:
                                          //  'https://backsigeop.neitor.com/api/reportes/personaPuestoServicio?perId=309&rucempresa=IIIVIP&nombre=ADMINISTRADOR&usuario=admin&mes=4',

                                          'https://backsafe.neitor.com/api/reportes/personaPuestoServicio?perId=${user.getUsuarioInfo!.id}&rucempresa=${user.getUsuarioInfo!.rucempresa}&nombre=${user.getUsuarioInfo!.nombre}&usuario=${user.getUsuarioInfo!.usuario}&mes=${ctrlMulta.numeroMes}',
                                      labelPdf: 'Horario.pdf')),
                            );
                          },
                          child: Container(
                            color: Colors.grey[100],
                            margin: EdgeInsets.symmetric(
                                vertical: size.iScreen(0.3)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(1.0),
                                vertical: size.iScreen(1.0)),
                            child: Text(
                              data[index],
                              style: GoogleFonts.roboto(
                                fontSize: size.iScreen(1.8),
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
//======================== MODAL PUESTOS =======================//

  Future<String?> _modalMeses(
      BuildContext context, Responsive size, HomeController controller) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: const Center(child: Text('Seleccione el Mes')),
        content: SizedBox(
            height: size.hScreen(20.0),
            width: double.maxFinite,
            child: prov.Consumer<HomeController>(
              builder: (_, value, __) {
                return ListView.builder(
                  itemCount: value.getListaMeses.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (value.getListaMeses.isEmpty) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                    }
                    final mes = value.getListaMeses[index];

                    return GestureDetector(
                      onTap: () {
                        final ctrlMulta =
                            context.read<MultasGuardiasContrtoller>();
                        // ctrlMulta.setLabelMes(value.getListaMeses[index]['mes']);

                        // print(' EL MES PDF: https://backsafe.neitor.com/api/reportes/personaPuestoServicio?perId=${value.getUsuarioInfo!.id}&rucempresa=${value.getUsuarioInfo!.rucempresa}&nombre=${value.getUsuarioInfo!.nombre}&usuario=${value.getUsuarioInfo!.usuario}&mes=${value.getListaMeses[index]}');
                        Navigator.pop(context);
                        // //====================//
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewsPDFs(
                                  infoPdf:
                                      //  'https://backsigeop.neitor.com/api/reportes/personaPuestoServicio?perId=309&rucempresa=IIIVIP&nombre=ADMINISTRADOR&usuario=admin&mes=4',

                                      'https://backsafe.neitor.com/api/reportes/personaPuestoServicio?perId=${value.getUsuarioInfo!.id}&rucempresa=${value.getUsuarioInfo!.rucempresa}&nombre=${value.getUsuarioInfo!.nombre}&usuario=${value.getUsuarioInfo!.usuario}&mes=$mes',
                                  labelPdf: 'Horario.pdf')),
                        );
                      },
                      child: Container(
                          width: size.wScreen(100),
                          color: Colors.grey.shade200,
                          margin:
                              EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                          padding: EdgeInsets.symmetric(
                              vertical: size.iScreen(1.0),
                              horizontal: size.iScreen(0.5)),
                          child: Text(value.getMonthName(mes),
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.5),
                                fontWeight: FontWeight.normal,
                                // color: Colors.grey
                              ))),
                    );

                    // ListTile(
                    //   onTap: () {
                    //     // value.setLabelPuestosCliente(_mes);

                    //     // value.setTipoAlimento(e['nombre']);

                    //     Navigator.pop(context);
                    //   },
                    //   title: Text('${_mes['mes']}'),
                    // );
                  },
                );
              },
            )),
      ),
    );
  }

  Future<void> _modalShare(
    BuildContext context,
    Responsive size,
  ) {
    final themeValue = context.read<ThemeApp>();
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'Compatir',
          style: GoogleFonts.roboto(
              fontSize: size.iScreen(2.0),
              color: themeValue.primaryColor,
              fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _onShare(context, 'https://acortar.link/kTJt3V');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Android',
                    style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.2),
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: size.iScreen(1.0),
                  ),
                  Icon(
                    Icons.android_outlined,
                    color: Colors.green,
                    size: size.iScreen(4.0),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // _onShare(context, 'https://acortar.link/SWMt9k');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'IOS',
                    style: GoogleFonts.roboto(
                        fontSize: size.iScreen(2.2),
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: size.iScreen(1.0),
                  ),
                  Icon(
                    Icons.apple_outlined,
                    color: Colors.black,
                    size: size.iScreen(4.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShare(BuildContext context, String urlApp) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(urlApp,
        subject: 'NeitorSafe App',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}

class _ItemsSocials extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function? onTap;

  const _ItemsSocials({
    required this.size,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.iScreen(1.0), vertical: size.iScreen(2.0)),
          padding: EdgeInsets.all(size.iScreen(1.2)),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15.0)),
          child: Icon(
            icon,
            size: size.iScreen(3.0),
            color: Colors.white,
          )),
      onTap: () => onTap,
    );
  }
}
