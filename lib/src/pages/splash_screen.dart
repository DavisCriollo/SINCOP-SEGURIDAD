import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nseguridad/src/controllers/botonTurno_controller.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';

import 'package:nseguridad/src/pages/login.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:nseguridad/src/api/authentication_client.dart';
import 'package:nseguridad/src/controllers/home_controller.dart';
import 'package:nseguridad/src/controllers/login_controller.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/pages/home.dart';
// import 'package:nseguridad/src/pages/login_page.dart';
// import 'package:nseguridad/src/pages/update_app_page.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/utils/theme_app.dart';
import 'package:upgrader/upgrader.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controllerLogin = LoginController();
  final controllerHome = HomeController();
  final _checker = AppVersionChecker();

  @override
  void initState() {
    super.initState();
// VERIFICO SI EL CONTEXTO  ESTA INICIALIZADO//
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //  checkVersion();
      _chechLogin();
    });
  }

  _chechLogin() async {
    final controllerHome = Provider.of<HomeController>(context, listen: false);
    final ctrlBoton = Provider.of<BotonTurnoController>(context, listen: false);
    //  final notificationProvider = NotificationProvider();
    final Session? session = await Auth.instance.getSession();
    // controllerHome.setSesionUser(session);
    final String? validaTurno = await Auth.instance.getTurnoSession();
    // print('EL ROL : ${session!.rol}');
    // final String? tokenFCM = await Auth.instance.getTokenFireBase();

    if (session != null) {
      controllerHome.setUsuarioInfo(session);
      final status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        //   // print('============== SI TIENE PERMISOS');
        final isGPSActive = await controllerHome.checkGPSStatus();
//  print('isGPSActive ================+> : ${isGPSActive}');
        if (isGPSActive == true) {
          await controllerHome.getCurrentPosition();

          if (controllerHome.getCoords != '') {
            if (session.rol!.contains('ADMIN')) {
              ctrlBoton.setTurnoBTN(true);
            } else {
              if (session.rol!.contains('GUARDIA') ||
                  session.rol!.contains('SUPERVISOR') ||
                  session.rol!.contains('ADMINISTRACION')) {
                controllerHome.getValidaTurnoServer(context);
                controllerHome.buscaNotificacionesPush('');
                controllerHome.buscaNotificacionesPush2('');
                // print('EL TURNO SI EXISTE : ${_isTurned}');
                //      controllerHome.setValidaBtnTurno((validaTurno != null) ? true : false);

                //   if (controllerHome.getBotonTurno) {
                //     controllerHome.setBotonTurno(true); //P OR DEFAUL ES TRUE
                //   } else {
                //     controllerHome.setBotonTurno(false);
                //   }
              }
            }

            final String primaryColorStr =
                session.colorPrimario.toString().substring(1);
            final String secondaryColorStr =
                session.colorSecundario.toString().substring(1);

            final Color primaryColor =
                Color(int.parse(primaryColorStr, radix: 16)).withOpacity(1.0);
            final Color secondaryColor =
                Color(int.parse(secondaryColorStr, radix: 16)).withOpacity(1.0);

            Provider.of<ThemeApp>(context, listen: false)
                .updateTheme(primaryColor, secondaryColor);

// if (mounted) {
//   Navigator.of(context).pushAndRemoveUntil(
//     MaterialPageRoute(
//       builder: (context) => Home(
//         validaTurno: validaTurno,
//         tipo: session.rol,
//         user: session,
//         ubicacionGPS: controllerHome.getCoords,
//       ),
//     ),
//     (Route<dynamic> route) => false,
//   );
// }
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Home(
                        validaTurno: validaTurno,
                        tipo: session.rol,
                        user: session,
                        ubicacionGPS: controllerHome.getCoords)),
                (Route<dynamic> route) => false);
            ModalRoute.withName('/');
          }
        } else {
          Navigator.pushNamed(context, 'gpsActive');
        }
      } else {
        // Navigator.pushNamed(context, 'gps');
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return Scaffold(
      body: SizedBox(
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(
                height: size.iScreen(2.0),
              ),
              const Text('Procesando.... '),
            ],
          ),
        ),
      ),
    );
  }
}
